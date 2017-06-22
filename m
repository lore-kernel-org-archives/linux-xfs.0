Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753919AbdFVXpg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jun 2017 19:45:36 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 457F1142889
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2017 23:45:36 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-120-226.rdu2.redhat.com [10.10.120.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBCD177673
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2017 23:45:35 +0000 (UTC)
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH v2] xfs_db: update sector size when type is set
Date: Thu, 22 Jun 2017 18:45:35 -0500
Message-Id: <20170622234535.30942-1-billodo@redhat.com>
In-Reply-To: <20170622193352.22346-1-billodo@redhat.com>
References: <20170622193352.22346-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

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
on the wrong length for the type (when the actual sector size > BBSIZE (512)).

For types with fields, reread the buffer to pick up the correct size for
the new type when it gets set. Facilitate the reread by setting the cursor
with set_cur().

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
v2: correction to argument 3 in call to set_cur: compute and pass basic block count;
    add comment regarding conditional call to set_cur.
    

 db/io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/db/io.c b/db/io.c
index 9918a51..792cc0a 100644
--- a/db/io.c
+++ b/db/io.c
@@ -615,7 +615,13 @@ set_iocur_type(
 	const typ_t	*t)
 {
 	struct xfs_buf	*bp = iocur_top->bp;
+	int bb_count;
 
+	/* adjust cursor for types that contain fields */
+	if (t->fields) {
+		bb_count = BTOBB(byteize(fsize(t->fields, iocur_top->data, 0, 0)));
+		set_cur(t, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
+	}
 	iocur_top->typ = t;
 
 	/* verify the buffer if the type has one. */
-- 
2.9.4

