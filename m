Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751963AbeDRRJG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Apr 2018 13:09:06 -0400
Date: Wed, 18 Apr 2018 13:09:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/11] xfs: create the XFS_QMOPT_QUOTIP_LOCKED flag
Message-ID: <20180418170904.GA22375@bfoster.bfoster>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401917977.11465.9543981144688523511.stgit@magnolia>
 <20180418153317.GB19870@bfoster.bfoster>
 <20180418165511.GS24738@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418165511.GS24738@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 18, 2018 at 09:55:11AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 18, 2018 at 11:33:17AM -0400, Brian Foster wrote:
> > On Tue, Apr 17, 2018 at 07:39:39PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Create a new QMOPT flag to signal that we've already locked the quota
> > > inode.  This will be used by the quota scrub code refactoring to avoid
> > > dropping the quota ip lock during scrub.  The flag is incompatible with
> > > the DQALLOC flag because dquot allocation creates a transaction, and we
> > > shouldn't be doing that with the ILOCK held.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_quota_defs.h |    2 ++
> > >  fs/xfs/xfs_dquot.c             |   32 ++++++++++++++++++++------------
> > >  2 files changed, 22 insertions(+), 12 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> > > index bb1b13a..cfc9938 100644
> > > --- a/fs/xfs/libxfs/xfs_quota_defs.h
> > > +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> > > @@ -107,6 +107,8 @@ typedef uint16_t	xfs_qwarncnt_t;
> > >   * to a single function. None of these XFS_QMOPT_* flags are meant to have
> > >   * persistent values (ie. their values can and will change between versions)
> > >   */
> > > +/* Quota ip already locked.  Cannot be used with DQALLOC. */
> > > +#define XFS_QMOPT_QUOTIP_LOCKED	0x0000001
> > >  #define XFS_QMOPT_DQALLOC	0x0000002 /* alloc dquot ondisk if needed */
> > >  #define XFS_QMOPT_UQUOTA	0x0000004 /* user dquot requested */
> > >  #define XFS_QMOPT_PQUOTA	0x0000008 /* project dquot requested */
> > > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > > index a7daef9..ed2e37c 100644
> > > --- a/fs/xfs/xfs_dquot.c
> > > +++ b/fs/xfs/xfs_dquot.c
> > > @@ -417,18 +417,20 @@ xfs_qm_dqtobp(
> > >  	struct xfs_mount	*mp = dqp->q_mount;
> > >  	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
> > >  	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
> > > -	uint			lock_mode;
> > > +	uint			lock_mode = 0;
> > >  
> > >  	quotip = xfs_quota_inode(dqp->q_mount, dqp->dq_flags);
> > >  	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
> > >  
> > > -	lock_mode = xfs_ilock_data_map_shared(quotip);
> > > +	if (!(flags & XFS_QMOPT_QUOTIP_LOCKED))
> > > +		lock_mode = xfs_ilock_data_map_shared(quotip);
> > >  	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
> > >  		/*
> > >  		 * Return if this type of quotas is turned off while we
> > >  		 * didn't have the quota inode lock.
> > >  		 */
> > > -		xfs_iunlock(quotip, lock_mode);
> > > +		if (lock_mode)
> > > +			xfs_iunlock(quotip, lock_mode);
> > >  		return -ESRCH;
> > >  	}
> > >  
> > > @@ -438,7 +440,8 @@ xfs_qm_dqtobp(
> > >  	error = xfs_bmapi_read(quotip, dqp->q_fileoffset,
> > >  			       XFS_DQUOT_CLUSTER_SIZE_FSB, &map, &nmaps, 0);
> > >  
> > > -	xfs_iunlock(quotip, lock_mode);
> > > +	if (lock_mode)
> > > +		xfs_iunlock(quotip, lock_mode);
> > >  	if (error)
> > >  		return error;
> > >  
> > > @@ -458,7 +461,7 @@ xfs_qm_dqtobp(
> > >  		 */
> > >  		if (!(flags & XFS_QMOPT_DQALLOC))
> > >  			return -ENOENT;
> > > -
> > > +		ASSERT(!(flags & XFS_QMOPT_QUOTIP_LOCKED));
> > >  		ASSERT(tp);
> > >  		error = xfs_qm_dqalloc(tpp, mp, dqp, quotip,
> > >  					dqp->q_fileoffset, &bp);
> > > @@ -553,6 +556,7 @@ xfs_qm_dqread(
> > >  	trace_xfs_dqread(dqp);
> > >  
> > >  	if (flags & XFS_QMOPT_DQALLOC) {
> > > +		ASSERT(!(flags & XFS_QMOPT_QUOTIP_LOCKED));
> > 
> > Perhaps we should just have an explicit check for both flags above and
> > return with -EINVAL if necessary?
> 
> Sounds like a good idea.
> 
> > >  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
> > >  				XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
> > >  		if (error)
> > > @@ -634,11 +638,12 @@ static int
> > >  xfs_dq_get_next_id(
> > >  	struct xfs_mount	*mp,
> > >  	uint			type,
> > > -	xfs_dqid_t		*id)
> > > +	xfs_dqid_t		*id,
> > > +	uint			flags)
> > >  {
> > >  	struct xfs_inode	*quotip = xfs_quota_inode(mp, type);
> > >  	xfs_dqid_t		next_id = *id + 1; /* simple advance */
> > > -	uint			lock_flags;
> > > +	uint			lock_flags = 0;
> > >  	struct xfs_bmbt_irec	got;
> > >  	struct xfs_iext_cursor	cur;
> > >  	xfs_fsblock_t		start;
> > > @@ -657,7 +662,8 @@ xfs_dq_get_next_id(
> > >  	/* Nope, next_id is now past the current chunk, so find the next one */
> > >  	start = (xfs_fsblock_t)next_id / mp->m_quotainfo->qi_dqperchunk;
> > >  
> > > -	lock_flags = xfs_ilock_data_map_shared(quotip);
> > > +	if (!(flags & XFS_QMOPT_QUOTIP_LOCKED))
> > > +		lock_flags = xfs_ilock_data_map_shared(quotip);
> > >  	if (!(quotip->i_df.if_flags & XFS_IFEXTENTS)) {
> > >  		error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
> > >  		if (error)
> > > @@ -673,7 +679,8 @@ xfs_dq_get_next_id(
> > >  		error = -ENOENT;
> > >  	}
> > >  
> > > -	xfs_iunlock(quotip, lock_flags);
> > > +	if (lock_flags)
> > > +		xfs_iunlock(quotip, lock_flags);
> > >  
> > >  	return error;
> > >  }
> > > @@ -733,7 +740,8 @@ xfs_qm_dqget(
> > 
> > Earlier code in this function drops/reacquires the ip ILOCK with a note
> > in the comment around lock ordering with the quota inode. Assuming an
> > inode is passed, is that lock cycle safe if the caller also has the
> > quotip held locked?
> 
> I'm not sure; for the case that I want to support (iterate dquots
> without a specific file inode in mind) I don't need (ip != NULL) at all.
> So my answer is that I don't want to support this scenario at all. :)
> 

Ok, works for me.

> Ok, so at the top of _dqget, add:
> 
> if (flags & _QUOTIP_LOCKED) {
> 	ASSERT(ip == NULL);
> 	ASSERT(!(flags & _DQALLOC));
> 	if (ip || (flags & DQALLOC))
> 		return -EINVAL;
> }
> 

It might be better to split the DQALLOC part off to xfs_qm_dqread()
since it is not static and that's where we act on the dqalloc flag.

Brian

> --D
> 
> > 
> > Brian
> > 
> > >  			if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
> > >  				xfs_dqunlock(dqp);
> > >  				mutex_unlock(&qi->qi_tree_lock);
> > > -				error = xfs_dq_get_next_id(mp, type, &id);
> > > +				error = xfs_dq_get_next_id(mp, type, &id,
> > > +						flags);
> > >  				if (error)
> > >  					return error;
> > >  				goto restart;
> > > @@ -768,7 +776,7 @@ xfs_qm_dqget(
> > >  
> > >  	/* If we are asked to find next active id, keep looking */
> > >  	if (error == -ENOENT && (flags & XFS_QMOPT_DQNEXT)) {
> > > -		error = xfs_dq_get_next_id(mp, type, &id);
> > > +		error = xfs_dq_get_next_id(mp, type, &id, flags);
> > >  		if (!error)
> > >  			goto restart;
> > >  	}
> > > @@ -827,7 +835,7 @@ xfs_qm_dqget(
> > >  	if (flags & XFS_QMOPT_DQNEXT) {
> > >  		if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
> > >  			xfs_qm_dqput(dqp);
> > > -			error = xfs_dq_get_next_id(mp, type, &id);
> > > +			error = xfs_dq_get_next_id(mp, type, &id, flags);
> > >  			if (error)
> > >  				return error;
> > >  			goto restart;
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
