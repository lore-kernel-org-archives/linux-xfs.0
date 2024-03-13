Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E097A47A6B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 15:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710344934; cv=none; b=dlKbJOGEHiSb8SAyP9Abse8HeN1LnYKCioK6mj+WGu2ZfJy4h6FTJMYHSLMj53jaUCYaowhAtjDNPD6lUAiamFA5hax7SepUE7VmlkN4IyDzeytB2PPA9+TqEo1c8YmfvPPZCXIBl2vQTsEFd4NFc8ZndP2D9ngyEjWSlKY/xzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710344934; c=relaxed/simple;
	bh=ot/RSbPkSFDGscCbzUd27Pvelmgybg1r5IyKbvWG/0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t8rlpjTcSATT0SuKnUKAq5R1PYZcIbMbR7tqJzU+CbBCrAF8gwxjxNrwvK4b3jIf+0YO6dGa+XpQZKFZqd0/db54hLXtPddd09G6oxsVLryomJAfm/ykdGAoWnr5d0Jdp5OpKhL6kFJRREdGrAhb3KCuSXg/K5Dtww0w50Pza8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ma9QF6fc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ma9QF6fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCC3C433C7;
	Wed, 13 Mar 2024 15:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710344933;
	bh=ot/RSbPkSFDGscCbzUd27Pvelmgybg1r5IyKbvWG/0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ma9QF6fcxaPhluO7jKO3VwwhZ6FvAPaHKSKAeRsDWEOWb01jx4Nh49UfcElhGLMO8
	 aweek4cS3XGcqaqHZgE458dHMKACDKz/bXAuW566uZVrNLxZAYEU8bk0bYhsZjbgu/
	 999yJVkEOSYGBYUZ9V1ElbyHtkRDqVFc4tokmEKoAPiubtli8YBSpGXA5DY9KQ1vgt
	 rFTFLL5FO3ppowAidTcoz3dfdE86kCtGnEIkVZ/kImRLLDEu2F2+vCAT40+Jruygfp
	 ydumT7LyYnXlCRBlh2Ee/5paGcrEoLU1fSx8Hs2H1qoPh/GetH9HVnZrQEoVA7iUsX
	 zM1Cbv2vh1HJg==
Date: Wed, 13 Mar 2024 08:48:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: allow sunit mount option to repair bad primary sb
 stripe values
Message-ID: <20240313154852.GL1927156@frogsfrogsfrogs>
References: <20240312233006.2461827-1-david@fromorbit.com>
 <20240313045634.GK1927156@frogsfrogsfrogs>
 <ZfFCHHWsQ3ucGo3C@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfFCHHWsQ3ucGo3C@dread.disaster.area>

