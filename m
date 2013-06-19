Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C85858003
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B67E18F8033
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:07 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2UqIcbRUc99wYSGF for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:06 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4o-0003Cj-R7
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4o-0000Gd-NV
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 40/50] xfs: move kernel specific type definitions to xfs.h
Date: Wed, 19 Jun 2013 15:36:03 +1000
Message-Id: <1371620173-712-41-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

xfs_types.h is shared with userspace, so having kernel specific
types defined in it is problematic. Move all the kernel specific
defines to xfs_linux.h so we can remove the __KERNEL__ guards from
xfs_types.h

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_types.h |   36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/include/xfs_types.h b/include/xfs_types.h
index dd6bf71..b4a7d5f 100644
--- a/include/xfs_types.h
+++ b/include/xfs_types.h
@@ -18,42 +18,6 @@
 #ifndef __XFS_TYPES_H__
 #define	__XFS_TYPES_H__
 
-#ifdef __KERNEL__
-
-/*
- * Additional type declarations for XFS
- */
-typedef signed char		__int8_t;
-typedef unsigned char		__uint8_t;
-typedef signed short int	__int16_t;
-typedef unsigned short int	__uint16_t;
-typedef signed int		__int32_t;
-typedef unsigned int		__uint32_t;
-typedef signed long long int	__int64_t;
-typedef unsigned long long int	__uint64_t;
-
-typedef __uint32_t		inst_t;		/* an instruction */
-
-typedef __s64			xfs_off_t;	/* <file offset> type */
-typedef unsigned long long	xfs_ino_t;	/* <inode> type */
-typedef __s64			xfs_daddr_t;	/* <disk address> type */
-typedef char *			xfs_caddr_t;	/* <core address> type */
-typedef __u32			xfs_dev_t;
-typedef __u32			xfs_nlink_t;
-
-/* __psint_t is the same size as a pointer */
-#if (BITS_PER_LONG == 32)
-typedef __int32_t __psint_t;
-typedef __uint32_t __psunsigned_t;
-#elif (BITS_PER_LONG == 64)
-typedef __int64_t __psint_t;
-typedef __uint64_t __psunsigned_t;
-#else
-#error BITS_PER_LONG must be 32 or 64
-#endif
-
-#endif	/* __KERNEL__ */
-
 typedef __uint32_t	prid_t;		/* project ID */
 
 typedef __uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
