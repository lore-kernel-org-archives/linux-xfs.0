Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB4FC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC3732083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WGSO1sZm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgEGMUZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725953AbgEGMUY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD54C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=w37MPktt5ODC/HOq0apwYYVR035DeWP4UaQYA90UFV0=; b=WGSO1sZmNwxoNzUaX3M2P/gKVT
        2tEKHA9uz07o1buj84Pui8AQP+yoq1fKGW+JVhZnoCx/j8EtMcwDFFVFKcanPd02dEntEYURHaDKs
        w4H0bwjAejx85ztJSbQeuG4YOkTbDc5biekMq4HJf7ZxtvDwvL25r5cB6BKjm6JsNLQXWamkL3Wjr
        kuKO8ZlQgZ9xKVm6fQPkBCrfGCcylI3ZabBv6l0DcMcoAByJTHBmkRChxFHQuQNVVZxmBZqjZm+Ts
        OU5fVIg5ptgIaFOqmAO2+jdM3bcdyKm8iJX89g5zUL9b5So3iQ6LPJUQhqK/yYk5Gl+kxJ2hkxLOK
        K2ApGNZg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVo-0007fH-9x; Thu, 07 May 2020 12:20:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 37/58] xfs: check owner of dir3 data blocks
Date:   Thu,  7 May 2020 14:18:30 +0200
Message-Id: <20200507121851.304002-38-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Source kernel commit: a10c21ed5d5241d11cf1d5a4556730840572900b

Check the owner field of dir3 data block headers.  If it's corrupt,
release the buffer and return EFSCORRUPTED.  All callers handle this
properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dir2_data.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 91a9cc16..ddd5e885 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -391,6 +391,22 @@ static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
 	.verify_write = xfs_dir3_data_write_verify,
 };
 
+static xfs_failaddr_t
+xfs_dir3_data_header_check(
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
+
+		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
+			return __this_address;
+	}
+
+	return NULL;
+}
 
 int
 xfs_dir3_data_read(
@@ -400,12 +416,24 @@ xfs_dir3_data_read(
 	unsigned int		flags,
 	struct xfs_buf		**bpp)
 {
+	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, bno, flags, bpp, XFS_DATA_FORK,
 			&xfs_dir3_data_buf_ops);
-	if (!err && tp && *bpp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
+	if (err || !*bpp)
+		return err;
+
+	/* Check things that we can't do in the verifier. */
+	fa = xfs_dir3_data_header_check(dp, *bpp);
+	if (fa) {
+		__xfs_buf_mark_corrupt(*bpp, fa);
+		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
+		return -EFSCORRUPTED;
+	}
+
+	xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
 	return err;
 }
 
-- 
2.26.2

