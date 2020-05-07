Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4153CC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 199C42083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nz4g9Xrq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgEGMUR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726618AbgEGMUR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805FDC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HEGRxpr8+lzQSn44sw4lujNhdUIdpAxo8BDXUiR8ock=; b=nz4g9Xrqs8TK7EWt88tT85JYWP
        8piybRnwPaSF1v2GkzDEYEnRPBe9mv6Sx7Mggeh4hWH7THqFOYqvd6LQY1fPcXHg3+MXxy9ko4slQ
        tzpWhYnMVT3v7Udd6PGiGxTmAUh2zwr8znCK8uOL8qrt5sNMGK9bX40KDIPpFicLuTridP7M9XgTA
        eM18jvBTnoALjvr40Aj4iDOW6CfYuTGpKZ/tKtkRpj0YskJ+Mjw/O4Cbrd6rKCHyMO62uwFfF/U9O
        87WWQO/WQ3XKm02zlsNkCFq5zyCt0OgSKCoOYuymGaEl8C8DzPEtm9QEfRaqX2FlebKZMDtU/qZDR
        o8gbCpXw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVh-0007eF-0a; Thu, 07 May 2020 12:20:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 34/58] xfs: fix buffer corruption reporting when xfs_dir3_free_header_check fails
Date:   Thu,  7 May 2020 14:18:27 +0200
Message-Id: <20200507121851.304002-35-hch@lst.de>
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

Source kernel commit: ce99494c9699df58b31d0a839e957f86cd58c755

xfs_verifier_error is supposed to be called on a corrupt metadata buffer
from within a buffer verifier function, whereas xfs_buf_mark_corrupt
is the function to be called when a piece of code has read a buffer and
catches something that a read verifier cannot.  The first function sets
b_error anticipating that the low level buffer handling code will see
the nonzero b_error and clear XBF_DONE on the buffer, whereas the second
function does not.

Since xfs_dir3_free_header_check examines fields in the dir free block
header that require more context than can be provided to read verifiers,
we must call xfs_buf_mark_corrupt when it finds a problem.

Switching the calls has a secondary effect that we no longer corrupt the
buffer state by setting b_error and leaving XBF_DONE set.  When /that/
happens, we'll trip over various state assertions (most commonly the
b_error check in xfs_buf_reverify) on a subsequent attempt to read the
buffer.

Fixes: bc1a09b8e334bf5f ("xfs: refactor verifier callers to print address of failing check")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dir2_node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 3dd999c3..56eae67e 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -223,7 +223,7 @@ __xfs_dir3_free_read(
 	/* Check things that we can't do in the verifier. */
 	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
 	if (fa) {
-		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
+		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		return -EFSCORRUPTED;
 	}
-- 
2.26.2

