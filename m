Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 02E947F78
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 07:59:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7B227AC002
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 05:59:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WV0tr5ckb9H2l3DH for
	<xfs@oss.sgi.com>; Wed, 22 Jan 2014 05:59:29 -0800 (PST)
Message-ID: <52DFCEBD.9020202@redhat.com>
Date: Wed, 22 Jan 2014 08:59:25 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs_repair: add support for validating dirent ftype
	field
References: <1390363829-3476-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1390363829-3476-1-git-send-email-david@fromorbit.com>
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

On 01/21/2014 11:10 PM, Dave Chinner wrote:
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
> Version 2:
> - factored out junking of entry in shortform directory code
> - fixed leak of ftypes array memory
> ---
>  include/xfs_dir2.h   |   3 +
>  libxfs/xfs_dir2.c    |  16 ++++
>  repair/dino_chunks.c |  11 +++
>  repair/incore.h      |  27 +++++-
>  repair/incore_ino.c  |  30 ++++++-
>  repair/phase6.c      | 235 ++++++++++++++++++++++++++++++++++++---------------
>  repair/scan.c        |   4 +-
>  7 files changed, 251 insertions(+), 75 deletions(-)
> 
...
>  		/*
>  		 * check easy case first, regular inode, just bump
>  		 * the link count and continue
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
> +	int			max_size,

We should probably be passing max_size as a pointer. Otherwise, nice
cleanup.

...
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
> +		 * go onto next entry - we have to take into entries

Nit... extra "into" on the above line (reads weird with the line below).
The rest of it looks good to me, though I'm pretty new to the directory
format bits.

Brian

>  		 * with bad namelen into account in no modify mode since we
>  		 * calculate size based on next_sfep.
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
