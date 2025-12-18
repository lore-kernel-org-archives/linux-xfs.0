Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415F1326940;
	Thu, 18 Dec 2025 06:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766040229; cv=none; b=DtLDsL2u1xazOXcUOOEKEO1bOVXTy8GemddNWRGoT2dZBE/gyQBrLcIE9BXTAjngxbveSO0eHPmechMaVaZhHPaOC7gktSjHARZ+pIpx1oPt/Y3AeDttjXMh2nSOJJk3gntdZ6/shvLN6iJVcw3vp9IcbZ6kcIBErcVHPnD5fxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766040229; c=relaxed/simple;
	bh=nMl6dQfS6MAndzc+cM4wOU/DH+BS+NDmaTjH3q3l15A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JKVj1ZKzYzGMzOGWc0T3ttpauy/zw4MxrKPqE1mGwjL8EpDe2zfvtVNKnIl41b3I/vth1F5RfQuWQuEF6aI9t7B1+UpoxR7Bytzj+PCtsrfqdnL4tjlavOJWBzsBoFmQQ55cmaWdY6YvKcN3Kgb3I5lT61O4aD23RZQKnaxqVp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJymeI5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJymeI5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB38C4CEFB;
	Thu, 18 Dec 2025 06:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766040228;
	bh=nMl6dQfS6MAndzc+cM4wOU/DH+BS+NDmaTjH3q3l15A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iJymeI5cmBbe8Ym0tpmigiRXAnQyNV/gP8sxqx8yqOc4w4SS46/SkmJfO2kDo11vU
	 n1SC3IKmJMIHsOVXTVyGDcRoz4VJTWxbRR2q0sa6IIIaDn3DTBJIwL5JJniWkfco90
	 hqwTIHi8TtmEzBUKm2WdtHwWquBNes0WFaXwyb6SNkaB3FD6dR6o9lmvkSBCzLqHaF
	 v7NMIxLIclV+yeEHs14bj2ZmLm+nSvyPR/nQk8o2iVLZn8Bl47Us3V8Cu+VNHpUiLq
	 iUAq9e9J7gMQ3nQw3TBSsJQWJkK3Mo1+XAMmy7Ri1Tf0ehlgP8CHS+WvgWCclVYOP1
	 dzPQNhhZPEqZg==
Message-ID: <f7859c1e-8092-42f7-9926-decb8bbe9bbe@kernel.org>
Date: Thu, 18 Dec 2025 15:43:46 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] block: add a bio_reuse helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20251218063234.1539374-1-hch@lst.de>
 <20251218063234.1539374-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251218063234.1539374-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/25 15:31, Christoph Hellwig wrote:
> Add a helper to allow an existing bio to be resubmitted withtout
> having to re-add the payload.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
