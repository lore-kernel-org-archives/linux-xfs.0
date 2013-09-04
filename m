Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 17E8829E61
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:21:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9D694AC003
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:21:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RrxiAAOLOE52Z2EE for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:21:36 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLDA-0007dG-AN
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLDA-0003uI-8n
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 39/55] xfs: move kernel specific type definitions to xfs.h
Date: Thu,  5 Sep 2013 08:05:43 +1000
Message-Id: <1378332359-14737-40-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-1-git-send-email-david@fromorbit.com>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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
 include/xfs_types.h | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/include/xfs_types.h b/include/xfs_types.h
index 6ed6b26..ce44b18 100644
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
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
