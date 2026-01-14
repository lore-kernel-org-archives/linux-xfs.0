Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86DA3815DE
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 10:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768385104; cv=none; b=Lmf5ajhf9ziqV26nQqb+1+wQYqzapUyZDIqc6nG60TabK3FYvDrrwkVUIMH5l8Cs+ImNhQn5IBB1kDu0F6FSJ7kIc86MtZGN35LMODLq/gukCMmVaGTlq8ak761QFrLuPAavSt02AhHrTi0pVzJWcwuyYursfPPqtG+42RE/kcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768385104; c=relaxed/simple;
	bh=gdEOezixdTtBJRxjnBx5D1k63PxHg8a9nxOS54PfMUo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jPIG+jfLH1OhcH+HZHwb39gyzkiP0NbUJX9cu662tVO6Mmv15+UNp0PQDDIgYwm/OtGl0gzGSfDw7w5e6LUvH4U+KZ1m+cSWGQ83R3UQS0/62t0AnN3cjFYwRafwDZxyMSBQLEnW8VDJ5RCEtuRYaLbeWWphxI6FdDgvHc+QwEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5AWBRis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5AWBRis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACA1C4CEF7;
	Wed, 14 Jan 2026 10:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768385104;
	bh=gdEOezixdTtBJRxjnBx5D1k63PxHg8a9nxOS54PfMUo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a5AWBRis4eL+OtLfFf/R+A6X9UbDDlB3tXIOPQIX+e1P/s2SxBXzOuvgnj3GKvRFY
	 JEAUUqatBBaz0YX4Ig02EZL4H8hi8s4hqyaP8vwx6LCe7S8Kc3xdA0UhM6MiGwrcxP
	 /63E3gFTqNF/YyKpU8VWDU/H2ouXAxLMjJHfMP0BlVT7Zhv1wCUjaL+iAjyVYqFK7A
	 ods2cOJZX7AaMcvxVhJ/zgmGXcvyvOg65B203cnUB6WWmdMMcWPQRVSkNJy+G6bFSU
	 lVGRaoPsJ8QdyufYG27IuDWGqBEpby8t/kN+y+7JPbOn++Dwprag99QpoHwUZXgg53
	 UfY6ESUrV0XNw==
Message-ID: <54add301-8d00-48ea-aa0a-7ca9bade86ea@kernel.org>
Date: Wed, 14 Jan 2026 11:05:01 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] xfs: check that used blocks are smaller than the
 write pointer
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20260114065339.3392929-1-hch@lst.de>
 <20260114065339.3392929-6-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260114065339.3392929-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/26 07:53, Christoph Hellwig wrote:
> Any used block must have been written, this reject used blocks > write
> pointer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
