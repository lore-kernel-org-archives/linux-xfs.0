Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDA01E4BE
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 15:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757085916; cv=none; b=uaVBx3a+dvBCxVlGaDM2HydHFt+lOkTUxG2S0eCFSopXif6vXoFDstEvz/biVKCW3CkxaKL7cd4IX+uNTl7epEVdSbajvjaaF27Tus4Yj/HnZrg5Y7T6xkqaIH7j1ur90fiWJZUAIth05Jw3l/6WfrapOD+ePsvIoh+9K+QXWaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757085916; c=relaxed/simple;
	bh=B24a1M8UhWO8xOizfG5jfLYZAaqkuJWlrbjBH+HlSBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hyX/vr6jrmZZij1j7CzrlVjN060ZNClRauBaCcEwaRyNYV13dq8Dwlwx3ra2YStxbUYhx6Xkc2njet8rU0fdMkZ0jkbX35H6BXTBWh/0mVkzOGWdpzdUoDn+wzWfcQuV0TQxOkFe+0mxfMuHf5rvkXeGIxT7H61eMKHKYOd8b2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r2Khv/hp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r2Khv/hp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9572EC4CEF1;
	Fri,  5 Sep 2025 15:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757085916;
	bh=B24a1M8UhWO8xOizfG5jfLYZAaqkuJWlrbjBH+HlSBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r2Khv/hp8zda//ZWjktz3KZUZTyqVbq8C2xu4O3XakvU5TQ+I0iXu1KdVRSCRtpBP
	 NyweCCd3u9U+hauoGHy+CTx5RXOkb36+H4uUt59g9vrBLkhuxoiScA9jy4d8kGd06U
	 LNaLI/9ewaBSX2XkVzOzz9wS0pYGlkrNh0FXMSh87r80qLQ/j6bhbPW1jBvvt3MSoa
	 LVe8BjfXpDDojCNdEcJCT8X4bnxGQ9YHgG3UVKEndSiKh7HL6ftsKJA6Agwk4djmhK
	 l/vaYi5G3+khaVkWNXp+kFyZaxwRuf4y3KSpGh6elqSSW/JXYCaIEamSYhoe2mjmef
	 +jPTr4qJYDhpw==
Date: Fri, 5 Sep 2025 08:25:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: preichl@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: remove deprecated mount options
Message-ID: <20250905152515.GM8096@frogsfrogsfrogs>
References: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
 <muu_F9WzxVlV7wwXYvleTQMz_gsQ4gb2ZjXdX2lkb6UVaWcTWopnJHY55oSAo3p3GsBObDuBTQFXuV9CAjgKdA==@protonmail.internalid>
 <175691147668.1206750.4620128821118989090.stgit@frogsfrogsfrogs>
 <vtoumkh2he3xx3q42bwf7xpmgq2hqvtyqunt3qkonnmsvgkd7i@p253vjx5ainy>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vtoumkh2he3xx3q42bwf7xpmgq2hqvtyqunt3qkonnmsvgkd7i@p253vjx5ainy>

On Fri, Sep 05, 2025 at 10:35:00AM +0200, Carlos Maiolino wrote:
> On Wed, Sep 03, 2025 at 08:00:08AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > These four mount options were scheduled for removal in September 2025,
> > so remove them now.
> > 
> > Cc: preichl@redhat.com
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_mount.h                |   12 ++++---
> >  Documentation/admin-guide/xfs.rst |   26 +---------------
> >  fs/xfs/libxfs/xfs_attr_leaf.c     |   23 +++-----------
> >  fs/xfs/libxfs/xfs_bmap.c          |   14 ++-------
> >  fs/xfs/libxfs/xfs_ialloc.c        |    4 +-
> >  fs/xfs/libxfs/xfs_sb.c            |    9 ++----
> >  fs/xfs/xfs_icache.c               |    6 +---
> >  fs/xfs/xfs_mount.c                |   13 --------
> >  fs/xfs/xfs_super.c                |   60 +------------------------------------
> >  9 files changed, 25 insertions(+), 142 deletions(-)
> > 
> > 

