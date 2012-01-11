Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BBU9DP160759 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 05:30:09 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Q3QuDuukPOE5QL8w for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 03:30:04 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RkwNY-0003iw-A3
	for xfs@oss.sgi.com; Wed, 11 Jan 2012 11:30:04 +0000
Date: Wed, 11 Jan 2012 06:30:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/12] repair: mark local functions static
Message-ID: <20120111113004.GB10932@infradead.org>
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174743.292463733@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111202174743.292463733@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

ping?

On Fri, Dec 02, 2011 at 12:46:29PM -0500, Christoph Hellwig wrote:
> Also remove unused function, remove useless ARGSUSED annotations and
> similar tiny cleanups.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/repair/agheader.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/agheader.c	2011-12-01 16:17:07.000000000 +0000
> +++ xfsprogs-dev/repair/agheader.c	2011-12-01 16:18:23.000000000 +0000
> @@ -22,7 +22,7 @@
>  #include "protos.h"
>  #include "err_protos.h"
>  
> -int
> +static int
>  verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
>  {
>  	xfs_drfsbno_t agblocks;
> @@ -107,7 +107,7 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_
>  	return(retval);
>  }
>  
> -int
> +static int
>  verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
>  {
>  	xfs_drfsbno_t agblocks;
> @@ -177,14 +177,13 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_
>   *			filesystem mount-point superblock
>   *
>   * the verified fields include id and geometry.
> -
> + *
>   * the inprogress fields, version numbers, and counters
>   * are allowed to differ as well as all fields after the
>   * counters to cope with the pre-6.5 mkfs non-zeroed
>   * secondary superblock sectors.
>   */
> -
> -int
> +static int
>  compare_sb(xfs_mount_t *mp, xfs_sb_t *sb)
>  {
>  	fs_geometry_t fs_geo, sb_geo;
> @@ -213,7 +212,7 @@ compare_sb(xfs_mount_t *mp, xfs_sb_t *sb
>   * Note: contrary to the name, this routine is called for all
>   * superblocks, not just the secondary superblocks.
>   */
> -int
> +static int
>  secondary_sb_wack(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
>  	xfs_agnumber_t i)
>  {
> Index: xfsprogs-dev/repair/attr_repair.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/attr_repair.c	2011-12-01 16:17:07.000000000 +0000
> +++ xfsprogs-dev/repair/attr_repair.c	2011-12-01 16:18:23.000000000 +0000
> @@ -80,8 +80,7 @@ static int xfs_mac_valid(xfs_mac_label_t
>   * in user attribute land without a conflict.
>   * If value is non-zero, then a remote attribute is being passed in
>   */
> -
> -int
> +static int
>  valuecheck(char *namevalue, char *value, int namelen, int valuelen)
>  {
>  	/* for proper alignment issues, get the structs and memmove the values */
> @@ -146,7 +145,7 @@ valuecheck(char *namevalue, char *value,
>   * if you cannot modify the structures. repair is set to 1, if anything
>   * was fixed.
>   */
> -int
> +static int
>  process_shortform_attr(
>  	xfs_ino_t	ino,
>  	xfs_dinode_t	*dip,
> @@ -490,7 +489,7 @@ bad_free_out:
>  	return -1;
>  }
>  
> -int
> +static int
>  process_leaf_attr_block(
>  	xfs_mount_t	*mp,
>  	xfs_attr_leafblock_t *leaf,
> @@ -643,7 +642,7 @@ process_leaf_attr_block(
>  /*
>   * returns 0 if the attribute fork is ok, 1 if it has to be junked.
>   */
> -int
> +static int
>  process_leaf_attr_level(xfs_mount_t	*mp,
>  			da_bt_cursor_t	*da_cursor)
>  {
> @@ -775,7 +774,7 @@ error_out:
>   * returns 0 if things are ok, 1 if bad
>   * Note this code has been based off process_node_dir.
>   */
> -int
> +static int
>  process_node_attr(
>  	xfs_mount_t	*mp,
>  	xfs_ino_t	ino,
> @@ -825,8 +824,7 @@ process_node_attr(
>   * returns 0 if things are ok, 1 if bad (attributes needs to be junked)
>   * repair is set, if anything was changed, but attributes can live thru it
>   */
> -
> -int
> +static int
>  process_longform_attr(
>  	xfs_mount_t	*mp,
>  	xfs_ino_t	ino,
> Index: xfsprogs-dev/repair/dino_chunks.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/dino_chunks.c	2011-12-01 16:18:23.000000000 +0000
> +++ xfsprogs-dev/repair/dino_chunks.c	2011-12-01 16:18:23.000000000 +0000
> @@ -34,8 +34,7 @@
>   * the dinodes are verified using verify_uncertain_dinode() which
>   * means only the basic inode info is checked, no fork checks.
>   */
> -
> -int
> +static int
>  check_aginode_block(xfs_mount_t	*mp,
>  			xfs_agnumber_t	agno,
>  			xfs_agblock_t	agbno)
> @@ -85,7 +84,7 @@ check_aginode_block(xfs_mount_t	*mp,
>   * routines called by check_uncertain_aginodes() and
>   * process_uncertain_aginodes().
>   */
> -int
> +static int
>  verify_inode_chunk(xfs_mount_t		*mp,
>  			xfs_ino_t	ino,
>  			xfs_ino_t	*start_ino)
> @@ -513,7 +512,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
>  /*
>   * same as above only for ag inode chunks
>   */
> -int
> +static int
>  verify_aginode_chunk(xfs_mount_t	*mp,
>  			xfs_agnumber_t	agno,
>  			xfs_agino_t	agino,
> @@ -536,7 +535,7 @@ verify_aginode_chunk(xfs_mount_t	*mp,
>   * this does the same as the two above only it returns a pointer
>   * to the inode record in the good inode tree
>   */
> -ino_tree_node_t *
> +static ino_tree_node_t *
>  verify_aginode_chunk_irec(xfs_mount_t	*mp,
>  			xfs_agnumber_t	agno,
>  			xfs_agino_t	agino)
> Index: xfsprogs-dev/repair/dinode.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/dinode.c	2011-12-01 16:17:32.000000000 +0000
> +++ xfsprogs-dev/repair/dinode.c	2011-12-01 16:18:23.000000000 +0000
> @@ -36,47 +36,7 @@
>   * inode clearing routines
>   */
>  
> -/*
> - * return the offset into the inode where the attribute fork starts
> - */
> -/* ARGSUSED */
> -int
> -calc_attr_offset(xfs_mount_t *mp, xfs_dinode_t *dino)
> -{
> -	int	offset = (__psint_t)XFS_DFORK_DPTR(dino) - (__psint_t)dino;
> -	xfs_bmdr_block_t        *dfp;
> -
> -	/*
> -	 * don't worry about alignment when calculating offset
> -	 * because the data fork is already 8-byte aligned
> -	 */
> -	switch (dino->di_format)  {
> -	case XFS_DINODE_FMT_DEV:
> -		offset += sizeof(xfs_dev_t);
> -		break;
> -	case XFS_DINODE_FMT_LOCAL:
> -		offset += be64_to_cpu(dino->di_size);
> -		break;
> -	case XFS_DINODE_FMT_EXTENTS:
> -		offset += be32_to_cpu(dino->di_nextents) *
> -						sizeof(xfs_bmbt_rec_t);
> -		break;
> -	case XFS_DINODE_FMT_BTREE:
> -		dfp = (xfs_bmdr_block_t *)XFS_DFORK_DPTR(dino);
> -		offset += be16_to_cpu(dfp->bb_numrecs) *
> -						sizeof(xfs_bmbt_rec_t);
> -		break;
> -	default:
> -		do_error(_("Unknown inode format.\n"));
> -		abort();
> -		break;
> -	}
> -
> -	return(offset);
> -}
> -
> -/* ARGSUSED */
> -int
> +static int
>  clear_dinode_attr(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
>  {
>  	ASSERT(dino->di_forkoff != 0);
> @@ -125,8 +85,7 @@ _("would have cleared inode %" PRIu64 "
>  	return(1);
>  }
>  
> -/* ARGSUSED */
> -int
> +static int
>  clear_dinode_core(xfs_dinode_t *dinoc, xfs_ino_t ino_num)
>  {
>  	int dirty = 0;
> @@ -262,8 +221,7 @@ clear_dinode_core(xfs_dinode_t *dinoc, x
>  	return(dirty);
>  }
>  
> -/* ARGSUSED */
> -int
> +static int
>  clear_dinode_unlinked(xfs_mount_t *mp, xfs_dinode_t *dino)
>  {
>  
> @@ -281,7 +239,7 @@ clear_dinode_unlinked(xfs_mount_t *mp, x
>   * until after the agi unlinked lists are walked in phase 3.
>   * returns > zero if the inode has been altered while being cleared
>   */
> -int
> +static int
>  clear_dinode(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
>  {
>  	int dirty;
> @@ -445,31 +403,6 @@ verify_agbno(xfs_mount_t	*mp,
>  	return verify_ag_bno(sbp, agno, agbno) == 0;
>  }
>  
> -/*
> - * return address of block fblock if it's within the range described
> - * by the extent list.  Otherwise, returns a null address.
> - */
> -/* ARGSUSED */
> -xfs_dfsbno_t
> -get_bmbt_reclist(
> -	xfs_mount_t		*mp,
> -	xfs_bmbt_rec_t		*rp,
> -	int			numrecs,
> -	xfs_dfiloff_t		fblock)
> -{
> -	int			i;
> -	xfs_bmbt_irec_t 	irec;
> -
> -	for (i = 0; i < numrecs; i++) {
> -		libxfs_bmbt_disk_get_all(rp + i, &irec);
> -		if (irec.br_startoff >= fblock &&
> -				irec.br_startoff + irec.br_blockcount < fblock)
> -			return (irec.br_startblock + fblock - irec.br_startoff);
> -	}
> -	return(NULLDFSBNO);
> -}
> -
> -
>  static int
>  process_rt_rec(
>  	xfs_mount_t		*mp,
> @@ -601,8 +534,7 @@ _("illegal state %d in rt block map %" P
>   * file overlaps with any duplicate extents (in the
>   * duplicate extent list).
>   */
> -/* ARGSUSED */
> -int
> +static int
>  process_bmbt_reclist_int(
>  	xfs_mount_t		*mp,
>  	xfs_bmbt_rec_t		*rp,
> @@ -931,7 +863,7 @@ get_agino_buf(xfs_mount_t	 *mp,
>   *
>   * NOTE: getfunc_extlist only used by dirv1 checking code
>   */
> -xfs_dfsbno_t
> +static xfs_dfsbno_t
>  getfunc_extlist(xfs_mount_t		*mp,
>  		xfs_ino_t		ino,
>  		xfs_dinode_t		*dip,
> @@ -960,7 +892,7 @@ getfunc_extlist(xfs_mount_t		*mp,
>  /*
>   * NOTE: getfunc_btree only used by dirv1 checking code... 
>   */
> -xfs_dfsbno_t
> +static xfs_dfsbno_t
>  getfunc_btree(xfs_mount_t		*mp,
>  		xfs_ino_t		ino,
>  		xfs_dinode_t		*dip,
> @@ -1168,8 +1100,7 @@ get_bmapi(xfs_mount_t *mp, xfs_dinode_t
>  /*
>   * return 1 if inode should be cleared, 0 otherwise
>   */
> -/* ARGSUSED */
> -int
> +static int
>  process_btinode(
>  	xfs_mount_t		*mp,
>  	xfs_agnumber_t		agno,
> @@ -1344,8 +1275,7 @@ _("bad numrecs 0 in inode %" PRIu64 " bm
>  /*
>   * return 1 if inode should be cleared, 0 otherwise
>   */
> -/* ARGSUSED */
> -int
> +static int
>  process_exinode(
>  	xfs_mount_t		*mp,
>  	xfs_agnumber_t		agno,
> @@ -1431,7 +1361,7 @@ process_lclinode(
>  	return(0);
>  }
>  
> -int
> +static int
>  process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
>  {
>  	xfs_dfiloff_t		expected_offset;
> @@ -1502,7 +1432,7 @@ _("bad extent #%d count (%" PRIu64 ") in
>   * takes a name and length and returns 1 if the name contains
>   * a \0, returns 0 otherwise
>   */
> -int
> +static int
>  null_check(char *name, int length)
>  {
>  	int i;
> @@ -1521,7 +1451,7 @@ null_check(char *name, int length)
>   * like usual, returns 0 if everything's ok and 1 if something's
>   * bogus
>   */
> -int
> +static int
>  process_symlink(
>  	xfs_mount_t	*mp,
>  	xfs_ino_t	lino,
> @@ -2459,8 +2389,7 @@ _("would clear obsolete nlink field in v
>   *
>   * for detailed, info, look at process_dinode() comments.
>   */
> -/* ARGSUSED */
> -int
> +static int
>  process_dinode_int(xfs_mount_t *mp,
>  		xfs_dinode_t *dino,
>  		xfs_agnumber_t agno,
> Index: xfsprogs-dev/repair/dinode.h
> ===================================================================
> --- xfsprogs-dev.orig/repair/dinode.h	2011-12-01 16:17:32.000000000 +0000
> +++ xfsprogs-dev/repair/dinode.h	2011-12-01 16:18:23.000000000 +0000
> @@ -61,19 +61,6 @@ scan_bmbt_reclist(
>  	xfs_drfsbno_t		*tot,
>  	int			whichfork);
>  
> -int
> -verify_inode_chunk(xfs_mount_t		*mp,
> -			xfs_ino_t	ino,
> -			xfs_ino_t	*start_ino);
> -
> -int	verify_aginode_chunk(xfs_mount_t	*mp,
> -				xfs_agnumber_t	agno,
> -				xfs_agino_t	agino,
> -				xfs_agino_t	*agino_start);
> -
> -int
> -clear_dinode(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num);
> -
>  void
>  update_rootino(xfs_mount_t *mp);
>  
> Index: xfsprogs-dev/repair/dir.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/dir.c	2011-12-01 16:17:07.000000000 +0000
> +++ xfsprogs-dev/repair/dir.c	2011-12-01 16:18:23.000000000 +0000
> @@ -72,8 +72,7 @@ namecheck(char *name, int length)
>   * entries.  a non-zero return value means the directory is bogus
>   * and should be blasted.
>   */
> -/* ARGSUSED */
> -int
> +static int
>  process_shortform_dir(
>  	xfs_mount_t	*mp,
>  	xfs_ino_t	ino,
> @@ -553,7 +552,7 @@ set_da_freemap(xfs_mount_t *mp, da_freem
>   * returns 0 if holemap is consistent with reality (as expressed by
>   * the da_freemap_t).  returns 1 if there's a conflict.
>   */
> -int
> +static int
>  verify_da_freemap(xfs_mount_t *mp, da_freemap_t *map, da_hole_map_t *holes,
>  			xfs_ino_t ino, xfs_dablk_t da_bno)
>  {
> @@ -591,7 +590,7 @@ verify_da_freemap(xfs_mount_t *mp, da_fr
>  	return(0);
>  }
>  
> -void
> +static void
>  process_da_freemap(xfs_mount_t *mp, da_freemap_t *map, da_hole_map_t *holes)
>  {
>  	int i, j, in_hole, start, length, smallest, num_holes;
> @@ -678,8 +677,7 @@ process_da_freemap(xfs_mount_t *mp, da_f
>  /*
>   * returns 1 if the hole info doesn't match, 0 if it does
>   */
> -/* ARGSUSED */
> -int
> +static int
>  compare_da_freemaps(xfs_mount_t *mp, da_hole_map_t *holemap,
>  			da_hole_map_t *block_hmap, int entries,
>  			xfs_ino_t ino, xfs_dablk_t da_bno)
> @@ -879,7 +877,7 @@ error_out:
>   * buffers (e.g. if we do, it's a mistake).  if error == 1, we're
>   * in an error-handling case so unreleased buffers may exist.
>   */
> -void
> +static void
>  release_da_cursor_int(xfs_mount_t	*mp,
>  			da_bt_cursor_t	*cursor,
>  			int		prev_level,
> @@ -922,91 +920,6 @@ err_release_da_cursor(xfs_mount_t	*mp,
>  }
>  
>  /*
> - * like traverse_int_dablock only it does far less checking
> - * and doesn't maintain the cursor.  Just gets you to the
> - * leftmost block in the directory.  returns the fsbno
> - * of that block if successful, NULLDFSBNO if not.
> - */
> -xfs_dfsbno_t
> -get_first_dblock_fsbno(xfs_mount_t	*mp,
> -			xfs_ino_t	ino,
> -			xfs_dinode_t	*dino)
> -{
> -	xfs_dablk_t		bno;
> -	int			i;
> -	xfs_da_intnode_t	*node;
> -	xfs_dfsbno_t		fsbno;
> -	xfs_buf_t		*bp;
> -
> -	/*
> -	 * traverse down left-side of tree until we hit the
> -	 * left-most leaf block setting up the btree cursor along
> -	 * the way.
> -	 */
> -	bno = 0;
> -	i = -1;
> -	node = NULL;
> -
> -	fsbno = get_bmapi(mp, dino, ino, bno, XFS_DATA_FORK);
> -
> -	if (fsbno == NULLDFSBNO)  {
> -		do_warn(_("bmap of block #%u of inode %" PRIu64 " failed\n"),
> -			bno, ino);
> -		return(fsbno);
> -	}
> -
> -	if (be64_to_cpu(dino->di_size) <= XFS_LBSIZE(mp))
> -		return(fsbno);
> -
> -	do {
> -		/*
> -		 * walk down left side of btree, release buffers as you
> -		 * go.  if the root block is a leaf (single-level btree),
> -		 * just return it.
> -		 *
> -		 */
> -
> -		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
> -				XFS_FSB_TO_BB(mp, 1), 0);
> -		if (!bp) {
> -			do_warn(
> -	_("can't read block %u (fsbno %" PRIu64 ") for directory inode %" PRIu64 "\n"),
> -				bno, fsbno, ino);
> -			return(NULLDFSBNO);
> -		}
> -
> -		node = (xfs_da_intnode_t *)XFS_BUF_PTR(bp);
> -
> -		if (XFS_DA_NODE_MAGIC !=
> -		    be16_to_cpu(node->hdr.info.magic))  {
> -			do_warn(
> -	_("bad dir/attr magic number in inode %" PRIu64 ", file bno = %u, fsbno = %" PRIu64 "\n"),
> -				ino, bno, fsbno);
> -			libxfs_putbuf(bp);
> -			return(NULLDFSBNO);
> -		}
> -
> -		if (i == -1)
> -			i = be16_to_cpu(node->hdr.level);
> -		bno = be32_to_cpu(node->btree[0].before);
> -
> -		libxfs_putbuf(bp);
> -
> -		fsbno = get_bmapi(mp, dino, ino, bno, XFS_DATA_FORK);
> -
> -		if (fsbno == NULLDFSBNO)  {
> -			do_warn(_("bmap of block #%u of inode %" PRIu64 " failed\n"),
> -				bno, ino);
> -			return(NULLDFSBNO);
> -		}
> -
> -		i--;
> -	} while(i > 0);
> -
> -	return(fsbno);
> -}
> -
> -/*
>   * make sure that all entries in all blocks along the right side of
>   * of the tree are used and hashval's are consistent.  level is the
>   * level of the descendent block.  returns 0 if good (even if it had
> @@ -1401,8 +1314,7 @@ size_t ts_dirbuf_size = 64*1024;
>   * bad entry name index pointers), we lose the directory.  We could
>   * try harder to fix this but it'll do for now.
>   */
> -/* ARGSUSED */
> -int
> +static int
>  process_leaf_dir_block(
>  	xfs_mount_t		*mp,
>  	xfs_dir_leafblock_t	*leaf,
> @@ -2311,7 +2223,7 @@ _("- existing hole info for block %d, di
>  /*
>   * returns 0 if the directory is ok, 1 if it has to be junked.
>   */
> -int
> +static int
>  process_leaf_dir_level(xfs_mount_t	*mp,
>  			da_bt_cursor_t	*da_cursor,
>  			int		ino_discovery,
> @@ -2489,8 +2401,7 @@ error_out:
>   *
>   * returns 0 if things are ok, 1 if bad (directory needs to be junked)
>   */
> -/* ARGSUSED */
> -int
> +static int
>  process_node_dir(
>  	xfs_mount_t	*mp,
>  	xfs_ino_t	ino,
> @@ -2588,8 +2499,7 @@ _("setting directory inode (%" PRIu64 ")
>   *
>   * returns 0 if things are ok, 1 if bad (directory needs to be junked)
>   */
> -/* ARGSUSED */
> -int
> +static int
>  process_leaf_dir(
>  	xfs_mount_t	*mp,
>  	xfs_ino_t	ino,
> Index: xfsprogs-dev/repair/dir.h
> ===================================================================
> --- xfsprogs-dev.orig/repair/dir.h	2011-12-01 16:17:07.000000000 +0000
> +++ xfsprogs-dev/repair/dir.h	2011-12-01 16:18:23.000000000 +0000
> @@ -75,12 +75,6 @@ err_release_da_cursor(
>  	da_bt_cursor_t	*cursor,
>  	int		prev_level);
>  
> -xfs_dfsbno_t
> -get_first_dblock_fsbno(
> -	xfs_mount_t	*mp,
> -	xfs_ino_t	ino,
> -	xfs_dinode_t	*dino);
> -
>  void
>  init_da_freemap(
>  	da_freemap_t *dir_freemap);
> @@ -91,17 +85,6 @@ namecheck(
>  	int		length);
>  
>  int
> -process_shortform_dir(
> -	xfs_mount_t	*mp,
> -	xfs_ino_t	ino,
> -	xfs_dinode_t	*dip,
> -	int		ino_discovery,
> -	int		*dino_dirty,	/* is dinode buffer dirty? */
> -	xfs_ino_t	*parent,	/* out - NULLFSINO if entry doesn't exist */
> -	char		*dirname,	/* directory pathname */
> -	int		*repair);	/* out - 1 if dir was fixed up */
> -
> -int
>  process_dir(
>  	xfs_mount_t	*mp,
>  	xfs_ino_t	ino,
> Index: xfsprogs-dev/repair/dir2.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/dir2.c	2011-12-01 16:17:07.000000000 +0000
> +++ xfsprogs-dev/repair/dir2.c	2011-12-01 16:18:23.000000000 +0000
> @@ -43,9 +43,10 @@ typedef struct dir2_bad {
>  	xfs_ino_t	ino;
>  	struct dir2_bad	*next;
>  } dir2_bad_t;
> -dir2_bad_t *dir2_bad_list;
>  
> -void
> +static dir2_bad_t *dir2_bad_list;
> +
> +static void
>  dir2_add_badlist(
>  	xfs_ino_t	ino)
>  {
> @@ -78,7 +79,7 @@ dir2_is_badino(
>   * Multibuffer handling.
>   * V2 directory blocks can be noncontiguous, needing multiple buffers.
>   */
> -xfs_dabuf_t *
> +static xfs_dabuf_t *
>  da_read_buf(
>  	xfs_mount_t	*mp,
>  	int		nex,
> @@ -186,7 +187,7 @@ da_buf_done(
>  	free(dabuf);
>  }
>  
> -int
> +static int
>  da_bwrite(
>  	xfs_mount_t	*mp,
>  	xfs_dabuf_t	*dabuf)
> @@ -226,7 +227,7 @@ da_bwrite(
>  	return error;
>  }
>  
> -void
> +static void
>  da_brelse(
>  	xfs_dabuf_t	*dabuf)
>  {
> @@ -262,7 +263,7 @@ da_brelse(
>   * left-most leaf block if successful (bno).  returns 1 if successful,
>   * 0 if unsuccessful.
>   */
> -int
> +static int
>  traverse_int_dir2block(xfs_mount_t	*mp,
>  		dir2_bt_cursor_t	*da_cursor,
>  		xfs_dablk_t		*rbno)
> @@ -392,7 +393,7 @@ error_out:
>   * buffers (e.g. if we do, it's a mistake).  if error == 1, we're
>   * in an error-handling case so unreleased buffers may exist.
>   */
> -void
> +static void
>  release_dir2_cursor_int(xfs_mount_t		*mp,
>  			dir2_bt_cursor_t	*cursor,
>  			int			prev_level,
> @@ -418,7 +419,7 @@ release_dir2_cursor_int(xfs_mount_t		*mp
>  	return;
>  }
>  
> -void
> +static void
>  release_dir2_cursor(xfs_mount_t		*mp,
>  		dir2_bt_cursor_t	*cursor,
>  		int			prev_level)
> @@ -426,7 +427,7 @@ release_dir2_cursor(xfs_mount_t		*mp,
>  	release_dir2_cursor_int(mp, cursor, prev_level, 0);
>  }
>  
> -void
> +static void
>  err_release_dir2_cursor(xfs_mount_t		*mp,
>  			dir2_bt_cursor_t	*cursor,
>  			int			prev_level)
> @@ -442,7 +443,7 @@ err_release_dir2_cursor(xfs_mount_t		*mp
>   * technically a block boundary.  This routine should be used then
>   * instead of verify_dir2_path().
>   */
> -int
> +static int
>  verify_final_dir2_path(xfs_mount_t	*mp,
>  		dir2_bt_cursor_t	*cursor,
>  		const int		p_level)
> @@ -589,7 +590,7 @@ _("would correct bad hashval in non-leaf
>   * since they have to be set so we can get a buffer for the
>   * block.
>   */
> -int
> +static int
>  verify_dir2_path(xfs_mount_t	*mp,
>  	dir2_bt_cursor_t	*cursor,
>  	const int		p_level)
> Index: xfsprogs-dev/repair/dir2.h
> ===================================================================
> --- xfsprogs-dev.orig/repair/dir2.h	2011-12-01 16:17:07.000000000 +0000
> +++ xfsprogs-dev/repair/dir2.h	2011-12-01 16:18:23.000000000 +0000
> @@ -59,30 +59,6 @@ typedef struct dir2_bt_cursor  {
>  	struct blkmap		*blkmap;
>  } dir2_bt_cursor_t;
>  
> -
> -/* ROUTINES */
> -
> -void
> -err_release_dir2_cursor(
> -	xfs_mount_t		*mp,
> -	dir2_bt_cursor_t	*cursor,
> -	int			prev_level);
> -
> -xfs_dabuf_t *
> -da_read_buf(
> -	xfs_mount_t	*mp,
> -	int		nex,
> -	struct bmap_ext	*bmp);
> -
> -int
> -da_bwrite(
> -	xfs_mount_t	*mp,
> -	xfs_dabuf_t	*bp);
> -
> -void
> -da_brelse(
> -	xfs_dabuf_t	*bp);
> -
>  int
>  process_dir2(
>  	xfs_mount_t	*mp,
> @@ -99,10 +75,6 @@ process_sf_dir2_fixi8(
>  	xfs_dir2_sf_t		*sfp,
>  	xfs_dir2_sf_entry_t	**next_sfep);
>  
> -void
> -dir2_add_badlist(
> -	xfs_ino_t	ino);
> -
>  int
>  dir2_is_badino(
>  	xfs_ino_t	ino);
> Index: xfsprogs-dev/repair/phase1.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/phase1.c	2011-12-01 16:17:07.000000000 +0000
> +++ xfsprogs-dev/repair/phase1.c	2011-12-01 16:18:23.000000000 +0000
> @@ -22,7 +22,7 @@
>  #include "protos.h"
>  #include "err_protos.h"
>  
> -void
> +static void
>  no_sb(void)
>  {
>  	do_warn(_("Sorry, could not find valid secondary superblock\n"));
> Index: xfsprogs-dev/repair/phase4.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/phase4.c	2011-12-01 16:17:07.000000000 +0000
> +++ xfsprogs-dev/repair/phase4.c	2011-12-01 16:18:23.000000000 +0000
> @@ -40,7 +40,7 @@
>   * free in which case they'd never be cleared so the fields wouldn't
>   * be cleared by process_dinode().
>   */
> -void
> +static void
>  quotino_check(xfs_mount_t *mp)
>  {
>  	ino_tree_node_t *irec;
> @@ -81,7 +81,7 @@ quotino_check(xfs_mount_t *mp)
>  	}
>  }
>  
> -void
> +static void
>  quota_sb_check(xfs_mount_t *mp)
>  {
>  	/*
> Index: xfsprogs-dev/repair/phase5.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/phase5.c	2011-12-01 16:17:07.000000000 +0000
> +++ xfsprogs-dev/repair/phase5.c	2011-12-01 16:18:23.000000000 +0000
> @@ -78,7 +78,7 @@ static __uint64_t	*sb_icount_ag;		/* all
>  static __uint64_t	*sb_ifree_ag;		/* free inodes per ag */
>  static __uint64_t	*sb_fdblocks_ag;	/* free data blocks per ag */
>  
> -int
> +static int
>  mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t agno)
>  {
>  	int			in_extent;
> @@ -165,8 +165,7 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_ag
>  	return(num_extents);
>  }
>  
> -/* ARGSUSED */
> -xfs_agblock_t
> +static xfs_agblock_t
>  get_next_blockaddr(xfs_agnumber_t agno, int level, bt_status_t *curs)
>  {
>  	ASSERT(curs->free_btree_blocks < curs->btree_blocks +
> @@ -185,8 +184,7 @@ get_next_blockaddr(xfs_agnumber_t agno,
>   * cursor pointer to the btree root.   called by init_freespace_cursor()
>   * and init_ino_cursor()
>   */
> -/* ARGSUSED */
> -void
> +static void
>  setup_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *curs)
>  {
>  	int			j;
> @@ -301,7 +299,7 @@ setup_cursor(xfs_mount_t *mp, xfs_agnumb
>  #endif
>  }
>  
> -void
> +static void
>  write_cursor(bt_status_t *curs)
>  {
>  	int i;
> @@ -322,7 +320,7 @@ write_cursor(bt_status_t *curs)
>  	}
>  }
>  
> -void
> +static void
>  finish_cursor(bt_status_t *curs)
>  {
>  	ASSERT(curs->num_free_blocks == 0);
> @@ -341,8 +339,7 @@ finish_cursor(bt_status_t *curs)
>   * btree_curs is an in/out.  returns the number of
>   * blocks that will show up in the AGFL.
>   */
> -
> -int
> +static int
>  calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  			xfs_agblock_t *extents, bt_status_t *btree_curs)
>  {
> @@ -595,7 +592,7 @@ calculate_freespace_cursor(xfs_mount_t *
>  	return(extra_blocks);
>  }
>  
> -void
> +static void
>  prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		bt_status_t *btree_curs, xfs_agblock_t startblock,
>  		xfs_extlen_t blockcount, int level, __uint32_t magic)
> @@ -689,7 +686,7 @@ prop_freespace_cursor(xfs_mount_t *mp, x
>   * of tree to build (bno or bcnt).  returns the number of free blocks
>   * represented by the tree.
>   */
> -xfs_extlen_t
> +static xfs_extlen_t
>  build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		bt_status_t *btree_curs, __uint32_t magic)
>  {
> @@ -854,7 +851,7 @@ build_freespace_tree(xfs_mount_t *mp, xf
>   * may perturb things because inode tree building happens before
>   * freespace tree building.
>   */
> -void
> +static void
>  init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
>  		__uint64_t *num_inos, __uint64_t *num_free_inos)
>  {
> @@ -942,7 +939,7 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agn
>  	return;
>  }
>  
> -void
> +static void
>  prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
>  	xfs_agino_t startino, int level)
>  {
> @@ -1027,7 +1024,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agn
>  	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
>  }
>  
> -void
> +static void
>  build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		bt_status_t *btree_curs, xfs_agino_t first_agino,
>  		xfs_agino_t count, xfs_agino_t freecount)
> @@ -1067,7 +1064,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_
>   * rebuilds an inode tree given a cursor.  We're lazy here and call
>   * the routine that builds the agi
>   */
> -void
> +static void
>  build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		bt_status_t *btree_curs)
>  {
> @@ -1197,7 +1194,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnu
>   * build both the agf and the agfl for an agno given both
>   * btree cursors
>   */
> -void
> +static void
>  build_agf_agfl(xfs_mount_t	*mp,
>  		xfs_agnumber_t	agno,
>  		bt_status_t	*bno_bt,
> @@ -1353,7 +1350,7 @@ build_agf_agfl(xfs_mount_t	*mp,
>   * feature bits to the filesystem, and sync up the on-disk superblock
>   * to match the incore superblock.
>   */
> -void
> +static void
>  sync_sb(xfs_mount_t *mp)
>  {
>  	xfs_buf_t	*bp;
> @@ -1377,7 +1374,7 @@ sync_sb(xfs_mount_t *mp)
>   * make sure the root and realtime inodes show up allocated
>   * even if they've been freed.  they get reinitialized in phase6.
>   */
> -void
> +static void
>  keep_fsinos(xfs_mount_t *mp)
>  {
>  	ino_tree_node_t		*irec;
> Index: xfsprogs-dev/repair/phase6.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/phase6.c	2011-12-01 16:17:07.000000000 +0000
> +++ xfsprogs-dev/repair/phase6.c	2011-12-01 16:18:23.000000000 +0000
> @@ -509,7 +509,7 @@ mk_rbmino(xfs_mount_t *mp)
>  	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
>  }
>  
> -int
> +static int
>  fill_rbmino(xfs_mount_t *mp)
>  {
>  	xfs_buf_t	*bp;
> @@ -576,7 +576,7 @@ _("can't access block %" PRIu64 " (fsbno
>  	return(0);
>  }
>  
> -int
> +static int
>  fill_rsumino(xfs_mount_t *mp)
>  {
>  	xfs_buf_t	*bp;
> @@ -645,7 +645,7 @@ _("can't access block %" PRIu64 " (fsbno
>  	return(0);
>  }
>  
> -void
> +static void
>  mk_rsumino(xfs_mount_t *mp)
>  {
>  	xfs_trans_t	*tp;
> @@ -751,7 +751,7 @@ mk_rsumino(xfs_mount_t *mp)
>  /*
>   * makes a new root directory.
>   */
> -void
> +static void
>  mk_root_dir(xfs_mount_t *mp)
>  {
>  	xfs_trans_t	*tp;
> @@ -815,7 +815,7 @@ mk_root_dir(xfs_mount_t *mp)
>  /*
>   * orphanage name == lost+found
>   */
> -xfs_ino_t
> +static xfs_ino_t
>  mk_orphanage(xfs_mount_t *mp)
>  {
>  	xfs_ino_t	ino;
> @@ -1130,9 +1130,6 @@ mv_orphanage(
>  }
>  
>  /*
> - * like get_first_dblock_fsbno only it uses the simulation code instead
> - * of raw I/O.
> - *
>   * Returns the fsbno of the first (leftmost) block in the directory leaf.
>   * sets *bno to the directory block # corresponding to the returned fsbno.
>   */
> @@ -3519,7 +3516,7 @@ out:
>   * mark realtime bitmap and summary inodes as reached.
>   * quota inode will be marked here as well
>   */
> -void
> +static void
>  mark_standalone_inodes(xfs_mount_t *mp)
>  {
>  	ino_tree_node_t		*irec;
> Index: xfsprogs-dev/repair/progress.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/progress.c	2011-12-01 16:17:07.000000000 +0000
> +++ xfsprogs-dev/repair/progress.c	2011-12-01 16:18:23.000000000 +0000
> @@ -360,7 +360,7 @@ print_final_rpt(void)
>  	return(sum);
>  }
>  
> -void
> +static void
>  timediff(int phase)
>  {
>  	phase_times[phase].duration =
> Index: xfsprogs-dev/repair/sb.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/sb.c	2011-12-01 16:17:07.000000000 +0000
> +++ xfsprogs-dev/repair/sb.c	2011-12-01 16:18:23.000000000 +0000
> @@ -32,7 +32,7 @@
>   * copy the fields of a superblock that are present in primary and
>   * secondaries -- preserve fields that are different in the primary.
>   */
> -void
> +static void
>  copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
>  {
>  	xfs_ino_t	rootino;
> @@ -169,7 +169,7 @@ find_secondary_sb(xfs_sb_t *rsb)
>   * calculate what inode alignment field ought to be
>   * based on internal superblock info
>   */
> -int
> +static int
>  calc_ino_align(xfs_sb_t *sb)
>  {
>  	xfs_extlen_t align;
> @@ -516,8 +516,7 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int
>  }
>  
>  /* returns element on list with highest reference count */
> -
> -fs_geo_list_t *
> +static fs_geo_list_t *
>  get_best_geo(fs_geo_list_t *list)
>  {
>  	int cnt = 0;
> @@ -537,8 +536,7 @@ get_best_geo(fs_geo_list_t *list)
>  }
>  
>  /* adds geometry info to linked list.  returns (sometimes new) head of list */
> -
> -fs_geo_list_t *
> +static fs_geo_list_t *
>  add_geo(fs_geo_list_t *list, fs_geometry_t *geo_p, int index)
>  {
>  	fs_geo_list_t	*current = list;
> @@ -565,7 +563,7 @@ add_geo(fs_geo_list_t *list, fs_geometry
>  	return(current);
>  }
>  
> -void
> +static void
>  free_geo(fs_geo_list_t *list)
>  {
>  	fs_geo_list_t	*next;
> Index: xfsprogs-dev/repair/scan.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/scan.c	2011-12-01 16:17:32.000000000 +0000
> +++ xfsprogs-dev/repair/scan.c	2011-12-01 16:18:23.000000000 +0000
> @@ -69,7 +69,7 @@ set_mp(xfs_mount_t *mpp)
>  	mp = mpp;
>  }
>  
> -void
> +static void
>  scan_sbtree(
>  	xfs_agblock_t	root,
>  	int		nlevels,
> Index: xfsprogs-dev/repair/xfs_repair.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/xfs_repair.c	2011-12-01 16:17:58.000000000 +0000
> +++ xfsprogs-dev/repair/xfs_repair.c	2011-12-01 16:18:23.000000000 +0000
> @@ -49,8 +49,7 @@ extern void	phase7(xfs_mount_t *);
>  /*
>   * -o: user-supplied override options
>   */
> -
> -char *o_opts[] = {
> +static char *o_opts[] = {
>  #define ASSUME_XFS	0
>  	"assume_xfs",
>  #define PRE_65_BETA	1
> @@ -71,8 +70,7 @@ char *o_opts[] = {
>  /*
>   * -c: conversion options
>   */
> -
> -char *c_opts[] = {
> +static char *c_opts[] = {
>  #define CONVERT_LAZY_COUNT	0
>  	"lazycount",
>  	NULL
> @@ -183,7 +181,7 @@ unknown(char opt, char *s)
>  /*
>   * sets only the global argument flags and variables
>   */
> -void
> +static void
>  process_args(int argc, char **argv)
>  {
>  	char *p;
> @@ -398,7 +396,7 @@ do_log(char const *msg, ...)
>  	va_end(args);
>  }
>  
> -void
> +static void
>  calc_mkfs(xfs_mount_t *mp)
>  {
>  	xfs_agblock_t	fino_bno;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
