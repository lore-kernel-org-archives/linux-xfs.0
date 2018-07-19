Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727501AbeGSNml (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 09:42:41 -0400
Date: Thu, 19 Jul 2018 08:59:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/8] xfs: fix indentation and other whitespace problems
 in scrub/repair
Message-ID: <20180719125933.GJ25672@bfoster>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192913161.31685.3748106388738255814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153192913161.31685.3748106388738255814.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 18, 2018 at 08:52:11AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've shortened everything, fix up all the indentation and
> whitespace problems.  There are no functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/agheader.c        |  172 ++++++++++++++++++++--------------------
>  fs/xfs/scrub/agheader_repair.c |    8 +-
>  fs/xfs/scrub/alloc.c           |   48 ++++++-----
>  fs/xfs/scrub/attr.c            |   20 ++---
>  fs/xfs/scrub/bmap.c            |  150 +++++++++++++++++------------------
>  fs/xfs/scrub/btree.c           |  172 ++++++++++++++++++++--------------------
>  fs/xfs/scrub/btree.h           |   25 +++---
>  fs/xfs/scrub/common.c          |  158 ++++++++++++++++++-------------------
>  fs/xfs/scrub/common.h          |   23 ++---
>  fs/xfs/scrub/dabtree.c         |   56 +++++++------
>  fs/xfs/scrub/dabtree.h         |   21 ++---
>  fs/xfs/scrub/dir.c             |   88 ++++++++++----------
>  fs/xfs/scrub/ialloc.c          |   58 +++++++------
>  fs/xfs/scrub/inode.c           |  102 ++++++++++++------------
>  fs/xfs/scrub/parent.c          |   60 +++++++-------
>  fs/xfs/scrub/quota.c           |   68 ++++++++--------
>  fs/xfs/scrub/refcount.c        |   70 ++++++++--------
>  fs/xfs/scrub/repair.c          |  148 +++++++++++++++++-----------------
>  fs/xfs/scrub/repair.h          |   28 +++----
>  fs/xfs/scrub/rmap.c            |   78 +++++++++---------
>  fs/xfs/scrub/rtbitmap.c        |   38 ++++-----
>  fs/xfs/scrub/scrub.c           |    8 +-
>  fs/xfs/scrub/scrub.h           |   62 +++++++-------
>  fs/xfs/scrub/symlink.c         |   10 +-
>  fs/xfs/scrub/trace.c           |    4 -
>  25 files changed, 832 insertions(+), 843 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 14ba4189ae8f..3068a9382feb 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -30,13 +30,13 @@
>  STATIC void
>  xchk_superblock_xref(
>  	struct xfs_scrub	*sc,
> -	struct xfs_buf			*bp)
> +	struct xfs_buf		*bp)
>  {
> -	struct xfs_owner_info		oinfo;
> -	struct xfs_mount		*mp = sc->mp;
> -	xfs_agnumber_t			agno = sc->sm->sm_agno;
> -	xfs_agblock_t			agbno;
> -	int				error;
> +	struct xfs_owner_info	oinfo;
> +	struct xfs_mount	*mp = sc->mp;
> +	xfs_agnumber_t		agno = sc->sm->sm_agno;
> +	xfs_agblock_t		agbno;
> +	int			error;
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return;
> @@ -68,14 +68,14 @@ int
>  xchk_superblock(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	struct xfs_buf			*bp;
> -	struct xfs_dsb			*sb;
> -	xfs_agnumber_t			agno;
> -	uint32_t			v2_ok;
> -	__be32				features_mask;
> -	int				error;
> -	__be16				vernum_mask;
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_buf		*bp;
> +	struct xfs_dsb		*sb;
> +	xfs_agnumber_t		agno;
> +	uint32_t		v2_ok;
> +	__be32			features_mask;
> +	int			error;
> +	__be16			vernum_mask;
>  
>  	agno = sc->sm->sm_agno;
>  	if (agno == 0)
> @@ -367,9 +367,9 @@ static inline void
>  xchk_agf_xref_freeblks(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> -	xfs_extlen_t			blocks = 0;
> -	int				error;
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> +	xfs_extlen_t		blocks = 0;
> +	int			error;
>  
>  	if (!sc->sa.bno_cur)
>  		return;
> @@ -387,11 +387,11 @@ static inline void
>  xchk_agf_xref_cntbt(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> -	xfs_agblock_t			agbno;
> -	xfs_extlen_t			blocks;
> -	int				have;
> -	int				error;
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> +	xfs_agblock_t		agbno;
> +	xfs_extlen_t		blocks;
> +	int			have;
> +	int			error;
>  
>  	if (!sc->sa.cnt_cur)
>  		return;
> @@ -419,11 +419,11 @@ STATIC void
>  xchk_agf_xref_btreeblks(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> -	struct xfs_mount		*mp = sc->mp;
> -	xfs_agblock_t			blocks;
> -	xfs_agblock_t			btreeblks;
> -	int				error;
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> +	struct xfs_mount	*mp = sc->mp;
> +	xfs_agblock_t		blocks;
> +	xfs_agblock_t		btreeblks;
> +	int			error;
>  
>  	/* Check agf_rmap_blocks; set up for agf_btreeblks check */
>  	if (sc->sa.rmap_cur) {
> @@ -465,9 +465,9 @@ static inline void
>  xchk_agf_xref_refcblks(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> -	xfs_agblock_t			blocks;
> -	int				error;
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> +	xfs_agblock_t		blocks;
> +	int			error;
>  
>  	if (!sc->sa.refc_cur)
>  		return;
> @@ -484,10 +484,10 @@ STATIC void
>  xchk_agf_xref(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_owner_info		oinfo;
> -	struct xfs_mount		*mp = sc->mp;
> -	xfs_agblock_t			agbno;
> -	int				error;
> +	struct xfs_owner_info	oinfo;
> +	struct xfs_mount	*mp = sc->mp;
> +	xfs_agblock_t		agbno;
> +	int			error;
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return;
> @@ -516,17 +516,17 @@ int
>  xchk_agf(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	struct xfs_agf			*agf;
> -	xfs_agnumber_t			agno;
> -	xfs_agblock_t			agbno;
> -	xfs_agblock_t			eoag;
> -	xfs_agblock_t			agfl_first;
> -	xfs_agblock_t			agfl_last;
> -	xfs_agblock_t			agfl_count;
> -	xfs_agblock_t			fl_count;
> -	int				level;
> -	int				error = 0;
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_agf		*agf;
> +	xfs_agnumber_t		agno;
> +	xfs_agblock_t		agbno;
> +	xfs_agblock_t		eoag;
> +	xfs_agblock_t		agfl_first;
> +	xfs_agblock_t		agfl_last;
> +	xfs_agblock_t		agfl_count;
> +	xfs_agblock_t		fl_count;
> +	int			level;
> +	int			error = 0;
>  
>  	agno = sc->sa.agno = sc->sm->sm_agno;
>  	error = xchk_ag_read_headers(sc, agno, &sc->sa.agi_bp,
> @@ -598,10 +598,10 @@ xchk_agf(
>  /* AGFL */
>  
>  struct xchk_agfl_info {
> -	struct xfs_owner_info		oinfo;
> -	unsigned int			sz_entries;
> -	unsigned int			nr_entries;
> -	xfs_agblock_t			*entries;
> +	struct xfs_owner_info	oinfo;
> +	unsigned int		sz_entries;
> +	unsigned int		nr_entries;
> +	xfs_agblock_t		*entries;
>  	struct xfs_scrub	*sc;
>  };
>  
> @@ -609,8 +609,8 @@ struct xchk_agfl_info {
>  STATIC void
>  xchk_agfl_block_xref(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			agbno,
> -	struct xfs_owner_info		*oinfo)
> +	xfs_agblock_t		agbno,
> +	struct xfs_owner_info	*oinfo)
>  {
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return;
> @@ -624,13 +624,13 @@ xchk_agfl_block_xref(
>  /* Scrub an AGFL block. */
>  STATIC int
>  xchk_agfl_block(
> -	struct xfs_mount		*mp,
> -	xfs_agblock_t			agbno,
> -	void				*priv)
> +	struct xfs_mount	*mp,
> +	xfs_agblock_t		agbno,
> +	void			*priv)
>  {
> -	struct xchk_agfl_info		*sai = priv;
> +	struct xchk_agfl_info	*sai = priv;
>  	struct xfs_scrub	*sc = sai->sc;
> -	xfs_agnumber_t			agno = sc->sa.agno;
> +	xfs_agnumber_t		agno = sc->sa.agno;
>  
>  	if (xfs_verify_agbno(mp, agno, agbno) &&
>  	    sai->nr_entries < sai->sz_entries)
> @@ -662,10 +662,10 @@ STATIC void
>  xchk_agfl_xref(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_owner_info		oinfo;
> -	struct xfs_mount		*mp = sc->mp;
> -	xfs_agblock_t			agbno;
> -	int				error;
> +	struct xfs_owner_info	oinfo;
> +	struct xfs_mount	*mp = sc->mp;
> +	xfs_agblock_t		agbno;
> +	int			error;
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return;
> @@ -693,12 +693,12 @@ int
>  xchk_agfl(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xchk_agfl_info		sai;
> -	struct xfs_agf			*agf;
> -	xfs_agnumber_t			agno;
> -	unsigned int			agflcount;
> -	unsigned int			i;
> -	int				error;
> +	struct xchk_agfl_info	sai;
> +	struct xfs_agf		*agf;
> +	xfs_agnumber_t		agno;
> +	unsigned int		agflcount;
> +	unsigned int		i;
> +	int			error;
>  
>  	agno = sc->sa.agno = sc->sm->sm_agno;
>  	error = xchk_ag_read_headers(sc, agno, &sc->sa.agi_bp,
> @@ -770,10 +770,10 @@ static inline void
>  xchk_agi_xref_icounts(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_agi			*agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
> -	xfs_agino_t			icount;
> -	xfs_agino_t			freecount;
> -	int				error;
> +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
> +	xfs_agino_t		icount;
> +	xfs_agino_t		freecount;
> +	int			error;
>  
>  	if (!sc->sa.ino_cur)
>  		return;
> @@ -791,10 +791,10 @@ STATIC void
>  xchk_agi_xref(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_owner_info		oinfo;
> -	struct xfs_mount		*mp = sc->mp;
> -	xfs_agblock_t			agbno;
> -	int				error;
> +	struct xfs_owner_info	oinfo;
> +	struct xfs_mount	*mp = sc->mp;
> +	xfs_agblock_t		agbno;
> +	int			error;
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return;
> @@ -820,18 +820,18 @@ int
>  xchk_agi(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	struct xfs_agi			*agi;
> -	xfs_agnumber_t			agno;
> -	xfs_agblock_t			agbno;
> -	xfs_agblock_t			eoag;
> -	xfs_agino_t			agino;
> -	xfs_agino_t			first_agino;
> -	xfs_agino_t			last_agino;
> -	xfs_agino_t			icount;
> -	int				i;
> -	int				level;
> -	int				error = 0;
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_agi		*agi;
> +	xfs_agnumber_t		agno;
> +	xfs_agblock_t		agbno;
> +	xfs_agblock_t		eoag;
> +	xfs_agino_t		agino;
> +	xfs_agino_t		first_agino;
> +	xfs_agino_t		last_agino;
> +	xfs_agino_t		icount;
> +	int			i;
> +	int			level;
> +	int			error = 0;
>  
>  	agno = sc->sa.agno = sc->sm->sm_agno;
>  	error = xchk_ag_read_headers(sc, agno, &sc->sa.agi_bp,
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 2457968482f8..1e96621ece3a 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -31,10 +31,10 @@ int
>  xrep_superblock(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	struct xfs_buf			*bp;
> -	xfs_agnumber_t			agno;
> -	int				error;
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_buf		*bp;
> +	xfs_agnumber_t		agno;
> +	int			error;
>  
>  	/* Don't try to repair AG 0's sb; let xfs_repair deal with it. */
>  	agno = sc->sm->sm_agno;
> diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> index 653d80b3aa39..036b5c7021eb 100644
> --- a/fs/xfs/scrub/alloc.c
> +++ b/fs/xfs/scrub/alloc.c
> @@ -30,7 +30,7 @@
>  int
>  xchk_setup_ag_allocbt(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
>  	return xchk_setup_ag_btree(sc, ip, false);
>  }
> @@ -43,14 +43,14 @@ xchk_setup_ag_allocbt(
>  STATIC void
>  xchk_allocbt_xref_other(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			agbno,
> -	xfs_extlen_t			len)
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len)
>  {
> -	struct xfs_btree_cur		**pcur;
> -	xfs_agblock_t			fbno;
> -	xfs_extlen_t			flen;
> -	int				has_otherrec;
> -	int				error;
> +	struct xfs_btree_cur	**pcur;
> +	xfs_agblock_t		fbno;
> +	xfs_extlen_t		flen;
> +	int			has_otherrec;
> +	int			error;
>  
>  	if (sc->sm->sm_type == XFS_SCRUB_TYPE_BNOBT)
>  		pcur = &sc->sa.cnt_cur;
> @@ -83,8 +83,8 @@ xchk_allocbt_xref_other(
>  STATIC void
>  xchk_allocbt_xref(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			agbno,
> -	xfs_extlen_t			len)
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len)
>  {
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return;
> @@ -98,14 +98,14 @@ xchk_allocbt_xref(
>  /* Scrub a bnobt/cntbt record. */
>  STATIC int
>  xchk_allocbt_rec(
> -	struct xchk_btree		*bs,
> -	union xfs_btree_rec		*rec)
> +	struct xchk_btree	*bs,
> +	union xfs_btree_rec	*rec)
>  {
> -	struct xfs_mount		*mp = bs->cur->bc_mp;
> -	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
> -	xfs_agblock_t			bno;
> -	xfs_extlen_t			len;
> -	int				error = 0;
> +	struct xfs_mount	*mp = bs->cur->bc_mp;
> +	xfs_agnumber_t		agno = bs->cur->bc_private.a.agno;
> +	xfs_agblock_t		bno;
> +	xfs_extlen_t		len;
> +	int			error = 0;
>  
>  	bno = be32_to_cpu(rec->alloc.ar_startblock);
>  	len = be32_to_cpu(rec->alloc.ar_blockcount);
> @@ -124,10 +124,10 @@ xchk_allocbt_rec(
>  STATIC int
>  xchk_allocbt(
>  	struct xfs_scrub	*sc,
> -	xfs_btnum_t			which)
> +	xfs_btnum_t		which)
>  {
> -	struct xfs_owner_info		oinfo;
> -	struct xfs_btree_cur		*cur;
> +	struct xfs_owner_info	oinfo;
> +	struct xfs_btree_cur	*cur;
>  
>  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
>  	cur = which == XFS_BTNUM_BNO ? sc->sa.bno_cur : sc->sa.cnt_cur;
> @@ -152,11 +152,11 @@ xchk_cntbt(
>  void
>  xchk_xref_is_used_space(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			agbno,
> -	xfs_extlen_t			len)
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len)
>  {
> -	bool				is_freesp;
> -	int				error;
> +	bool			is_freesp;
> +	int			error;
>  
>  	if (!sc->sa.bno_cur || xchk_skip_xref(sc->sm))
>  		return;
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 6650fb3010b6..81d5e90547a1 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -34,9 +34,9 @@
>  int
>  xchk_setup_xattr(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
> -	size_t				sz;
> +	size_t			sz;
>  
>  	/*
>  	 * Allocate the buffer without the inode lock held.  We need enough
> @@ -57,7 +57,7 @@ xchk_setup_xattr(
>  
>  struct xchk_xattr {
>  	struct xfs_attr_list_context	context;
> -	struct xfs_scrub	*sc;
> +	struct xfs_scrub		*sc;
>  };
>  
>  /*
> @@ -128,12 +128,12 @@ xchk_xattr_listent(
>  STATIC bool
>  xchk_xattr_set_map(
>  	struct xfs_scrub	*sc,
> -	unsigned long			*map,
> -	unsigned int			start,
> -	unsigned int			len)
> +	unsigned long		*map,
> +	unsigned int		start,
> +	unsigned int		len)
>  {
> -	unsigned int			mapsize = sc->mp->m_attr_geo->blksize;
> -	bool				ret = true;
> +	unsigned int		mapsize = sc->mp->m_attr_geo->blksize;
> +	bool			ret = true;
>  
>  	if (start >= mapsize)
>  		return false;
> @@ -155,7 +155,7 @@ xchk_xattr_set_map(
>   */
>  STATIC bool
>  xchk_xattr_check_freemap(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	unsigned long			*map,
>  	struct xfs_attr3_icleaf_hdr	*leafhdr)
>  {
> @@ -405,7 +405,7 @@ xchk_xattr_rec(
>  /* Scrub the extended attribute metadata. */
>  int
>  xchk_xattr(
> -	struct xfs_scrub	*sc)
> +	struct xfs_scrub		*sc)
>  {
>  	struct xchk_xattr		sx;
>  	struct attrlist_cursor_kern	cursor = { 0 };
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 0e5166232b15..e1d11f3223e3 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -35,9 +35,9 @@
>  int
>  xchk_setup_inode_bmap(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
> -	int				error;
> +	int			error;
>  
>  	error = xchk_get_inode(sc, ip);
>  	if (error)
> @@ -80,25 +80,25 @@ xchk_setup_inode_bmap(
>  
>  struct xchk_bmap_info {
>  	struct xfs_scrub	*sc;
> -	xfs_fileoff_t			lastoff;
> -	bool				is_rt;
> -	bool				is_shared;
> -	int				whichfork;
> +	xfs_fileoff_t		lastoff;
> +	bool			is_rt;
> +	bool			is_shared;
> +	int			whichfork;
>  };
>  
>  /* Look for a corresponding rmap for this irec. */
>  static inline bool
>  xchk_bmap_get_rmap(
> -	struct xchk_bmap_info		*info,
> -	struct xfs_bmbt_irec		*irec,
> -	xfs_agblock_t			agbno,
> -	uint64_t			owner,
> -	struct xfs_rmap_irec		*rmap)
> +	struct xchk_bmap_info	*info,
> +	struct xfs_bmbt_irec	*irec,
> +	xfs_agblock_t		agbno,
> +	uint64_t		owner,
> +	struct xfs_rmap_irec	*rmap)
>  {
> -	xfs_fileoff_t			offset;
> -	unsigned int			rflags = 0;
> -	int				has_rmap;
> -	int				error;
> +	xfs_fileoff_t		offset;
> +	unsigned int		rflags = 0;
> +	int			has_rmap;
> +	int			error;
>  
>  	if (info->whichfork == XFS_ATTR_FORK)
>  		rflags |= XFS_RMAP_ATTR_FORK;
> @@ -152,13 +152,13 @@ xchk_bmap_get_rmap(
>  /* Make sure that we have rmapbt records for this extent. */
>  STATIC void
>  xchk_bmap_xref_rmap(
> -	struct xchk_bmap_info		*info,
> -	struct xfs_bmbt_irec		*irec,
> -	xfs_agblock_t			agbno)
> +	struct xchk_bmap_info	*info,
> +	struct xfs_bmbt_irec	*irec,
> +	xfs_agblock_t		agbno)
>  {
> -	struct xfs_rmap_irec		rmap;
> -	unsigned long long		rmap_end;
> -	uint64_t			owner;
> +	struct xfs_rmap_irec	rmap;
> +	unsigned long long	rmap_end;
> +	uint64_t		owner;
>  
>  	if (!info->sc->sa.rmap_cur || xchk_skip_xref(info->sc->sm))
>  		return;
> @@ -222,10 +222,10 @@ xchk_bmap_xref_rmap(
>  /* Cross-reference a single rtdev extent record. */
>  STATIC void
>  xchk_bmap_rt_extent_xref(
> -	struct xchk_bmap_info		*info,
> -	struct xfs_inode		*ip,
> -	struct xfs_btree_cur		*cur,
> -	struct xfs_bmbt_irec		*irec)
> +	struct xchk_bmap_info	*info,
> +	struct xfs_inode	*ip,
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_bmbt_irec	*irec)
>  {
>  	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return;
> @@ -237,16 +237,16 @@ xchk_bmap_rt_extent_xref(
>  /* Cross-reference a single datadev extent record. */
>  STATIC void
>  xchk_bmap_extent_xref(
> -	struct xchk_bmap_info		*info,
> -	struct xfs_inode		*ip,
> -	struct xfs_btree_cur		*cur,
> -	struct xfs_bmbt_irec		*irec)
> +	struct xchk_bmap_info	*info,
> +	struct xfs_inode	*ip,
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_bmbt_irec	*irec)
>  {
> -	struct xfs_mount		*mp = info->sc->mp;
> -	xfs_agnumber_t			agno;
> -	xfs_agblock_t			agbno;
> -	xfs_extlen_t			len;
> -	int				error;
> +	struct xfs_mount	*mp = info->sc->mp;
> +	xfs_agnumber_t		agno;
> +	xfs_agblock_t		agbno;
> +	xfs_extlen_t		len;
> +	int			error;
>  
>  	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return;
> @@ -284,15 +284,15 @@ xchk_bmap_extent_xref(
>  /* Scrub a single extent record. */
>  STATIC int
>  xchk_bmap_extent(
> -	struct xfs_inode		*ip,
> -	struct xfs_btree_cur		*cur,
> -	struct xchk_bmap_info		*info,
> -	struct xfs_bmbt_irec		*irec)
> +	struct xfs_inode	*ip,
> +	struct xfs_btree_cur	*cur,
> +	struct xchk_bmap_info	*info,
> +	struct xfs_bmbt_irec	*irec)
>  {
> -	struct xfs_mount		*mp = info->sc->mp;
> -	struct xfs_buf			*bp = NULL;
> -	xfs_filblks_t			end;
> -	int				error = 0;
> +	struct xfs_mount	*mp = info->sc->mp;
> +	struct xfs_buf		*bp = NULL;
> +	xfs_filblks_t		end;
> +	int			error = 0;
>  
>  	if (cur)
>  		xfs_btree_get_block(cur, 0, &bp);
> @@ -357,16 +357,16 @@ xchk_bmap_extent(
>  /* Scrub a bmbt record. */
>  STATIC int
>  xchk_bmapbt_rec(
> -	struct xchk_btree		*bs,
> -	union xfs_btree_rec		*rec)
> +	struct xchk_btree	*bs,
> +	union xfs_btree_rec	*rec)
>  {
> -	struct xfs_bmbt_irec		irec;
> -	struct xchk_bmap_info		*info = bs->private;
> -	struct xfs_inode		*ip = bs->cur->bc_private.b.ip;
> -	struct xfs_buf			*bp = NULL;
> -	struct xfs_btree_block		*block;
> -	uint64_t			owner;
> -	int				i;
> +	struct xfs_bmbt_irec	irec;
> +	struct xchk_bmap_info	*info = bs->private;
> +	struct xfs_inode	*ip = bs->cur->bc_private.b.ip;
> +	struct xfs_buf		*bp = NULL;
> +	struct xfs_btree_block	*block;
> +	uint64_t		owner;
> +	int			i;
>  
>  	/*
>  	 * Check the owners of the btree blocks up to the level below
> @@ -392,14 +392,14 @@ xchk_bmapbt_rec(
>  STATIC int
>  xchk_bmap_btree(
>  	struct xfs_scrub	*sc,
> -	int				whichfork,
> -	struct xchk_bmap_info		*info)
> +	int			whichfork,
> +	struct xchk_bmap_info	*info)
>  {
> -	struct xfs_owner_info		oinfo;
> -	struct xfs_mount		*mp = sc->mp;
> -	struct xfs_inode		*ip = sc->ip;
> -	struct xfs_btree_cur		*cur;
> -	int				error;
> +	struct xfs_owner_info	oinfo;
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_inode	*ip = sc->ip;
> +	struct xfs_btree_cur	*cur;
> +	int			error;
>  
>  	cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
>  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
> @@ -410,8 +410,8 @@ xchk_bmap_btree(
>  
>  struct xchk_bmap_check_rmap_info {
>  	struct xfs_scrub	*sc;
> -	int				whichfork;
> -	struct xfs_iext_cursor		icur;
> +	int			whichfork;
> +	struct xfs_iext_cursor	icur;
>  };
>  
>  /* Can we find bmaps that fit this rmap? */
> @@ -424,7 +424,7 @@ xchk_bmap_check_rmap(
>  	struct xfs_bmbt_irec		irec;
>  	struct xchk_bmap_check_rmap_info	*sbcri = priv;
>  	struct xfs_ifork		*ifp;
> -	struct xfs_scrub	*sc = sbcri->sc;
> +	struct xfs_scrub		*sc = sbcri->sc;
>  	bool				have_map;
>  
>  	/* Is this even the right fork? */
> @@ -488,7 +488,7 @@ xchk_bmap_check_rmap(
>  /* Make sure each rmap has a corresponding bmbt entry. */
>  STATIC int
>  xchk_bmap_check_ag_rmaps(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	int				whichfork,
>  	xfs_agnumber_t			agno)
>  {
> @@ -523,11 +523,11 @@ xchk_bmap_check_ag_rmaps(
>  STATIC int
>  xchk_bmap_check_rmaps(
>  	struct xfs_scrub	*sc,
> -	int				whichfork)
> +	int			whichfork)
>  {
> -	loff_t				size;
> -	xfs_agnumber_t			agno;
> -	int				error;
> +	loff_t			size;
> +	xfs_agnumber_t		agno;
> +	int			error;
>  
>  	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb) ||
>  	    whichfork == XFS_COW_FORK ||
> @@ -580,16 +580,16 @@ xchk_bmap_check_rmaps(
>  STATIC int
>  xchk_bmap(
>  	struct xfs_scrub	*sc,
> -	int				whichfork)
> +	int			whichfork)
>  {
> -	struct xfs_bmbt_irec		irec;
> -	struct xchk_bmap_info		info = { NULL };
> -	struct xfs_mount		*mp = sc->mp;
> -	struct xfs_inode		*ip = sc->ip;
> -	struct xfs_ifork		*ifp;
> -	xfs_fileoff_t			endoff;
> -	struct xfs_iext_cursor		icur;
> -	int				error = 0;
> +	struct xfs_bmbt_irec	irec;
> +	struct xchk_bmap_info	info = { NULL };
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_inode	*ip = sc->ip;
> +	struct xfs_ifork	*ifp;
> +	xfs_fileoff_t		endoff;
> +	struct xfs_iext_cursor	icur;
> +	int			error = 0;
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index c4e1dce8c5b3..4ae959f7ad2c 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -31,11 +31,11 @@
>  static bool
>  __xchk_btree_process_error(
>  	struct xfs_scrub	*sc,
> -	struct xfs_btree_cur		*cur,
> -	int				level,
> -	int				*error,
> -	__u32				errflag,
> -	void				*ret_ip)
> +	struct xfs_btree_cur	*cur,
> +	int			level,
> +	int			*error,
> +	__u32			errflag,
> +	void			*ret_ip)
>  {
>  	if (*error == 0)
>  		return true;
> @@ -66,9 +66,9 @@ __xchk_btree_process_error(
>  bool
>  xchk_btree_process_error(
>  	struct xfs_scrub	*sc,
> -	struct xfs_btree_cur		*cur,
> -	int				level,
> -	int				*error)
> +	struct xfs_btree_cur	*cur,
> +	int			level,
> +	int			*error)
>  {
>  	return __xchk_btree_process_error(sc, cur, level, error,
>  			XFS_SCRUB_OFLAG_CORRUPT, __return_address);
> @@ -77,9 +77,9 @@ xchk_btree_process_error(
>  bool
>  xchk_btree_xref_process_error(
>  	struct xfs_scrub	*sc,
> -	struct xfs_btree_cur		*cur,
> -	int				level,
> -	int				*error)
> +	struct xfs_btree_cur	*cur,
> +	int			level,
> +	int			*error)
>  {
>  	return __xchk_btree_process_error(sc, cur, level, error,
>  			XFS_SCRUB_OFLAG_XFAIL, __return_address);
> @@ -89,10 +89,10 @@ xchk_btree_xref_process_error(
>  static void
>  __xchk_btree_set_corrupt(
>  	struct xfs_scrub	*sc,
> -	struct xfs_btree_cur		*cur,
> -	int				level,
> -	__u32				errflag,
> -	void				*ret_ip)
> +	struct xfs_btree_cur	*cur,
> +	int			level,
> +	__u32			errflag,
> +	void			*ret_ip)
>  {
>  	sc->sm->sm_flags |= errflag;
>  
> @@ -107,8 +107,8 @@ __xchk_btree_set_corrupt(
>  void
>  xchk_btree_set_corrupt(
>  	struct xfs_scrub	*sc,
> -	struct xfs_btree_cur		*cur,
> -	int				level)
> +	struct xfs_btree_cur	*cur,
> +	int			level)
>  {
>  	__xchk_btree_set_corrupt(sc, cur, level, XFS_SCRUB_OFLAG_CORRUPT,
>  			__return_address);
> @@ -117,8 +117,8 @@ xchk_btree_set_corrupt(
>  void
>  xchk_btree_xref_set_corrupt(
>  	struct xfs_scrub	*sc,
> -	struct xfs_btree_cur		*cur,
> -	int				level)
> +	struct xfs_btree_cur	*cur,
> +	int			level)
>  {
>  	__xchk_btree_set_corrupt(sc, cur, level, XFS_SCRUB_OFLAG_XCORRUPT,
>  			__return_address);
> @@ -225,11 +225,11 @@ xchk_btree_key(
>   */
>  static bool
>  xchk_btree_ptr_ok(
> -	struct xchk_btree		*bs,
> -	int				level,
> -	union xfs_btree_ptr		*ptr)
> +	struct xchk_btree	*bs,
> +	int			level,
> +	union xfs_btree_ptr	*ptr)
>  {
> -	bool				res;
> +	bool			res;
>  
>  	/* A btree rooted in an inode has no block pointer to the root. */
>  	if ((bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> @@ -250,18 +250,18 @@ xchk_btree_ptr_ok(
>  /* Check that a btree block's sibling matches what we expect it. */
>  STATIC int
>  xchk_btree_block_check_sibling(
> -	struct xchk_btree		*bs,
> -	int				level,
> -	int				direction,
> -	union xfs_btree_ptr		*sibling)
> +	struct xchk_btree	*bs,
> +	int			level,
> +	int			direction,
> +	union xfs_btree_ptr	*sibling)
>  {
> -	struct xfs_btree_cur		*cur = bs->cur;
> -	struct xfs_btree_block		*pblock;
> -	struct xfs_buf			*pbp;
> -	struct xfs_btree_cur		*ncur = NULL;
> -	union xfs_btree_ptr		*pp;
> -	int				success;
> -	int				error;
> +	struct xfs_btree_cur	*cur = bs->cur;
> +	struct xfs_btree_block	*pblock;
> +	struct xfs_buf		*pbp;
> +	struct xfs_btree_cur	*ncur = NULL;
> +	union xfs_btree_ptr	*pp;
> +	int			success;
> +	int			error;
>  
>  	error = xfs_btree_dup_cursor(cur, &ncur);
>  	if (!xchk_btree_process_error(bs->sc, cur, level + 1, &error) ||
> @@ -313,14 +313,14 @@ xchk_btree_block_check_sibling(
>  /* Check the siblings of a btree block. */
>  STATIC int
>  xchk_btree_block_check_siblings(
> -	struct xchk_btree		*bs,
> -	struct xfs_btree_block		*block)
> +	struct xchk_btree	*bs,
> +	struct xfs_btree_block	*block)
>  {
> -	struct xfs_btree_cur		*cur = bs->cur;
> -	union xfs_btree_ptr		leftsib;
> -	union xfs_btree_ptr		rightsib;
> -	int				level;
> -	int				error = 0;
> +	struct xfs_btree_cur	*cur = bs->cur;
> +	union xfs_btree_ptr	leftsib;
> +	union xfs_btree_ptr	rightsib;
> +	int			level;
> +	int			error = 0;
>  
>  	xfs_btree_get_sibling(cur, block, &leftsib, XFS_BB_LEFTSIB);
>  	xfs_btree_get_sibling(cur, block, &rightsib, XFS_BB_RIGHTSIB);
> @@ -361,15 +361,15 @@ struct check_owner {
>   */
>  STATIC int
>  xchk_btree_check_block_owner(
> -	struct xchk_btree		*bs,
> -	int				level,
> -	xfs_daddr_t			daddr)
> +	struct xchk_btree	*bs,
> +	int			level,
> +	xfs_daddr_t		daddr)
>  {
> -	xfs_agnumber_t			agno;
> -	xfs_agblock_t			agbno;
> -	xfs_btnum_t			btnum;
> -	bool				init_sa;
> -	int				error = 0;
> +	xfs_agnumber_t		agno;
> +	xfs_agblock_t		agbno;
> +	xfs_btnum_t		btnum;
> +	bool			init_sa;
> +	int			error = 0;
>  
>  	if (!bs->cur)
>  		return 0;
> @@ -408,12 +408,12 @@ xchk_btree_check_block_owner(
>  /* Check the owner of a btree block. */
>  STATIC int
>  xchk_btree_check_owner(
> -	struct xchk_btree		*bs,
> -	int				level,
> -	struct xfs_buf			*bp)
> +	struct xchk_btree	*bs,
> +	int			level,
> +	struct xfs_buf		*bp)
>  {
> -	struct xfs_btree_cur		*cur = bs->cur;
> -	struct check_owner		*co;
> +	struct xfs_btree_cur	*cur = bs->cur;
> +	struct check_owner	*co;
>  
>  	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) && bp == NULL)
>  		return 0;
> @@ -484,14 +484,14 @@ xchk_btree_check_minrecs(
>   */
>  STATIC int
>  xchk_btree_get_block(
> -	struct xchk_btree		*bs,
> -	int				level,
> -	union xfs_btree_ptr		*pp,
> -	struct xfs_btree_block		**pblock,
> -	struct xfs_buf			**pbp)
> +	struct xchk_btree	*bs,
> +	int			level,
> +	union xfs_btree_ptr	*pp,
> +	struct xfs_btree_block	**pblock,
> +	struct xfs_buf		**pbp)
>  {
> -	void				*failed_at;
> -	int				error;
> +	xfs_failaddr_t		failed_at;
> +	int			error;
>  
>  	*pblock = NULL;
>  	*pbp = NULL;
> @@ -538,17 +538,17 @@ xchk_btree_get_block(
>   */
>  STATIC void
>  xchk_btree_block_keys(
> -	struct xchk_btree		*bs,
> -	int				level,
> -	struct xfs_btree_block		*block)
> +	struct xchk_btree	*bs,
> +	int			level,
> +	struct xfs_btree_block	*block)
>  {
> -	union xfs_btree_key		block_keys;
> -	struct xfs_btree_cur		*cur = bs->cur;
> -	union xfs_btree_key		*high_bk;
> -	union xfs_btree_key		*parent_keys;
> -	union xfs_btree_key		*high_pk;
> -	struct xfs_btree_block		*parent_block;
> -	struct xfs_buf			*bp;
> +	union xfs_btree_key	block_keys;
> +	struct xfs_btree_cur	*cur = bs->cur;
> +	union xfs_btree_key	*high_bk;
> +	union xfs_btree_key	*parent_keys;
> +	union xfs_btree_key	*high_pk;
> +	struct xfs_btree_block	*parent_block;
> +	struct xfs_buf		*bp;
>  
>  	if (level >= cur->bc_nlevels - 1)
>  		return;
> @@ -584,22 +584,22 @@ xchk_btree_block_keys(
>  int
>  xchk_btree(
>  	struct xfs_scrub	*sc,
> -	struct xfs_btree_cur		*cur,
> -	xchk_btree_rec_fn		scrub_fn,
> -	struct xfs_owner_info		*oinfo,
> -	void				*private)
> +	struct xfs_btree_cur	*cur,
> +	xchk_btree_rec_fn	scrub_fn,
> +	struct xfs_owner_info	*oinfo,
> +	void			*private)
>  {
> -	struct xchk_btree		bs = { NULL };
> -	union xfs_btree_ptr		ptr;
> -	union xfs_btree_ptr		*pp;
> -	union xfs_btree_rec		*recp;
> -	struct xfs_btree_block		*block;
> -	int				level;
> -	struct xfs_buf			*bp;
> -	struct check_owner		*co;
> -	struct check_owner		*n;
> -	int				i;
> -	int				error = 0;
> +	struct xchk_btree	bs = { NULL };
> +	union xfs_btree_ptr	ptr;
> +	union xfs_btree_ptr	*pp;
> +	union xfs_btree_rec	*recp;
> +	struct xfs_btree_block	*block;
> +	int			level;
> +	struct xfs_buf		*bp;
> +	struct check_owner	*co;
> +	struct check_owner	*n;
> +	int			i;
> +	int			error = 0;
>  
>  	/* Initialize scrub state */
>  	bs.cur = cur;
> diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
> index a0b74b515b9b..aada763cd006 100644
> --- a/fs/xfs/scrub/btree.h
> +++ b/fs/xfs/scrub/btree.h
> @@ -14,8 +14,7 @@ bool xchk_btree_process_error(struct xfs_scrub *sc,
>  
>  /* Check for btree xref operation errors. */
>  bool xchk_btree_xref_process_error(struct xfs_scrub *sc,
> -				struct xfs_btree_cur *cur, int level,
> -				int *error);
> +		struct xfs_btree_cur *cur, int level, int *error);
>  
>  /* Check for btree corruption. */
>  void xchk_btree_set_corrupt(struct xfs_scrub *sc,
> @@ -33,20 +32,20 @@ typedef int (*xchk_btree_rec_fn)(
>  struct xchk_btree {
>  	/* caller-provided scrub state */
>  	struct xfs_scrub	*sc;
> -	struct xfs_btree_cur		*cur;
> -	xchk_btree_rec_fn		scrub_rec;
> -	struct xfs_owner_info		*oinfo;
> -	void				*private;
> +	struct xfs_btree_cur	*cur;
> +	xchk_btree_rec_fn	scrub_rec;
> +	struct xfs_owner_info	*oinfo;
> +	void			*private;
>  
>  	/* internal scrub state */
> -	union xfs_btree_rec		lastrec;
> -	bool				firstrec;
> -	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
> -	bool				firstkey[XFS_BTREE_MAXLEVELS];
> -	struct list_head		to_check;
> +	union xfs_btree_rec	lastrec;
> +	bool			firstrec;
> +	union xfs_btree_key	lastkey[XFS_BTREE_MAXLEVELS];
> +	bool			firstkey[XFS_BTREE_MAXLEVELS];
> +	struct list_head	to_check;
>  };
>  int xchk_btree(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
> -		    xchk_btree_rec_fn scrub_fn,
> -		    struct xfs_owner_info *oinfo, void *private);
> +		xchk_btree_rec_fn scrub_fn, struct xfs_owner_info *oinfo,
> +		void *private);
>  
>  #endif /* __XFS_SCRUB_BTREE_H__ */
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 81e8bb7d5486..248efa74c390 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -70,11 +70,11 @@
>  static bool
>  __xchk_process_error(
>  	struct xfs_scrub	*sc,
> -	xfs_agnumber_t			agno,
> -	xfs_agblock_t			bno,
> -	int				*error,
> -	__u32				errflag,
> -	void				*ret_ip)
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		bno,
> +	int			*error,
> +	__u32			errflag,
> +	void			*ret_ip)
>  {
>  	switch (*error) {
>  	case 0:
> @@ -100,9 +100,9 @@ __xchk_process_error(
>  bool
>  xchk_process_error(
>  	struct xfs_scrub	*sc,
> -	xfs_agnumber_t			agno,
> -	xfs_agblock_t			bno,
> -	int				*error)
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		bno,
> +	int			*error)
>  {
>  	return __xchk_process_error(sc, agno, bno, error,
>  			XFS_SCRUB_OFLAG_CORRUPT, __return_address);
> @@ -111,9 +111,9 @@ xchk_process_error(
>  bool
>  xchk_xref_process_error(
>  	struct xfs_scrub	*sc,
> -	xfs_agnumber_t			agno,
> -	xfs_agblock_t			bno,
> -	int				*error)
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		bno,
> +	int			*error)
>  {
>  	return __xchk_process_error(sc, agno, bno, error,
>  			XFS_SCRUB_OFLAG_XFAIL, __return_address);
> @@ -123,11 +123,11 @@ xchk_xref_process_error(
>  static bool
>  __xchk_fblock_process_error(
>  	struct xfs_scrub	*sc,
> -	int				whichfork,
> -	xfs_fileoff_t			offset,
> -	int				*error,
> -	__u32				errflag,
> -	void				*ret_ip)
> +	int			whichfork,
> +	xfs_fileoff_t		offset,
> +	int			*error,
> +	__u32			errflag,
> +	void			*ret_ip)
>  {
>  	switch (*error) {
>  	case 0:
> @@ -153,9 +153,9 @@ __xchk_fblock_process_error(
>  bool
>  xchk_fblock_process_error(
>  	struct xfs_scrub	*sc,
> -	int				whichfork,
> -	xfs_fileoff_t			offset,
> -	int				*error)
> +	int			whichfork,
> +	xfs_fileoff_t		offset,
> +	int			*error)
>  {
>  	return __xchk_fblock_process_error(sc, whichfork, offset, error,
>  			XFS_SCRUB_OFLAG_CORRUPT, __return_address);
> @@ -164,9 +164,9 @@ xchk_fblock_process_error(
>  bool
>  xchk_fblock_xref_process_error(
>  	struct xfs_scrub	*sc,
> -	int				whichfork,
> -	xfs_fileoff_t			offset,
> -	int				*error)
> +	int			whichfork,
> +	xfs_fileoff_t		offset,
> +	int			*error)
>  {
>  	return __xchk_fblock_process_error(sc, whichfork, offset, error,
>  			XFS_SCRUB_OFLAG_XFAIL, __return_address);
> @@ -188,7 +188,7 @@ xchk_fblock_xref_process_error(
>  void
>  xchk_block_set_preen(
>  	struct xfs_scrub	*sc,
> -	struct xfs_buf			*bp)
> +	struct xfs_buf		*bp)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
>  	trace_xchk_block_preen(sc, bp->b_bn, __return_address);
> @@ -202,7 +202,7 @@ xchk_block_set_preen(
>  void
>  xchk_ino_set_preen(
>  	struct xfs_scrub	*sc,
> -	xfs_ino_t			ino)
> +	xfs_ino_t		ino)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
>  	trace_xchk_ino_preen(sc, ino, __return_address);
> @@ -212,7 +212,7 @@ xchk_ino_set_preen(
>  void
>  xchk_block_set_corrupt(
>  	struct xfs_scrub	*sc,
> -	struct xfs_buf			*bp)
> +	struct xfs_buf		*bp)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
>  	trace_xchk_block_error(sc, bp->b_bn, __return_address);
> @@ -222,7 +222,7 @@ xchk_block_set_corrupt(
>  void
>  xchk_block_xref_set_corrupt(
>  	struct xfs_scrub	*sc,
> -	struct xfs_buf			*bp)
> +	struct xfs_buf		*bp)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
>  	trace_xchk_block_error(sc, bp->b_bn, __return_address);
> @@ -236,7 +236,7 @@ xchk_block_xref_set_corrupt(
>  void
>  xchk_ino_set_corrupt(
>  	struct xfs_scrub	*sc,
> -	xfs_ino_t			ino)
> +	xfs_ino_t		ino)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
>  	trace_xchk_ino_error(sc, ino, __return_address);
> @@ -246,7 +246,7 @@ xchk_ino_set_corrupt(
>  void
>  xchk_ino_xref_set_corrupt(
>  	struct xfs_scrub	*sc,
> -	xfs_ino_t			ino)
> +	xfs_ino_t		ino)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
>  	trace_xchk_ino_error(sc, ino, __return_address);
> @@ -256,8 +256,8 @@ xchk_ino_xref_set_corrupt(
>  void
>  xchk_fblock_set_corrupt(
>  	struct xfs_scrub	*sc,
> -	int				whichfork,
> -	xfs_fileoff_t			offset)
> +	int			whichfork,
> +	xfs_fileoff_t		offset)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
>  	trace_xchk_fblock_error(sc, whichfork, offset, __return_address);
> @@ -267,8 +267,8 @@ xchk_fblock_set_corrupt(
>  void
>  xchk_fblock_xref_set_corrupt(
>  	struct xfs_scrub	*sc,
> -	int				whichfork,
> -	xfs_fileoff_t			offset)
> +	int			whichfork,
> +	xfs_fileoff_t		offset)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
>  	trace_xchk_fblock_error(sc, whichfork, offset, __return_address);
> @@ -281,7 +281,7 @@ xchk_fblock_xref_set_corrupt(
>  void
>  xchk_ino_set_warning(
>  	struct xfs_scrub	*sc,
> -	xfs_ino_t			ino)
> +	xfs_ino_t		ino)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
>  	trace_xchk_ino_warning(sc, ino, __return_address);
> @@ -291,8 +291,8 @@ xchk_ino_set_warning(
>  void
>  xchk_fblock_set_warning(
>  	struct xfs_scrub	*sc,
> -	int				whichfork,
> -	xfs_fileoff_t			offset)
> +	int			whichfork,
> +	xfs_fileoff_t		offset)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
>  	trace_xchk_fblock_warning(sc, whichfork, offset, __return_address);
> @@ -319,13 +319,13 @@ struct xchk_rmap_ownedby_info {
>  
>  STATIC int
>  xchk_count_rmap_ownedby_irec(
> -	struct xfs_btree_cur			*cur,
> -	struct xfs_rmap_irec			*rec,
> -	void					*priv)
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_rmap_irec		*rec,
> +	void				*priv)
>  {
> -	struct xchk_rmap_ownedby_info		*sroi = priv;
> -	bool					irec_attr;
> -	bool					oinfo_attr;
> +	struct xchk_rmap_ownedby_info	*sroi = priv;
> +	bool				irec_attr;
> +	bool				oinfo_attr;
>  
>  	irec_attr = rec->rm_flags & XFS_RMAP_ATTR_FORK;
>  	oinfo_attr = sroi->oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK;
> @@ -346,11 +346,11 @@ xchk_count_rmap_ownedby_irec(
>  int
>  xchk_count_rmap_ownedby_ag(
>  	struct xfs_scrub		*sc,
> -	struct xfs_btree_cur			*cur,
> -	struct xfs_owner_info			*oinfo,
> -	xfs_filblks_t				*blocks)
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_owner_info		*oinfo,
> +	xfs_filblks_t			*blocks)
>  {
> -	struct xchk_rmap_ownedby_info		sroi;
> +	struct xchk_rmap_ownedby_info	sroi;
>  
>  	sroi.oinfo = oinfo;
>  	*blocks = 0;
> @@ -372,7 +372,7 @@ xchk_count_rmap_ownedby_ag(
>  static inline bool
>  want_ag_read_header_failure(
>  	struct xfs_scrub	*sc,
> -	unsigned int			type)
> +	unsigned int		type)
>  {
>  	/* Return all AG header read failures when scanning btrees. */
>  	if (sc->sm->sm_type != XFS_SCRUB_TYPE_AGF &&
> @@ -399,13 +399,13 @@ want_ag_read_header_failure(
>  int
>  xchk_ag_read_headers(
>  	struct xfs_scrub	*sc,
> -	xfs_agnumber_t			agno,
> -	struct xfs_buf			**agi,
> -	struct xfs_buf			**agf,
> -	struct xfs_buf			**agfl)
> +	xfs_agnumber_t		agno,
> +	struct xfs_buf		**agi,
> +	struct xfs_buf		**agf,
> +	struct xfs_buf		**agfl)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	int				error;
> +	struct xfs_mount	*mp = sc->mp;
> +	int			error;
>  
>  	error = xfs_ialloc_read_agi(mp, sc->tp, agno, agi);
>  	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGI))
> @@ -455,8 +455,8 @@ xchk_ag_btcur_init(
>  	struct xfs_scrub	*sc,
>  	struct xchk_ag		*sa)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	xfs_agnumber_t			agno = sa->agno;
> +	struct xfs_mount	*mp = sc->mp;
> +	xfs_agnumber_t		agno = sa->agno;
>  
>  	if (sa->agf_bp) {
>  		/* Set up a bnobt cursor for cross-referencing. */
> @@ -545,10 +545,10 @@ xchk_ag_free(
>  int
>  xchk_ag_init(
>  	struct xfs_scrub	*sc,
> -	xfs_agnumber_t			agno,
> +	xfs_agnumber_t		agno,
>  	struct xchk_ag		*sa)
>  {
> -	int				error;
> +	int			error;
>  
>  	sa->agno = agno;
>  	error = xchk_ag_read_headers(sc, agno, &sa->agi_bp,
> @@ -566,7 +566,7 @@ xchk_ag_init(
>  void
>  xchk_perag_get(
>  	struct xfs_mount	*mp,
> -	struct xchk_ag	*sa)
> +	struct xchk_ag		*sa)
>  {
>  	if (!sa->pag)
>  		sa->pag = xfs_perag_get(mp, sa->agno);
> @@ -587,7 +587,7 @@ xchk_perag_get(
>  int
>  xchk_trans_alloc(
>  	struct xfs_scrub	*sc,
> -	uint				resblks)
> +	uint			resblks)
>  {
>  	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
>  		return xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
> @@ -600,9 +600,9 @@ xchk_trans_alloc(
>  int
>  xchk_setup_fs(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
> -	uint				resblks;
> +	uint			resblks;
>  
>  	resblks = xrep_calc_ag_resblks(sc);
>  	return xchk_trans_alloc(sc, resblks);
> @@ -612,11 +612,11 @@ xchk_setup_fs(
>  int
>  xchk_setup_ag_btree(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip,
> -	bool				force_log)
> +	struct xfs_inode	*ip,
> +	bool			force_log)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	int				error;
> +	struct xfs_mount	*mp = sc->mp;
> +	int			error;
>  
>  	/*
>  	 * If the caller asks us to checkpont the log, do so.  This
> @@ -659,12 +659,12 @@ xchk_checkpoint_log(
>  int
>  xchk_get_inode(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip_in)
> +	struct xfs_inode	*ip_in)
>  {
> -	struct xfs_imap			imap;
> -	struct xfs_mount		*mp = sc->mp;
> -	struct xfs_inode		*ip = NULL;
> -	int				error;
> +	struct xfs_imap		imap;
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_inode	*ip = NULL;
> +	int			error;
>  
>  	/* We want to scan the inode we already had opened. */
>  	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino) {
> @@ -723,10 +723,10 @@ xchk_get_inode(
>  int
>  xchk_setup_inode_contents(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip,
> -	unsigned int			resblks)
> +	struct xfs_inode	*ip,
> +	unsigned int		resblks)
>  {
> -	int				error;
> +	int			error;
>  
>  	error = xchk_get_inode(sc, ip);
>  	if (error)
> @@ -754,8 +754,8 @@ xchk_setup_inode_contents(
>  bool
>  xchk_should_check_xref(
>  	struct xfs_scrub	*sc,
> -	int				*error,
> -	struct xfs_btree_cur		**curpp)
> +	int			*error,
> +	struct xfs_btree_cur	**curpp)
>  {
>  	/* No point in xref if we already know we're corrupt. */
>  	if (xchk_skip_xref(sc->sm))
> @@ -789,9 +789,9 @@ xchk_should_check_xref(
>  void
>  xchk_buffer_recheck(
>  	struct xfs_scrub	*sc,
> -	struct xfs_buf			*bp)
> +	struct xfs_buf		*bp)
>  {
> -	xfs_failaddr_t			fa;
> +	xfs_failaddr_t		fa;
>  
>  	if (bp->b_ops == NULL) {
>  		xchk_block_set_corrupt(sc, bp);
> @@ -816,9 +816,9 @@ int
>  xchk_metadata_inode_forks(
>  	struct xfs_scrub	*sc)
>  {
> -	__u32				smtype;
> -	bool				shared;
> -	int				error;
> +	__u32			smtype;
> +	bool			shared;
> +	int			error;
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return 0;
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index c321230d32dc..2d4324d12f9a 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -108,24 +108,21 @@ xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip)
>  
>  void xchk_ag_free(struct xfs_scrub *sc, struct xchk_ag *sa);
>  int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
> -		      struct xchk_ag *sa);
> +		struct xchk_ag *sa);
>  void xchk_perag_get(struct xfs_mount *mp, struct xchk_ag *sa);
>  int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
> -			      struct xfs_buf **agi, struct xfs_buf **agf,
> -			      struct xfs_buf **agfl);
> +		struct xfs_buf **agi, struct xfs_buf **agf,
> +		struct xfs_buf **agfl);
>  void xchk_ag_btcur_free(struct xchk_ag *sa);
> -int xchk_ag_btcur_init(struct xfs_scrub *sc,
> -			    struct xchk_ag *sa);
> -int xchk_count_rmap_ownedby_ag(struct xfs_scrub *sc,
> -				    struct xfs_btree_cur *cur,
> -				    struct xfs_owner_info *oinfo,
> -				    xfs_filblks_t *blocks);
> +int xchk_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
> +int xchk_count_rmap_ownedby_ag(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
> +		struct xfs_owner_info *oinfo, xfs_filblks_t *blocks);
>  
> -int xchk_setup_ag_btree(struct xfs_scrub *sc,
> -			     struct xfs_inode *ip, bool force_log);
> +int xchk_setup_ag_btree(struct xfs_scrub *sc, struct xfs_inode *ip,
> +		bool force_log);
>  int xchk_get_inode(struct xfs_scrub *sc, struct xfs_inode *ip_in);
> -int xchk_setup_inode_contents(struct xfs_scrub *sc,
> -				   struct xfs_inode *ip, unsigned int resblks);
> +int xchk_setup_inode_contents(struct xfs_scrub *sc, struct xfs_inode *ip,
> +		unsigned int resblks);
>  void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
>  
>  /*
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 7fc12d540ea6..f1260b4bfdee 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -36,9 +36,9 @@
>   */
>  bool
>  xchk_da_process_error(
> -	struct xchk_da_btree		*ds,
> -	int				level,
> -	int				*error)
> +	struct xchk_da_btree	*ds,
> +	int			level,
> +	int			*error)
>  {
>  	struct xfs_scrub	*sc = ds->sc;
>  
> @@ -72,8 +72,8 @@ xchk_da_process_error(
>   */
>  void
>  xchk_da_set_corrupt(
> -	struct xchk_da_btree		*ds,
> -	int				level)
> +	struct xchk_da_btree	*ds,
> +	int			level)
>  {
>  	struct xfs_scrub	*sc = ds->sc;
>  
> @@ -88,13 +88,13 @@ xchk_da_set_corrupt(
>  /* Find an entry at a certain level in a da btree. */
>  STATIC void *
>  xchk_da_btree_entry(
> -	struct xchk_da_btree		*ds,
> -	int				level,
> -	int				rec)
> +	struct xchk_da_btree	*ds,
> +	int			level,
> +	int			rec)
>  {
> -	char				*ents;
> -	struct xfs_da_state_blk		*blk;
> -	void				*baddr;
> +	char			*ents;
> +	struct xfs_da_state_blk	*blk;
> +	void			*baddr;
>  
>  	/* Dispatch the entry finding function. */
>  	blk = &ds->state->path.blk[level];
> @@ -158,9 +158,9 @@ xchk_da_btree_hash(
>   */
>  STATIC bool
>  xchk_da_btree_ptr_ok(
> -	struct xchk_da_btree		*ds,
> -	int				level,
> -	xfs_dablk_t			blkno)
> +	struct xchk_da_btree	*ds,
> +	int			level,
> +	xfs_dablk_t		blkno)
>  {
>  	if (blkno < ds->lowest || (ds->highest != 0 && blkno >= ds->highest)) {
>  		xchk_da_set_corrupt(ds, level);
> @@ -246,13 +246,13 @@ static const struct xfs_buf_ops xchk_da_btree_buf_ops = {
>  /* Check a block's sibling. */
>  STATIC int
>  xchk_da_btree_block_check_sibling(
> -	struct xchk_da_btree		*ds,
> -	int				level,
> -	int				direction,
> -	xfs_dablk_t			sibling)
> +	struct xchk_da_btree	*ds,
> +	int			level,
> +	int			direction,
> +	xfs_dablk_t		sibling)
>  {
> -	int				retval;
> -	int				error;
> +	int			retval;
> +	int			error;
>  
>  	memcpy(&ds->state->altpath, &ds->state->path,
>  			sizeof(ds->state->altpath));
> @@ -294,13 +294,13 @@ xchk_da_btree_block_check_sibling(
>  /* Check a block's sibling pointers. */
>  STATIC int
>  xchk_da_btree_block_check_siblings(
> -	struct xchk_da_btree		*ds,
> -	int				level,
> -	struct xfs_da_blkinfo		*hdr)
> +	struct xchk_da_btree	*ds,
> +	int			level,
> +	struct xfs_da_blkinfo	*hdr)
>  {
> -	xfs_dablk_t			forw;
> -	xfs_dablk_t			back;
> -	int				error = 0;
> +	xfs_dablk_t		forw;
> +	xfs_dablk_t		back;
> +	int			error = 0;
>  
>  	forw = be32_to_cpu(hdr->forw);
>  	back = be32_to_cpu(hdr->back);
> @@ -474,9 +474,9 @@ xchk_da_btree_block(
>  /* Visit all nodes and leaves of a da btree. */
>  int
>  xchk_da_btree(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	int				whichfork,
> -	xchk_da_btree_rec_fn	scrub_fn,
> +	xchk_da_btree_rec_fn		scrub_fn,
>  	void				*private)
>  {
>  	struct xchk_da_btree		ds = {};
> diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
> index a15c03389e8f..cb3f0003245b 100644
> --- a/fs/xfs/scrub/dabtree.h
> +++ b/fs/xfs/scrub/dabtree.h
> @@ -9,12 +9,12 @@
>  /* dir/attr btree */
>  
>  struct xchk_da_btree {
> -	struct xfs_da_args		dargs;
> -	xfs_dahash_t			hashes[XFS_DA_NODE_MAXDEPTH];
> -	int				maxrecs[XFS_DA_NODE_MAXDEPTH];
> -	struct xfs_da_state		*state;
> +	struct xfs_da_args	dargs;
> +	xfs_dahash_t		hashes[XFS_DA_NODE_MAXDEPTH];
> +	int			maxrecs[XFS_DA_NODE_MAXDEPTH];
> +	struct xfs_da_state	*state;
>  	struct xfs_scrub	*sc;
> -	void				*private;
> +	void			*private;
>  
>  	/*
>  	 * Lowest and highest directory block address in which we expect
> @@ -22,10 +22,10 @@ struct xchk_da_btree {
>  	 * (presumably) means between LEAF_OFFSET and FREE_OFFSET; for
>  	 * attributes there is no limit.
>  	 */
> -	xfs_dablk_t			lowest;
> -	xfs_dablk_t			highest;
> +	xfs_dablk_t		lowest;
> +	xfs_dablk_t		highest;
>  
> -	int				tree_level;
> +	int			tree_level;
>  };
>  
>  typedef int (*xchk_da_btree_rec_fn)(struct xchk_da_btree *ds,
> @@ -37,9 +37,8 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
>  /* Check for da btree corruption. */
>  void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
>  
> -int xchk_da_btree_hash(struct xchk_da_btree *ds, int level,
> -			    __be32 *hashp);
> +int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
>  int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
> -		       xchk_da_btree_rec_fn scrub_fn, void *private);
> +		xchk_da_btree_rec_fn scrub_fn, void *private);
>  
>  #endif /* __XFS_SCRUB_DABTREE_H__ */
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 194a3ef69a9f..f58709052b03 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -33,7 +33,7 @@
>  int
>  xchk_setup_directory(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
>  	return xchk_setup_inode_contents(sc, ip, 0);
>  }
> @@ -44,7 +44,7 @@ xchk_setup_directory(
>  
>  struct xchk_dir_ctx {
>  	/* VFS fill-directory iterator */
> -	struct dir_context		dir_iter;
> +	struct dir_context	dir_iter;
>  
>  	struct xfs_scrub	*sc;
>  };
> @@ -52,15 +52,15 @@ struct xchk_dir_ctx {
>  /* Check that an inode's mode matches a given DT_ type. */
>  STATIC int
>  xchk_dir_check_ftype(
> -	struct xchk_dir_ctx		*sdc,
> -	xfs_fileoff_t			offset,
> -	xfs_ino_t			inum,
> -	int				dtype)
> +	struct xchk_dir_ctx	*sdc,
> +	xfs_fileoff_t		offset,
> +	xfs_ino_t		inum,
> +	int			dtype)
>  {
> -	struct xfs_mount		*mp = sdc->sc->mp;
> -	struct xfs_inode		*ip;
> -	int				ino_dtype;
> -	int				error = 0;
> +	struct xfs_mount	*mp = sdc->sc->mp;
> +	struct xfs_inode	*ip;
> +	int			ino_dtype;
> +	int			error = 0;
>  
>  	if (!xfs_sb_version_hasftype(&mp->m_sb)) {
>  		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
> @@ -102,20 +102,20 @@ xchk_dir_check_ftype(
>   */
>  STATIC int
>  xchk_dir_actor(
> -	struct dir_context		*dir_iter,
> -	const char			*name,
> -	int				namelen,
> -	loff_t				pos,
> -	u64				ino,
> -	unsigned			type)
> +	struct dir_context	*dir_iter,
> +	const char		*name,
> +	int			namelen,
> +	loff_t			pos,
> +	u64			ino,
> +	unsigned		type)
>  {
> -	struct xfs_mount		*mp;
> -	struct xfs_inode		*ip;
> -	struct xchk_dir_ctx		*sdc;
> -	struct xfs_name			xname;
> -	xfs_ino_t			lookup_ino;
> -	xfs_dablk_t			offset;
> -	int				error = 0;
> +	struct xfs_mount	*mp;
> +	struct xfs_inode	*ip;
> +	struct xchk_dir_ctx	*sdc;
> +	struct xfs_name		xname;
> +	xfs_ino_t		lookup_ino;
> +	xfs_dablk_t		offset;
> +	int			error = 0;
>  
>  	sdc = container_of(dir_iter, struct xchk_dir_ctx, dir_iter);
>  	ip = sdc->sc->ip;
> @@ -289,7 +289,7 @@ xchk_dir_rec(
>   */
>  STATIC void
>  xchk_directory_check_free_entry(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	xfs_dablk_t			lblk,
>  	struct xfs_dir2_data_free	*bf,
>  	struct xfs_dir2_data_unused	*dup)
> @@ -314,7 +314,7 @@ xchk_directory_check_free_entry(
>  /* Check free space info in a directory data block. */
>  STATIC int
>  xchk_directory_data_bestfree(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	xfs_dablk_t			lblk,
>  	bool				is_block)
>  {
> @@ -455,7 +455,7 @@ xchk_directory_data_bestfree(
>   */
>  STATIC void
>  xchk_directory_check_freesp(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	xfs_dablk_t			lblk,
>  	struct xfs_buf			*dbp,
>  	unsigned int			len)
> @@ -474,7 +474,7 @@ xchk_directory_check_freesp(
>  /* Check free space info in a directory leaf1 block. */
>  STATIC int
>  xchk_directory_leaf1_bestfree(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	struct xfs_da_args		*args,
>  	xfs_dablk_t			lblk)
>  {
> @@ -572,7 +572,7 @@ xchk_directory_leaf1_bestfree(
>  /* Check free space info in a directory freespace block. */
>  STATIC int
>  xchk_directory_free_bestfree(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	struct xfs_da_args		*args,
>  	xfs_dablk_t			lblk)
>  {
> @@ -628,18 +628,18 @@ STATIC int
>  xchk_directory_blocks(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_bmbt_irec		got;
> -	struct xfs_da_args		args;
> -	struct xfs_ifork		*ifp;
> -	struct xfs_mount		*mp = sc->mp;
> -	xfs_fileoff_t			leaf_lblk;
> -	xfs_fileoff_t			free_lblk;
> -	xfs_fileoff_t			lblk;
> -	struct xfs_iext_cursor		icur;
> -	xfs_dablk_t			dabno;
> -	bool				found;
> -	int				is_block = 0;
> -	int				error;
> +	struct xfs_bmbt_irec	got;
> +	struct xfs_da_args	args;
> +	struct xfs_ifork	*ifp;
> +	struct xfs_mount	*mp = sc->mp;
> +	xfs_fileoff_t		leaf_lblk;
> +	xfs_fileoff_t		free_lblk;
> +	xfs_fileoff_t		lblk;
> +	struct xfs_iext_cursor	icur;
> +	xfs_dablk_t		dabno;
> +	bool			found;
> +	int			is_block = 0;
> +	int			error;
>  
>  	/* Ignore local format directories. */
>  	if (sc->ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> @@ -772,14 +772,14 @@ int
>  xchk_directory(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xchk_dir_ctx		sdc = {
> +	struct xchk_dir_ctx	sdc = {
>  		.dir_iter.actor = xchk_dir_actor,
>  		.dir_iter.pos = 0,
>  		.sc = sc,
>  	};
> -	size_t				bufsize;
> -	loff_t				oldpos;
> -	int				error = 0;
> +	size_t			bufsize;
> +	loff_t			oldpos;
> +	int			error = 0;
>  
>  	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
>  		return -ENOENT;
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 6df8eba9f52b..224dba937492 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -37,7 +37,7 @@
>  int
>  xchk_setup_ag_iallocbt(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
>  	return xchk_setup_ag_btree(sc, ip, sc->try_harder);
>  }
> @@ -51,7 +51,7 @@ xchk_setup_ag_iallocbt(
>   */
>  static inline void
>  xchk_iallocbt_chunk_xref_other(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	struct xfs_inobt_rec_incore	*irec,
>  	xfs_agino_t			agino)
>  {
> @@ -76,7 +76,7 @@ xchk_iallocbt_chunk_xref_other(
>  /* Cross-reference with the other btrees. */
>  STATIC void
>  xchk_iallocbt_chunk_xref(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	struct xfs_inobt_rec_incore	*irec,
>  	xfs_agino_t			agino,
>  	xfs_agblock_t			agbno,
> @@ -364,13 +364,13 @@ xchk_iallocbt_rec(
>  STATIC void
>  xchk_iallocbt_xref_rmap_btreeblks(
>  	struct xfs_scrub	*sc,
> -	int				which)
> +	int			which)
>  {
> -	struct xfs_owner_info		oinfo;
> -	xfs_filblks_t			blocks;
> -	xfs_extlen_t			inobt_blocks = 0;
> -	xfs_extlen_t			finobt_blocks = 0;
> -	int				error;
> +	struct xfs_owner_info	oinfo;
> +	xfs_filblks_t		blocks;
> +	xfs_extlen_t		inobt_blocks = 0;
> +	xfs_extlen_t		finobt_blocks = 0;
> +	int			error;
>  
>  	if (!sc->sa.ino_cur || !sc->sa.rmap_cur ||
>  	    (xfs_sb_version_hasfinobt(&sc->mp->m_sb) && !sc->sa.fino_cur) ||
> @@ -404,12 +404,12 @@ xchk_iallocbt_xref_rmap_btreeblks(
>  STATIC void
>  xchk_iallocbt_xref_rmap_inodes(
>  	struct xfs_scrub	*sc,
> -	int				which,
> -	xfs_filblks_t			inode_blocks)
> +	int			which,
> +	xfs_filblks_t		inode_blocks)
>  {
> -	struct xfs_owner_info		oinfo;
> -	xfs_filblks_t			blocks;
> -	int				error;
> +	struct xfs_owner_info	oinfo;
> +	xfs_filblks_t		blocks;
> +	int			error;
>  
>  	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
>  		return;
> @@ -428,12 +428,12 @@ xchk_iallocbt_xref_rmap_inodes(
>  STATIC int
>  xchk_iallocbt(
>  	struct xfs_scrub	*sc,
> -	xfs_btnum_t			which)
> +	xfs_btnum_t		which)
>  {
> -	struct xfs_btree_cur		*cur;
> -	struct xfs_owner_info		oinfo;
> -	xfs_filblks_t			inode_blocks = 0;
> -	int				error;
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_owner_info	oinfo;
> +	xfs_filblks_t		inode_blocks = 0;
> +	int			error;
>  
>  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
>  	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
> @@ -475,13 +475,13 @@ xchk_finobt(
>  static inline void
>  xchk_xref_inode_check(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			agbno,
> -	xfs_extlen_t			len,
> -	struct xfs_btree_cur		**icur,
> -	bool				should_have_inodes)
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len,
> +	struct xfs_btree_cur	**icur,
> +	bool			should_have_inodes)
>  {
> -	bool				has_inodes;
> -	int				error;
> +	bool			has_inodes;
> +	int			error;
>  
>  	if (!(*icur) || xchk_skip_xref(sc->sm))
>  		return;
> @@ -497,8 +497,8 @@ xchk_xref_inode_check(
>  void
>  xchk_xref_is_not_inode_chunk(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			agbno,
> -	xfs_extlen_t			len)
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len)
>  {
>  	xchk_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur, false);
>  	xchk_xref_inode_check(sc, agbno, len, &sc->sa.fino_cur, false);
> @@ -508,8 +508,8 @@ xchk_xref_is_not_inode_chunk(
>  void
>  xchk_xref_is_inode_chunk(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			agbno,
> -	xfs_extlen_t			len)
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len)
>  {
>  	xchk_xref_inode_check(sc, agbno, len, &sc->sa.ino_cur, true);
>  }
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 6cc027983c13..5b3b177c0fc9 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -39,9 +39,9 @@
>  int
>  xchk_setup_inode(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
> -	int				error;
> +	int			error;
>  
>  	/*
>  	 * Try to get the inode.  If the verifiers fail, we try again
> @@ -78,12 +78,12 @@ xchk_setup_inode(
>  STATIC void
>  xchk_inode_extsize(
>  	struct xfs_scrub	*sc,
> -	struct xfs_dinode		*dip,
> -	xfs_ino_t			ino,
> -	uint16_t			mode,
> -	uint16_t			flags)
> +	struct xfs_dinode	*dip,
> +	xfs_ino_t		ino,
> +	uint16_t		mode,
> +	uint16_t		flags)
>  {
> -	xfs_failaddr_t			fa;
> +	xfs_failaddr_t		fa;
>  
>  	fa = xfs_inode_validate_extsize(sc->mp, be32_to_cpu(dip->di_extsize),
>  			mode, flags);
> @@ -100,13 +100,13 @@ xchk_inode_extsize(
>  STATIC void
>  xchk_inode_cowextsize(
>  	struct xfs_scrub	*sc,
> -	struct xfs_dinode		*dip,
> -	xfs_ino_t			ino,
> -	uint16_t			mode,
> -	uint16_t			flags,
> -	uint64_t			flags2)
> +	struct xfs_dinode	*dip,
> +	xfs_ino_t		ino,
> +	uint16_t		mode,
> +	uint16_t		flags,
> +	uint64_t		flags2)
>  {
> -	xfs_failaddr_t			fa;
> +	xfs_failaddr_t		fa;
>  
>  	fa = xfs_inode_validate_cowextsize(sc->mp,
>  			be32_to_cpu(dip->di_cowextsize), mode, flags,
> @@ -119,12 +119,12 @@ xchk_inode_cowextsize(
>  STATIC void
>  xchk_inode_flags(
>  	struct xfs_scrub	*sc,
> -	struct xfs_dinode		*dip,
> -	xfs_ino_t			ino,
> -	uint16_t			mode,
> -	uint16_t			flags)
> +	struct xfs_dinode	*dip,
> +	xfs_ino_t		ino,
> +	uint16_t		mode,
> +	uint16_t		flags)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_mount	*mp = sc->mp;
>  
>  	if (flags & ~XFS_DIFLAG_ANY)
>  		goto bad;
> @@ -164,13 +164,13 @@ xchk_inode_flags(
>  STATIC void
>  xchk_inode_flags2(
>  	struct xfs_scrub	*sc,
> -	struct xfs_dinode		*dip,
> -	xfs_ino_t			ino,
> -	uint16_t			mode,
> -	uint16_t			flags,
> -	uint64_t			flags2)
> +	struct xfs_dinode	*dip,
> +	xfs_ino_t		ino,
> +	uint16_t		mode,
> +	uint16_t		flags,
> +	uint64_t		flags2)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_mount	*mp = sc->mp;
>  
>  	if (flags2 & ~XFS_DIFLAG2_ANY)
>  		goto bad;
> @@ -207,16 +207,16 @@ xchk_inode_flags2(
>  STATIC void
>  xchk_dinode(
>  	struct xfs_scrub	*sc,
> -	struct xfs_dinode		*dip,
> -	xfs_ino_t			ino)
> +	struct xfs_dinode	*dip,
> +	xfs_ino_t		ino)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	size_t				fork_recs;
> -	unsigned long long		isize;
> -	uint64_t			flags2;
> -	uint32_t			nextents;
> -	uint16_t			flags;
> -	uint16_t			mode;
> +	struct xfs_mount	*mp = sc->mp;
> +	size_t			fork_recs;
> +	unsigned long long	isize;
> +	uint64_t		flags2;
> +	uint32_t		nextents;
> +	uint16_t		flags;
> +	uint16_t		mode;
>  
>  	flags = be16_to_cpu(dip->di_flags);
>  	if (dip->di_version >= 3)
> @@ -426,7 +426,7 @@ xchk_dinode(
>   */
>  static void
>  xchk_inode_xref_finobt(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	xfs_ino_t			ino)
>  {
>  	struct xfs_inobt_rec_incore	rec;
> @@ -470,12 +470,12 @@ xchk_inode_xref_finobt(
>  STATIC void
>  xchk_inode_xref_bmap(
>  	struct xfs_scrub	*sc,
> -	struct xfs_dinode		*dip)
> +	struct xfs_dinode	*dip)
>  {
> -	xfs_extnum_t			nextents;
> -	xfs_filblks_t			count;
> -	xfs_filblks_t			acount;
> -	int				error;
> +	xfs_extnum_t		nextents;
> +	xfs_filblks_t		count;
> +	xfs_filblks_t		acount;
> +	int			error;
>  
>  	if (xchk_skip_xref(sc->sm))
>  		return;
> @@ -504,13 +504,13 @@ xchk_inode_xref_bmap(
>  STATIC void
>  xchk_inode_xref(
>  	struct xfs_scrub	*sc,
> -	xfs_ino_t			ino,
> -	struct xfs_dinode		*dip)
> +	xfs_ino_t		ino,
> +	struct xfs_dinode	*dip)
>  {
> -	struct xfs_owner_info		oinfo;
> -	xfs_agnumber_t			agno;
> -	xfs_agblock_t			agbno;
> -	int				error;
> +	struct xfs_owner_info	oinfo;
> +	xfs_agnumber_t		agno;
> +	xfs_agblock_t		agbno;
> +	int			error;
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return;
> @@ -541,11 +541,11 @@ xchk_inode_xref(
>  static void
>  xchk_inode_check_reflink_iflag(
>  	struct xfs_scrub	*sc,
> -	xfs_ino_t			ino)
> +	xfs_ino_t		ino)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	bool				has_shared;
> -	int				error;
> +	struct xfs_mount	*mp = sc->mp;
> +	bool			has_shared;
> +	int			error;
>  
>  	if (!xfs_sb_version_hasreflink(&mp->m_sb))
>  		return;
> @@ -566,8 +566,8 @@ int
>  xchk_inode(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_dinode		di;
> -	int				error = 0;
> +	struct xfs_dinode	di;
> +	int			error = 0;
>  
>  	/*
>  	 * If sc->ip is NULL, that means that the setup function called
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index 808459ad0c35..aacb0284c48a 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -29,7 +29,7 @@
>  int
>  xchk_setup_parent(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
>  	return xchk_setup_inode_contents(sc, ip, 0);
>  }
> @@ -39,22 +39,22 @@ xchk_setup_parent(
>  /* Look for an entry in a parent pointing to this inode. */
>  
>  struct xchk_parent_ctx {
> -	struct dir_context		dc;
> -	xfs_ino_t			ino;
> -	xfs_nlink_t			nlink;
> +	struct dir_context	dc;
> +	xfs_ino_t		ino;
> +	xfs_nlink_t		nlink;
>  };
>  
>  /* Look for a single entry in a directory pointing to an inode. */
>  STATIC int
>  xchk_parent_actor(
> -	struct dir_context		*dc,
> -	const char			*name,
> -	int				namelen,
> -	loff_t				pos,
> -	u64				ino,
> -	unsigned			type)
> +	struct dir_context	*dc,
> +	const char		*name,
> +	int			namelen,
> +	loff_t			pos,
> +	u64			ino,
> +	unsigned		type)
>  {
> -	struct xchk_parent_ctx		*spc;
> +	struct xchk_parent_ctx	*spc;
>  
>  	spc = container_of(dc, struct xchk_parent_ctx, dc);
>  	if (spc->ino == ino)
> @@ -66,19 +66,19 @@ xchk_parent_actor(
>  STATIC int
>  xchk_parent_count_parent_dentries(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*parent,
> -	xfs_nlink_t			*nlink)
> +	struct xfs_inode	*parent,
> +	xfs_nlink_t		*nlink)
>  {
> -	struct xchk_parent_ctx		spc = {
> +	struct xchk_parent_ctx	spc = {
>  		.dc.actor = xchk_parent_actor,
>  		.dc.pos = 0,
>  		.ino = sc->ip->i_ino,
>  		.nlink = 0,
>  	};
> -	size_t				bufsize;
> -	loff_t				oldpos;
> -	uint				lock_mode;
> -	int				error = 0;
> +	size_t			bufsize;
> +	loff_t			oldpos;
> +	uint			lock_mode;
> +	int			error = 0;
>  
>  	/*
>  	 * If there are any blocks, read-ahead block 0 as we're almost
> @@ -122,14 +122,14 @@ xchk_parent_count_parent_dentries(
>  STATIC int
>  xchk_parent_validate(
>  	struct xfs_scrub	*sc,
> -	xfs_ino_t			dnum,
> -	bool				*try_again)
> +	xfs_ino_t		dnum,
> +	bool			*try_again)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	struct xfs_inode		*dp = NULL;
> -	xfs_nlink_t			expected_nlink;
> -	xfs_nlink_t			nlink;
> -	int				error = 0;
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_inode	*dp = NULL;
> +	xfs_nlink_t		expected_nlink;
> +	xfs_nlink_t		nlink;
> +	int			error = 0;
>  
>  	*try_again = false;
>  
> @@ -257,11 +257,11 @@ int
>  xchk_parent(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_mount		*mp = sc->mp;
> -	xfs_ino_t			dnum;
> -	bool				try_again;
> -	int				tries = 0;
> -	int				error = 0;
> +	struct xfs_mount	*mp = sc->mp;
> +	xfs_ino_t		dnum;
> +	bool			try_again;
> +	int			tries = 0;
> +	int			error = 0;
>  
>  	/*
>  	 * If we're a directory, check that the '..' link points up to
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 309ebeecfa5d..782d582d3edd 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -49,10 +49,10 @@ xchk_quota_to_dqtype(
>  int
>  xchk_setup_quota(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
> -	uint				dqtype;
> -	int				error;
> +	uint			dqtype;
> +	int			error;
>  
>  	if (!XFS_IS_QUOTA_RUNNING(sc->mp) || !XFS_IS_QUOTA_ON(sc->mp))
>  		return -ENOENT;
> @@ -77,33 +77,33 @@ xchk_setup_quota(
>  
>  struct xchk_quota_info {
>  	struct xfs_scrub	*sc;
> -	xfs_dqid_t			last_id;
> +	xfs_dqid_t		last_id;
>  };
>  
>  /* Scrub the fields in an individual quota item. */
>  STATIC int
>  xchk_quota_item(
> -	struct xfs_dquot		*dq,
> -	uint				dqtype,
> -	void				*priv)
> +	struct xfs_dquot	*dq,
> +	uint			dqtype,
> +	void			*priv)
>  {
> -	struct xchk_quota_info		*sqi = priv;
> +	struct xchk_quota_info	*sqi = priv;
>  	struct xfs_scrub	*sc = sqi->sc;
> -	struct xfs_mount		*mp = sc->mp;
> -	struct xfs_disk_dquot		*d = &dq->q_core;
> -	struct xfs_quotainfo		*qi = mp->m_quotainfo;
> -	xfs_fileoff_t			offset;
> -	unsigned long long		bsoft;
> -	unsigned long long		isoft;
> -	unsigned long long		rsoft;
> -	unsigned long long		bhard;
> -	unsigned long long		ihard;
> -	unsigned long long		rhard;
> -	unsigned long long		bcount;
> -	unsigned long long		icount;
> -	unsigned long long		rcount;
> -	xfs_ino_t			fs_icount;
> -	xfs_dqid_t			id = be32_to_cpu(d->d_id);
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_disk_dquot	*d = &dq->q_core;
> +	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> +	xfs_fileoff_t		offset;
> +	unsigned long long	bsoft;
> +	unsigned long long	isoft;
> +	unsigned long long	rsoft;
> +	unsigned long long	bhard;
> +	unsigned long long	ihard;
> +	unsigned long long	rhard;
> +	unsigned long long	bcount;
> +	unsigned long long	icount;
> +	unsigned long long	rcount;
> +	xfs_ino_t		fs_icount;
> +	xfs_dqid_t		id = be32_to_cpu(d->d_id);
>  
>  	/*
>  	 * Except for the root dquot, the actual dquot we got must either have
> @@ -197,12 +197,12 @@ STATIC int
>  xchk_quota_data_fork(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_bmbt_irec		irec = { 0 };
> -	struct xfs_iext_cursor		icur;
> -	struct xfs_quotainfo		*qi = sc->mp->m_quotainfo;
> -	struct xfs_ifork		*ifp;
> -	xfs_fileoff_t			max_dqid_off;
> -	int				error = 0;
> +	struct xfs_bmbt_irec	irec = { 0 };
> +	struct xfs_iext_cursor	icur;
> +	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
> +	struct xfs_ifork	*ifp;
> +	xfs_fileoff_t		max_dqid_off;
> +	int			error = 0;
>  
>  	/* Invoke the fork scrubber. */
>  	error = xchk_metadata_inode_forks(sc);
> @@ -236,11 +236,11 @@ int
>  xchk_quota(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xchk_quota_info		sqi;
> -	struct xfs_mount		*mp = sc->mp;
> -	struct xfs_quotainfo		*qi = mp->m_quotainfo;
> -	uint				dqtype;
> -	int				error = 0;
> +	struct xchk_quota_info	sqi;
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> +	uint			dqtype;
> +	int			error = 0;
>  
>  	dqtype = xchk_quota_to_dqtype(sc);
>  
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index c1162d408987..e8c82b026083 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -30,7 +30,7 @@
>  int
>  xchk_setup_ag_refcountbt(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
>  	return xchk_setup_ag_btree(sc, ip, false);
>  }
> @@ -74,21 +74,21 @@ xchk_setup_ag_refcountbt(
>   * should always hold true.  If not, the refcount is incorrect.
>   */
>  struct xchk_refcnt_frag {
> -	struct list_head		list;
> -	struct xfs_rmap_irec		rm;
> +	struct list_head	list;
> +	struct xfs_rmap_irec	rm;
>  };
>  
>  struct xchk_refcnt_check {
>  	struct xfs_scrub	*sc;
> -	struct list_head		fragments;
> +	struct list_head	fragments;
>  
>  	/* refcount extent we're examining */
> -	xfs_agblock_t			bno;
> -	xfs_extlen_t			len;
> -	xfs_nlink_t			refcount;
> +	xfs_agblock_t		bno;
> +	xfs_extlen_t		len;
> +	xfs_nlink_t		refcount;
>  
>  	/* number of owners seen */
> -	xfs_nlink_t			seen;
> +	xfs_nlink_t		seen;
>  };
>  
>  /*
> @@ -278,7 +278,7 @@ xchk_refcountbt_process_rmap_fragments(
>  /* Use the rmap entries covering this extent to verify the refcount. */
>  STATIC void
>  xchk_refcountbt_xref_rmap(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	xfs_agblock_t			bno,
>  	xfs_extlen_t			len,
>  	xfs_nlink_t			refcount)
> @@ -326,9 +326,9 @@ xchk_refcountbt_xref_rmap(
>  STATIC void
>  xchk_refcountbt_xref(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			agbno,
> -	xfs_extlen_t			len,
> -	xfs_nlink_t			refcount)
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len,
> +	xfs_nlink_t		refcount)
>  {
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return;
> @@ -341,17 +341,17 @@ xchk_refcountbt_xref(
>  /* Scrub a refcountbt record. */
>  STATIC int
>  xchk_refcountbt_rec(
> -	struct xchk_btree		*bs,
> -	union xfs_btree_rec		*rec)
> +	struct xchk_btree	*bs,
> +	union xfs_btree_rec	*rec)
>  {
> -	struct xfs_mount		*mp = bs->cur->bc_mp;
> -	xfs_agblock_t			*cow_blocks = bs->private;
> -	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
> -	xfs_agblock_t			bno;
> -	xfs_extlen_t			len;
> -	xfs_nlink_t			refcount;
> -	bool				has_cowflag;
> -	int				error = 0;
> +	struct xfs_mount	*mp = bs->cur->bc_mp;
> +	xfs_agblock_t		*cow_blocks = bs->private;
> +	xfs_agnumber_t		agno = bs->cur->bc_private.a.agno;
> +	xfs_agblock_t		bno;
> +	xfs_extlen_t		len;
> +	xfs_nlink_t		refcount;
> +	bool			has_cowflag;
> +	int			error = 0;
>  
>  	bno = be32_to_cpu(rec->refc.rc_startblock);
>  	len = be32_to_cpu(rec->refc.rc_blockcount);
> @@ -383,12 +383,12 @@ xchk_refcountbt_rec(
>  STATIC void
>  xchk_refcount_xref_rmap(
>  	struct xfs_scrub	*sc,
> -	struct xfs_owner_info		*oinfo,
> -	xfs_filblks_t			cow_blocks)
> +	struct xfs_owner_info	*oinfo,
> +	xfs_filblks_t		cow_blocks)
>  {
> -	xfs_extlen_t			refcbt_blocks = 0;
> -	xfs_filblks_t			blocks;
> -	int				error;
> +	xfs_extlen_t		refcbt_blocks = 0;
> +	xfs_filblks_t		blocks;
> +	int			error;
>  
>  	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
>  		return;
> @@ -419,9 +419,9 @@ int
>  xchk_refcountbt(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_owner_info		oinfo;
> -	xfs_agblock_t			cow_blocks = 0;
> -	int				error;
> +	struct xfs_owner_info	oinfo;
> +	xfs_agblock_t		cow_blocks = 0;
> +	int			error;
>  
>  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
>  	error = xchk_btree(sc, sc->sa.refc_cur, xchk_refcountbt_rec,
> @@ -437,7 +437,7 @@ xchk_refcountbt(
>  /* xref check that a cow staging extent is marked in the refcountbt. */
>  void
>  xchk_xref_is_cow_staging(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	xfs_agblock_t			agbno,
>  	xfs_extlen_t			len)
>  {
> @@ -484,11 +484,11 @@ xchk_xref_is_cow_staging(
>  void
>  xchk_xref_is_not_shared(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			agbno,
> -	xfs_extlen_t			len)
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len)
>  {
> -	bool				shared;
> -	int				error;
> +	bool			shared;
> +	int			error;
>  
>  	if (!sc->sa.refc_cur || xchk_skip_xref(sc->sm))
>  		return;
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 29debd5649ac..5de1cac424ec 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -42,11 +42,11 @@
>   */
>  int
>  xrep_attempt(
> -	struct xfs_inode		*ip,
> +	struct xfs_inode	*ip,
>  	struct xfs_scrub	*sc,
> -	bool				*fixed)
> +	bool			*fixed)
>  {
> -	int				error = 0;
> +	int			error = 0;
>  
>  	trace_xrep_attempt(ip, sc->sm, error);
>  
> @@ -94,7 +94,7 @@ xrep_attempt(
>   */
>  void
>  xrep_failure(
> -	struct xfs_mount		*mp)
> +	struct xfs_mount	*mp)
>  {
>  	xfs_alert_ratelimited(mp,
>  "Corruption not fixed during online repair.  Unmount and run xfs_repair.");
> @@ -108,7 +108,7 @@ int
>  xrep_probe(
>  	struct xfs_scrub	*sc)
>  {
> -	int				error = 0;
> +	int			error = 0;
>  
>  	if (xchk_should_terminate(sc, &error))
>  		return error;
> @@ -124,7 +124,7 @@ int
>  xrep_roll_ag_trans(
>  	struct xfs_scrub	*sc)
>  {
> -	int				error;
> +	int			error;
>  
>  	/* Keep the AG header buffers locked so we can keep going. */
>  	xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
> @@ -163,9 +163,9 @@ xrep_roll_ag_trans(
>   */
>  bool
>  xrep_ag_has_space(
> -	struct xfs_perag		*pag,
> -	xfs_extlen_t			nr_blocks,
> -	enum xfs_ag_resv_type		type)
> +	struct xfs_perag	*pag,
> +	xfs_extlen_t		nr_blocks,
> +	enum xfs_ag_resv_type	type)
>  {
>  	return  !xfs_ag_resv_critical(pag, XFS_AG_RESV_RMAPBT) &&
>  		!xfs_ag_resv_critical(pag, XFS_AG_RESV_METADATA) &&
> @@ -179,7 +179,7 @@ xrep_ag_has_space(
>   */
>  xfs_extlen_t
>  xrep_calc_ag_resblks(
> -	struct xfs_scrub	*sc)
> +	struct xfs_scrub		*sc)
>  {
>  	struct xfs_mount		*mp = sc->mp;
>  	struct xfs_scrub_metadata	*sm = sc->sm;
> @@ -280,13 +280,13 @@ xrep_calc_ag_resblks(
>  int
>  xrep_alloc_ag_block(
>  	struct xfs_scrub	*sc,
> -	struct xfs_owner_info		*oinfo,
> -	xfs_fsblock_t			*fsbno,
> -	enum xfs_ag_resv_type		resv)
> +	struct xfs_owner_info	*oinfo,
> +	xfs_fsblock_t		*fsbno,
> +	enum xfs_ag_resv_type	resv)
>  {
> -	struct xfs_alloc_arg		args = {0};
> -	xfs_agblock_t			bno;
> -	int				error;
> +	struct xfs_alloc_arg	args = {0};
> +	xfs_agblock_t		bno;
> +	int			error;
>  
>  	switch (resv) {
>  	case XFS_AG_RESV_AGFL:
> @@ -330,7 +330,7 @@ xrep_alloc_ag_block(
>  /* Initialize a new AG btree root block with zero entries. */
>  int
>  xrep_init_btblock(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	xfs_fsblock_t			fsb,
>  	struct xfs_buf			**bpp,
>  	xfs_btnum_t			btnum,
> @@ -386,11 +386,11 @@ xrep_init_btblock(
>  int
>  xrep_collect_btree_extent(
>  	struct xfs_scrub	*sc,
> -	struct xrep_extent_list		*exlist,
> -	xfs_fsblock_t			fsbno,
> -	xfs_extlen_t			len)
> +	struct xrep_extent_list	*exlist,
> +	xfs_fsblock_t		fsbno,
> +	xfs_extlen_t		len)
>  {
> -	struct xrep_extent		*rex;
> +	struct xrep_extent	*rex;
>  
>  	trace_xrep_collect_btree_extent(sc->mp,
>  			XFS_FSB_TO_AGNO(sc->mp, fsbno),
> @@ -416,10 +416,10 @@ xrep_collect_btree_extent(
>  void
>  xrep_cancel_btree_extents(
>  	struct xfs_scrub	*sc,
> -	struct xrep_extent_list		*exlist)
> +	struct xrep_extent_list	*exlist)
>  {
> -	struct xrep_extent		*rex;
> -	struct xrep_extent		*n;
> +	struct xrep_extent	*rex;
> +	struct xrep_extent	*n;
>  
>  	for_each_xrep_extent_safe(rex, n, exlist) {
>  		list_del(&rex->list);
> @@ -430,12 +430,12 @@ xrep_cancel_btree_extents(
>  /* Compare two btree extents. */
>  static int
>  xrep_btree_extent_cmp(
> -	void				*priv,
> -	struct list_head		*a,
> -	struct list_head		*b)
> +	void			*priv,
> +	struct list_head	*a,
> +	struct list_head	*b)
>  {
> -	struct xrep_extent		*ap;
> -	struct xrep_extent		*bp;
> +	struct xrep_extent	*ap;
> +	struct xrep_extent	*bp;
>  
>  	ap = container_of(a, struct xrep_extent, list);
>  	bp = container_of(b, struct xrep_extent, list);
> @@ -464,17 +464,17 @@ xrep_btree_extent_cmp(
>  int
>  xrep_subtract_extents(
>  	struct xfs_scrub	*sc,
> -	struct xrep_extent_list		*exlist,
> -	struct xrep_extent_list		*sublist)
> +	struct xrep_extent_list	*exlist,
> +	struct xrep_extent_list	*sublist)
>  {
> -	struct list_head		*lp;
> -	struct xrep_extent		*ex;
> -	struct xrep_extent		*newex;
> -	struct xrep_extent		*subex;
> -	xfs_fsblock_t			sub_fsb;
> -	xfs_extlen_t			sub_len;
> -	int				state;
> -	int				error = 0;
> +	struct list_head	*lp;
> +	struct xrep_extent	*ex;
> +	struct xrep_extent	*newex;
> +	struct xrep_extent	*subex;
> +	xfs_fsblock_t		sub_fsb;
> +	xfs_extlen_t		sub_len;
> +	int			state;
> +	int			error = 0;
>  
>  	if (list_empty(&exlist->list) || list_empty(&sublist->list))
>  		return 0;
> @@ -621,13 +621,13 @@ xrep_subtract_extents(
>  int
>  xrep_invalidate_blocks(
>  	struct xfs_scrub	*sc,
> -	struct xrep_extent_list		*exlist)
> +	struct xrep_extent_list	*exlist)
>  {
> -	struct xrep_extent		*rex;
> -	struct xrep_extent		*n;
> -	struct xfs_buf			*bp;
> -	xfs_fsblock_t			fsbno;
> -	xfs_agblock_t			i;
> +	struct xrep_extent	*rex;
> +	struct xrep_extent	*n;
> +	struct xfs_buf		*bp;
> +	xfs_fsblock_t		fsbno;
> +	xfs_agblock_t		i;
>  
>  	/*
>  	 * For each block in each extent, see if there's an incore buffer for
> @@ -659,9 +659,9 @@ xrep_invalidate_blocks(
>  int
>  xrep_fix_freelist(
>  	struct xfs_scrub	*sc,
> -	bool				can_shrink)
> +	bool			can_shrink)
>  {
> -	struct xfs_alloc_arg		args = {0};
> +	struct xfs_alloc_arg	args = {0};
>  
>  	args.mp = sc->mp;
>  	args.tp = sc->tp;
> @@ -679,10 +679,10 @@ xrep_fix_freelist(
>  STATIC int
>  xrep_put_freelist(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			agbno)
> +	xfs_agblock_t		agbno)
>  {
> -	struct xfs_owner_info		oinfo;
> -	int				error;
> +	struct xfs_owner_info	oinfo;
> +	int			error;
>  
>  	/* Make sure there's space on the freelist. */
>  	error = xrep_fix_freelist(sc, true);
> @@ -715,16 +715,16 @@ xrep_put_freelist(
>  STATIC int
>  xrep_dispose_btree_block(
>  	struct xfs_scrub	*sc,
> -	xfs_fsblock_t			fsbno,
> -	struct xfs_owner_info		*oinfo,
> -	enum xfs_ag_resv_type		resv)
> +	xfs_fsblock_t		fsbno,
> +	struct xfs_owner_info	*oinfo,
> +	enum xfs_ag_resv_type	resv)
>  {
> -	struct xfs_btree_cur		*cur;
> -	struct xfs_buf			*agf_bp = NULL;
> -	xfs_agnumber_t			agno;
> -	xfs_agblock_t			agbno;
> -	bool				has_other_rmap;
> -	int				error;
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_buf		*agf_bp = NULL;
> +	xfs_agnumber_t		agno;
> +	xfs_agblock_t		agbno;
> +	bool			has_other_rmap;
> +	int			error;
>  
>  	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
>  	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
> @@ -789,13 +789,13 @@ xrep_dispose_btree_block(
>  int
>  xrep_reap_btree_extents(
>  	struct xfs_scrub	*sc,
> -	struct xrep_extent_list		*exlist,
> -	struct xfs_owner_info		*oinfo,
> -	enum xfs_ag_resv_type		type)
> +	struct xrep_extent_list	*exlist,
> +	struct xfs_owner_info	*oinfo,
> +	enum xfs_ag_resv_type	type)
>  {
> -	struct xrep_extent		*rex;
> -	struct xrep_extent		*n;
> -	int				error = 0;
> +	struct xrep_extent	*rex;
> +	struct xrep_extent	*n;
> +	int			error = 0;
>  
>  	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
>  
> @@ -851,7 +851,7 @@ xrep_reap_btree_extents(
>   */
>  
>  struct xrep_findroot {
> -	struct xfs_scrub	*sc;
> +	struct xfs_scrub		*sc;
>  	struct xfs_buf			*agfl_bp;
>  	struct xfs_agf			*agf;
>  	struct xrep_find_ag_btree	*btree_info;
> @@ -860,11 +860,11 @@ struct xrep_findroot {
>  /* See if our block is in the AGFL. */
>  STATIC int
>  xrep_findroot_agfl_walk(
> -	struct xfs_mount		*mp,
> -	xfs_agblock_t			bno,
> -	void				*priv)
> +	struct xfs_mount	*mp,
> +	xfs_agblock_t		bno,
> +	void			*priv)
>  {
> -	xfs_agblock_t			*agbno = priv;
> +	xfs_agblock_t		*agbno = priv;
>  
>  	return (*agbno == bno) ? XFS_BTREE_QUERY_RANGE_ABORT : 0;
>  }
> @@ -981,7 +981,7 @@ xrep_findroot_rmap(
>  /* Find the roots of the per-AG btrees described in btree_info. */
>  int
>  xrep_find_ag_btree_roots(
> -	struct xfs_scrub	*sc,
> +	struct xfs_scrub		*sc,
>  	struct xfs_buf			*agf_bp,
>  	struct xrep_find_ag_btree	*btree_info,
>  	struct xfs_buf			*agfl_bp)
> @@ -1017,9 +1017,9 @@ xrep_find_ag_btree_roots(
>  void
>  xrep_force_quotacheck(
>  	struct xfs_scrub	*sc,
> -	uint				dqtype)
> +	uint			dqtype)
>  {
> -	uint				flag;
> +	uint			flag;
>  
>  	flag = xfs_quota_chkd_flag(dqtype);
>  	if (!(flag & sc->mp->m_qflags))
> @@ -1046,7 +1046,7 @@ int
>  xrep_ino_dqattach(
>  	struct xfs_scrub	*sc)
>  {
> -	int				error;
> +	int			error;
>  
>  	error = xfs_qm_dqattach_locked(sc->ip, false);
>  	switch (error) {
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index 677f4b73b5ec..91355f6b0087 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -15,33 +15,31 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
>  
>  /* Repair helpers */
>  
> -int xrep_attempt(struct xfs_inode *ip, struct xfs_scrub *sc,
> -		bool *fixed);
> +int xrep_attempt(struct xfs_inode *ip, struct xfs_scrub *sc, bool *fixed);
>  void xrep_failure(struct xfs_mount *mp);
>  int xrep_roll_ag_trans(struct xfs_scrub *sc);
>  bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
>  		enum xfs_ag_resv_type type);
>  xfs_extlen_t xrep_calc_ag_resblks(struct xfs_scrub *sc);
> -int xrep_alloc_ag_block(struct xfs_scrub *sc,
> -		struct xfs_owner_info *oinfo, xfs_fsblock_t *fsbno,
> -		enum xfs_ag_resv_type resv);
> +int xrep_alloc_ag_block(struct xfs_scrub *sc, struct xfs_owner_info *oinfo,
> +		xfs_fsblock_t *fsbno, enum xfs_ag_resv_type resv);
>  int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
>  		struct xfs_buf **bpp, xfs_btnum_t btnum,
>  		const struct xfs_buf_ops *ops);
>  
>  struct xrep_extent {
> -	struct list_head		list;
> -	xfs_fsblock_t			fsbno;
> -	xfs_extlen_t			len;
> +	struct list_head	list;
> +	xfs_fsblock_t		fsbno;
> +	xfs_extlen_t		len;
>  };
>  
>  struct xrep_extent_list {
> -	struct list_head		list;
> +	struct list_head	list;
>  };
>  
>  static inline void
>  xrep_init_extent_list(
> -	struct xrep_extent_list		*exlist)
> +	struct xrep_extent_list	*exlist)
>  {
>  	INIT_LIST_HEAD(&exlist->list);
>  }
> @@ -78,10 +76,8 @@ struct xrep_find_ag_btree {
>  	unsigned int			height;
>  };
>  
> -int xrep_find_ag_btree_roots(struct xfs_scrub *sc,
> -		struct xfs_buf *agf_bp,
> -		struct xrep_find_ag_btree *btree_info,
> -		struct xfs_buf *agfl_bp);
> +int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
> +		struct xrep_find_ag_btree *btree_info, struct xfs_buf *agfl_bp);
>  void xrep_force_quotacheck(struct xfs_scrub *sc, uint dqtype);
>  int xrep_ino_dqattach(struct xfs_scrub *sc);
>  
> @@ -93,9 +89,9 @@ int xrep_superblock(struct xfs_scrub *sc);
>  #else
>  
>  static inline int xrep_attempt(
> -	struct xfs_inode		*ip,
> +	struct xfs_inode	*ip,
>  	struct xfs_scrub	*sc,
> -	bool				*fixed)
> +	bool			*fixed)
>  {
>  	return -EOPNOTSUPP;
>  }
> diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> index dc9c91a706ff..5e293c129813 100644
> --- a/fs/xfs/scrub/rmap.c
> +++ b/fs/xfs/scrub/rmap.c
> @@ -31,7 +31,7 @@
>  int
>  xchk_setup_ag_rmapbt(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
>  	return xchk_setup_ag_btree(sc, ip, false);
>  }
> @@ -42,15 +42,15 @@ xchk_setup_ag_rmapbt(
>  STATIC void
>  xchk_rmapbt_xref_refc(
>  	struct xfs_scrub	*sc,
> -	struct xfs_rmap_irec		*irec)
> +	struct xfs_rmap_irec	*irec)
>  {
> -	xfs_agblock_t			fbno;
> -	xfs_extlen_t			flen;
> -	bool				non_inode;
> -	bool				is_bmbt;
> -	bool				is_attr;
> -	bool				is_unwritten;
> -	int				error;
> +	xfs_agblock_t		fbno;
> +	xfs_extlen_t		flen;
> +	bool			non_inode;
> +	bool			is_bmbt;
> +	bool			is_attr;
> +	bool			is_unwritten;
> +	int			error;
>  
>  	if (!sc->sa.refc_cur || xchk_skip_xref(sc->sm))
>  		return;
> @@ -73,10 +73,10 @@ xchk_rmapbt_xref_refc(
>  STATIC void
>  xchk_rmapbt_xref(
>  	struct xfs_scrub	*sc,
> -	struct xfs_rmap_irec		*irec)
> +	struct xfs_rmap_irec	*irec)
>  {
> -	xfs_agblock_t			agbno = irec->rm_startblock;
> -	xfs_extlen_t			len = irec->rm_blockcount;
> +	xfs_agblock_t		agbno = irec->rm_startblock;
> +	xfs_extlen_t		len = irec->rm_blockcount;
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		return;
> @@ -96,17 +96,17 @@ xchk_rmapbt_xref(
>  /* Scrub an rmapbt record. */
>  STATIC int
>  xchk_rmapbt_rec(
> -	struct xchk_btree		*bs,
> -	union xfs_btree_rec		*rec)
> +	struct xchk_btree	*bs,
> +	union xfs_btree_rec	*rec)
>  {
> -	struct xfs_mount		*mp = bs->cur->bc_mp;
> -	struct xfs_rmap_irec		irec;
> -	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
> -	bool				non_inode;
> -	bool				is_unwritten;
> -	bool				is_bmbt;
> -	bool				is_attr;
> -	int				error;
> +	struct xfs_mount	*mp = bs->cur->bc_mp;
> +	struct xfs_rmap_irec	irec;
> +	xfs_agnumber_t		agno = bs->cur->bc_private.a.agno;
> +	bool			non_inode;
> +	bool			is_unwritten;
> +	bool			is_bmbt;
> +	bool			is_attr;
> +	int			error;
>  
>  	error = xfs_rmap_btrec_to_irec(rec, &irec);
>  	if (!xchk_btree_process_error(bs->sc, bs->cur, 0, &error))
> @@ -174,7 +174,7 @@ int
>  xchk_rmapbt(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_owner_info		oinfo;
> +	struct xfs_owner_info	oinfo;
>  
>  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
>  	return xchk_btree(sc, sc->sa.rmap_cur, xchk_rmapbt_rec,
> @@ -185,13 +185,13 @@ xchk_rmapbt(
>  static inline void
>  xchk_xref_check_owner(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			bno,
> -	xfs_extlen_t			len,
> -	struct xfs_owner_info		*oinfo,
> -	bool				should_have_rmap)
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	struct xfs_owner_info	*oinfo,
> +	bool			should_have_rmap)
>  {
> -	bool				has_rmap;
> -	int				error;
> +	bool			has_rmap;
> +	int			error;
>  
>  	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
>  		return;
> @@ -208,9 +208,9 @@ xchk_xref_check_owner(
>  void
>  xchk_xref_is_owned_by(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			bno,
> -	xfs_extlen_t			len,
> -	struct xfs_owner_info		*oinfo)
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	struct xfs_owner_info	*oinfo)
>  {
>  	xchk_xref_check_owner(sc, bno, len, oinfo, true);
>  }
> @@ -219,9 +219,9 @@ xchk_xref_is_owned_by(
>  void
>  xchk_xref_is_not_owned_by(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			bno,
> -	xfs_extlen_t			len,
> -	struct xfs_owner_info		*oinfo)
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	struct xfs_owner_info	*oinfo)
>  {
>  	xchk_xref_check_owner(sc, bno, len, oinfo, false);
>  }
> @@ -230,11 +230,11 @@ xchk_xref_is_not_owned_by(
>  void
>  xchk_xref_has_no_owner(
>  	struct xfs_scrub	*sc,
> -	xfs_agblock_t			bno,
> -	xfs_extlen_t			len)
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len)
>  {
> -	bool				has_rmap;
> -	int				error;
> +	bool			has_rmap;
> +	int			error;
>  
>  	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
>  		return;
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index 653a809bba34..665d4bbb17cc 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -27,9 +27,9 @@
>  int
>  xchk_setup_rt(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
> -	int				error;
> +	int			error;
>  
>  	error = xchk_setup_fs(sc, ip);
>  	if (error)
> @@ -47,13 +47,13 @@ xchk_setup_rt(
>  /* Scrub a free extent record from the realtime bitmap. */
>  STATIC int
>  xchk_rtbitmap_rec(
> -	struct xfs_trans		*tp,
> -	struct xfs_rtalloc_rec		*rec,
> -	void				*priv)
> +	struct xfs_trans	*tp,
> +	struct xfs_rtalloc_rec	*rec,
> +	void			*priv)
>  {
>  	struct xfs_scrub	*sc = priv;
> -	xfs_rtblock_t			startblock;
> -	xfs_rtblock_t			blockcount;
> +	xfs_rtblock_t		startblock;
> +	xfs_rtblock_t		blockcount;
>  
>  	startblock = rec->ar_startext * tp->t_mountp->m_sb.sb_rextsize;
>  	blockcount = rec->ar_extcount * tp->t_mountp->m_sb.sb_rextsize;
> @@ -70,7 +70,7 @@ int
>  xchk_rtbitmap(
>  	struct xfs_scrub	*sc)
>  {
> -	int				error;
> +	int			error;
>  
>  	/* Invoke the fork scrubber. */
>  	error = xchk_metadata_inode_forks(sc);
> @@ -90,10 +90,10 @@ int
>  xchk_rtsummary(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_inode		*rsumip = sc->mp->m_rsumip;
> -	struct xfs_inode		*old_ip = sc->ip;
> -	uint				old_ilock_flags = sc->ilock_flags;
> -	int				error = 0;
> +	struct xfs_inode	*rsumip = sc->mp->m_rsumip;
> +	struct xfs_inode	*old_ip = sc->ip;
> +	uint			old_ilock_flags = sc->ilock_flags;
> +	int			error = 0;
>  
>  	/*
>  	 * We ILOCK'd the rt bitmap ip in the setup routine, now lock the
> @@ -126,14 +126,14 @@ xchk_rtsummary(
>  void
>  xchk_xref_is_used_rt_space(
>  	struct xfs_scrub	*sc,
> -	xfs_rtblock_t			fsbno,
> -	xfs_extlen_t			len)
> +	xfs_rtblock_t		fsbno,
> +	xfs_extlen_t		len)
>  {
> -	xfs_rtblock_t			startext;
> -	xfs_rtblock_t			endext;
> -	xfs_rtblock_t			extcount;
> -	bool				is_free;
> -	int				error;
> +	xfs_rtblock_t		startext;
> +	xfs_rtblock_t		endext;
> +	xfs_rtblock_t		extcount;
> +	bool			is_free;
> +	int			error;
>  
>  	if (xchk_skip_xref(sc->sm))
>  		return;
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index b3c6420ccae5..5956b8073e2f 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -153,7 +153,7 @@ static int
>  xchk_probe(
>  	struct xfs_scrub	*sc)
>  {
> -	int				error = 0;
> +	int			error = 0;
>  
>  	if (xchk_should_terminate(sc, &error))
>  		return error;
> @@ -167,8 +167,8 @@ xchk_probe(
>  STATIC int
>  xchk_teardown(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip_in,
> -	int				error)
> +	struct xfs_inode	*ip_in,
> +	int			error)
>  {
>  	xchk_ag_free(sc, &sc->sa);
>  	if (sc->tp) {
> @@ -479,7 +479,7 @@ xfs_scrub_metadata(
>  	struct xfs_inode		*ip,
>  	struct xfs_scrub_metadata	*sm)
>  {
> -	struct xfs_scrub	sc;
> +	struct xfs_scrub		sc;
>  	struct xfs_mount		*mp = ip->i_mount;
>  	bool				try_harder = false;
>  	bool				already_fixed = false;
> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> index 47c75d2f28da..af323b229c4b 100644
> --- a/fs/xfs/scrub/scrub.h
> +++ b/fs/xfs/scrub/scrub.h
> @@ -36,21 +36,21 @@ struct xchk_meta_ops {
>  
>  /* Buffer pointers and btree cursors for an entire AG. */
>  struct xchk_ag {
> -	xfs_agnumber_t			agno;
> -	struct xfs_perag		*pag;
> +	xfs_agnumber_t		agno;
> +	struct xfs_perag	*pag;
>  
>  	/* AG btree roots */
> -	struct xfs_buf			*agf_bp;
> -	struct xfs_buf			*agfl_bp;
> -	struct xfs_buf			*agi_bp;
> +	struct xfs_buf		*agf_bp;
> +	struct xfs_buf		*agfl_bp;
> +	struct xfs_buf		*agi_bp;
>  
>  	/* AG btrees */
> -	struct xfs_btree_cur		*bno_cur;
> -	struct xfs_btree_cur		*cnt_cur;
> -	struct xfs_btree_cur		*ino_cur;
> -	struct xfs_btree_cur		*fino_cur;
> -	struct xfs_btree_cur		*rmap_cur;
> -	struct xfs_btree_cur		*refc_cur;
> +	struct xfs_btree_cur	*bno_cur;
> +	struct xfs_btree_cur	*cnt_cur;
> +	struct xfs_btree_cur	*ino_cur;
> +	struct xfs_btree_cur	*fino_cur;
> +	struct xfs_btree_cur	*rmap_cur;
> +	struct xfs_btree_cur	*refc_cur;
>  };
>  
>  struct xfs_scrub {
> @@ -66,7 +66,7 @@ struct xfs_scrub {
>  	bool				has_quotaofflock;
>  
>  	/* State tracking for single-AG operations. */
> -	struct xchk_ag		sa;
> +	struct xchk_ag			sa;
>  };
>  
>  /* Metadata scrubbers */
> @@ -115,27 +115,25 @@ xchk_quota(struct xfs_scrub *sc)
>  #endif
>  
>  /* cross-referencing helpers */
> -void xchk_xref_is_used_space(struct xfs_scrub *sc,
> -		xfs_agblock_t agbno, xfs_extlen_t len);
> -void xchk_xref_is_not_inode_chunk(struct xfs_scrub *sc,
> -		xfs_agblock_t agbno, xfs_extlen_t len);
> -void xchk_xref_is_inode_chunk(struct xfs_scrub *sc,
> -		xfs_agblock_t agbno, xfs_extlen_t len);
> -void xchk_xref_is_owned_by(struct xfs_scrub *sc,
> -		xfs_agblock_t agbno, xfs_extlen_t len,
> -		struct xfs_owner_info *oinfo);
> -void xchk_xref_is_not_owned_by(struct xfs_scrub *sc,
> -		xfs_agblock_t agbno, xfs_extlen_t len,
> -		struct xfs_owner_info *oinfo);
> -void xchk_xref_has_no_owner(struct xfs_scrub *sc,
> -		xfs_agblock_t agbno, xfs_extlen_t len);
> -void xchk_xref_is_cow_staging(struct xfs_scrub *sc,
> -		xfs_agblock_t bno, xfs_extlen_t len);
> -void xchk_xref_is_not_shared(struct xfs_scrub *sc,
> -		xfs_agblock_t bno, xfs_extlen_t len);
> +void xchk_xref_is_used_space(struct xfs_scrub *sc, xfs_agblock_t agbno,
> +		xfs_extlen_t len);
> +void xchk_xref_is_not_inode_chunk(struct xfs_scrub *sc, xfs_agblock_t agbno,
> +		xfs_extlen_t len);
> +void xchk_xref_is_inode_chunk(struct xfs_scrub *sc, xfs_agblock_t agbno,
> +		xfs_extlen_t len);
> +void xchk_xref_is_owned_by(struct xfs_scrub *sc, xfs_agblock_t agbno,
> +		xfs_extlen_t len, struct xfs_owner_info *oinfo);
> +void xchk_xref_is_not_owned_by(struct xfs_scrub *sc, xfs_agblock_t agbno,
> +		xfs_extlen_t len, struct xfs_owner_info *oinfo);
> +void xchk_xref_has_no_owner(struct xfs_scrub *sc, xfs_agblock_t agbno,
> +		xfs_extlen_t len);
> +void xchk_xref_is_cow_staging(struct xfs_scrub *sc, xfs_agblock_t bno,
> +		xfs_extlen_t len);
> +void xchk_xref_is_not_shared(struct xfs_scrub *sc, xfs_agblock_t bno,
> +		xfs_extlen_t len);
>  #ifdef CONFIG_XFS_RT
> -void xchk_xref_is_used_rt_space(struct xfs_scrub *sc,
> -		xfs_rtblock_t rtbno, xfs_extlen_t len);
> +void xchk_xref_is_used_rt_space(struct xfs_scrub *sc, xfs_rtblock_t rtbno,
> +		xfs_extlen_t len);
>  #else
>  # define xchk_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
>  #endif
> diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
> index 56c6347e9482..f7ebaa946999 100644
> --- a/fs/xfs/scrub/symlink.c
> +++ b/fs/xfs/scrub/symlink.c
> @@ -27,7 +27,7 @@
>  int
>  xchk_setup_symlink(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode		*ip)
> +	struct xfs_inode	*ip)
>  {
>  	/* Allocate the buffer without the inode lock held. */
>  	sc->buf = kmem_zalloc_large(XFS_SYMLINK_MAXLEN + 1, KM_SLEEP);
> @@ -43,10 +43,10 @@ int
>  xchk_symlink(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_inode		*ip = sc->ip;
> -	struct xfs_ifork		*ifp;
> -	loff_t				len;
> -	int				error = 0;
> +	struct xfs_inode	*ip = sc->ip;
> +	struct xfs_ifork	*ifp;
> +	loff_t			len;
> +	int			error = 0;
>  
>  	if (!S_ISLNK(VFS_I(ip)->i_mode))
>  		return -ENOENT;
> diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> index 1ef1202a1e45..96feaf8dcdec 100644
> --- a/fs/xfs/scrub/trace.c
> +++ b/fs/xfs/scrub/trace.c
> @@ -23,8 +23,8 @@
>  /* Figure out which block the btree cursor was pointing to. */
>  static inline xfs_fsblock_t
>  xchk_btree_cur_fsbno(
> -	struct xfs_btree_cur		*cur,
> -	int				level)
> +	struct xfs_btree_cur	*cur,
> +	int			level)
>  {
>  	if (level < cur->bc_nlevels && cur->bc_bufs[level])
>  		return XFS_DADDR_TO_FSB(cur->bc_mp, cur->bc_bufs[level]->b_bn);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
