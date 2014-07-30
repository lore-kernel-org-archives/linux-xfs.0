Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 51AC87F6F
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 20:49:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 190E78F806F
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 18:49:09 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VkH4LrUAhu2GLAMd for <xfs@oss.sgi.com>;
	Tue, 29 Jul 2014 18:49:07 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCJ0c-0001HC-QO
	for xfs@oss.sgi.com; Wed, 30 Jul 2014 11:48:50 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCJ0c-0002ua-Po
	for xfs@oss.sgi.com; Wed, 30 Jul 2014 11:48:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: quotacheck leaves dquot buffers without verifiers
Date: Wed, 30 Jul 2014 11:48:48 +1000
Message-Id: <1406684929-11133-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1406684929-11133-1-git-send-email-david@fromorbit.com>
References: <1406684929-11133-1-git-send-email-david@fromorbit.com>
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

When running xfs/305, I noticed that quotacheck was flushing dquot
buffers that did not have the xfs_dquot_buf_ops verifiers attached:

XFS (vdb): _xfs_buf_ioapply: no ops on block 0x1dc8/0x1dc8
ffff880052489000: 44 51 01 04 00 00 65 b8 00 00 00 00 00 00 00 00  DQ....e.........
ffff880052489010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880052489020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880052489030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
CPU: 1 PID: 2376 Comm: mount Not tainted 3.16.0-rc2-dgc+ #306
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
 ffff88006fe38000 ffff88004a0ffae8 ffffffff81cf1cca 0000000000000001
 ffff88004a0ffb88 ffffffff814d50ca 000010004a0ffc70 0000000000000000
 ffff88006be56dc4 0000000000000021 0000000000001dc8 ffff88007c773d80
Call Trace:
 [<ffffffff81cf1cca>] dump_stack+0x45/0x56
 [<ffffffff814d50ca>] _xfs_buf_ioapply+0x3ca/0x3d0
 [<ffffffff810db520>] ? wake_up_state+0x20/0x20
 [<ffffffff814d51f5>] ? xfs_bdstrat_cb+0x55/0xb0
 [<ffffffff814d513b>] xfs_buf_iorequest+0x6b/0xd0
 [<ffffffff814d51f5>] xfs_bdstrat_cb+0x55/0xb0
 [<ffffffff814d53ab>] __xfs_buf_delwri_submit+0x15b/0x220
 [<ffffffff814d6040>] ? xfs_buf_delwri_submit+0x30/0x90
 [<ffffffff814d6040>] xfs_buf_delwri_submit+0x30/0x90
 [<ffffffff8150f89d>] xfs_qm_quotacheck+0x17d/0x3c0
 [<ffffffff81510591>] xfs_qm_mount_quotas+0x151/0x1e0
 [<ffffffff814ed01c>] xfs_mountfs+0x56c/0x7d0
 [<ffffffff814f0f12>] xfs_fs_fill_super+0x2c2/0x340
 [<ffffffff811c9fe4>] mount_bdev+0x194/0x1d0
 [<ffffffff814f0c50>] ? xfs_finish_flags+0x170/0x170
 [<ffffffff814ef0f5>] xfs_fs_mount+0x15/0x20
 [<ffffffff811ca8c9>] mount_fs+0x39/0x1b0
 [<ffffffff811e4d67>] vfs_kern_mount+0x67/0x120
 [<ffffffff811e757e>] do_mount+0x23e/0xad0
 [<ffffffff8117abde>] ? __get_free_pages+0xe/0x50
 [<ffffffff811e71e6>] ? copy_mount_options+0x36/0x150
 [<ffffffff811e8103>] SyS_mount+0x83/0xc0
 [<ffffffff81cfd40b>] tracesys+0xdd/0xe2

This was caused by dquot buffer readahead not attaching a verifier
structure to the buffer when readahead was issued, resulting in the
followup read of the buffer finding a valid buffer and so not
attaching new verifiers to the buffer as part of the read.

Also, when a verifier failure occurs, we then read the buffer
without verifiers. Attach the verifiers manually after this read so
that if the buffer is then written it will be verified that the
corruption has been repaired.

Further, when flushing a dquot we don't ask for a verifier when
reading in the dquot buffer the dquot belongs to. Most of the time
this isn't an issue because the buffer is still cached, but when it
is not cached it will result in writing the dquot buffer without
having the verfier attached.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c | 3 ++-
 fs/xfs/xfs_qm.c    | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8a44a79..63c2de4 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -974,7 +974,8 @@ xfs_qm_dqflush(
 	 * Get the buffer containing the on-disk dquot
 	 */
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, 0, &bp, NULL);
+				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
+				   &xfs_dquot_buf_ops);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 7e1a80b..1023210 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -911,6 +911,12 @@ xfs_qm_dqiter_bufs(
 		if (error)
 			break;
 
+		/*
+		 * A corrupt buffer might not have a verifier attached, so
+		 * make sure we have the correct one attached before writeback
+		 * occurs.
+		 */
+		bp->b_ops = &xfs_dquot_buf_ops;
 		xfs_qm_reset_dqcounts(mp, bp, firstid, type);
 		xfs_buf_delwri_queue(bp, buffer_list);
 		xfs_buf_relse(bp);
@@ -996,7 +1002,7 @@ xfs_qm_dqiterate(
 					xfs_buf_readahead(mp->m_ddev_targp,
 					       XFS_FSB_TO_DADDR(mp, rablkno),
 					       mp->m_quotainfo->qi_dqchunklen,
-					       NULL);
+					       &xfs_dquot_buf_ops);
 					rablkno++;
 				}
 			}
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
