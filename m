Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1531D95A9;
	Fri, 21 Mar 2025 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742570496; cv=none; b=a4KgQOQD5R8Q1bb1eQTNW1/T2ULXPMakd6FLtd+WM6nUsabhsKzY5JzHVaAFoh8pqfhSW1m+DZCLi6YFBkTIKQtYoXnQs+EBd+AQPbH3Ae0+lQpN0zwLAG813HIVJPt8ZuWV09/LlYsumnkhtol89z1H8g7tF4hsdBzW3TBnn8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742570496; c=relaxed/simple;
	bh=vWtz7US6En/UQUrwRZMKR/zr3+MFrg9xsuyfYOzdEjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSXDkl4bqAPL/4X4fJ7Z6BkFGOgqqjbjT+7+EjQPQF4lQB5bGUs7mfYgaztHIT2cdUdsiRRJpjLcopF18teR6r/9iQKBiGzi7do+UAIzuN7hiPKBuW6OHMyvU70EiHvvCQgTENXKY4aYqeXGsFhcqyXjhS4ctXJZWf2OqQy61Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNAg7tCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNAg7tCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D644C4CEE3;
	Fri, 21 Mar 2025 15:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742570496;
	bh=vWtz7US6En/UQUrwRZMKR/zr3+MFrg9xsuyfYOzdEjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kNAg7tCh8ySmX9qlutdyGuTrC1+N+j8x69eQjXgNGzrfF0ZtB4Ll0jWGDZjtnC4+s
	 5RP8UB1jBH7j6x2YeIilzRfD86IVenL5hAaPLyDzEFn1NYnolPyz8pmSaj03OE2j68
	 Kje/doPyQu8ztEJGX9gFXDFGO7b9wGB+Z4UzFJL//T+eM5msR8BAgr7Go+DjwdAQ8p
	 Ssbw4PQOE7OY9IEIF5yZNdlxIjzJOZaEZmyxPwicDs+iH32zpoWvm3qvrIZvBKW2MI
	 K8apHCDZl2V56by9PZ8z31jrlwUMkRZViZSPNeQehceKgzcR2XUuUm5ovHkPUa+gsU
	 t81jhe8izYynA==
Date: Fri, 21 Mar 2025 08:21:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] xfs/049: skip on zoned devices
Message-ID: <20250321152135.GJ2803749@frogsfrogsfrogs>
References: <20250321072145.1675257-1-hch@lst.de>
 <20250321072145.1675257-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321072145.1675257-13-hch@lst.de>

On Fri, Mar 21, 2025 at 08:21:41AM +0100, Christoph Hellwig wrote:
> This tes creates an ext2 file system, which doesn't support zoned
> devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/049 | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tests/xfs/049 b/tests/xfs/049
> index cdcddf76498c..07feb58c9ad6 100755
> --- a/tests/xfs/049
> +++ b/tests/xfs/049
> @@ -40,6 +40,8 @@ _require_scratch_nocheck
>  _require_no_large_scratch_dev
>  _require_loop
>  _require_extra_fs ext2
> +# this test actually runs ext2 on the scratch device
> +_require_non_zoned_device $SCRATCH_DEV
>  
>  echo "(dev=$SCRATCH_DEV, mount=$SCRATCH_MNT)" >> $seqres.full
>  echo "" >> $seqres.full
> -- 
> 2.45.2
> 
> 
