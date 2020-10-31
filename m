Return-Path: <SRS0=wlCw=EG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DDE2C388F7
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Oct 2020 08:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E29102074F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Oct 2020 08:26:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="Yxwcz/d6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgJaI0O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 31 Oct 2020 04:26:14 -0400
Received: from m15112.mail.126.com ([220.181.15.112]:49739 "EHLO
        m15112.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgJaI0N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 31 Oct 2020 04:26:13 -0400
X-Greylist: delayed 1832 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Oct 2020 04:26:12 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=wGiJ91nQrq2RZ4Nqah
        xgfPZnGI/70abhkimlokyd5ak=; b=Yxwcz/d66BbgGbt5mr+CodaXtzrCks360d
        QXKWTiVSmdlNE4N0B/kiYWb3e9e/Wcj4cUIGzvA6oemGgsnarbPxWROWJz91kwne
        ojIm092BxRn0CM3huu40U/Kd/TEKskzSXzFDqj7Q46VVtIiYIgvaZ9mgjHmszLX/
        MFu71E/sc=
Received: from localhost.localdomain (unknown [211.138.116.176])
        by smtp2 (Coremail) with SMTP id DMmowADn7vplGJ1fwqpLIg--.34999S2;
        Sat, 31 Oct 2020 15:55:18 +0800 (CST)
From:   Fengfei Xi <fengfei_xi@126.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengfei Xi <fengfei_xi@126.com>
Subject: [PATCH] xfs: fix the comment of function xfs_buf_free_maps
Date:   Sat, 31 Oct 2020 15:55:15 +0800
Message-Id: <1604130915-5025-1-git-send-email-fengfei_xi@126.com>
X-Mailer: git-send-email 1.9.1
X-CM-TRANSID: DMmowADn7vplGJ1fwqpLIg--.34999S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU93kuUUUUU
X-Originating-IP: [211.138.116.176]
X-CM-SenderInfo: pihqwwxhlb5xa6rslhhfrp/1tbi2QfOklpEARp5qQAAsX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix the inappropriate comment to help people to understad the code

Signed-off-by: Fengfei Xi <fengfei_xi@126.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4e4cf91..f8bf00b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -198,7 +198,7 @@
 }
 
 /*
- *	Frees b_pages if it was allocated.
+ *	Frees b_maps if it was allocated.
  */
 static void
 xfs_buf_free_maps(
-- 
1.9.1

