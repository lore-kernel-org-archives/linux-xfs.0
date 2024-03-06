Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FE21B275
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 21:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709761427; cv=none; b=r5Vn3Z1BqC0Yj/TIdxM1jFtBIXMmjn+ZGxMCsGpRxKwCS0kTSCmyQYoD06Fp0G9olirs9lvPS8e45LPy/XTsXmksmDNfFec5Wvtv7Jw4HN0QLzvLGjqPDil6MZ84qaFrDQM+HJvP2kfjc1bI52UEsStBFvv3z0EjfxBc8cvxWwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709761427; c=relaxed/simple;
	bh=uukPMIgwelsrQgoZrhNPDN+BN9GWpaoxf+QYnlNhnWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3jYIC60PkiX7roC/n+xN7483GGvrf9efPfiv/d77/knAKtDjh/QDevvzRiBTmE5dNqS0TEy8pYQVDuFIa1C6uJu3XtMBvoScDS1bclRGBH4Ocf5pSUA4hpp/RpIT10nGrjVU7AKCYt48fblk1fZkrsNXPmqOWesczNZBZ41kjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=H9yxAKaM; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="H9yxAKaM"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dd0d46ecc3so1789245ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 06 Mar 2024 13:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709761425; x=1710366225; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OqS1D1xnlEZxU/gt8FOXzyqGq6KDWn8HMHjTQCSCX2s=;
        b=H9yxAKaMz5Bi1v54O8NH2L9tuUWEBQqZFPPshApg2UvqPeme5FHfDFiDMWXi51zN24
         F+ldSy6B4o97D5dxTdbaNsM+oMcfOtukyyagn/yRO8DpvEIXz4ZCi2R5NbrFcGx6C4bZ
         EwubEcHdIzl2C4ZcMbQH+R5PnqMF1GWlcE/FHReWhV8UvyzUaI6YYxPoA1C2qVoySl0i
         aWP3rxm3qGbJ9kpXcn6xH66YWU4I51myYTTOWK05PadxCH2HT4zUvD+737D1HCtvUxEN
         kMmE4DFX8hyBrUjwnn9BVCrSQNKfVaL5ZFU1HirB4g0drhfn2tYo6a6wK7xbY0TTWnPS
         q4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709761425; x=1710366225;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OqS1D1xnlEZxU/gt8FOXzyqGq6KDWn8HMHjTQCSCX2s=;
        b=HTG82xXG+hnHKmAgmTPGYiryq9ajfSCqCdOoMdBgmFqGeHWadjZgqYX/DlmPMi1A3M
         9xDgrd+fDpH5OIyGkQHuT4ZPjKvDhpFFjwH/leWelEdb2XEsjrKGRWkxSEA426QeXhH2
         L92vNtYmGhykDtFafQpMRhcihGy3kqy2Z23mKSQ8sj2kxbyaErH6u+y8jExotDlUDRzp
         X3vg3gjhy9wEM3FozWoEN1lpFT0xAIsBvoUcc9Dl/jFDAy7iZvsXvPQctVwbC5BvlZ6t
         cQRIku8HdxN4qwKxOaYaWSmSXY/kpsGkcLK79yQneVNWDaRoEhtikTjA9XIK/ncuavR8
         R0ig==
X-Forwarded-Encrypted: i=1; AJvYcCVwb1Ah3KLa8+7elMTa74u2nWS8hZS/z5uEgpZk1/9uuM0uSFrUWBbWjStky5bFfJrSkWbuGeSEL9vLmT32lUMLK+PCBWhu1eJA
X-Gm-Message-State: AOJu0YzCKP7Ri5JBpE5N40mA+4EhUXnXvlyo1no3sJQKre0jmnXtrtt1
	mUr252+GQmBzvzxH2sq1Mayhswm70teDjOpXy6UaToURkMLxiTm6EHtIZd33bQw=
