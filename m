Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751147AbdFVTdz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jun 2017 15:33:55 -0400
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH] xfs_db: update sector size when type is set
Date: Thu, 22 Jun 2017 14:33:52 -0500
Message-Id: <20170622193352.22346-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net

xfs_db doesn't take sector size into account when setting type.
This can result in an errant crc. For example, with a sector size
of 4096:

xfs_db> agi 0
xfs_db> p crc
crc = 0xab85043e (correct)
xfs_db> daddr
current daddr is 16
xfs_db> daddr 42
xfs_db> daddr 16
xfs_db> type agi
Metadata CRC error detected at xfs_agi block 0x10/0x200
xfs_db> p crc
crc = 0xab85043e (bad)

When xfs_db sets the new daddr in daddr_f, it does so with one
BBSIZE sector (512). Changing the type doesn't change the size
of the current buffer in iocur_top, so the checksum is calculated
on the wrong length for the type (when the actual sector size > BBSIZE (512).

For types with fields, reread the buffer to pick up the correct size for
the new type when it gets set. Facilitate the reread by setting the cursor
with set_cur().

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 db/io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/db/io.c b/db/io.c
index 9918a51..7e6d330 100644
--- a/db/io.c
+++ b/db/io.c
@@ -616,6 +616,12 @@ set_iocur_type(
 {
 	struct xfs_buf	*bp = iocur_top->bp;
 
+	if (t->fields)
+		set_cur(t,
+			iocur_top->bb,
+			fsize(t->fields, iocur_top->data,
+			      0, 0) / mp->m_sb.sb_blocksize,
+			DB_RING_IGN, NULL);
 	iocur_top->typ = t;
 
 	/* verify the buffer if the type has one. */
-- 
2.9.4

