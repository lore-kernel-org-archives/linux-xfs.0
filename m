Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Nov 2006 20:55:42 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAG4tWaG018479
	for <xfs@oss.sgi.com>; Wed, 15 Nov 2006 20:55:34 -0800
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [210.143.35.52])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42F34521C3A
	for <xfs@oss.sgi.com>; Wed, 15 Nov 2006 20:54:43 -0800 (PST)
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.193])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kAG4sfLZ019559
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 13:54:42 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kAG4sfN18472 for xfs@oss.sgi.com; Thu, 16 Nov 2006 13:54:41 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id kAG4sQ806476 for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 13:54:26 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061116.135929.68702252 for <xfs@oss.sgi.com>
	; Thu, 16 Nov 2006 13:59:29 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id 46A63AE4B0
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 13:54:26 +0900 (JST)
Message-Id: <200611160454.AA04682@TNESG9305.tnes.nec.co.jp>
Date: Thu, 16 Nov 2006 13:54:26 +0900
Subject: [PATCH] xfs_db initialization
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

This patch fixes the issue that xfs_db causes segmentation fault
when a corrupt file system is specified. 

Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.15-orgn/libxfs/init.c	2006-10-18 01:10:14.000000000 +0900
+++ xfsprogs-2.8.15/libxfs/init.c	2006-11-16 10:03:18.575412805 +0900
@@ -595,8 +595,8 @@ libxfs_mount(
 		fprintf(stderr, _("%s: data size check failed\n"), progname);
 		if (!(flags & LIBXFS_MOUNT_DEBUGGER))
 			return NULL;
-	}
-	libxfs_putbuf(bp);
+	} else
+		libxfs_putbuf(bp);
 
 	if (mp->m_logdev && mp->m_logdev != mp->m_dev) {
 		d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
@@ -610,7 +610,8 @@ libxfs_mount(
 			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
 				return NULL;
 		}
-		libxfs_putbuf(bp);
+		if (bp)
+			libxfs_putbuf(bp);
 	}
 
 	/* Initialize realtime fields in the mount structure */
