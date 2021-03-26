Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C2BC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 12:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F7D9619B8
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 12:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhCZMut (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 08:50:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:57742 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229906AbhCZMuS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Mar 2021 08:50:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616763017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=LcQKnD/N1xLIrOYWIKuGGiUHktDU105b6yOF9qPrTYc=;
        b=V1rIXiTkNk+PsxDhPpV3aKIbSSdrh7d7ivJwK8tAQCkCVo8uXfxaWP6MNAmb1g1O/G9O4a
        RoMdGoBM5QdooH8tYItvAR6cg7O64OU0zGmhlKsMbpbjLhICq8JBHz7RKFmcSy5gut+7dq
        GafVk9j61zQy7X7mW9KYtlErXA1uwOc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7EC73ADD7
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 12:50:17 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfsprogs: remove BMV_IF_NO_DMAPI_READ flag
Date:   Fri, 26 Mar 2021 13:53:21 +0100
Message-Id: <20210326125321.28047-3-ailiop@suse.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use of the flag has had no effect since kernel commit 288699fecaff
("xfs: drop dmapi hooks"), which removed all dmapi related code, so
remove it from bmap.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 io/bmap.c           | 28 +++++++---------------------
 man/man8/xfs_bmap.8 |  9 ---------
 po/de.po            |  3 ---
 po/pl.po            |  3 ---
 scrub/filemap.c     |  3 +--
 5 files changed, 8 insertions(+), 38 deletions(-)

diff --git a/io/bmap.c b/io/bmap.c
index f838840eb533..27383ca60375 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -33,7 +33,6 @@ bmap_help(void)
 " -a -- prints the attribute fork map instead of the data fork.\n"
 " -c -- prints the copy-on-write fork map instead of the data fork.\n"
 "       This works only if the kernel was compiled in debug mode.\n"
-" -d -- suppresses a DMAPI read event, offline portions shown as holes.\n"
 " -e -- print delayed allocation extents.\n"
 " -l -- also displays the length of each extent in 512-byte blocks.\n"
 " -n -- query n extents.\n"
@@ -67,7 +66,7 @@ bmap_f(
 	int			c;
 	int			egcnt;
 
-	while ((c = getopt(argc, argv, "acdeln:pv")) != EOF) {
+	while ((c = getopt(argc, argv, "aceln:pv")) != EOF) {
 		switch (c) {
 		case 'a':	/* Attribute fork. */
 			bmv_iflags |= BMV_IF_ATTRFORK;
@@ -86,10 +85,6 @@ bmap_f(
 		case 'n':	/* number of extents specified */
 			nflag = atoi(optarg);
 			break;
-		case 'd':
-		/* do not recall possibly offline DMAPI files */
-			bmv_iflags |= BMV_IF_NO_DMAPI_READ;
-			break;
 		case 'p':
 		/* report unwritten preallocated blocks */
 			pflag = 1;
@@ -103,7 +98,7 @@ bmap_f(
 		}
 	}
 	if (aflag || cflag)
-		bmv_iflags &= ~(BMV_IF_PREALLOC|BMV_IF_NO_DMAPI_READ);
+		bmv_iflags &= ~BMV_IF_PREALLOC;
 
 	if (vflag) {
 		c = -xfrog_geometry(file->fd, &fsgeo);
@@ -154,19 +149,10 @@ bmap_f(
  *	EINVAL, check the length with fstat() and return "no extents"
  *	if the length == 0.
  *
- *	Why not do the xfsctl(FS_IOC_FSGETXATTR[A]) first?  Two reasons:
- *	(1)	The extent count may be wrong for a file with delayed
- *		allocation blocks.  The XFS_IOC_GETBMAPX forces the real
- *		allocation and fixes up the extent count.
- *	(2)	For XFS_IOC_GETBMAP[X] on a DMAPI file that has been moved
- *		offline by a DMAPI application (e.g., DMF) the
- *		FS_IOC_FSGETXATTR only reflects the extents actually online.
- *		Doing XFS_IOC_GETBMAPX call first forces that data blocks online
- *		and then everything proceeds normally (see PV #545725).
- *
- *		If you don't want this behavior on a DMAPI offline file,
- *		try the "-d" option which sets the BMV_IF_NO_DMAPI_READ
- *		iflag for XFS_IOC_GETBMAPX.
+ *	Why not do the xfsctl(FS_IOC_FSGETXATTR[A]) first?
+ *	The extent count may be wrong for a file with delayed
+ *	allocation blocks.  The XFS_IOC_GETBMAPX forces the real
+ *	allocation and fixes up the extent count.
  */
 
 	do {	/* loop a miximum of two times */
@@ -441,7 +427,7 @@ bmap_init(void)
 	bmap_cmd.argmin = 0;
 	bmap_cmd.argmax = -1;
 	bmap_cmd.flags = CMD_NOMAP_OK;
-	bmap_cmd.args = _("[-adlpv] [-n nx]");
+	bmap_cmd.args = _("[-acelpv] [-n nx]");
 	bmap_cmd.oneline = _("print block mapping for an XFS file");
 	bmap_cmd.help = bmap_help;
 
diff --git a/man/man8/xfs_bmap.8 b/man/man8/xfs_bmap.8
index dd925b12dbd4..9ec7f52b84f2 100644
--- a/man/man8/xfs_bmap.8
+++ b/man/man8/xfs_bmap.8
@@ -36,15 +36,6 @@ no matter what the filesystem's block size is.
 If this option is specified, information about the file's
 attribute fork is printed instead of the default data fork.
 .TP
-.B \-d
-If portions of the file have been migrated offline by
-a DMAPI application, a DMAPI read event will be generated to
-bring those portions back online before the disk block map is
-printed.  However if the
-.B \-d
-option is used, no DMAPI read event will be generated for a
-DMAPI file and offline portions will be reported as holes.
-.TP
 .B \-e
 If this option is used,
 .B xfs_bmap
diff --git a/po/de.po b/po/de.po
index aa9af769ab89..944b0e91deb2 100644
--- a/po/de.po
+++ b/po/de.po
@@ -4670,7 +4670,6 @@ msgid ""
 " Holes are marked by replacing the startblock..endblock with 'hole'.\n"
 " All the file offsets and disk blocks are in units of 512-byte blocks.\n"
 " -a -- prints the attribute fork map instead of the data fork.\n"
-" -d -- suppresses a DMAPI read event, offline portions shown as holes.\n"
 " -l -- also displays the length of each extent in 512-byte blocks.\n"
 " Note: the bmap for non-regular files can be obtained provided the file\n"
 " was opened appropriately (in particular, must be opened read-only).\n"
@@ -4694,8 +4693,6 @@ msgstr ""
 " Alle Datei-Offsets und Plattenblöcke sind Einheiten aus 512-Byte-Blöcken.\n"
 " -a -- gibt die Attributs-Verzweigungs-Karte statt der\n"
 "       Daten-Verzweigung aus.\n"
-" -d -- unterdrückt ein DMAPI-Lese-Ereignis, Offline-Teile werden als Löcher\n"
-"       betrachtet.\n"
 " -l -- zeigt außerdem die Länge von jedem Bereich in 512-Byte Blöcken.\n"
 " Anmerkung: Das »bmap« für irreguläre Dateien kann bereitgestellt werden,\n"
 " statt der Datei die passend geöffnet wurde (im Einzelnen darf sie\n"
diff --git a/po/pl.po b/po/pl.po
index cf9d2e8edac9..e5a1aad8307e 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -6252,7 +6252,6 @@ msgid ""
 " -a -- prints the attribute fork map instead of the data fork.\n"
 " -c -- prints the copy-on-write fork map instead of the data fork.\n"
 "       This works only if the kernel was compiled in debug mode.\n"
-" -d -- suppresses a DMAPI read event, offline portions shown as holes.\n"
 " -e -- print delayed allocation extents.\n"
 " -l -- also displays the length of each extent in 512-byte blocks.\n"
 " -n -- query n extents.\n"
@@ -6278,8 +6277,6 @@ msgstr ""
 " Wszystkie offsety w plikach i bloki dysku są w jednostkach 512-bajtowych.\n"
 " -a - wypisanie mapy gałęzi atrybutów zamiast gałęzi danych.\n"
 " -c - wypisanie mapy gałęzi CoW zamiast gałęzi danych.\n"
-" -d - pominięcie zdarzenia odczytu DMAPI, pokazanie części offline jako "
-"dziur.\n"
 " -e - wypisanie ekstentów opóźnionego przydzielania.\n"
 " -l - wyświetlenie także długości każdego ekstentu w 512-bajtowych blokach.\n"
 " -n - odpytanie n ekstentów.\n"
diff --git a/scrub/filemap.c b/scrub/filemap.c
index 0b914ef6017a..d4905ace659e 100644
--- a/scrub/filemap.c
+++ b/scrub/filemap.c
@@ -55,8 +55,7 @@ scrub_iterate_filemaps(
 		map->bmv_length = ULLONG_MAX;
 	else
 		map->bmv_length = BTOBB(key->bm_length);
-	map->bmv_iflags = BMV_IF_NO_DMAPI_READ | BMV_IF_PREALLOC |
-			  BMV_IF_NO_HOLES;
+	map->bmv_iflags = BMV_IF_PREALLOC | BMV_IF_NO_HOLES;
 	switch (whichfork) {
 	case XFS_ATTR_FORK:
 		getxattr_type = XFS_IOC_FSGETXATTRA;
-- 
2.31.0

