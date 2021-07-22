Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F885C6377D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10EB56128C
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhGVHBu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 03:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhGVHBu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 03:01:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3351C061575;
        Thu, 22 Jul 2021 00:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=H/HzHUbup5jN6v9nUb2oFbvAvzEYXDSXOMVKgeh6kZA=; b=cQVF+GCtm7Kgc4OeA/U/3dbyC6
        fjXeYXSvI4Nc5Due8aoP5mV34fYHZMGTu4EBmEuO9KAP9sutunDOvo9j/G+q2mb4pQnC/fGQIUzwK
        IfOkMxBa8CjUW0gcJ/plr94vZL4PsuWONDCAiVaEm/q9hrbAAzywVCuGmo+7Ypljl9P5xDslE+Ktr
        kR/h0+rOzuQYcTaCtbPa2NAkOQqZXJMG/gn/4QVhcP2NknvwymJUFWcvsTfG8L46FlYjzLTlhy7pg
        GJUknean7oHwCBjwUxLtsifZjX5EGv83+G+Bk/5oF9cuDaWg6NFOuKjVs/M3TycxiSxVku4yWmCJC
        Pd7gde8g==;
Received: from [2001:4bb8:193:7660:643c:9899:473:314a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6TKs-00A0be-Nx; Thu, 22 Jul 2021 07:41:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 6/7] xfs/305: don't turn quota accounting off
Date:   Thu, 22 Jul 2021 09:38:31 +0200
Message-Id: <20210722073832.976547-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210722073832.976547-1-hch@lst.de>
References: <20210722073832.976547-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

