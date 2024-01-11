Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2385025F;
	Thu, 11 Jan 2024 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5IBcDeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1162FC433F1;
	Thu, 11 Jan 2024 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704993680;
	bh=OwFPmXX9sMx+PcvPUN2ib0yXbdwFI0C+dziGdRtuByQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V5IBcDeQGU3/hg5yOAJHjFZLhs7kNNswcZppVbChu7efAZy/xFTgkWE0Hyo+RU+UN
	 oRnFPupaQmSRH2r3M5AwJodwrhdRu4xytmUJDgyQIvuvmyO0fYCYjkBTLs6RRK9okR
	 kIOncKpztjhvVWuxN4mg0zhn2S1ivsEX9llpMqDbxduWauNOIEK7pD+w1F5F3ALZgz
	 nHDefr2cetgY7dY+D3idOc7AMnOSHml/hqhWDS1te01XjNPz66Y+eKiNV1jLkrA5hM
	 CD1rhV5kao93sCmF8P61o2T0+10lT7sm1E5IQNjQ9DTVnoLOIDKLJoSP6SQ5V2MKNZ
	 JVJ9rVoNdEUYw==
Date: Thu, 11 Jan 2024 09:21:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH V3 2/5] common/xfs: Add function to detect support for
 metadump v2
Message-ID: <20240111172119.GC722968@frogsfrogsfrogs>
References: <20240111115913.1638668-1-chandanbabu@kernel.org>
 <20240111115913.1638668-3-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111115913.1638668-3-chandanbabu@kernel.org>

On Thu, Jan 11, 2024 at 05:28:26PM +0530, Chandan Babu R wrote:
> This commit defines a new function to help detect support for metadump v2.
> 
> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

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
