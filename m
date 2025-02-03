Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F89220E320
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 17:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738603208; cv=none; b=H7Esp7LrVxzOgUAyMGwf4vRWhIsRJZmQKh54QQSBXlNisf7GTNT8EVAcMly3LEPlcp6vWvplzCUBX0QLHJm69awlaWnuFOb0eBDiq9KxE53OUT0dLuGyuYIx8EAQW7W+xOseOlGQwuHNKLidbUQX9Ur/PVqoC66XNxQCYWo5oic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738603208; c=relaxed/simple;
	bh=nL+AxjKxVuk08jSXWH+bZzvVrgcVlKuCIVKGG0kloEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ns9duvXiPiRN7UxjBlseoiOO060XvccpCkucrH+vwe5A2mTrR8aeZLg7Av7K3dNfFQmgbM7QSBQUtD8T+KieovnC/QMIm8o2WCGGJSL1bVJZ/v4yjgenS2hhgQkWYhHTAJqmkwFkjjQ43dCPCl0ihSgr7YQ0p0ocl+Kih3ksFTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pGeTrnyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pGeTrnyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EF7C4CEE3;
	Mon,  3 Feb 2025 17:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738603207;
	bh=nL+AxjKxVuk08jSXWH+bZzvVrgcVlKuCIVKGG0kloEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pGeTrnyWXSO+aZ/o1KAf3xJW4qtUj1tOlLE0kSd9X7WUf3bkSiWLnliuHKnirGm2b
	 bj/JZU0ugKGYnlFqvJE3gkE+8HDyxfKOyDhRzG8FVcm17kUYTF4+eCQVLJ8yIFQrUp
	 UG7Y058ma0ZJSxlE8kDQELrNAMhWj997ctt3BEL7HUBt4bvU7pTuE6Xvl8/xaMWE81
	 qFD2W8RyJkNDRwCkO/3YZESnNPPhkgRQAqxUtbtW7FhN4zZ8rmJ3U7iTgT1/BN1y0o
	 fb8yrrPzjF7jaDci7oqrhIot73ZXWh7voXA5xYspNf82aD91M+hbuLE+tINTrAmXnA
	 EgP5YYLFLEH/g==
Date: Mon, 3 Feb 2025 09:20:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, dchinner@redhat.com,
	hch@lst.de
Subject: Re: [PATCH V3] xfs: Do not allow norecovery mount with quotacheck
Message-ID: <20250203172006.GA134507@frogsfrogsfrogs>
References: <20250203130513.213225-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203130513.213225-1-cem@kernel.org>

