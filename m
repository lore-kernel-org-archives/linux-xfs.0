Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754146AbdF1AQl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jun 2017 20:16:41 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9BBD1334594
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2017 00:16:40 +0000 (UTC)
Received: from Liberator-5.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5339B85C5B
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2017 00:16:40 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_db: properly set inode type
Message-ID: <e6c83eea-af29-c01b-752e-e049e8fdc69f@redhat.com>
Date: Tue, 27 Jun 2017 19:16:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

When we set the type to "inode" the verifier validates multiple
inodes in the current fs block, so setting the buffer size to
that of just one inode is not sufficient and it'll emit spurious
verifier errors for all but the first, as we read off the end:

xfs_db> daddr 99
xfs_db> type inode
Metadata corruption detected at xfs_inode block 0x63/0x200
Metadata corruption detected at xfs_inode block 0x63/0x200
Metadata corruption detected at xfs_inode block 0x63/0x200
Metadata corruption detected at xfs_inode block 0x63/0x200
Metadata corruption detected at xfs_inode block 0x63/0x200
Metadata corruption detected at xfs_inode block 0x63/0x200
Metadata corruption detected at xfs_inode block 0x63/0x200

Use the special set_cur_inode() function for this purpose
as is done in inode_f().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/io.c b/db/io.c
index b97b710..655a978 100644
--- a/db/io.c
+++ b/db/io.c
@@ -618,6 +618,18 @@ set_iocur_type(
 	struct xfs_buf	*bp = iocur_top->bp;
 	int bb_count;
 
+	/* Inodes are special; verifier checks all inodes in the buffer */
+	if (t->typnm == TYP_INODE) {
+		xfs_daddr_t	b = iocur_top->bb;
+		xfs_ino_t	ino;
+
+		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
+			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
+			(mp->m_sb.sb_agblocks << mp->m_sb.sb_inopblog));
+		set_cur_inode(ino);
+		return;
+	}
+
 	/* adjust cursor for types that contain fields */
 	if (t->fields) {
 		bb_count = BTOBB(byteize(fsize(t->fields, iocur_top->data, 0, 0)));

