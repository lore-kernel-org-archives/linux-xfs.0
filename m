Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAE37FBA8;
	Mon, 29 Jul 2024 16:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722271249; cv=none; b=gkDkg8QU1mXZbM6MmDqyqPuIkkZQ+uYBUqtdFvXZ+WhyL40BrYrEdQhizHohGhzH3wUxLr6emLQbpszAFv9lJBDt5LZgMcdc+vaowX4lF8VRLynXj7LsLCG+8a27lfnaQTgeBu9e5Qt6zdr/0DKSRUJYQR3KUhEhtTWEZHYeot8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722271249; c=relaxed/simple;
	bh=OQkrbk+hOnFu1OaBLJHjJq5G5WV6XLfbmN2mOM1fu2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OnVwHlTxTQIxxYTJgGZbEDT5oNQPpTJWXX6/2YCQ8d/C9JU/a81oFNLDTNlq5z1s/1pviy/8A9ahejWMhOB7qoiBgtxbKTnYtbeWl4eSayVt03+ZUek1GBKoDg0SG43JR/dPzgxlVNsLqHHmjOYzwydGZpEE9d1FyLtgB2g2bQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HbwuoLRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HbwuoLRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF241C4AF09;
	Mon, 29 Jul 2024 16:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722271248;
	bh=OQkrbk+hOnFu1OaBLJHjJq5G5WV6XLfbmN2mOM1fu2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HbwuoLRH6qBxRxFX9pCy1svh6uPFriGyJMlmUiAcxgGl6KUlSb3bcKMYPTcCRDs10
	 KGYVKw6EPUjHTNAdLxd7aYSCBIyg5M2TTBIxuBImaqHl9yhj8p7VpmNQ3INuwdn4lv
	 xGNiA5/jaOQ4B6EamKlFfC27nnn3BpywWF/waVUn1VhiQNtIPpBOla9uE2Ib007uXt
	 MCdZVPTbqdoSRVomtO1m5tgq1XqOdoVboPeXIAxr+n3NA8qM6CSgQfBmhat+pmRdEi
	 JzWVrjIfklACZWnFQOgnPCrCxOqLk55VqKJjLrGpE9ch1X3TdOjOZrZI1uigVePRc9
	 sIgpj9uHAVFWg==
Date: Mon, 29 Jul 2024 09:40:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] add more tests to the growfs group
Message-ID: <20240729164048.GA6352@frogsfrogsfrogs>
References: <20240729142027.430744-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240729142027.430744-1-hch@lst.de>

On Mon, Jul 29, 2024 at 07:20:26AM -0700, Christoph Hellwig wrote:
> xfs/127 xfs/233 exercises growfs behavior, add them to the growfs group.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/127 | 2 +-
>  tests/xfs/233 | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/127 b/tests/xfs/127
> index b690ab0d5..4f008efdb 100755
> --- a/tests/xfs/127
> +++ b/tests/xfs/127
> @@ -7,7 +7,7 @@
>  # Tests xfs_growfs on a reflinked filesystem
>  #
>  . ./common/preamble
> -_begin_fstest auto quick clone
> +_begin_fstest auto quick clone growfs
>  
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/xfs/233 b/tests/xfs/233
> index 1f691e20f..5d2c10e7d 100755
> --- a/tests/xfs/233
> +++ b/tests/xfs/233
> @@ -7,7 +7,7 @@
>  # Tests xfs_growfs on a rmapbt filesystem
>  #
>  . ./common/preamble
> -_begin_fstest auto quick rmap
> +_begin_fstest auto quick rmap growfs
>  
>  # Import common functions.
>  . ./common/filter
> -- 
> 2.43.0
> 
> 
