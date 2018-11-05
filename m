Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33842 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387865AbeKFGyX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 01:54:23 -0500
Received: by mail-wm1-f65.google.com with SMTP id f1-v6so7321162wmg.1
        for <linux-xfs@vger.kernel.org>; Mon, 05 Nov 2018 13:32:42 -0800 (PST)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id x18-v6sm38861711wrs.50.2018.11.05.13.32.40
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Nov 2018 13:32:40 -0800 (PST)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 5/5] xfs_metadump: Zap dev inodes
Date: Mon,  5 Nov 2018 22:31:45 +0100
Message-Id: <20181105213145.7560-6-stefanrin@gmail.com>
In-Reply-To: <20181105213145.7560-1-stefanrin@gmail.com>
References: <20181105213145.7560-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Stefan Ring <stefanrin@gmail.com>
---
 db/metadump.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/db/metadump.c b/db/metadump.c
index 59765263..57d6bc09 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2269,6 +2269,25 @@ process_inode_data(
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
@@ -2321,7 +2340,15 @@ process_inode(
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
2.14.5
