Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EACiAH250454 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 04:12:44 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4080F1DB1135
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 02:13:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	kSiv1ZdWhQCngCFc for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 02:13:39 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11435815-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 20:43:38 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVMht-0007rP-JH
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:13:37 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVMdg-0001LF-6h
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:09:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/9] xfsprogs: Fix miscellaneous warnings in libxfs
Date: Thu, 14 Jan 2010 21:09:05 +1100
Message-Id: <1263463752-5052-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1263463752-5052-1-git-send-email-david@fromorbit.com>
References: <1263463752-5052-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

These are questionable fixes but they do shut up the warnings with
as little change as possible. The first couple are questionable
because they are a result of the compiler (gcc 4.3.4) trying to be
smart but failing.

The uninitialised variable warnings in xfs_bmapi() is spurious, as
certain fields are unused in certain situations but gcc can't work
that out.  It is easily suppressed by initialising the structure to
zero.

xfs_mod_sb() is dumping out an array subscript bound warning that is
spurious. The code is correct and will assert fail on out of bounds
indexes. A simple reorder of the first and last offset calculations
makes the warning go away (a good sign of compiler fail if ever
there was one).

Changing xfs_alloc_mark_busy() from a macro to a static inline
definition is needed for the compiler to see that variables passed
to that function are actually used.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs.h       |    5 +++--
 libxfs/xfs_bmap.c  |    2 +-
 libxfs/xfs_mount.c |    9 ++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 8e94dad..abe8700 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -288,9 +288,10 @@ roundup_pow_of_two(uint v)
 #define xfs_ilock(ip,mode)				((void) 0)
 #define xfs_iunlock(ip,mode)				((void) 0)
 
-/* space allocation */
+/* space allocation - use static inlines to avoid unused var warnings */
 #define xfs_alloc_search_busy(tp,ag,b,len)	((void) 0)
-#define xfs_alloc_mark_busy(tp,ag,b,len)	((void) 0)
+static inline void xfs_alloc_mark_busy(xfs_trans_t *tp,
+	xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len) {}
 #define xfs_rotorstep				1
 #define xfs_bmap_rtalloc(a)			(ENOSYS)
 #define xfs_rtpick_extent(mp,tp,len,p)		(ENOSYS)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cf1123a..4cc6431 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4274,7 +4274,7 @@ xfs_bmapi(
 	xfs_fsblock_t	abno;		/* allocated block number */
 	xfs_extlen_t	alen;		/* allocated extent length */
 	xfs_fileoff_t	aoff;		/* allocated file offset */
-	xfs_bmalloca_t	bma;		/* args for xfs_bmap_alloc */
+	xfs_bmalloca_t	bma = { 0 };	/* args for xfs_bmap_alloc */
 	xfs_btree_cur_t	*cur;		/* bmap btree cursor */
 	xfs_fileoff_t	end;		/* end of mapped file region */
 	int		eof;		/* we've hit the end of extents */
diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
index 02bff42..662c8d2 100644
--- a/libxfs/xfs_mount.c
+++ b/libxfs/xfs_mount.c
@@ -400,15 +400,14 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
 
 	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
 
-	/* find modified range */
+	/* find modified range - get last first to avoid spurious warning */
+	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
+	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
+	last = xfs_sb_info[f + 1].offset - 1;
 
 	f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
 	first = xfs_sb_info[f].offset;
 
-	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
-	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
-	last = xfs_sb_info[f + 1].offset - 1;
-
 	xfs_trans_log_buf(tp, bp, first, last);
 }
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
