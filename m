Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 12:35:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m62JZc0U026515
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 12:35:38 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 083CF12D6607
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2008 12:36:39 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id XTzys3CWWks2qK9y for <xfs@oss.sgi.com>; Wed, 02 Jul 2008 12:36:39 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m62JaUNW019830
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 21:36:30 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m62JaUx2019828
	for xfs@oss.sgi.com; Wed, 2 Jul 2008 21:36:30 +0200
Date: Wed, 2 Jul 2008 21:36:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix compilation without CONFIG_PROC_FS
Message-ID: <20080702193630.GA19715@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_stats.h	2008-06-27 15:16:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.h	2008-06-27 15:19:18.000000000 +0200
@@ -146,11 +146,12 @@ extern void xfs_cleanup_procfs(void);
 
 static inline int xfs_init_procfs(void)
 {
-	return 0
-};
+	return 0;
+}
+
 static inline void xfs_cleanup_procfs(void)
 {
-};
+}
 
 #endif	/* !CONFIG_PROC_FS */
 
