Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FEA15AE2;
	Tue,  2 Jan 2024 19:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vP6fUiss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B8CC433C7;
	Tue,  2 Jan 2024 19:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704222663;
	bh=v7Sg5Hu2tTtPpVizisGQrUZ1egDq4eG4pzn1oBIzlEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vP6fUissFLHpwDJUX3Clw/yIeEVawt8yhtl8IXFZ1XDDsGF4vBn+K28wosP+9athF
	 jehLmhrbkY8bLjmy+B08xY1UC8wNZ8e4AlPDVMUPC34YkyFob16d8LCqCOWtqMF6Zv
	 YzY2uxii5fN5/qRHd0dSVPVlYDXIPuuJhjh5NiKsXRIuu93ntb8+2N3pBzc7C58cWY
	 dIph2dDGEVG+XUJiT70xdLmppLdG9StQAw0BcyWlc+aA1wOVWp7pB7ofBG41fRmtoH
	 JNW+xRT1+lmCqjILa63oAtgnfZ7iGQXmzMuuGy55EdmFNFJn2MxKJouVVla+zAzDm4
	 W/OpSlJnv0YMQ==
Date: Tue, 2 Jan 2024 11:11:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 3/5] _scratch_xfs_mdrestore: Pass scratch log device when
 applicable
Message-ID: <20240102191102.GE108281@frogsfrogsfrogs>
References: <20240102084357.1199843-1-chandanbabu@kernel.org>
 <20240102084357.1199843-4-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240102084357.1199843-4-chandanbabu@kernel.org>

On Tue, Jan 02, 2024 at 02:13:50PM +0530, Chandan Babu R wrote:
> Metadump v2 supports dumping contents of an external log device. This commit
> modifies _scratch_xfs_mdrestore() and _xfs_mdrestore() to be able to restore
> metadump files which contain data from external log devices.
> 
> The callers of _scratch_xfs_mdrestore() must set the value of $SCRATCH_LOGDEV
> only when all of the following conditions are met:
> 1. Metadump is in v2 format.
> 2. Metadump has contents dumped from an external log device.
> 
> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>

Looks very similar to my version,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  common/xfs | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 558a6bb5..248c8361 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -682,7 +682,8 @@ _xfs_metadump() {
>  _xfs_mdrestore() {
>  	local metadump="$1"
>  	local device="$2"
> -	shift; shift
> +	local logdev="$3"
> +	shift; shift; shift
>  	local options="$@"
>  
>  	# If we're configured for compressed dumps and there isn't already an
> @@ -695,6 +696,10 @@ _xfs_mdrestore() {
>  	fi
>  	test -r "$metadump" || return 1
>  
> +	if [ "$logdev" != "none" ]; then
> +		options="$options -l $logdev"
> +	fi
> +
>  	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
>  }
>  
> @@ -724,8 +729,18 @@ _scratch_xfs_mdrestore()
>  {
>  	local metadump=$1
>  	shift
> +	local logdev=none
> +	local options="$@"
>  
> -	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$@"
> +	# $SCRATCH_LOGDEV should have a non-zero length value only when all of
> +	# the following conditions are met.
> +	# 1. Metadump is in v2 format.
> +	# 2. Metadump has contents dumped from an external log device.
> +	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ]; then
> +		logdev=$SCRATCH_LOGDEV
> +	fi
> +
> +	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$@"
>  }
>  
>  # Do not use xfs_repair (offline fsck) to rebuild the filesystem
> -- 
> 2.43.0
> 
> 
