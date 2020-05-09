Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B450C47257
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F376B21775
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t/Y7Bssq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgEIRBk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgEIRBk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:01:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DDFC061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mI4yRtbyupMbzDf+FbwyG2oAE7P425sTEpoDjmEtgpE=; b=t/Y7BssqkAPVKTWwO33eSlM6X1
        xsQXgycyWbkllkFkQk4R6hprmaMHpg2iPJVm8KSZ0URLhbVTuwpWAl+o0XF7HleQHNAfFem07dD9X
        67vbl/wtEp7Ixn+Z71C4cCA3Dz62MrOagpDRUBrVtg4s2Eplv+lFbr6oNwUmNUAoSQXUM6o+Ncrwm
        XtmW9vVtj/z/i5G8PdLxE8Xxvy3qEqAfbzah+Dcqwwlf5AkT9NLMR5kjKAZjgr5lvJqCHxgOmXei+
        12VDAwKmT3YyNvVNDeY01LIJmCRckONZDsl8cVGmH7f89qSh/GvB0fd2wVuKb1bbvNk/FBRBL6ab0
        T1NJ1D1w==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSr5-000656-SA; Sat, 09 May 2020 17:01:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] db: validate name and namelen in attr_set_f and attr_remove_f
Date:   Sat,  9 May 2020 19:01:22 +0200
Message-Id: <20200509170125.952508-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509170125.952508-1-hch@lst.de>
References: <20200509170125.952508-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

libxfs has stopped validating these parameters internally, so do it
in the xfs_db commands.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/db/attrset.c b/db/attrset.c
index 0a464983..e3575271 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -130,7 +130,16 @@ attr_set_f(
 	}
 
 	args.name = (const unsigned char *)argv[optind];
+	if (!args.name) {
+		dbprintf(_("invalid name\n"));
+		return 0;
+	}
+
 	args.namelen = strlen(argv[optind]);
+	if (args.namelen >= MAXNAMELEN) {
+		dbprintf(_("name too long\n"));
+		return 0;
+	}
 
 	if (args.valuelen) {
 		args.value = memalign(getpagesize(), args.valuelen);
@@ -216,7 +225,16 @@ attr_remove_f(
 	}
 
 	args.name = (const unsigned char *)argv[optind];
+	if (!args.name) {
+		dbprintf(_("invalid name\n"));
+		return 0;
+	}
+
 	args.namelen = strlen(argv[optind]);
+	if (args.namelen >= MAXNAMELEN) {
+		dbprintf(_("name too long\n"));
+		return 0;
+	}
 
 	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp,
 			&xfs_default_ifork_ops)) {
-- 
2.26.2

