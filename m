Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66B157CA4
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:57:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3A5D98F8037
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:57:37 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id p0k9mii6XFcATMEo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:57:35 -0700 (PDT)
Subject: [PATCH 13/47] xfs: clean up typedef usage in the EFI/EFD handling code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:57:30 -0700
Message-ID: <146907705011.25461.9159996141406923498.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Replace structure typedefs with struct xfs_foo_* in the EFI/EFD
handling code in preparation to move it over to deferred ops.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trans.h         |    6 +++---
 fs/xfs/xfs_trans_extfree.c |   30 +++++++++++++++---------------
 2 files changed, 18 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9a462e8..5226511 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -209,12 +209,12 @@ void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
-struct xfs_efi_log_item	*xfs_trans_get_efi(xfs_trans_t *, uint);
-void		xfs_trans_log_efi_extent(xfs_trans_t *,
+struct xfs_efi_log_item	*xfs_trans_get_efi(struct xfs_trans *, uint);
+void		xfs_trans_log_efi_extent(struct xfs_trans *,
 					 struct xfs_efi_log_item *,
 					 xfs_fsblock_t,
 					 xfs_extlen_t);
-struct xfs_efd_log_item	*xfs_trans_get_efd(xfs_trans_t *,
+struct xfs_efd_log_item	*xfs_trans_get_efd(struct xfs_trans *,
 				  struct xfs_efi_log_item *,
 				  uint);
 int		xfs_trans_free_extent(struct xfs_trans *,
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index a96ae54..380cc46 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -33,11 +33,11 @@
  * caller must use all nextents extents, because we are not
  * flexible about this at all.
  */
-xfs_efi_log_item_t *
-xfs_trans_get_efi(xfs_trans_t	*tp,
-		  uint		nextents)
+struct xfs_efi_log_item *
+xfs_trans_get_efi(struct xfs_trans	*tp,
+		  uint			nextents)
 {
-	xfs_efi_log_item_t	*efip;
+	struct xfs_efi_log_item		*efip;
 
 	ASSERT(tp != NULL);
 	ASSERT(nextents > 0);
@@ -58,13 +58,13 @@ xfs_trans_get_efi(xfs_trans_t	*tp,
  * be called once for each extent to be freed.
  */
 void
-xfs_trans_log_efi_extent(xfs_trans_t		*tp,
-			 xfs_efi_log_item_t	*efip,
-			 xfs_fsblock_t		start_block,
-			 xfs_extlen_t		ext_len)
+xfs_trans_log_efi_extent(struct xfs_trans		*tp,
+			 struct xfs_efi_log_item	*efip,
+			 xfs_fsblock_t			start_block,
+			 xfs_extlen_t			ext_len)
 {
-	uint			next_extent;
-	xfs_extent_t		*extp;
+	uint						next_extent;
+	struct xfs_extent				*extp;
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	efip->efi_item.li_desc->lid_flags |= XFS_LID_DIRTY;
@@ -88,12 +88,12 @@ xfs_trans_log_efi_extent(xfs_trans_t		*tp,
  * caller must use all nextents extents, because we are not
  * flexible about this at all.
  */
-xfs_efd_log_item_t *
-xfs_trans_get_efd(xfs_trans_t		*tp,
-		  xfs_efi_log_item_t	*efip,
-		  uint			nextents)
+struct xfs_efd_log_item *
+xfs_trans_get_efd(struct xfs_trans		*tp,
+		  struct xfs_efi_log_item	*efip,
+		  uint				nextents)
 {
-	xfs_efd_log_item_t	*efdp;
+	struct xfs_efd_log_item			*efdp;
 
 	ASSERT(tp != NULL);
 	ASSERT(nextents > 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
