Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0665BC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88B1E2220F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgLCTYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:24:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49766 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgLCTYH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 14:24:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3JJrvw030176;
        Thu, 3 Dec 2020 19:23:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OgD03wHtepgn1FHnYGXhh+pGTsk6c8qzPLgCr/gLrUE=;
 b=oqy/iuX7uBe8KgV8pvmHhbPjKqPDosfznuaRZ/9QYzHbsVTq2TzjhT+Lyev/JcCFJbzu
 YMUXzzrahD7L3BBxT/9VBmsMvEmJaIHHDvg28Q2KD4itZ+mjE6fjKejfn8AMrMD7a1ZR
 EDlz2xij9YUGh0YSloQimsuvkrfLJP9EKj5mFhi+vi/AJPTeWXdZN9hRCK8F1kVv8Ul/
 sSuLGYFejFQhLCfD21cfxnuyf2/2b/nLUOqlnSMj6OK7vX3HhSzeAvG15KaAsN2V2gWV
 AYTYskswIAlhpAszsYtNbJIrfPnbfY4iYaPrzkb7VZMQltN0DkQrYvHcFisPuiYETRSD jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 353dyqyvda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 19:23:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3JKVCn128767;
        Thu, 3 Dec 2020 19:21:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35404r9pph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 19:21:20 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3JLIJi027851;
        Thu, 3 Dec 2020 19:21:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 11:21:18 -0800
Date:   Thu, 3 Dec 2020 11:21:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201203192117.GF106272@magnolia>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
 <20201203161028.1900929-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203161028.1900929-4-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=5 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030111
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 12:10:25AM +0800, Gao Xiang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So xfs_ialloc() will only address in-core inode allocation then.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks good to me, I never liked ialloc_context anyway.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 200 +++++++++++++++------------------------------
>  1 file changed, 65 insertions(+), 135 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4ebfb1a18f0f..34eca1624397 100644
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
> +static struct xfs_inode *
>  xfs_ialloc(
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*pip,
> -	umode_t		mode,
> -	xfs_nlink_t	nlink,
> -	dev_t		rdev,
> -	prid_t		prid,
> -	xfs_buf_t	**ialloc_context,
> -	xfs_inode_t	**ipp)
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
> @@ -926,20 +881,19 @@ xfs_ialloc(
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
>  int
>  xfs_dir_ialloc(
> @@ -954,83 +908,59 @@ xfs_dir_ialloc(
>  	xfs_inode_t	**ipp)		/* pointer to inode; it will be
>  					   locked. */
>  {
> -	xfs_trans_t	*tp;
>  	xfs_inode_t	*ip;
>  	xfs_buf_t	*ialloc_context = NULL;
> -	int		code;
> -
> -	tp = *tpp;
> -	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> +	xfs_ino_t	pino = dp ? dp->i_ino : 0;
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
> +	*ipp = NULL;
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
> +	error = xfs_dialloc(*tpp, pino, mode, ialloc_context, &ino);
> +	if (error)
> +		return error;
>  
>  	/*
>  	 * If the AGI buffer is non-NULL, then we were unable to get an
>  	 * inode in one operation.  We need to commit the current
> -	 * transaction and call xfs_ialloc() again.  It is guaranteed
> +	 * transaction and call xfs_ialloc() then.  It is guaranteed
>  	 * to succeed the second time.
>  	 */
>  	if (ialloc_context) {
> -		code = xfs_dialloc_roll(&tp, ialloc_context);
> -		if (code) {
> -			*ipp = NULL;
> -			return code;
> -		}
> -
> -		/*
> -		 * Call ialloc again. Since we've locked out all
> -		 * other allocations in this allocation group,
> -		 * this call should always succeed.
> -		 */
> -		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
> -				  &ialloc_context, &ip);
> -
> +		error = xfs_dialloc_roll(tpp, ialloc_context);
> +		if (error)
> +			return error;
>  		/*
> -		 * If we get an error at this point, return to the caller
> -		 * so that the current transaction can be aborted.
> +		 * Call dialloc again. Since we've locked out all other
> +		 * allocations in this allocation group, this call should
> +		 * always succeed.
>  		 */
> -		if (code) {
> -			*tpp = tp;
> -			*ipp = NULL;
> -			return code;
> -		}
> -		ASSERT(!ialloc_context && ip);
> -
> +		error = xfs_dialloc(*tpp, pino, mode, ialloc_context, &ino);
> +		if (error)
> +			return error;
> +		ASSERT(!ialloc_context);
>  	}
>  
> -	*ipp = ip;
> -	*tpp = tp;
> +	if (ino == NULLFSINO)
> +		return -ENOSPC;
>  
> +	/* Initialise the newly allocated inode. */
> +	ip = xfs_ialloc(*tpp, dp, ino, mode, nlink, rdev, prid);
> +	if (IS_ERR(ip))
> +		return PTR_ERR(ip);
> +	*ipp = ip;
>  	return 0;
>  }
>  
> -- 
> 2.18.4
> 
