Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 462DA7F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 17:27:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 15F94304032
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 15:27:25 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	1bB7QL6WoyrOYNKc for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 15:27:23 -0700 (PDT)
Date: Tue, 25 Aug 2015 08:27:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824222720.GD714@dastard>
References: <20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150820061224.GG17933@dhcp-13-216.nay.redhat.com>
	<20150820143626.GI17933@dhcp-13-216.nay.redhat.com>
	<20150820143735.GJ17933@dhcp-13-216.nay.redhat.com>
	<20150820165537.GA2044@mtj.duckdns.org>
	<20150820230451.GT714@dastard>
	<20150824181038.GA28944@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824181038.GA28944@mtj.duckdns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

On Mon, Aug 24, 2015 at 02:10:38PM -0400, Tejun Heo wrote:
> Hello, Dave.
> 
> On Fri, Aug 21, 2015 at 09:04:51AM +1000, Dave Chinner wrote:
> > > Maybe I'm misunderstanding the code but all xfs_writepage() calls are
> > > from unbound workqueues - the writeback workers - while
> > > xfs_setfilesize() are from bound workqueues, so I wondered why that
> > > was and looked at the code and the setsize functions are run off of a
> > > separate work item which is queued from the end_bio callback and I
> > > can't tell who would be waiting for them.  Dave, what am I missing?
> > 
> > xfs_setfilesize runs transactions, so it can't be run from IO
> > completion context as it needs to block (i.e. on log space or inode
> > locks). It also can't block log IO completion, nor metadata Io
> > completion, as only log IO completion can free log space, and the
> > inode lock might be waiting on metadata buffer IO completion (e.g.
> > during delayed allocation). Hence we have multiple IO completion
> > workqueues to keep these things separated and deadlock free. i.e.
> > they all get punted to a workqueue where they are then processed in
> > a context that can block safely.
> 
> I'm still a bit confused.  What prevents the following from happening?
> 
> 1. io completion of last dirty page of an inode and work item for
>    xfs_setfilesize() is queued.
> 
> 2. inode removed from dirty list.

The inode has already been removed from the dirty list - that
happens at inode writeback submission time, not IO completion.

> 3. __sync_filesystem() invokes sync_inodes_sb().  There are no dirty
>    pages, so it finishes.

There are no dirty pages, but the pages aren't clean, either. i.e
they are still under writeback.  Hence we need to invoke
wait_inodes_sb() to wait for writeback on all pages to complete
before returning.

> 4. xfs_fs_sync_fs() is called which calls _xfs_log_force() but the
>    work item from #1 hasn't run yet, so the size update isn't written
>    out.

The bug here is that wait_inodes_sb() has not been run, therefore
->syncfs is being run before IO completions have been processed and
pages marked clean.

> 5. Crash.
> 
> Is it that _xfs_log_force() waits for the setfilesize transaction
> created during writepage?

No, it's wait_inodes_sb() that does the waiting for data IO
completion for sync.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
