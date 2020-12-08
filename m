Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD21C4167B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 23:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 790DF23B42
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 23:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgLHXKg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 18:10:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37338 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731642AbgLHXKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 18:10:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8N3KOp177549;
        Tue, 8 Dec 2020 23:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0itiT76ssu94Q4nCXd1oD4nBEabtKaE/ZA41cWekzSw=;
 b=CxetrXBeWpMOF5E2jYAMzWIwnrYMrSql3XWh2dR7qHHmRXeR5Fqh7fdXN4lVU1KdxBSB
 lzfYUOBlszitM3WghkjIZUcKNC6Os85s5z/ZdCbbLvTIn4E7MOkyAZ4Ff3lE7mMyD5Q6
 gvtuj97pwS3NEZwy/M/wHcsfKtmKmbM39WI8t4hQOWoAFINglbVK44B2JJDrFcFIj02f
 H1KN7HTDJ7+rO6Y7zdwWHds7b39cZj7ndG8vPzsx3ahYyRTeyZ8obFodWQq8FK/MShKs
 C/QZYg8xr0VofcuUjEZ5A63namO4lJbM7T/QrNgeJapGhGeJ4pZT5NAB0tRUWtGcQchX Kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35825m5fet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 23:09:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8N4nRH051472;
        Tue, 8 Dec 2020 23:09:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 358ksp81kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 23:09:45 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B8N9iRh026432;
        Tue, 8 Dec 2020 23:09:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 15:09:43 -0800
