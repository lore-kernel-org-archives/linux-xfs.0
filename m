Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3IHrIsB220456 for <xfs@oss.sgi.com>; Wed, 18 Apr 2012 12:53:18 -0500
Message-ID: <4F8EFF8A.80305@sgi.com>
Date: Wed, 18 Apr 2012 12:53:14 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/10] xfs: implement freezing by emptying the AIL
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164644.830680325@bombadil.infradead.org>
	<4F8C22D4.3040908@sgi.com> <20120416235432.GZ6734@dastard>
	<20120417042023.GG6734@dastard> <20120417082633.GH6734@dastard>
In-Reply-To: <20120417082633.GH6734@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 04/17/12 03:26, Dave Chinner wrote:

> Yeah, it's pretty clear what is happening here. We don't have
> freeze protection against EOF zeroing operations. At least
> xfs_setattr_size() and xfs_change_file_space() fail to check for
> freeze, and that is initially what I though was causing this problem.
>
> However, adding freeze checks into the relevant paths didn't make
> the hangs go away, so there's more to it than that. Basically, we've
> been getting races between checking for freeze, the dirtying of the
> pages and the flusher thread syncing out the dirty data. i.e.:
>
> Thread 1		Thread 2		freeze		flusher thread
> write inode A
> check for freeze
> 					grab s_umount
> 					SB_FREEZE_WRITE
> 					writeback_inodes_sb()
> 								iterate dirty inodes
> 								inode A not in flush
> 					sync_inodes_sb()
> 								iterate dirty inodes
> 								inode A not in flush
> dirty pages
> mark inode A dirty
> write inode A done.
> 					SB_FREEZE_TRANS
> 					drop s_umount
> 					freeze done
> 			sync
> 			grab s_umount
> 								iterate dirty inodes
> 								Flush dirty inode A
>
>
> Before we added the transactional inode size updates, this race
> simply went unnoticed because nothing caused the flusher thread to
> block. All the problems I see are due to overwrites of allocated
> space - if there was real allocation then the delalloc conversion
> would have always hung. Now we see that when we need to extend the
> file size when writing, we ahve to allocate a transaction and hence
> the flusher thread now hangs.
>
> While I can "fix" the xfs_setattr_size() and xfs_change_file_space()
> triggers, they don't close the above race condition, so this problem
> is essentially unfixable in XFS. The only reason we have not tripped
> over it before is that the flusher thread didn't hang waiting for a
> transaction reservation when the race was hit.
>
> So why didn't this happen before Christoph's patch set? That's
> something I can't explain. Oh, wait, yes I can - 068 hangs even
> without this patch of Christoph's. Actually, looking at my xfstests
> logs, I can trace the start of the failures back to mid march, and
> that coincided with an update to the xfstests installed on my test
> boxes. Which coincides with when my machines first saw this change:
>
> commit 281627df3eb55e1b729b9bb06fff5ff112929646
> Author: Christoph Hellwig<hch@infradead.org>
> Date:   Tue Mar 13 08:41:05 2012 +0000
>
>      xfs: log file size updates at I/O completion time
>
> That confirms my analysis above - the problem is being exposed by new
> code in the writeback path that does transaction allocation where it
> didn't used to.
>
> Clearly the problem is not really the new code in Christoph's
> patches - it's an existing freeze problem that has previously
> resulted in data writes occuring after a freeze has completed (of
> which we have had rare complaints about). That sounds pretty dire,
> except for one thing: Jan Kara's patch set that fixes all these
> freeze problems:
>
> https://lkml.org/lkml/2012/4/16/356
>
> And now that I've run some testing with Jan's patch series, along
> with Christoph's and mine (75-odd patches;), a couple of my test
> VMs have been running test 068 in a tight loop for about half an
> hour without a hang, so I'd consider this problem fixed by Jan's
> freeze fixes given I could reliably hang it in 2-3 minutes before
> adding Jan's patch set to my stack.
>
> So the fix for this problem is getting Jan's patch set into the
> kernel at the same time we get the inode size logging changes into
> the kernel. What do people think about that for a plan?
>
> Cheers,
>
> Dave.
> -- Dave Chinner david@fromorbit.com

Just a heads up, Jan's freeze patch did clear up the test 086 hang on my 
test box as well, but the 106 (quota test) hang on one of the mounts is 
still there.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
