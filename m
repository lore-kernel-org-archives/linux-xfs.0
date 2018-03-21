Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:32826 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbeCUDju (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:39:50 -0400
Subject: [PATCH 01/14] xfs_scrub: avoid buffer overflow when scanning
 attributes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Mar 2018 20:39:46 -0700
Message-ID: <152160358636.8288.17415854751640340360.stgit@magnolia>
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

Avoid a buffer overflow when we're formatting extended attribute names
for name checking.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase5.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 8e0a1be..36821d0 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -143,6 +143,8 @@ static const struct xfs_attr_ns attr_ns[] = {
 	{ATTR_SECURE,		"secure"},
 	{0, NULL},
 };
+/* Enough space to handle the prefix. */
+#define ATTR_NAME_MAX		(NAME_MAX + 8)
 
 /*
  * Check all the xattr names in a particular namespace of a file handle
@@ -158,7 +160,7 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 {
 	struct attrlist_cursor		cur;
 	char				attrbuf[XFS_XATTR_LIST_MAX];
-	char				keybuf[NAME_MAX + 1];
+	char				keybuf[ATTR_NAME_MAX + 1];
 	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
 	struct attrlist_ent		*ent;
 	struct unicrash			*uc;
@@ -172,14 +174,14 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 
 	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
 	memset(&cur, 0, sizeof(cur));
-	memset(keybuf, 0, NAME_MAX + 1);
+	memset(keybuf, 0, ATTR_NAME_MAX + 1);
 	error = attr_list_by_handle(handle, sizeof(*handle), attrbuf,
 			XFS_XATTR_LIST_MAX, attr_ns->flags, &cur);
 	while (!error) {
 		/* Examine the xattrs. */
 		for (i = 0; i < attrlist->al_count; i++) {
 			ent = ATTR_ENTRY(attrlist, i);
-			snprintf(keybuf, NAME_MAX, "%s.%s", attr_ns->name,
+			snprintf(keybuf, ATTR_NAME_MAX, "%s.%s", attr_ns->name,
 					ent->a_name);
 			moveon = xfs_scrub_check_name(ctx, descr,
 					_("extended attribute"), keybuf);

