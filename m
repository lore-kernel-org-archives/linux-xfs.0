Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1253FB39;
	Mon, 22 Jan 2024 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705942417; cv=none; b=ERqL47we0U7v5Bbo/K8Qhbikf2lYLTtJamXiL98iaJdoUyqCD/lxIpX470TMHoc5nTY4JcdryyUWZ9XCIzP7B5DM5r0cluafB3NHmmKHYnhbhBh+zpXl/caYOOGtyDAKr7L15iJV+I1Cdm4S6RvQ8KjPwFAohbuVqom+rRRczm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705942417; c=relaxed/simple;
	bh=+fUb/1geYCi6XXls1nF1ZIUE2qfx2ZMySSZL/UG0MSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FSAZSS0qZOhBzHrLTt5bzGx3PTjeiCd6LJ7KfYENIBiGSiEOvKSUU2ORFavvAI/Mpbl3zL51cmbKIO8oo7rt33uSQh1QjgZQN68yn8C8+qymZVVn/FXNKB2k7RFlwbEHbWpwjGHjvkE53my9HwhW3GDSH2Ww3hFBfqfgV3IFblk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bcC+Ue1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bcC+Ue1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095F4C433F1;
	Mon, 22 Jan 2024 16:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705942417;
	bh=+fUb/1geYCi6XXls1nF1ZIUE2qfx2ZMySSZL/UG0MSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bcC+Ue1XT04by/DjWImPMpD6ekEvDXjRvFRcU/lVd9u10Ha4/p7O6Lo8ucBI7BY/s
	 d1H1gkuZDWi82V1wifSj/4XHbLIbldNnnZE3TQrhl6rJCzaclolj3y6gQ1dU9deJRz
	 aen5yxPpGpbApazoF6fergFPjr1tiwfYhvi5cgCfy7nptqXXmNo3AmOovSfpkLtOpN
	 kK9hBy8fRKMVksHaclyh6yxuE3eNK+8tzbA+1wlqBPn7CQyjSU2Oe1mCpNGyOA9oQx
	 Zmhn9oBUF5IfEvClalEADtJ8ieULpehaesef2yjRRl4P8NIQYV4IseTd+7dPAAQ0Qa
	 JVlqWpzgdXLJg==
Date: Mon, 22 Jan 2024 08:53:36 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, p.raghav@samsung.com,
	mcgrof@kernel.org, gost.dev@samsung.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/558: scale blk IO size based on the filesystem
 blksz
Message-ID: <20240122165336.GA6226@frogsfrogsfrogs>
References: <20240122111751.449762-1-kernel@pankajraghav.com>
 <20240122111751.449762-2-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122111751.449762-2-kernel@pankajraghav.com>

On Mon, Jan 22, 2024 at 12:17:50PM +0100, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> This test fails for >= 64k filesystem block size on a 4k PAGE_SIZE
> system(see LBS efforts[1]). Scale the `blksz` based on the filesystem

Fails how, specifically?

--D

> block size instead of fixing it as 64k so that we do get some iomap
> invalidations while doing concurrent writes.
> 
> Cap the blksz to be at least 64k to retain the same behaviour as before
> for smaller filesystem blocksizes.
> 
> [1] LBS effort: https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  tests/xfs/558 | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/558 b/tests/xfs/558
> index 9e9b3be8..270f458c 100755
> --- a/tests/xfs/558
> +++ b/tests/xfs/558
> @@ -127,7 +127,12 @@ _scratch_mount >> $seqres.full
>  $XFS_IO_PROG -c 'chattr -x' $SCRATCH_MNT &> $seqres.full
>  _require_pagecache_access $SCRATCH_MNT
>  
> -blksz=65536
> +min_blksz=65536
> +file_blksz=$(_get_file_block_size "$SCRATCH_MNT")
> +blksz=$(( 8 * $file_blksz ))
> +
> +blksz=$(( blksz > min_blksz ? blksz : min_blksz ))
> +
>  _require_congruent_file_oplen $SCRATCH_MNT $blksz
>  
>  # Make sure we have sufficient extent size to create speculative CoW
> -- 
> 2.43.0
> 
