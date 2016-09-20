Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3FB7C7CCB
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 18:07:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 101E68F8033
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 16:07:25 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VaZXfOYye7Wv4s62 for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2016 16:07:21 -0700 (PDT)
Date: Wed, 21 Sep 2016 09:06:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel BUG at fs/xfs/xfs_message.c:113!
Message-ID: <20160920230613.GL340@dastard>
References: <20160920163304.GA8999@linux.intel.com>
	<20160920201453.GH340@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160920201453.GH340@dastard>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Sep 21, 2016 at 06:14:53AM +1000, Dave Chinner wrote:
> On Tue, Sep 20, 2016 at 10:33:04AM -0600, Ross Zwisler wrote:
> > I'm consistently able to generate this kernel BUG with both v4.7 and v4.8-rc7.
> > This bug reproduces both with and without DAX.
> > Here is the BUG with v4.8-rc7, passed through kasan_symbolize.py:
> > 
> >   run fstests generic/026 at 2016-09-20 10:22:58
> >   XFS (pmem0p2): Unmounting Filesystem
> >   XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 309
> 
> It overran the block allocation reservation for the transaction.

Can you try the patch I've attached below, Ross? it solves the
problem for me....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: remote attribute blocks aren't really userdata

From: Dave Chinner <dchinner@redhat.com>

When adding a new remote attribute, we write the attribute to the
new extent before the allocation transaction is committed. This
means we cannot reuse busy extents as that violates crash
consistency semantics. Hence we currently treat remote attribute
extent allocation like userdata because it has the same overwrite
ordering constraints as userdata.

Unfortunately, this also allows the allocator to incorrectly apply
extent size hints to the remote attribute extent allocation. This
results in interesting failures, such as transaction block
reservation overruns and in-memory inode attribute fork corruption.

To fix this, we need to separate the busy extent reuse configuration
from the userdata configuration. This changes the definition of
XFS_BMAPI_METADATA slightly - it now means that allocation is
metadata and reuse of busy extents is acceptible due to the metadata
ordering semantics of the journal. If this flag is not set, it
means the allocation is that has unordered data writeback, and hence
busy extent reuse is not allowed. It no longer implies the
allocation is for user data, just that the data write will not be
strictly ordered. This matches the semantics for both user data
and remote attribute block allocation.

As such, This patch changes the "userdata" field to a "datatype"
field, and adds a "no busy reuse" flag to the field.
When we detect an unordered data extent allocation, we immediately set
the no reuse flag. We then set the "user data" flags based on the
inode fork we are allocating the extent to. Hence we only set
userdata flags on data fork allocations now and consider attribute
fork remote extents to be an unordered metadata extent.

The result is that remote attribute extents now have the expected
allocation semantics, and the data fork allocation behaviour is
completely unchanged.

It should be noted that there may be other ways to fix this (e.g.
use ordered metadata buffers for the remote attribute extent data
write) but they are more invasive and difficult to validate both
from a design and implementation POV. Hence this patch takes the
simple, obvious route to fixing the problem...

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 23 ++++++++++++-----------
 fs/xfs/libxfs/xfs_alloc.h | 17 +++++++++++++++--
 fs/xfs/libxfs/xfs_bmap.c  | 41 ++++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_bmap.h  |  2 +-
 fs/xfs/xfs_bmap_util.c    |  2 +-
 fs/xfs/xfs_extent_busy.c  |  2 +-
 fs/xfs/xfs_filestream.c   |  9 ++++++---
 fs/xfs/xfs_trace.h        |  8 ++++----
 8 files changed, 66 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 2620a86..ca75dc9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -258,7 +258,7 @@ xfs_alloc_compute_diff(
 	xfs_agblock_t	wantbno,	/* target starting block */
 	xfs_extlen_t	wantlen,	/* target length */
 	xfs_extlen_t	alignment,	/* target alignment */
-	char		userdata,	/* are we allocating data? */
+	int		datatype,	/* are we allocating data? */
 	xfs_agblock_t	freebno,	/* freespace's starting block */
 	xfs_extlen_t	freelen,	/* freespace's length */
 	xfs_agblock_t	*newbnop)	/* result: best start block from free */
