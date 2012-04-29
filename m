Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3T0lPH7066454 for <xfs@oss.sgi.com>; Sat, 28 Apr 2012 19:47:25 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	XVTClsphB0kXAaML for <xfs@oss.sgi.com>;
	Sat, 28 Apr 2012 17:47:08 -0700 (PDT)
Date: Sun, 29 Apr 2012 10:14:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/37] xfs: current 3.4 patch queue
Message-ID: <20120429001439.GN9541@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<20120428021546.GI16881@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120428021546.GI16881@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 27, 2012 at 09:15:46PM -0500, Ben Myers wrote:
> Dave,
> 
> I want to pull this in and have been testing toward that end.  With Jan's
> patches this seems to be working well.  I've had to disable a couple asserts:
> 
> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c
> +++ xfs/fs/xfs/xfs_bmap.c
> @@ -5620,8 +5620,8 @@ xfs_getbmap(
>                                 XFS_FSB_TO_BB(mp, map[i].br_blockcount);
>                         out[cur_ext].bmv_unused1 = 0;
>                         out[cur_ext].bmv_unused2 = 0;
> -                       ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
> -                             (map[i].br_startblock != DELAYSTARTBLOCK));
> +//                     ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
> +//                           (map[i].br_startblock != DELAYSTARTBLOCK));
>                          if (map[i].br_startblock == HOLESTARTBLOCK &&
>                             whichfork == XFS_ATTR_FORK) {
>                                 /* came to the end of attribute fork */
> 
> Index: xfs/fs/xfs/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_super.c
> +++ xfs/fs/xfs/xfs_super.c
> @@ -822,7 +822,7 @@ xfs_fs_destroy_inode(
>         if (is_bad_inode(inode))
>                 goto out_reclaim;
> 
> -       ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
> +//     ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);

That's the two problems my latest patch series help reduce. I think
they solve this second one, and I now understand the remaining case
I'm tripping over the first one, and that is a case of modifying the
assert to avoid failure.

FYI, that last case is due to specualtive delalloc beyond EOF, and
when allocating the range during writeback being able to allocate
part of what is beyond EOF but not all of it due to limited
available free space sizes. Hence data flushes will never be able to
convert that remaining delalloc range beyond EOF, and so getbmap
will assert fail above on that.


> That first one has been hanging around for awhile.  It isn't due to this patch
> set.  The second I'm not so sure about.  Looks like you're addressing these in a
> different thread.

Same problem, different failure modes.

> I'm also testing this patch set them without Jan's work, since I'm not sure when
> it will be pulled in.  Here's the latest:
> 
> case login: [ 2934.077472] BUG: unable to handle kernel paging request at ffffc900036a8010
> [ 2934.078452] IP: [<ffffffffa009a790>] xlog_get_lowest_lsn+0x30/0x80 [xfs]
> [ 2934.078452] PGD 12b029067 PUD 12b02a067 PMD 378f5067 PTE 0
> [ 2934.078452] Oops: 0000 [#1] SMP
> [ 2934.078452] CPU 1
> [ 2934.078452] Modules linked in: xfs(O) exportfs e1000e [last unloaded: xfs]
> [ 2934.078452]
> [ 2934.078452] Pid: 9031, comm: kworker/1:15 Tainted: G           O 3.4.0-rc2+ #3 SGI.COM AltixXE310/X7DGT-INF

What out-of-tree module do you have loaded that tainted the kernel?
The ethernet driver?


> [ 2934.078452] RIP: 0010:[<ffffffffa009a790>]  [<ffffffffa009a790>] xlog_get_lowest_lsn+0x30/0x80 [xfs]
.....
> [ 2934.078452] Call Trace:
> [ 2934.078452]  [<ffffffffa009b006>] xlog_state_do_callback+0xa6/0x390 [xfs]
> [ 2934.078452]  [<ffffffffa009b3d7>] xlog_state_done_syncing+0xe7/0x110 [xfs]
> [ 2934.078452]  [<ffffffffa009bbde>] xlog_iodone+0x7e/0x100 [xfs]
> [ 2934.078452]  [<ffffffffa00372d1>] xfs_buf_iodone_work+0x21/0x50 [xfs]
> [ 2934.078452]  [<ffffffff81051498>] process_one_work+0x158/0x440
> [ 2934.078452]  [<ffffffffa00372b0>] ? xfs_bioerror_relse+0x80/0x80 [xfs]
> [ 2934.078452]  [<ffffffff8105428b>] worker_thread+0x17b/0x410
> [ 2934.078452]  [<ffffffff81054110>] ? manage_workers+0x200/0x200
> [ 2934.078452]  [<ffffffff81058bce>] kthread+0x9e/0xb0
> [ 2934.078452]  [<ffffffff816f8014>] kernel_thread_helper+0x4/0x10
> [ 2934.078452]  [<ffffffff81058b30>] ? kthread_freezable_should_stop+0x70/0x70

Only way this can happen is if the log has already been torn down
before an IO completion for a log write occurs. Not sure how that
can happen, but we do do some log io (write the unmount record) on
unmount and then tear down the log without having first flsuhed the
buftarg....

> Looks like I've seen that one before this patch series:
> http://oss.sgi.com/pipermail/xfs/2012-March/017909.html

Yeah, i don't think it is related.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
