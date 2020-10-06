Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EED9C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F4CC208B6
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:16:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="t0ovOeEz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgJFEQU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:16:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46074 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgJFEQU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:16:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964EL1F133171;
        Tue, 6 Oct 2020 04:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MW9u6zpkS/t1MgLpe9daXqW0LRjIGJuteYukMbd+oOc=;
 b=t0ovOeEz/+cYuqXdiRbFFFECd0K1N/h1xhqWr2UkF3K7Hd4wJQlL3rwMpt+ckT2gj8bb
 xA+RxqvV4mre7oZGXEmpn7C2ogFR9uB/8/nRcoO15VLN3vWi23uR/gtXEoI661KZV3lD
 ryl2af1dfmqREPp2gcRCKblSYO9Hgv9KKvxfgflrne51kBnfY/udFqkQ7dW1vE338VAd
 q9/uaC5pJfJwUYgPIcxS6xla6nnqrSDJ2bkf7G+u66lJRD2zCRW3bQDuRNZI3AFRKnAI
 DmaDrW0nXMUkIaSGe+DcjyIrpF3z0SRRqhp8jqYuN+yCnQGXCl9CuUYch5zy0xxvf1Bt lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33ym34eup9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:16:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964B7if163215;
        Tue, 6 Oct 2020 04:16:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33yyjewxty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:16:17 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0964GGXJ014555;
        Tue, 6 Oct 2020 04:16:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:16:16 -0700
Date:   Mon, 5 Oct 2020 21:16:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20201006041614.GI49547@magnolia>
References: <20201005213852.233004-1-preichl@redhat.com>
 <20201005213852.233004-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005213852.233004-2-preichl@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 05, 2020 at 11:38:49PM +0200, Pavel Reichl wrote:
> Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
> __xfs_rwsem_islocked() is a helper function which encapsulates checking
> state of rw_semaphores hold by inode.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Suggested-by: Eric Sandeen <sandeen@redhat.com>
> Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 62 ++++++++++++++++++++++++++++++++++------------
>  fs/xfs/xfs_inode.h | 21 ++++++++++------
>  2 files changed, 60 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c06129cffba9..1f39bce96656 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -345,32 +345,62 @@ xfs_ilock_demote(
>  }
>  
>  #if defined(DEBUG) || defined(XFS_WARN)
> -int
> +static inline bool
> +__xfs_rwsem_islocked(
> +	struct rw_semaphore	*rwsem,
> +	int			lock_flags)
> +{
> +	int	arg;

This ought ^^^^ to be indented ^^ to there.

Otherwise this patch looks ok to me from what I vaguely remember from
the last revision.

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

Oh, also I appreciate the comment that documents why we're picking these
seemingly magic numbers.

--D

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
> -	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> -		if (!(lock_flags & XFS_ILOCK_SHARED))
> -			return !!ip->i_lock.mr_writer;
> -		return rwsem_is_locked(&ip->i_lock.mr_lock);
> +	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
> +		return __xfs_rwsem_islocked(&ip->i_lock,
> +				(lock_flags >> XFS_ILOCK_FLAG_SHIFT));
>  	}
>  
> -	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
> -		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
> -			return !!ip->i_mmaplock.mr_writer;
> -		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
> +	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
> +		return __xfs_rwsem_islocked(&ip->i_mmaplock,
> +				(lock_flags >> XFS_MMAPLOCK_FLAG_SHIFT));
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
>  uint		xfs_ilock_data_map_shared(struct xfs_inode *);
>  uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
>  
> -- 
> 2.26.2
> 
