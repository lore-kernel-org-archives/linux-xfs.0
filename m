Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35164 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbeDKA1j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Apr 2018 20:27:39 -0400
Date: Tue, 10 Apr 2018 17:27:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 01/14] xfs_scrub: avoid buffer overflow when scanning
 attributes
Message-ID: <20180411002734.GU7500@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
 <152160358636.8288.17415854751640340360.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152160358636.8288.17415854751640340360.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Avoid a buffer overflow when we're formatting extended attribute names
for name checking.  The kernel headers provide us with XATTR_NAME_MAX,
so we can rely on that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: use XATTR_NAME_MAX per Eric Sandeen's suggestion
---
 scrub/phase5.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scrub/phase5.c b/scrub/phase5.c
index 5f2a1a7..e0e7e8c 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -158,7 +158,7 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 {
 	struct attrlist_cursor		cur;
 	char				attrbuf[XFS_XATTR_LIST_MAX];
-	char				keybuf[NAME_MAX + 1];
+	char				keybuf[XATTR_NAME_MAX + 1];
 	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
 	struct attrlist_ent		*ent;
 	struct unicrash			*uc;
@@ -172,14 +172,14 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 
 	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
 	memset(&cur, 0, sizeof(cur));
-	memset(keybuf, 0, NAME_MAX + 1);
+	memset(keybuf, 0, XATTR_NAME_MAX + 1);
 	error = attr_list_by_handle(handle, sizeof(*handle), attrbuf,
 			XFS_XATTR_LIST_MAX, attr_ns->flags, &cur);
 	while (!error) {
 		/* Examine the xattrs. */
 		for (i = 0; i < attrlist->al_count; i++) {
 			ent = ATTR_ENTRY(attrlist, i);
-			snprintf(keybuf, NAME_MAX, "%s.%s", attr_ns->name,
+			snprintf(keybuf, XATTR_NAME_MAX, "%s.%s", attr_ns->name,
 					ent->a_name);
 			moveon = xfs_scrub_check_name(ctx, descr,
 					_("extended attribute"), keybuf);
