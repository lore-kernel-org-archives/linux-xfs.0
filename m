Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CEC2A1D6;
	Sun, 21 Jan 2024 04:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705812997; cv=none; b=ng7OBEHA4UQNcXriXEm2U5jotXG3CHNaPeSjBB0O/qA5uBhI66im3s2wnw62WCX0S+WLUWeh329oCvzhWS7Zg1rVSxwNC+1ghUEJh6eKmoG67klWFEmadAt15O67to5XeCJhFacCJ1tfTPekCLmXlnnNcpTCEDhrvueENFBoV6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705812997; c=relaxed/simple;
	bh=Ai6F7QE0Ib9TZ2en/6w7Iyas4/cd7z1+Uz3Mgs2DIHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOY7RFLLNTk76CkRKS9Z9JhlcsJsaudZ6LfwuWskVeujEyexILjrTS4kXaLiCXUX6uKnrBLeU6kgC0xC9bfCINp23XK9saxvXTjDUbW9nFtUt2A14HXmpepXYzt8CmrHzu2KQllDi2VNLXn/j8aKZbr+DnD5jFotQHpJJnBcaZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GV4rghNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GV4rghNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B50C433C7;
	Sun, 21 Jan 2024 04:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705812997;
	bh=Ai6F7QE0Ib9TZ2en/6w7Iyas4/cd7z1+Uz3Mgs2DIHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GV4rghNLPH/c2XQMw7lJ7M4Z/u4xVnBO2MVqR9ktlYNio4G73CWzmH2wSiRyinTe3
	 QlEfNunGxzW0Ucqj8TzvqSyvEI0y4F1eKp5cHRVDfyZDC0NzS7wc/CjhXaJuSF6Fbe
	 +gbHAC6z2wVJL9cNHleYPY8Ilckxivk46symbgT7NUOlVM6JaM6R2X3YEJ0JTxxcrA
	 /hYLbaUYAzCixOTU7w//xEzUlf5h4BBb65rMZdLYmC03tlaV0jW4ZHplnKqEOtSTQS
	 SXORsgyX+dCQz7KYw48toquW6LHVlGm9gZZgJEK60tXL7gHTzXZknnGheCSSAXbkm+
	 0ZOqmkeeC0oQw==
Date: Sat, 20 Jan 2024 20:56:36 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/604: Make test as _notrun for higher blocksizes
 filesystem
Message-ID: <20240121045636.GA674488@frogsfrogsfrogs>
References: <070f1491c25c37d2a9e01a40aebe87f3404a4b69.1705656364.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <070f1491c25c37d2a9e01a40aebe87f3404a4b69.1705656364.git.ritesh.list@gmail.com>

On Fri, Jan 19, 2024 at 02:57:45PM +0530, Ritesh Harjani (IBM) wrote:
> If we have filesystem with blocksize = 64k, then the falloc value will
> be huge which makes fallocate fail hence causing the test to fail.
> Instead make the testcase "_notrun" if the fallocate itself fails.

How much space is it asking for?

--D

> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  tests/xfs/604 | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/604 b/tests/xfs/604
> index bb6db797..40596a28 100755
> --- a/tests/xfs/604
> +++ b/tests/xfs/604
> @@ -35,7 +35,8 @@ allocbt_node_maxrecs=$(((dbsize - alloc_block_len) / 12))
>  # Create a big file with a size such that the punches below create the exact
>  # free extents we want.
>  num_holes=$((allocbt_leaf_maxrecs * allocbt_node_maxrecs - 1))
> -$XFS_IO_PROG -c "falloc 0 $((9 * dbsize + num_holes * dbsize * 2))" -f "$SCRATCH_MNT/big"
> +$XFS_IO_PROG -c "falloc 0 $((9 * dbsize + num_holes * dbsize * 2))" -f "$SCRATCH_MNT/big" ||
> +				_notrun "Not enough space on device for bs=$dbsize"
>  
>  # Fill in any small free extents in AG 0. After this, there should be only one,
>  # large free extent.
> -- 
> 2.43.0
> 
> 
