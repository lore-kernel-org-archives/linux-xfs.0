Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70A412E4E
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 06:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710309923; cv=none; b=biyubHTNWLO7fisEDwFqpnDBxjkwz57O1rZ4rdjNQ1CYklk9tof3AnyUlheUzAEBusxG8u2vpB6VmWxd4BMM8l8ZnYlELUq05LBA13KkG1kuuwx69l+dNac087VecV2I2BkWAQ3sORGv0VlGAxgz9qIKKWqxKrkFGeiIV5mmbSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710309923; c=relaxed/simple;
	bh=GO6EFi9SSjErkC6LOikYC8AFYP7lDEuZNqeg1U+8SsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnROb+DxPiLTdB7rBtE07y6+0EZ/VdhvsnmRGLkgzJ0dlNpC8PZxTR4gqBOJDAaT7CDP6FdK+46Frbh45acE/BKm5mqKZbV3QqFin/HR0jhoe77dNFgQvCdPjlwg7OPuOVuRWx+DpQzAnaUCVPy+N69gN2TvxHmd6LgkL7BjkC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=KXzQMNlU; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KXzQMNlU"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5cdbc4334edso3257010a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Mar 2024 23:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710309921; x=1710914721; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Decu8a9QVAA8Nq3EJtwoTowmFKJQJZbkttNc1ud4qs=;
        b=KXzQMNlU5HllsnzFqz1H9McNsl78lnTqPz/ryJE5THfItHC7pvzsVt9YqRndncRPRB
         vvzdMRju5rfdYvO4H9rqJ+aWiX0F+d0b0+rR6gG/ffy1SomZwIvVUD9aivIaWMAevEp0
         dUjzQ68i1qSLWnuqG2enxSnDwzgpwfydw9dzU7HuKpnrdYlxgyV7fOlTitKJBxdvabr9
         3hrN958sqIMGN/TGz+ihISPQh/webmQL6Ibe1PkVM26q819c/N1x/W+3RPei3HmdOysY
         sK3V8DvmYYZyFme9MSzYe1ZHsAE76KdQ2OBtHEapKhgnyTJ3+zcrPdgwcDxkusXqv5B8
         ///w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710309921; x=1710914721;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Decu8a9QVAA8Nq3EJtwoTowmFKJQJZbkttNc1ud4qs=;
        b=TvEEZspBBLUXpSwtFp5US9uReU5sfhOja5cWeUnmmJInj+/bGda+xBnjYH2e3yIpsb
         geNAB9mTMtnRGGCgU/pWNQOhemtTjC82aNqvmaL8ymuyWRdKR1fqB/7EpCEFu11mHFj6
         +IH/GMHybNz6MnDW8v/trtLjO8ZgeLMg5vqEyRZdoNnnn8pcE8wddjvm8N+hMBDj/YV+
         6ymQOGAto+5rsa3LlBuZpPrUfRCawPe+5s5cZFrzVdFV9LEjc2CJoPm/kpjHkzeTP2OW
         M++X7zR6VPb4vDI7d8JzIbEz8iuJQ8mGis1rCOenx073DWm6aMBEyhH+3A17RIosrTkr
         021Q==
X-Gm-Message-State: AOJu0Yxgtn6NMu3o3OdI5EhtmPipLAcGbJ9t54SsXoi1vPJGswW9hSIx
	1U1PgVqQwW5t85U/0ku76VfZPyGEWjRx5BiMD2oavCxwsZ72J8yy/jg3bSCPHo2n8AJQfkj3P7a
	h
X-Google-Smtp-Source: AGHT+IHBWddjNAIS94SRVtVCZptupnD5pYPWRXALFB6WyMMPv3lSEcl518wu1KGVwhh2XVvVxM3QsQ==
X-Received: by 2002:a05:6a20:b288:b0:1a1:8899:a2b0 with SMTP id ei8-20020a056a20b28800b001a18899a2b0mr7467968pzb.52.1710309920785;
        Tue, 12 Mar 2024 23:05:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-47-118.pa.nsw.optusnet.com.au. [49.179.47.118])
        by smtp.gmail.com with ESMTPSA id gt2-20020a17090af2c200b0029af5587889sm581596pjb.12.2024.03.12.23.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 23:05:20 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rkHjo-001Edq-37;
	Wed, 13 Mar 2024 17:05:16 +1100
Date: Wed, 13 Mar 2024 17:05:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: allow sunit mount option to repair bad primary sb
 stripe values
Message-ID: <ZfFCHHWsQ3ucGo3C@dread.disaster.area>
References: <20240312233006.2461827-1-david@fromorbit.com>
 <20240313045634.GK1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240313045634.GK1927156@frogsfrogsfrogs>