<snip>

> Looks good.
> 
> I'm sure you already have it planned, but just being paranoid... Will
> you consider updating xfsprogs too? :)

Yes, I'll send that for xfsprogs 6.18.  I think that's all just manpage
updates + libxfs sync.

--D

> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> > -	/*
> > -	 * V5 filesystems always use attr2 format for attributes.
> > -	 */
> > -	if (xfs_has_crc(mp) && xfs_has_noattr2(mp)) {
> > -		xfs_warn(mp, "Cannot mount a V5 filesystem as noattr2. "
> > -			     "attr2 is always enabled for V5 filesystems.");
> > -		return -EINVAL;
> > -	}
> > -
> >  	/*
> >  	 * prohibit r/w mounts of read-only filesystems
> >  	 */
> > @@ -1542,22 +1527,6 @@ xfs_fs_parse_param(
> >  		return 0;
> >  #endif
> >  	/* Following mount options will be removed in September 2025 */
> > -	case Opt_ikeep:
> > -		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_IKEEP, true);
> > -		parsing_mp->m_features |= XFS_FEAT_IKEEP;
> > -		return 0;
> > -	case Opt_noikeep:
> > -		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_IKEEP, false);
> > -		parsing_mp->m_features &= ~XFS_FEAT_IKEEP;
> > -		return 0;
> > -	case Opt_attr2:
> > -		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_ATTR2, true);
> > -		parsing_mp->m_features |= XFS_FEAT_ATTR2;
> > -		return 0;
> > -	case Opt_noattr2:
> > -		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_NOATTR2, true);
> > -		parsing_mp->m_features |= XFS_FEAT_NOATTR2;
> > -		return 0;
> >  	case Opt_max_open_zones:
> >  		parsing_mp->m_max_open_zones = result.uint_32;
> >  		return 0;
> > @@ -1593,16 +1562,6 @@ xfs_fs_validate_params(
> >  		return -EINVAL;
> >  	}
> > 
> > -	/*
> > -	 * We have not read the superblock at this point, so only the attr2
> > -	 * mount option can set the attr2 feature by this stage.
> > -	 */
> > -	if (xfs_has_attr2(mp) && xfs_has_noattr2(mp)) {
> > -		xfs_warn(mp, "attr2 and noattr2 cannot both be specified.");
> > -		return -EINVAL;
> > -	}
> > -
> > -
> >  	if (xfs_has_noalign(mp) && (mp->m_dalign || mp->m_swidth)) {
> >  		xfs_warn(mp,
> >  	"sunit and swidth options incompatible with the noalign option");
> > @@ -2177,21 +2136,6 @@ xfs_fs_reconfigure(
> >  	if (error)
> >  		return error;
> > 
> > -	/* attr2 -> noattr2 */
> > -	if (xfs_has_noattr2(new_mp)) {
> > -		if (xfs_has_crc(mp)) {
> > -			xfs_warn(mp,
> > -			"attr2 is always enabled for a V5 filesystem - can't be changed.");
> > -			return -EINVAL;
> > -		}
> > -		mp->m_features &= ~XFS_FEAT_ATTR2;
> > -		mp->m_features |= XFS_FEAT_NOATTR2;
> > -	} else if (xfs_has_attr2(new_mp)) {
> > -		/* noattr2 -> attr2 */
> > -		mp->m_features &= ~XFS_FEAT_NOATTR2;
> > -		mp->m_features |= XFS_FEAT_ATTR2;
> > -	}
> > -
> >  	/* Validate new max_atomic_write option before making other changes */
> >  	if (mp->m_awu_max_bytes != new_mp->m_awu_max_bytes) {
> >  		error = xfs_set_max_atomic_write_opt(mp,
> > 
> 
