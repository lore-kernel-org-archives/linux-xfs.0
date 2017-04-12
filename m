Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40768 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751992AbdDLDyQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 23:54:16 -0400
Subject: [PATCH] xfs_db: set buf flag for inode or dqblk with "type"
References: <20170411225334.GE8502@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d7c0fbec-5229-3d69-a435-a68e76ada593@sandeen.net>
Date: Tue, 11 Apr 2017 22:54:15 -0500
MIME-Version: 1.0
In-Reply-To: <20170411225334.GE8502@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Currently, setting "type" to inode or dqblk does not
appropriately set the buffer type flags for these
types.  i.e.:

xfs_db> inode 128

sets ino_buf, but

xfs_db> convert inode 128 fsblock
0x10 (16)
xfs_db> fsblock 16
xfs_db> type inode

does not.  This is apparent if we try to use "type" to
switch to an inode or dqblk, then try to use "write -d"
which tests these flags.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/io.c b/db/io.c
index 9918a51..d78fc66 100644
--- a/db/io.c
+++ b/db/io.c
@@ -617,6 +617,13 @@ set_iocur_type(
 	struct xfs_buf	*bp = iocur_top->bp;
 
 	iocur_top->typ = t;
+	iocur_top->ino_buf = 0;
+	iocur_top->dquot_buf  = 0;
+
+	if (t->typnm == TYP_INODE)
+		iocur_top->ino_buf = 1;
+	else if (t->typnm == TYP_DQBLK)
+		iocur_top->dquot_buf = 1;
 
 	/* verify the buffer if the type has one. */
 	if (!bp)


