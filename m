Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51994 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbeCUDj5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:39:57 -0400
Subject: [PATCH 02/14] xfs_scrub: only run ascii name checks if unicode name
 checker
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Mar 2018 20:39:52 -0700
Message-ID: <152160359247.8288.11181593031135733955.stgit@magnolia>
In-Reply-To: <152160358015.8288.2700156777231657519.stgit@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Skip the ASCII name checks if the Unicode name checker is going to run,
since the latter covers everything that the former does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase5.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 36821d0..decda02 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -113,11 +113,11 @@ xfs_scrub_scan_dirents(
 
 	dentry = readdir(dir);
 	while (dentry) {
-		moveon = xfs_scrub_check_name(ctx, descr, _("directory"),
-				dentry->d_name);
-		if (!moveon)
-			break;
-		moveon = unicrash_check_dir_name(uc, descr, dentry);
+		if (uc)
+			moveon = unicrash_check_dir_name(uc, descr, dentry);
+		else
+			moveon = xfs_scrub_check_name(ctx, descr,
+					_("directory"), dentry->d_name);
 		if (!moveon)
 			break;
 		dentry = readdir(dir);
@@ -163,7 +163,7 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 	char				keybuf[ATTR_NAME_MAX + 1];
 	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
 	struct attrlist_ent		*ent;
-	struct unicrash			*uc;
+	struct unicrash			*uc = NULL;
 	bool				moveon = true;
 	int				i;
 	int				error;
@@ -183,11 +183,13 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 			ent = ATTR_ENTRY(attrlist, i);
 			snprintf(keybuf, ATTR_NAME_MAX, "%s.%s", attr_ns->name,
 					ent->a_name);
-			moveon = xfs_scrub_check_name(ctx, descr,
-					_("extended attribute"), keybuf);
-			if (!moveon)
-				goto out;
-			moveon = unicrash_check_xattr_name(uc, descr, keybuf);
+			if (uc)
+				moveon = unicrash_check_xattr_name(uc, descr,
+						keybuf);
+			else
+				moveon = xfs_scrub_check_name(ctx, descr,
+						_("extended attribute"),
+						keybuf);
 			if (!moveon)
 				goto out;
 		}

