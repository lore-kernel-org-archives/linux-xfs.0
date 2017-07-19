Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26382 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbdGSCYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2017 22:24:22 -0400
Date: Tue, 18 Jul 2017 19:24:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] libxfs: add a flags argument to libxfs_iget
Message-ID: <20170719022416.GL4224@magnolia>
References: <150040480534.16432.7424988688113046337.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150040480534.16432.7424988688113046337.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

On Tue, Jul 18, 2017 at 12:06:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a flags argument to libxfs_iget to bring it up to date with the
> kernel xfs_iget.  We will use the flags argument in the next patch
> to enable xfs_repair to shut off inode fork verifiers.

After chatting with Dave it occured to us that we really ought to have
verifiers for shortform attrs and inline symlinks.  From there, it seems
that the kernel could create a helper to verify an inode's inline forks.
This helper would be called from xfs_iget_cache_miss and xfs_iflush_int.

For xfsprogs we can modify libxfs_iget to take a pointer to a structure
full of ifork verifiers so that regular programs can just call the
library versions, and xfs_repair can supply its own for the special
sauce things it wants to do.  libxfs_iflush_int would of course call the
standard libxfs ifork verifiers the same as the kernel, as we never want
corrupt metadata hitting the disk.

Will send an rfc later...

--D

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/attrset.c        |    4 ++--
>  include/xfs_inode.h |    2 +-
>  libxfs/rdwr.c       |   15 ++++++++++-----
>  libxfs/trans.c      |    4 ++--
>  repair/phase6.c     |   10 +++++-----
>  5 files changed, 20 insertions(+), 15 deletions(-)
> 
> 
> diff --git a/db/attrset.c b/db/attrset.c
> index ad3c8f3..ddd72ed 100644
> --- a/db/attrset.c
> +++ b/db/attrset.c
> @@ -151,7 +151,7 @@ attr_set_f(
>  		value = NULL;
>  	}
>  
> -	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip)) {
> +	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, 0, &ip)) {
>  		dbprintf(_("failed to iget inode %llu\n"),
>  			(unsigned long long)iocur_top->ino);
>  		goto out;
> @@ -226,7 +226,7 @@ attr_remove_f(
>  
>  	name = argv[optind];
>  
> -	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip)) {
> +	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, 0, &ip)) {
>  		dbprintf(_("failed to iget inode %llu\n"),
>  			(unsigned long long)iocur_top->ino);
>  		goto out;
> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> index 8766024..5d5158e 100644
> --- a/include/xfs_inode.h
> +++ b/include/xfs_inode.h
> @@ -149,7 +149,7 @@ extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
>  
>  /* Inode Cache Interfaces */
>  extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
> -				uint, struct xfs_inode **);
> +				uint, uint, struct xfs_inode **);
>  extern void	libxfs_iput(struct xfs_inode *);
>  
>  #define IRELE(ip) libxfs_iput(ip)
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 43b4f1d..cf156ba 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1329,11 +1329,16 @@ extern kmem_zone_t	*xfs_ili_zone;
>  extern kmem_zone_t	*xfs_inode_zone;
>  
>  int
> -libxfs_iget(xfs_mount_t *mp, xfs_trans_t *tp, xfs_ino_t ino, uint lock_flags,
> -		xfs_inode_t **ipp)
> +libxfs_iget(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_ino_t		ino,
> +	uint			flags,
> +	uint			lock_flags,
> +	struct xfs_inode	**ipp)
>  {
> -	xfs_inode_t	*ip;
> -	int		error = 0;
> +	struct xfs_inode	*ip;
> +	int			error = 0;
>  
>  	ip = kmem_zone_zalloc(xfs_inode_zone, 0);
>  	if (!ip)
> @@ -1341,7 +1346,7 @@ libxfs_iget(xfs_mount_t *mp, xfs_trans_t *tp, xfs_ino_t ino, uint lock_flags,
>  
>  	ip->i_ino = ino;
>  	ip->i_mount = mp;
> -	error = xfs_iread(mp, tp, ip, 0);
> +	error = xfs_iread(mp, tp, ip, flags);
>  	if (error) {
>  		kmem_zone_free(xfs_inode_zone, ip);
>  		*ipp = NULL;
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index e161c28..fe22cb9 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -246,9 +246,9 @@ libxfs_trans_iget(
>  	xfs_inode_log_item_t	*iip;
>  
>  	if (tp == NULL)
> -		return libxfs_iget(mp, tp, ino, lock_flags, ipp);
> +		return libxfs_iget(mp, tp, ino, flags, lock_flags, ipp);
>  
> -	error = libxfs_iget(mp, tp, ino, lock_flags, &ip);
> +	error = libxfs_iget(mp, tp, ino, flags, lock_flags, &ip);
>  	if (error)
>  		return error;
>  	ASSERT(ip != NULL);
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 373b1a5..011bcdf 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -925,7 +925,7 @@ mk_orphanage(xfs_mount_t *mp)
>  	 * would have been cleared in phase3 and phase4.
>  	 */
>  
> -	if ((i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip)))
> +	if ((i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, 0, &pip)))
>  		do_error(_("%d - couldn't iget root inode to obtain %s\n"),
>  			i, ORPHANAGE);
>  
> @@ -949,7 +949,7 @@ mk_orphanage(xfs_mount_t *mp)
>  	 * use iget/ijoin instead of trans_iget because the ialloc
>  	 * wrapper can commit the transaction and start a new one
>  	 */
> -/*	if ((i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip)))
> +/*	if ((i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, 0, &pip)))
>  		do_error(_("%d - couldn't iget root inode to make %s\n"),
>  			i, ORPHANAGE);*/
>  
> @@ -1063,7 +1063,7 @@ mv_orphanage(
>  	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
>  				(unsigned long long)ino);
>  
> -	err = -libxfs_iget(mp, NULL, orphanage_ino, 0, &orphanage_ip);
> +	err = -libxfs_iget(mp, NULL, orphanage_ino, 0, 0, &orphanage_ip);
>  	if (err)
>  		do_error(_("%d - couldn't iget orphanage inode\n"), err);
>  	/*
> @@ -1075,7 +1075,7 @@ mv_orphanage(
>  		xname.len = snprintf((char *)fname, sizeof(fname), "%llu.%d",
>  					(unsigned long long)ino, ++incr);
>  
> -	if ((err = -libxfs_iget(mp, NULL, ino, 0, &ino_p)))
> +	if ((err = -libxfs_iget(mp, NULL, ino, 0, 0, &ino_p)))
>  		do_error(_("%d - couldn't iget disconnected inode\n"), err);
>  
>  	xname.type = xfs_mode_to_ftype(VFS_I(ino_p)->i_mode);
> @@ -2817,7 +2817,7 @@ process_dir_inode(
>  
>  	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
>  
> -	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
> +	error = -libxfs_iget(mp, NULL, ino, 0, 0, &ip);
>  	if (error) {
>  		if (!no_modify)
>  			do_error(
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
