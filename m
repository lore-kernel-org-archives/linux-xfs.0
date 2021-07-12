Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4C2C07E9C
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1176960FF3
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhGLLRK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 07:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235456AbhGLLQ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jul 2021 07:16:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC50C0613DD;
        Mon, 12 Jul 2021 04:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ZA4VP6EOXAg966+D6EAwKT23yxSFLPZH1bPIJnsKkSk=; b=ITMdY4BUJ5Vj5WZnyBThWZK/9g
        irUEGep3quRLu/9o0HQFXQmkEIuic4crwUowX6x1Yw7xlC6+8yIpGlhSZ5H8/Ad+YwtKeTXTKOOz9
        KuyUgyZJbyihvwMnHnHhPR4pj3W4XtD08q6weTQC+8jzJvHiQBpNcLP7FD3SrH5PWxxTuJdQtlfR/
        rMb70B2p1INuVPt6VPCrwveFVDSz6iyefxSvIguZ6npeJCoAxu18HqNOO/tMe/xSheXiWU5JS0fwU
        RZ94jJjO4sUcnQL1c3g+cHbO5kpwN8axOcjOwksNGy3h3CoMc5go91GMJvg7KgkeMz4O7J5EgxUJw
        +IfuOymA==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2tsn-00HXKw-LM; Mon, 12 Jul 2021 11:13:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs/305: don't turn quota accounting off
Date:   Mon, 12 Jul 2021 13:11:46 +0200
Message-Id: <20210712111146.82734-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712111146.82734-1-hch@lst.de>
References: <20210712111146.82734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The test case tests just as much when just testing turning quota
enforcement off, so switch it to that.  This is in preparation for
removing support to turn quota accounting off.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/305 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/305 b/tests/xfs/305
index 140557a0..0b89499a 100755
--- a/tests/xfs/305
+++ b/tests/xfs/305
@@ -38,7 +38,7 @@ _exercise()
 
 	$FSSTRESS_PROG -d $QUOTA_DIR -n 1000000 -p 100 $FSSTRESS_AVOID >/dev/null 2>&1 &
 	sleep 10
-	xfs_quota -x -c "off -$type" $SCRATCH_DEV
+	xfs_quota -x -c "disable -$type" $SCRATCH_DEV
 	sleep 5
 	$KILLALL_PROG -q $FSSTRESS_PROG
 	wait
-- 
2.30.2

