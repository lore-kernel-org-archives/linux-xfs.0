Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 05A4F7FFF
	for <xfs@oss.sgi.com>; Fri, 24 Jan 2014 07:42:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B00E6304043
	for <xfs@oss.sgi.com>; Fri, 24 Jan 2014 05:42:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qNE9bHqn4438sdCr for
	<xfs@oss.sgi.com>; Fri, 24 Jan 2014 05:42:45 -0800 (PST)
Message-ID: <52E26DD2.5020808@redhat.com>
Date: Fri, 24 Jan 2014 08:42:42 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfs_repair: add support for validating dirent ftype
	field
References: <1390517573-29898-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1390517573-29898-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 01/23/2014 05:52 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add code to track the filetype of an inode from phase 3 when all the
> inodes are scanned throught to phase 6 when the directory structure
> is validated and corrected.
> 
> Add code to phase 6 shortform and long form directory entry
> validation to read the ftype from the dirent, lookup the inode
> record and check they are the same. If they aren't and we are in
> no-modify mode, issue a warning such as:
> 
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
> would fix ftype mismatch (5/1) in directory/child inode 64/68
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> 
> If we are fixing the problem:
> 
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
> fixing ftype mismatch (5/1) in directory/child inode 64/68
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> 
> Note that this is from a leaf form directory entry that was
> intentionally corrupted with xfs_db like so:
> 
> xfs_db> inode 64
> xfs_db> a u3.bmx[0].startblock
> xfs_db> p
> ....
> du[3].inumber = 68
> du[3].namelen = 11
> du[3].name = "syscalltest"
> du[3].filetype = 1
> du[3].tag = 0x70
> ....
> xfs_db> write du[3].filetype 5
> du[3].filetype = 5
> xfs_db> quit
> 
> Shortform directory entry repair was tested in a similar fashion.
> 
> Further, track the ftype in the directory hash table that is build,
> so if the directory is rebuild from scratch it has the necessary
> ftype information to rebuild the directory correctly. Further, if we
> detect a ftype mismatch, update the entry in the hash so that later
> directory errors that lead to it being rebuilt use the corrected
> ftype field, not the bad one.
> 
> Note that this code pulls in some kernel side code that is currently
> in kernel private locations (xfs_mode_to_ftype table), so there'll
> be some kernel/userspace sync work needed to bring these back into
> line.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Version 3:
> - fixed max_size updates
> - fixed comment grammar
> 
> Version 2:
> - factored out junking of entry in shortform directory code
> - fixed leak of ftypes array memory
> ---
>  include/xfs_dir2.h   |   3 +
>  libxfs/xfs_dir2.c    |  16 ++++
>  repair/dino_chunks.c |  11 +++
>  repair/incore.h      |  27 +++++-
>  repair/incore_ino.c  |  30 ++++++-
>  repair/phase6.c      | 239 ++++++++++++++++++++++++++++++++++++---------------
>  repair/scan.c        |   4 +-
>  7 files changed, 253 insertions(+), 77 deletions(-)
> 
> diff --git a/include/xfs_dir2.h b/include/xfs_dir2.h
> index 9910401..3900130 100644
...
> diff --git a/repair/phase6.c b/repair/phase6.c
> index d2d4a44..157685c 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
...
> @@ -2189,6 +2238,59 @@ out_fix:
>   * shortform directory v2 processing routines -- entry verification and
>   * bad entry deletion (pruning).
>   */
> +static struct xfs_dir2_sf_entry *
> +shortform_dir2_junk(
> +	struct xfs_mount	*mp,
> +	struct xfs_dir2_sf_hdr	*sfp,
> +	struct xfs_dir2_sf_entry *sfep,
> +	xfs_ino_t		lino,
> +	int			*max_size,
> +	int			*index,
> +	int			*bytes_deleted,
> +	int			*ino_dirty)
> +{
> +	struct xfs_dir2_sf_entry *tmp_sfep;
> +	int			tmp_len;
> +	int			tmp_elen;
> +
> +	if (lino == orphanage_ino)
> +		orphanage_ino = 0;
> +	if (no_modify) {
> +		do_warn(_("would junk entry\n"));
> +		return NULL;

Argh, sorry I missed this last time. ;) This looks like a problem. In
the no_modify case, we return NULL and 'continue' in the caller, which
skips the loop end logic and leads to bad things.

We could calculate and return the next entry here, but it might be
cleaner to use a goto instead of continue in the callers and not
duplicate the logic.

> +	}
> +
> +	tmp_elen = xfs_dir3_sf_entsize(mp, sfp,
> +					sfep->namelen);
> +	tmp_sfep = (xfs_dir2_sf_entry_t *)
> +		((__psint_t) sfep + tmp_elen);
> +	tmp_len = *max_size - ((__psint_t) tmp_sfep
> +				- (__psint_t) sfp);
> +	*max_size -= tmp_elen;
> +	*bytes_deleted += tmp_elen;
> +
> +	memmove(sfep, tmp_sfep, tmp_len);
> +
> +	sfp->count -= 1;
> +	memset((void *)((__psint_t)sfep + tmp_len), 0,
> +			tmp_elen);
> +
> +	/*
> +	 * WARNING:  drop the index i by one
> +	 * so it matches the decremented count for
> +	 * accurate comparisons in the loop test
> +	 */
> +	(*index)--;
> +
> +	*ino_dirty = 1;
> +
> +	if (verbose)
> +		do_warn(_("junking entry\n"));
> +	else
> +		do_warn("\n");
> +	return sfep;
> +}
> +
>  static void
>  shortform_dir2_entry_check(xfs_mount_t	*mp,
>  			xfs_ino_t	ino,
> @@ -2201,15 +2303,13 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  	xfs_ino_t		lino;
>  	xfs_ino_t		parent;
>  	struct xfs_dir2_sf_hdr	*sfp;
> -	xfs_dir2_sf_entry_t	*sfep, *next_sfep, *tmp_sfep;
> +	struct xfs_dir2_sf_entry *sfep;
> +	struct xfs_dir2_sf_entry *next_sfep;
>  	xfs_ifork_t		*ifp;
>  	ino_tree_node_t		*irec;

If we're going to respin, it might be worth fixing up these two typedefs
as well.

Brian

>  	int			max_size;
>  	int			ino_offset;
>  	int			i;
> -	int			junkit;
> -	int			tmp_len;
> -	int			tmp_elen;
>  	int			bad_sfnamelen;
>  	int			namelen;
>  	int			bytes_deleted;
> @@ -2266,9 +2366,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  	for (i = 0; i < sfp->count && max_size >
>  					(__psint_t)next_sfep - (__psint_t)sfp;
>  			sfep = next_sfep, i++)  {
> -		junkit = 0;
>  		bad_sfnamelen = 0;
> -		tmp_sfep = NULL;
>  
>  		lino = xfs_dir3_sfe_get_ino(mp, sfp, sfep);
>  
> @@ -2340,7 +2438,10 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  			do_warn(
>  	_("entry \"%s\" in shortform directory %" PRIu64 " references non-existent inode %" PRIu64 "\n"),
>  				fname, ino, lino);
> -			goto do_junkit;
> +			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
> +						&max_size, &i, &bytes_deleted,
> +						ino_dirty);
> +			continue;
>  		}
>  
>  		ino_offset = XFS_INO_TO_AGINO(mp, lino) - irec->ino_startnum;
> @@ -2354,7 +2455,10 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  			do_warn(
>  	_("entry \"%s\" in shortform directory inode %" PRIu64 " points to free inode %" PRIu64 "\n"),
>  				fname, ino, lino);
> -			goto do_junkit;
> +			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
> +						&max_size, &i, &bytes_deleted,
> +						ino_dirty);
> +			continue;
>  		}
>  		/*
>  		 * check if this inode is lost+found dir in the root
> @@ -2367,7 +2471,10 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  				do_warn(
>  	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory"),
>  					ORPHANAGE, lino, ino);
> -				goto do_junkit;
> +				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
> +						lino, &max_size, &i,
> +						&bytes_deleted, ino_dirty);
> +				continue;
>  			}
>  			/*
>  			 * if this is a dup, it will be picked up below,
> @@ -2381,11 +2488,15 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  		 */
>  		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
>  				(sfep - xfs_dir2_sf_firstentry(sfp)),
> -				lino, sfep->namelen, sfep->name)) {
> +				lino, sfep->namelen, sfep->name,
> +				xfs_dir3_sfe_get_ftype(mp, sfp, sfep))) {
>  			do_warn(
>  _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>  				fname, lino, ino);
> -			goto do_junkit;
> +			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
> +						&max_size, &i, &bytes_deleted,
> +						ino_dirty);
> +			continue;
>  		}
>  
>  		if (!inode_isadir(irec, ino_offset))  {
> @@ -2403,11 +2514,14 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>  			 * the .. in the child, blow out the entry
>  			 */
>  			if (is_inode_reached(irec, ino_offset))  {
> -				junkit = 1;
>  				do_warn(
>  	_("entry \"%s\" in directory inode %" PRIu64
>  	  " references already connected inode %" PRIu64 ".\n"),
>  					fname, ino, lino);
> +				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
> +						lino, &max_size, &i,
> +						&bytes_deleted, ino_dirty);
> +				continue;
>  			} else if (parent == ino)  {
>  				add_inode_reached(irec, ino_offset);
>  				add_inode_ref(current_irec, current_ino_offset);
> @@ -2423,76 +2537,60 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>  				add_dotdot_update(XFS_INO_TO_AGNO(mp, lino),
>  							irec, ino_offset);
>  			} else  {
> -				junkit = 1;
>  				do_warn(
>  	_("entry \"%s\" in directory inode %" PRIu64
>  	  " not consistent with .. value (%" PRIu64
>  	  ") in inode %" PRIu64 ",\n"),
>  					fname, ino, parent, lino);
> +				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
> +						lino, &max_size, &i,
> +						&bytes_deleted, ino_dirty);
> +				continue;
>  			}
>  		}
>  
> -		if (junkit)  {
> -do_junkit:
> -			if (lino == orphanage_ino)
> -				orphanage_ino = 0;
> -			if (!no_modify)  {
> -				tmp_elen = xfs_dir3_sf_entsize(mp, sfp,
> -								sfep->namelen);
> -				tmp_sfep = (xfs_dir2_sf_entry_t *)
> -					((__psint_t) sfep + tmp_elen);
> -				tmp_len = max_size - ((__psint_t) tmp_sfep
> -							- (__psint_t) sfp);
> -				max_size -= tmp_elen;
> -				bytes_deleted += tmp_elen;
> -
> -				memmove(sfep, tmp_sfep, tmp_len);
> -
> -				sfp->count -= 1;
> -				memset((void *)((__psint_t)sfep + tmp_len), 0,
> -						tmp_elen);
> -
> -				/*
> -				 * set the tmp value to the current
> -				 * pointer so we'll process the entry
> -				 * we just moved up
> -				 */
> -				tmp_sfep = sfep;
> -
> -				/*
> -				 * WARNING:  drop the index i by one
> -				 * so it matches the decremented count for
> -				 * accurate comparisons in the loop test
> -				 */
> -				i--;
> +		/* validate ftype field if supported */
> +		if (xfs_sb_version_hasftype(&mp->m_sb)) {
> +			__uint8_t dir_ftype;
> +			__uint8_t ino_ftype;
>  
> -				*ino_dirty = 1;
> +			dir_ftype = xfs_dir3_sfe_get_ftype(mp, sfp, sfep);
> +			ino_ftype = get_inode_ftype(irec, ino_offset);
>  
> -				if (verbose)
> -					do_warn(_("junking entry\n"));
> -				else
> -					do_warn("\n");
> -			} else  {
> -				do_warn(_("would junk entry\n"));
> +			if (dir_ftype != ino_ftype) {
> +				if (no_modify) {
> +					do_warn(
> +	_("would fix ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
> +						dir_ftype, ino_ftype,
> +						ino, lino);
> +				} else {
> +					do_warn(
> +	_("fixing ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
> +						dir_ftype, ino_ftype,
> +						ino, lino);
> +					xfs_dir3_sfe_put_ftype(mp, sfp, sfep,
> +								ino_ftype);
> +					dir_hash_update_ftype(hashtab,
> +			(xfs_dir2_dataptr_t)(sfep - xfs_dir2_sf_firstentry(sfp)),
> +							      ino_ftype);
> +					*ino_dirty = 1;
> +				}
>  			}
> -		} else if (lino > XFS_DIR2_MAX_SHORT_INUM)
> +		}
> +
> +		if (lino > XFS_DIR2_MAX_SHORT_INUM)
>  			i8++;
>  
>  		/*
> -		 * go onto next entry unless we've just junked an
> -		 * entry in which the current entry pointer points
> -		 * to an unprocessed entry.  have to take into entries
> -		 * with bad namelen into account in no modify mode since we
> -		 * calculate size based on next_sfep.
> +		 * go onto next entry - we have to take entries with bad namelen
> +		 * into account in no modify mode since we calculate size based
> +		 * on next_sfep.
>  		 */
>  		ASSERT(no_modify || bad_sfnamelen == 0);
> -
> -		next_sfep = (tmp_sfep == NULL)
> -			? (xfs_dir2_sf_entry_t *) ((__psint_t) sfep
> -							+ ((!bad_sfnamelen)
> -				? xfs_dir3_sf_entsize(mp, sfp, sfep->namelen)
> -				: xfs_dir3_sf_entsize(mp, sfp, namelen)))
> -			: tmp_sfep;
> +		next_sfep = (struct xfs_dir2_sf_entry *)((__psint_t)sfep +
> +			      (bad_sfnamelen
> +				? xfs_dir3_sf_entsize(mp, sfp, namelen)
> +				: xfs_dir3_sf_entsize(mp, sfp, sfep->namelen)));
>  	}
>  
>  	if (sfp->i8count != i8) {
> @@ -2501,6 +2599,8 @@ do_junkit:
>  				ino);
>  		} else {
>  			if (i8 == 0) {
> +				struct xfs_dir2_sf_entry *tmp_sfep;
> +
>  				tmp_sfep = next_sfep;
>  				process_sf_dir2_fixi8(mp, sfp, &tmp_sfep);
>  				bytes_deleted +=
> @@ -2518,8 +2618,7 @@ do_junkit:
>  	/*
>  	 * sync up sizes if required
>  	 */
> -	if (*ino_dirty)  {
> -		ASSERT(bytes_deleted > 0);
> +	if (*ino_dirty && bytes_deleted > 0)  {
>  		ASSERT(!no_modify);
>  		libxfs_idata_realloc(ip, -bytes_deleted, XFS_DATA_FORK);
>  		ip->i_d.di_size -= bytes_deleted;
> diff --git a/repair/scan.c b/repair/scan.c
> index 49ed194..73b4581 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -866,9 +866,9 @@ _("inode rec for ino %" PRIu64 " (%d/%d) overlaps existing rec (start %d/%d)\n")
>  		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
>  			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
>  				nfree++;
> -				add_aginode_uncertain(agno, ino + j, 1);
> +				add_aginode_uncertain(mp, agno, ino + j, 1);
>  			} else  {
> -				add_aginode_uncertain(agno, ino + j, 0);
> +				add_aginode_uncertain(mp, agno, ino + j, 0);
>  			}
>  		}
>  	}
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
