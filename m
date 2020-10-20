Return-Path: <SRS0=H2w8=D3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C9EC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 10:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 652182224F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 10:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LIc7wITs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393148AbgJTK2M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Oct 2020 06:28:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41902 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388891AbgJTK2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Oct 2020 06:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603189691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CMbDVKIH+icViwYvKUfDic9ADkxKNgdEQcVET1ODGtI=;
        b=LIc7wITs1Qw7o9v2LifZ5W8CzzTfpTEzF0NwnSKoc8nx2AfIlKYRgtikBNt55p+T9iIttU
        POw8xriHxJBaGyAH4OFCIqwwP6OwyybEDy0Pp1lWQvMe+NJAsSwnIebUQ9PT2CkFX/rwpN
        529S2UqDjgckQspCIRbTbGJcvK9JEWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-8tYqeP7cM22-8s9O4vyezw-1; Tue, 20 Oct 2020 06:28:09 -0400
X-MC-Unique: 8tYqeP7cM22-8s9O4vyezw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1AED1006C8A
        for <linux-xfs@vger.kernel.org>; Tue, 20 Oct 2020 10:28:08 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 511426198C;
        Tue, 20 Oct 2020 10:28:07 +0000 (UTC)
Date:   Tue, 20 Oct 2020 06:28:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v12 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20201020102806.GA1263949@bfoster>
References: <20201016021005.548850-1-preichl@redhat.com>
 <20201016021005.548850-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016021005.548850-2-preichl@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 16, 2020 at 04:10:02AM +0200, Pavel Reichl wrote:
> Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
> __xfs_rwsem_islocked() is a helper function which encapsulates checking
> state of rw_semaphores hold by inode.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Suggested-by: Eric Sandeen <sandeen@redhat.com>
> Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_inode.c | 39 +++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_inode.h | 21 ++++++++++++++-------
>  2 files changed, 45 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c06129cffba9..1fdf8c7eb990 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -345,9 +345,34 @@ xfs_ilock_demote(
>  }
>  
>  #if defined(DEBUG) || defined(XFS_WARN)
> -int
> +static inline bool
> +__xfs_rwsem_islocked(
> +	struct rw_semaphore	*rwsem,
> +	int			lock_flags,
> +	int			shift)
> +{
> +	lock_flags >>= shift;
> +
> +	if (!debug_locks)
> +		return rwsem_is_locked(rwsem);
> +	/*
> +	 * If the shared flag is not set, pass 0 to explicitly check for
> +	 * exclusive access to the lock. If the shared flag is set, we typically
> +	 * want to make sure the lock is at least held in shared mode
> +	 * (i.e., shared | excl) but we don't necessarily care that it might
> +	 * actually be held exclusive. Therefore, pass -1 to check whether the
> +	 * lock is held in any mode rather than one of the explicit shared mode
> +	 * values (1 or 2)."
> +	 */
> +	if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
> +		return lockdep_is_held_type(rwsem, -1);
> +	}

Nit: no need for braces here. Otherwise LGTM. Thanks for the tweaks.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	return lockdep_is_held_type(rwsem, 0);
> +}
> +
> +bool
>  xfs_isilocked(
> -	xfs_inode_t		*ip,
> +	struct xfs_inode	*ip,
>  	uint			lock_flags)
>  {
>  	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> @@ -362,15 +387,13 @@ xfs_isilocked(
>  		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
>  	}
>  
> -	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
> -		if (!(lock_flags & XFS_IOLOCK_SHARED))
> -			return !debug_locks ||
> -				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
> -		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
> +	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
> +		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem, lock_flags,
> +				XFS_IOLOCK_FLAG_SHIFT);
>  	}
>  
>  	ASSERT(0);
> -	return 0;
> +	return false;
>  }
>  #endif
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e9a8bb184d1f..9cecd6c9c90c 100644
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
> +#define XFS_IOLOCK_EXCL		(1 << XFS_IOLOCK_FLAG_SHIFT)
> +#define XFS_IOLOCK_SHARED	(XFS_IOLOCK_EXCL << XFS_SHARED_LOCK_SHIFT)
> +#define XFS_ILOCK_EXCL		(1 << XFS_ILOCK_FLAG_SHIFT)
> +#define XFS_ILOCK_SHARED	(XFS_ILOCK_EXCL << XFS_SHARED_LOCK_SHIFT)
> +#define XFS_MMAPLOCK_EXCL	(1 << XFS_MMAPLOCK_FLAG_SHIFT)
> +#define XFS_MMAPLOCK_SHARED	(XFS_MMAPLOCK_EXCL << XFS_SHARED_LOCK_SHIFT)
>  
>  #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
>  				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
> @@ -412,7 +419,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
>  int		xfs_ilock_nowait(xfs_inode_t *, uint);
>  void		xfs_iunlock(xfs_inode_t *, uint);
>  void		xfs_ilock_demote(xfs_inode_t *, uint);
> -int		xfs_isilocked(xfs_inode_t *, uint);
> +bool		xfs_isilocked(struct xfs_inode *, uint);
>  uint		xfs_ilock_data_map_shared(struct xfs_inode *);
>  uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
>  
> -- 
> 2.26.2
> 

