Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36086 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751639AbdGRBvO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jul 2017 21:51:14 -0400
Subject: [PATCH V2] xfs_db: properly set inode type
References: <e6c83eea-af29-c01b-752e-e049e8fdc69f@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c17ce413-430e-acce-e63d-51fd1b684f62@sandeen.net>
Date: Mon, 17 Jul 2017 20:51:13 -0500
MIME-Version: 1.0
In-Reply-To: <e6c83eea-af29-c01b-752e-e049e8fdc69f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

When we set the type to "inode" the verifier may validate multiple
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

V2: Warn if the daddr given was reset to an inode-aligned
address

diff --git a/db/io.c b/db/io.c
index b046c8d..4153da0 100644
--- a/db/io.c
+++ b/db/io.c
@@ -616,6 +616,22 @@ set_iocur_type(
 {
 	struct xfs_buf	*bp = iocur_top->bp;
 
+	/* Inodes are special; verifier checks all inodes in the buffer */
+	if (type->typnm == TYP_INODE) {
+		xfs_daddr_t	b = iocur_top->bb;
+		xfs_ino_t	ino;
+
+		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
+			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
+			(mp->m_sb.sb_agblocks << mp->m_sb.sb_inopblog));
+		set_cur_inode(ino);
+		if (iocur_top->bb != b)
+			dbprintf(
+_("cursor set to nearest inode %llu at daddr %lld\n"),
+				 ino, iocur_top->bb);
+		return;
+	}
+
 	/* adjust buffer size for types with fields & hence fsize() */
 	if (type->fields) {
 		int bb_count;	/* type's size in basic blocks */

