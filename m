Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5A31E3DEF
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jan 2025 16:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738340839; cv=none; b=gIF9Fqevd5k07GlLZwUi9OSd8zvnJau10MLaKKSMgWdso/yPcNVXOnOAJcqqYDAznYWcFRKnooZfMBTuQEjhGjVqMfWAZefecTqVWnm0ovw5ioLtX2NC4btumYhw+RyRCr4A4cuznaNBmfwzmSJc3LpwXvvAADca4VYE0mrSEGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738340839; c=relaxed/simple;
	bh=dtU3sxEnVvbyldeuyQdn1Kkmw5t5fisuqMXg6psYWpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRjNS5QeoLZFSYiFV/FW2OIbKObrtMzIFy63ffEkTe8tKCUerRPsdVI66OK91OovEqoEN+1cxKBMFxq9x/gVjXjQdLr3di14CbICHIDW808lU1FBQOkxr9dUES2GJ/4QfhsQOtJElddR8d2XGFG67GqXJTgl4STpPsWGt4ciQPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=im8bLcSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="im8bLcSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E063C4CED3;
	Fri, 31 Jan 2025 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738340839;
	bh=dtU3sxEnVvbyldeuyQdn1Kkmw5t5fisuqMXg6psYWpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=im8bLcSDWDgjlT0W/0LJgRTOIAc4OOl5W9zTiA5C5egXAk5u2iUoLufQrtqCdHCbA
	 wX5VE3/8aVHUriyTNZFxd4mMYXC9ZtMrztkW7TDMR+FhstOGdsIjRWwddY3Pr24H7f
	 T7G8KEOgBKu/7RcMABFODvF8hQ0rKAW/6ErTZlNiLoDrfBMeBC152IDpBvmWpEYhyn
	 7NcN4gPOzz6FYnb9xgGQ1ZPW8lVW6JXB3b/NB6has/U+lq5rVhUYJlHT4mrBlelxep
	 bI9D670o5iCF1WXhRC0neth3zmjBWTN2ggqDxTuRVYv68vXV5i2VVqGJ3zxPTweTJr
	 fbp8ITymlSFNg==
Date: Fri, 31 Jan 2025 17:27:13 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, dchinner@redhat.com, 
	hch@lst.de
Subject: Re: [PATCH V2] xfs: Do not allow norecovery mount with quotacheck
Message-ID: <p37aojs3slqjn4ob566fgpdiknbifn65cileh3tj63e5yimj4d@xcqzxue3d3px>
References: <20250131100302.15430-1-cem@kernel.org>
 <cIPmaW81e_qUtSjwffZo769u2On8_AgVFWj5kiyM1w_JAXFIg21QhWWwe0D5QYZJySJThy8z00AaIxdldNdOkg==@protonmail.internalid>
 <20250131161806.GU1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250131161806.GU1611770@frogsfrogsfrogs>

