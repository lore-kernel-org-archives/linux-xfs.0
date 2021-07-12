Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A471C07E9C
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58B3361152
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbhGLLQW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 07:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbhGLLQT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jul 2021 07:16:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783FCC0613DD;
        Mon, 12 Jul 2021 04:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=X1NeZeVtf+Cf6qAkIGRLNh0MOX2/K2uIrNry7FochMs=; b=hh1DzIt3D27F6QKmyRxfAeaPQr
        CoU0BqzB6EtbNeLWyFxQk/timBI9aZ4Se5ZR8iMyD0kky6r7a/MDLDCYYdETydXtumbliWk8BNFED
        fTRrrs5sM36mg9GdeEHX7v/i3vZ75tdFXt9L0g788tmaYkBAkTCPn37HtL8q5t+JUn/xpsrY3oSE0
        9qdxeW9tNnftFU5tCrvq7ltqzevjjfF2lCZpT47NTbMsVM5DIz6J9cQtPfTMmCckr2iUaTaxa37Gr
        qURzNY4D+tywtVFVe0klZP7tXDb0hvYZiR5Ykj9nIxTE4820Rnl12HWvr6y2jP7JKQyN7pyJUzvBj
        TRlm1FHA==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2ts8-00HXI2-6a; Mon, 12 Jul 2021 11:13:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs/220: avoid failure when disabling quota accounting is not supported
Date:   Mon, 12 Jul 2021 13:11:44 +0200
Message-Id: <20210712111146.82734-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712111146.82734-1-hch@lst.de>
References: <20210712111146.82734-1-hch@lst.de>
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

