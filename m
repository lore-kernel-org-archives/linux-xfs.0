Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5752DCBF3
	for <linux-xfs@vger.kernel.org>; Wed,  1 Apr 2026 19:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775072876; cv=none; b=tR6HfE7cHQw/iPO327+6wlVH/xQNQLDDor0Sa190feQxdRXtan6kKQ/XWSG4a+SE74eZTPASP9cZbupEt8V095G+gbSmTm0M3DaOh4EFmEye6SrmR9fFxBs7J9yc7ubm0NdXXtvfslUCEqvl0wGATwjILzOhoFXQMydCp3b+D9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775072876; c=relaxed/simple;
	bh=DzwQdDDYEyW76kNNnjlKjY/HOoYATXdiF4TiJbpeeNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WvzZ9EbE6gQEq8quFQsW49bHrqjqPz2VD4V7aLd9ZUT6Q7bl/ui6Af6QxA5ubDwDFHseuu9NoMCy4BhCnpgl5aFUYpqXkNd3jgVR1WaxeZk9hpAG95tb0zgQ8JDW0xMnu6tXmA1TfwG7Q4rJE62YvECLjLuB0LpogSRauGkDsHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSpa7JeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSpa7JeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6143C4CEF7;
	Wed,  1 Apr 2026 19:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775072875;
	bh=DzwQdDDYEyW76kNNnjlKjY/HOoYATXdiF4TiJbpeeNE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YSpa7JeRaVkj8DeECRViKRa+RG67ip9Zg7f2RjfQJvsU7PO1ClxihTcopgIDNwYrg
	 wb2Ci9vpTD/vljfo3s+kEuFuBBJ52DN4ZKneN1duwU8hwSlHYB4zhzkri3F5TyMpuj
	 QqpCt3AGk5p3v4s337uDmBzG0TP9hTYHv3COcVJ7go2nJgh8Gk8WNMmxXHga1PxpaD
	 NM0a84bo2kH7PreLwEhHe6HFANq9wNMCkgY7AcZg4tAweF7tjmatDAS/FdX+N8hzqh
	 pNwwHZMrEqANmBTa9iWY0HOVha/l8fXWK4ZixW9OEP12RvB4gqT0JUZ5L0QsSWrZAt
	 GBmZoXn9G/Z0Q==
Message-ID: <204768d9-c456-4c0b-9c8f-e3f0fbc53ca6@kernel.org>
Date: Thu, 2 Apr 2026 04:47:53 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix number of GC bvecs
To: Christoph Hellwig <hch@lst.de>, cem@kernel.org
Cc: hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
References: <20260401135801.124987-1-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260401135801.124987-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/26 22:58, Christoph Hellwig wrote:
> GC scratch allocations can wrap around and use the same buffer twice, and
> the current code fails to account for that.  So far this worked due to
> rounding in the block layer, but changes to the bio allocator drop the
> over-provisioning and generic/256 or generic/361 will not usually fail
> when running against the current block tree.
> 
> Simply the allocation to always pass the maximum value that is easier to

s/Simply/Simplify

> verify, as a saving of up to one bvec per allocation isn't worth the
> effort to verify a complicated calculated value.
> 
> Fixes: 102f444b57b3 ("xfs: rework zone GC buffer management")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
