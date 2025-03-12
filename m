Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6721D7E37;
	Wed, 12 Mar 2025 19:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741809367; cv=none; b=dReoLoUL/HIQjUuEPHAR9Nz2tJwL81i6h8q5NLC1juI7gaOcwQSbUm5LKqnYiEaCbLmtWQjp2LyQ/PNfkqVgvJ02wNXmU3KpphGJa/+1VZl6546PbiHDaJU8mbN76n+G3s/N7BQ/i100N2xEZak4CtseMbycBQdMae3em2GvVog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741809367; c=relaxed/simple;
	bh=+G+mQo83aQ4YtKSFH0IvqpVug5JLkkVLcl2VgjujZyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U+/KEIRjFbZY0fOkRu2Qhd9d5AUNuXT3N9wEMHvBBAehdwHyeEpjvG6I0YEt0+4MP9eOwAS4xZHGoZrMklHd/xM4lxj8EKzDH5RiByQAMYf/r9Yhy6nQfQ03lRpg61z0JQ8f70RiOJB0PxyDLAUj2A8mUvYmS0ylTk87SJAQJKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FtxeuzxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FtxeuzxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CCCC4CEEB;
	Wed, 12 Mar 2025 19:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741809365;
	bh=+G+mQo83aQ4YtKSFH0IvqpVug5JLkkVLcl2VgjujZyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FtxeuzxCoIEN1HucYTAf2e3phNm4o3N78xpxvSATUf9MIFysCABaDAW/RDoBuV5p4
	 Oj8ZGN/vX+GSbXgiQFAyGGMwybmt5t1aQptr3WdWApiVqK0VA3ZQMHkO6pGCNCjciV
	 Ez6H2BseC9QmrWPDvpDyv2Sdb/Ej9NNku8KApUx4cY0yqmGFQWoY/mFqBKyFd8UkR5
	 /ttFACkMqe9O+5/D5pSws6KBjwM8YPnfHNqcLMcYQdoUykD3xQUsMW+Gs3yui0vFb4
	 CfUuGlN5Uq0tzl1iVyqkhaP8MIbw6T1MRLCD2jNbnF47iqrp52/n7K8Dw2/D+nHVrL
	 BuWMXleLEStgw==
Date: Wed, 12 Mar 2025 12:56:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/17] xfs/177: force a small file system size
Message-ID: <20250312195605.GA2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-2-hch@lst.de>

On Wed, Mar 12, 2025 at 07:44:53AM +0100, Christoph Hellwig wrote:
> This test make assumptions about the number of metadata inodes.  When
> using small realtime group size (e.g. the customary 256MB for SMR
> hard drives) this assumption gets violated even with modest file system
> size.  Force a small file system size to side-step this issue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/177 | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/177 b/tests/xfs/177
> index 82b3ca264140..8d23f66d51b7 100755
> --- a/tests/xfs/177
> +++ b/tests/xfs/177
> @@ -77,7 +77,9 @@ delay_centisecs="$(cat "$xfs_centisecs_file")"
>  sleep_seconds=$(( ( (99 + (delay_centisecs / 6) ) / 100) + 1))
>  echo "Will sleep $sleep_seconds seconds to expire inodes" >> $seqres.full
>  
> -_scratch_mkfs >> $seqres.full
> +# Force a relatively small file system size to keep the number of rtgroups
> +# and thus metadata inodes low
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full

I guess that works... will try it out overnight and see what happens.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  _scratch_mount >> $seqres.full
>  
>  junkdir=$SCRATCH_MNT/$seq.junk
> -- 
> 2.45.2
> 
> 
