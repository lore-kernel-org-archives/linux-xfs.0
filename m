Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329A3C38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A335208E4
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bdTVqnZS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgEGMUt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGMUt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E38C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=knIK34M4WYHHkW3zqLBlsgaqUFLVoyoAcGjjJjGrabE=; b=bdTVqnZSu/oZIBb1IXB9/T+2qx
        fhnqigMSY8768BXQZsCYwy9ACTF/zfgPi6vBXrV0Vi6CkIvlOzpwwXFJGcCVh9DqUYnkefFRiH5VC
        OS5WF1bOcm2h4bV4HDFotBIPqYcHewQvFlsb0vWirhbgowf8uMMBq+vfWLd7YZMKeZwVwo9swl6Th
        jAfaKMcPhRM1I391NifFekoaeUFTHwh1mNSMGMbmyywt3MswmmTh9+QgQYryML5FYyMFCSqDcVD8j
        gYwlxhEyFEs5xI1OYiTe/ituzf6dGyHud75Y24NrIeb56Mx2rk42/8r/Ns3RoyFrVcpd+qPKPKzF3
        BXMq5lCA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfWC-0007pk-MF; Thu, 07 May 2020 12:20:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 47/58] xfs: fix incorrect test in xfs_alloc_ag_vextent_lastblock
Date:   Thu,  7 May 2020 14:18:40 +0200
Message-Id: <20200507121851.304002-48-hch@lst.de>
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

Source kernel commit: 77ca1eed5a7d2bf0905562eb1a15aac76bc19fe4

When I lifted the code in xfs_alloc_ag_vextent_lastblock out of a loop,
I forgot to convert all the accesses to len to be pointer dereferences.

Coverity-id: 1457918
Fixes: 5113f8ec3753ed ("xfs: clean up weird while loop in xfs_alloc_ag_vextent_near")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 841b0305..fee4039c 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1510,7 +1510,7 @@ xfs_alloc_ag_vextent_lastblock(
 	 * maxlen, go to the start of this block, and skip all those smaller
 	 * than minlen.
 	 */
-	if (len || args->alignment > 1) {
+	if (*len || args->alignment > 1) {
 		acur->cnt->bc_ptrs[0] = 1;
 		do {
 			error = xfs_alloc_get_rec(acur->cnt, bno, len, &i);
-- 
2.26.2

