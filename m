Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1EB0829E13
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:24:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1258E304062
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:24:31 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ZwGOnkJRTQznSdEf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:24:29 -0700 (PDT)
Received: from smtpout2.drei.com ([109.126.64.2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z6bUK-0001zz-Dz
	for xfs@oss.sgi.com; Sun, 21 Jun 2015 09:24:29 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/8] xfsprogs: remove boolean_t typedef
Date: Sun, 21 Jun 2015 11:22:02 +0200
Message-Id: <1434878524-18176-7-git-send-email-hch@lst.de>
In-Reply-To: <1434878524-18176-1-git-send-email-hch@lst.de>
References: <1434878524-18176-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Only one use of this exists, and it's treated like an int anyway by
both caller and callee.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/darwin.h      | 3 ---
 include/freebsd.h     | 2 --
 include/gnukfreebsd.h | 2 --
 include/linux.h       | 5 -----
 logprint/log_misc.c   | 2 +-
 5 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/darwin.h b/include/darwin.h
index ca9f8f4..3655d40 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -144,9 +144,6 @@ typedef char*		xfs_caddr_t;
 #define O_SYNC          0
 #endif
 
-#define B_FALSE		0
-#define B_TRUE		1
-
 #define ENOATTR		989     /* Attribute not found */
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
 #define EFSBADCRC	991	/* Bad CRC detected */
diff --git a/include/freebsd.h b/include/freebsd.h
index d01c0c1..244b012 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -55,8 +55,6 @@ typedef __int64_t	xfs_daddr_t;
 typedef char*		xfs_caddr_t;
 typedef off_t		loff_t;
 
-typedef enum { B_FALSE,B_TRUE }	boolean_t;
-
 #define	O_LARGEFILE	0
 
 #define HAVE_FID	1
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index e92858d..978a257 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -45,8 +45,6 @@ typedef __int64_t	xfs_daddr_t;
 typedef char*		xfs_caddr_t;
 typedef off_t		loff_t;
 
-typedef enum { B_FALSE,B_TRUE }	boolean_t;
-
 #define HAVE_FID	1
 
 static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
diff --git a/include/linux.h b/include/linux.h
index da50421..e7a3cb2 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -144,9 +144,4 @@ typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
 typedef char*		xfs_caddr_t;
 
-#ifndef _BOOLEAN_T_DEFINED
-typedef enum {B_FALSE, B_TRUE}	boolean_t;
-#define _BOOLEAN_T_DEFINED	1
-#endif
-
 #endif	/* __XFS_LINUX_H__ */
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 6f41c91..708a513 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -641,7 +641,7 @@ xlog_print_trans_inode(
 	int		len,
 	int		*i,
 	int		num_ops,
-	boolean_t	continued)
+	int		continued)
 {
     xfs_icdinode_t	   dino;
     xlog_op_header_t	   *op_head;
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
