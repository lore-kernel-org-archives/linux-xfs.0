Return-Path: <SRS0=pOan=AF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91056C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 12:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F953207DD
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 12:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jN0K/2oX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389657AbgFXMjQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 08:39:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44993 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388132AbgFXMjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 08:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593002352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vRXkah07ftWJTtJS8OrVdyW4vN0GJwZo6+Ug6scW5aU=;
        b=jN0K/2oXefB61h4mIymt/7c2KQKcIsUSCBCiVJG8gXYNuiZvnfVl4SDKchzwQ9xkMPa4Rp
        8jWZgI3qGQQE6fC0+ydfDjAqptdFtKZdTW8+w8v2R4hJ6SWwJX2U6kWT0fzwGQlEZopH/3
        e9SeW9TbnUQvHQfS/lo9W1PCg82IcVo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-j-GS0RQ5P1ycdpgFXM3Z9g-1; Wed, 24 Jun 2020 08:39:10 -0400
X-MC-Unique: j-GS0RQ5P1ycdpgFXM3Z9g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 270F8BFC1;
        Wed, 24 Jun 2020 12:39:09 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A8F660C80;
        Wed, 24 Jun 2020 12:39:08 +0000 (UTC)
Date:   Wed, 24 Jun 2020 08:39:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 3/3] xfs: refactor locking and unlocking two inodes
 against userspace IO
Message-ID: <20200624123906.GC9914@bfoster>
References: <159288488965.150128.10967331397379450406.stgit@magnolia>
 <159288490975.150128.5869655548489048713.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159288490975.150128.5869655548489048713.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 22, 2020 at 09:01:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the two functions that we use to lock and unlock two inodes to
> block userspace from initiating IO against a file, whether via system
> calls or mmap activity.  Move them to xfs_inode.c since this functionality
> isn't specific to reflink anyway.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

