Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEBC2D9EC7;
	Fri, 21 Nov 2025 17:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763744683; cv=none; b=staBtEiMDYYPAIZYdCbbs+PPrDuFFsNFEAdfGKSDYUJ/LGwf005DzY5RyI7vNgtTK/tIMeF2yjaGyt1f+UHd0eGs+fLSetCI/gpZ5Pv87U3ptOSQFn5k7Olu5tjWof84U0jDYMFloslfT3hw6yw1oVshDMoCS0r7qRnZRT3InRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763744683; c=relaxed/simple;
	bh=E7gGSRlT3EEnVwdxumPZ0J2/0FVLsiRXO4ZosciiKVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dz8/ghtHo/Y8I0+5/ucyH0epNwPvAKQy5hb0GI5IafuwOQ65q2a8+iFzH7QYjD14oYjGDZOLVoSsJM3fQeNbi0yDtzzH6S8AfPSa5B7NV/KS/YaDZcsbe/QKAZMVazQFOgfVu7X6f43eoaZmrXXsGhbdCPdfpKt1Oa80NkUm5Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eovfbcZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eovfbcZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF40C4CEF1;
	Fri, 21 Nov 2025 17:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763744682;
	bh=E7gGSRlT3EEnVwdxumPZ0J2/0FVLsiRXO4ZosciiKVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eovfbcZCz8kDRz7CbkesD2a+p/jBS/9nKer3WLvSyR1rTtfJvkP4e4hV/nbGLkigz
	 oT/t8EOIAVKcwFqgs1Ewmc1aXUzzIwqjk/VedWkIZUYvYPWsjE1BU3P+pnfkozHGdq
	 8OJV4JmfW5kHgMDeJ339FvVN0jU5ARuZj49C4yGRZoZauQt0NvzxdZfRnzWyJgsdLM
	 nlwD//wlsH6CDSMqNFQoCb5IEWyh62o5mWK42affjN6Nuug90U7ZblMEXlG1nzB1Pp
	 yIfDmS1XpFIuEUbUoqxkQzEJxAY/P8/KwV8SNejnhEUowAJ2q0Sr7sbxR6oeIXkCwL
	 0tQKZqbx5g8/w==
Date: Fri, 21 Nov 2025 09:04:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/158: _notrun when the file system can't be
 created
Message-ID: <20251121170441.GO196366@frogsfrogsfrogs>
References: <20251121071013.93927-1-hch@lst.de>
 <20251121071013.93927-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121071013.93927-4-hch@lst.de>

On Fri, Nov 21, 2025 at 08:10:07AM +0100, Christoph Hellwig wrote:
> I get an "inode btree counters not supported without finobt support"
> with some zoned setups with the latests xfsprogs.  Just _notrun the
> test if we can't create the original file system feature combination
> that we're trying to upgrade from.

What configuration, specifically?  I haven't noticed any problems with
xfs/158 and:

MKFS_OPTIONS  -- -f -m metadir=1 -r zoned=1 /dev/sdf
MKFS_OPTIONS  -- -f -rrtdev=/dev/sdd -m metadir=1 -d rtinherit=1 -r zoned=1 /dev/sdf

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/158 | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/158 b/tests/xfs/158
> index 89bf8c851659..02ab39ffda0b 100755
> --- a/tests/xfs/158
> +++ b/tests/xfs/158
> @@ -22,12 +22,14 @@ _scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
>  	echo "Should not be able to format with inobtcount but not finobt."
>  
>  # Make sure we can't upgrade a filesystem to inobtcount without finobt.
> -_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
> +try_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 || \
> +	_notrun "invalid feature combination" >> $seqres.full
>  _scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
>  _check_scratch_xfs_features INOBTCNT
>  
>  # Format V5 filesystem without inode btree counter support and populate it.
> -_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +_scratch_mkfs -m crc=1,inobtcount=0 || \
> +	_notrun "invalid feature combination" >> $seqres.full
>  _scratch_mount
>  
>  mkdir $SCRATCH_MNT/stress
> -- 
> 2.47.3
> 
> 
