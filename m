Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518D2C38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FB67207DD
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dT3CZ07F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgEHGem (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 02:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727094AbgEHGem (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5D2C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wn5CPAe9dbEELVBKBZoZ65bYWI/DRKSTsJjv2Kmabts=; b=dT3CZ07FHvdqQBEr2NnKcS0Yjv
        Kz3GVsp3gVamDRMrjVnb0UTrb4VgF5vx044RfWig+j5tcnojcl3ueUbtKUnpec0hoUK3vroro4xUg
        xNPxRHVSbYeQ3F+oVGGuosWtz5b1eYMCS0xsv7GBC6N/sqkRs2MJwUzvE7wTeAocT/rfcR5mVibQT
        PQzSqYcXei6n6VXs1Njpk+1FVs3YO+W4TtQ6TP44R7P92wusrPNvOKq48utD8VhWj98cDK19QL/Oj
        vxgopmdrxfID97vIybaeOJH43VMz4h9M+9cqqLvVyWbOMuzdEW2ru6EpHEg+zfYVgua9pBpxOiz9i
        UnIYZTzA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwan-0002vV-VB; Fri, 08 May 2020 06:34:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 07/12] xfs: remove xfs_iread
Date:   Fri,  8 May 2020 08:34:18 +0200
Message-Id: <20200508063423.482370-8-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508063423.482370-1-hch@lst.de>
References: <20200508063423.482370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is not much point in the xfs_iread function, as it has a single
caller and not a whole lot of code.  Move it into the only caller,
and trim down the overdocumentation to just documenting the important
"why" instead of a lot of redundant "what".

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 73 -----------------------------------
 fs/xfs/libxfs/xfs_inode_buf.h |  2 -
 fs/xfs/xfs_icache.c           | 33 +++++++++++++++-
 3 files changed, 32 insertions(+), 76 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 329534eebbdcc..05f939adea944 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -614,79 +614,6 @@ xfs_dinode_calc_crc(
 	dip->di_crc = xfs_end_cksum(crc);
 }
 
-/*
- * Read the disk inode attributes into the in-core inode structure.
- *
- * For version 5 superblocks, if we are initialising a new inode and we are not
- * utilising the XFS_MOUNT_IKEEP inode cluster mode, we can simple build the new
- * inode core with a random generation number. If we are keeping inodes around,
- * we need to read the inode cluster to get the existing generation number off
- * disk. Further, if we are using version 4 superblocks (i.e. v1/v2 inode
- * format) then log recovery is dependent on the di_flushiter field being
- * initialised from the current on-disk value and hence we must also read the
- * inode off disk.
- */
-int
-xfs_iread(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	uint		iget_flags)
-{
-	xfs_buf_t	*bp;
-	xfs_dinode_t	*dip;
-	int		error;
-
-	/*
-	 * Fill in the location information in the in-core inode.
-	 */
-	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, iget_flags);
-	if (error)
-		return error;
-
-	/* shortcut IO on inode allocation if possible */
-	if ((iget_flags & XFS_IGET_CREATE) &&
-	    xfs_sb_version_has_v3inode(&mp->m_sb) &&
-	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
-		VFS_I(ip)->i_generation = prandom_u32();
-		return 0;
-	}
-
-	/*
-	 * Get pointers to the on-disk inode and the buffer containing it.
-	 */
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0);
-	if (error)
-		return error;
-
-	error = xfs_inode_from_disk(ip, dip);
-	if (error)
-		goto out_brelse;
-
-	/*
-	 * Mark the buffer containing the inode as something to keep
-	 * around for a while.  This helps to keep recently accessed
-	 * meta-data in-core longer.
-	 */
-	xfs_buf_set_ref(bp, XFS_INO_REF);
-
-	/*
-	 * Use xfs_trans_brelse() to release the buffer containing the on-disk
-	 * inode, because it was acquired with xfs_trans_read_buf() in
-	 * xfs_imap_to_bp() above.  If tp is NULL, this is just a normal
-	 * brelse().  If we're within a transaction, then xfs_trans_brelse()
-	 * will only release the buffer if it is not dirty within the
-	 * transaction.  It will be OK to release the buffer in this case,
-	 * because inodes on disk are never destroyed and we will be locking the
-	 * new in-core inode before putting it in the cache where other
-	 * processes can find it.  Thus we don't have to worry about the inode
-	 * being changed just because we released the buffer.
-	 */
- out_brelse:
-	xfs_trans_brelse(tp, bp);
-	return error;
-}
-
 /*
  * Validate di_extsize hint.
  *
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 0fbb99224ec73..e4cbcaf62a32b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -49,8 +49,6 @@ struct xfs_imap {
 int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 		       struct xfs_imap *, struct xfs_dinode **,
 		       struct xfs_buf **, uint);
-int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
-		  struct xfs_inode *, uint);
 void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
 void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
 			  xfs_lsn_t lsn);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 922a29032e374..af5748f5d9271 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -22,6 +22,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
+#include "xfs_ialloc.h"
 
 #include <linux/iversion.h>
 
@@ -508,10 +509,40 @@ xfs_iget_cache_miss(
 	if (!ip)
 		return -ENOMEM;
 
-	error = xfs_iread(mp, tp, ip, flags);
+	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, flags);
 	if (error)
 		goto out_destroy;
 
+	/*
+	 * For version 5 superblocks, if we are initialising a new inode and we
+	 * are not utilising the XFS_MOUNT_IKEEP inode cluster mode, we can
+	 * simply build the new inode core with a random generation number.
+	 *
+	 * For version 4 (and older) superblocks, log recovery is dependent on
+	 * the di_flushiter field being initialised from the current on-disk
+	 * value and hence we must also read the inode off disk even when
+	 * initializing new inodes.
+	 */
+	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
+	    (flags & XFS_IGET_CREATE) && !(mp->m_flags & XFS_MOUNT_IKEEP)) {
+		VFS_I(ip)->i_generation = prandom_u32();
+	} else {
+		struct xfs_dinode	*dip;
+		struct xfs_buf		*bp;
+
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0);
+		if (error)
+			goto out_destroy;
+
+		error = xfs_inode_from_disk(ip, dip);
+		if (!error)
+			xfs_buf_set_ref(bp, XFS_INO_REF);
+		xfs_trans_brelse(tp, bp);
+
+		if (error)
+			goto out_destroy;
+	}
+
 	if (!xfs_inode_verify_forks(ip)) {
 		error = -EFSCORRUPTED;
 		goto out_destroy;
-- 
2.26.2

