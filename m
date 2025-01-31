Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6D61E8823
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jan 2025 16:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738340287; cv=none; b=kRFszw2rbjrONCDByrlqUcbYa06+jlu/UalgjNnG0Fyw5yayzceoxzrEJ0GNqIFR7J2vZIjlI7wUcxfx23SoLjz+KSXIHlLZWNGm+OxvhC7Y8qHkiGfshiFSctRc8ZgA7WL4RP1B1yEtptDn3TIUO8N/VncvvkCyLFWpn43SNyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738340287; c=relaxed/simple;
	bh=2GMBmAduAL7aSFpKMBSGm66nuzGFc5YDo7FgAR0knkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TvX5zDE+0z2TDb9zMWINrelS93HW3dTSgFX6DD6fiGsQV/Owk+d89rK7sg+RFL9r/MwXNthXdu9pV7BDJXNLq9bg2I8HgqDNT1YyoNgjOZi5u8fi7Z5GtgZGWEnozq9xytAZFe17D9JDJhZqS+AuxHxqLCS+RZGrJR94W5mP8eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6psn2Fi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6psn2Fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014B2C4CED3;
	Fri, 31 Jan 2025 16:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738340287;
	bh=2GMBmAduAL7aSFpKMBSGm66nuzGFc5YDo7FgAR0knkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H6psn2Fixz3+X1Bsb6axch4tfevTIjZc0j5vNnRGTbf9bROgKm54NhQrmvDj6NPFI
	 pRn3UMGDvpjF3MRjVw6DOALjko42HQIfjS0nnniXVrLA98jNVh3T/LiRLAlrtHdB84
	 3l9D8RUhq6oTex5cPduXDXBq3w6eP4glG4FuFP7eEZBtcAvuPkN4tEN6DmJy+Uicxo
	 F6yLzbHIRAineDMIOJz5rZAFVy6Dq/syfNemPTTp6DBlUEZ8yddBqmP8gcfxMebBTP
	 UxBXWoPqDWJx+6W1az+YxOk1GkP3SxTHOgnDo3RDbjKidoC38TUbxMfUQublfAYO0S
	 V642LknaRxxdQ==
Date: Fri, 31 Jan 2025 08:18:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, dchinner@redhat.com,
	hch@lst.de
Subject: Re: [PATCH V2] xfs: Do not allow norecovery mount with quotacheck
Message-ID: <20250131161806.GU1611770@frogsfrogsfrogs>
References: <20250131100302.15430-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250131100302.15430-1-cem@kernel.org>

On Fri, Jan 31, 2025 at 11:02:54AM +0100, cem@kernel.org wrote:
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
> add a new helper named xfs_qm_validate(), factoring the quota state
> changes out of xfs_qm_newmount() to reduce cluttering within it.
> 
> As per Darrick suggestion, add a new, different  warning message if
> metadir is enabled.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> ---
> 
> Changelog V1->V2:
> 	- Issue a different warn message in case metadir is enabled
> 	- Factour out quota state validator code to a new helper
> 	- Change patch subject to reduce length
> 
> 
>  fs/xfs/xfs_qm_bhv.c | 55 ++++++++++++++++++++++++++++++++-------------
>  1 file changed, 39 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 37f1230e7584..a6a7870401c3 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -78,6 +78,28 @@ xfs_qm_statvfs(
>  	}
>  }
>  
> +STATIC int
> +xfs_qm_validate(

This validates ... what exactly?

Oh, it validates that we can actually make the state change.

xfs_qm_validate_state_change(), perhaps ?

> +	xfs_mount_t	*mp,

Please don't introduce more typedef usage.

	struct xfs_mount	*mp,

> +	uint		uqd,
> +	uint		gqd,
> +	uint		pqd)
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
> +	if (xfs_qm_validate(mp, uquotaondisk,
> +			    gquotaondisk, pquotaondisk)) {
> +
> +		if (xfs_has_metadir(mp))
> +			xfs_warn(mp,
> +			       "metadir enabled, please mount withouth quotas");

"metadir enabled, please mount without any quota mount options"

--D

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
