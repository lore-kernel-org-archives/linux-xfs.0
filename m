Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F29480C0C;
	Mon, 29 Jul 2024 16:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722271268; cv=none; b=s4CxhXsyM344tmyMn9UOJeEqnbLxfaS8BXrLJ9ZEOIKIcLVqeyt/UvTlZby3jeEQIRdzO+L5KH9t7ce9hLB6uRrKx+X58a+EsLcjYLaxBhYSWYQLRORcnROAKBBfDAlQN5u4mmqfFqfG2KRT5Ki5vwapSNF+Pm728IbXqIc9pWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722271268; c=relaxed/simple;
	bh=DNE89WqTeaOQmKxiUPRGPmXidnYnMlb61yacRANxxdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJ4g+CGuVDxofSmC5dWJeUUIjLjIRbOlI5bnuQMjgg//yBPX96HW8Nd94SjaHRYS8RfI0+6A45H/yPz6BjaZmE1j7hVtb+KOXzsqhl8oGhq0LcuEetjddkgyfZBMDXmy5V1haRkHy5A97m1VQaVXH/Vs2JHj1344y3GYvDZD9YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g9LIgPwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g9LIgPwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32118C4AF0E;
	Mon, 29 Jul 2024 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722271268;
	bh=DNE89WqTeaOQmKxiUPRGPmXidnYnMlb61yacRANxxdk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g9LIgPwbyR7mSialFZm53rnK4I5c3uo+ddJM5X2rcvxdyGtxhpSu7zQsaE7+HzIi4
	 /JxURT82OwMmf4s0ZyL4MCq/TxUOrsaCI3bwDgUdKhbS8qetP8nyeEu0g/fDzVVvqu
	 kOCI4OfSuVRn4EWrAk93FgJJOWeCeYPObTlRbcJw1hVd1iQGTEotj4d+lkvm6StGzw
	 olcI1OVKSmZkOb8jKqDB+8s8Xur6FfKmZ3omeHD8fYUUAx4+BWJwrXxyiQqpA8pwyK
	 pi/kexzvZwaq3Okjwmf+PGvK8FPn++WGLLssOr9dXQ3y4x0ONT9hcmBTIiL02+8Wv+
	 uyRSje5C4cxyA==
Date: Mon, 29 Jul 2024 09:41:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/233: don't require rmap
Message-ID: <20240729164107.GB6352@frogsfrogsfrogs>
References: <20240729142027.430744-1-hch@lst.de>
 <20240729142027.430744-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240729142027.430744-2-hch@lst.de>

On Mon, Jul 29, 2024 at 07:20:27AM -0700, Christoph Hellwig wrote:
> Nothing in xfs/233 requires an rmap, it can run on any file system.
> And it is a very useful test because it starts out with a very small
> file system (or RT subvolume), which exercise some code paths no other
> test does.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Heh, you're right.  Lets do this! :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/233 | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/233 b/tests/xfs/233
> index 5d2c10e7d..211e5f842 100755
> --- a/tests/xfs/233
> +++ b/tests/xfs/233
> @@ -4,7 +4,7 @@
>  #
>  # FS QA Test No. 233
>  #
> -# Tests xfs_growfs on a rmapbt filesystem
> +# Tests xfs_growfs starting with a really small file system.
>  #
>  . ./common/preamble
>  _begin_fstest auto quick rmap growfs
> @@ -12,7 +12,6 @@ _begin_fstest auto quick rmap growfs
>  # Import common functions.
>  . ./common/filter
>  
> -_require_xfs_scratch_rmapbt
>  _require_no_large_scratch_dev
>  
>  echo "Format and mount"
> -- 
> 2.43.0
> 
> 