@@ -269,6 +269,7 @@ xfs_alloc_compute_diff(
 	xfs_extlen_t	newlen1=0;	/* length with newbno1 */
 	xfs_extlen_t	newlen2=0;	/* length with newbno2 */
 	xfs_agblock_t	wantend;	/* end of target extent */
+	bool		userdata = xfs_alloc_is_userdata(datatype);
 
 	ASSERT(freelen >= wantlen);
 	freeend = freebno + freelen;
@@ -924,7 +925,7 @@ xfs_alloc_find_best_extent(
 
 			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
 						       args->alignment,
-						       args->userdata, *sbnoa,
+						       args->datatype, *sbnoa,
 						       *slena, &new);
 
 			/*
@@ -1108,7 +1109,7 @@ restart:
 			if (args->len < blen)
 				continue;
 			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, args->userdata, ltbnoa,
+				args->alignment, args->datatype, ltbnoa,
 				ltlena, &ltnew);
 			if (ltnew != NULLAGBLOCK &&
 			    (args->len > blen || ltdiff < bdiff)) {
@@ -1261,7 +1262,7 @@ restart:
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, args->userdata, ltbnoa,
+				args->alignment, args->datatype, ltbnoa,
 				ltlena, &ltnew);
 
 			error = xfs_alloc_find_best_extent(args,
@@ -1278,7 +1279,7 @@ restart:
 			args->len = XFS_EXTLEN_MIN(gtlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			gtdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, args->userdata, gtbnoa,
+				args->alignment, args->datatype, gtbnoa,
 				gtlena, &gtnew);
 
 			error = xfs_alloc_find_best_extent(args,
@@ -1338,7 +1339,7 @@ restart:
 	}
 	rlen = args->len;
 	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment,
-				     args->userdata, ltbnoa, ltlena, &ltnew);
+				     args->datatype, ltbnoa, ltlena, &ltnew);
 	ASSERT(ltnew >= ltbno);
 	ASSERT(ltnew + rlen <= ltbnoa + ltlena);
 	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
@@ -1617,9 +1618,9 @@ xfs_alloc_ag_vextent_small(
 			goto error0;
 		if (fbno != NULLAGBLOCK) {
 			xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
-					     args->userdata);
+			      xfs_alloc_allow_busy_reuse(args->datatype));
 
-			if (args->userdata) {
+			if (xfs_alloc_is_userdata(args->datatype)) {
 				xfs_buf_t	*bp;
 
 				bp = xfs_btree_get_bufs(args->mp, args->tp,
@@ -2099,7 +2100,7 @@ xfs_alloc_fix_freelist(
 	 * somewhere else if we are not being asked to try harder at this
 	 * point
 	 */
-	if (pag->pagf_metadata && args->userdata &&
+	if (pag->pagf_metadata && xfs_alloc_is_userdata(args->datatype) &&
 	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
 		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
 		goto out_agbp_relse;
@@ -2675,7 +2676,7 @@ xfs_alloc_vextent(
 		 * Try near allocation first, then anywhere-in-ag after
 		 * the first a.g. fails.
 		 */
-		if ((args->userdata & XFS_ALLOC_INITIAL_USER_DATA) &&
+		if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
 		    (mp->m_flags & XFS_MOUNT_32BITINODES)) {
 			args->fsbno = XFS_AGB_TO_FSB(mp,
 					((mp->m_agfrotor / rotorstep) %
@@ -2808,7 +2809,7 @@ xfs_alloc_vextent(
 #endif
 
 		/* Zero the extent if we were asked to do so */
-		if (args->userdata & XFS_ALLOC_USERDATA_ZERO) {
+		if (args->datatype & XFS_ALLOC_USERDATA_ZERO) {
 			error = xfs_zero_extent(args->ip, args->fsbno, args->len);
 			if (error)
 				goto error0;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index f7c5201..7c404a6 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -85,20 +85,33 @@ typedef struct xfs_alloc_arg {
 	xfs_extlen_t	len;		/* output: actual size of extent */
 	xfs_alloctype_t	type;		/* allocation type XFS_ALLOCTYPE_... */
 	xfs_alloctype_t	otype;		/* original allocation type */
+	int		datatype;	/* mask defining data type treatment */
 	char		wasdel;		/* set if allocation was prev delayed */
 	char		wasfromfl;	/* set if allocation is from freelist */
-	char		userdata;	/* mask defining userdata treatment */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 	enum xfs_ag_resv_type	resv;	/* block reservation to use */
 } xfs_alloc_arg_t;
 
 /*
- * Defines for userdata
+ * Defines for datatype
  */
 #define XFS_ALLOC_USERDATA		(1 << 0)/* allocation is for user data*/
 #define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
 #define XFS_ALLOC_USERDATA_ZERO		(1 << 2)/* zero extent on allocation */
+#define XFS_ALLOC_NOBUSY		(1 << 3)/* Busy extents not allowed */
+
+static inline bool
+xfs_alloc_is_userdata(int datatype)
+{
+	return (datatype & ~XFS_ALLOC_NOBUSY) != 0;
+}
+
+static inline bool
+xfs_alloc_allow_busy_reuse(int datatype)
+{
+	return (datatype & XFS_ALLOC_NOBUSY) == 0;
+}
 
 /* freespace limit calculations */
 #define XFS_ALLOC_AGFL_RESERVE	4
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6fd4586..9d7f61d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3348,7 +3348,8 @@ xfs_bmap_adjacent(
 
 	mp = ap->ip->i_mount;
 	nullfb = *ap->firstblock == NULLFSBLOCK;
-	rt = XFS_IS_REALTIME_INODE(ap->ip) && ap->userdata;
+	rt = XFS_IS_REALTIME_INODE(ap->ip) &&
+		xfs_alloc_is_userdata(ap->datatype);
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, *ap->firstblock);
 	/*
 	 * If allocating at eof, and there's a previous real block,
@@ -3624,7 +3625,7 @@ xfs_bmap_btalloc(
 {
 	xfs_mount_t	*mp;		/* mount point structure */
 	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
-	xfs_extlen_t	align;		/* minimum allocation alignment */
+	xfs_extlen_t	align = 0;	/* minimum allocation alignment */
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
 	xfs_agnumber_t	ag;
 	xfs_alloc_arg_t	args;
@@ -3647,7 +3648,8 @@ xfs_bmap_btalloc(
 	else if (mp->m_dalign)
 		stripe_align = mp->m_dalign;
 
-	align = ap->userdata ? xfs_get_extsz_hint(ap->ip) : 0;
+	if (xfs_alloc_is_userdata(ap->datatype))
+		align = xfs_get_extsz_hint(ap->ip);
 	if (unlikely(align)) {
 		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 						align, 0, ap->eof, 0, ap->conv,
@@ -3660,7 +3662,8 @@ xfs_bmap_btalloc(
 	nullfb = *ap->firstblock == NULLFSBLOCK;
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, *ap->firstblock);
 	if (nullfb) {
-		if (ap->userdata && xfs_inode_is_filestream(ap->ip)) {
+		if (xfs_alloc_is_userdata(ap->datatype) &&
+		    xfs_inode_is_filestream(ap->ip)) {
 			ag = xfs_filestream_lookup_ag(ap->ip);
 			ag = (ag != NULLAGNUMBER) ? ag : 0;
 			ap->blkno = XFS_AGB_TO_FSB(mp, ag, 0);
@@ -3700,7 +3703,8 @@ xfs_bmap_btalloc(
 		 * enough for the request.  If one isn't found, then adjust
 		 * the minimum allocation size to the largest space found.
 		 */
-		if (ap->userdata && xfs_inode_is_filestream(ap->ip))
+		if (xfs_alloc_is_userdata(ap->datatype) &&
+		    xfs_inode_is_filestream(ap->ip))
 			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
 		else
 			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
@@ -3784,8 +3788,8 @@ xfs_bmap_btalloc(
 	args.minleft = ap->minleft;
 	args.wasdel = ap->wasdel;
 	args.resv = XFS_AG_RESV_NONE;
-	args.userdata = ap->userdata;
-	if (ap->userdata & XFS_ALLOC_USERDATA_ZERO)
+	args.datatype = ap->datatype;
+	if (ap->datatype & XFS_ALLOC_USERDATA_ZERO)
 		args.ip = ap->ip;
 
 	error = xfs_alloc_vextent(&args);
@@ -3879,7 +3883,8 @@ STATIC int
 xfs_bmap_alloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
-	if (XFS_IS_REALTIME_INODE(ap->ip) && ap->userdata)
+	if (XFS_IS_REALTIME_INODE(ap->ip) &&
+	    xfs_alloc_is_userdata(ap->datatype))
 		return xfs_bmap_rtalloc(ap);
 	return xfs_bmap_btalloc(ap);
 }
@@ -4204,15 +4209,21 @@ xfs_bmapi_allocate(
 	}
 
 	/*
-	 * Indicate if this is the first user data in the file, or just any
-	 * user data. And if it is userdata, indicate whether it needs to
-	 * be initialised to zero during allocation.
+	 * Set the data type being allocated. For the data fork, the first data
+	 * in the file is treated differently to all other allocations. For the
+	 * attribute fork, we only need to ensure the allocated range is not on
+	 * the busy list.
 	 */
 	if (!(bma->flags & XFS_BMAPI_METADATA)) {
-		bma->userdata = (bma->offset == 0) ?
-			XFS_ALLOC_INITIAL_USER_DATA : XFS_ALLOC_USERDATA;
+		bma->datatype = XFS_ALLOC_NOBUSY;
+		if (whichfork == XFS_DATA_FORK) {
+			if (bma->offset == 0)
+				bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
+			else
+				bma->datatype |= XFS_ALLOC_USERDATA;
+		}
 		if (bma->flags & XFS_BMAPI_ZERO)
-			bma->userdata |= XFS_ALLOC_USERDATA_ZERO;
+			bma->datatype |= XFS_ALLOC_USERDATA_ZERO;
 	}
 
 	bma->minlen = (bma->flags & XFS_BMAPI_CONTIG) ? bma->length : 1;
@@ -4482,7 +4493,7 @@ xfs_bmapi_write(
 	bma.tp = tp;
 	bma.ip = ip;
 	bma.total = total;
-	bma.userdata = 0;
+	bma.datatype = 0;
 	bma.dfops = dfops;
 	bma.firstblock = firstblock;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index d660069..8395f6e 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -54,7 +54,7 @@ struct xfs_bmalloca {
 	bool			wasdel;	/* replacing a delayed allocation */
 	bool			aeof;	/* allocated space at eof */
 	bool			conv;	/* overwriting unwritten extents */
-	char			userdata;/* userdata mask */
+	int			datatype;/* data type being allocated */
 	int			flags;
 };
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4ece4f2..e827d65 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -182,7 +182,7 @@ xfs_bmap_rtalloc(
 					XFS_TRANS_DQ_RTBCOUNT, (long) ralen);
 
 		/* Zero the extent if we were asked to do so */
-		if (ap->userdata & XFS_ALLOC_USERDATA_ZERO) {
+		if (ap->datatype & XFS_ALLOC_USERDATA_ZERO) {
 			error = xfs_zero_extent(ap->ip, ap->blkno, ap->length);
 			if (error)
 				return error;
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index c263e07..162dc18 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -384,7 +384,7 @@ restart:
 		 * If this is a metadata allocation, try to reuse the busy
 		 * extent instead of trimming the allocation.
 		 */
-		if (!args->userdata &&
+		if (!xfs_alloc_is_userdata(args->datatype) &&
 		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
 			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
 							  busyp, fbno, flen,
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index c8005fd..043ca380 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -371,7 +371,8 @@ xfs_filestream_new_ag(
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_extlen_t		minlen = ap->length;
 	xfs_agnumber_t		startag = 0;
-	int			flags, err = 0;
+	int			flags = 0;
+	int			err = 0;
 	struct xfs_mru_cache_elem *mru;
 
 	*agp = NULLAGNUMBER;
@@ -387,8 +388,10 @@ xfs_filestream_new_ag(
 		startag = (item->ag + 1) % mp->m_sb.sb_agcount;
 	}
 
-	flags = (ap->userdata ? XFS_PICK_USERDATA : 0) |
-	        (ap->dfops->dop_low ? XFS_PICK_LOWSPACE : 0);
+	if (xfs_alloc_is_userdata(ap->datatype))
+		flags |= XFS_PICK_USERDATA;
+	if (ap->dfops->dop_low)
+		flags |= XFS_PICK_LOWSPACE;
 
 	err = xfs_filestream_pick_ag(pip, startag, agp, flags, minlen);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 993e2d2..2be97c0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1624,7 +1624,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__field(char, wasdel)
 		__field(char, wasfromfl)
 		__field(int, resv)
-		__field(char, userdata)
+		__field(int, datatype)
 		__field(xfs_fsblock_t, firstblock)
 	),
 	TP_fast_assign(
@@ -1645,13 +1645,13 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__entry->wasdel = args->wasdel;
 		__entry->wasfromfl = args->wasfromfl;
 		__entry->resv = args->resv;
-		__entry->userdata = args->userdata;
+		__entry->datatype = args->datatype;
 		__entry->firstblock = args->firstblock;
 	),
 	TP_printk("dev %d:%d agno %u agbno %u minlen %u maxlen %u mod %u "
 		  "prod %u minleft %u total %u alignment %u minalignslop %u "
 		  "len %u type %s otype %s wasdel %d wasfromfl %d resv %d "
-		  "userdata %d firstblock 0x%llx",
+		  "userdata 0x%xfirstblock 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1669,7 +1669,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		  __entry->wasdel,
 		  __entry->wasfromfl,
 		  __entry->resv,
-		  __entry->userdata,
+		  __entry->datatype,
 		  (unsigned long long)__entry->firstblock)
 )
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
