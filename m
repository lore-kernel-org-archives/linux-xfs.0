Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Jun 2007 22:45:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5P5jTdo017157
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 22:45:30 -0700
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 4B24018011E86
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 23:46:50 -0500 (CDT)
Message-ID: <467F48B9.7060504@sandeen.net>
Date: Sun, 24 Jun 2007 23:46:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove hard-coded fnames from tracing functions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

This has been on my stack a while, still compiles clean but feel free
to double-check. :-)

 xfs_alloc.c      |   53 ++--------
 xfs_bmap.c       |  266 +++++++++++++++++++++++--------------------------------
 xfs_bmap.h       |    6 -
 xfs_bmap_btree.c |   88 +++---------------
 xfs_inode.c      |    8 -
 5 files changed, 149 insertions(+), 272 deletions(-)

---------------

Remove the hardcoded "fnames" for tracing, and just embed
them in tracing macros via __FUNCTION__.  Kills a lot of #ifdefs
too.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux.orig/fs/xfs/xfs_bmap_btree.c
+++ linux/fs/xfs/xfs_bmap_btree.c
@@ -76,7 +76,7 @@ static char	EXIT[] = "exit";
  */
 STATIC void
 xfs_bmbt_trace_enter(
-	char		*func,
+	const char	*func,
 	xfs_btree_cur_t	*cur,
 	char		*s,
 	int		type,
@@ -117,7 +117,7 @@ xfs_bmbt_trace_enter(
  */
 STATIC void
 xfs_bmbt_trace_argbi(
-	char		*func,
+	const char	*func,
 	xfs_btree_cur_t	*cur,
 	xfs_buf_t	*b,
 	int		i,
@@ -134,7 +134,7 @@ xfs_bmbt_trace_argbi(
  */
 STATIC void
 xfs_bmbt_trace_argbii(
-	char		*func,
+	const char	*func,
 	xfs_btree_cur_t	*cur,
 	xfs_buf_t	*b,
 	int		i0,
@@ -153,7 +153,7 @@ xfs_bmbt_trace_argbii(
  */
 STATIC void
 xfs_bmbt_trace_argfffi(
-	char			*func,
+	const char		*func,
 	xfs_btree_cur_t		*cur,
 	xfs_dfiloff_t		o,
 	xfs_dfsbno_t		b,
@@ -172,7 +172,7 @@ xfs_bmbt_trace_argfffi(
  */
 STATIC void
 xfs_bmbt_trace_argi(
-	char		*func,
+	const char	*func,
 	xfs_btree_cur_t	*cur,
 	int		i,
 	int		line)
@@ -188,7 +188,7 @@ xfs_bmbt_trace_argi(
  */
 STATIC void
 xfs_bmbt_trace_argifk(
-	char			*func,
+	const char		*func,
 	xfs_btree_cur_t		*cur,
 	int			i,
 	xfs_fsblock_t		f,
@@ -206,7 +206,7 @@ xfs_bmbt_trace_argifk(
  */
 STATIC void
 xfs_bmbt_trace_argifr(
-	char			*func,
+	const char		*func,
 	xfs_btree_cur_t		*cur,
 	int			i,
 	xfs_fsblock_t		f,
@@ -235,7 +235,7 @@ xfs_bmbt_trace_argifr(
  */
 STATIC void
 xfs_bmbt_trace_argik(
-	char			*func,
+	const char		*func,
 	xfs_btree_cur_t		*cur,
 	int			i,
 	xfs_bmbt_key_t		*k,
@@ -255,7 +255,7 @@ xfs_bmbt_trace_argik(
  */
 STATIC void
 xfs_bmbt_trace_cursor(
-	char		*func,
+	const char	*func,
 	xfs_btree_cur_t	*cur,
 	char		*s,
 	int		line)
@@ -274,21 +274,21 @@ xfs_bmbt_trace_cursor(
 }
 
 #define	XFS_BMBT_TRACE_ARGBI(c,b,i)	\
-	xfs_bmbt_trace_argbi(fname, c, b, i, __LINE__)
+	xfs_bmbt_trace_argbi(__FUNCTION__, c, b, i, __LINE__)
 #define	XFS_BMBT_TRACE_ARGBII(c,b,i,j)	\
-	xfs_bmbt_trace_argbii(fname, c, b, i, j, __LINE__)
+	xfs_bmbt_trace_argbii(__FUNCTION__, c, b, i, j, __LINE__)
 #define	XFS_BMBT_TRACE_ARGFFFI(c,o,b,i,j)	\
-	xfs_bmbt_trace_argfffi(fname, c, o, b, i, j, __LINE__)
+	xfs_bmbt_trace_argfffi(__FUNCTION__, c, o, b, i, j, __LINE__)
 #define	XFS_BMBT_TRACE_ARGI(c,i)	\
-	xfs_bmbt_trace_argi(fname, c, i, __LINE__)
+	xfs_bmbt_trace_argi(__FUNCTION__, c, i, __LINE__)
 #define	XFS_BMBT_TRACE_ARGIFK(c,i,f,s)	\
-	xfs_bmbt_trace_argifk(fname, c, i, f, s, __LINE__)
+	xfs_bmbt_trace_argifk(__FUNCTION__, c, i, f, s, __LINE__)
 #define	XFS_BMBT_TRACE_ARGIFR(c,i,f,r)	\
-	xfs_bmbt_trace_argifr(fname, c, i, f, r, __LINE__)
+	xfs_bmbt_trace_argifr(__FUNCTION__, c, i, f, r, __LINE__)
 #define	XFS_BMBT_TRACE_ARGIK(c,i,k)	\
-	xfs_bmbt_trace_argik(fname, c, i, k, __LINE__)
+	xfs_bmbt_trace_argik(__FUNCTION__, c, i, k, __LINE__)
 #define	XFS_BMBT_TRACE_CURSOR(c,s)	\
-	xfs_bmbt_trace_cursor(fname, c, s, __LINE__)
+	xfs_bmbt_trace_cursor(__FUNCTION__, c, s, __LINE__)
 #else
 #define	XFS_BMBT_TRACE_ARGBI(c,b,i)
 #define	XFS_BMBT_TRACE_ARGBII(c,b,i,j)
@@ -318,9 +318,6 @@ xfs_bmbt_delrec(
 	xfs_fsblock_t		bno;		/* fs-relative block number */
 	xfs_buf_t		*bp;		/* buffer for block */
 	int			error;		/* error return value */
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_delrec";
-#endif
 	int			i;		/* loop counter */
 	int			j;		/* temp state */
 	xfs_bmbt_key_t		key;		/* bmap btree key */
@@ -694,9 +691,6 @@ xfs_bmbt_insrec(
 	xfs_bmbt_block_t	*block;		/* bmap btree block */
 	xfs_buf_t		*bp;		/* buffer for block */
 	int			error;		/* error return value */
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_insrec";
-#endif
 	int			i;		/* loop index */
 	xfs_bmbt_key_t		key;		/* bmap btree key */
 	xfs_bmbt_key_t		*kp=NULL;	/* pointer to bmap btree key */
@@ -881,9 +875,6 @@ xfs_bmbt_killroot(
 #ifdef DEBUG
 	int			error;
 #endif
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_killroot";
-#endif
 	int			i;
 	xfs_bmbt_key_t		*kp;
 	xfs_inode_t		*ip;
@@ -973,9 +964,6 @@ xfs_bmbt_log_keys(
 	int		kfirst,
 	int		klast)
 {
-#ifdef XFS_BMBT_TRACE
-	static char	fname[] = "xfs_bmbt_log_keys";
-#endif
 	xfs_trans_t	*tp;
 
 	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
@@ -1012,9 +1000,6 @@ xfs_bmbt_log_ptrs(
 	int		pfirst,
 	int		plast)
 {
-#ifdef XFS_BMBT_TRACE
-	static char	fname[] = "xfs_bmbt_log_ptrs";
-#endif
 	xfs_trans_t	*tp;
 
 	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
@@ -1055,9 +1040,6 @@ xfs_bmbt_lookup(
 	xfs_daddr_t		d;
 	xfs_sfiloff_t		diff;
 	int			error;		/* error return value */
-#ifdef XFS_BMBT_TRACE
-	static char	fname[] = "xfs_bmbt_lookup";
-#endif
 	xfs_fsblock_t		fsbno=0;
 	int			high;
 	int			i;
@@ -1195,9 +1177,6 @@ xfs_bmbt_lshift(
 	int			*stat)		/* success/failure */
 {
 	int			error;		/* error return value */
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_lshift";
-#endif
 #ifdef DEBUG
 	int			i;		/* loop counter */
 #endif
@@ -1331,9 +1310,6 @@ xfs_bmbt_rshift(
 	int			*stat)		/* success/failure */
 {
 	int			error;		/* error return value */
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_rshift";
-#endif
 	int			i;		/* loop counter */
 	xfs_bmbt_key_t		key;		/* bmap btree key */
 	xfs_buf_t		*lbp;		/* left buffer pointer */
@@ -1492,9 +1468,6 @@ xfs_bmbt_split(
 {
 	xfs_alloc_arg_t		args;		/* block allocation args */
 	int			error;		/* error return value */
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_split";
-#endif
 	int			i;		/* loop counter */
 	xfs_fsblock_t		lbno;		/* left sibling block number */
 	xfs_buf_t		*lbp;		/* left buffer pointer */
@@ -1641,9 +1614,6 @@ xfs_bmbt_updkey(
 #ifdef DEBUG
 	int			error;
 #endif
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_updkey";
-#endif
 	xfs_bmbt_key_t		*kp;
 	int			ptr;
 
@@ -1712,9 +1682,6 @@ xfs_bmbt_decrement(
 	xfs_bmbt_block_t	*block;
 	xfs_buf_t		*bp;
 	int			error;		/* error return value */
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_decrement";
-#endif
 	xfs_fsblock_t		fsbno;
 	int			lev;
 	xfs_mount_t		*mp;
@@ -1785,9 +1752,6 @@ xfs_bmbt_delete(
 	int		*stat)		/* success/failure */
 {
 	int		error;		/* error return value */
-#ifdef XFS_BMBT_TRACE
-	static char	fname[] = "xfs_bmbt_delete";
-#endif
 	int		i;
 	int		level;
 
@@ -2000,9 +1964,6 @@ xfs_bmbt_increment(
 	xfs_bmbt_block_t	*block;
 	xfs_buf_t		*bp;
 	int			error;		/* error return value */
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_increment";
-#endif
 	xfs_fsblock_t		fsbno;
 	int			lev;
 	xfs_mount_t		*mp;
@@ -2080,9 +2041,6 @@ xfs_bmbt_insert(
 	int		*stat)		/* success/failure */
 {
 	int		error;		/* error return value */
-#ifdef XFS_BMBT_TRACE
-	static char	fname[] = "xfs_bmbt_insert";
-#endif
 	int		i;
 	int		level;
 	xfs_fsblock_t	nbno;
@@ -2142,9 +2100,6 @@ xfs_bmbt_log_block(
 	int			fields)
 {
 	int			first;
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_log_block";
-#endif
 	int			last;
 	xfs_trans_t		*tp;
 	static const short	offsets[] = {
@@ -2181,9 +2136,6 @@ xfs_bmbt_log_recs(
 {
 	xfs_bmbt_block_t	*block;
 	int			first;
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_log_recs";
-#endif
 	int			last;
 	xfs_bmbt_rec_t		*rp;
 	xfs_trans_t		*tp;
@@ -2245,9 +2197,6 @@ xfs_bmbt_newroot(
 	xfs_bmbt_key_t		*ckp;		/* child key pointer */
 	xfs_bmbt_ptr_t		*cpp;		/* child ptr pointer */
 	int			error;		/* error return code */
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_newroot";
-#endif
 #ifdef DEBUG
 	int			i;		/* loop counter */
 #endif
@@ -2630,9 +2579,6 @@ xfs_bmbt_update(
 	xfs_bmbt_block_t	*block;
 	xfs_buf_t		*bp;
 	int			error;
-#ifdef XFS_BMBT_TRACE
-	static char		fname[] = "xfs_bmbt_update";
-#endif
 	xfs_bmbt_key_t		key;
 	int			ptr;
 	xfs_bmbt_rec_t		*rp;
Index: linux/fs/xfs/xfs_alloc.c
===================================================================
--- linux.orig/fs/xfs/xfs_alloc.c
+++ linux/fs/xfs/xfs_alloc.c
@@ -55,17 +55,17 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 ktrace_t *xfs_alloc_trace_buf;
 
 #define	TRACE_ALLOC(s,a)	\
-	xfs_alloc_trace_alloc(fname, s, a, __LINE__)
+	xfs_alloc_trace_alloc(__FUNCTION__, s, a, __LINE__)
 #define	TRACE_FREE(s,a,b,x,f)	\
-	xfs_alloc_trace_free(fname, s, mp, a, b, x, f, __LINE__)
+	xfs_alloc_trace_free(__FUNCTION__, s, mp, a, b, x, f, __LINE__)
 #define	TRACE_MODAGF(s,a,f)	\
-	xfs_alloc_trace_modagf(fname, s, mp, a, f, __LINE__)
-#define	TRACE_BUSY(fname,s,ag,agb,l,sl,tp)	\
-	xfs_alloc_trace_busy(fname, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSY, __LINE__)
-#define	TRACE_UNBUSY(fname,s,ag,sl,tp)	\
-	xfs_alloc_trace_busy(fname, s, mp, ag, -1, -1, sl, tp, XFS_ALLOC_KTRACE_UNBUSY, __LINE__)
-#define	TRACE_BUSYSEARCH(fname,s,ag,agb,l,sl,tp)	\
-	xfs_alloc_trace_busy(fname, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSYSEARCH, __LINE__)
+	xfs_alloc_trace_modagf(__FUNCTION__, s, mp, a, f, __LINE__)
+#define	TRACE_BUSY(__FUNCTION__,s,ag,agb,l,sl,tp)	\
+	xfs_alloc_trace_busy(__FUNCTION__, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSY, __LINE__)
+#define	TRACE_UNBUSY(__FUNCTION__,s,ag,sl,tp)	\
+	xfs_alloc_trace_busy(__FUNCTION__, s, mp, ag, -1, -1, sl, tp, XFS_ALLOC_KTRACE_UNBUSY, __LINE__)
+#define	TRACE_BUSYSEARCH(__FUNCTION__,s,ag,agb,l,sl,tp)	\
+	xfs_alloc_trace_busy(__FUNCTION__, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSYSEARCH, __LINE__)
 #else
 #define	TRACE_ALLOC(s,a)
 #define	TRACE_FREE(s,a,b,x,f)
@@ -420,7 +420,7 @@ xfs_alloc_read_agfl(
  */
 STATIC void
 xfs_alloc_trace_alloc(
-	char		*name,		/* function tag string */
+	const char	*name,		/* function tag string */
 	char		*str,		/* additional string */
 	xfs_alloc_arg_t	*args,		/* allocation argument structure */
 	int		line)		/* source line number */
@@ -453,7 +453,7 @@ xfs_alloc_trace_alloc(
  */
 STATIC void
 xfs_alloc_trace_free(
-	char		*name,		/* function tag string */
+	const char	*name,		/* function tag string */
 	char		*str,		/* additional string */
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_agnumber_t	agno,		/* allocation group number */
@@ -479,7 +479,7 @@ xfs_alloc_trace_free(
  */
 STATIC void
 xfs_alloc_trace_modagf(
-	char		*name,		/* function tag string */
+	const char	*name,		/* function tag string */
 	char		*str,		/* additional string */
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_agf_t	*agf,		/* new agf value */
@@ -507,7 +507,7 @@ xfs_alloc_trace_modagf(
 
 STATIC void
 xfs_alloc_trace_busy(
-	char		*name,		/* function tag string */
+	const char	*name,		/* function tag string */
 	char		*str,		/* additional string */
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_agnumber_t	agno,		/* allocation group number */
@@ -549,9 +549,6 @@ xfs_alloc_ag_vextent(
 	xfs_alloc_arg_t	*args)	/* argument structure for allocation */
 {
 	int		error=0;
-#ifdef XFS_ALLOC_TRACE
-	static char	fname[] = "xfs_alloc_ag_vextent";
-#endif
 
 	ASSERT(args->minlen > 0);
 	ASSERT(args->maxlen > 0);
@@ -635,9 +632,6 @@ xfs_alloc_ag_vextent_exact(
 	xfs_agblock_t	fbno;	/* start block of found extent */
 	xfs_agblock_t	fend;	/* end block of found extent */
 	xfs_extlen_t	flen;	/* length of found extent */
-#ifdef XFS_ALLOC_TRACE
-	static char	fname[] = "xfs_alloc_ag_vextent_exact";
-#endif
 	int		i;	/* success/failure of operation */
 	xfs_agblock_t	maxend;	/* end of maximal extent */
 	xfs_agblock_t	minend;	/* end of minimal extent */
@@ -737,9 +731,6 @@ xfs_alloc_ag_vextent_near(
 	xfs_btree_cur_t	*bno_cur_gt;	/* cursor for bno btree, right side */
 	xfs_btree_cur_t	*bno_cur_lt;	/* cursor for bno btree, left side */
 	xfs_btree_cur_t	*cnt_cur;	/* cursor for count btree */
-#ifdef XFS_ALLOC_TRACE
-	static char	fname[] = "xfs_alloc_ag_vextent_near";
-#endif
 	xfs_agblock_t	gtbno;		/* start bno of right side entry */
 	xfs_agblock_t	gtbnoa;		/* aligned ... */
 	xfs_extlen_t	gtdiff;		/* difference to right side entry */
@@ -1270,9 +1261,6 @@ xfs_alloc_ag_vextent_size(
 	int		error;		/* error result */
 	xfs_agblock_t	fbno;		/* start of found freespace */
 	xfs_extlen_t	flen;		/* length of found freespace */
-#ifdef XFS_ALLOC_TRACE
-	static char	fname[] = "xfs_alloc_ag_vextent_size";
-#endif
 	int		i;		/* temp status variable */
 	xfs_agblock_t	rbno;		/* returned block number */
 	xfs_extlen_t	rlen;		/* length of returned extent */
@@ -1427,9 +1415,6 @@ xfs_alloc_ag_vextent_small(
 	int		error;
 	xfs_agblock_t	fbno;
 	xfs_extlen_t	flen;
-#ifdef XFS_ALLOC_TRACE
-	static char	fname[] = "xfs_alloc_ag_vextent_small";
-#endif
 	int		i;
 
 	if ((error = xfs_alloc_decrement(ccur, 0, &i)))
@@ -1516,9 +1501,6 @@ xfs_free_ag_extent(
 	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
 	xfs_btree_cur_t	*cnt_cur;	/* cursor for by-size btree */
 	int		error;		/* error return value */
-#ifdef XFS_ALLOC_TRACE
-	static char	fname[] = "xfs_free_ag_extent";
-#endif
 	xfs_agblock_t	gtbno;		/* start of right neighbor block */
 	xfs_extlen_t	gtlen;		/* length of right neighbor block */
 	int		haveleft;	/* have a left neighbor block */
@@ -2003,9 +1985,6 @@ xfs_alloc_get_freelist(
 	xfs_agblock_t	bno;	/* block number returned */
 	int		error;
 	int		logflags;
-#ifdef XFS_ALLOC_TRACE
-	static char	fname[] = "xfs_alloc_get_freelist";
-#endif
 	xfs_mount_t	*mp;	/* mount structure */
 	xfs_perag_t	*pag;	/* per allocation group data */
 
@@ -2128,9 +2107,6 @@ xfs_alloc_put_freelist(
 	__be32			*blockp;/* pointer to array entry */
 	int			error;
 	int			logflags;
-#ifdef XFS_ALLOC_TRACE
-	static char		fname[] = "xfs_alloc_put_freelist";
-#endif
 	xfs_mount_t		*mp;	/* mount structure */
 	xfs_perag_t		*pag;	/* per allocation group data */
 
@@ -2263,9 +2239,6 @@ xfs_alloc_vextent(
 	xfs_agblock_t	agsize;	/* allocation group size */
 	int		error;
 	int		flags;	/* XFS_ALLOC_FLAG_... locking flags */
-#ifdef XFS_ALLOC_TRACE
-	static char	fname[] = "xfs_alloc_vextent";
-#endif
 	xfs_extlen_t	minleft;/* minimum left value, temp copy */
 	xfs_mount_t	*mp;	/* mount structure pointer */
 	xfs_agnumber_t	sagno;	/* starting allocation group number */
Index: linux/fs/xfs/xfs_bmap.c
===================================================================
--- linux.orig/fs/xfs/xfs_bmap.c
+++ linux/fs/xfs/xfs_bmap.c
@@ -277,7 +277,7 @@ xfs_bmap_isaeof(
 STATIC void
 xfs_bmap_trace_addentry(
 	int		opcode,		/* operation */
-	char		*fname,		/* function name */
+	const char	*fname,		/* function name */
 	char		*desc,		/* operation description */
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index of entry(ies) */
@@ -291,7 +291,7 @@ xfs_bmap_trace_addentry(
  */
 STATIC void
 xfs_bmap_trace_delete(
-	char		*fname,		/* function name */
+	const char	*fname,		/* function name */
 	char		*desc,		/* operation description */
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index of entry(entries) deleted */
@@ -304,7 +304,7 @@ xfs_bmap_trace_delete(
  */
 STATIC void
 xfs_bmap_trace_insert(
-	char		*fname,		/* function name */
+	const char	*fname,		/* function name */
 	char		*desc,		/* operation description */
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index of entry(entries) inserted */
@@ -318,7 +318,7 @@ xfs_bmap_trace_insert(
  */
 STATIC void
 xfs_bmap_trace_post_update(
-	char		*fname,		/* function name */
+	const char	*fname,		/* function name */
 	char		*desc,		/* operation description */
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index of entry updated */
@@ -329,17 +329,25 @@ xfs_bmap_trace_post_update(
  */
 STATIC void
 xfs_bmap_trace_pre_update(
-	char		*fname,		/* function name */
+	const char	*fname,		/* function name */
 	char		*desc,		/* operation description */
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index of entry to be updated */
 	int		whichfork);	/* data or attr fork */
 
+#define	XFS_BMAP_TRACE_DELETE(d,ip,i,c,w)	\
+	xfs_bmap_trace_delete(__FUNCTION__,d,ip,i,c,w)
+#define	XFS_BMAP_TRACE_INSERT(d,ip,i,c,r1,r2,w)	\
+	xfs_bmap_trace_insert(__FUNCTION__,d,ip,i,c,r1,r2,w)
+#define	XFS_BMAP_TRACE_POST_UPDATE(d,ip,i,w)	\
+	xfs_bmap_trace_post_update(__FUNCTION__,d,ip,i,w)
+#define	XFS_BMAP_TRACE_PRE_UPDATE(d,ip,i,w)	\
+	xfs_bmap_trace_pre_update(__FUNCTION__,d,ip,i,w)
 #else
-#define	xfs_bmap_trace_delete(f,d,ip,i,c,w)
-#define	xfs_bmap_trace_insert(f,d,ip,i,c,r1,r2,w)
-#define	xfs_bmap_trace_post_update(f,d,ip,i,w)
-#define	xfs_bmap_trace_pre_update(f,d,ip,i,w)
+#define	XFS_BMAP_TRACE_DELETE(d,ip,i,c,w)
+#define	XFS_BMAP_TRACE_INSERT(d,ip,i,c,r1,r2,w)
+#define	XFS_BMAP_TRACE_POST_UPDATE(d,ip,i,w)
+#define	XFS_BMAP_TRACE_PRE_UPDATE(d,ip,i,w)
 #endif	/* XFS_BMAP_TRACE */
 
 /*
@@ -531,9 +539,6 @@ xfs_bmap_add_extent(
 	xfs_filblks_t		da_new; /* new count del alloc blocks used */
 	xfs_filblks_t		da_old; /* old count del alloc blocks used */
 	int			error;	/* error return value */
-#ifdef XFS_BMAP_TRACE
-	static char		fname[] = "xfs_bmap_add_extent";
-#endif
 	xfs_ifork_t		*ifp;	/* inode fork ptr */
 	int			logflags; /* returned value */
 	xfs_extnum_t		nextents; /* number of extents in file now */
@@ -551,8 +556,8 @@ xfs_bmap_add_extent(
 	 * already extents in the list.
 	 */
 	if (nextents == 0) {
-		xfs_bmap_trace_insert(fname, "insert empty", ip, 0, 1, new,
-			NULL, whichfork);
+		XFS_BMAP_TRACE_INSERT("insert empty", ip, 0, 1, new, NULL,
+			whichfork);
 		xfs_iext_insert(ifp, 0, 1, new);
 		ASSERT(cur == NULL);
 		ifp->if_lastex = 0;
@@ -710,9 +715,6 @@ xfs_bmap_add_extent_delay_real(
 	int			diff;	/* temp value */
 	xfs_bmbt_rec_t		*ep;	/* extent entry for idx */
 	int			error;	/* error return value */
-#ifdef XFS_BMAP_TRACE
-	static char		fname[] = "xfs_bmap_add_extent_delay_real";
-#endif
 	int			i;	/* temp state */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
 	xfs_fileoff_t		new_endoff;	/* end offset of new entry */
@@ -808,15 +810,14 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left and right neighbors are both contiguous with new.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LF|RF|LC|RC", ip, idx - 1,
+		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + PREV.br_blockcount +
 			RIGHT.br_blockcount);
-		xfs_bmap_trace_post_update(fname, "LF|RF|LC|RC", ip, idx - 1,
-			XFS_DATA_FORK);
-		xfs_bmap_trace_delete(fname, "LF|RF|LC|RC", ip, idx, 2,
+		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_DELETE("LF|RF|LC|RC", ip, idx, 2, XFS_DATA_FORK);
 		xfs_iext_remove(ifp, idx, 2);
 		ip->i_df.if_lastex = idx - 1;
 		ip->i_d.di_nextents--;
@@ -855,15 +856,14 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LF|RF|LC", ip, idx - 1,
+		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + PREV.br_blockcount);
-		xfs_bmap_trace_post_update(fname, "LF|RF|LC", ip, idx - 1,
+		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx - 1;
-		xfs_bmap_trace_delete(fname, "LF|RF|LC", ip, idx, 1,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_DELETE("LF|RF|LC", ip, idx, 1, XFS_DATA_FORK);
 		xfs_iext_remove(ifp, idx, 1);
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -892,16 +892,13 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The right neighbor is contiguous, the left is not.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LF|RF|RC", ip, idx,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|RC", ip, idx, XFS_DATA_FORK);
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount + RIGHT.br_blockcount);
-		xfs_bmap_trace_post_update(fname, "LF|RF|RC", ip, idx,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|RC", ip, idx, XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx;
-		xfs_bmap_trace_delete(fname, "LF|RF|RC", ip, idx + 1, 1,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_DELETE("LF|RF|RC", ip, idx + 1, 1, XFS_DATA_FORK);
 		xfs_iext_remove(ifp, idx + 1, 1);
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -931,11 +928,9 @@ xfs_bmap_add_extent_delay_real(
 		 * Neither the left nor right neighbors are contiguous with
 		 * the new one.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LF|RF", ip, idx,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF", ip, idx, XFS_DATA_FORK);
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
-		xfs_bmap_trace_post_update(fname, "LF|RF", ip, idx,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("LF|RF", ip, idx, XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
@@ -963,17 +958,14 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is contiguous.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LF|LC", ip, idx - 1,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("LF|LC", ip, idx - 1, XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + new->br_blockcount);
 		xfs_bmbt_set_startoff(ep,
 			PREV.br_startoff + new->br_blockcount);
-		xfs_bmap_trace_post_update(fname, "LF|LC", ip, idx - 1,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx - 1, XFS_DATA_FORK);
 		temp = PREV.br_blockcount - new->br_blockcount;
-		xfs_bmap_trace_pre_update(fname, "LF|LC", ip, idx,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("LF|LC", ip, idx, XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep, temp);
 		ip->i_df.if_lastex = idx - 1;
 		if (cur == NULL)
@@ -995,8 +987,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 			STARTBLOCKVAL(PREV.br_startblock));
 		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-		xfs_bmap_trace_post_update(fname, "LF|LC", ip, idx,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: The boundary between two in-core extents moved. */
 		temp = LEFT.br_startoff;
@@ -1009,11 +1000,11 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is not contiguous.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LF", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("LF", ip, idx, XFS_DATA_FORK);
 		xfs_bmbt_set_startoff(ep, new_endoff);
 		temp = PREV.br_blockcount - new->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
-		xfs_bmap_trace_insert(fname, "LF", ip, idx, 1, new, NULL,
+		XFS_BMAP_TRACE_INSERT("LF", ip, idx, 1, new, NULL,
 			XFS_DATA_FORK);
 		xfs_iext_insert(ifp, idx, 1, new);
 		ip->i_df.if_lastex = idx;
@@ -1046,8 +1037,7 @@ xfs_bmap_add_extent_delay_real(
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, idx + 1);
 		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-		xfs_bmap_trace_post_update(fname, "LF", ip, idx + 1,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("LF", ip, idx + 1, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: One in-core extent is split in two. */
 		temp = PREV.br_startoff;
@@ -1060,17 +1050,14 @@ xfs_bmap_add_extent_delay_real(
 		 * The right neighbor is contiguous with the new allocation.
 		 */
 		temp = PREV.br_blockcount - new->br_blockcount;
-		xfs_bmap_trace_pre_update(fname, "RF|RC", ip, idx,
-			XFS_DATA_FORK);
-		xfs_bmap_trace_pre_update(fname, "RF|RC", ip, idx + 1,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("RF|RC", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("RF|RC", ip, idx + 1, XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep, temp);
 		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, idx + 1),
 			new->br_startoff, new->br_startblock,
 			new->br_blockcount + RIGHT.br_blockcount,
 			RIGHT.br_state);
-		xfs_bmap_trace_post_update(fname, "RF|RC", ip, idx + 1,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx + 1, XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx + 1;
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -1091,8 +1078,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 			STARTBLOCKVAL(PREV.br_startblock));
 		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-		xfs_bmap_trace_post_update(fname, "RF|RC", ip, idx,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: The boundary between two in-core extents moved. */
 		temp = PREV.br_startoff;
@@ -1106,10 +1092,10 @@ xfs_bmap_add_extent_delay_real(
 		 * The right neighbor is not contiguous.
 		 */
 		temp = PREV.br_blockcount - new->br_blockcount;
-		xfs_bmap_trace_pre_update(fname, "RF", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("RF", ip, idx, XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep, temp);
-		xfs_bmap_trace_insert(fname, "RF", ip, idx + 1, 1,
-			new, NULL, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_INSERT("RF", ip, idx + 1, 1, new, NULL,
+			XFS_DATA_FORK);
 		xfs_iext_insert(ifp, idx + 1, 1, new);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents++;
@@ -1141,7 +1127,7 @@ xfs_bmap_add_extent_delay_real(
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, idx);
 		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-		xfs_bmap_trace_post_update(fname, "RF", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("RF", ip, idx, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: One in-core extent is split in two. */
 		temp = PREV.br_startoff;
@@ -1155,7 +1141,7 @@ xfs_bmap_add_extent_delay_real(
 		 * This case is avoided almost all the time.
 		 */
 		temp = new->br_startoff - PREV.br_startoff;
-		xfs_bmap_trace_pre_update(fname, "0", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx, XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep, temp);
 		r[0] = *new;
 		r[1].br_state = PREV.br_state;
@@ -1163,7 +1149,7 @@ xfs_bmap_add_extent_delay_real(
 		r[1].br_startoff = new_endoff;
 		temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
 		r[1].br_blockcount = temp2;
-		xfs_bmap_trace_insert(fname, "0", ip, idx + 1, 2, &r[0], &r[1],
+		XFS_BMAP_TRACE_INSERT("0", ip, idx + 1, 2, &r[0], &r[1],
 			XFS_DATA_FORK);
 		xfs_iext_insert(ifp, idx + 1, 2, &r[0]);
 		ip->i_df.if_lastex = idx + 1;
@@ -1222,13 +1208,11 @@ xfs_bmap_add_extent_delay_real(
 		}
 		ep = xfs_iext_get_ext(ifp, idx);
 		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-		xfs_bmap_trace_post_update(fname, "0", ip, idx, XFS_DATA_FORK);
-		xfs_bmap_trace_pre_update(fname, "0", ip, idx + 2,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx + 2, XFS_DATA_FORK);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx + 2),
 			NULLSTARTBLOCK((int)temp2));
-		xfs_bmap_trace_post_update(fname, "0", ip, idx + 2,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx + 2, XFS_DATA_FORK);
 		*dnew = temp + temp2;
 		/* DELTA: One in-core extent is split in three. */
 		temp = PREV.br_startoff;
@@ -1287,9 +1271,6 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_btree_cur_t		*cur;	/* btree cursor */
 	xfs_bmbt_rec_t		*ep;	/* extent entry for idx */
 	int			error;	/* error return value */
-#ifdef XFS_BMAP_TRACE
-	static char		fname[] = "xfs_bmap_add_extent_unwritten_real";
-#endif
 	int			i;	/* temp state */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
 	xfs_fileoff_t		new_endoff;	/* end offset of new entry */
@@ -1390,15 +1371,14 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left and right neighbors are both contiguous with new.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LF|RF|LC|RC", ip, idx - 1,
+		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + PREV.br_blockcount +
 			RIGHT.br_blockcount);
-		xfs_bmap_trace_post_update(fname, "LF|RF|LC|RC", ip, idx - 1,
-			XFS_DATA_FORK);
-		xfs_bmap_trace_delete(fname, "LF|RF|LC|RC", ip, idx, 2,
+		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_DELETE("LF|RF|LC|RC", ip, idx, 2, XFS_DATA_FORK);
 		xfs_iext_remove(ifp, idx, 2);
 		ip->i_df.if_lastex = idx - 1;
 		ip->i_d.di_nextents -= 2;
@@ -1441,15 +1421,14 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LF|RF|LC", ip, idx - 1,
+		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + PREV.br_blockcount);
-		xfs_bmap_trace_post_update(fname, "LF|RF|LC", ip, idx - 1,
+		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx - 1;
-		xfs_bmap_trace_delete(fname, "LF|RF|LC", ip, idx, 1,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_DELETE("LF|RF|LC", ip, idx, 1, XFS_DATA_FORK);
 		xfs_iext_remove(ifp, idx, 1);
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
@@ -1484,16 +1463,15 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting all of a previous oldext extent to newext.
 		 * The right neighbor is contiguous, the left is not.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LF|RF|RC", ip, idx,
+		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF|RC", ip, idx,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount + RIGHT.br_blockcount);
 		xfs_bmbt_set_state(ep, newext);
-		xfs_bmap_trace_post_update(fname, "LF|RF|RC", ip, idx,
+		XFS_BMAP_TRACE_POST_UPDATE("LF|RF|RC", ip, idx,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx;
-		xfs_bmap_trace_delete(fname, "LF|RF|RC", ip, idx + 1, 1,
-			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_DELETE("LF|RF|RC", ip, idx + 1, 1, XFS_DATA_FORK);
 		xfs_iext_remove(ifp, idx + 1, 1);
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
@@ -1529,10 +1507,10 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Neither the left nor right neighbors are contiguous with
 		 * the new one.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LF|RF", ip, idx,
+		XFS_BMAP_TRACE_PRE_UPDATE("LF|RF", ip, idx,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_state(ep, newext);
-		xfs_bmap_trace_post_update(fname, "LF|RF", ip, idx,
+		XFS_BMAP_TRACE_POST_UPDATE("LF|RF", ip, idx,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx;
 		if (cur == NULL)
@@ -1559,21 +1537,21 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the first part of a previous oldext extent to newext.
 		 * The left neighbor is contiguous.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LF|LC", ip, idx - 1,
+		XFS_BMAP_TRACE_PRE_UPDATE("LF|LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			LEFT.br_blockcount + new->br_blockcount);
 		xfs_bmbt_set_startoff(ep,
 			PREV.br_startoff + new->br_blockcount);
-		xfs_bmap_trace_post_update(fname, "LF|LC", ip, idx - 1,
+		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx - 1,
 			XFS_DATA_FORK);
-		xfs_bmap_trace_pre_update(fname, "LF|LC", ip, idx,
+		XFS_BMAP_TRACE_PRE_UPDATE("LF|LC", ip, idx,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_startblock(ep,
 			new->br_startblock + new->br_blockcount);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
-		xfs_bmap_trace_post_update(fname, "LF|LC", ip, idx,
+		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx - 1;
 		if (cur == NULL)
@@ -1610,15 +1588,15 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the first part of a previous oldext extent to newext.
 		 * The left neighbor is not contiguous.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LF", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("LF", ip, idx, XFS_DATA_FORK);
 		ASSERT(ep && xfs_bmbt_get_state(ep) == oldext);
 		xfs_bmbt_set_startoff(ep, new_endoff);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
 		xfs_bmbt_set_startblock(ep,
 			new->br_startblock + new->br_blockcount);
-		xfs_bmap_trace_post_update(fname, "LF", ip, idx, XFS_DATA_FORK);
-		xfs_bmap_trace_insert(fname, "LF", ip, idx, 1, new, NULL,
+		XFS_BMAP_TRACE_POST_UPDATE("LF", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_INSERT("LF", ip, idx, 1, new, NULL,
 			XFS_DATA_FORK);
 		xfs_iext_insert(ifp, idx, 1, new);
 		ip->i_df.if_lastex = idx;
@@ -1653,18 +1631,18 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the last part of a previous oldext extent to newext.
 		 * The right neighbor is contiguous with the new allocation.
 		 */
-		xfs_bmap_trace_pre_update(fname, "RF|RC", ip, idx,
+		XFS_BMAP_TRACE_PRE_UPDATE("RF|RC", ip, idx,
 			XFS_DATA_FORK);
-		xfs_bmap_trace_pre_update(fname, "RF|RC", ip, idx + 1,
+		XFS_BMAP_TRACE_PRE_UPDATE("RF|RC", ip, idx + 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
-		xfs_bmap_trace_post_update(fname, "RF|RC", ip, idx,
+		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, idx + 1),
 			new->br_startoff, new->br_startblock,
 			new->br_blockcount + RIGHT.br_blockcount, newext);
-		xfs_bmap_trace_post_update(fname, "RF|RC", ip, idx + 1,
+		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx + 1,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx + 1;
 		if (cur == NULL)
@@ -1700,12 +1678,12 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the last part of a previous oldext extent to newext.
 		 * The right neighbor is not contiguous.
 		 */
-		xfs_bmap_trace_pre_update(fname, "RF", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("RF", ip, idx, XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
-		xfs_bmap_trace_post_update(fname, "RF", ip, idx, XFS_DATA_FORK);
-		xfs_bmap_trace_insert(fname, "RF", ip, idx + 1, 1,
-			new, NULL, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("RF", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_INSERT("RF", ip, idx + 1, 1, new, NULL,
+			XFS_DATA_FORK);
 		xfs_iext_insert(ifp, idx + 1, 1, new);
 		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents++;
@@ -1744,17 +1722,17 @@ xfs_bmap_add_extent_unwritten_real(
 		 * newext.  Contiguity is impossible here.
 		 * One extent becomes three extents.
 		 */
-		xfs_bmap_trace_pre_update(fname, "0", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx, XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(ep,
 			new->br_startoff - PREV.br_startoff);
-		xfs_bmap_trace_post_update(fname, "0", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx, XFS_DATA_FORK);
 		r[0] = *new;
 		r[1].br_startoff = new_endoff;
 		r[1].br_blockcount =
 			PREV.br_startoff + PREV.br_blockcount - new_endoff;
 		r[1].br_startblock = new->br_startblock + new->br_blockcount;
 		r[1].br_state = oldext;
-		xfs_bmap_trace_insert(fname, "0", ip, idx + 1, 2, &r[0], &r[1],
+		XFS_BMAP_TRACE_INSERT("0", ip, idx + 1, 2, &r[0], &r[1],
 			XFS_DATA_FORK);
 		xfs_iext_insert(ifp, idx + 1, 2, &r[0]);
 		ip->i_df.if_lastex = idx + 1;
@@ -1845,9 +1823,6 @@ xfs_bmap_add_extent_hole_delay(
 	int			rsvd)		/* OK to allocate reserved blocks */
 {
 	xfs_bmbt_rec_t		*ep;	/* extent record for idx */
-#ifdef XFS_BMAP_TRACE
-	static char		fname[] = "xfs_bmap_add_extent_hole_delay";
-#endif
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
 	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
 	xfs_filblks_t		newlen=0;	/* new indirect size */
@@ -1919,7 +1894,7 @@ xfs_bmap_add_extent_hole_delay(
 		 */
 		temp = left.br_blockcount + new->br_blockcount +
 			right.br_blockcount;
-		xfs_bmap_trace_pre_update(fname, "LC|RC", ip, idx - 1,
+		XFS_BMAP_TRACE_PRE_UPDATE("LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1), temp);
 		oldlen = STARTBLOCKVAL(left.br_startblock) +
@@ -1928,10 +1903,9 @@ xfs_bmap_add_extent_hole_delay(
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx - 1),
 			NULLSTARTBLOCK((int)newlen));
-		xfs_bmap_trace_post_update(fname, "LC|RC", ip, idx - 1,
-			XFS_DATA_FORK);
-		xfs_bmap_trace_delete(fname, "LC|RC", ip, idx, 1,
+		XFS_BMAP_TRACE_POST_UPDATE("LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
+		XFS_BMAP_TRACE_DELETE("LC|RC", ip, idx, 1, XFS_DATA_FORK);
 		xfs_iext_remove(ifp, idx, 1);
 		ip->i_df.if_lastex = idx - 1;
 		/* DELTA: Two in-core extents were replaced by one. */
@@ -1946,7 +1920,7 @@ xfs_bmap_add_extent_hole_delay(
 		 * Merge the new allocation with the left neighbor.
 		 */
 		temp = left.br_blockcount + new->br_blockcount;
-		xfs_bmap_trace_pre_update(fname, "LC", ip, idx - 1,
+		XFS_BMAP_TRACE_PRE_UPDATE("LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1), temp);
 		oldlen = STARTBLOCKVAL(left.br_startblock) +
@@ -1954,7 +1928,7 @@ xfs_bmap_add_extent_hole_delay(
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx - 1),
 			NULLSTARTBLOCK((int)newlen));
-		xfs_bmap_trace_post_update(fname, "LC", ip, idx - 1,
+		XFS_BMAP_TRACE_POST_UPDATE("LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx - 1;
 		/* DELTA: One in-core extent grew into a hole. */
@@ -1968,14 +1942,14 @@ xfs_bmap_add_extent_hole_delay(
 		 * on the right.
 		 * Merge the new allocation with the right neighbor.
 		 */
-		xfs_bmap_trace_pre_update(fname, "RC", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_PRE_UPDATE("RC", ip, idx, XFS_DATA_FORK);
 		temp = new->br_blockcount + right.br_blockcount;
 		oldlen = STARTBLOCKVAL(new->br_startblock) +
 			STARTBLOCKVAL(right.br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_allf(ep, new->br_startoff,
 			NULLSTARTBLOCK((int)newlen), temp, right.br_state);
-		xfs_bmap_trace_post_update(fname, "RC", ip, idx, XFS_DATA_FORK);
+		XFS_BMAP_TRACE_POST_UPDATE("RC", ip, idx, XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx;
 		/* DELTA: One in-core extent grew into a hole. */
 		temp2 = temp;
@@ -1989,7 +1963,7 @@ xfs_bmap_add_extent_hole_delay(
 		 * Insert a new entry.
 		 */
 		oldlen = newlen = 0;
-		xfs_bmap_trace_insert(fname, "0", ip, idx, 1, new, NULL,
+		XFS_BMAP_TRACE_INSERT("0", ip, idx, 1, new, NULL,
 			XFS_DATA_FORK);
 		xfs_iext_insert(ifp, idx, 1, new);
 		ip->i_df.if_lastex = idx;
@@ -2039,9 +2013,6 @@ xfs_bmap_add_extent_hole_real(
 {
 	xfs_bmbt_rec_t		*ep;	/* pointer to extent entry ins. point */
 	int			error;	/* error return value */
-#ifdef XFS_BMAP_TRACE
-	static char		fname[] = "xfs_bmap_add_extent_hole_real";
-#endif
 	int			i;	/* temp state */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
 	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
@@ -2118,15 +2089,14 @@ xfs_bmap_add_extent_hole_real(
 		 * left and on the right.
 		 * Merge all three into a single extent record.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LC|RC", ip, idx - 1,
+		XFS_BMAP_TRACE_PRE_UPDATE("LC|RC", ip, idx - 1,
 			whichfork);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			left.br_blockcount + new->br_blockcount +
 			right.br_blockcount);
-		xfs_bmap_trace_post_update(fname, "LC|RC", ip, idx - 1,
+		XFS_BMAP_TRACE_POST_UPDATE("LC|RC", ip, idx - 1,
 			whichfork);
-		xfs_bmap_trace_delete(fname, "LC|RC", ip,
-			idx, 1, whichfork);
+		XFS_BMAP_TRACE_DELETE("LC|RC", ip, idx, 1, whichfork);
 		xfs_iext_remove(ifp, idx, 1);
 		ifp->if_lastex = idx - 1;
 		XFS_IFORK_NEXT_SET(ip, whichfork,
@@ -2168,10 +2138,10 @@ xfs_bmap_add_extent_hole_real(
 		 * on the left.
 		 * Merge the new allocation with the left neighbor.
 		 */
-		xfs_bmap_trace_pre_update(fname, "LC", ip, idx - 1, whichfork);
+		XFS_BMAP_TRACE_PRE_UPDATE("LC", ip, idx - 1, whichfork);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
 			left.br_blockcount + new->br_blockcount);
-		xfs_bmap_trace_post_update(fname, "LC", ip, idx - 1, whichfork);
+		XFS_BMAP_TRACE_POST_UPDATE("LC", ip, idx - 1, whichfork);
 		ifp->if_lastex = idx - 1;
 		if (cur == NULL) {
 			rval = XFS_ILOG_FEXT(whichfork);
@@ -2202,11 +2172,11 @@ xfs_bmap_add_extent_hole_real(
 		 * on the right.
 		 * Merge the new allocation with the right neighbor.
 		 */
-		xfs_bmap_trace_pre_update(fname, "RC", ip, idx, whichfork);
+		XFS_BMAP_TRACE_PRE_UPDATE("RC", ip, idx, whichfork);
 		xfs_bmbt_set_allf(ep, new->br_startoff, new->br_startblock,
 			new->br_blockcount + right.br_blockcount,
 			right.br_state);
-		xfs_bmap_trace_post_update(fname, "RC", ip, idx, whichfork);
+		XFS_BMAP_TRACE_POST_UPDATE("RC", ip, idx, whichfork);
 		ifp->if_lastex = idx;
 		if (cur == NULL) {
 			rval = XFS_ILOG_FEXT(whichfork);
@@ -2237,8 +2207,7 @@ xfs_bmap_add_extent_hole_real(
 		 * real allocation.
 		 * Insert a new entry.
 		 */
-		xfs_bmap_trace_insert(fname, "0", ip, idx, 1, new, NULL,
-			whichfork);
+		XFS_BMAP_TRACE_INSERT("0", ip, idx, 1, new, NULL, whichfork);
 		xfs_iext_insert(ifp, idx, 1, new);
 		ifp->if_lastex = idx;
 		XFS_IFORK_NEXT_SET(ip, whichfork,
@@ -3048,9 +3017,6 @@ xfs_bmap_del_extent(
 	xfs_bmbt_rec_t		*ep;	/* current extent entry pointer */
 	int			error;	/* error return value */
 	int			flags;	/* inode logging flags */
-#ifdef XFS_BMAP_TRACE
-	static char		fname[] = "xfs_bmap_del_extent";
-#endif
 	xfs_bmbt_irec_t		got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
 	int			i;	/* temp state */
@@ -3144,7 +3110,7 @@ xfs_bmap_del_extent(
 		/*
 		 * Matches the whole extent.  Delete the entry.
 		 */
-		xfs_bmap_trace_delete(fname, "3", ip, idx, 1, whichfork);
+		XFS_BMAP_TRACE_DELETE("3", ip, idx, 1, whichfork);
 		xfs_iext_remove(ifp, idx, 1);
 		ifp->if_lastex = idx;
 		if (delay)
@@ -3165,7 +3131,7 @@ xfs_bmap_del_extent(
 		/*
 		 * Deleting the first part of the extent.
 		 */
-		xfs_bmap_trace_pre_update(fname, "2", ip, idx, whichfork);
+		XFS_BMAP_TRACE_PRE_UPDATE("2", ip, idx, whichfork);
 		xfs_bmbt_set_startoff(ep, del_endoff);
 		temp = got.br_blockcount - del->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
@@ -3174,13 +3140,13 @@ xfs_bmap_del_extent(
 			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 				da_old);
 			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-			xfs_bmap_trace_post_update(fname, "2", ip, idx,
+			XFS_BMAP_TRACE_POST_UPDATE("2", ip, idx,
 				whichfork);
 			da_new = temp;
 			break;
 		}
 		xfs_bmbt_set_startblock(ep, del_endblock);
-		xfs_bmap_trace_post_update(fname, "2", ip, idx, whichfork);
+		XFS_BMAP_TRACE_POST_UPDATE("2", ip, idx, whichfork);
 		if (!cur) {
 			flags |= XFS_ILOG_FEXT(whichfork);
 			break;
@@ -3196,19 +3162,19 @@ xfs_bmap_del_extent(
 		 * Deleting the last part of the extent.
 		 */
 		temp = got.br_blockcount - del->br_blockcount;
-		xfs_bmap_trace_pre_update(fname, "1", ip, idx, whichfork);
+		XFS_BMAP_TRACE_PRE_UPDATE("1", ip, idx, whichfork);
 		xfs_bmbt_set_blockcount(ep, temp);
 		ifp->if_lastex = idx;
 		if (delay) {
 			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 				da_old);
 			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
-			xfs_bmap_trace_post_update(fname, "1", ip, idx,
+			XFS_BMAP_TRACE_POST_UPDATE("1", ip, idx,
 				whichfork);
 			da_new = temp;
 			break;
 		}
-		xfs_bmap_trace_post_update(fname, "1", ip, idx, whichfork);
+		XFS_BMAP_TRACE_POST_UPDATE("1", ip, idx, whichfork);
 		if (!cur) {
 			flags |= XFS_ILOG_FEXT(whichfork);
 			break;
@@ -3225,7 +3191,7 @@ xfs_bmap_del_extent(
 		 * Deleting the middle of the extent.
 		 */
 		temp = del->br_startoff - got.br_startoff;
-		xfs_bmap_trace_pre_update(fname, "0", ip, idx, whichfork);
+		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx, whichfork);
 		xfs_bmbt_set_blockcount(ep, temp);
 		new.br_startoff = del_endoff;
 		temp2 = got_endoff - del_endoff;
@@ -3312,8 +3278,8 @@ xfs_bmap_del_extent(
 				}
 			}
 		}
-		xfs_bmap_trace_post_update(fname, "0", ip, idx, whichfork);
-		xfs_bmap_trace_insert(fname, "0", ip, idx + 1, 1, &new, NULL,
+		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx, whichfork);
+		XFS_BMAP_TRACE_INSERT("0", ip, idx + 1, 1, &new, NULL,
 			whichfork);
 		xfs_iext_insert(ifp, idx + 1, 1, &new);
 		ifp->if_lastex = idx + 1;
@@ -3553,9 +3519,6 @@ xfs_bmap_local_to_extents(
 {
 	int		error;		/* error return value */
 	int		flags;		/* logging flags returned */
-#ifdef XFS_BMAP_TRACE
-	static char	fname[] = "xfs_bmap_local_to_extents";
-#endif
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
 
 	/*
@@ -3610,7 +3573,7 @@ xfs_bmap_local_to_extents(
 		xfs_iext_add(ifp, 0, 1);
 		ep = xfs_iext_get_ext(ifp, 0);
 		xfs_bmbt_set_allf(ep, 0, args.fsbno, 1, XFS_EXT_NORM);
-		xfs_bmap_trace_post_update(fname, "new", ip, 0, whichfork);
+		XFS_BMAP_TRACE_POST_UPDATE("new", ip, 0, whichfork);
 		XFS_IFORK_NEXT_SET(ip, whichfork, 1);
 		ip->i_d.di_nblocks = 1;
 		XFS_TRANS_MOD_DQUOT_BYINO(args.mp, tp, ip,
@@ -3733,7 +3696,7 @@ ktrace_t	*xfs_bmap_trace_buf;
 STATIC void
 xfs_bmap_trace_addentry(
 	int		opcode,		/* operation */
-	char		*fname,		/* function name */
+	const char	*fname,		/* function name */
 	char		*desc,		/* operation description */
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index of entry(ies) */
@@ -3792,7 +3755,7 @@ xfs_bmap_trace_addentry(
  */
 STATIC void
 xfs_bmap_trace_delete(
-	char		*fname,		/* function name */
+	const char	*fname,		/* function name */
 	char		*desc,		/* operation description */
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index of entry(entries) deleted */
@@ -3814,7 +3777,7 @@ xfs_bmap_trace_delete(
  */
 STATIC void
 xfs_bmap_trace_insert(
-	char		*fname,		/* function name */
+	const char	*fname,		/* function name */
 	char		*desc,		/* operation description */
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index of entry(entries) inserted */
@@ -3843,7 +3806,7 @@ xfs_bmap_trace_insert(
  */
 STATIC void
 xfs_bmap_trace_post_update(
-	char		*fname,		/* function name */
+	const char	*fname,		/* function name */
 	char		*desc,		/* operation description */
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index of entry updated */
@@ -3861,7 +3824,7 @@ xfs_bmap_trace_post_update(
  */
 STATIC void
 xfs_bmap_trace_pre_update(
-	char		*fname,		/* function name */
+	const char	*fname,		/* function name */
 	char		*desc,		/* operation description */
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	idx,		/* index of entry to be updated */
@@ -4478,9 +4441,6 @@ xfs_bmap_read_extents(
 	xfs_buf_t		*bp;	/* buffer for "block" */
 	int			error;	/* error return value */
 	xfs_exntfmt_t		exntf;	/* XFS_EXTFMT_NOSTATE, if checking */
-#ifdef XFS_BMAP_TRACE
-	static char		fname[] = "xfs_bmap_read_extents";
-#endif
 	xfs_extnum_t		i, j;	/* index into the extents list */
 	xfs_ifork_t		*ifp;	/* fork structure */
 	int			level;	/* btree level, for checking */
@@ -4597,7 +4557,7 @@ xfs_bmap_read_extents(
 	}
 	ASSERT(i == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)));
 	ASSERT(i == XFS_IFORK_NEXTENTS(ip, whichfork));
-	xfs_bmap_trace_exlist(fname, ip, i, whichfork);
+	XFS_BMAP_TRACE_EXLIST(ip, i, whichfork);
 	return 0;
 error0:
 	xfs_trans_brelse(tp, bp);
@@ -4625,7 +4585,7 @@ xfs_bmap_trace_exlist(
 	for (idx = 0; idx < cnt; idx++) {
 		ep = xfs_iext_get_ext(ifp, idx);
 		xfs_bmbt_get_all(ep, &s);
-		xfs_bmap_trace_insert(fname, "exlist", ip, idx, 1, &s, NULL,
+		XFS_BMAP_TRACE_INSERT("exlist", ip, idx, 1, &s, NULL,
 			whichfork);
 	}
 }
Index: linux/fs/xfs/xfs_bmap.h
===================================================================
--- linux.orig/fs/xfs/xfs_bmap.h
+++ linux/fs/xfs/xfs_bmap.h
@@ -144,12 +144,14 @@ extern ktrace_t	*xfs_bmap_trace_buf;
  */
 void
 xfs_bmap_trace_exlist(
-	char			*fname,		/* function name */
+	const char		*fname,		/* function name */
 	struct xfs_inode	*ip,		/* incore inode pointer */
 	xfs_extnum_t		cnt,		/* count of entries in list */
 	int			whichfork);	/* data or attr fork */
+#define	XFS_BMAP_TRACE_EXLIST(ip,c,w)	\
+	xfs_bmap_trace_exlist(__FUNCTION__,ip,c,w)
 #else
-#define	xfs_bmap_trace_exlist(f,ip,c,w)
+#define	XFS_BMAP_TRACE_EXLIST(ip,c,w)
 #endif
 
 /*
Index: linux/fs/xfs/xfs_inode.c
===================================================================
--- linux.orig/fs/xfs/xfs_inode.c
+++ linux/fs/xfs/xfs_inode.c
@@ -644,8 +644,7 @@ xfs_iformat_extents(
 			ep->l1 = INT_GET(get_unaligned((__uint64_t*)&dp->l1),
 								ARCH_CONVERT);
 		}
-		xfs_bmap_trace_exlist("xfs_iformat_extents", ip, nex,
-			whichfork);
+		XFS_BMAP_TRACE_EXLIST(ip, nex, whichfork);
 		if (whichfork != XFS_DATA_FORK ||
 			XFS_EXTFMT_INODE(ip) == XFS_EXTFMT_NOSTATE)
 				if (unlikely(xfs_check_nostate_extents(
@@ -2876,9 +2875,6 @@ xfs_iextents_copy(
 	int			copied;
 	xfs_bmbt_rec_t		*dest_ep;
 	xfs_bmbt_rec_t		*ep;
-#ifdef XFS_BMAP_TRACE
-	static char		fname[] = "xfs_iextents_copy";
-#endif
 	int			i;
 	xfs_ifork_t		*ifp;
 	int			nrecs;
@@ -2889,7 +2885,7 @@ xfs_iextents_copy(
 	ASSERT(ifp->if_bytes > 0);
 
 	nrecs = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
-	xfs_bmap_trace_exlist(fname, ip, nrecs, whichfork);
+	XFS_BMAP_TRACE_EXLIST(ip, nrecs, whichfork);
 	ASSERT(nrecs > 0);
 
 	/*
