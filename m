Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 272D2C4363A
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 15:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA95B2184D
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 15:09:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gSSQ7hgA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730888AbgJHPJ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 11:09:57 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51236 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730880AbgJHPJ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 11:09:56 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098F0EhB158151;
        Thu, 8 Oct 2020 15:09:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=cZ639WdNFbjoEWaJns57iWBHfsTjuo+D2wPeIW+5suA=;
 b=gSSQ7hgAXoQ6wlp62NouCllAfnJdyPGOjkxHG2glTLDpYp78373IzQFoZBs+Pv1fr9uy
 76YCzvGV4Qeeogc8FJqvcjRGBQu/+ybJNGpdoQQu0ipdaHR22+UEQvY/FPoPxQRbLsuy
 txO+k36H8T3td+08+H7ERuAB6K9WznBqUXUPAyGVrTz7/L0kWU3S7mNlipTAVrEpBKnk
 WRaM9RvhlxQQktdGt4oB/+8sednkifu5cv+uVA5n1roPOlCY8Y4fRsyJK+WjWU205f0e
 3saOB7g965XJqZuQWXWlPNBS9vxiYM8SCMpzzb6zLpvHRipcrk4X1yhFE96IDD1qAYd+ sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33xetb8e1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 15:09:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098F0G8w156394;
        Thu, 8 Oct 2020 15:09:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33y3819p0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 15:09:53 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098F9q5E007767;
        Thu, 8 Oct 2020 15:09:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 08:09:52 -0700
Date:   Thu, 8 Oct 2020 08:09:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v10 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20201008150950.GN6540@magnolia>
References: <20201008134605.863269-1-preichl@redhat.com>
 <20201008134605.863269-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008134605.863269-2-preichl@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080115
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 08, 2020 at 03:46:02PM +0200, Pavel Reichl wrote:
> Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
> __xfs_rwsem_islocked() is a helper function which encapsulates checking
> state of rw_semaphores hold by inode.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Suggested-by: Eric Sandeen <sandeen@redhat.com>
> Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 48 ++++++++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_inode.h | 21 +++++++++++++-------
>  2 files changed, 54 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c06129cffba9..7c1ceb4df4ec 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -345,9 +345,43 @@ xfs_ilock_demote(
>  }
>  
>  #if defined(DEBUG) || defined(XFS_WARN)
> -int
> +static inline bool
> +__xfs_rwsem_islocked(
> +	struct rw_semaphore	*rwsem,
> +	int			lock_flags)
> +{
> +	int			arg;
> +
> +	if (!debug_locks)
> +		return rwsem_is_locked(rwsem);
> +
> +	if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
> +		/*
> +		 * The caller could be asking if we have (shared | excl)
> +		 * access to the lock. Ask lockdep if the rwsem is
> +		 * locked either for read or write access.
> +		 *
> +		 * The caller could also be asking if we have only
> +		 * shared access to the lock. Holding a rwsem
> +		 * write-locked implies read access as well, so the
> +		 * request to lockdep is the same for this case.
> +		 */
> +		arg = -1;
> +	} else {
> +		/*
> +		 * The caller is asking if we have only exclusive access
> +		 * to the lock. Ask lockdep if the rwsem is locked for
> +		 * write access.
> +		 */
> +		arg = 0;
> +	}
> +
> +	return lockdep_is_held_type(rwsem, arg);
> +}
> +
> +bool
>  xfs_isilocked(
> -	xfs_inode_t		*ip,
> +	struct xfs_inode	*ip,
>  	uint			lock_flags)
>  {
>  	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> @@ -362,15 +396,13 @@ xfs_isilocked(
>  		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
>  	}
>  
> -	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
> -		if (!(lock_flags & XFS_IOLOCK_SHARED))
> -			return !debug_locks ||
> -				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
> -		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
> +	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
> +		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
> +				(lock_flags >> XFS_IOLOCK_FLAG_SHIFT));
>  	}
>  
>  	ASSERT(0);
> -	return 0;
> +	return false;
>  }
>  #endif
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e9a8bb184d1f..77d5655191ab 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -268,12 +268,19 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
>   * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
>   *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
>   */
> -#define	XFS_IOLOCK_EXCL		(1<<0)
> -#define	XFS_IOLOCK_SHARED	(1<<1)
> -#define	XFS_ILOCK_EXCL		(1<<2)
> -#define	XFS_ILOCK_SHARED	(1<<3)
> -#define	XFS_MMAPLOCK_EXCL	(1<<4)
> -#define	XFS_MMAPLOCK_SHARED	(1<<5)
> +
> +#define XFS_IOLOCK_FLAG_SHIFT	0
> +#define XFS_ILOCK_FLAG_SHIFT	2
> +#define XFS_MMAPLOCK_FLAG_SHIFT	4
> +
> +#define XFS_SHARED_LOCK_SHIFT	1
> +
> +#define XFS_IOLOCK_EXCL		(1 << (XFS_IOLOCK_FLAG_SHIFT))
> +#define XFS_IOLOCK_SHARED	(XFS_IOLOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
> +#define XFS_ILOCK_EXCL		(1 << (XFS_ILOCK_FLAG_SHIFT))
> +#define XFS_ILOCK_SHARED	(XFS_ILOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
> +#define XFS_MMAPLOCK_EXCL	(1 << (XFS_MMAPLOCK_FLAG_SHIFT))
> +#define XFS_MMAPLOCK_SHARED	(XFS_MMAPLOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
>  
>  #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
>  				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
> @@ -412,7 +419,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
>  int		xfs_ilock_nowait(xfs_inode_t *, uint);
>  void		xfs_iunlock(xfs_inode_t *, uint);
>  void		xfs_ilock_demote(xfs_inode_t *, uint);
> -int		xfs_isilocked(xfs_inode_t *, uint);
> +bool		xfs_isilocked(xfs_inode_t *, uint);

Minor nit: you might as well get rid of the typedef here.

With that fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  uint		xfs_ilock_data_map_shared(struct xfs_inode *);
>  uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
>  
> -- 
> 2.26.2
> 