Date:   Tue, 8 Dec 2020 15:09:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201208230942.GG1943235@magnolia>
References: <20201208122003.3158922-1-hsiangkao@redhat.com>
 <20201208122003.3158922-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208122003.3158922-4-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080145
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 08, 2020 at 08:20:00PM +0800, Gao Xiang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So xfs_ialloc() will only address in-core inode allocation then,
> Also, rename xfs_ialloc() to xfs_dir_ialloc_init() in order to
> keep everything in xfs_inode.c under the same namespace.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks fine to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c   | 220 +++++++++++++++----------------------------
>  fs/xfs/xfs_inode.h   |   6 +-
>  fs/xfs/xfs_qm.c      |  27 +++---
>  fs/xfs/xfs_symlink.c |   8 +-
>  4 files changed, 98 insertions(+), 163 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 76282da7a05c..ae6c83d46aaa 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -761,68 +761,25 @@ xfs_inode_inherit_flags2(
>  }
>  
>  /*
> - * Allocate an inode on disk and return a copy of its in-core version.
> - * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
> - * appropriately within the inode.  The uid and gid for the inode are
> - * set according to the contents of the given cred structure.
> - *
> - * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
> - * has a free inode available, call xfs_iget() to obtain the in-core
> - * version of the allocated inode.  Finally, fill in the inode and
> - * log its initial contents.  In this case, ialloc_context would be
> - * set to NULL.
> - *
> - * If xfs_dialloc() does not have an available inode, it will replenish
> - * its supply by doing an allocation. Since we can only do one
> - * allocation within a transaction without deadlocks, we must commit
> - * the current transaction before returning the inode itself.
> - * In this case, therefore, we will set ialloc_context and return.
> - * The caller should then commit the current transaction, start a new
> - * transaction, and call xfs_ialloc() again to actually get the inode.
> - *
> - * To ensure that some other process does not grab the inode that
> - * was allocated during the first call to xfs_ialloc(), this routine
> - * also returns the [locked] bp pointing to the head of the freelist
> - * as ialloc_context.  The caller should hold this buffer across
> - * the commit and pass it back into this routine on the second call.
> - *
> - * If we are allocating quota inodes, we do not have a parent inode
> - * to attach to or associate with (i.e. pip == NULL) because they
> - * are not linked into the directory structure - they are attached
> - * directly to the superblock - and so have no parent.
> + * Initialise a newly allocated inode and return the in-core inode to the
> + * caller locked exclusively.
>   */
> -static int
> -xfs_ialloc(
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*pip,
> -	umode_t		mode,
> -	xfs_nlink_t	nlink,
> -	dev_t		rdev,
> -	prid_t		prid,
> -	xfs_buf_t	**ialloc_context,
> -	xfs_inode_t	**ipp)
> +static struct xfs_inode *
> +xfs_init_new_inode(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*pip,
> +	xfs_ino_t		ino,
> +	umode_t			mode,
> +	xfs_nlink_t		nlink,
> +	dev_t			rdev,
> +	prid_t			prid)
>  {
> -	struct xfs_mount *mp = tp->t_mountp;
> -	xfs_ino_t	ino;
> -	xfs_inode_t	*ip;
> -	uint		flags;
> -	int		error;
> -	struct timespec64 tv;
> -	struct inode	*inode;
> -
> -	/*
> -	 * Call the space management code to pick
> -	 * the on-disk inode to be allocated.
> -	 */
> -	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode,
> -			    ialloc_context, &ino);
> -	if (error)
> -		return error;
> -	if (*ialloc_context || ino == NULLFSINO) {
> -		*ipp = NULL;
> -		return 0;
> -	}
> -	ASSERT(*ialloc_context == NULL);
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_inode	*ip;
> +	unsigned int		flags;
> +	int			error;
> +	struct timespec64	tv;
> +	struct inode		*inode;
>  
>  	/*
>  	 * Protect against obviously corrupt allocation btree records. Later
> @@ -833,18 +790,16 @@ xfs_ialloc(
>  	 */
>  	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
>  		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
> -		return -EFSCORRUPTED;
> +		return ERR_PTR(-EFSCORRUPTED);
>  	}
>  
>  	/*
> -	 * Get the in-core inode with the lock held exclusively.
> -	 * This is because we're setting fields here we need
> -	 * to prevent others from looking at until we're done.
> +	 * Get the in-core inode with the lock held exclusively to prevent
> +	 * others from looking at until we're done.
>  	 */
> -	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE,
> -			 XFS_ILOCK_EXCL, &ip);
> +	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE, XFS_ILOCK_EXCL, &ip);
>  	if (error)
> -		return error;
> +		return ERR_PTR(error);
>  	ASSERT(ip != NULL);
>  	inode = VFS_I(ip);
>  	inode->i_mode = mode;
> @@ -926,22 +881,21 @@ xfs_ialloc(
>  
>  	/* now that we have an i_mode we can setup the inode structure */
>  	xfs_setup_inode(ip);
> -
> -	*ipp = ip;
> -	return 0;
> +	return ip;
>  }
>  
>  /*
> - * Allocates a new inode from disk and return a pointer to the
> - * incore copy. This routine will internally commit the current
> - * transaction and allocate a new one if the Space Manager needed
> - * to do an allocation to replenish the inode free-list.
> - *
> - * This routine is designed to be called from xfs_create and
> - * xfs_create_dir.
> + * Allocates a new inode from disk and return a pointer to the incore copy. This
> + * routine will internally commit the current transaction and allocate a new one
> + * if we needed to allocate more on-disk free inodes to perform the requested
> + * operation.
>   *
> + * If we are allocating quota inodes, we do not have a parent inode to attach to
> + * or associate with (i.e. dp == NULL) because they are not linked into the
> + * directory structure - they are attached directly to the superblock - and so
> + * have no parent.
>   */
> -int
> +struct xfs_inode *
>  xfs_dir_ialloc(
>  	xfs_trans_t	**tpp,		/* input: current transaction;
>  					   output: may be a new transaction. */
> @@ -950,90 +904,60 @@ xfs_dir_ialloc(
>  	umode_t		mode,
>  	xfs_nlink_t	nlink,
>  	dev_t		rdev,
> -	prid_t		prid,		/* project id */
> -	xfs_inode_t	**ipp)		/* pointer to inode; it will be
> -					   locked. */
> +	prid_t		prid)		/* project id */
>  {
> -	xfs_trans_t	*tp;
>  	xfs_inode_t	*ip;
>  	xfs_buf_t	*ialloc_context = NULL;
> -	int		code;
> -
> -	tp = *tpp;
> -	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> +	xfs_ino_t	parent_ino = dp ? dp->i_ino : 0;
> +	xfs_ino_t	ino;
> +	int		error;
>  
> -	/*
> -	 * xfs_ialloc will return a pointer to an incore inode if
> -	 * the Space Manager has an available inode on the free
> -	 * list. Otherwise, it will do an allocation and replenish
> -	 * the freelist.  Since we can only do one allocation per
> -	 * transaction without deadlocks, we will need to commit the
> -	 * current transaction and start a new one.  We will then
> -	 * need to call xfs_ialloc again to get the inode.
> -	 *
> -	 * If xfs_ialloc did an allocation to replenish the freelist,
> -	 * it returns the bp containing the head of the freelist as
> -	 * ialloc_context. We will hold a lock on it across the
> -	 * transaction commit so that no other process can steal
> -	 * the inode(s) that we've just allocated.
> -	 */
> -	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, &ialloc_context,
> -			&ip);
> +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
>  
>  	/*
> -	 * Return an error if we were unable to allocate a new inode.
> -	 * This should only happen if we run out of space on disk or
> -	 * encounter a disk error.
> +	 * Call the space management code to pick the on-disk inode to be
> +	 * allocated and replenish the freelist.  Since we can only do one
> +	 * allocation per transaction without deadlocks, we will need to
> +	 * commit the current transaction and start a new one.
> +	 * If xfs_dialloc did an allocation to replenish the freelist, it
> +	 * returns the bp containing the head of the freelist as
> +	 * ialloc_context. We will hold a lock on it across the transaction
> +	 * commit so that no other process can steal the inode(s) that we've
> +	 * just allocated.
>  	 */
> -	if (code) {
> -		*ipp = NULL;
> -		return code;
> -	}
> -	if (!ialloc_context && !ip) {
> -		*ipp = NULL;
> -		return -ENOSPC;
> -	}
> +	error = xfs_dialloc(*tpp, parent_ino, mode, &ialloc_context, &ino);
> +	if (error)
> +		return ERR_PTR(error);
>  
>  	/*
>  	 * If the AGI buffer is non-NULL, then we were unable to get an
>  	 * inode in one operation.  We need to commit the current
> -	 * transaction and call xfs_ialloc() again.  It is guaranteed
> +	 * transaction and call xfs_dialloc() again.  It is guaranteed
>  	 * to succeed the second time.
>  	 */
>  	if (ialloc_context) {
> -		code = xfs_dialloc_roll(&tp, ialloc_context);
> -		if (code) {
> +		error = xfs_dialloc_roll(tpp, ialloc_context);
> +		if (error) {
>  			xfs_buf_relse(ialloc_context);
> -			*tpp = tp;
> -			*ipp = NULL;
> -			return code;
> +			return ERR_PTR(error);
>  		}
> -
>  		/*
> -		 * Call ialloc again. Since we've locked out all
> -		 * other allocations in this allocation group,
> -		 * this call should always succeed.
> +		 * Call dialloc again. Since we've locked out all other
> +		 * allocations in this allocation group, this call should
> +		 * always succeed.
>  		 */
> -		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
> -				  &ialloc_context, &ip);
> -
> -		/*
> -		 * If we get an error at this point, return to the caller
> -		 * so that the current transaction can be aborted.
> -		 */
> -		if (code) {
> -			*tpp = tp;
> -			*ipp = NULL;
> -			return code;
> -		}
> -		ASSERT(!ialloc_context && ip);
> -
> +		error = xfs_dialloc(*tpp, parent_ino, mode,
> +				    &ialloc_context, &ino);
> +		if (error)
> +			return ERR_PTR(error);
> +		ASSERT(!ialloc_context);
>  	}
>  
> -	*ipp = ip;
> -	*tpp = tp;
> +	if (ino == NULLFSINO)
> +		return ERR_PTR(-ENOSPC);
>  
> -	return 0;
> +	/* Initialise the newly allocated inode. */
> +	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid);
>  }
>  
>  /*
> @@ -1147,9 +1071,12 @@ xfs_create(
>  	 * entry pointing to them, but a directory also the "." entry
>  	 * pointing to itself.
>  	 */
> -	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip);
> -	if (error)
> +	ip = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid);
> +	if (IS_ERR(ip)) {
> +		error = PTR_ERR(ip);
> +		ip = NULL;
>  		goto out_trans_cancel;
> +	}
>  
>  	/*
>  	 * Now we join the directory inode to the transaction.  We do not do it
> @@ -1269,9 +1196,12 @@ xfs_create_tmpfile(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
> -	if (error)
> +	ip = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid);
> +	if (IS_ERR(ip)) {
> +		error = PTR_ERR(ip);
> +		ip = NULL;
>  		goto out_trans_cancel;
> +	}
>  
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(tp);
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 751a3d1d7d84..95b4ae35e6df 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -407,9 +407,9 @@ void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
>  xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
>  xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
>  
> -int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
> -			       xfs_nlink_t, dev_t, prid_t,
> -			       struct xfs_inode **);
> +struct xfs_inode *
> +xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t, xfs_nlink_t,
> +	       dev_t, prid_t);
>  
>  static inline int
>  xfs_itruncate_extents(
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b2a9abee8b2b..bfdf71d87777 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -737,15 +737,15 @@ xfs_qm_destroy_quotainfo(
>   */
>  STATIC int
>  xfs_qm_qino_alloc(
> -	xfs_mount_t	*mp,
> -	xfs_inode_t	**ip,
> -	uint		flags)
> +	struct xfs_mount	*mp,
> +	struct xfs_inode	**ipp,
> +	unsigned int		flags)
>  {
>  	xfs_trans_t	*tp;
>  	int		error;
>  	bool		need_alloc = true;
>  
> -	*ip = NULL;
> +	*ipp = NULL;
>  	/*
>  	 * With superblock that doesn't have separate pquotino, we
>  	 * share an inode between gquota and pquota. If the on-disk
> @@ -771,7 +771,7 @@ xfs_qm_qino_alloc(
>  				return -EFSCORRUPTED;
>  		}
>  		if (ino != NULLFSINO) {
> -			error = xfs_iget(mp, NULL, ino, 0, 0, ip);
> +			error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
>  			if (error)
>  				return error;
>  			mp->m_sb.sb_gquotino = NULLFSINO;
> @@ -787,11 +787,14 @@ xfs_qm_qino_alloc(
>  		return error;
>  
>  	if (need_alloc) {
> -		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, ip);
> -		if (error) {
> +		struct xfs_inode *ip;
> +
> +		ip = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0);
> +		if (IS_ERR(ip)) {
>  			xfs_trans_cancel(tp);
> -			return error;
> +			return PTR_ERR(ip);
>  		}
> +		*ipp = ip;
>  	}
>  
>  	/*
> @@ -812,11 +815,11 @@ xfs_qm_qino_alloc(
>  		mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
>  	}
>  	if (flags & XFS_QMOPT_UQUOTA)
> -		mp->m_sb.sb_uquotino = (*ip)->i_ino;
> +		mp->m_sb.sb_uquotino = (*ipp)->i_ino;
>  	else if (flags & XFS_QMOPT_GQUOTA)
> -		mp->m_sb.sb_gquotino = (*ip)->i_ino;
> +		mp->m_sb.sb_gquotino = (*ipp)->i_ino;
>  	else
> -		mp->m_sb.sb_pquotino = (*ip)->i_ino;
> +		mp->m_sb.sb_pquotino = (*ipp)->i_ino;
>  	spin_unlock(&mp->m_sb_lock);
>  	xfs_log_sb(tp);
>  
> @@ -826,7 +829,7 @@ xfs_qm_qino_alloc(
>  		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
>  	}
>  	if (need_alloc)
> -		xfs_finish_inode_setup(*ip);
> +		xfs_finish_inode_setup(*ipp);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 8e88a7ca387e..988fc771f089 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -223,10 +223,12 @@ xfs_symlink(
>  	/*
>  	 * Allocate an inode for the symlink.
>  	 */
> -	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
> -			       prid, &ip);
> -	if (error)
> +	ip = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0, prid);
> +	if (IS_ERR(ip)) {
> +		error = PTR_ERR(ip);
> +		ip = NULL;
>  		goto out_trans_cancel;
> +	}
>  
>  	/*
>  	 * Now we join the directory inode to the transaction.  We do not do it
> -- 
> 2.18.4
> 
