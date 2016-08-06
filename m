Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8DF8D7CD0
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2016 03:40:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 12BB2AC004
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2016 01:40:28 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id Y5P4a29B5shVyksy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 06 Aug 2016 01:40:27 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id D72E92083B
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2016 10:40:25 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s5xvY2yvvzysW
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2016 10:40:25 +0200 (CEST)
Date: Sat, 6 Aug 2016 10:39:49 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH xfsprogs] kill off u_int*_t types
Message-ID: <20160806083949.GA28832@nyan>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

They were only used in two places and can be replaced by uint*_t.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 db/check.c          | 2 +-
 include/darwin.h    | 8 ++------
 libxfs/xfs_format.h | 2 +-
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/db/check.c b/db/check.c
index 25146e5..f507148 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3336,7 +3336,7 @@ process_quota(
 	int		cb;
 	xfs_dqblk_t	*dqb;
 	xfs_dqid_t	dqid;
-	u_int8_t	exp_flags = 0;
+	uint8_t		exp_flags = 0;
 	uint		i;
 	uint		perblock;
 	xfs_fileoff_t	qbno;
diff --git a/include/darwin.h b/include/darwin.h
index 45e0c03..b5076ce 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -130,15 +130,11 @@ typedef signed long long int	__s64;
 #define __int32_t	int32_t
 #define __int32_t	int32_t
 #define __int64_t	int64_t
-#define __uint8_t	u_int8_t
-#define __uint16_t	u_int16_t
-#define __uint32_t	u_int32_t
-#define __uint64_t	u_int64_t
 #define off64_t		off_t
 
 typedef off_t		xfs_off_t;
-typedef u_int64_t	xfs_ino_t;
-typedef u_int32_t	xfs_dev_t;
+typedef uint64_t	xfs_ino_t;
+typedef uint32_t	xfs_dev_t;
 typedef int64_t		xfs_daddr_t;
 
 #define stat64		stat
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f89b6e0..eb50a76 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1109,7 +1109,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * Dquot and dquot block format definitions
  */
 #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
-#define XFS_DQUOT_VERSION	(u_int8_t)0x01	/* latest version number */
+#define XFS_DQUOT_VERSION	(uint8_t)0x01	/* latest version number */
 
 /*
  * This is the main portion of the on-disk representation of quota
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
