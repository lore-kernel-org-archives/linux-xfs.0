Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9351C156E0;
	Tue,  2 Jan 2024 18:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cm19BWa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F159CC433C8;
	Tue,  2 Jan 2024 18:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704220054;
	bh=HP6tI+HVZOSimiQ6Fk4eB4jNgTr/gBOBVI+28KM6jQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cm19BWa9LjdOMSmMndSikGfi1J699z1W+uGSWZrxFY7SlJCVR/jjFy06qe3oFuXj/
	 qlwVxpTwCbAfO2Vz0fOaxcBsf+vEIhZthkNlifoxwEiusDKTLayRFgKtufoubDUNNG
	 yDPHzFQGsN74aLBa3bNOP6c8etCxEPuojZzNZmI0ePPTkZF0+M3S1cwfDLZ8pEzJif
	 /fW1qRUZy2ZZTL4pDR85SVtZqjxWMiwOOB5SPz8HZ9z7HXLp5QN+mQ1A6TLAPy0FuO
	 nVyFW1eFDBBLGAx+31ALx+eZuEis/66OQpVz+XofA7B28JMPZd7hyh6JaUkwPA/qjM
	 ioFLJg6o4dwTg==
Date: Tue, 2 Jan 2024 10:27:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 2/5] common/xfs: Add function to detect support for
 metadump v2
Message-ID: <20240102182733.GW361584@frogsfrogsfrogs>
References: <20240102084357.1199843-1-chandanbabu@kernel.org>
 <20240102084357.1199843-3-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240102084357.1199843-3-chandanbabu@kernel.org>

On Tue, Jan 02, 2024 at 02:13:49PM +0530, Chandan Babu R wrote:
> This commit defines a new function to help detect support for metadump v2.
> 
> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
> ---
>  common/xfs | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 38094828..558a6bb5 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -698,6 +698,14 @@ _xfs_mdrestore() {
>  	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
>  }
>  
> +_scratch_metadump_v2_supported()
> +{
> +	$XFS_DB_PROG -c "help metadump" $SCRATCH_DEV | \
> +		grep -q "Metadump version to be used"
> +
> +	return $?

You don't need this; bash will retain the status code of the last
process in the pipe as the result value.

(Looks good to me otherwise.)

--D

> +}
> +
>  # Snapshot the metadata on the scratch device
>  _scratch_xfs_metadump()
>  {
> -- 
> 2.43.0
> 
> 
