Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2G7pUP031826 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:07:51 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00D8C164F1EF
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:07:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qXvYRtMlLi4hFPHw for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:07:50 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xlz-0007Qj-24
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:51 +0000
Message-Id: <20081202160650.974883000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 10/22] kill dead quota flags
Content-Disposition: inline; filename=xfs-kill-dead-quota-flags
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/xfs_quota.h
===================================================================
--- xfs-master.orig/fs/xfs/xfs_quota.h	2008-12-01 19:26:03.000000000 +0100
+++ xfs-master/fs/xfs/xfs_quota.h	2008-12-01 19:27:41.000000000 +0100
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
 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
