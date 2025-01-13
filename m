Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DDB76034
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 05:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736744694; cv=none; b=Cba1sRDE8BBdRqgfmlwPRDAOwJIg/RWo8MUwf4j8QQu7jNeYKcilbK59e2ZUj7svNSdi1JxVIIoAvWdfVPvvNGIdBnOyuow91G+6WK/A83710ieHQL7M6eINVz35SKy9ojxcDt+goqbP73BibDiqrRv9JuQLXOG+3luhj5nhnUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736744694; c=relaxed/simple;
	bh=hAwcPOJpYvOg2yeuZvaN+JeU9ExO0R2a+7YrPWCu9e4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iVw8a9SUOfyK37wcFGPlodd6se1UUhYAuWkaby+rfEAQBjMjQFhzG8sjpwE2EaJQUAhUgOfAxeWVmWTRafuEoWeeji7K02tht/wEN3mHPLZGT+fJLJg6M9CLvEbdHVAZWx2Me+TPUGwrhZ2hbugUSwZ/Z7BuWkCWlFf1dtExAFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOmakcf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOmakcf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4233CC4CED6;
	Mon, 13 Jan 2025 05:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736744694;
	bh=hAwcPOJpYvOg2yeuZvaN+JeU9ExO0R2a+7YrPWCu9e4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jOmakcf1ONwpe+poIP4K2Ia5kgOhJWEPuJA2PuWvf8nWhfjJTJ3Xrs8f6EpOe/UrH
	 Gm+MXsucXC3QK4bLspDSBuSmDhu+oWNRGTSGQEwtx5p/R013A4XVlU2JoCbiGo3eKn
	 qynPW1EM3cnq2mMRqR9lVM6SMJZGg4596r6KA+Qs0v7JeAUjiep7JZrU2rqYdk86pc
	 UStd56vfAIU8ExG4FgG21xSyELhqF23LLxUgKIVmhHSIhwUA7i5Q0bzf0wUJJoHXmF
	 eM4f8sAvyZZgCHS9eGgGFBHGGV/Lfa+1gGqS+ozUsN0Zhyqdjncmq19braewtYXGpW
	 9OBQ03RN+bcIA==
Date: Sun, 12 Jan 2025 21:04:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix the comment above xfs_discard_endio
Message-ID: <20250113050453.GT1387004@frogsfrogsfrogs>
References: <20250113042626.2051997-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113042626.2051997-1-hch@lst.de>

On Mon, Jan 13, 2025 at 05:26:26AM +0100, Christoph Hellwig wrote:
> pagb_lock has been replaced with eb_lock.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yep, I guess we forgot that one. :/
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_discard.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index c4bd145f5ec1..3f2403a7b49c 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -90,7 +90,7 @@ xfs_discard_endio_work(
>  
>  /*
>   * Queue up the actual completion to a thread to avoid IRQ-safe locking for
> - * pagb_lock.
> + * eb_lock.
>   */
>  static void
>  xfs_discard_endio(
> -- 
> 2.45.2
> 
