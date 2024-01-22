Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5517A5B5DB;
	Mon, 22 Jan 2024 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705942583; cv=none; b=qgtOvS0+zjlQvXus1NHFsGyk26xakaMt/RC9JzAdzPd5oJVtUVct12tcLU4rUsEtbKn+lPq13/yZh+kPoPhw2SIewUjumxyK6lAWs7QEJ1SJsaO/sBuRZ0KQwvm8h3fJeudJdN188OLRcNUVgAPuCWuYvdfPlLG02MSCBEAEGBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705942583; c=relaxed/simple;
	bh=bDbC5+OZYxWAWLes8ATPVhnQNB9i4jh3/Ib85vuOuo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gnvHY84UAgl0Q07qzX+k2b+FU6ZIt9m82bjE7ZhRbPQwVdEKmEgyowYtmZB+oEMk5fpleokj3TdjD9xUjnCpXXRPj/J/buDxmYITnGzyvpwT5AEprRFP1W7XsV4BT5YW6wRb55kzz76jzU3hEov540xeMCdmmz5YYFjTHhYAeh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NaQr168e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NaQr168e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD78C433F1;
	Mon, 22 Jan 2024 16:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705942582;
	bh=bDbC5+OZYxWAWLes8ATPVhnQNB9i4jh3/Ib85vuOuo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NaQr168eQC+fJtZ81Kt7oLuCmIhejTtREmS2HfBx4G0gEtOn52NiR1bMkdHY8CPk7
	 KZKull2P42dW31+meyxrmSm0CT2zhewGyi7WvJ/cy8t/uDpDTbc/qfnYbp8vaZBh24
	 3HvQ0lplTC/LQyeIj3jMQfZnSEcifl78NUJ7UQCK2vV0veAk/fWhBXS6yjsXVaGjpL
	 Om68qRpvh6LkKGfbP3pvhWSjhBTtTb0BhvKOCuHcf0WURgRW6LH2RKEb6NFYNN5OiE
	 19fx2e7V/t190NA+9IaFxCrM8Haa0p8tfF2WO/c+MRpd4Y+DTD3rEVaRzxGjYes0hN
	 y41dGmpD4D+nw==
Date: Mon, 22 Jan 2024 08:56:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHv2] xfs/604: Make test as _notrun for higher blocksizes
 filesystem
Message-ID: <20240122165622.GA6188@frogsfrogsfrogs>
References: <89356c509e4cde7bf5fdea6b46ec45cc5b2afed9.1705910636.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89356c509e4cde7bf5fdea6b46ec45cc5b2afed9.1705910636.git.ritesh.list@gmail.com>

On Mon, Jan 22, 2024 at 01:51:20PM +0530, Ritesh Harjani (IBM) wrote:
> If we have filesystem with blocksize = 64k, then the falloc value will
> be huge (falloc_size=5451.33GB) which makes fallocate fail hence causing
> the test to fail. Instead make the testcase "_notrun" if the initial
> fallocate itself fails.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/604 | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/604 b/tests/xfs/604
> index bb6db797..fdc444c2 100755
> --- a/tests/xfs/604
> +++ b/tests/xfs/604
> @@ -35,7 +35,9 @@ allocbt_node_maxrecs=$(((dbsize - alloc_block_len) / 12))
>  # Create a big file with a size such that the punches below create the exact
>  # free extents we want.
>  num_holes=$((allocbt_leaf_maxrecs * allocbt_node_maxrecs - 1))
> -$XFS_IO_PROG -c "falloc 0 $((9 * dbsize + num_holes * dbsize * 2))" -f "$SCRATCH_MNT/big"
> +falloc_size=$((9 * dbsize + num_holes * dbsize * 2))
> +$XFS_IO_PROG -c "falloc 0 $falloc_size" -f "$SCRATCH_MNT/big" ||
> +       _notrun "Not enough space on device for falloc_size=$(echo "scale=2; $falloc_size / 1073741824" | $BC -q)GB and bs=$dbsize"
>  
>  # Fill in any small free extents in AG 0. After this, there should be only one,
>  # large free extent.
> -- 
> 2.43.0
> 
> 
