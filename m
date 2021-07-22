Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84149C63793
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67BBE6023B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhGVHAl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 03:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhGVHAk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 03:00:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463E1C061575;
        Thu, 22 Jul 2021 00:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=X1NeZeVtf+Cf6qAkIGRLNh0MOX2/K2uIrNry7FochMs=; b=c7m2x+mjZj/o5oYxbynk1DtAoD
        ZNTPDbhaBB4JyecYOaEDGGagp8Y2/t5jknKaiqy6ur2LZqyxF/Pb/KSUgH0fyB5SpbtZDLy3uj2Xz
        aJd/qI0t2muE67VlZzsq9AMTYA/UJpRDlHAoo0Vs4+GrfoQgvg2/7EraAaAgk4iotGIXv52LWJ3+/
        xSk3yKdkSC/v+7LuhUCiJSfPdVyU/ekU2grj8z7KqqOwyEtxXZJd88huWBPA5gdz7iywI+SnS52Iy
        hh+KDE1nvb2+Nv3cCQASjrv1nMmqbVcK1wVaC0LHCEd0/D4k/QYic42NvvDE/9yWkZ0lwPjy21yyH
        IqmoeE1w==;
Received: from [2001:4bb8:193:7660:643c:9899:473:314a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6TJx-00A0XR-3e; Thu, 22 Jul 2021 07:40:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs/220: avoid failure when disabling quota accounting is not supported
Date:   Thu, 22 Jul 2021 09:38:29 +0200
Message-Id: <20210722073832.976547-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210722073832.976547-1-hch@lst.de>
References: <20210722073832.976547-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Doing a proper _requires for quotaoff support is rather hard, as we need
to test it on a specific file system.  Instead just use sed to remove
the warning and let the test case pass.  Eventually it should just be
removed entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/220 | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/220 b/tests/xfs/220
index 8d955225..c847a0dc 100755
--- a/tests/xfs/220
+++ b/tests/xfs/220
@@ -54,7 +54,12 @@ _scratch_mount -o uquota
 
 # turn off quota and remove space allocated to the quota files
 # (this used to give wrong ENOSYS returns in 2.6.31)
-xfs_quota -x -c off -c remove $SCRATCH_DEV
+#
+# The sed expression below replaces a notrun to cater for kernels that have
+# removed the ability to disable quota accounting at runtime.  On those
+# kernel this test is rather useless, and in a few years we can drop it.
+xfs_quota -x -c off -c remove $SCRATCH_DEV 2>&1 | \
+	sed -e '/XFS_QUOTARM: Invalid argument/d'
 
 # and unmount again
 _scratch_unmount
-- 
2.30.2

