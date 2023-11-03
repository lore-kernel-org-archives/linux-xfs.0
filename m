Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D78C0018A
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Nov 2023 16:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344957AbjKCQCW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Nov 2023 12:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345028AbjKCQCW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2023 12:02:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D154133
        for <linux-xfs@vger.kernel.org>; Fri,  3 Nov 2023 09:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=vkgTMRmKtlcckxbO4JTe89Ar1QSdKCR5cqVz2QuMCj8=; b=an8UXcml6lRzm3juD20hp6pFSa
        DmXmqGjjiIstiidFJ22117EPuBmJ+Hh7QPgDsDQ7m/ZEEakQ5iid0v1Ehryilb6j+Dt1oEjyEjHD7
        dXyLNtiRFApjQAs4v5/wxmGh+A0wZNCXLTpydkMum6ngsXxKPDAWUlYU6p+58GDKyMn5ascejcjM3
        ln0XQBqN0O3JNKssygnQeCvfytFajqD06uJaZ2C6AfH2ofkOGnJzaKdZ90eBM2vjHQPfEAal6RV6j
        KawEIGNJ9Hi4TQwHgzy7BB70B+SSr7p0FJySjgKDt/bdiPSR1p++UaxtijsowFtyDtNd3aQ3IVY9C
        9MryVMEw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qywcg-00BkIX-2I
        for linux-xfs@vger.kernel.org;
        Fri, 03 Nov 2023 16:02:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] db: fix unsigned char related warnings
Date:   Fri,  3 Nov 2023 17:02:10 +0100
Message-Id: <20231103160210.548636-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Clean up the code in hash.c to use the normal char type for all
high-level code, only casting to uint8_t when calling into low-level
code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/hash.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/db/hash.c b/db/hash.c
index 716da88ba..05a94f249 100644
--- a/db/hash.c
+++ b/db/hash.c
@@ -65,16 +65,15 @@ hash_f(
 	}
 
 	for (c = optind; c < argc; c++) {
-		if (use_dir2_hash) {
-			struct xfs_name	xname = {
-				.name	= (uint8_t *)argv[c],
-				.len	= strlen(argv[c]),
-			};
+		struct xfs_name	xname = {
+			.name	= (uint8_t *)argv[c],
+			.len	= strlen(argv[c]),
+		};
 
+		if (use_dir2_hash)
 			hashval = libxfs_dir2_hashname(mp, &xname);
-		} else {
-			hashval = libxfs_da_hashname(argv[c], strlen(argv[c]));
-		}
+		else
+			hashval = libxfs_da_hashname(xname.name, xname.len);
 		dbprintf("0x%x\n", hashval);
 	}
 
@@ -103,7 +102,7 @@ struct name_dup {
 	struct name_dup	*next;
 	uint32_t	crc;
 	uint8_t		namelen;
-	uint8_t		name[];
+	char		name[];
 };
 
 static inline size_t
@@ -175,7 +174,7 @@ dup_table_free(
 static struct name_dup *
 dup_table_find(
 	struct dup_table	*tab,
-	unsigned char		*name,
+	char			*name,
 	size_t			namelen)
 {
 	struct name_dup		*ent;
@@ -197,7 +196,7 @@ dup_table_find(
 static int
 dup_table_store(
 	struct dup_table	*tab,
-	unsigned char		*name,
+	char			*name,
 	size_t			namelen)
 {
 	struct name_dup		*dup;
@@ -209,7 +208,7 @@ dup_table_store(
 		int		ret;
 
 		do {
-			ret = find_alternate(namelen, name, seq++);
+			ret = find_alternate(namelen, (uint8_t *)name, seq++);
 		} while (ret == 0);
 		if (ret < 0)
 			return EEXIST;
@@ -231,15 +230,15 @@ dup_table_store(
 static int
 collide_dirents(
 	unsigned long		nr,
-	const unsigned char	*name,
+	char			*name,
 	size_t			namelen,
 	int			fd)
 {
 	struct xfs_name		dname = {
-		.name		= name,
+		.name		= (uint8_t *)name,
 		.len		= namelen,
 	};
-	unsigned char		direntname[MAXNAMELEN + 1];
+	char			direntname[MAXNAMELEN + 1];
 	struct dup_table	*tab = NULL;
 	xfs_dahash_t		old_hash;
 	unsigned long		i;
@@ -268,10 +267,10 @@ collide_dirents(
 			return error;
 	}
 
-	dname.name = direntname;
+	dname.name = (uint8_t *)direntname;
 	for (i = 0; i < nr; i++) {
 		strncpy(direntname, name, MAXNAMELEN);
-		obfuscate_name(old_hash, namelen, direntname, true);
+		obfuscate_name(old_hash, namelen, (uint8_t *)direntname, true);
 		ASSERT(old_hash == libxfs_dir2_hashname(mp, &dname));
 
 		if (fd >= 0) {
@@ -297,17 +296,17 @@ collide_dirents(
 static int
 collide_xattrs(
 	unsigned long		nr,
-	const unsigned char	*name,
+	char			*name,
 	size_t			namelen,
 	int			fd)
 {
-	unsigned char		xattrname[MAXNAMELEN + 5];
+	char			xattrname[MAXNAMELEN + 5];
 	struct dup_table	*tab = NULL;
 	xfs_dahash_t		old_hash;
 	unsigned long		i;
 	int			error;
 
-	old_hash = libxfs_da_hashname(name, namelen);
+	old_hash = libxfs_da_hashname((uint8_t *)name, namelen);
 
 	if (fd >= 0) {
 		/*
@@ -330,8 +329,10 @@ collide_xattrs(
 
 	for (i = 0; i < nr; i++) {
 		snprintf(xattrname, MAXNAMELEN + 5, "user.%s", name);
-		obfuscate_name(old_hash, namelen, xattrname + 5, false);
-		ASSERT(old_hash == libxfs_da_hashname(xattrname + 5, namelen));
+		obfuscate_name(old_hash, namelen, (uint8_t *)xattrname + 5,
+				false);
+		ASSERT(old_hash == libxfs_da_hashname((uint8_t *)xattrname + 5,
+				namelen));
 
 		if (fd >= 0) {
 			error = fsetxattr(fd, xattrname, "1", 1, 0);
-- 
2.39.2