On Wed, Mar 13, 2024 at 05:05:16PM +1100, Dave Chinner wrote:
> On Tue, Mar 12, 2024 at 09:56:34PM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 13, 2024 at 10:30:06AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > If a filesystem has a busted stripe alignment configuration on disk
> > > (e.g. because broken RAID firmware told mkfs that swidth was smaller
> > > than sunit), then the filesystem will refuse to mount due to the
> > > stripe validation failing. This failure is triggering during distro
> > > upgrades from old kernels lacking this check to newer kernels with
> > > this check, and currently the only way to fix it is with offline
> > > xfs_db surgery.
> > > 
> > > This runtime validity checking occurs when we read the superblock
> > > for the first time and causes the mount to fail immediately. This
> > > prevents the rewrite of stripe unit/width via
> > > mount options that occurs later in the mount process. Hence there is
> > > no way to recover this situation without resorting to offline xfs_db
> > > rewrite of the values.
> > > 
> > > However, we parse the mount options long before we read the
> > > superblock, and we know if the mount has been asked to re-write the
> > > stripe alignment configuration when we are reading the superblock
> > > and verifying it for the first time. Hence we can conditionally
> > > ignore stripe verification failures if the mount options specified
> > > will correct the issue.
> > > 
> > > We validate that the new stripe unit/width are valid before we
> > > overwrite the superblock values, so we can ignore the invalid config
> > > at verification and fail the mount later if the new values are not
> > > valid. This, at least, gives users the chance of correcting the
> > > issue after a kernel upgrade without having to resort to xfs-db
> > > hacks.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_sb.c | 40 +++++++++++++++++++++++++++++++---------
> > >  fs/xfs/libxfs/xfs_sb.h |  3 ++-
> > >  2 files changed, 33 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index d991eec05436..f51b1efa2cae 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -530,7 +530,8 @@ xfs_validate_sb_common(
> > >  	}
> > >  
> > >  	if (!xfs_validate_stripe_geometry(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
> > > -			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
> > > +			XFS_FSB_TO_B(mp, sbp->sb_width), 0,
> > > +			xfs_buf_daddr(bp) == XFS_SB_DADDR, false))
> > >  		return -EFSCORRUPTED;
> > >  
> > >  	/*
> > > @@ -1323,8 +1324,10 @@ xfs_sb_get_secondary(
> > >  }
> > >  
> > >  /*
> > > - * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
> > > - * so users won't be confused by values in error messages.
> > > + * sunit, swidth, sectorsize(optional with 0) should be all in bytes, so users
> > > + * won't be confused by values in error messages. This returns false if a value
> > > + * is invalid and it is not the primary superblock that going to be corrected
> > > + * later in the mount process.
> > 
> > Hmm, I found this last sentence a little confusing.  How about:
> > 
> > "This function returns false if the stripe geometry is invalid and no
> > attempt will be made to correct it later in the mount process."
> 
> Sure.
> 
> .....
> > > @@ -1375,9 +1379,27 @@ xfs_validate_stripe_geometry(
> > >  			xfs_notice(mp,
> > >  "stripe width (%lld) must be a multiple of the stripe unit (%lld)",
> > >  				   swidth, sunit);
> > > -		return false;
> > > +		goto check_override;
> > >  	}
> > >  	return true;
> > > +
> > > +check_override:
> > > +	if (!primary_sb)
> > > +		return false;
> > > +	/*
> > > +	 * During mount, mp->m_dalign will not be set unless the sunit mount
> > > +	 * option was set. If it was set, ignore the bad stripe alignment values
> > > +	 * and allow the validation and overwrite later in the mount process to
> > > +	 * attempt to overwrite the bad stripe alignment values with the values
> > > +	 * supplied by mount options.
> > 
> > What catches the case of if m_dalign/m_swidth also being garbage values?
> > Is it xfs_check_new_dalign?  Should that fail the mount if the
> > replacement values are also garbage?
> 
> xfs_validate_new_dalign().
> 
> It returns -EINVAL is the new striped alignment cannot be used (i.e.
> not aligned to block or ag sizes) and that causes the mount to fail.

Ok good.

> > > diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> > > index 67a40069724c..58798b9c70ba 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.h
> > > +++ b/fs/xfs/libxfs/xfs_sb.h
> > > @@ -35,7 +35,8 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
> > >  				struct xfs_buf **bpp);
> > >  
> > >  extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
> > 
> > This declaration might as well lose the extern here too.
> > 
> > > -		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
> > > +		__s64 sunit, __s64 swidth, int sectorsize, bool primary_sb,
> > > +		bool silent);
> > 
> > What should value for @primary_sb should mkfs pass into
> > xfs_validate_stripe_geometry from calc_stripe_factors?
> 
> Userspace problem, really. i.e. mkfs is already abusing this
> function by passing a NULL xfs_mount and so will crash if the
> function tries to dereference mp. Hence it can pass false for
> "primary_sb" so it doesn't run any of the kernel side primary sb
> recovery code that dereferences mp because it doesn't need to
> (can't!) run it.

At least it's mkfs so there's nothing /to/ recover ;)

I've vaguely wondered if this function ought to drop the @mp argument
and instead pass back an error enum, and then the caller can decide if
it wants to emit a message or do something else.  That would be a
worthwhile cleanup for the lurking logic bomb in mkfs; maybe I'll try to
code something up later.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
