Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901F23E92A7
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 09:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774950808; cv=none; b=iEmNp0I9fCev+GNEAyuydh6plNLicdBGadl8w1FpQsmc29x+Hooq33LHlccPXP7SyxQNwu0Uny3dQKc3tTTAi9zjMPTloVJpLdbaFBfVUBnsMHqa7gwIJQt7fn4CILRF2w1890IZ9QQLttKCK9cqkFjwWKZ6LCUHMbcBvwDNsV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774950808; c=relaxed/simple;
	bh=UpzC3SPVW6wpsriTQmcAwUM1xU0UEQrWsO/woVTWjzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DKbtYxMMkiTHFx75c9qP1n+nrjNVUQChreOxBj50h6sDtLTbl7qAFS7Y22bzd6dqbo/Okunq7VjPNZOI3yfR1LU8miy1p9hskGWpibffvGKnT+VqehdwnMBjlGy/4jn1YFI6XQNE0jmZVy7mZXitUvG2Mof27O8ZXtizrxS+FtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dzHz2itP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dzHz2itP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9995C19423;
	Tue, 31 Mar 2026 09:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774950808;
	bh=UpzC3SPVW6wpsriTQmcAwUM1xU0UEQrWsO/woVTWjzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dzHz2itPhGXb2Q4J+I87JSfh+/VJixkoRmQOhXQvD5u8/6U7iP10EgozB/3KOQ4cu
	 qUnlEvoWgZWCuD0JQlW6d3eefAln5G3I1tNoHkOxS71Yat6Tx36Z1UIAqXjZWAGgNt
	 +QxQfyx38VpscmtsMFJ331/dXxzEU2MWNuoBDhcsZPkmw8rVCGjiL8tfVPRQC1+RIe
	 QnqojLVzBZF4CQm/Jewsk7dZBwPgTqKmndqUneMQMJO3LveybzhJW2ucnDUhc5EySR
	 SLSzJQyOOV62pc+IGEOQc8elt2CXHJu+lchh7fZuZcRz+Z5kKLN/zE/In69apYTJIc
	 b7MA1lh7kP1Bw==
Message-ID: <ef07ed36-c2c8-4711-bbe2-c01afd6dabc6@kernel.org>
Date: Tue, 31 Mar 2026 18:53:26 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] xfs: reduce special casing for the open GC zone
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-8-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260330054533.3856339-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 14:44, Christoph Hellwig wrote:
> Currently the open zone used for garbage collection is a special snow
> flake, and it that has been a bit annoying for some further zoned XFS

s/it that has/it has

> work I've been doing.
> 
> Remove the zi_open_gc_field and instead track the open GC zone in the
> zi_open_zones list together with the normal open zones, and keep an extra
> pointer and a reference of in the GC thread's data structure.  This means
> anything iterating over open zones just has to look at zi_open_zones, and
> the life time rules are consistent.  It also helps to add support for
> multiple open GC zones if we ever need them, and removes a bit of code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
