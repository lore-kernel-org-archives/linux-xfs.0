Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DB93254BA
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 16:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765385341; cv=none; b=dGhZ8y9sd88NtEiu6Ul7lkX7W6z++FlaWQvSSohlXOU1oTRJdv6RyssCIWuNPdoxQqKZ/Frl27H+tB0XRXkQ5sRydGDoQIdwssT3BUmEp7N65JJZik3tR4azbNgHSeSzfNwrwKWPg6G564TffnqrtSTpM8FHZ6MIr3g3Y2qhOsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765385341; c=relaxed/simple;
	bh=hmW3129OwodSxHfa+Wh/L3SWxKzjuN8tfvvgb/fVJlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jW9cM/Ggm2PqWZ16kQ4On2bzs73BcXyaQzOkYicC1NEwGZ55N1Q6ak0KyM5olA5al3VXmXHUoKgRZDInTJJhpp38aEq7m8riWeeC4UBRrOVGMkL6SsGBp1bwIQk7dPMnlv1VdDSra5KoQj0FzvjNejFpZPzR/3dxZRZ1A3my8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pyolr8O5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pyolr8O5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE77C4CEF1;
	Wed, 10 Dec 2025 16:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765385340;
	bh=hmW3129OwodSxHfa+Wh/L3SWxKzjuN8tfvvgb/fVJlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pyolr8O5uyMtll5K21F5EOEeE7IbDp8dCePTXVuCBB0CdDGQrSAVEhllOJA2ibSXf
	 uHtlf5txdL0fp1sFfLUSHTdCBAj9US+dmgYdxb952fjsIPH5ul9nel0DvCKIYQfwP+
	 0wwIJNh+C5js0mO1hN9A1jY/uuj6e+ZeBCAA4OAwjRuOPqFFrm8s7HISRtf198bpoF
	 zCEgI3+ayefr6krTvE31+S8dICXW75FLZ+HVk3D2vFZFSQMg3noniqV0UZWP4OHusP
	 bWifWJg3EGzMD/1AnA+q8ZwM6+NWl5bYcFw8UABHMO+rFKORYgAVfy5+MOKRXJzyv4
	 EFih9PfrK67iw==
Date: Wed, 10 Dec 2025 08:48:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: validate that zoned RT devices are zone aligned
Message-ID: <20251210164859.GB7725@frogsfrogsfrogs>
References: <20251210142305.3660710-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210142305.3660710-1-hch@lst.de>

On Wed, Dec 10, 2025 at 03:23:05PM +0100, Christoph Hellwig wrote:
> Garbage collection assumes all zones contain the full amount of blocks.
> Mkfs already ensures this happens, but make the kernel check it as well

mkfs doesn't enforce that when you're creating a zoned filesystem on
non-zoned storage:

# mkfs.xfs -r rtdev=/dev/sda,zoned=1 -f /dev/sdf
meta-data=/dev/sdf               isize=512    agcount=4, agsize=1298176 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=1
data     =                       bsize=4096   blocks=5192704, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =/dev/sda               extsz=4096   blocks=5192704, rtextents=5192704
         =                       rgcount=80   rgsize=65536 extents
         =                       zoned=1      start=0 reserved=0

5192704 isn't congruent with 65536, and we get a runt rtgroup at the
end:

# mount /dev/sdf /opt -o rtdev=/dev/sda
# xfs_io -c 'rginfo' /opt | tail -n 20
RTG: 76
Length: 65536
Sick: 0x0
Checked: 0x0
Flags: 0x0
RTG: 77
Length: 65536
Sick: 0x0
Checked: 0x0
Flags: 0x0
RTG: 78
Length: 65536
Sick: 0x0
Checked: 0x0
Flags: 0x0
RTG: 79
Length: 15360
Sick: 0x0
Checked: 0x0
Flags: 0x0

rtgroup 79 is clearly a runt group.

(The mkfs enforcement does work if you have an actual zoned storage
device since mkfs complains about changes in the zone sizes.)

> to avoid getting into trouble due to fuzzers or mkfs bugs.
>
> Fixes: 2167eaabe2fa ("xfs: define the zoned on-disk format")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

How many filesystems are there in the wild with rump rtgroups?  My first
thought was "why not pretend the runt rtgroup doesn't exist?" but then
that creates all sorts of weirdness where you have a 778M rt volume on a
disk with 256M rtgroups, but then we ignore the 10M of space and you can
never get to it.

Given that runt zoned rtgroups can exist in the wild, how hard would it
be to fix zonegc?

--D

> ---
>  fs/xfs/libxfs/xfs_sb.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index cdd16dd805d7..db5231f846ea 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -301,6 +301,19 @@ xfs_validate_rt_geometry(
>  	    sbp->sb_rbmblocks != xfs_expected_rbmblocks(sbp))
>  		return false;
>  
> +	if (xfs_sb_is_v5(sbp) &&
> +	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
> +		uint32_t		mod;
> +
> +		/*
> +		 * Zoned RT devices must be aligned to the rtgroup size, because
> +		 * garbage collection can't deal with rump RT groups.
> +		 */
> +		div_u64_rem(sbp->sb_rextents, sbp->sb_rgextents, &mod);
> +		if (mod)
> +			return false;
> +	}
> +
>  	return true;
>  }
>  
> -- 
> 2.47.3
> 
> 
