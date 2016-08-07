Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 485F07CF4
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:35:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1979C304048
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:35:53 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id NtsNTo00CaqXNLUp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:35:51 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id F353F20A94
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:49 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s6XQY3vTHz1043
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:49 +0200 (CEST)
Message-Id: <5562ea1f5a96d39d406d2258053167e798b98fff.1470555003.git.felix.janda@posteo.de>
In-Reply-To: <cover.1470555003.git.felix.janda@posteo.de>
References: <cover.1470555003.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sun, 7 Aug 2016 07:52:09 +0200
Subject: [PATCH xfsprogs 14/14] platform: remove use of off64_t
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

Since we force transparent LFS for downstreams, it can be replaced
by off_t.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/darwin.h  | 1 -
 include/freebsd.h | 1 -
 include/irix.h    | 2 +-
 include/linux.h   | 2 +-
 4 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/darwin.h b/include/darwin.h
index bd1a112..1f3f789 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -134,7 +134,6 @@ typedef signed long long int	__s64;
 #define __uint16_t	u_int16_t
 #define __uint32_t	u_int32_t
 #define __uint64_t	u_int64_t
-#define off64_t		off_t
 
 typedef off_t		xfs_off_t;
 typedef u_int64_t	xfs_ino_t;
diff --git a/include/freebsd.h b/include/freebsd.h
index df924ef..93a9204 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -41,7 +41,6 @@
 #define EFSBADCRC	991	/* Bad CRC detected */
 
 typedef off_t		xfs_off_t;
-typedef off_t		off64_t;
 typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
diff --git a/include/irix.h b/include/irix.h
index b92e01b..a212505 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -43,7 +43,7 @@
 #define __int16_t	short
 #define __uint8_t	unsigned char
 #define __uint16_t	unsigned short
-typedef off64_t		xfs_off_t;
+typedef off_t		xfs_off_t;
 typedef __int64_t	xfs_ino_t;
 typedef __int32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
diff --git a/include/linux.h b/include/linux.h
index 5614719..ed388ea 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -137,7 +137,7 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 #define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
 #define EFSBADCRC	EBADMSG	/* Bad CRC detected */
 
-typedef off64_t		xfs_off_t;
+typedef off_t		xfs_off_t;
 typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