X-Google-Smtp-Source: AGHT+IGeAaHtQgnkvyhYEwMigv8RchqGrHd9eF0DQABn9eQLnjlAJuXr7YDlVieSKvKTjcYUqxdROQ==
X-Received: by 2002:a17:902:8608:b0:1dd:39:d651 with SMTP id f8-20020a170902860800b001dd0039d651mr6244636plo.69.1709761424794;
        Wed, 06 Mar 2024 13:43:44 -0800 (PST)
Received: from dread.disaster.area (pa49-179-47-118.pa.nsw.optusnet.com.au. [49.179.47.118])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902650d00b001dcc97aa8fasm13370249plk.17.2024.03.06.13.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 13:43:44 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rhz37-00Fygs-2L;
	Thu, 07 Mar 2024 08:43:41 +1100
Date: Thu, 7 Mar 2024 08:43:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: djwong@kernel.org, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, chandan.babu@oracle.com,
	axboe@kernel.dk, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	ojaswin@linux.ibm.com, ritesh.list@gmail.com,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v2 11/14] fs: xfs: Support FS_XFLAG_ATOMICWRITES for
 forcealign
Message-ID: <ZejjjaTFPi+qEDgS@dread.disaster.area>
References: <20240304130428.13026-1-john.g.garry@oracle.com>
 <20240304130428.13026-12-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240304130428.13026-12-john.g.garry@oracle.com>

On Mon, Mar 04, 2024 at 01:04:25PM +0000, John Garry wrote:
> Add initial support for FS_XFLAG_ATOMICWRITES for forcealign enabled.
> 
> Current kernel support for atomic writes is based on HW support (for atomic
> writes). As such, it is required to ensure extent alignment with
> atomic_write_unit_max so that an atomic write can result in a single
> HW-compliant IO operation.
> 
> rtvol also guarantees extent alignment, but we are basing support initially
> on forcealign, which is not supported for rtvol yet.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
....
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 2d9f5430efc3..5f54f9b3755e 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -354,12 +354,16 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
>  #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
>  #define XFS_SB_FEAT_RO_COMPAT_FORCEALIGN (1 << 30)	/* aligned file data extents */
> +#define XFS_SB_FEAT_RO_COMPAT_ATOMICWRITES (1 << 31)	/* atomicwrites enabled */
> +
>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
>  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
> -		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT | \
> -		 XFS_SB_FEAT_RO_COMPAT_FORCEALIGN)
> +		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT| \
> +		 XFS_SB_FEAT_RO_COMPAT_FORCEALIGN| \

Please leave a spave between the feature name and the '| \'.

> +		 XFS_SB_FEAT_RO_COMPAT_ATOMICWRITES)
> +
>  #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
>  static inline bool
>  xfs_sb_has_ro_compat_feature(
> @@ -1089,6 +1093,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
>  /* data extent mappings for regular files must be aligned to extent size hint */
>  #define XFS_DIFLAG2_FORCEALIGN_BIT 5
> +#define XFS_DIFLAG2_ATOMICWRITES_BIT 6
>  
>  #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
>  #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
> @@ -1096,10 +1101,12 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
>  #define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
>  #define XFS_DIFLAG2_FORCEALIGN	(1 << XFS_DIFLAG2_FORCEALIGN_BIT)
> +#define XFS_DIFLAG2_ATOMICWRITES	(1 << XFS_DIFLAG2_ATOMICWRITES_BIT)
>  
>  #define XFS_DIFLAG2_ANY \
>  	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
> -	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_FORCEALIGN)
> +	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_FORCEALIGN | \
> +	 XFS_DIFLAG2_ATOMICWRITES)
>  
>  static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
>  {
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index f2c16a028fae..d7bb3e34dd69 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -165,6 +165,8 @@ xfs_sb_version_to_features(
>  		features |= XFS_FEAT_INOBTCNT;
>  	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FORCEALIGN)
>  		features |= XFS_FEAT_FORCEALIGN;
> +	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_ATOMICWRITES)
> +		features |= XFS_FEAT_ATOMICWRITES;
>  	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
>  		features |= XFS_FEAT_FTYPE;
>  	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index bbb8886f1d32..14020ab1450c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -645,6 +645,8 @@ xfs_ip2xflags(
>  			flags |= FS_XFLAG_COWEXTSIZE;
>  		if (ip->i_diflags2 & XFS_DIFLAG2_FORCEALIGN)
>  			flags |= FS_XFLAG_FORCEALIGN;
> +		if (ip->i_diflags2 & XFS_DIFLAG2_ATOMICWRITES)
> +			flags |= FS_XFLAG_ATOMICWRITES;
>  	}
>  
>  	if (xfs_inode_has_attr_fork(ip))
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index b6c42c27943e..f56bdbb74ad7 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -310,6 +310,11 @@ static inline bool xfs_inode_forcealign(struct xfs_inode *ip)
>  	return ip->i_diflags2 & XFS_DIFLAG2_FORCEALIGN;
>  }
>  
> +static inline bool xfs_inode_atomicwrites(struct xfs_inode *ip)
> +{
> +	return ip->i_diflags2 & XFS_DIFLAG2_ATOMICWRITES;
> +}

