Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705463FFACC;
	Thu, 14 May 2026 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778770053; cv=none; b=jHjlYvo4VVwWLYLuVGmqSCovqovcK29xQZTew24NA26qkADIS+QTzA18LNzgs8j5BOCwM7l2g5GHkYZhGSMOy4b1/5I3njjUwYB68kvBuLdgrVSg8/gv27RxzxQZrGOePNpd+TRK7aBOfpU4NZFd5hiEmlAPA3d4CWHIXN99HRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778770053; c=relaxed/simple;
	bh=v5v3PXO0LcYYEDDNA/uOfgdrW9BQJ3RDLMIAPhWxKto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pI26wanXXoRknN/7XnXK5msPX1izqt/Uw46GNVyeh78MZsEYEicxpVjGxoCVNbSVJsAbtOv/6o657X/n8M+F0pTO1e9QhpHWgUddFPG4I31LZ4wKKxbfChKh8F4RyPwa/iT0sy6tXnJmBmPOPfAHNfhE1JQgLYvQjrIbQylF23Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OQZISsEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OQZISsEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD00C2BCB3;
	Thu, 14 May 2026 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778770053;
	bh=v5v3PXO0LcYYEDDNA/uOfgdrW9BQJ3RDLMIAPhWxKto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OQZISsEvEGiCg0SACyV1iuCGyuKtKxhfkzeKP5T9bQ+rIBDxyGhst8d09tgThfbq1
	 wCAGd63U7ku0Q2q4AJpL1C83I2ZRDeLB7DArpce9z+aR5/8IPVdUXK0I5IKNtDi0O2
	 AGXIa1RuwUNv6GVdpkRe1C1eLeMf2pMA8QPXBblK+2aTbPvK+gC4TBFlKLUYJ0Z0JN
	 cCudNJpO2sJlmW5TQLFHDXii9BBnftPObhjxea34gV9tdPLDhPn/yLMrVzM405BT6y
	 vAkI3M7dpnVjDjmVEtpGMDbzpBEiOh5PMsglzUYGqDsZ43IuCuPg3bajMzpzn+3muS
	 EleHWNtg0w+DA==
Date: Thu, 14 May 2026 07:47:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] xfs/21{6,7} Use default -l concurrency=0 on
 mkfs.xfs that supports it
Message-ID: <20260514144732.GA9544@frogsfrogsfrogs>
References: <20260514113910.866888-2-lukas@herbolt.com>
 <20260514113910.866888-10-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514113910.866888-10-lukas@herbolt.com>

On Thu, May 14, 2026 at 01:39:15PM +0200, Lukas Herbolt wrote:
> The XFS concurrency optimization breaks the log sizing check on
> systems with non-rotational disks and high amount of CPUs. Default to
> the old behavior with -l concurrency=0 and with -d concurrency=0.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  changes v2:
> 	use default mkfs.xfs for scratch device
> 	remove the double check -l/-d as those were introduced together

Yeah, sorry about breaking that. :/
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  tests/xfs/216 | 6 +++++-
>  tests/xfs/217 | 7 ++++++-
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/216 b/tests/xfs/216
> index 091c11d08642..0148e7f4de3e 100755
> --- a/tests/xfs/216
> +++ b/tests/xfs/216
> @@ -22,13 +22,17 @@ _cleanup()
>  
>  _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
> +if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> +	loop_mkfs_opts="-l concurrency=0"
> +else
> +	loop_mkfs_opts=""
> +fi
>  _scratch_mount
>  
>  _require_loop
>  LOOP_IMG=$SCRATCH_MNT/test_fs
>  LOOP_MNT=$SCRATCH_MNT/test_fs_dir
>  
> -loop_mkfs_opts=
>  $MKFS_XFS_PROG 2>&1 | grep -q rmapbt && \
>  	loop_mkfs_opts="$loop_mkfs_opts -m rmapbt=0"
>  $MKFS_XFS_PROG 2>&1 | grep -q reflink && \
> diff --git a/tests/xfs/217 b/tests/xfs/217
> index dae6ce55f475..23aae842d1fb 100755
> --- a/tests/xfs/217
> +++ b/tests/xfs/217
> @@ -21,6 +21,11 @@ _cleanup()
>  
>  _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
> +if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> +	loop_mkfs_opts="-l concurrency=0 -d concurrency=0"
> +else
> +	loop_mkfs_opts=""
> +fi
>  _scratch_mount
>  # 16T mkfs requires a bit over 2G free
>  _require_fs_space $SCRATCH_MNT 2202000
> @@ -34,7 +39,7 @@ _do_mkfs()
>  	for i in $*; do
>  		echo -n "fssize=${i}g "
>  		$MKFS_XFS_PROG -f -b size=4096 -l version=2 \
> -			-d size=${i}g $loop_dev |grep log
> +			-d size=${i}g $loop_dev $loop_mkfs_opts |grep log
>  		_mount $loop_dev $LOOP_MNT
>  		echo "test write" > $LOOP_MNT/test
>  		_unmount $LOOP_MNT > /dev/null 2>&1
> -- 
> 2.54.0
> 
> 