I'd prefer to see refactoring patches separate from moving patches, but
looks Ok:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c    |    2 +
>  fs/xfs/xfs_inode.c   |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h   |    3 ++
>  fs/xfs/xfs_reflink.c |   85 +---------------------------------------------
>  fs/xfs/xfs_reflink.h |    2 -
>  5 files changed, 99 insertions(+), 86 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index b375fae811f2..a32d1eeee0f7 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1065,7 +1065,7 @@ xfs_file_remap_range(
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_log_force_inode(dest);
>  out_unlock:
> -	xfs_reflink_remap_unlock(file_in, file_out);
> +	xfs_iunlock_io_mmap(src, dest);
>  	if (ret)
>  		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
>  	return remapped > 0 ? remapped : ret;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9aea7d68d8ab..b9c6d1cc64a9 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3881,3 +3881,96 @@ xfs_log_force_inode(
>  		return 0;
>  	return xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC, NULL);
>  }
> +
> +/*
> + * Grab the exclusive iolock for a data copy from src to dest, making sure to
> + * abide vfs locking order (lowest pointer value goes first) and breaking the
> + * layout leases before proceeding.  The loop is needed because we cannot call
> + * the blocking break_layout() with the iolocks held, and therefore have to
> + * back out both locks.
> + */
> +static int
> +xfs_iolock_two_inodes_and_break_layout(
> +	struct inode		*src,
> +	struct inode		*dest)
> +{
> +	int			error;
> +
> +	if (src > dest)
> +		swap(src, dest);
> +
> +retry:
> +	/* Wait to break both inodes' layouts before we start locking. */
> +	error = break_layout(src, true);
> +	if (error)
> +		return error;
> +	if (src != dest) {
> +		error = break_layout(dest, true);
> +		if (error)
> +			return error;
> +	}
> +
> +	/* Lock one inode and make sure nobody got in and leased it. */
> +	inode_lock(src);
> +	error = break_layout(src, false);
> +	if (error) {
> +		inode_unlock(src);
> +		if (error == -EWOULDBLOCK)
> +			goto retry;
> +		return error;
> +	}
> +
> +	if (src == dest)
> +		return 0;
> +
> +	/* Lock the other inode and make sure nobody got in and leased it. */
> +	inode_lock_nested(dest, I_MUTEX_NONDIR2);
> +	error = break_layout(dest, false);
> +	if (error) {
> +		inode_unlock(src);
> +		inode_unlock(dest);
> +		if (error == -EWOULDBLOCK)
> +			goto retry;
> +		return error;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Lock two files so that userspace cannot initiate I/O via file syscalls or
> + * mmap activity.
> + */
> +int
> +xfs_ilock_io_mmap(
> +	struct xfs_inode	*ip1,
> +	struct xfs_inode	*ip2)
> +{
> +	int			ret;
> +
> +	ret = xfs_iolock_two_inodes_and_break_layout(VFS_I(ip1), VFS_I(ip2));
> +	if (ret)
> +		return ret;
> +	if (ip1 == ip2)
> +		xfs_ilock(ip1, XFS_MMAPLOCK_EXCL);
> +	else
> +		xfs_lock_two_inodes(ip1, XFS_MMAPLOCK_EXCL,
> +				    ip2, XFS_MMAPLOCK_EXCL);
> +	return 0;
> +}
> +
> +/* Unlock both files to allow IO and mmap activity. */
> +void
> +xfs_iunlock_io_mmap(
> +	struct xfs_inode	*ip1,
> +	struct xfs_inode	*ip2)
> +{
> +	bool			same_inode = (ip1 == ip2);
> +
> +	xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
> +	if (!same_inode)
> +		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
> +	inode_unlock(VFS_I(ip2));
> +	if (!same_inode)
> +		inode_unlock(VFS_I(ip1));
> +}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 47d3b391030d..001529784f96 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -499,4 +499,7 @@ void xfs_iunlink_destroy(struct xfs_perag *pag);
>  
>  void xfs_end_io(struct work_struct *work);
>  
> +int xfs_ilock_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> +void xfs_iunlock_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> +
>  #endif	/* __XFS_INODE_H__ */
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index dd9ed7d5694d..130b6be8180e 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1203,81 +1203,6 @@ xfs_reflink_remap_blocks(
>  	return error;
>  }
>  
> -/*
> - * Grab the exclusive iolock for a data copy from src to dest, making sure to
> - * abide vfs locking order (lowest pointer value goes first) and breaking the
> - * layout leases before proceeding.  The loop is needed because we cannot call
> - * the blocking break_layout() with the iolocks held, and therefore have to
> - * back out both locks.
> - */
> -static int
> -xfs_iolock_two_inodes_and_break_layout(
> -	struct inode		*src,
> -	struct inode		*dest)
> -{
> -	int			error;
> -
> -	if (src > dest)
> -		swap(src, dest);
> -
> -retry:
> -	/* Wait to break both inodes' layouts before we start locking. */
> -	error = break_layout(src, true);
> -	if (error)
> -		return error;
> -	if (src != dest) {
> -		error = break_layout(dest, true);
> -		if (error)
> -			return error;
> -	}
> -
> -	/* Lock one inode and make sure nobody got in and leased it. */
> -	inode_lock(src);
> -	error = break_layout(src, false);
> -	if (error) {
> -		inode_unlock(src);
> -		if (error == -EWOULDBLOCK)
> -			goto retry;
> -		return error;
> -	}
> -
> -	if (src == dest)
> -		return 0;
> -
> -	/* Lock the other inode and make sure nobody got in and leased it. */
> -	inode_lock_nested(dest, I_MUTEX_NONDIR2);
> -	error = break_layout(dest, false);
> -	if (error) {
> -		inode_unlock(src);
> -		inode_unlock(dest);
> -		if (error == -EWOULDBLOCK)
> -			goto retry;
> -		return error;
> -	}
> -
> -	return 0;
> -}
> -
> -/* Unlock both inodes after they've been prepped for a range clone. */
> -void
> -xfs_reflink_remap_unlock(
> -	struct file		*file_in,
> -	struct file		*file_out)
> -{
> -	struct inode		*inode_in = file_inode(file_in);
> -	struct xfs_inode	*src = XFS_I(inode_in);
> -	struct inode		*inode_out = file_inode(file_out);
> -	struct xfs_inode	*dest = XFS_I(inode_out);
> -	bool			same_inode = (inode_in == inode_out);
> -
> -	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
> -	if (!same_inode)
> -		xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
> -	inode_unlock(inode_out);
> -	if (!same_inode)
> -		inode_unlock(inode_in);
> -}
> -
>  /*
>   * If we're reflinking to a point past the destination file's EOF, we must
>   * zero any speculative post-EOF preallocations that sit between the old EOF
> @@ -1340,18 +1265,12 @@ xfs_reflink_remap_prep(
>  	struct xfs_inode	*src = XFS_I(inode_in);
>  	struct inode		*inode_out = file_inode(file_out);
>  	struct xfs_inode	*dest = XFS_I(inode_out);
> -	bool			same_inode = (inode_in == inode_out);
>  	int			ret;
>  
>  	/* Lock both files against IO */
> -	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
> +	ret = xfs_ilock_io_mmap(src, dest);
>  	if (ret)
>  		return ret;
> -	if (same_inode)
> -		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
> -	else
> -		xfs_lock_two_inodes(src, XFS_MMAPLOCK_EXCL, dest,
> -				XFS_MMAPLOCK_EXCL);
>  
>  	/* Check file eligibility and prepare for block sharing. */
>  	ret = -EINVAL;
> @@ -1402,7 +1321,7 @@ xfs_reflink_remap_prep(
>  
>  	return 0;
>  out_unlock:
> -	xfs_reflink_remap_unlock(file_in, file_out);
> +	xfs_iunlock_io_mmap(src, dest);
>  	return ret;
>  }
>  
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 3e4fd46373ab..487b00434b96 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -56,7 +56,5 @@ extern int xfs_reflink_remap_blocks(struct xfs_inode *src, loff_t pos_in,
>  		loff_t *remapped);
>  extern int xfs_reflink_update_dest(struct xfs_inode *dest, xfs_off_t newlen,
>  		xfs_extlen_t cowextsize, unsigned int remap_flags);
> -extern void xfs_reflink_remap_unlock(struct file *file_in,
> -		struct file *file_out);
>  
>  #endif /* __XFS_REFLINK_H */
> 

