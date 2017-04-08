Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45578 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751841AbdDHOrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 8 Apr 2017 10:47:12 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E1A00625E37
        for <linux-xfs@vger.kernel.org>; Sat,  8 Apr 2017 09:47:11 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfsprogs: remove unused libxfs compat defines
Message-ID: <a36bedc0-9590-2f61-81fc-5a919a05ca9f@sandeen.net>
Date: Sat, 8 Apr 2017 09:47:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

We define dummy macros in libxfs for building it in userspace,
but many of these are no longer used in the code, so remove them.

(I left a few unused macros in place for symmetry and future use,
if they are still present in kernel code)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

 libxfs_priv.h |   33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index c2d4494..b091d4d 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -103,8 +103,6 @@ extern char    *progname;
 #define ATTR_KERNOTIME			0
 #define ATTR_KERNOVAL			0
 
-#define IHOLD(ip)			((void) 0)
-
 #define XFS_IGET_CREATE			0x1
 #define XFS_IGET_UNTRUSTED		0x2
 
@@ -128,16 +126,12 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 	cmn_err(CE_ALERT, "%s: XFS_ERROR_REPORT", (e));  \
 } while (0)
 
-#define XFS_QM_DQATTACH(mp,ip,flags)	0
 #define XFS_ERRLEVEL_LOW		1
 #define XFS_FORCED_SHUTDOWN(mp)		0
 #define XFS_ILOCK_EXCL			0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
-#define XFS_TRANS_MOD_DQUOT_BYINO(mp,tp,ip,field,delta)	do { } while (0)
-#define XFS_TRANS_RESERVE_QUOTA_NBLKS(mp,tp,ip,nblks,ninos,fl)	0
-#define XFS_TRANS_UNRESERVE_QUOTA_NBLKS(mp,tp,ip,nblks,ninos,fl)	0
 #define XFS_TEST_ERROR(expr,a,b,c)	( expr )
 #define XFS_WANT_CORRUPTED_GOTO(mp, expr, l)				\
 {									\
@@ -313,18 +307,11 @@ roundup_64(__uint64_t x, __uint32_t y)
 /* buffer management */
 #define XFS_BUF_LOCK			0
 #define XFS_BUF_TRYLOCK			0
-#define XBF_LOCK			XFS_BUF_LOCK
 #define XBF_TRYLOCK			XFS_BUF_TRYLOCK
-#define XBF_DONT_BLOCK			0
 #define XBF_UNMAPPED			0
 #define XBF_DONE			0
-#define XFS_BUF_GETERROR(bp)		0
-#define XFS_BUF_DONE(bp)		((bp)->b_flags |= LIBXFS_B_UPTODATE)
-#define XFS_BUF_ISDONE(bp)		((bp)->b_flags & LIBXFS_B_UPTODATE)
 #define xfs_buf_stale(bp)		((bp)->b_flags |= LIBXFS_B_STALE)
 #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
-#define XFS_BUF_SET_VTYPE(a,b)		((void) 0)
-#define XFS_BUF_SET_VTYPE_REF(a,b,c)	((void) 0)
 #define XFS_BUF_SET_BDSTRAT_FUNC(a,b)	((void) 0)
 
 /* avoid gcc warning */
@@ -356,7 +343,6 @@ roundup_64(__uint64_t x, __uint32_t y)
 #define XFS_MOUNT_RDONLY		0	/* ignored in userspace */
 
 
-#define xfs_trans_get_block_res(tp)	1
 #define xfs_trans_set_sync(tp)		((void) 0)
 #define xfs_trans_ordered_buf(tp, bp)	((void) 0)
 #define	xfs_trans_agblocks_delta(tp, d)
@@ -376,25 +362,13 @@ roundup_64(__uint64_t x, __uint32_t y)
 	__d = __d; /* no set-but-unused warning */	\
 })
 #define xfs_buf_readahead_map(a,b,c,ops)	((void) 0)	/* no readahead */
-#define xfs_buftrace(x,y)			((void) 0)	/* debug only */
 
-#define xfs_cmn_err(tag,level,mp,fmt,args...)	cmn_err(level,fmt, ## args)
 #define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
 #define xfs_alert(mp,fmt,args...)		cmn_err(CE_ALERT,fmt, ## args)
 #define xfs_alert_tag(mp,tag,fmt,args...)	cmn_err(CE_ALERT,fmt, ## args)
 
-#define xfs_dir2_trace_args(where, args)		((void) 0)
-#define xfs_dir2_trace_args_b(where, args, bp)		((void) 0)
-#define xfs_dir2_trace_args_bb(where, args, lbp, dbp)	((void) 0)
-#define xfs_dir2_trace_args_bibii(where, args, bs, ss, bd, sd, c) ((void) 0)
-#define xfs_dir2_trace_args_db(where, args, db, bp)	((void) 0)
-#define xfs_dir2_trace_args_i(where, args, i)		((void) 0)
-#define xfs_dir2_trace_args_s(where, args, s)		((void) 0)
-#define xfs_dir2_trace_args_sb(where, args, s, bp)	((void) 0)
 #define xfs_sort					qsort
 
-#define xfs_icsb_reinit_counters(mp)			do { } while (0)
-#define xfs_initialize_perag_icache(pag)		((void) 0)
 
 #define xfs_ilock(ip,mode)				((void) 0)
 #define xfs_ilock_nowait(ip,mode)			((void) 0)
@@ -405,7 +379,6 @@ roundup_64(__uint64_t x, __uint32_t y)
 	typeof(mode) __mode = mode;				\
 	__mode = __mode; /* no set-but-unused warning */	\
 })
-#define __xfs_flock(ip)					((void) 0)
 
 /* space allocation */
 #define xfs_extent_busy_reuse(mp,ag,bno,len,user)	((void) 0)
@@ -421,12 +394,6 @@ roundup_64(__uint64_t x, __uint32_t y)
 })
 #define xfs_extent_busy_flush(mp,pag,busy_gen)		(0)
 
-/* avoid unused variable warning */
-#define xfs_alloc_busy_insert(tp,ag,b,len)	({	\
-	xfs_agnumber_t __foo = ag;			\
-	__foo = 0;					\
-})
-
 #define xfs_rotorstep				1
 #define xfs_bmap_rtalloc(a)			(-ENOSYS)
 #define xfs_get_extsz_hint(ip)			(0)

