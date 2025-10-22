Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1406835B121;
	Wed, 22 Oct 2025 16:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761149523; cv=none; b=LjPkx/sMduy2wk42uS2teM826FP2f89M2M/QFKosEtdpEVc27r2QyC0TSG+7UEgF/SoiKwexzObVbFQAorVZ0DIHlQ9nchRbfRYfI3KJ1A11DxzJx6QbcU7O8eZH/USAwUsZ6QRkhCKVaIybVkB/ZMwb5JsNdwEPRyxfdkNQ1kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761149523; c=relaxed/simple;
	bh=AjmDQ+nkEwesZ4wY/xTAfi7/c3fMFdEeUmW/V+xDmGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VW0ZoDuRV4L88s8u9ndAd68qC8JqH4M+QASSSbYJOnTfv9X3l44tRHZzyuUnaosXcYiSHFbRTWEL26VhWcO7hE1DMq3DmAhTs25U7mLymC0LAA1YZLwHO6zV4z6lD0ZuSoAz1pa4zFAZc3HkJ/hsFpxaDlCV7mL+cvoWfACaQng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pvVF5irx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pvVF5irx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EBFC4CEE7;
	Wed, 22 Oct 2025 16:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761149522;
	bh=AjmDQ+nkEwesZ4wY/xTAfi7/c3fMFdEeUmW/V+xDmGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pvVF5irx0L426TzVrHlus1fd8nHnWCvtXXmTZ4/24eCZPVPo6K0B2FNGpANU1k3pf
	 NKtx6cLrjhnmhAoeX/lmuBCOZlMXucdac8KML/AxkltQqNFlzjg4KH/JbpUWCKRjPJ
	 NoYZn9HMDyGAE3NFi+rCxxR7vf3t6bAglLQyos0FVUoOc8XoUT/JTvpdN3JQdLMX85
	 3GywjywWvzz7GH1MTO5pIEchN2uT4ZctSSuFEXuxWrajpUKQEPJwkp76htyFqNInOd
	 OSNI2ng6LS2mtfCsHTrQPJQw9wK7k3cE3Fw5MBUA3jECGksG1xk3wXJq+vPXdq71RN
	 2TGq/pPeM3HEA==
Date: Wed, 22 Oct 2025 09:12:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: always warn about deprecated mount options
Message-ID: <20251022161202.GN3356773@frogsfrogsfrogs>
References: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
 <MK77eWYpInMwgQbgEmSwJLbCh54diNy9QV2ebaTYOT2J82_b40KtfxBIvp4JLwmeM2iW_USktGAfL7bQOEuFqg==@protonmail.internalid>
 <176107134023.4152072.12787167413342928659.stgit@frogsfrogsfrogs>
 <dduztn5x2drvcafdcnvk6jvnmgdteh6wjnzswkrrjhrx7tcwvd@z7s5ej7lvlxs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dduztn5x2drvcafdcnvk6jvnmgdteh6wjnzswkrrjhrx7tcwvd@z7s5ej7lvlxs>

On Wed, Oct 22, 2025 at 10:00:55AM +0200, Carlos Maiolino wrote:
> On Tue, Oct 21, 2025 at 11:30:12AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The deprecation of the 'attr2' mount option in 6.18 wasn't entirely
> > successful because nobody noticed that the kernel never printed a
> > warning about attr2 being set in fstab if the only xfs filesystem is the
> > root fs; the initramfs mounts the root fs with no mount options; and the
> > init scripts only conveyed the fstab options by remounting the root fs.
> 
> This is a weird behavior IMHO, as far as I remember not all mount options should
> necessarily work with remount and what the initramfs initially mounted
> might not reflect the reality the user expects. Assuming the 'remount'
> used here does not mean unmounting/mounting the root fs, but using mount
> -o remount...

Yes, this is a ... weird quirk of the initramfs behavior where it mounts
the rootfs with no mount options, grabs the intended mount options out
of /etc/fstab, and then mount / -o remount,$fstaboptions.  In that case
there's no warning if the fstab options contain 'attr2'.

> This is not a concern this patch should consider though, it looks fine
> as-is.
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Thanks!

--D

> 
> > 
> > Fix this by making it complain all the time.
> > 
> > Cc: <stable@vger.kernel.org> # v5.13
> > Fixes: 92cf7d36384b99 ("xfs: Skip repetitive warnings about mount options")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_super.c |   25 +++++++++++++++++--------
> >  1 file changed, 17 insertions(+), 8 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index e85a156dc17d16..ae9b17730eaf41 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1373,16 +1373,25 @@ suffix_kstrtoull(
> >  static inline void
> >  xfs_fs_warn_deprecated(
> >  	struct fs_context	*fc,
> > -	struct fs_parameter	*param,
> > -	uint64_t		flag,
> > -	bool			value)
> > +	struct fs_parameter	*param)
> >  {
> > -	/* Don't print the warning if reconfiguring and current mount point
> > -	 * already had the flag set
> > +	/*
> > +	 * Always warn about someone passing in a deprecated mount option.
> > +	 * Previously we wouldn't print the warning if we were reconfiguring
> > +	 * and current mount point already had the flag set, but that was not
> > +	 * the right thing to do.
> > +	 *
> > +	 * Many distributions mount the root filesystem with no options in the
> > +	 * initramfs and rely on mount -a to remount the root fs with the
> > +	 * options in fstab.  However, the old behavior meant that there would
> > +	 * never be a warning about deprecated mount options for the root fs in
> > +	 * /etc/fstab.  On a single-fs system, that means no warning at all.
> > +	 *
> > +	 * Compounding this problem are distribution scripts that copy
> > +	 * /proc/mounts to fstab, which means that we can't remove mount
> > +	 * options unless we're 100% sure they have only ever been advertised
> > +	 * in /proc/mounts in response to explicitly provided mount options.
> >  	 */
> > -	if ((fc->purpose & FS_CONTEXT_FOR_RECONFIGURE) &&
> > -            !!(XFS_M(fc->root->d_sb)->m_features & flag) == value)
> > -		return;
> >  	xfs_warn(fc->s_fs_info, "%s mount option is deprecated.", param->key);
> >  }
> > 
> > 
> 
