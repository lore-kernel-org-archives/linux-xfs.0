Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36041 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730149AbeHAVZG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 17:25:06 -0400
From: Thomas Bianchi <thomas.bianchi8@gmail.com>
Subject: [PATCH] xfs: substitute spaces with tabs
Date: Wed,  1 Aug 2018 18:22:25 +0200
Message-Id: <1533140611-23467-1-git-send-email-thomas.bianchi8@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Thomas Bianchi <thomas.bianchi8@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org

Inside xfs_attr_shortform_list removes spaces at the beginnig of the line
and replaces with tabs.
Issue found by checkpatch.

ERROR: code indent should use tabs where possible

Signed-off-by: Thomas Bianchi <thomas.bianchi8@gmail.com>
---
 fs/xfs/xfs_attr_list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index f9ca801..a580340 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -87,7 +87,7 @@
 	 */
 	if (context->bufsize == 0 ||
 	    (XFS_ISRESET_CURSOR(cursor) &&
-             (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) {
+	     (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			context->put_listent(context,
 					     sfe->flags,
-- 
1.8.3.1

