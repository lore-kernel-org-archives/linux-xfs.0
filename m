Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47456 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728196AbeIMAcq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Sep 2018 20:32:46 -0400
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 12BEE3082A34
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 19:26:49 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF592308BE75
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 19:26:48 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: warn properly about reflink flag with and without
 -n
Message-ID: <700e2326-fd4c-224e-bf9c-cb77756e4a55@redhat.com>
Date: Wed, 12 Sep 2018 14:26:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The decision to emit a warning in fix_inode_reflink_flag seems broken; in
no-modify mode we'll do_warn that we're setting it (even though we don't),
and we'll be silent if it needs to be cleared.

Fix this so it's the standard "would" in no-modify, and "will" in regular
mode.  This also ensures that we return the proper status if flags are
found to be incorrect in -n or -e mode.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/rmap.c b/repair/rmap.c
index bffb5b61..7ef2d0fd 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1142,16 +1142,27 @@ fix_inode_reflink_flag(
 	struct xfs_dinode	*dino;
 	struct xfs_buf		*buf;
 
+	if (no_modify) {
+		if (set)
+			do_warn(
+_("would set reflink flag on inode %"PRIu64"\n"),
+				XFS_AGINO_TO_INO(mp, agno, agino));
+		else
+			do_warn(
+_("would clear reflink flag on inode %"PRIu64"\n"),
+				XFS_AGINO_TO_INO(mp, agno, agino));
+		return 0;
+	}
+
+	/* Modify mode */
 	if (set)
 		do_warn(
 _("setting reflink flag on inode %"PRIu64"\n"),
 			XFS_AGINO_TO_INO(mp, agno, agino));
-	else if (!no_modify) /* && !set */
+	else
 		do_warn(
 _("clearing reflink flag on inode %"PRIu64"\n"),
 			XFS_AGINO_TO_INO(mp, agno, agino));
-	if (no_modify)
-		return 0;
 
 	buf = get_agino_buf(mp, agno, agino, &dino);
 	if (!buf)
