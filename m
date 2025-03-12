Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAB31EB9E1;
	Wed, 12 Mar 2025 20:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810159; cv=none; b=R+NS0w/w3KeXpsWnRHCrapL0e6lBjDX1quwPSDdmNAf3Gjeaf1KuXjfNuzpO/b5Z2sQMEunBefnqrA3qgfMAz+yZHBEMIy4BTj7IIbDtn3nPY8goWiCXviHy4fRRft4mFBxwk4SLiy3kao1CILn+Yf7COQsIn1QidoMTmctgCPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810159; c=relaxed/simple;
	bh=HLU1JtY9kQD4HnCqf/ROV/wJ4gKDKgzRWIEjLSvXdJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RuwMBUwmvsumpHwvXvCkK5OKQD9af5tLqoKeji9J6y8qbSlhCtCwilBNRFz+t/8C1WupBuTJe9Yf2p7dHbgzY0h/D846j+o2S0j8JFKR5e8n2kCWjhx22pspwsIt4Rcj15SZXpcPlC8gSVx+f9+3mpadsho1VTN7EeIoiKxI+44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M8CKv6No; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8CKv6No"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17E5C4CEDD;
	Wed, 12 Mar 2025 20:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741810157;
	bh=HLU1JtY9kQD4HnCqf/ROV/wJ4gKDKgzRWIEjLSvXdJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M8CKv6NoiHhEAwmkPcSLFNcnf+dHw19mxwwpZrpyIsRDhsj40/vrnOuLTNyDwniDI
	 /z9GlxuAkqB/uLXmtUdrRmdZr+NAh0Sgm3PtciAbburQZyq7qxheonhF7iMNkKbchY
	 VYTUGMzpOZxZUmOGEWr3HIqJIk0OeJKXviiWZzAwUJCTsmItZQvyKXB2kvJIYCnFJO
	 g83ovgQRN42URNNJUBnbcDr0io2QFsJrdDb1f5FWmxfvEK1K8InIc3cTqM6UGjG0q+
	 SMgJBlsF9dij5fpu4VDMNHcHNOFmL+ZZMxoAc5cmXRTXKXnl97ipaIfYTgz8d2HV/N
	 Pagtv7irucwsQ==
Date: Wed, 12 Mar 2025 13:09:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/17] common: extend the zoned device checks in
 _require_dm_target
Message-ID: <20250312200917.GD2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-5-hch@lst.de>

On Wed, Mar 12, 2025 at 07:44:56AM +0100, Christoph Hellwig wrote:
> Also check for zoned log and rt devices in _require_dm_target
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/rc | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index dcdfa86e43b1..753e86f91a04 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2501,6 +2501,12 @@ _require_dm_target()
>  	case $target in
>  	snapshot|thin-pool)
>  		_require_non_zoned_device ${SCRATCH_DEV}
> +	        if [ "$FSTYP" = "xfs" ] && [ -b "$SCRATCH_RTDEV" ]; then

Silly nit: -n not -b, to be consistent with the codebase?

(Doesn't really matter since _require_non_zoned_device never aborts the
test if it's fed something that isn't a block device)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +			_require_non_zoned_device ${SCRATCH_RTDEV}
> +		fi
> +	        if [ "$FSTYP" = "xfs" ] && [ -b "$SCRATCH_LOGDEV" ]; then
> +			_require_non_zoned_device ${SCRATCH_LOGDEV}
> +		fi
>  		;;
>  	esac
>  }
> -- 
> 2.45.2
> 
> 
