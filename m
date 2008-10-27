Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:49:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDmgin027389
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:48:42 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD312ADE7D6
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:48:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id pnhYgDNIY5YQfJPO for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:48:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSSX-0001fw-Ae
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:48:41 +0000
Date: Mon, 27 Oct 2008 09:48:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/10] kill dead quota flags
Message-ID: <20081027134841.GA6440@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-kill-dead-quota-flags
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_quota.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_quota.h	2008-08-14 18:27:11.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/xfs_quota.h	2008-08-14 18:28:04.000000000 -0300
@@ -84,11 +84,9 @@ typedef struct xfs_dqblk {
 #define XFS_DQ_USER		0x0001		/* a user quota */
 #define XFS_DQ_PROJ		0x0002		/* project quota */
 #define XFS_DQ_GROUP		0x0004		/* a group quota */
-#define XFS_DQ_FLOCKED		0x0008		/* flush lock taken */
-#define XFS_DQ_DIRTY		0x0010		/* dquot is dirty */
-#define XFS_DQ_WANT		0x0020		/* for lookup/reclaim race */
-#define XFS_DQ_INACTIVE		0x0040		/* dq off mplist & hashlist */
-#define XFS_DQ_MARKER		0x0080		/* sentinel */
+#define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
+#define XFS_DQ_WANT		0x0010		/* for lookup/reclaim race */
+#define XFS_DQ_INACTIVE		0x0020		/* dq off mplist & hashlist */
 
 #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-08-14 18:27:23.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-08-14 18:27:50.000000000 -0300
@@ -6644,11 +6644,9 @@ static char *xdq_flags[] = {
 	"USER",		/* XFS_DQ_USER */
 	"PROJ",		/* XFS_DQ_PROJ */
 	"GROUP",	/* XFS_DQ_GROUP */
-	"FLKD",		/* XFS_DQ_FLOCKED */
 	"DIRTY",	/* XFS_DQ_DIRTY */
 	"WANT",		/* XFS_DQ_WANT */
 	"INACT",	/* XFS_DQ_INACTIVE */
-	"MARKER",	/* XFS_DQ_MARKER */
 	NULL
 };
 

-- 
