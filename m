Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44080 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbfACTP7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jan 2019 14:15:59 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5967563816
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jan 2019 19:15:59 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E8B95D6A6
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jan 2019 19:15:59 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: allow '/' in attribute names
Message-ID: <1c673348-0244-89ff-5b3c-545ee3e458e4@redhat.com>
Date: Thu, 3 Jan 2019 13:15:56 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

For some reason, since the earliest days of XFS, a '/' character
in an extended attribute name has been treated as corruption by
xfs_repair.  This despite nothing in other userspace tools or the
kernel having this restriction.

My best guess is that this was an unintentional leftover from
common code between dirs & attrs in the "da" code, and there has
never been a good reason for it.

Since userspace and kernelspace allow such a name to be set,
listed, and read, it seems wrong to flag it as corruption.
So, make this test conditional on whether we're validating a name
in a dir, as opposed to the name of an attr.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 1d04500..2f6f7ef 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -292,11 +292,9 @@ process_shortform_attr(
 			}
 		}
 
-		/* namecheck checks for / and null terminated for file names.
-		 * attributes names currently follow the same rules.
-		*/
+		/* namecheck checks for null chars in attr names. */
 		if (namecheck((char *)&currententry->nameval[0],
-						currententry->namelen))  {
+						currententry->namelen, false)) {
 			do_warn(
 	_("entry contains illegal character in shortform attribute name\n"));
 			junkit = 1;
@@ -459,7 +457,7 @@ process_leaf_attr_local(
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
 	if (local->namelen == 0 || namecheck((char *)&local->nameval[0],
-							local->namelen)) {
+						     local->namelen, false)) {
 		do_warn(
 	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
 			i, da_bno, ino, local->namelen);
@@ -514,7 +512,7 @@ process_leaf_attr_remote(
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
 
 	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0],
-						remotep->namelen) ||
+						remotep->namelen, false) ||
 			be32_to_cpu(entry->hashval) !=
 				libxfs_da_hashname((unsigned char *)&remotep->name[0],
 						remotep->namelen) ||
diff --git a/repair/da_util.c b/repair/da_util.c
index 1450767..1f6568e 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -13,20 +13,25 @@
 #include "da_util.h"
 
 /*
- * takes a name and length (name need not be null-terminated)
- * and returns 1 if the name contains a '/' or a \0, returns 0
- * otherwise
+ * takes a name and length (name need not be null-terminated) and whether
+ * we are checking a dir (vs an attr), and returns 1 if the direntry contains
+ * a '/', or if anything contains a \0, and returns 0 otherwise
  */
 int
-namecheck(char *name, int length)
+namecheck(
+	char	*name,
+	int	length,
+	bool	isadir)
 {
-	char *c;
-	int i;
+	char	*c;
+	int	i;
 
 	ASSERT(length < MAXNAMELEN);
 
 	for (c = name, i = 0; i < length; i++, c++) {
-		if (*c == '/' || *c == '\0')
+		if (isadir && *c == '/')
+			return 0;
+		if (*c == '\0')
 			return 1;
 	}
 
diff --git a/repair/da_util.h b/repair/da_util.h
index d36dfd0..041dff7 100644
--- a/repair/da_util.h
+++ b/repair/da_util.h
@@ -27,7 +27,8 @@ typedef struct da_bt_cursor {
 int
 namecheck(
 	char		*name,
-	int		length);
+	int		length,
+	bool		isadir);
 
 struct xfs_buf *
 da_read_buf(
diff --git a/repair/dir2.c b/repair/dir2.c
index ba5763e..6d592d6 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -310,7 +310,7 @@ _("entry #%d %s in shortform dir %" PRIu64),
 		 * the length value is stored in a byte
 		 * so it can't be too big, it can only wrap
 		 */
-		if (namecheck((char *)&sfep->name[0], namelen))  {
+		if (namecheck((char *)&sfep->name[0], namelen, true))  {
 			/*
 			 * junk entry
 			 */
@@ -781,7 +781,7 @@ _("\twould clear inode number in entry at offset %" PRIdPTR "...\n"),
 		 * during phase 4.
 		 */
 		junkit = dep->name[0] == '/';
-		nm_illegal = namecheck((char *)dep->name, dep->namelen);
+		nm_illegal = namecheck((char *)dep->name, dep->namelen, true);
 		if (ino_discovery && nm_illegal) {
 			do_warn(
 _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64 " has illegal name \"%*.*s\": "),
