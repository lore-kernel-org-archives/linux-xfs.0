Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C246A31BC84;
	Fri, 23 Jan 2026 08:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769157860; cv=none; b=Vo4w2Oa3GzzD8XfSGewstFE2Iygk70aEGVvHHTfMRIZsE/gB1L6OM8T5GloSlvqPe4CNgsGQe+EKT8VHfROdz5NGZctHjqG/yL7EJf3pSrZAnGhklSBSyIE+ufk8Is8DMFOoagFvDkcE2CasGBdga7nC0eMy8IKPLBcSpPtVCoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769157860; c=relaxed/simple;
	bh=9LlZuX1hwZ6QaSfnRVgMW3t4M4VIWQmFz5B5UZevCHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iy6eVtJ1gPbUmaL5UDEx2hj63m+0DTOrTiU4PZOZPxI0Ovxc9g+frZSGHsyMnFa7G51qYu4/w0MRMlgYb7pOTVd0Br2nVBoetTpEGeWSusKwjVAyWPNZqofd3TWX3oEeAujAtoWSGhqLLl4z8r7QN3yEYy+aZqng3CLUhqfXQ+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p9eQ2LMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p9eQ2LMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599D1C2BC86;
	Fri, 23 Jan 2026 08:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769157860;
	bh=9LlZuX1hwZ6QaSfnRVgMW3t4M4VIWQmFz5B5UZevCHI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p9eQ2LMe8Hy2MebXv5Ab4xA8GkN7cmcSViWsfqWP/4yMuBA69S4e7mhMUd+Pfk84x
	 iLp6UHVq4mnhNXA1XfYWjZPMixbbfN2WhpOJ6GTb+2MkyyN07DN0Z+vOxuoes1SfaT
	 mCqtRh1UBAitCKGcVFzj5ib7G0WXGI+RoMbD/gGf69oWQM/rA6rEW14f2kF2X+gV46
	 MU1lInyg1SFRLOecvdRxAXJw5vbWRFzA9C5tjONDeN9btFbRAmtHQvhmIjhH/4SBAa
	 J5UHteoYd+jCO4sWSF1pT7B0N+OAjaMR1m9CmzRvf1/O/37JUahO2QKkkkdU2uzKno
	 JU3zCQg6Jc1tw==
Message-ID: <eb964806-8cf1-45ac-a02e-69fed1baf123@kernel.org>
Date: Fri, 23 Jan 2026 19:44:15 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/14] block: refactor get_contig_folio_len
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-2-hch@lst.de>
 <824538a6-ce9d-41e7-9485-10ff9e4d5334@kernel.org>
 <20260123083554.GA30708@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260123083554.GA30708@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/01/23 19:35, Christoph Hellwig wrote:
> On Fri, Jan 23, 2026 at 07:32:04PM +1100, Damien Le Moal wrote:
>>> -	unsigned int j;
>>> +	struct folio *folio = page_folio(pages[0]);
>>> +	size_t contig_sz = min_t(size_t, PAGE_SIZE - offset, left);
>>> +	unsigned int max_pages, i;
>>> +	size_t folio_offset, len;
>>> +
>>> +	folio_offset = PAGE_SIZE * folio_page_idx(folio, pages[0]) + offset;
>>
>> folio_page_idx(folio, pages[0]) is always going to be 0 here, no ?
> 
> No, page could be at an offset into the folio.

Arg... yes. pages[0] may not be the first page of the compound page...

-- 
Damien Le Moal
Western Digital Research
