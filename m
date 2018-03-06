Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42016 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753987AbeCFTng (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Mar 2018 14:43:36 -0500
Date: Tue, 6 Mar 2018 11:43:29 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/16] xfs_repair: don't fail directory repairs when
 grabbing inodes
Message-ID: <20180306194329.GI18989@magnolia>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993162526.22223.3665832156616656282.stgit@magnolia>
 <fa21f326-8144-8dd1-0d4e-3a36a6f439c2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa21f326-8144-8dd1-0d4e-3a36a6f439c2@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, djwong@kernel.org

On Tue, Mar 06, 2018 at 01:23:51PM -0600, Eric Sandeen wrote:
> On 3/1/18 1:13 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > There are a few places where xfs_repair needs to be able to load a
> > damaged directory inode to perform repairs.  Since inline data fork
> > verifiers can now be customized, refactor libxfs_iget to enable
> > repair to get at this so that we don't crash in phase 6.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> 
> Hm but there /is/ no custom verifier here, right?  Just NULL or default?
> In that case does it make sense to be passing ops around vs. just
> adding a "bool validate" arg in place of the NULL ops dance you have now?

Originally it was just an iget flag, but I think Dave wanted repair to
have the ability to pass in a custom ifork_ops.  Theoretically we could
have an ifork verifier that does the same things as the libxfs ones
*except* for the places where repair deliberately zeroes a field that it
intends to set in a future pass.  I don't really like the prospect of
maintaining code almost-duplication, but in the mean time this restores
xfs_repair's ability to fix directory .. entries which we lost in
4.10).

--D

