Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E809C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E2D321775
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="URuqs8f+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgEIRBi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgEIRBh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:01:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F15C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=j2v9KbR3ulzFR/Y/DO39FvwM56vX9vjRgX1QtZmMbno=; b=URuqs8f+Fs3IUirztlgZvtQm1S
        GcE0+20BunJ2Z80gStsBXz8j/TPWDsVGYJIhoi2/YDiRiUMpuNhkn09Zuo5Z+v30ou9IJke4Eg2KR
        8MqVBJlC5xwWrU9qdftR5o7BbGPKMbN30HoxNsIMkOOuHhcUI+7ay+N3HezlyyTIys7I54B+dzEna
        hF5zgagyiur+SxfQFTNA2kHWz7p5kjcsbBvm3XzKQWgbIMahAUL/CM6gTO6mkEKXkhoooFVtdAyK2
        HWK2ScOyqzMboqOM30i+JAbcKSrBizBLtiOeroWRkwJ3e9JpjzQpt+ZedGUMFT+hdHwl1BUnfLTfJ
        zKxmG2Vw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSr3-00064h-DQ; Sat, 09 May 2020 17:01:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] db: cleanup attr_set_f and attr_remove_f
Date:   Sat,  9 May 2020 19:01:21 +0200
Message-Id: <20200509170125.952508-5-hch@lst.de>
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

Don't use local variables for information that is set in the da_args
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c | 67 ++++++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 39 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index 1ff2eb85..0a464983 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -67,10 +67,9 @@ attr_set_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_inode	*ip = NULL;
-	struct xfs_da_args	args = { NULL };
-	char			*name, *value, *sp;
-	int			c, valuelen = 0;
+	struct xfs_da_args	args = { };
+	char			*sp;
+	int			c;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -111,8 +110,9 @@ attr_set_f(
 
 		/* value length */
 		case 'v':
-			valuelen = (int)strtol(optarg, &sp, 0);
-			if (*sp != '\0' || valuelen < 0 || valuelen > 64*1024) {
+			args.valuelen = strtol(optarg, &sp, 0);
+			if (*sp != '\0' ||
+			    args.valuelen < 0 || args.valuelen > 64 * 1024) {
 				dbprintf(_("bad attr_set valuelen %s\n"), optarg);
 				return 0;
 			}
@@ -129,35 +129,29 @@ attr_set_f(
 		return 0;
 	}
 
-	name = argv[optind];
+	args.name = (const unsigned char *)argv[optind];
+	args.namelen = strlen(argv[optind]);
 
-	if (valuelen) {
-		value = (char *)memalign(getpagesize(), valuelen);
-		if (!value) {
-			dbprintf(_("cannot allocate buffer (%d)\n"), valuelen);
+	if (args.valuelen) {
+		args.value = memalign(getpagesize(), args.valuelen);
+		if (!args.value) {
+			dbprintf(_("cannot allocate buffer (%d)\n"),
+				args.valuelen);
 			goto out;
 		}
-		memset(value, 'v', valuelen);
-	} else {
-		value = NULL;
+		memset(args.value, 'v', args.valuelen);
 	}
 
-	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip,
+	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp,
 			&xfs_default_ifork_ops)) {
 		dbprintf(_("failed to iget inode %llu\n"),
 			(unsigned long long)iocur_top->ino);
 		goto out;
 	}
 
-	args.dp = ip;
-	args.name = (unsigned char *)name;
-	args.namelen = strlen(name);
-	args.value = value;
-	args.valuelen = valuelen;
-
 	if (libxfs_attr_set(&args)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
-			name, (unsigned long long)iocur_top->ino);
+			args.name, (unsigned long long)iocur_top->ino);
 		goto out;
 	}
 
@@ -166,10 +160,10 @@ attr_set_f(
 
 out:
 	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
-	if (ip)
-		libxfs_irele(ip);
-	if (value)
-		free(value);
+	if (args.dp)
+		libxfs_irele(args.dp);
+	if (args.value)
+		free(args.value);
 	return 0;
 }
 
@@ -178,9 +172,7 @@ attr_remove_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_inode	*ip = NULL;
-	struct xfs_da_args	args = { NULL };
-	char			*name;
+	struct xfs_da_args	args = { };
 	int			c;
 
 	if (cur_typ == NULL) {
@@ -223,23 +215,20 @@ attr_remove_f(
 		return 0;
 	}
 
-	name = argv[optind];
+	args.name = (const unsigned char *)argv[optind];
+	args.namelen = strlen(argv[optind]);
 
-	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip,
+	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp,
 			&xfs_default_ifork_ops)) {
 		dbprintf(_("failed to iget inode %llu\n"),
 			(unsigned long long)iocur_top->ino);
 		goto out;
 	}
 
-	args.dp = ip;
-	args.name = (unsigned char *)name;
-	args.namelen = strlen(name);
-	args.value = NULL;
-
 	if (libxfs_attr_set(&args)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
-			name, (unsigned long long)iocur_top->ino);
+			(unsigned char *)args.name,
+			(unsigned long long)iocur_top->ino);
 		goto out;
 	}
 
@@ -248,7 +237,7 @@ attr_remove_f(
 
 out:
 	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
-	if (ip)
-		libxfs_irele(ip);
+	if (args.dp)
+		libxfs_irele(args.dp);
 	return 0;
 }
-- 
2.26.2

