Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 347837CA2
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 11:43:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D9F1B8F8033
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HNpQqu0EIsIpWoB7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:55 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC v2 PATCH 09/10] xfs: support no block reservation transaction
	mode
Date: Tue, 12 Apr 2016 12:42:52 -0400
Message-Id: <1460479373-63317-10-git-send-email-bfoster@redhat.com>
In-Reply-To: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
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
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com

The block device reservation mechanism is tied into the transaction
reservation mechanism and assumes the worst case scenario of a 1-1
mapping between filesystem blocks and dm blocks. This might be overkill
for certain codepaths that have enough context to not require a
worst-case reservation.

Define an optional transaction flag to disable block reservation on a
per-transaction basis. This allows any particular operation to open code
a block device reservation and potentially use a more optimal
reservation value.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_shared.h |  2 ++
 fs/xfs/xfs_trans.c         | 10 ++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 81ac870..ba79373 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -183,6 +183,8 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
 #define XFS_TRANS_FREEZE_PROT	0x40	/* Transaction has elevated writer
 					   count in superblock */
+#define XFS_TRANS_NOBLKRES	0x100	/* do not attempt blkdev reservation */
+
 /*
  * Field values for xfs_trans_mod_sb.
  */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 26e6288..343e435 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -174,11 +174,13 @@ xfs_trans_reserve(
 	uint			rtextents)
 {
 	int			error = 0;
-	int			flags = 0;
+	int			flags = XFS_BLK_RES;
 	struct xfs_mount	*mp = tp->t_mountp;
 
 	if (tp->t_flags & XFS_TRANS_RESERVE)
 		flags |= XFS_FDBLOCKS_RSVD;
+	if (tp->t_flags & XFS_TRANS_NOBLKRES)
+		flags &= ~XFS_BLK_RES;
 
 	/* Mark this thread as being in a transaction */
 	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
@@ -189,13 +191,13 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (blocks > 0) {
-		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), flags);
+		error = __xfs_mod_fdblocks(mp, -((int64_t)blocks), flags);
 		if (error != 0) {
 			current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 			return -ENOSPC;
 		}
 		tp->t_blk_res += blocks;
-		if (mp->m_thin_res)
+		if (mp->m_thin_res && (flags & XFS_BLK_RES))
 			tp->t_blk_thin_res += xfs_fsb_res(mp, blocks, false);
 	}
 
@@ -266,7 +268,7 @@ undo_log:
 
 undo_blocks:
 	if (blocks > 0) {
-		xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), flags);
+		__xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), flags);
 		tp->t_blk_res = 0;
 		if (tp->t_blk_thin_res)
 			tp->t_blk_thin_res = 0;
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