> > ---
> >  db/attrset.c        |    6 ++++--
> >  include/xfs_inode.h |    6 ++++--
> >  libxfs/rdwr.c       |   25 +++++++++++++++++--------
> >  libxfs/trans.c      |    6 ++++--
> >  libxfs/util.c       |    2 +-
> >  repair/phase6.c     |   16 +++++++++++-----
> >  6 files changed, 41 insertions(+), 20 deletions(-)
> > 
> > 
> > diff --git a/db/attrset.c b/db/attrset.c
> > index ad3c8f3..457317a 100644
> > --- a/db/attrset.c
> > +++ b/db/attrset.c
> > @@ -151,7 +151,8 @@ attr_set_f(
> >  		value = NULL;
> >  	}
> >  
> > -	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip)) {
> > +	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip,
> > +			&xfs_default_ifork_ops)) {
> >  		dbprintf(_("failed to iget inode %llu\n"),
> >  			(unsigned long long)iocur_top->ino);
> >  		goto out;
> > @@ -226,7 +227,8 @@ attr_remove_f(
> >  
> >  	name = argv[optind];
> >  
> > -	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip)) {
> > +	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip,
> > +			&xfs_default_ifork_ops)) {
> >  		dbprintf(_("failed to iget inode %llu\n"),
> >  			(unsigned long long)iocur_top->ino);
> >  		goto out;
> > diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> > index 92829a2..f29f0f0 100644
> > --- a/include/xfs_inode.h
> > +++ b/include/xfs_inode.h
> > @@ -162,9 +162,11 @@ extern void	libxfs_trans_ichgtime(struct xfs_trans *,
> >  extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
> >  
> >  /* Inode Cache Interfaces */
> > -extern bool	libxfs_inode_verify_forks(struct xfs_inode *ip);
> > +extern bool	libxfs_inode_verify_forks(struct xfs_inode *ip,
> > +				struct xfs_ifork_ops *);
> >  extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
> > -				uint, struct xfs_inode **);
> > +				uint, struct xfs_inode **,
> > +				struct xfs_ifork_ops *);
> >  extern void	libxfs_iput(struct xfs_inode *);
> >  
> >  #define IRELE(ip) libxfs_iput(ip)
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index 3c5def2..416e89b 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -1342,12 +1342,16 @@ extern kmem_zone_t	*xfs_inode_zone;
> >   */
> >  bool
> >  libxfs_inode_verify_forks(
> > -	struct xfs_inode	*ip)
> > +	struct xfs_inode	*ip,
> > +	struct xfs_ifork_ops	*ops)
> >  {
> >  	struct xfs_ifork	*ifp;
> >  	xfs_failaddr_t		fa;
> >  
> > -	fa = xfs_ifork_verify_data(ip, &xfs_default_ifork_ops);
> > +	if (!ops)
> > +		return true;
> > +
> > +	fa = xfs_ifork_verify_data(ip, ops);
> >  	if (fa) {
> >  		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> >  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
> > @@ -1355,7 +1359,7 @@ libxfs_inode_verify_forks(
> >  		return false;
> >  	}
> >  
> > -	fa = xfs_ifork_verify_attr(ip, &xfs_default_ifork_ops);
> > +	fa = xfs_ifork_verify_attr(ip, ops);
> >  	if (fa) {
> >  		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
> >  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> > @@ -1367,11 +1371,16 @@ libxfs_inode_verify_forks(
> >  }
> >  
> >  int
> > -libxfs_iget(xfs_mount_t *mp, xfs_trans_t *tp, xfs_ino_t ino, uint lock_flags,
> > -		xfs_inode_t **ipp)
> > +libxfs_iget(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	*tp,
> > +	xfs_ino_t		ino,
> > +	uint			lock_flags,
> > +	struct xfs_inode	**ipp,
> > +	struct xfs_ifork_ops	*ifork_ops)
> >  {
> > -	xfs_inode_t	*ip;
> > -	int		error = 0;
> > +	struct xfs_inode	*ip;
> > +	int			error = 0;
> >  
> >  	ip = kmem_zone_zalloc(xfs_inode_zone, 0);
> >  	if (!ip)
> > @@ -1386,7 +1395,7 @@ libxfs_iget(xfs_mount_t *mp, xfs_trans_t *tp, xfs_ino_t ino, uint lock_flags,
> >  		return error;
> >  	}
> >  
> > -	if (!libxfs_inode_verify_forks(ip)) {
> > +	if (!libxfs_inode_verify_forks(ip, ifork_ops)) {
> >  		libxfs_iput(ip);
> >  		return -EFSCORRUPTED;
> >  	}
> > diff --git a/libxfs/trans.c b/libxfs/trans.c
> > index 0e7b7ae..67b1117 100644
> > --- a/libxfs/trans.c
> > +++ b/libxfs/trans.c
> > @@ -243,9 +243,11 @@ libxfs_trans_iget(
> >  	xfs_inode_log_item_t	*iip;
> >  
> >  	if (tp == NULL)
> > -		return libxfs_iget(mp, tp, ino, lock_flags, ipp);
> > +		return libxfs_iget(mp, tp, ino, lock_flags, ipp,
> > +				&xfs_default_ifork_ops);
> >  
> > -	error = libxfs_iget(mp, tp, ino, lock_flags, &ip);
> > +	error = libxfs_iget(mp, tp, ino, lock_flags, &ip,
> > +			&xfs_default_ifork_ops);
> >  	if (error)
> >  		return error;
> >  	ASSERT(ip != NULL);
> > diff --git a/libxfs/util.c b/libxfs/util.c
> > index aac558c..611ab9c 100644
> > --- a/libxfs/util.c
> > +++ b/libxfs/util.c
> > @@ -494,7 +494,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
> >  		VFS_I(ip)->i_version++;
> >  
> >  	/* Check the inline fork data before we write out. */
> > -	if (!libxfs_inode_verify_forks(ip))
> > +	if (!libxfs_inode_verify_forks(ip, &xfs_default_ifork_ops))
> >  		return -EFSCORRUPTED;
> >  
> >  	/*
> > diff --git a/repair/phase6.c b/repair/phase6.c
> > index 1a398aa..aff83bc 100644
> > --- a/repair/phase6.c
> > +++ b/repair/phase6.c
> > @@ -927,7 +927,9 @@ mk_orphanage(xfs_mount_t *mp)
> >  	 * would have been cleared in phase3 and phase4.
> >  	 */
> >  
> > -	if ((i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip)))
> > +	i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip,
> > +			&xfs_default_ifork_ops);
> > +	if (i)
> >  		do_error(_("%d - couldn't iget root inode to obtain %s\n"),
> >  			i, ORPHANAGE);
> >  
> > @@ -951,7 +953,9 @@ mk_orphanage(xfs_mount_t *mp)
> >  	 * use iget/ijoin instead of trans_iget because the ialloc
> >  	 * wrapper can commit the transaction and start a new one
> >  	 */
> > -/*	if ((i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip)))
> > +/*	i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip,
> > +			&xfs_default_ifork_ops);
> > +	if (i)
> >  		do_error(_("%d - couldn't iget root inode to make %s\n"),
> >  			i, ORPHANAGE);*/
> >  
> > @@ -1066,7 +1070,8 @@ mv_orphanage(
> >  	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
> >  				(unsigned long long)ino);
> >  
> > -	err = -libxfs_iget(mp, NULL, orphanage_ino, 0, &orphanage_ip);
> > +	err = -libxfs_iget(mp, NULL, orphanage_ino, 0, &orphanage_ip,
> > +			&xfs_default_ifork_ops);
> >  	if (err)
> >  		do_error(_("%d - couldn't iget orphanage inode\n"), err);
> >  	/*
> > @@ -1078,7 +1083,8 @@ mv_orphanage(
> >  		xname.len = snprintf((char *)fname, sizeof(fname), "%llu.%d",
> >  					(unsigned long long)ino, ++incr);
> >  
> > -	if ((err = -libxfs_iget(mp, NULL, ino, 0, &ino_p)))
> > +	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &xfs_default_ifork_ops);
> > +	if (err)
> >  		do_error(_("%d - couldn't iget disconnected inode\n"), err);
> >  
> >  	xname.type = libxfs_mode_to_ftype(VFS_I(ino_p)->i_mode);
> > @@ -2827,7 +2833,7 @@ process_dir_inode(
> >  
> >  	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
> >  
> > -	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
> > +	error = -libxfs_iget(mp, NULL, ino, 0, &ip, NULL);
> >  	if (error) {
> >  		if (!no_modify)
> >  			do_error(
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