On Fri, Jan 31, 2025 at 08:18:06AM -0800, Darrick J. Wong wrote:
> On Fri, Jan 31, 2025 at 11:02:54AM +0100, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > Mounting a filesystem that requires quota state changing will generate a
> > transaction.
> >
> > We already check for a read-only device; we should do that for
> > norecovery too.
> >
> > A quotacheck on a norecovery mount, and with the right log size, will cause
> > the mount process to hang on:
> >
> > [<0>] xlog_grant_head_wait+0x5d/0x2a0 [xfs]
> > [<0>] xlog_grant_head_check+0x112/0x180 [xfs]
> > [<0>] xfs_log_reserve+0xe3/0x260 [xfs]
> > [<0>] xfs_trans_reserve+0x179/0x250 [xfs]
> > [<0>] xfs_trans_alloc+0x101/0x260 [xfs]
> > [<0>] xfs_sync_sb+0x3f/0x80 [xfs]
> > [<0>] xfs_qm_mount_quotas+0xe3/0x2f0 [xfs]
> > [<0>] xfs_mountfs+0x7ad/0xc20 [xfs]
> > [<0>] xfs_fs_fill_super+0x762/0xa50 [xfs]
> > [<0>] get_tree_bdev_flags+0x131/0x1d0
> > [<0>] vfs_get_tree+0x26/0xd0
> > [<0>] vfs_cmd_create+0x59/0xe0
> > [<0>] __do_sys_fsconfig+0x4e3/0x6b0
> > [<0>] do_syscall_64+0x82/0x160
> > [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> > This is caused by a transaction running with bogus initialized head/tail
> >
> > I initially hit this while running generic/050, with random log
> > sizes, but I managed to reproduce it reliably here with the steps
> > below:
> >
> > mkfs.xfs -f -lsize=1025M -f -b size=4096 -m crc=1,reflink=1,rmapbt=1, -i
> > sparse=1 /dev/vdb2 > /dev/null
> > mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt
> > xfs_io -x -c 'shutdown -f' /mnt
> > umount /mnt
> > mount -o ro,norecovery,usrquota,grpquota,prjquota  /dev/vdb2 /mnt
> >
> > Last mount hangs up
> >
> > As we add yet another validation if quota state is changing, this also
> > add a new helper named xfs_qm_validate(), factoring the quota state
> > changes out of xfs_qm_newmount() to reduce cluttering within it.
> >
> > As per Darrick suggestion, add a new, different  warning message if
> > metadir is enabled.
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > Signed-off-by: Carlos Maiolino <cem@kernel.org>
> > ---
> >
> > Changelog V1->V2:
> > 	- Issue a different warn message in case metadir is enabled
> > 	- Factour out quota state validator code to a new helper
> > 	- Change patch subject to reduce length
> >
> >
> >  fs/xfs/xfs_qm_bhv.c | 55 ++++++++++++++++++++++++++++++++-------------
> >  1 file changed, 39 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> > index 37f1230e7584..a6a7870401c3 100644
> > --- a/fs/xfs/xfs_qm_bhv.c
> > +++ b/fs/xfs/xfs_qm_bhv.c
> > @@ -78,6 +78,28 @@ xfs_qm_statvfs(
> >  	}
> >  }
> >
> > +STATIC int
> > +xfs_qm_validate(
> 
> This validates ... what exactly?
> 
> Oh, it validates that we can actually make the state change.
> 
> xfs_qm_validate_state_change(), perhaps ?

Yeah, I thought the name would be too big, but indeed looks decent

> 
> > +	xfs_mount_t	*mp,
> 
> Please don't introduce more typedef usage.

Ditto, my bad, will fix.

> 
> 	struct xfs_mount	*mp,
> 
> > +	uint		uqd,
> > +	uint		gqd,
> > +	uint		pqd)
> > +{
> > +	int state;
> > +
> > +	/* Is quota state changing? */
> > +	state = ((uqd && !XFS_IS_UQUOTA_ON(mp)) ||
> > +		(!uqd &&  XFS_IS_UQUOTA_ON(mp)) ||
> > +		 (gqd && !XFS_IS_GQUOTA_ON(mp)) ||
> > +		(!gqd &&  XFS_IS_GQUOTA_ON(mp)) ||
> > +		 (pqd && !XFS_IS_PQUOTA_ON(mp)) ||
> > +		(!pqd &&  XFS_IS_PQUOTA_ON(mp)));
> > +
> > +	return  state &&
> > +		(xfs_dev_is_read_only(mp, "changing quota state") ||
> > +		xfs_has_norecovery(mp));
> > +}
> > +
> >  int
> >  xfs_qm_newmount(
> >  	xfs_mount_t	*mp,
> > @@ -97,24 +119,25 @@ xfs_qm_newmount(
> >  	}
> >
> >  	/*
> > -	 * If the device itself is read-only, we can't allow
> > -	 * the user to change the state of quota on the mount -
> > -	 * this would generate a transaction on the ro device,
> > -	 * which would lead to an I/O error and shutdown
> > +	 * If the device itself is read-only and/or in norecovery
> > +	 * mode, we can't allow the user to change the state of
> > +	 * quota on the mount - this would generate a transaction
> > +	 * on the ro device, which would lead to an I/O error and
> > +	 * shutdown.
> >  	 */
> >
> > -	if (((uquotaondisk && !XFS_IS_UQUOTA_ON(mp)) ||
> > -	    (!uquotaondisk &&  XFS_IS_UQUOTA_ON(mp)) ||
> > -	     (gquotaondisk && !XFS_IS_GQUOTA_ON(mp)) ||
> > -	    (!gquotaondisk &&  XFS_IS_GQUOTA_ON(mp)) ||
> > -	     (pquotaondisk && !XFS_IS_PQUOTA_ON(mp)) ||
> > -	    (!pquotaondisk &&  XFS_IS_PQUOTA_ON(mp)))  &&
> > -	    xfs_dev_is_read_only(mp, "changing quota state")) {
> > -		xfs_warn(mp, "please mount with%s%s%s%s.",
> > -			(!quotaondisk ? "out quota" : ""),
> > -			(uquotaondisk ? " usrquota" : ""),
> > -			(gquotaondisk ? " grpquota" : ""),
> > -			(pquotaondisk ? " prjquota" : ""));
> > +	if (xfs_qm_validate(mp, uquotaondisk,
> > +			    gquotaondisk, pquotaondisk)) {
> > +
> > +		if (xfs_has_metadir(mp))
> > +			xfs_warn(mp,
> > +			       "metadir enabled, please mount withouth quotas");
> 
> "metadir enabled, please mount without any quota mount options"

Thanks for the review, V3 soon.


> 
> --D
> 
> > +		else
> > +			xfs_warn(mp, "please mount with%s%s%s%s.",
> > +				(!quotaondisk ? "out quota" : ""),
> > +				(uquotaondisk ? " usrquota" : ""),
> > +				(gquotaondisk ? " grpquota" : ""),
> > +				(pquotaondisk ? " prjquota" : ""));
> >  		return -EPERM;
> >  	}
> >
> > --
> > 2.48.1
> >
> >
> 