On Mon, Feb 03, 2025 at 02:04:57PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Mounting a filesystem that requires quota state changing will generate a
> transaction.
> 
> We already check for a read-only device; we should do that for
> norecovery too.
> 
> A quotacheck on a norecovery mount, and with the right log size, will cause
> the mount process to hang on:
> 
> [<0>] xlog_grant_head_wait+0x5d/0x2a0 [xfs]
> [<0>] xlog_grant_head_check+0x112/0x180 [xfs]
> [<0>] xfs_log_reserve+0xe3/0x260 [xfs]
> [<0>] xfs_trans_reserve+0x179/0x250 [xfs]
> [<0>] xfs_trans_alloc+0x101/0x260 [xfs]
> [<0>] xfs_sync_sb+0x3f/0x80 [xfs]
> [<0>] xfs_qm_mount_quotas+0xe3/0x2f0 [xfs]
> [<0>] xfs_mountfs+0x7ad/0xc20 [xfs]
> [<0>] xfs_fs_fill_super+0x762/0xa50 [xfs]
> [<0>] get_tree_bdev_flags+0x131/0x1d0
> [<0>] vfs_get_tree+0x26/0xd0
> [<0>] vfs_cmd_create+0x59/0xe0
> [<0>] __do_sys_fsconfig+0x4e3/0x6b0
> [<0>] do_syscall_64+0x82/0x160
> [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> This is caused by a transaction running with bogus initialized head/tail
> 
> I initially hit this while running generic/050, with random log
> sizes, but I managed to reproduce it reliably here with the steps
> below:
> 
> mkfs.xfs -f -lsize=1025M -f -b size=4096 -m crc=1,reflink=1,rmapbt=1, -i
> sparse=1 /dev/vdb2 > /dev/null
> mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt
> xfs_io -x -c 'shutdown -f' /mnt
> umount /mnt
> mount -o ro,norecovery,usrquota,grpquota,prjquota  /dev/vdb2 /mnt
> 
> Last mount hangs up
> 
> As we add yet another validation if quota state is changing, this also
> add a new helper named xfs_qm_validate_state_change(), factoring the
> quota state changes out of xfs_qm_newmount() to reduce cluttering
> within it.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good to me now,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> 
> Changelog V2 -> V3:
> 	- Update helper name
> 	- Update metadir warn message
> 	- Don't use typedef for xfs_mount
> 
>  fs/xfs/xfs_qm_bhv.c | 55 ++++++++++++++++++++++++++++++++-------------
>  1 file changed, 39 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 37f1230e7584..245d754f382a 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -78,6 +78,28 @@ xfs_qm_statvfs(
>  	}
>  }
>  
> +STATIC int
> +xfs_qm_validate_state_change(
> +	struct xfs_mount	*mp,
> +	uint			uqd,
> +	uint			gqd,
> +	uint			pqd)
> +{
> +	int state;
> +
> +	/* Is quota state changing? */
> +	state = ((uqd && !XFS_IS_UQUOTA_ON(mp)) ||
> +		(!uqd &&  XFS_IS_UQUOTA_ON(mp)) ||
> +		 (gqd && !XFS_IS_GQUOTA_ON(mp)) ||
> +		(!gqd &&  XFS_IS_GQUOTA_ON(mp)) ||
> +		 (pqd && !XFS_IS_PQUOTA_ON(mp)) ||
> +		(!pqd &&  XFS_IS_PQUOTA_ON(mp)));
> +
> +	return  state &&
> +		(xfs_dev_is_read_only(mp, "changing quota state") ||
> +		xfs_has_norecovery(mp));
> +}
> +
>  int
>  xfs_qm_newmount(
>  	xfs_mount_t	*mp,
> @@ -97,24 +119,25 @@ xfs_qm_newmount(
>  	}
>  
>  	/*
> -	 * If the device itself is read-only, we can't allow
> -	 * the user to change the state of quota on the mount -
> -	 * this would generate a transaction on the ro device,
> -	 * which would lead to an I/O error and shutdown
> +	 * If the device itself is read-only and/or in norecovery
> +	 * mode, we can't allow the user to change the state of
> +	 * quota on the mount - this would generate a transaction
> +	 * on the ro device, which would lead to an I/O error and
> +	 * shutdown.
>  	 */
>  
> -	if (((uquotaondisk && !XFS_IS_UQUOTA_ON(mp)) ||
> -	    (!uquotaondisk &&  XFS_IS_UQUOTA_ON(mp)) ||
> -	     (gquotaondisk && !XFS_IS_GQUOTA_ON(mp)) ||
> -	    (!gquotaondisk &&  XFS_IS_GQUOTA_ON(mp)) ||
> -	     (pquotaondisk && !XFS_IS_PQUOTA_ON(mp)) ||
> -	    (!pquotaondisk &&  XFS_IS_PQUOTA_ON(mp)))  &&
> -	    xfs_dev_is_read_only(mp, "changing quota state")) {
> -		xfs_warn(mp, "please mount with%s%s%s%s.",
> -			(!quotaondisk ? "out quota" : ""),
> -			(uquotaondisk ? " usrquota" : ""),
> -			(gquotaondisk ? " grpquota" : ""),
> -			(pquotaondisk ? " prjquota" : ""));
> +	if (xfs_qm_validate_state_change(mp, uquotaondisk,
> +			    gquotaondisk, pquotaondisk)) {
> +
> +		if (xfs_has_metadir(mp))
> +			xfs_warn(mp,
> +		"metadir enabled, please mount without any quota mount options");
> +		else
> +			xfs_warn(mp, "please mount with%s%s%s%s.",
> +				(!quotaondisk ? "out quota" : ""),
> +				(uquotaondisk ? " usrquota" : ""),
> +				(gquotaondisk ? " grpquota" : ""),
> +				(pquotaondisk ? " prjquota" : ""));
>  		return -EPERM;
>  	}
>  
> -- 
> 2.48.1
> 
> 
