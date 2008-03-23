Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Mar 2008 17:50:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2N0ohcx008059
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 17:50:44 -0700
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E25A6D666D
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 17:51:17 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.177]) by cuda.sgi.com with ESMTP id uwfyczAkwzDEXJoC for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 17:51:17 -0700 (PDT)
Received: by wa-out-1112.google.com with SMTP id k22so2594038waf.18
        for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 17:51:16 -0700 (PDT)
Message-ID: <47E5A982.8010002@gmail.com>
Date: Sun, 23 Mar 2008 08:51:14 +0800
From: Kevin Xu <cgxu.gg@gmail.com>
MIME-Version: 1.0
Subject: [PATCH]fix fbno in  xfs_dir2_node_addname_int
Content-Type: multipart/mixed;
 boundary="------------090401090106060102070105"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfscn@googlegroups.com
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------090401090106060102070105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

if we didn't find a freespace block for our new entry  in the current 
freeindex block, 
return to the first freeindex block and continue to check.

--------------090401090106060102070105
Content-Type: text/x-patch;
 name="usig-xfs-fix-080322.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usig-xfs-fix-080322.patch"

--- linux-2.6-xfs/fs/xfs/xfs_dir2_node.c	2008-03-22 22:41:12.118699220 +0800
+++ linux-xfs-usig/fs/xfs/xfs_dir2_node.c	2008-03-22 22:48:07.694781678 +0800
@@ -1502,8 +1502,10 @@ xfs_dir2_node_addname_int(
 				 */
 				xfs_da_brelse(tp, fbp);
 				fbp = NULL;
-				if (fblk && fblk->bp)
+				if (fblk && fblk->bp) {
 					fblk->bp = NULL;
+					fbno = -1;
+				}
 			}
 		}
 	}


--------------090401090106060102070105--
