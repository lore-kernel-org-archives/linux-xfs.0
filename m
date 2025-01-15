Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A068BE7
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 06:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736922281; cv=none; b=YAbYkGSm0NitzUhutZL8ADac950dxhsC8hCvMABQOSaP/NsuYdMRNOLZQpii26fer6YSfCfgMfnqRfXeTyN5XvG2JKxkvebENmAELm2yHKia5Mq2R0mlBJvtZcpMyEQhhx3xtWxfEoMLFMeN9catJdpsxrbK9jJGXQ3iNkOzc98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736922281; c=relaxed/simple;
	bh=r9jqVwUSaJtNABoU36v/myDxqYiMFGx8lW67i+OiNcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W3YahAAsJLLcb4FcmpWHDIZ6LR33r7eGkBZNDUFt69MdHfVJCma1/3o0ILWLzat961tzKNYfYEx76//89pMaW507ypb/fwckDU4Lkjs7iirqjJszZXx87YQ3DibnK+xl/RILJGdjlYHDznp/w/P6ljes2FODm0G4YOTCf61E/cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bRojHHnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bRojHHnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7405FC4CEDF;
	Wed, 15 Jan 2025 06:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736922280;
	bh=r9jqVwUSaJtNABoU36v/myDxqYiMFGx8lW67i+OiNcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bRojHHnbq567nSIDur74pm7Apy2/n7L0FhZRqWXSWmjtDwdy1VPQWg5AnheTG2m2Y
	 P5MURYyjNUreAW0ZDSmsOB7tk10/Mo5GYlefhUtpb/6Zdbp6h/3NoAkywXyz1YFm8E
	 xZYUW6XPSxUHsxl++EfQaWg6bjTcUppPqvICXfqTV38kbUcM0uErf2nIj8oBJfjZQr
	 uNIx8MTVpRfIgSQzjxNfcTTB6LxhBnrWBh2OSI3l6nf4Jx0vRqRqLn3AyDSr+58Td5
	 jATXyowj0+sJ+uxe81GtxDavPDMD5CXzOS35YrKTTVXEbFNfl1wUnQ3ab787mTktPR
	 lfVBCb5XcD4Dw==
Date: Tue, 14 Jan 2025 22:24:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH] xfs: Prevent mounting with quotas in norecovery if
 quotacheck is needed
Message-ID: <20250115062438.GG3557553@frogsfrogsfrogs>
References: <20250115061840.269757-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115061840.269757-1-cem@kernel.org>

On Wed, Jan 15, 2025 at 07:18:32AM +0100, cem@kernel.org wrote:
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
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_qm_bhv.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 37f1230e7584..eae106ca7e1b 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -97,10 +97,11 @@ xfs_qm_newmount(
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
>  	if (((uquotaondisk && !XFS_IS_UQUOTA_ON(mp)) ||
> @@ -109,7 +110,8 @@ xfs_qm_newmount(
>  	    (!gquotaondisk &&  XFS_IS_GQUOTA_ON(mp)) ||
>  	     (pquotaondisk && !XFS_IS_PQUOTA_ON(mp)) ||
>  	    (!pquotaondisk &&  XFS_IS_PQUOTA_ON(mp)))  &&
> -	    xfs_dev_is_read_only(mp, "changing quota state")) {
> +	    (xfs_dev_is_read_only(mp, "changing quota state") ||
> +	     xfs_has_norecovery(mp))) {
>  		xfs_warn(mp, "please mount with%s%s%s%s.",
>  			(!quotaondisk ? "out quota" : ""),
>  			(uquotaondisk ? " usrquota" : ""),

The logic seems ok, but (as I mentioned in office hours this morning) I
wonder if we shouldn't just ignore quota entirely for a norecovery
mount?

I guess for metadir we also could change the message to say "don't mount
with any quota options" since the quota mount options are persistent now.

--D

> -- 
> 2.47.1
> 
