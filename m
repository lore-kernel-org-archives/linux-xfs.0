Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D1DA529E14
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:24:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 64FBAAC006
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:24:34 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id dKOJTHZM9QyyXXu7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:24:33 -0700 (PDT)
Received: from smtpout2.drei.com ([109.126.64.2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z6bUO-00020S-OW
	for xfs@oss.sgi.com; Sun, 21 Jun 2015 09:24:33 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/8] xfsprogs: remove non-Linux defintions for loff_t
Date: Sun, 21 Jun 2015 11:22:03 +0200
Message-Id: <1434878524-18176-8-git-send-email-hch@lst.de>
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

We don't use loff_t anywhere in xfsprogs, so no need to define it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/darwin.h      | 1 -
 include/freebsd.h     | 1 -
 include/gnukfreebsd.h | 1 -
 include/irix.h        | 1 -
 4 files changed, 4 deletions(-)

diff --git a/include/darwin.h b/include/darwin.h
index 3655d40..ec8cb4f 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -118,7 +118,6 @@ static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
 #define __uint16_t	u_int16_t
 #define __uint32_t	u_int32_t
 #define __uint64_t	u_int64_t
-#define loff_t		off_t
 #define off64_t		off_t
 
 typedef off_t		xfs_off_t;
diff --git a/include/freebsd.h b/include/freebsd.h
index 244b012..0ae1262 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -53,7 +53,6 @@ typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
 typedef char*		xfs_caddr_t;
-typedef off_t		loff_t;
 
 #define	O_LARGEFILE	0
 
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index 978a257..6882cfe 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -43,7 +43,6 @@ typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
 typedef char*		xfs_caddr_t;
-typedef off_t		loff_t;
 
 #define HAVE_FID	1
 
diff --git a/include/irix.h b/include/irix.h
index ad6dbfe..ea1f219 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -42,7 +42,6 @@
 #define __int16_t	short
 #define __uint8_t	unsigned char
 #define __uint16_t	unsigned short
-#define loff_t		off64_t
 typedef off64_t		xfs_off_t;
 typedef __int64_t	xfs_ino_t;
 typedef __int32_t	xfs_dev_t;
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
