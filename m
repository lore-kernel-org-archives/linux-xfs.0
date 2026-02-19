Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF2621E087
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 15:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771516450; cv=none; b=hbl66IyD7eTS4GbHhPKiwjSaYC+nUiJhmg4y3bA6VG02/PE7vDBimL+TdjVlZwAEGYG8+pZCrIzUXcCHyiJBxI6PzeVuuPvCXLjWwdV5PqalSWHT7goPr7k9XuJVuZn+Iu9cwCYxnpvPJL1aT2WNAavB6WvjnZNjqBlRakuwWUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771516450; c=relaxed/simple;
	bh=fFj91ggbcQugiyV/dXdEb9PaQoMhRw0hYhw8AEJsKe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rTHARc2vR7h5wFkVow/Utp1CEIzP9cDEcG2osbFBnHmBA/MHUa3x3qMyhl6Pei9P6hW3M80DGNB5Ffs/fFDeVjAPhaLAQsL8Df7Pen75PPzs4sdg0b5O6VeBCmVyqkpHHARID/guP3AGuyiFti0WgaeImyk3Gywp+z9AJwOdeOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhgYE2so; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhgYE2so"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1FCC4CEF7;
	Thu, 19 Feb 2026 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771516449;
	bh=fFj91ggbcQugiyV/dXdEb9PaQoMhRw0hYhw8AEJsKe0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HhgYE2soMRffvxa/3xnr9jadjP8JtALeyQyZmUYQrl/oDYsQFbsU5QfBEGV9Qu+In
	 ZdWS5c6AEyDnN4E62O2pE3OTyZMbL4fDvpUxq1NtonD2uH8W/AzOW+1dcOV8y+90AS
	 pErwiZ9X4UzH9BbAdBatAYalfb5lhYrFks7Il7YPPOSqeKOVO4vwfaedcV9y2NOizK
	 3V/shqx+wJW1s5RM2MJV8+D/FYNgav9uZYJYw5sirPmPu6OqKVhrldsLV9bmaCftMw
	 ipPabhbnQLeKUCWI9ev/fGlyux8/v8IUL4ZyBAxttHrvMLByKMHUOFZQgZL73bD5L3
	 mmWmM+tSzYgCQ==
Date: Thu, 19 Feb 2026 07:54:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: hch@infradead.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: Re: [PATCH v3 4/4] xfs: Add comments for usages of some macros.
Message-ID: <20260219155409.GG6490@frogsfrogsfrogs>
References: <cover.1771512159.git.nirjhar.roy.lists@gmail.com>
 <ed78cfaa48058b00bc93cff93994cfbe0d4ef503.1771512159.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed78cfaa48058b00bc93cff93994cfbe0d4ef503.1771512159.git.nirjhar.roy.lists@gmail.com>

On Thu, Feb 19, 2026 at 08:16:50PM +0530, Nirjhar Roy (IBM) wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> 
> Add comments explaining when to use XFS_IS_CORRUPT() and ASSERT()
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  fs/xfs/xfs_platform.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
> index 1e59bf94d1f2..c9ce0450cf7a 100644
> --- a/fs/xfs/xfs_platform.h
> +++ b/fs/xfs/xfs_platform.h
> @@ -235,6 +235,7 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
>  
>  #ifdef XFS_WARN
>  
> +/* Please note that this ASSERT doesn't kill the kernel */

It will if the kernel has panic_on_warn set.

>  #define ASSERT(expr)	\
>  	(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
>  
> @@ -245,6 +246,11 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
>  #endif /* XFS_WARN */
>  #endif /* DEBUG */
>  
> +/*
> + * Use this to catch metadata corruptions that are not caught by the regular

"...not caught by the block or structure verifiers."

> + * verifiers. The reason is that the verifiers check corruptions only within
> + * the block.

"...only within the scope of the object being verified."

> + */

Other than that, I agree with this comment.

--D

>  #define XFS_IS_CORRUPT(mp, expr)	\
>  	(unlikely(expr) ? xfs_corruption_error(#expr, XFS_ERRLEVEL_LOW, (mp), \
>  					       NULL, 0, __FILE__, __LINE__, \
> -- 
> 2.43.5
> 
> 
