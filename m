Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200C422331;
	Sat, 23 Nov 2024 16:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732378796; cv=none; b=lKkpdOp2xxcn4bKRmCIezjegJlzVXNnFUsQKh236qf7z5SAPI9RbFLRElgjKkFIpqAPOJm24jm9kd0zsWRDqt+xDdDSZ79dnVpg9NYEXJyRAmUKISTWVNYokUVRojJwyfmeSwQRxwxBQdbHsDVzchI8fQfBz7W/BkcNWuAQadcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732378796; c=relaxed/simple;
	bh=UAz/5rueebgzUWvU1dKEBr8+mhyiLuppUlnKNTQYIFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sNPAjFJpeGNwsgIrFu8qGcneR3XVz+aTzxFZLCpZ7CR18cNdMNPzmhlhiasDbWeFLvSQhojr3VKsKWw41xIZ0zo8HoAkuqj3SNuK7Pbi2FDdhgEczAQ4qem1Mr6HmeaaRimovcRFNo0CQYfgg0tzuuhbGsh8w6AvLpal/t5k1NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCzb5a8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCzb5a8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1DFC4CECD;
	Sat, 23 Nov 2024 16:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732378795;
	bh=UAz/5rueebgzUWvU1dKEBr8+mhyiLuppUlnKNTQYIFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QCzb5a8AwcfZgjSgKNQ9EzailygTLJLz7Tt4vJRh42qWopVD4jZyCGWUKHYgwYqq0
	 Y7P7snVgNK/ZYbVk+sYiwAhuIq5tNZpvE/l58aW9NmVrCz9J2h3WopZjRbHtBolFbP
	 W3pgtZCZ4ZL1rWEHVzJE4Gonzukx+x52DxIiV9rq/3XZWeNPgVWK9I4xWQcSJuLjyD
	 oPIHiUIp6CwL++wAjqhhCWWCwLfztj57EwdGjXrNLtbHnunMSSnlpmqYYymTWGrVYS
	 gm5rugLT/TdNEbvEh0+VSKopjFEZo/Nfjbh+vzTXS1IwWWfSZNan2mZSxVpJ1KIQGE
	 xVBk07mdLsKfA==
Date: Sat, 23 Nov 2024 08:19:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: dchinner@redhat.com, cem@kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use inode_set_cached_link()
Message-ID: <20241123161955.GO1926309@frogsfrogsfrogs>
References: <20241123075105.1082661-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241123075105.1082661-1-mjguzik@gmail.com>

On Sat, Nov 23, 2024 at 08:51:05AM +0100, Mateusz Guzik wrote:
> For cases where caching is applicable this dodges inode locking, memory
> allocation and memcpy + strlen.
> 
> Throughput of readlink on Saphire Rappids (ops/s):
> before:	3641273
> after:	4009524 (+10%)
> 
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> ---
> 
> First a minor note that in the stock case strlen is called on the buffer
> and I verified that i_disk_size is the value which is computed.
> 
> The important note is that I'm assuming the pointed to area is stable
> for the duration of the inode's lifetime -- that is if the read off
> symlink is fine *or* it was just created and is eligible caching, it
> wont get invalidated as long as the inode is in memory. If this does not
> hold then this submission is wrong and it would be nice(tm) to remedy
> it.

It is not stable for the lifetime of the inode.  See commit
7b7820b83f2300 ("xfs: don't expose internal symlink metadata buffers to
the vfs").  With parent pointers' ability to expand the symlink xattr
fork area sufficiently to bump the symlink target into a remote block
and online repair's ability to mess with the inode, direct vfs access of
if_data has only become more difficult.

--D

> This depends on stuff which landed in vfs-6.14.misc, but is not in next
> nor fs-next yet.
> 
> For benchmark code see bottom of https://lore.kernel.org/linux-fsdevel/20241120112037.822078-1-mjguzik@gmail.com/
> 
>  fs/xfs/xfs_iops.c    |  1 +
>  fs/xfs/xfs_symlink.c | 24 ++++++++++++++++++++++++
>  fs/xfs/xfs_symlink.h |  1 +
>  3 files changed, 26 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 207e0dadffc3..1d0a3797f876 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1394,6 +1394,7 @@ xfs_setup_iops(
>  		break;
>  	case S_IFLNK:
>  		inode->i_op = &xfs_symlink_inode_operations;
> +		xfs_setup_cached_symlink(ip);
>  		break;
>  	default:
>  		inode->i_op = &xfs_inode_operations;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 4252b07cd251..59bf1b9ccb20 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -28,6 +28,30 @@
>  #include "xfs_parent.h"
>  #include "xfs_defer.h"
>  
> +void
> +xfs_setup_cached_symlink(
> +	struct xfs_inode	*ip)
> +{
> +	struct inode		*inode = &ip->i_vnode;
> +	xfs_fsize_t		pathlen;
> +
> +	/*
> +	 * If we have the symlink readily accessible let the VFS know where to
> +	 * find it. This avoids calls to xfs_readlink().
> +	 */
> +	pathlen = ip->i_disk_size;
> +	if (pathlen <= 0 || pathlen > XFS_SYMLINK_MAXLEN)
> +		return;
> +
> +	if (ip->i_df.if_format != XFS_DINODE_FMT_LOCAL)
> +		return;
> +
> +	if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_data))
> +		return;
> +
> +	inode_set_cached_link(inode, ip->i_df.if_data, pathlen);
> +}
> +
>  int
>  xfs_readlink(
>  	struct xfs_inode	*ip,
> diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
> index 0d29a50e66fd..0e45a8a33829 100644
> --- a/fs/xfs/xfs_symlink.h
> +++ b/fs/xfs/xfs_symlink.h
> @@ -12,5 +12,6 @@ int xfs_symlink(struct mnt_idmap *idmap, struct xfs_inode *dp,
>  		umode_t mode, struct xfs_inode **ipp);
>  int xfs_readlink(struct xfs_inode *ip, char *link);
>  int xfs_inactive_symlink(struct xfs_inode *ip);
> +void xfs_setup_cached_symlink(struct xfs_inode *ip);
>  
>  #endif /* __XFS_SYMLINK_H */
> -- 
> 2.43.0
> 
