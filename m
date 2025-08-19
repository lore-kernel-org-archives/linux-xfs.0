Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCFF31AF25
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 07:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755587856; cv=none; b=rVgEKe1x8+Yes1cSvCFPMc2852pBnWv0kz9s8++MIrt60fk7tt1ompgUJ2CrjNgHdYr1eFzwzvNAmq8Rb3CIMwtuEjK0s9/JcLBHlCSF8LtoVvyvdRVZ78qtxTxu7VYg3/20/fevNYG+irl+aQrlAUO/EdASUQhN/CdCH7WVOZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755587856; c=relaxed/simple;
	bh=0IO/5w7tMqmhJ4gTqGNr1ZvyhBoqyFitJL84E9tw5Yc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K1nEGPh3Zti5p3NYwuiORCRv8v4RMT6Q7m9T9BVirAkRyafJ/oeY1cZpb9RPtADC9cBKbkDppT4unruduVtFLJ38WEt+ofIslXeL1wV9rPEUvDAhNv3Tv8+EHkLmMWgtJ75GpRYQeLpmSqRH1TBLnXNSI1OjrWSuSO4hgFI2tpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QMrcZ4h4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QMrcZ4h4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B79C116C6;
	Tue, 19 Aug 2025 07:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755587856;
	bh=0IO/5w7tMqmhJ4gTqGNr1ZvyhBoqyFitJL84E9tw5Yc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QMrcZ4h4NqMtql2Vz9Qtz1+jALMdd/+0t1vIwqN7T0I6Ytj5J1XvOi4KeVjeXyrMe
	 5/XAiDquJm0KSz6BJjltk0KHaZZXxQZW3+yDagQHXmha9HhuDdY4Oxc4/zvnliSN2k
	 6iIC6O3gIule5gKgNa86CO1OP2H8gbydN5QPD400PwLPQKgqE6DpePyfb9OEaMxDAi
	 3F5xhJ7LDpDO5w2UxRYViqWAeSX8t1K2NeAXYb3tkpsLr60h6/8Qh63tvBYjBbDbkg
	 d3LmN6fGOTYhlMFFuzAsIyA1ENmTy0GSxNEIH8Zetu9EoenxZ9L4V726bkl8u6JUhp
	 +eCJUY3mjWK2w==
Message-ID: <c2fee9f2-5eb7-4e35-9242-7fdb5efb4420@kernel.org>
Date: Tue, 19 Aug 2025 16:17:34 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] xfs: reject swapon for inodes on a zoned file system
 earlier
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20250818050716.1485521-1-hch@lst.de>
 <20250818050716.1485521-4-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250818050716.1485521-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/25 14:06, Christoph Hellwig wrote:
> No point in going down into the iomap mapping loop when we known it
> will be rejected.

s/known/know

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