On Tue, Mar 12, 2024 at 09:56:34PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 13, 2024 at 10:30:06AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If a filesystem has a busted stripe alignment configuration on disk
> > (e.g. because broken RAID firmware told mkfs that swidth was smaller
> > than sunit), then the filesystem will refuse to mount due to the
> > stripe validation failing. This failure is triggering during distro
> > upgrades from old kernels lacking this check to newer kernels with
> > this check, and currently the only way to fix it is with offline
> > xfs_db surgery.
> > 
> > This runtime validity checking occurs when we read the superblock
> > for the first time and causes the mount to fail immediately. This
> > prevents the rewrite of stripe unit/width via
> > mount options that occurs later in the mount process. Hence there is
> > no way to recover this situation without resorting to offline xfs_db
> > rewrite of the values.
> > 
> > However, we parse the mount options long before we read the
> > superblock, and we know if the mount has been asked to re-write the
> > stripe alignment configuration when we are reading the superblock
> > and verifying it for the first time. Hence we can conditionally
> > ignore stripe verification failures if the mount options specified
> > will correct the issue.
> > 
> > We validate that the new stripe unit/width are valid before we
> > overwrite the superblock values, so we can ignore the invalid config
> > at verification and fail the mount later if the new values are not
> > valid. This, at least, gives users the chance of correcting the
> > issue after a kernel upgrade without having to resort to xfs-db
> > hacks.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_sb.c | 40 +++++++++++++++++++++++++++++++---------
> >  fs/xfs/libxfs/xfs_sb.h |  3 ++-
> >  2 files changed, 33 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index d991eec05436..f51b1efa2cae 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -530,7 +530,8 @@ xfs_validate_sb_common(
> >  	}
> >  
> >  	if (!xfs_validate_stripe_geometry(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
> > -			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
> > +			XFS_FSB_TO_B(mp, sbp->sb_width), 0,
> > +			xfs_buf_daddr(bp) == XFS_SB_DADDR, false))
> >  		return -EFSCORRUPTED;
> >  
> >  	/*
> > @@ -1323,8 +1324,10 @@ xfs_sb_get_secondary(
> >  }
> >  
> >  /*
> > - * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
> > - * so users won't be confused by values in error messages.
> > + * sunit, swidth, sectorsize(optional with 0) should be all in bytes, so users
> > + * won't be confused by values in error messages. This returns false if a value
> > + * is invalid and it is not the primary superblock that going to be corrected
> > + * later in the mount process.
> 
> Hmm, I found this last sentence a little confusing.  How about:
> 
> "This function returns false if the stripe geometry is invalid and no
> attempt will be made to correct it later in the mount process."

Sure.

.....
> > @@ -1375,9 +1379,27 @@ xfs_validate_stripe_geometry(
> >  			xfs_notice(mp,
> >  "stripe width (%lld) must be a multiple of the stripe unit (%lld)",
> >  				   swidth, sunit);
> > -		return false;
> > +		goto check_override;
> >  	}
> >  	return true;
> > +
> > +check_override:
> > +	if (!primary_sb)
> > +		return false;
> > +	/*
> > +	 * During mount, mp->m_dalign will not be set unless the sunit mount
> > +	 * option was set. If it was set, ignore the bad stripe alignment values
> > +	 * and allow the validation and overwrite later in the mount process to
> > +	 * attempt to overwrite the bad stripe alignment values with the values
> > +	 * supplied by mount options.
> 
> What catches the case of if m_dalign/m_swidth also being garbage values?
> Is it xfs_check_new_dalign?  Should that fail the mount if the
> replacement values are also garbage?

xfs_validate_new_dalign().

It returns -EINVAL is the new striped alignment cannot be used (i.e.
not aligned to block or ag sizes) and that causes the mount to fail.

> > diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> > index 67a40069724c..58798b9c70ba 100644
> > --- a/fs/xfs/libxfs/xfs_sb.h
> > +++ b/fs/xfs/libxfs/xfs_sb.h
> > @@ -35,7 +35,8 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
> >  				struct xfs_buf **bpp);
> >  
> >  extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
> 
> This declaration might as well lose the extern here too.
> 
> > -		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
> > +		__s64 sunit, __s64 swidth, int sectorsize, bool primary_sb,
> > +		bool silent);
> 
> What should value for @primary_sb should mkfs pass into
> xfs_validate_stripe_geometry from calc_stripe_factors?

Userspace problem, really. i.e. mkfs is already abusing this
function by passing a NULL xfs_mount and so will crash if the
function tries to dereference mp. Hence it can pass false for
"primary_sb" so it doesn't run any of the kernel side primary sb
recovery code that dereferences mp because it doesn't need to
(can't!) run it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
