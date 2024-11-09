Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6BB185B62
	for <linux-xfs@vger.kernel.org>; Sat,  9 Nov 2024 16:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731169285; cv=none; b=bN31rD2O3AO7GvPT9KAO46il5ZhMGEj1tYXxgjYTbmK8HYjUSVLxtBbklp3xr/kPssTyaMBI8Mfy5A4dkibFh/ULil7nMT2UEtrpSiWJ/s/x2wGPFpZit69FXikPcqeZ77vdvcFnyogrVzho9H7WfH7nf9J1COJBq4VhnNPaumI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731169285; c=relaxed/simple;
	bh=mQ7/UMeZwDN2ANEAzu1TJDnJu//LpFyIyLgM17EfKBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pROnRAsCqxI0RopxR6ueHSMD+AZg5sCqKD7+z39N6bnd739y7lXGYE/tyjeQO2Uib3E14BXAFUHcZgLroQO9lBZNc7MDBvhLb9mG7QFJYloSsfFiI+8Ye02o7ohwsmtgnhfFO8ogMAdc8SNKSJJ3uCtqA4r16/MlafDeNZXxzlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GiMnUfYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GiMnUfYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8952BC4CED3;
	Sat,  9 Nov 2024 16:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731169284;
	bh=mQ7/UMeZwDN2ANEAzu1TJDnJu//LpFyIyLgM17EfKBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GiMnUfYbixTN/XOK/u1b0T3iVLd7WCOcrDZRZbUxyZXPYcjVPj09HOEovMTqCvQCW
	 CR3OYID2iNePFEaYvkmlcCiXWP7omd59TjWqB5TFilXEpVDsjtrM8FNFGOEiBqHpRc
	 QqwL/3tIjBLRKTPRf4gMFb5YypBn2lDBMS3FVRn67qIkm19LAbOfHRARj2l0MtldqT
	 UZ3UIdvwt9m2lNvHtRP4pnWAtlnAXEE8/i8Zi2C4Y/Py8Rs8k5r5OGdEVSqkpUr9QM
	 qpJXx2YdiYor+gFmstOuglVP2id7ZgCGPTbmvgWcV4JZD27ZviYKtWn39csFA7snqH
	 HqXgt98S/dg8g==
Date: Sat, 9 Nov 2024 08:21:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: remove unknown compat feature check in superblock
 write validation
Message-ID: <20241109162124.GA9438@frogsfrogsfrogs>
References: <20241021012549.875726-1-leo.lilong@huawei.com>
 <Zy8Rj7eISiraFIha@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zy8Rj7eISiraFIha@localhost.localdomain>

On Sat, Nov 09, 2024 at 03:38:55PM +0800, Long Li wrote:
> 
> Friendly Ping ...

Sorry about that, I missed this one.

> On Mon, Oct 21, 2024 at 09:25:49AM +0800, Long Li wrote:
> > Compat features are new features that older kernels can safely ignore,
> > allowing read-write mounts without issues. The current sb write validation
> > implementation returns -EFSCORRUPTED for unknown compat features,
> > preventing filesystem write operations and contradicting the feature's
> > definition.
> > 
> > Additionally, if the mounted image is unclean, the log recovery may need
> > to write to the superblock. Returning an error for unknown compat features
> > during sb write validation can cause mount failures.
> > 
> > Although XFS currently does not use compat feature flags, this issue
> > affects current kernels' ability to mount images that may use compat
> > feature flags in the future.
> > 
> > Since superblock read validation already warns about unknown compat
> > features, it's unnecessary to repeat this warning during write validation.
> > Therefore, the relevant code in write validation is being removed.
> > 

You might want to add this so it actually gets backported:

Cc: <stable@vger.kernel.org> # v4.19

> > Fixes: 9e037cb7972f ("xfs: check for unknown v5 feature bits in superblock write verifier")
> > Signed-off-by: Long Li <leo.lilong@huawei.com>

Makes sense, so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> > ---
> >  fs/xfs/libxfs/xfs_sb.c | 7 -------
> >  1 file changed, 7 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index d95409f3cba6..02ebcbc4882f 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -297,13 +297,6 @@ xfs_validate_sb_write(
> >  	 * the kernel cannot support since we checked for unsupported bits in
> >  	 * the read verifier, which means that memory is corrupt.
> >  	 */
> > -	if (xfs_sb_has_compat_feature(sbp, XFS_SB_FEAT_COMPAT_UNKNOWN)) {
> > -		xfs_warn(mp,
> > -"Corruption detected in superblock compatible features (0x%x)!",
> > -			(sbp->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN));
> > -		return -EFSCORRUPTED;
> > -	}
> > -
> >  	if (!xfs_is_readonly(mp) &&
> >  	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> >  		xfs_alert(mp,
> > -- 
> > 2.39.2
> > 
> 
