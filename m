Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CB93A4532
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986357; cv=none; b=tiJAA2gfP2/NdzCgnc5KXva7wBJZwLzjXTnmnwY8taIQfGBGPS+2hQU9SvYE4I3ahYtwKWQmQFANRCKDd9OwVZDnVXN8Kqu82V1RPW8WoTiTC6nvjJvy8MoADUkcZIoNs4GzI0sDemvQp4uE3cKvRDO6L315ga7r/FDTo6gtmB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986357; c=relaxed/simple;
	bh=WMEGoeKNa36L7rLgn1Ij5cEwVhoxdCR84ioMuzDOo88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SVFqfJ06+0J54F/yBbb3Uerj1ywO/XBFt9HQ47smZKpMt3aGo+uR/5HN+Fk3ngpvi/1Xbx6VQ+cbyvlsQc8SdvUFGF53jrYW0l4CzIx2zptsoz9kAb3vY4ff5WuV6icJ1QdNw29LbDFRJBctaflGIg5QP9qibkyc2EGE7TBeA90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AosiPsnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AosiPsnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9F7C19423;
	Tue, 31 Mar 2026 19:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774986356;
	bh=WMEGoeKNa36L7rLgn1Ij5cEwVhoxdCR84ioMuzDOo88=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AosiPsnPnGxOPEq8KE5eNOuSxQW6SfFeYJ8fFMz1Wtksv3SHOCgbGB47gzL3ySye5
	 DJhYitRYItgEZsasjZySv3IQPrCCTHrCejVi1hYK5pIj+fIVrcSh6LcljWmqyyjaN5
	 cnD16v5OjuOLUBgjbO9lThEgSaLB43ttWf15kvlZOvR/kJwl6mWZspuExbsOq42ifB
	 LkQg3SobTaXY3lEhK9+gO5fQh1pOQFwRCOuAfLd5z9tDyvmr14XNlXioajf1cjdDvv
	 DwULTLO15ix8RiUDgpdr0rva8kyaE0PJFtf/ps2q1lFygWrLG/D/FTpqqFbKon15Ly
	 0k9Q4/5UVzqvg==
Message-ID: <0ae6d911-e6f3-4d0d-a8bc-357bbe8e68e2@kernel.org>
Date: Wed, 1 Apr 2026 04:45:54 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] xfs: expose the number of open zones in sysfs
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260331152751.4048218-1-hch@lst.de>
 <20260331152751.4048218-9-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260331152751.4048218-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/26 00:27, Christoph Hellwig wrote:
> Add a sysfs attribute for the current number of open zones so that it
> can be trivially read from userspace in monitoring or testing software.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I am not sure if the READ_ONCE() not being paired with a WRITE_ONCE() really
helps here.

Nevertheless,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
