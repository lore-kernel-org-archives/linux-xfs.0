Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA69C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 23:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346779AbiAKXW7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 18:22:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41168 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbiAKXW7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 18:22:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A071B81BE7
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jan 2022 23:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD83C36AE3;
        Tue, 11 Jan 2022 23:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641943377;
        bh=4Y8RIkF91OIQYqxy1BR5wXvKRHWSiozr9ek90UF/81E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tvxPv3hRPKgT1jyD4SWEdoVjZQycosEUVG/ythd/c5WWsbQCTz966LcSz3Lvsjk3Q
         fE1pbimlQ57hWhh4A51Ba8W541MeWf5xQh4DcWBZ5x9Zwg1veWyZonZjYjyGZdp5jB
         zl8Ay9JH1HgnWpZRfHT9YtLX5GKIGDtf9kmY6ASv88oUX1Mh8vfAbkQSxbTxq2UOGe
         xpuyMVHDMqcYzXra5qWjnBcIV7Q5NvoQzCQb+wOKnSlHjLSvvEMSWrk/B48vCz/mUX
         SUnO300/W21eaoHNKA4g69ZbfvZnrcT6li4z5w7pDtx6jXC+p9vsY5YSDSwf817NW3
         KCJJByoqhikXQ==
Subject: [PATCH 3/3] xfs: remove the XFS_IOC_FSSETDM definitions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 11 Jan 2022 15:22:57 -0800
Message-ID: <164194337697.3069025.4831414268040360601.stgit@magnolia>
In-Reply-To: <164194336019.3069025.16691952615002573445.stgit@magnolia>
References: <164194336019.3069025.16691952615002573445.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove the definitions for these ioctls, since the functionality (and,
weirdly, the 32-bit compat ioctl definitions) were removed from the
kernel in November 2019.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 49c0e583d6bb..505533c43a92 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -92,21 +92,6 @@ struct getbmapx {
 #define XFS_FMR_OWN_COW		FMR_OWNER('X', 7) /* cow staging */
 #define XFS_FMR_OWN_DEFECTIVE	FMR_OWNER('X', 8) /* bad blocks */
 
-/*
- * Structure for XFS_IOC_FSSETDM.
- * For use by backup and restore programs to set the XFS on-disk inode
- * fields di_dmevmask and di_dmstate.  These must be set to exactly and
- * only values previously obtained via xfs_bulkstat!  (Specifically the
- * struct xfs_bstat fields bs_dmevmask and bs_dmstate.)
- */
-#ifndef HAVE_FSDMIDATA
-struct fsdmidata {
-	__u32		fsd_dmevmask;	/* corresponds to di_dmevmask */
-	__u16		fsd_padding;
-	__u16		fsd_dmstate;	/* corresponds to di_dmstate  */
-};
-#endif
-
 /*
  * File segment locking set data type for 64 bit access.
  * Also used for all the RESV/FREE interfaces.
@@ -562,16 +547,10 @@ typedef struct xfs_fsop_handlereq {
 
 /*
  * Compound structures for passing args through Handle Request interfaces
- * xfs_fssetdm_by_handle, xfs_attrlist_by_handle, xfs_attrmulti_by_handle
- * - ioctls: XFS_IOC_FSSETDM_BY_HANDLE, XFS_IOC_ATTRLIST_BY_HANDLE, and
- *	     XFS_IOC_ATTRMULTI_BY_HANDLE
+ * xfs_attrlist_by_handle, xfs_attrmulti_by_handle
+ * - ioctls: XFS_IOC_ATTRLIST_BY_HANDLE, and XFS_IOC_ATTRMULTI_BY_HANDLE
  */
 
-typedef struct xfs_fsop_setdm_handlereq {
-	struct xfs_fsop_handlereq	hreq;	/* handle information	*/
-	struct fsdmidata		__user *data;	/* DMAPI data	*/
-} xfs_fsop_setdm_handlereq_t;
-
 /*
  * Flags passed in xfs_attr_multiop.am_flags for the attr ioctl interface.
  *
@@ -789,7 +768,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_ALLOCSP64 ----- deprecated 36	 */
 /*	XFS_IOC_FREESP64 ------ deprecated 37	 */
 #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
-#define XFS_IOC_FSSETDM		_IOW ('X', 39, struct fsdmidata)
+/*      XFS_IOC_FSSETDM ------- deprecated 39    */
 #define XFS_IOC_RESVSP		_IOW ('X', 40, struct xfs_flock64)
 #define XFS_IOC_UNRESVSP	_IOW ('X', 41, struct xfs_flock64)
 #define XFS_IOC_RESVSP64	_IOW ('X', 42, struct xfs_flock64)
@@ -831,7 +810,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FREEZE		     _IOWR('X', 119, int)	/* aka FIFREEZE */
 #define XFS_IOC_THAW		     _IOWR('X', 120, int)	/* aka FITHAW */
 
-#define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
+/*      XFS_IOC_FSSETDM_BY_HANDLE -- deprecated 121      */
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY_V4	     _IOR ('X', 124, struct xfs_fsop_geom_v4)

