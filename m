Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6196E1DE894;
	Wed, 12 Mar 2025 20:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741811112; cv=none; b=JCl7q0O+QlSlMzYHWZsQTbNqsSMHkqqWCQ24LQ/qM/YffN5XYKCJ8QL5ibVGGz9N1ChMvlZS7fVcRWkA4rjrGDVgt0NOOl0Zeg3c1mccDGtuPU/yvn9OYp5PwPq2xFR4JbQsJ4qkLczr+az8gSl+1ph3b9AQV0wguCuLIeAkag8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741811112; c=relaxed/simple;
	bh=4zD6l4q9YC5YCkz3MzOteKQOWqhmCGqJtO0+0W00Oyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QqnEsCHBkiTW72Gx3Y9BbDe11wtLep3dFm1zwP2X6BpjKYtGwq0rheNJrsQY1cEuDOEIDYS656D5F/HlnIN2jMXiUiMg0TP+cUz8CN/fhnYzhXbkpBmkhdMbLdDRrSj7wH6Vr68wpSRbUy47iMxoUPgpTCsyPIm570wDHvhVWtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4VxL9kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4VxL9kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20DFC4CEDD;
	Wed, 12 Mar 2025 20:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741811111;
	bh=4zD6l4q9YC5YCkz3MzOteKQOWqhmCGqJtO0+0W00Oyo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V4VxL9kn/2CoFoTLOj5fjKhE3A71CSyKY8Ka2PzM7Bs78DpbpCnVxEtVuSb2QHZ1Y
	 s4vQAYPewA3aVajOVidYkdvHlOuxpp/TpCuPOQXWatBiPrw/6EYhUQF31tZ6wqnbRj
	 8C55owkuFre3Xmp3UcEgjGQtA9kGyWVMJjZlhUCQAStAhL5w0FWt2E8e4jx5H1K1xo
	 pKTPlkvq07C602TDwC7lxrS3YJQCpbgns8qowpnYT2kdzIJ3GGaRVO7Lo/RNatKy3p
	 INOUV1J11h/KUKbYrNYrg2fSK/JgngPyQeOq1HI9fj0qsI/2QPNQ0hOXVhC+HyQbAX
	 1lsAOzpqb6GUw==
Date: Wed, 12 Mar 2025 13:25:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/17] xfs: no quota support with internal rtdev
Message-ID: <20250312202511.GM2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-13-hch@lst.de>

On Wed, Mar 12, 2025 at 07:45:04AM +0100, Christoph Hellwig wrote:
> Same as regular zoned, but the previous check didn't work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/xfs | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/common/xfs b/common/xfs
> index a18b721eb5cf..3f9119d5ef65 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -2210,7 +2210,10 @@ _xfs_scratch_supports_rtquota() {
>  # can check that quickly, and we make the bold assumption that the same will
>  # apply to any scratch fs that might be created.
>  _require_xfs_rtquota_if_rtdev() {
> -	test "$USE_EXTERNAL" = "yes" || return
> +	if [ "$USE_EXTERNAL" != "yes" ]; then
> +		xfs_info "$TEST_DIR" | grep -q 'realtime.*internal' &&
> +			_notrun "Quota on internal rt device not supported"

Huh, I wonder if we should've allowed internal non-zoned rt devices.
It might've made the whole "we want 2MB blocksize on pmem" mess a little
less unpalatable.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	fi
>  
>  	if [ -n "$TEST_RTDEV$SCRATCH_RTDEV" ]; then
>  		_xfs_kmod_supports_rtquota || \
> -- 
> 2.45.2
> 
> 
