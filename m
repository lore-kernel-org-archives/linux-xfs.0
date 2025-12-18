Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2124923278D;
	Thu, 18 Dec 2025 06:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766040328; cv=none; b=k8c54WnaIDYQL5gR09/znV5aMXTRTRih90SS2jLDWfmivs7SZyOz1zk1niRaGzeBajo88KnQPEm64S0RFRpvMSgWaIHkqMNb+6l1YMGlmO1pE1XYJnk77yUd0hqzCLMOC7RraqAjN9u3pZmwGqAcjDPMv4vlp1UXb9U4Xcv2G80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766040328; c=relaxed/simple;
	bh=6MYD3OwDGgwPtfd32eAYCs6ap0Xds5MRAH1Q9JC6oHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JRZ8NyEBFwJ2A/bffNbKe1eRlMIjoRE+hEN6fXqU46Qes5FNpMxAO61hJXhPrvnGjdKP1Vpi/dFOqUfWX0NOtkYeAqlvzXjaImTUgVIjnkxbjQ9DkRccaIEoeubyvUASptl5X2i2jwV9W3DK0jCDb6eNheTR2VpvgS7IaSxh6LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ACU+lBQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ACU+lBQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF2BC116D0;
	Thu, 18 Dec 2025 06:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766040327;
	bh=6MYD3OwDGgwPtfd32eAYCs6ap0Xds5MRAH1Q9JC6oHE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ACU+lBQtksD0ZeEGahr5ST4yab6KtguybHP1A7Cl29eEJ9NXPilmpAPQsgBILfeIU
	 wlHSrUJsYJ2TPakFqS79C0Tt4YX4enUMHlvKLniAY/0NWhkRd59L/2fFgldcx3JEgT
	 guKG0cX6KJ51KHRhfl+KlSCCsnTwPWZM3WJuFvQie4nz0L4JEJ0RyOdi3CF3ZI3wRU
	 mPFHON01F/UXSr6WD4z/UKw98Z7XnNw5Hawlc9lqOtwCSyhp5nBRUqnRihFthYftul
	 TSFp4ZzuRomCWoKdASYhdAm/JhRxln87x5XK2Lnbagupd/Hd5iWrA8GgIJdMJMrzsg
	 J+SSlwMMNgvOg==
Message-ID: <23ba239e-702e-47a2-9cf3-e02b53b96426@kernel.org>
Date: Thu, 18 Dec 2025 15:45:25 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20251218063234.1539374-1-hch@lst.de>
 <20251218063234.1539374-3-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251218063234.1539374-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/25 15:31, Christoph Hellwig wrote:
> Replace our somewhat fragile code to reuse the bio, which caused a
> regression in the past with the block layer bio_reuse helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
