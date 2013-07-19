Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 17A6F7F75
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 078FD304043
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bHIACLmiZ5O7NMyi for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:38 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-00048s-5K
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-0001z2-3u
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 30/49] xfs: remove __KERNEL__ from debug code
Date: Fri, 19 Jul 2013 16:25:01 +1000
Message-Id: <1374215120-7271-31-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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

There is no reason the remaining kernel-only debug code needs to
remain kernel-only. Kill the __KERNEL__ part of the defines, and let
userspace handle the debug code appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.h      | 2 +-
 fs/xfs/xfs_dir2_data.c | 4 ++--
 fs/xfs/xfs_rtalloc.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 8b2fe97..33b41f3 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -127,7 +127,7 @@ static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
 	{ BMAP_RIGHT_FILLING,	"RF" }, \
 	{ BMAP_ATTRFORK,	"ATTR" }
 
-#if defined(__KERNEL) && defined(DEBUG)
+#ifdef DEBUG
 void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 		int whichfork, unsigned long caller_ip);
 #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)	\
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 4e1917d..98c23fa 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -331,7 +331,7 @@ xfs_dir2_data_freefind(
 	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
 	xfs_dir2_data_aoff_t	off;		/* offset value needed */
 	struct xfs_dir2_data_free *bf;
-#if defined(DEBUG) && defined(__KERNEL__)
+#ifdef DEBUG
 	int			matched;	/* matched the value */
 	int			seenzero;	/* saw a 0 bestfree entry */
 #endif
@@ -339,7 +339,7 @@ xfs_dir2_data_freefind(
 	off = (xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr);
 	bf = xfs_dir3_data_bestfree_p(hdr);
 
-#if defined(DEBUG) && defined(__KERNEL__)
+#ifdef DEBUG
 	/*
 	 * Validate some consistency in the bestfree table.
 	 * Check order, non-overlapping entries, and if we find the
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4822806..6dbcb5e 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -2147,7 +2147,7 @@ xfs_rtfree_extent(
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
-#if defined(__KERNEL__) && defined(DEBUG)
+#ifdef DEBUG
 	/*
 	 * Check to see that this whole range is currently allocated.
 	 */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
