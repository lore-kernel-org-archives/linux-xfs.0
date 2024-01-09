Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A70238DF8;
	Tue,  9 Jan 2024 16:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3Vj2zle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6F1C433F1;
	Tue,  9 Jan 2024 16:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704818956;
	bh=OCj4SPP069TkrrSiOjEbo4qW5j5LESdWi6ki9koNQog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n3Vj2zlecc2yrJRTMQwBIwTy0SyTfZDDu1h59KwKbOM7/axvgI7oROug6yILgFUlP
	 8AYnYD9NkLl4WLPFw6DXFFCDWTdgzxZrjHZnI5NniD3PJzSwl3c+uiUYUueSc7GGsf
	 a4940vta6WqXXzZ94zBCQKougr0piTebvaX8yAvTGEQPIGOKF2+9cnCp9EwoRoTBdY
	 hm93fY4vV21rYGx33LPhVsptG/HAYIzcXiyywHr/LY33jm6FQzVGBuFaX7AbhrgYgN
	 pZ6WnkDjopL4jrHDwElp8oBNnYgoKFc3I8ddbs+dpBVdpUXG365kxTceWJzneAc57Q
	 q1k5xhIJcVp3g==
Date: Tue, 9 Jan 2024 08:49:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH V2 2/5] common/xfs: Add function to detect support for
 metadump v2
Message-ID: <20240109164915.GE722975@frogsfrogsfrogs>
References: <20240109102054.1668192-1-chandanbabu@kernel.org>
 <20240109102054.1668192-3-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240109102054.1668192-3-chandanbabu@kernel.org>

On Tue, Jan 09, 2024 at 03:50:44PM +0530, Chandan Babu R wrote:
> This commit defines a new function to help detect support for metadump v2.
> 
> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
> ---
>  common/xfs | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 38094828..fc744489 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -698,6 +698,12 @@ _xfs_mdrestore() {
>  	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
>  }
>  
> +_scratch_metadump_v2_supported()

/me wonders if the "_scratch" prefix is really warranted here since
metadump v2 support is a property of the tool, not the scratch fs.
OTOH xfs_db won't give you subcommand help without passing in a
filesystem and we probably don't want to force-feed it $TEST_DEV so
if zorro doesn't have any objections,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +{
> +	$XFS_DB_PROG -c "help metadump" $SCRATCH_DEV | \
> +		grep -q "Metadump version to be used"
> +}
> +
>  # Snapshot the metadata on the scratch device
>  _scratch_xfs_metadump()
>  {
> -- 
> 2.43.0
> 
> 
