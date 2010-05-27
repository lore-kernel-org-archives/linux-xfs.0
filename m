Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4R6iCI9117427 for <xfs@oss.sgi.com>; Thu, 27 May 2010 01:44:12 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 583A61D5224B
	for <xfs@oss.sgi.com>; Wed, 26 May 2010 23:46:35 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id 5loMaOtEl9Gmq9Ta for <xfs@oss.sgi.com>;
	Wed, 26 May 2010 23:46:35 -0700 (PDT)
Date: Thu, 27 May 2010 16:46:31 +1000
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 3/5 v2] superblock: introduce per-sb cache shrinker
	infrastructure
Message-ID: <20100527064631.GK22536@laptop>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
	<1274777588-21494-4-git-send-email-david@fromorbit.com>
	<20100526164116.GD22536@laptop> <20100526231214.GB1395@dastard>
	<20100527015335.GD1395@dastard>
	<20100527040120.GX31073@ZenIV.linux.org.uk>
	<20100527061751.GK12087@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100527061751.GK12087@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com, Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 04:17:51PM +1000, Dave Chinner wrote:
> On Thu, May 27, 2010 at 05:01:20AM +0100, Al Viro wrote:
> > Um...  Maybe I'm dumb, but what's wrong with doing unregistration from
> > deactivate_locked_super(), right after the call of ->kill_sb()?  At that
> > point ->s_umount is already dropped, so we won't deadlock at all.
> > Shrinker rwsem will make sure that all shrinkers-in-progress will run
> > to completion, so we won't get a superblock freed under prune_super().
> > I don't particulary mind down_try_read() in prune_super(), but why not
> > make life obviously safer?
> > 
> > Am I missing something here?
> 
> I was worried about memory allocation in the ->kill_sb path
> deadlocking on the s_umount lock if it enters reclaim. e.g.  XFS
> inodes can still be dirty even after the VFS has disposed of them,
> and writing them back can require page cache allocation for the
> backing buffers. If allocation recurses back into the shrinker, we
> can deadlock on the s_umount lock.  This doesn't seem like an XFS
> specific problem, so I used a trylock to avoid that whole class of
> problems (same way the current shrinkers do).

If GFP_FS is set, we wouldn't touch the locks. It is a concern
though, if __GFP_FS allocations were previously permitted under
the exclusive lock.

 
> >From there, we can unregister the shrinker before calling ->kill_sb
> as per above. That, in turn, means that the unmount
> invalidate_inodes() vs shrinker race goes away and the iprune_sem is
> not needed in the new prune_icache_sb() function.  I'm pretty sure
> that I can now remove the iprune_sem, but I haven't written the
> patch to do that yet.

I do really like that aspect of your patch. It's nice to have the
shrinker always only operating against active supers. So I would
be in favour of your current scheme.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
