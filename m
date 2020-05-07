Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF27EC4724C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE964208E4
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H1iRVQan"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgEGMVS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726948AbgEGMVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:21:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610BAC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=eYYzw4P6CJytke1DO5TPfE4jFCD7fMM2WNQBvwthK1U=; b=H1iRVQanP0Cmz6GP/5DMqP2l8Y
        I+h9vh8D6Us82pSiu8MhkYPhTgB6Cly5iV+AtBudPomHTs/t56sM4E/9ksYj6ZUMi/iGhYEHce2hH
        HFkEhAmHBW2mssdlNls4olOQ1GhewaflWP0jNHG8Xz4lzwY7XUisWbrnRUib4oUKnisNytyazHdEo
        L95YMJzkGRjfPeQ5d8Rx2JN+0bklEk4/pop7LMZ4MbhkvnSQx264ZY3/YcfW05CkMWyds8Qn0V8DX
        tNrZaeBi7yA5EHpJGgIc1HhKvz3p08WOk7zF7RIyRiW+niXpXZsskg62xIYHG+VBKys7pwfFPzQ4z
        S93qJPgw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfWe-0008Ac-1l; Thu, 07 May 2020 12:21:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 58/58] xfs: validate the realtime geometry in xfs_validate_sb_common
Date:   Thu,  7 May 2020 14:18:51 +0200
Message-Id: <20200507121851.304002-59-hch@lst.de>
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

Source kernel commit: f8e566c0f5e1fd8de33ccec6eb1ff815cd4b0dc3

Validate the geometry of the realtime geometry when we mount the
filesystem, so that we don't abruptly shut down the filesystem later on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h | 22 ++++++++++++++++++++++
 libxfs/xfs_sb.c      | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 85fcccb6..70c70479 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -265,6 +265,28 @@ static inline uint64_t div64_u64_rem(uint64_t dividend, uint64_t divisor,
 	return dividend / divisor;
 }
 
+/**
+ * div_u64 - unsigned 64bit divide with 32bit divisor
+ * @dividend: unsigned 64bit dividend
+ * @divisor: unsigned 32bit divisor
+ *
+ * This is the most common 64bit divide and should be used if possible,
+ * as many 32bit archs can optimize this variant better than a full 64bit
+ * divide.
+ */
+static inline uint64_t div_u64(uint64_t dividend, uint32_t divisor)
+{
+	uint32_t remainder;
+	return div_u64_rem(dividend, divisor, &remainder);
+}
+
+static inline uint64_t howmany_64(uint64_t x, uint32_t y)
+{
+	x += y - 1;
+	do_div(x, y);
+	return x;
+}
+
 #define min_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
 #define max_t(type,x,y) \
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index e26b9016..d37d60b3 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -325,6 +325,38 @@ xfs_validate_sb_common(
 		return -EFSCORRUPTED;
 	}
 
+	/* Validate the realtime geometry; stolen from xfs_repair */
+	if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
+	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE) {
+		xfs_notice(mp,
+			"realtime extent sanity check failed");
+		return -EFSCORRUPTED;
+	}
+
+	if (sbp->sb_rblocks == 0) {
+		if (sbp->sb_rextents != 0 || sbp->sb_rbmblocks != 0 ||
+		    sbp->sb_rextslog != 0 || sbp->sb_frextents != 0) {
+			xfs_notice(mp,
+				"realtime zeroed geometry check failed");
+			return -EFSCORRUPTED;
+		}
+	} else {
+		uint64_t	rexts;
+		uint64_t	rbmblocks;
+
+		rexts = div_u64(sbp->sb_rblocks, sbp->sb_rextsize);
+		rbmblocks = howmany_64(sbp->sb_rextents,
+				       NBBY * sbp->sb_blocksize);
+
+		if (sbp->sb_rextents != rexts ||
+		    sbp->sb_rextslog != xfs_highbit32(sbp->sb_rextents) ||
+		    sbp->sb_rbmblocks != rbmblocks) {
+			xfs_notice(mp,
+				"realtime geometry sanity check failed");
+			return -EFSCORRUPTED;
+		}
+	}
+
 	if (sbp->sb_unit) {
 		if (!xfs_sb_version_hasdalign(sbp) ||
 		    sbp->sb_unit > sbp->sb_width ||
-- 
2.26.2

