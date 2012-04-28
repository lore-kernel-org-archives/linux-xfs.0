Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3S2D1dS238709 for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 21:13:01 -0500
Date: Fri, 27 Apr 2012 21:15:46 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/37] xfs: current 3.4 patch queue
Message-ID: <20120428021546.GI16881@sgi.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

Dave,

I want to pull this in and have been testing toward that end.  With Jan's
patches this seems to be working well.  I've had to disable a couple asserts:

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c
+++ xfs/fs/xfs/xfs_bmap.c
@@ -5620,8 +5620,8 @@ xfs_getbmap(
                                XFS_FSB_TO_BB(mp, map[i].br_blockcount);
                        out[cur_ext].bmv_unused1 = 0;
                        out[cur_ext].bmv_unused2 = 0;
-                       ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
-                             (map[i].br_startblock != DELAYSTARTBLOCK));
+//                     ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
+//                           (map[i].br_startblock != DELAYSTARTBLOCK));
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
                            whichfork == XFS_ATTR_FORK) {
                                /* came to the end of attribute fork */

Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c
+++ xfs/fs/xfs/xfs_super.c
@@ -822,7 +822,7 @@ xfs_fs_destroy_inode(
        if (is_bad_inode(inode))
                goto out_reclaim;

-       ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
+//     ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);

        /*
         * We should never get here with one of the reclaim flags already set.

That first one has been hanging around for awhile.  It isn't due to this patch
set.  The second I'm not so sure about.  Looks like you're addressing these in a
different thread.

I'm also testing this patch set them without Jan's work, since I'm not sure when
it will be pulled in.  Here's the latest:

case login: [ 2934.077472] BUG: unable to handle kernel paging request at ffffc900036a8010
[ 2934.078452] IP: [<ffffffffa009a790>] xlog_get_lowest_lsn+0x30/0x80 [xfs]
[ 2934.078452] PGD 12b029067 PUD 12b02a067 PMD 378f5067 PTE 0
[ 2934.078452] Oops: 0000 [#1] SMP
[ 2934.078452] CPU 1
[ 2934.078452] Modules linked in: xfs(O) exportfs e1000e [last unloaded: xfs]
[ 2934.078452]
[ 2934.078452] Pid: 9031, comm: kworker/1:15 Tainted: G           O 3.4.0-rc2+ #3 SGI.COM AltixXE310/X7DGT-INF
[ 2934.078452] RIP: 0010:[<ffffffffa009a790>]  [<ffffffffa009a790>] xlog_get_lowest_lsn+0x30/0x80 [xfs]
[ 2934.078452] RSP: 0018:ffff880078281d10  EFLAGS: 00010246
[ 2934.078452] RAX: ffffc900036a8000 RBX: ffff8800378c7e00 RCX: ffff8800378c7e00
[ 2934.078452] RDX: ffff8800378426c0 RSI: 0000000000000000 RDI: 0000000000000000
[ 2934.078452] RBP: ffff880078281d10 R08: ffff8800378c7d00 R09: 0000000000000000
[ 2934.078452] R10: 0000000000000400 R11: 0000000000000001 R12: ffff880037842600
[ 2934.078452] R13: ffff8800378c7e00 R14: 0000000000000000 R15: ffff88012fc99205
[ 2934.078452] FS:  0000000000000000(0000) GS:ffff88012fc80000(0000) knlGS:0000000000000000
[ 2934.078452] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2934.078452] CR2: ffffc900036a8010 CR3: 0000000037870000 CR4: 00000000000007e0
[ 2934.078452] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2934.078452] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2934.078452] Process kworker/1:15 (pid: 9031, threadinfo ffff880078280000, task ffff880098f7a490)
[ 2934.078452] Stack:
[ 2934.078452]  ffff880078281d90 ffffffffa009b006 0000000300000000 ffff8800378c7e00
[ 2934.078452]  ffff880037842600 ffff8800378c7d00 0000000000000286 0000000000000000
[ 2934.078452]  0000000100000000 ffff8800378426a8 ffff8800378426c0 ffff8800378c7e00
[ 2934.078452] Call Trace:
[ 2934.078452]  [<ffffffffa009b006>] xlog_state_do_callback+0xa6/0x390 [xfs]
[ 2934.078452]  [<ffffffffa009b3d7>] xlog_state_done_syncing+0xe7/0x110 [xfs]
[ 2934.078452]  [<ffffffffa009bbde>] xlog_iodone+0x7e/0x100 [xfs]
[ 2934.078452]  [<ffffffffa00372d1>] xfs_buf_iodone_work+0x21/0x50 [xfs]
[ 2934.078452]  [<ffffffff81051498>] process_one_work+0x158/0x440
[ 2934.078452]  [<ffffffffa00372b0>] ? xfs_bioerror_relse+0x80/0x80 [xfs]
[ 2934.078452]  [<ffffffff8105428b>] worker_thread+0x17b/0x410
[ 2934.078452]  [<ffffffff81054110>] ? manage_workers+0x200/0x200
[ 2934.078452]  [<ffffffff81058bce>] kthread+0x9e/0xb0
[ 2934.078452]  [<ffffffff816f8014>] kernel_thread_helper+0x4/0x10
[ 2934.078452]  [<ffffffff81058b30>] ? kthread_freezable_should_stop+0x70/0x70
[ 2934.078452]  [<ffffffff816f8010>] ? gs_change+0xb/0xb
[ 2934.078452] Code: 00 00 00 31 ff 48 89 e5 4c 89 c1 eb 0f 66 0f 1f 44 00 00 48 8b 49 30 49 39 c8 74 40 0f b7 41 5c a8 41 75 ef 48 8b 81 c8 00 00 00 <48> 8b 70 10 48 0f ce 48 85 f6 74 05 48 85 ff 74 14 48 89 f2 48
[ 2934.078452] RIP  [<ffffffffa009a790>] xlog_get_lowest_lsn+0x30/0x80 [xfs]
[ 2934.078452]  RSP <ffff880078281d10>
[ 2934.078452] CR2: ffffc900036a8010
[ 2934.078452] ---[ end trace b65516a5387874db ]---

Looks like I've seen that one before this patch series:
http://oss.sgi.com/pipermail/xfs/2012-March/017909.html

Looking good.  ;)

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
