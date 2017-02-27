Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751625AbdB0FRJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Feb 2017 00:17:09 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82279C04B326
        for <linux-xfs@vger.kernel.org>; Mon, 27 Feb 2017 04:39:56 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v1R4dtNn009039
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2017 23:39:56 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: remove unused libxfs helper #defines
Message-ID: <78814f34-15b8-9d72-7b25-377478e9c564@redhat.com>
Date: Sun, 26 Feb 2017 22:39:54 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

There are several #defines which aren't used anywhere
in either xfsprogs or the kernel, so remove them from the
libxfs/libxfs_priv.h helper file.

This does leave a few (currently) unused defines in place
if they are still used in the kernel, in the hope that future
libxfs changes might Just Work.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 libxfs_priv.h |   38 +-------------------------------------
 1 file changed, 1 insertion(+), 37 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 14ae788..ccc732f 100644
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
@@ -308,20 +302,11 @@ roundup_64(__uint64_t x, __uint32_t y)
 }
 
 /* buffer management */
-#define XFS_BUF_LOCK			0
-#define XFS_BUF_TRYLOCK			0
-#define XBF_LOCK			XFS_BUF_LOCK
-#define XBF_TRYLOCK			XFS_BUF_TRYLOCK
-#define XBF_DONT_BLOCK			0
+#define XBF_TRYLOCK			0
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
@@ -353,7 +338,6 @@ roundup_64(__uint64_t x, __uint32_t y)
 #define XFS_MOUNT_RDONLY		0	/* ignored in userspace */
 
 
-#define xfs_trans_get_block_res(tp)	1
 #define xfs_trans_set_sync(tp)		((void) 0)
 #define xfs_trans_ordered_buf(tp, bp)	((void) 0)
 #define	xfs_trans_agblocks_delta(tp, d)
@@ -373,26 +357,13 @@ roundup_64(__uint64_t x, __uint32_t y)
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
-
 #define xfs_ilock(ip,mode)				((void) 0)
 #define xfs_ilock_nowait(ip,mode)			((void) 0)
 #define xfs_ilock_demote(ip,mode)			((void) 0)
@@ -402,7 +373,6 @@ roundup_64(__uint64_t x, __uint32_t y)
 	typeof(mode) __mode = mode;				\
 	__mode = __mode; /* no set-but-unused warning */	\
 })
-#define __xfs_flock(ip)					((void) 0)
 
 /* space allocation */
 #define xfs_extent_busy_reuse(mp,ag,bno,len,user)	((void) 0)
@@ -417,12 +387,6 @@ do { \
 	*(len) = (flen); \
 } while (0)
 
-/* avoid unused variable warning */
-#define xfs_alloc_busy_insert(tp,ag,b,len)	({	\
-	xfs_agnumber_t __foo = ag;			\
-	__foo = 0;					\
-})
-
 #define xfs_rotorstep				1
 #define xfs_bmap_rtalloc(a)			(-ENOSYS)
 #define xfs_get_extsz_hint(ip)			(0)

