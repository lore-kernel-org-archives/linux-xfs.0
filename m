Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB223A1D2;
	Fri, 27 Mar 2026 15:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774624799; cv=none; b=W5iUandKnjNBnYVkI9SmZG5jo+Bz4a1LbihIt6TzGUuZOi70CZwiDWhCHX3yDD+2dTV720maHhbwUuvtC9UEUTbSyx//RhHzfZJNDO0BUM5G/E+GVbUqRM3DcBH9l+LNiJ3RuHFOpUHTmuCM8UFDtOQvCj2D5w8ZQ7DqF0kvdLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774624799; c=relaxed/simple;
	bh=rp9G9J3epECogb7W3JKiVDPbH2qVbp8Z2+N9EMJJ1Ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oi25am1itiMkettmStnC+ZLCIPNJCn7/WHkcc4MOcv4Irsuun9/Zt3/iD4pjZXT/LBEJe9cADL4p1HZy0xLj+CeEXDUGS3blrHWqeDULO3PG4TCyu4XQo++dwKwPLFUwr5MJrhpe3fHYlscxNWc/sjbmaT8qEALy3lsd7qJHt+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTJrN4ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTJrN4ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744DBC19423;
	Fri, 27 Mar 2026 15:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774624799;
	bh=rp9G9J3epECogb7W3JKiVDPbH2qVbp8Z2+N9EMJJ1Ng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tTJrN4ur8dkLYf51abaHM8ItQJuufWnZjP24vx4ewBxZSXMxck9vZgw/Nl8FMVwCr
	 Vo+gaMtCNOUrP1NsNKgQYo6lY3YHxDG2ug6UMdXPb3bAJ+eUya5mGco/dvXCouGsNa
	 tDT8vAMVhPEbSHZhW+W77XC9YONEbiQfIxCHUJpVixkh4/YKaFTvoP4W2AFwaEwPMs
	 E473vVl2B0JbNqqowFWtLwnukM+QksJX+bhKYgRPqMZJdh79ZCvIEkB6/5xd6mPEQZ
	 lr5wijx2Px88iarQKPUV12865lsuTAJtqKHH71G/XY3tGqif6Z4/X+TWCnYrgTISol
	 13ywqdEk3CzLg==
Date: Fri, 27 Mar 2026 08:19:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs/647: turn rt dev block device lookup into a
 common helper
Message-ID: <20260327151958.GB6223@frogsfrogsfrogs>
References: <20260327123429.39330-1-hans.holmberg@wdc.com>
 <20260327123429.39330-2-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327123429.39330-2-hans.holmberg@wdc.com>

On Fri, Mar 27, 2026 at 01:34:28PM +0100, Hans Holmberg wrote:
> Turn the logic figuring out on which block device the rt data is stored on
> into a common helper.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/xfs    | 11 +++++++++++
>  tests/xfs/647 | 10 +---------
>  2 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 7fa0db2e26b4..c81f939e68d2 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -737,6 +737,17 @@ _xfs_metadump_supports_rt()
>  	$XFS_METADUMP_PROG --help 2>&1 | grep -q -- '-r rtdev'
>  }
>  
> +# What block device is rt data located on for scratch?
> +_xfs_get_scratch_rtdev_bdev()
> +{
> +	# Is the rt dev internal or not?
> +	if [ -z "$SCRATCH_RTDEV" ]; then
> +		echo "$SCRATCH_DEV"
> +	else
> +		echo "$SCRATCH_RTDEV"
> +	fi
> +}
> +
>  # Snapshot the metadata on the scratch device
>  _scratch_xfs_metadump()
>  {
> diff --git a/tests/xfs/647 b/tests/xfs/647
> index 76959b28c779..0ef340a14b07 100755
> --- a/tests/xfs/647
> +++ b/tests/xfs/647
> @@ -17,15 +17,7 @@ _begin_fstest auto quick zone
>  _require_scratch
>  _require_realtime
>  
> -#
> -# Figure out if the rt section is internal or not
> -#
> -if [ -z "$SCRATCH_RTDEV" ]; then
> -	zdev=$SCRATCH_DEV
> -else
> -	zdev=$SCRATCH_RTDEV
> -fi
> -
> +zdev="$(_xfs_get_scratch_rtdev_bdev)"
>  _require_zoned_device $zdev
>  _require_command "$BLKZONE_PROG" blkzone
>  
> -- 
> 2.34.1
> 
> 
