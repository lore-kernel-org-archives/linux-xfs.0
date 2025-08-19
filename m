Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4D9225390
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 05:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755583003; cv=none; b=OwUvTazgCsCCGanIwo/zMGhKFYETngiBRixbSWSWpHQO4QgmoFek7ZaAiRoUo34WFss5WBxam8lUjAta0n6kqRNvLtXyILirOaDuVplxKwF/WN23Ue7S1yf3oDCvT6WsLyO6QDObzv2YDByu/PG81J/sffi7pLeIsXWSo9cBhZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755583003; c=relaxed/simple;
	bh=smue8BOGuE7m4w//ejvA7qzBiOzVmj+WuD4dOY8apuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ldgU/lGW4Rb1/OjkkJJH6ZmKow9Ph6Vlu0cJJnDaKrDqc+75oUToC1hkbKrrr0JybT3LRyHiTHwuKU/pPNYSuaUXkJQQfH1dG5Z6UzrhoH9dxTsus42IOlwS7tVN9tuG1eWZVimbBH0s4HfOX+TTXcx8wuzzZU9T9vCIxvFTJ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1//YRRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1//YRRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4BAC4CEF4;
	Tue, 19 Aug 2025 05:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755583003;
	bh=smue8BOGuE7m4w//ejvA7qzBiOzVmj+WuD4dOY8apuo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H1//YRRBR1+NUi4Mmg7T4HT3E2iLscNoNleSP/59ZoACSc3iwI7yofLy6Q9WlGyUk
	 nPsuE/BOjhLT1IEiCue1luQP9KREf3nzvfHtQiCcX9K62jVVoMse+EeBSwi8+RyAKw
	 PV6sFu6O8VGdAvfhNeDitl5e8YPEPgxfRSfwEohDVRz480Mc81eDS5scQQM3tJ/VZi
	 ihBJ1UwBSKiHXRxjyxVln3AINa7KgsYc0yrBulfkWf92EUGtLnN1FdxJCB7v7Dtrb8
	 UlJGjnrYZolPtpAuyHKf/9xLsUI5RKv1aimySYc3TIHPUy3j21w12m4/s4FahZLpCb
	 mwFio4YDDr3Zw==
Message-ID: <aeaa9d62-cff3-49eb-835b-3d0e3d7180fc@kernel.org>
Date: Tue, 19 Aug 2025 14:56:36 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] xfs: remove xfs_last_used_zone
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20250818050716.1485521-1-hch@lst.de>
 <20250818050716.1485521-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250818050716.1485521-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/25 14:06, Christoph Hellwig wrote:
> This was my first attempt at caching the last used zone.  But it turns out
> for O_DIRECT or RWF_DONTCACHE that operate concurrently or in very short
> sequence, the bmap btree does not record a written extent yet, so it fails.
> Because it then still finds the last written zone it can lead to a weird
> ping-pong around a few zones with writers seeing different values.
> 
> Remove it entirely as the later added xfs_cached_zone actually does a
> much better job enforcing the locality as the zone is associated with the
> inode in the MRU cache as soon as the zone is selected.
> 
> Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I ran several write & overwrite workloads with this. No problems detected.
So:

Tested-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
