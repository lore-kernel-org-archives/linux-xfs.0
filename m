Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B4323D2B4;
	Fri, 23 Jan 2026 08:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769158548; cv=none; b=DFwicvK4liswtoypn2NLSm6ulrXPPxsOoB/pqpQVWnDInT34cDivLsEsFvJaVfCsqHcr/xNc5nTLtiO5EbW5EvJGoMM+t6zO55OzGBY36jgRgkJow91jdMwPOIW0+81DnnC9oFe3I4OQiNxcdnfs0FRrZnbmvXI+tbHmSWojXYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769158548; c=relaxed/simple;
	bh=D2STUJJevpR1tZfKzuqQPSXtPsstfQuMrp0UWl6vYkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UtUni5EV12ekQ+lTXPxPQqp53xwp+RcOSbugCUo8H53gTbWFXzzdPV8LdbA14hhKhfV2AiQWhg1fG9LtDUB3zMDbyO0pkia27AuMOkYDWB0TBOnwbzMb/rrhptunfhSw7cL1Yho7G9K1rpizYjaIDo8uXp4wdxF86S460n1jdZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4TCPNZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4TCPNZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E5FC116D0;
	Fri, 23 Jan 2026 08:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769158548;
	bh=D2STUJJevpR1tZfKzuqQPSXtPsstfQuMrp0UWl6vYkY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l4TCPNZyS9Yc36pw3fs0/9/Fcy/yRu/1/cs3jUycB9RN3tm4ShmrVAZrFWzmVvK23
	 W2uPkHbAd5DkHEs22oFaycAYVHda4ZD021cf2dCVxXv1oGyagkZFylknGPiEwOc4w3
	 hGOs8gy/19lDos4WpA17gLZ1HFw5OKg7sxZbchNWKGvOi48E0GjFbF+6+ehWdQM7v+
	 Rt5djmgJHRfsDTJa5sG376uC6TICrDPzBuCRtnelD9EIkNH2XV3GGXI/2Esja/4RPM
	 ZmsnsaHiwRZpOCy6nD+6gqM4bh2y5k/xtFXn1Bwk5W9W7g0CboL5s/1EQEkFPvrvAz
	 kc9mJlBlngoWw==
Message-ID: <5d471215-c06c-4eda-afd7-68876616e923@kernel.org>
Date: Fri, 23 Jan 2026 19:55:43 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/14] iomap: simplify iomap_dio_bio_iter
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-8-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260119074425.4005867-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/01/19 18:44, Christoph Hellwig wrote:
> Use iov_iter_count to check if we need to continue as that just reads
> a field in the iov_iter, and only use bio_iov_vecs_to_alloc to calculate
> the actual number of vectors to allocate for the bio.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
