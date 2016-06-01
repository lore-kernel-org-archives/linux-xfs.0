Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E423F7CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 08:18:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B7AC78F8049
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 06:18:06 -0700 (PDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com
	[74.125.82.67]) by cuda.sgi.com with ESMTP id LrEcJqhzN08rb2gW
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Jun 2016 06:18:01 -0700 (PDT)
Received: by mail-wm0-f67.google.com with SMTP id q62so6718438wmg.3
	for <xfs@oss.sgi.com>; Wed, 01 Jun 2016 06:18:01 -0700 (PDT)
Date: Wed, 1 Jun 2016 15:17:58 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160601131758.GO26601@dhcp22.suse.cz>
References: <20160512080321.GA18496@dastard>
	<20160513160341.GW20141@dhcp22.suse.cz>
	<20160516104130.GK3193@twins.programming.kicks-ass.net>
	<20160516130519.GJ23146@dhcp22.suse.cz>
	<20160516132541.GP3193@twins.programming.kicks-ass.net>
	<20160516231056.GE18496@dastard>
	<20160517144912.GZ3193@twins.programming.kicks-ass.net>
	<20160517223549.GV26977@dastard>
	<20160519081146.GS3193@twins.programming.kicks-ass.net>
	<20160520001714.GC26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160520001714.GC26977@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Peter Zijlstra <peterz@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, Qu Wenruo <quwenruo@cn.fujitsu.com>, xfs@oss.sgi.com, Ingo Molnar <mingo@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

Thanks Dave for your detailed explanation again! Peter do you have any
other idea how to deal with these situations other than opt out from
lockdep reclaim machinery?

If not I would rather go with an annotation than a gfp flag to be honest
but if you absolutely hate that approach then I will try to check wheter
a CONFIG_LOCKDEP GFP_FOO doesn't break something else. Otherwise I would
steal the description from Dave's email and repost my patch.

I plan to repost my scope gfp patches in few days and it would be good
to have some mechanism to drop those GFP_NOFS to paper over lockdep
false positives for that.

[keeping Dave's explanation for reference]

On Fri 20-05-16 10:17:14, Dave Chinner wrote:
> On Thu, May 19, 2016 at 10:11:46AM +0200, Peter Zijlstra wrote:
> > On Wed, May 18, 2016 at 08:35:49AM +1000, Dave Chinner wrote:
[...]
> > > There's a maze of dark, grue-filled twisty passages here...
> > 
> > OK; I might need a bit more again.
> > 
> > So now the code does something like:
> > 
> > 	down_read(&i_lock);		-- lockdep marks lock as held
> > 	kmalloc(GFP_KERNEL);		-- lockdep marks held locks as ENABLED_RECLAIM_FS
> > 	  --> reclaim()
> > 	     down_read_trylock(&i_lock); -- lockdep does _NOT_ mark as USED_IN_RECLAIM_FS
> > 
> > Right?
> 
> In the path that can deadlock the log, yes. It's actually way more
> complex than the above, because the down_read_trylock(&i_lock) that
> matters is run in a completely separate, async kthread that
> xfs_trans_reserve() will block waiting for.
> 
> process context				xfsaild kthread(*)
> ---------------				------------------
> down_read(&i_lock);		-- lockdep marks lock as held
> kmalloc(GFP_KERNEL);		-- lockdep marks held locks as ENABLED_RECLAIM_FS
>   --> reclaim()
>      xfs_trans_reserve()
>      ....
> 	  xfs_trans_push_ail()	---- called if no space in the log to kick the xfsaild into action
> 	  ....
>        xlog_grant_head_wait()	---- blocks waiting for log space
>        .....
> 
> 					xfsaild_push()   ----- iterates AIL
> 					  grabs log item
> 					    lock log item
> 	>>>>>>>>>>>>>>>>>>>>>		      down_read_trylock(&i_lock);
> 					      format item into buffer
> 					      add to dirty buffer list
> 					  ....
> 					  submit dirty buffer list for IO
> 					    buffer IO started
> 					.....
> 					<async IO completion context>
> 					buffer callbacks
> 					  mark inode clean
> 					  remove inode from AIL
> 					  move tail of log forwards
> 					    wake grant head waiters
> 	<woken by log tail moving>
> 	<log space available>
> 	transaction reservation granted
>      .....
>      down_write(some other inode ilock)
>      <modify some other inode>
>      xfs_trans_commit
>      .....
> 
> (*) xfsaild runs with PF_MEMALLOC context.
> 
> The problem is that if the ilock is held exclusively at GFP_KERNEL
> time, the xfsaild cannot lock the inode to flush it, so if that
> inode pins the tail of the log then we can't make space available
> for xfs_trans_reserve and there is the deadlock.
> 
> Once xfs_trans_reserve completes, however, we'll take the ilock on
> *some other inode*, and that's where the "it can't be the inode we
> currently hold locked because we have references to it" and
> henceit's safe to have a pattern like:
> 
> down_read(&i_lock);		-- lockdep marks lock as held
> kmalloc(GFP_KERNEL);		-- lockdep marks held locks as ENABLED_RECLAIM_FS
>   --> reclaim()
>     down_write(&ilock)
> 
> because the lock within reclaim context is completely unrelated to
> the lock we already hold.
> 
> Lockdep can't possibly know about this because the deadlock involves
> locking contexts that *aren't doing anything wrong within their own
> contexts*. It's only when you add the dependency of log space
> reservation requirements needed to make forwards progress that
> there's then an issue with locking and reclaim.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