I'd really like this to be more readable:
xfs_inode_has_atomic_writes().

Same for the force align check, now that I notice it:
xfs_inode_has_force_align().

> +
>  /*
>   * Return the buftarg used for data allocations on a given inode.
>   */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 867d8d51a3d0..f118a1ae39b5 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1112,6 +1112,8 @@ xfs_flags2diflags2(
>  		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  	if (xflags & FS_XFLAG_FORCEALIGN)
>  		di_flags2 |= XFS_DIFLAG2_FORCEALIGN;
> +	if (xflags & FS_XFLAG_ATOMICWRITES)
> +		di_flags2 |= XFS_DIFLAG2_ATOMICWRITES;
>  
>  	return di_flags2;
>  }
> @@ -1124,10 +1126,12 @@ xfs_ioctl_setattr_xflags(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	bool			rtflag = (fa->fsx_xflags & FS_XFLAG_REALTIME);
> +	bool			atomic_writes = fa->fsx_xflags & FS_XFLAG_ATOMICWRITES;
>  	uint64_t		i_flags2;
>  
> -	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
> -		/* Can't change realtime flag if any extents are allocated. */
> +	/* Can't change RT or atomic flags if any extents are allocated. */
> +	if (rtflag != XFS_IS_REALTIME_INODE(ip) ||
> +	    atomic_writes != xfs_inode_atomicwrites(ip)) {
>  		if (ip->i_df.if_nextents || ip->i_delayed_blks)
>  			return -EINVAL;
>  	}
> @@ -1164,6 +1168,13 @@ xfs_ioctl_setattr_xflags(
>  			return -EINVAL;
>  	}
>  
> +	if (atomic_writes) {
> +		if (!xfs_has_atomicwrites(mp))
> +			return -EINVAL;

That looks wrong - if we are trying to turn on atomic writes, then
shouldn't this be returning an error if atomic writes are already
configured?

> +		if (!(fa->fsx_xflags & FS_XFLAG_FORCEALIGN))
> +			return -EINVAL;

Where's the check for xfs_has_atomicwrites(mp) here? We can't allow
this inode flag to be set if the superblock does not have the
feature bit that says it's a known feature bit set.

Which reminds me: both the forcealign and the atomicwrite inode flag
need explicit checking in the inode verifier. i.e. checking that if
the inode flag bit is set, the relevant superblock feature bit is
set.

....
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 74dcafddf6a9..efe4b4234b2e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1712,6 +1712,10 @@ xfs_fs_fill_super(
>  		xfs_warn(mp,
>  "EXPERIMENTAL forced data extent alignment feature in use. Use at your own risk!");
>  
> +	if (xfs_has_atomicwrites(mp))
> +		xfs_warn(mp,
> +"EXPERIMENTAL atomicwrites feature in use. Use at your own risk!");

"EXPERIMENTAL atomic write IO feature is in use. Use at your own risk!");

-Dave.
-- 
Dave Chinner
david@fromorbit.com
