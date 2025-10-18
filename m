Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D627E9443
	for <linux-xfs@vger.kernel.org>; Sat, 18 Oct 2025 04:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760760502; cv=none; b=EyMVvMjbcbAdsQ5uEjoLyI82HdNVCoc8oUG3qkJqifTORQZblURz4C+2+p5VapEQZPpfnWn4oP7OBbHkaHv21W6Y1Jz1zbBFNFw07zjuo7ujqJorSGf56coFklPHZcPzaFUyx8kLBj+nT51vVGn6TVlOVh89OD11eiEq6odWXPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760760502; c=relaxed/simple;
	bh=Bz2sqnxKpVPi1wG3weF9g0Ox+6uz191MfbDXRdZp1UY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HH+Y/wOxh530Z2Eb6l1zyI23LxgwVIb2WCjezTXTWqghriNKsVVRmWX9xAsWhIz9Vh83upugH/SmQTpA7PNeZzEauu1f5gYcb2tqqNbnj6Sj6WWT7uih9RKsl34d/xelReqJxyW7XHvzwVEZYGJ3rdu8f4IYNBcjMYaKbddCGQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rkg0s26X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rkg0s26X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E40C4CEF8;
	Sat, 18 Oct 2025 04:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760760502;
	bh=Bz2sqnxKpVPi1wG3weF9g0Ox+6uz191MfbDXRdZp1UY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Rkg0s26XqiYbA53dxRzzKW5mlmfDzvO6eICeL/tYZq0fMYIgYRNpXYXCfitXNiHHn
	 C5L4k7I7GOAjjAq/Fdcq6Zdc2hjigc0DkCuVK4aRMJlv+ngHEm4Y8yZG2tzuJu3S2S
	 gZcTdghrbEPTV/IF56fuf5MN/oeIGivu1VE0IKI4MwQf8VJUOAuAiqZ66GTBdD2ujO
	 dyg9FtH1bW6yD8dnWUdyQjLqitMXaZB6f+PM0oNPvrxXdd3MiuNCDP2SGBWlXBrBgO
	 0GUKVPP4b57EzAa/R1Lm1pZFmjiPFpoZ/orUaZeU+QB+dM2dbiFIvn+Ew7/u6USekT
	 TExb34c0zpdxw==
Message-ID: <25898d32-4270-4d8a-81ef-4304d2e60a16@kernel.org>
Date: Sat, 18 Oct 2025 13:08:19 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs: prevent gc from picking the same zone twice
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20251017060710.696868-1-hch@lst.de>
 <20251017060710.696868-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251017060710.696868-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/17/25 15:07, Christoph Hellwig wrote:
> When we are picking a zone for gc it might already be in the pipeline
> which can lead to us moving the same data twice resulting in in write
> amplification and a very unfortunate case where keep on garbage

s/keep/we keep

> collecting the zone we just filled with migrated data stopping all
> forward progress.
> 
> Fix this by introducing a count of on-going GC operations on a zone, so
> and skip any zone with ongoing GC when picking a new victim.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
