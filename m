Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E11B30568D
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 18:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779904912; cv=none; b=l+kZ9SnvGjR4tx8fZYfrGNDd8E+iGtZsPn60RozIWj8SQEFN8Qdt0jZRopFU9NiV8m3uofOGG/AmNal9gPNwB7DV71k+21YdTIuBprYe0qk7LcGbY3QOPPuMtsdfMLRpQbVK8H+etAB/FbwQUAciFTy0np/jIcUutwCzWKVQsYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779904912; c=relaxed/simple;
	bh=AW8Z/Au8Tq5XlDxclZyAo1BkoLpJpvufk05gLXd85Y4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u71yggaFPN/Z6W60y00n6tmRbc9biepOvQaT7vYVh3J/JB9Hctvo977dMShBzkhZtw513rjCdNFTsAWgWSJwomH66HVcxlm9jorGXmCq++KMdInc5uMQ1oUXGedxO+4DS33OKrZsYApdAGyQwedj6OIIWxfsABMZoq980bCiLbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e09amJ1+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e09amJ1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A41A1F000E9;
	Wed, 27 May 2026 18:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779904910;
	bh=wWEqRxAL3ao9J6GnnsfJ6nYmbd1rD1gsVXfyQvnzhOg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e09amJ1+AQ82b5w6zbDRsw9/v9F6wLyNMmwnMzv8t9F7GPjdvk5S37VokbpDsF9RJ
	 cZHb2bguCdK5OAXAhRG3ydK+c2Wl8xYcNaAgDfvoJ4KezP2mDGvQHGjWyIQPJFvcQW
	 zDzsoPV2NtjLMJ+suXNnYqG00YlIVZyJJjXr40HatcgH4ZW/+/hDU2mvaSYCwbopbQ
	 LRMaHtGtd0E3/dpvammgsiv93MWQ19eZX4m1Rru/6Ayp5dwAJXzgHCteJYGR6SreKZ
	 WVTnmfgFmpdRMUYBaOqdzYJMKS86GKcGM5Fpty/5og1mr2JbAUAZKXIXq39rsu8xj7
	 TpEFvtB3s7heA==
Message-ID: <f9b6ed6d-6df1-4f3e-a22e-af949f2b2b5c@kernel.org>
Date: Thu, 28 May 2026 03:01:48 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] xfs: factor rtgroup geom write pointer reporting into
 a helper
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
 Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260527123941.2319377-1-hch@lst.de>
 <20260527123941.2319377-3-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260527123941.2319377-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/27 21:39, Christoph Hellwig wrote:
> Sticks out a bit better if we add a separate helper for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup!

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
