Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 55CB47FF3
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 486B88F8033
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:05 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	pUkrNacP0HaE73Ra for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:03 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4o-0003CQ-Md
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4e-0000GJ-Hv
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 36/50] xfs: remove __KERNEL__ from debug code
Date: Wed, 19 Jun 2013 15:35:59 +1000
Message-Id: <1371620173-712-37-git-send-email-david@fromorbit.com>
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

There is no reason the remaining kernel-only debug code needs to
remain kernel-only. Kill the __KERNEL__ part of the defines, and let
userspace handle the debug code appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_bmap.h     |    2 +-
 libxfs/xfs_dir2_data.c |    4 ++--
 libxfs/xfs_rtalloc.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/xfs_bmap.h b/include/xfs_bmap.h
index 262f760..a2e50c6 100644
--- a/include/xfs_bmap.h
+++ b/include/xfs_bmap.h
@@ -163,7 +163,7 @@ typedef struct xfs_bmalloca {
 	{ BMAP_RIGHT_FILLING,	"RF" }, \
 	{ BMAP_ATTRFORK,	"ATTR" }
 
-#if defined(__KERNEL) && defined(DEBUG)
+#ifdef DEBUG
 void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 		int whichfork, unsigned long caller_ip);
 #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)	\
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 064ddb2..5074878 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -315,7 +315,7 @@ xfs_dir2_data_freefind(
 	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
 	xfs_dir2_data_aoff_t	off;		/* offset value needed */
 	struct xfs_dir2_data_free *bf;
-#if defined(DEBUG) && defined(__KERNEL__)
+#ifdef DEBUG
 	int			matched;	/* matched the value */
 	int			seenzero;	/* saw a 0 bestfree entry */
 #endif
@@ -323,7 +323,7 @@ xfs_dir2_data_freefind(
 	off = (xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr);
 	bf = xfs_dir3_data_bestfree_p(hdr);
 
-#if defined(DEBUG) && defined(__KERNEL__)
+#ifdef DEBUG
 	/*
 	 * Validate some consistency in the bestfree table.
 	 * Check order, non-overlapping entries, and if we find the
diff --git a/libxfs/xfs_rtalloc.c b/libxfs/xfs_rtalloc.c
index 9797db7..f5a90b2 100644
--- a/libxfs/xfs_rtalloc.c
+++ b/libxfs/xfs_rtalloc.c
@@ -735,7 +735,7 @@ xfs_rtfree_extent(
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
-#if defined(__KERNEL__) && defined(DEBUG)
+#ifdef DEBUG
 	/*
 	 * Check to see that this whole range is currently allocated.
 	 */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
