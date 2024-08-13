Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F4A19EEB1;
	Tue, 13 Aug 2024 14:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560046; cv=none; b=E5fNQ6YNK1dkZByHmAf4nFGYsby+1a38szvcBVTLeSdZDYx+aQgKH/jPEgy2506JNUQy/Pywy9+wP8I5m5X/CaBsGfymrzp9HJpJdq/H3KNSyHQHWrMnbDdQfmE91iCtz93NBQ2aekfhNtIoT+nB6EP8G8uPzxneoCfVHnawbg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560046; c=relaxed/simple;
	bh=o3BjWMi6v5uyouSb5RLlPRWAcrsbicY0RYuKU6cQ7js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVgsCeXHMEi6BtExDIPDXGWzLuxVzno3kloY5ROHUT5yEoM9N1CAuDqZBa1K8YoqK/KdXTxRqaFBRb4yzoxgjjY9OCGT73QXs0RZcztiK1bVpedrogLKvAbx766ugoHysvlS5qlO06/h0u7Nq6cUlSXWCr0T9F/LcGJKiqSgShs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDsMyz+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDsMyz+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B313C4AF0F;
	Tue, 13 Aug 2024 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723560045;
	bh=o3BjWMi6v5uyouSb5RLlPRWAcrsbicY0RYuKU6cQ7js=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dDsMyz+SSxbSlJ9EGMKm5O3JFKob7wMkIb34jx+HOcecsGrdUY6GpP3GdZLrmkmJp
	 hRRZoSWrRUchUhVDFHoBEMlWZeQCPXFmCkcV+0QsWTtd48BPcxW92WITMF41a5arNU
	 GJgqzE8NRf0BNGYtDYGP2jnRZvykR4gHTe+G/0zja0WsTCFaHjNrF3hlDIT6QcSVrU
	 X6GJF4WNqQ/fuU2JzDZbEWHTHFnt48o8XQbxSOLU8u0ueYLprgvxvamz/9qJsi2ziZ
	 EpxQUu7KCc7rXOMkj4X3jRIi9B7lfGML561bTcfXLHCPSw2krk/ITQpWSeORu6bWcn
	 64dREIqlgLURQ==
Date: Tue, 13 Aug 2024 07:40:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs/424: don't use _min_dio_alignment
Message-ID: <20240813144045.GE6047@frogsfrogsfrogs>
References: <20240813073527.81072-1-hch@lst.de>
 <20240813073527.81072-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813073527.81072-4-hch@lst.de>

On Tue, Aug 13, 2024 at 09:35:02AM +0200, Christoph Hellwig wrote:
> xfs/424 tests xfs_db and not the kernel xfs code, and really wants
> the device sector size and not the minimum direct I/O alignment.
> 
> Switch to a direct call of the blockdev utility.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/424 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/424 b/tests/xfs/424
> index 71d48bec1..6078d3489 100755
> --- a/tests/xfs/424
> +++ b/tests/xfs/424
> @@ -50,7 +50,7 @@ echo "Silence is golden."
>  # NOTE: skip attr3, bmapbta, bmapbtd, dir3, dqblk, inodata, symlink
>  # rtbitmap, rtsummary, log
>  #
> -sec_sz=`_min_dio_alignment $SCRATCH_DEV`
> +sec_sz=`blockdev --getss $SCRATCH_DEV`
>  while [ $sec_sz -le 4096 ]; do
>  	sector_sizes="$sector_sizes $sec_sz"
>  	sec_sz=$((sec_sz * 2))
> -- 
> 2.43.0
> 
> 
