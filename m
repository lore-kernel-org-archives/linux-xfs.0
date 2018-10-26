Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f52.google.com ([209.85.128.52]:39903 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727636AbeJ0E6m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Oct 2018 00:58:42 -0400
Received: by mail-wm1-f52.google.com with SMTP id y144-v6so2532307wmd.4
        for <linux-xfs@vger.kernel.org>; Fri, 26 Oct 2018 13:20:17 -0700 (PDT)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id 193-v6sm7669219wmj.21.2018.10.26.13.20.14
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Oct 2018 13:20:15 -0700 (PDT)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 5/5] xfs_metadump: Zap dev inodes
Date: Fri, 26 Oct 2018 22:19:43 +0200
Message-Id: <20181026201943.24131-6-stefanrin@gmail.com>
In-Reply-To: <20181026201943.24131-1-stefanrin@gmail.com>
References: <20181026201943.24131-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

---
 db/metadump.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/db/metadump.c b/db/metadump.c
index 39183fb7..bdc6f2f4 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2269,6 +2269,24 @@ process_inode_data(
 	return 1;
 }
 
+static int
+process_dev_inode(
+	xfs_dinode_t		*dip)
+{
+	if (XFS_DFORK_NEXTENTS(dip, XFS_ATTR_FORK) ||
+	    XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
+		if (show_warnings)
+			print_warning("inode %llu has unexpected extents",
+				      (unsigned long long)cur_ino);
+		return 0;
+	} else {
+		int used = XFS_DFORK_DPTR(dip) - (char*)dip;
+
+		memset(XFS_DFORK_DPTR(dip), 0, mp->m_sb.sb_inodesize - used);
+		return 1;
+	}
+}
+
 /*
  * when we process the inode, we may change the data in the data and/or
  * attribute fork if they are in short form and we are obfuscating names.
@@ -2321,7 +2339,9 @@ process_inode(
 		case S_IFREG:
 			success = process_inode_data(dip, TYP_DATA);
 			break;
-		default: ;
+		default:
+			success = process_dev_inode(dip);
+			break;
 	}
 	nametable_clear();
 
-- 
2.14.5
