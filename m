Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C031E7F50
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:34:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9BE948F8039
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 21:34:46 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GHZzCWziiV9dMPBT for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 21:34:44 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vqyv2-0000bl-9Q
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 16:34:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vqyv2-0003cK-8W
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 16:34:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] xfs: don't try to mark uncached buffers stale on error.
Date: Thu, 12 Dec 2013 16:34:33 +1100
Message-Id: <1386826478-13846-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1386826478-13846-1-git-send-email-david@fromorbit.com>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

fsstress failed during a shutdown with the following assert:

XFS: Assertion failed: xfs_buf_islocked(bp), file: fs/xfs/xfs_buf.c, line: 143
.....
 xfs_buf_stale+0x3f/0xf0
 xfs_bioerror_relse+0x2d/0x90
 xfsbdstrat+0x51/0xa0
 xfs_zero_remaining_bytes+0x1d1/0x2d0
 xfs_free_file_space+0x5d0/0x600
 xfs_change_file_space+0x251/0x3a0
 xfs_ioc_space+0xcc/0x130
.....

xfs_zero_remaining_bytes() works with uncached buffers, and hence if
we are preventing IO due to a shutdown, we should not be marking it
stale as that is only for cached buffers. Instead, just mark it with
an error and make sure it gets to the caller.

