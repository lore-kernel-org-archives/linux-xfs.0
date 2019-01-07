Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51295 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfAGUO7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jan 2019 15:14:59 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so2044091wmj.1
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jan 2019 12:14:58 -0800 (PST)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id j124sm3194818wmb.48.2019.01.07.12.14.56
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 12:14:56 -0800 (PST)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 5/5] xfs_metadump: Zap dev inodes
Date: Mon,  7 Jan 2019 21:13:55 +0100
Message-Id: <20190107201355.18996-6-stefanrin@gmail.com>
In-Reply-To: <20190107201355.18996-1-stefanrin@gmail.com>
References: <20190107201355.18996-1-stefanrin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Stefan Ring <stefanrin@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/db/metadump.c b/db/metadump.c
index 3994c4f4..b02e6074 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2272,6 +2272,26 @@ process_inode_data(
 	return 1;
 }
 
+static int
+process_dev_inode(
+	xfs_dinode_t		*dip)
+{
+	if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
+		if (show_warnings)
+			print_warning("inode %llu has unexpected extents",
+				      (unsigned long long)cur_ino);
+		return 0;
+	} else {
+		if (zero_stale_data) {
+			unsigned int	size = sizeof(xfs_dev_t);
+
+			memset(XFS_DFORK_DPTR(dip) + size, 0,
+					XFS_DFORK_DSIZE(dip, mp) - size);
+		}
+		return 1;
+	}
+}
+
 /*
  * when we process the inode, we may change the data in the data and/or
  * attribute fork if they are in short form and we are obfuscating names.
@@ -2324,7 +2344,15 @@ process_inode(
 		case S_IFREG:
 			success = process_inode_data(dip, TYP_DATA);
 			break;
-		default: ;
+		case S_IFIFO:
+		case S_IFCHR:
+		case S_IFBLK:
+		case S_IFSOCK:
+			success = process_dev_inode(dip);
+			need_new_crc = 1;
+			break;
+		default:
+			break;
 	}
 	nametable_clear();
 
-- 
2.19.2
