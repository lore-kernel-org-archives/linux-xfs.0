Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D6B2222A0
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 12:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745844906; cv=none; b=U3TbmzAZgjMbQnF2ypp/ErEM24ExyFqtxAts6h9wKavasbXLKV3iegaqB07NchVdcAi25fjajyeAqIiPPF2jUstu2LH703DwiIPNG7c1+WI5VjTphyn7jJgTAmdVgl+WlngqlVKl7FCJPUzGkjkTL2fLPf+I6DHiB+hhasfn1kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745844906; c=relaxed/simple;
	bh=wukCs24ivYDQU1KACl71g105BrcVdetBk0NpUfDdY7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RSaxLCf7dVXBa7fZyxrAUeOHNYd5PK2/nytraD+mfvzDhlRMfa1GH45HnMhwhilkJe4fmaeCopC9EfiwECaOwowe5JUbnV5hpNmNwP9/P4N6oEkLAORqb1T70EMu1OsN7ziWp/eGdgnaNLO7FzGCWyAoWTpuGMSPlVs3YcNCino=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j3IthB06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j3IthB06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3304C4CEE4;
	Mon, 28 Apr 2025 12:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745844906;
	bh=wukCs24ivYDQU1KACl71g105BrcVdetBk0NpUfDdY7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j3IthB06KmjA6G4DmGRKX1wYFF1VhJN+nNT+wfOdXafkQUxEe0oGxgrvbQ3Q77ycz
	 CooQp9UvRPx2iwQ1vueDGF8f4ldD7ntOaJ9kXC9psnw9JEcOaNwO0CwRm3Ak2cM2Rw
	 uZCZnlaHPYcRM0vAjURXauXfzyC7nfKQz4rkPTGOeqnHH4f2V+FTfVLH1uSzMv/rBK
	 VsoRuwYrHCcoBckIaxyG6e24Z2pw/mJYPrQxgGNfc8FZYjqZXXnsL1M2MMB7GAPZHC
	 St8JIF0zbRUD/N6hYbNFPlY5FQKrZB67kYdG8okMWZe8Sh1uOIUNYBiGMs6BGqRk4a
	 MCVkaW5wE1p5Q==
Date: Mon, 28 Apr 2025 14:54:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Dave Chinner <david@fromorbit.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Message-ID: <rld7gaksnhm5r2dn65v2cxct3wtqvokbhxnw2zh6betey4jblc@6dvgavf47zle>
References: <M6FcYEJbADh29bAOdxfu6Qm-ktiyMPYZw39bsvsx-RJNJsTgTMpoahi2HA9UAqfEH9ueyBk3Kry5vydrxmxWrA==@protonmail.internalid>
 <20250425085217.9189-1-hans.holmberg@wdc.com>
 <iboil7qz4s76y53wlwvpnu2diypdv5bdryoqwhlh4duat5dtj2@lkptlw2z3pdq>
 <C4tcpc9KgtT1pkGmrFcEWdwZcHpOiA2vViIipXnQqeVEHXsRPRXdmhAyyFhgljCydyMMbHO_qeL3wgFD3FVEng==@protonmail.internalid>
 <8d4aa088-e59e-46bc-bc75-60eff2d49f4a@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d4aa088-e59e-46bc-bc75-60eff2d49f4a@wdc.com>

On Mon, Apr 28, 2025 at 11:51:24AM +0000, Hans Holmberg wrote:
> On 28/04/2025 11:52, Carlos Maiolino wrote:
> > On Fri, Apr 25, 2025 at 08:52:53AM +0000, Hans Holmberg wrote:
> >> Allow read-only mounts on rtdevs and logdevs that are marked as
> >> read-only and make sure those mounts can't be remounted read-write.
> >>
> >> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> >> ---
> >>
> >> I will post a couple of xfstests to add coverage for these cases.
> >>
> >>  fs/xfs/xfs_super.c | 24 +++++++++++++++++++++---
> >>  1 file changed, 21 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >> index b2dd0c0bf509..d7ac1654bc80 100644
> >> --- a/fs/xfs/xfs_super.c
> >> +++ b/fs/xfs/xfs_super.c
> >> @@ -380,10 +380,14 @@ xfs_blkdev_get(
> >>  	struct file		**bdev_filep)
> >>  {
> >>  	int			error = 0;
> >> +	blk_mode_t		mode;
> >>
> >> -	*bdev_filep = bdev_file_open_by_path(name,
> >> -		BLK_OPEN_READ | BLK_OPEN_WRITE | BLK_OPEN_RESTRICT_WRITES,
> >> -		mp->m_super, &fs_holder_ops);
> >> +	mode = BLK_OPEN_READ | BLK_OPEN_RESTRICT_WRITES;
> >
> > 	Does BLK_OPEN_RESTRICT_WRITES makes sense without BLK_OPEN_WRITE?
> > 	Perhaps this should be OR'ed together with OPEN_WRITE below?
> 
> BLK_OPEN_RESTRICT_WRITES disallows other writers to mounted devs, and I
> presume we want this for read-only mounts as well?

Thanks, it wasn't really clear to me what the purpose of RESTRICT_WRITES was,
thanks for the clarification, this looks good to me:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> >
> >
> > -Carlos
> >
> >> +	if (!xfs_is_readonly(mp))
> >> +		mode |= BLK_OPEN_WRITE;
> >
> >> +
> >> +	*bdev_filep = bdev_file_open_by_path(name, mode,
> >> +			mp->m_super, &fs_holder_ops);
> >>  	if (IS_ERR(*bdev_filep)) {
> >>  		error = PTR_ERR(*bdev_filep);
> >>  		*bdev_filep = NULL;
> >> @@ -1969,6 +1973,20 @@ xfs_remount_rw(
> >>  	struct xfs_sb		*sbp = &mp->m_sb;
> >>  	int error;
> >>
> >> +	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp &&
> >> +	    bdev_read_only(mp->m_logdev_targp->bt_bdev)) {
> >> +		xfs_warn(mp,
> >> +			"ro->rw transition prohibited by read-only logdev");
> >> +		return -EACCES;
> >> +	}
> >> +
> >> +	if (mp->m_rtdev_targp &&
> >> +	    bdev_read_only(mp->m_rtdev_targp->bt_bdev)) {
> >> +		xfs_warn(mp,
> >> +			"ro->rw transition prohibited by read-only rtdev");
> >> +		return -EACCES;
> >> +	}
> >> +
> >>  	if (xfs_has_norecovery(mp)) {
> >>  		xfs_warn(mp,
> >>  			"ro->rw transition prohibited on norecovery mount");
> >> --
> >> 2.34.1
> >>
> >
> 