[ 7732.193441] XFS: Assertion failed: xfs_buf_islocked(bp), file: fs/xfs/xfs_buf.c, line: 96
[ 7732.195036] ------------[ cut here ]------------
[ 7732.195890] kernel BUG at fs/xfs/xfs_message.c:107!
[ 7732.196018] invalid opcode: 0000 [#1] SMP
[ 7732.196018] Modules linked in:
[ 7732.196018] CPU: 0 PID: 2899 Comm: fsstress Not tainted 3.12.0-rc7-dgc+ #47
[ 7732.196018] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 7732.196018] task: ffff88003a83ada0 ti: ffff88002c0ae000 task.ti: ffff88002c0ae000
[ 7732.196018] RIP: 0010:[<ffffffff81488462>]  [<ffffffff81488462>] assfail+0x22/0x30
[ 7732.196018] RSP: 0000:ffff88002c0afae8  EFLAGS: 00010292
[ 7732.196018] RAX: 000000000000004d RBX: ffff880002e59600 RCX: 0000000000000000
[ 7732.196018] RDX: ffff88003fc0ed68 RSI: ffff88003fc0d3f8 RDI: 0000000000000246
[ 7732.196018] RBP: ffff88002c0afae8 R08: 0000000000000096 R09: 00000000000012ec
[ 7732.196018] R10: 0000000000000000 R11: 00000000000012eb R12: 0000000000100002
[ 7732.196018] R13: ffffffff81473523 R14: 0000000000009fff R15: 0000000000009fff
[ 7732.196018] FS:  00007f8017e4a700(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[ 7732.196018] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 7732.196018] CR2: 00007ff8d020a000 CR3: 0000000009b43000 CR4: 00000000000006f0
[ 7732.196018] Stack:
[ 7732.196018]  ffff88002c0afb08 ffffffff8147476e ffff880002e59600 0000000000100002
[ 7732.196018]  ffff88002c0afb28 ffffffff814762cd ffff880002e59600 ffff880002e59600
[ 7732.196018]  ffff88002c0afb58 ffffffff81476841 0000000000009f89 ffff880002e59600
[ 7732.196018] Call Trace:
[ 7732.196018]  [<ffffffff8147476e>] xfs_buf_stale+0x2e/0xb0
[ 7732.196018]  [<ffffffff814762cd>] xfs_bioerror_relse+0x2d/0x90
[ 7732.196018]  [<ffffffff81476841>] xfsbdstrat+0x51/0x90
[ 7732.196018]  [<ffffffff81473523>] xfs_zero_remaining_bytes+0x1d3/0x2d0
[ 7732.196018]  [<ffffffff81473ba6>] xfs_free_file_space+0x586/0x5b0
[ 7732.196018]  [<ffffffff81190002>] ? slabs_cpu_partial_show+0xd2/0x120
[ 7732.196018]  [<ffffffff811b9399>] ? mntput_no_expire+0x49/0x160
[ 7732.196018]  [<ffffffff811b8812>] ? mnt_clone_write+0x12/0x30
[ 7732.196018]  [<ffffffff81aba3f6>] ? down_write+0x16/0x40
[ 7732.196018]  [<ffffffff81481c14>] xfs_ioc_space+0x2d4/0x450
[ 7732.196018]  [<ffffffff811a700b>] ? path_lookupat+0x6b/0x760
[ 7732.196018]  [<ffffffff8148f57e>] ? xfs_trans_free+0x6e/0x80
[ 7732.196018]  [<ffffffff81192a81>] ? kmem_cache_alloc+0x31/0x150
[ 7732.196018]  [<ffffffff8148326b>] xfs_file_ioctl+0x48b/0xae0
[ 7732.196018]  [<ffffffff811a60d6>] ? final_putname+0x26/0x50
[ 7732.196018]  [<ffffffff8110b6a2>] ? from_kgid+0x12/0x20
[ 7732.196018]  [<ffffffff8110b6be>] ? from_kgid_munged+0xe/0x20
[ 7732.196018]  [<ffffffff8119f856>] ? cp_new_stat+0x146/0x160
[ 7732.196018]  [<ffffffff811ace02>] do_vfs_ioctl+0x452/0x530
[ 7732.196018]  [<ffffffff8119fd35>] ? SYSC_newfstat+0x25/0x30
[ 7732.196018]  [<ffffffff811acf71>] SyS_ioctl+0x91/0xb0
[ 7732.196018]  [<ffffffff81ac6029>] system_call_fastpath+0x16/0x1b


Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 47 ++++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ce01c1a..27dc152 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1076,7 +1076,14 @@ xfs_bioerror(
 	 */
 	XFS_BUF_UNREAD(bp);
 	XFS_BUF_UNDONE(bp);
-	xfs_buf_stale(bp);
+
+	/*
+	 * we might be handling an uncached buffer here, in which case the
+	 * stale buffer handling is irrelevant as is doing IO with the buffer
+	 * locked. Hence we don't mark them stale.
+	 */
+	if (bp->b_pag)
+		xfs_buf_stale(bp);
 
 	xfs_buf_ioend(bp, 0);
 
@@ -1094,25 +1101,20 @@ xfs_bioerror_relse(
 	struct xfs_buf	*bp)
 {
 	int64_t		fl = bp->b_flags;
+
 	/*
-	 * No need to wait until the buffer is unpinned.
-	 * We aren't flushing it.
-	 *
-	 * chunkhold expects B_DONE to be set, whether
-	 * we actually finish the I/O or not. We don't want to
-	 * change that interface.
+	 * No need to wait until the buffer is unpinned. We aren't flushing it.
 	 */
 	XFS_BUF_UNREAD(bp);
 	XFS_BUF_DONE(bp);
 	xfs_buf_stale(bp);
 	bp->b_iodone = NULL;
+
+	/*
+	 * There's no reason to mark error for ASYNC buffers as there is no-one
+	 * waiting to collect the error.
+	 */
 	if (!(fl & XBF_ASYNC)) {
-		/*
-		 * Mark b_error and B_ERROR _both_.
-		 * Lot's of chunkcache code assumes that.
-		 * There's no reason to mark error for
-		 * ASYNC buffers.
-		 */
 		xfs_buf_ioerror(bp, EIO);
 		complete(&bp->b_iowait);
 	} else {
@@ -1129,14 +1131,13 @@ xfs_bdstrat_cb(
 	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
 		trace_xfs_bdstrat_shut(bp, _RET_IP_);
 		/*
-		 * Metadata write that didn't get logged but
-		 * written delayed anyway. These aren't associated
-		 * with a transaction, and can be ignored.
+		 * If this is a cached write, then it is likely to be a delayed
+		 * write metadata buffer that can be ignored because the
+		 * contents are logged.
 		 */
 		if (!bp->b_iodone && !XFS_BUF_ISREAD(bp))
 			return xfs_bioerror_relse(bp);
-		else
-			return xfs_bioerror(bp);
+		return xfs_bioerror(bp);
 	}
 
 	xfs_buf_iorequest(bp);
@@ -1176,7 +1177,15 @@ xfsbdstrat(
 {
 	if (XFS_FORCED_SHUTDOWN(mp)) {
 		trace_xfs_bdstrat_shut(bp, _RET_IP_);
-		xfs_bioerror_relse(bp);
+		/*
+		 * we could be handling uncached IO here, in which case there is
+		 * always a caller waiting to collect the error and releas the
+		 * buffer.
+		 */
+		if (bp->b_pag)
+			xfs_bioerror_relse(bp);
+		else
+			xfs_bioerror(bp);
 		return;
 	}
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
