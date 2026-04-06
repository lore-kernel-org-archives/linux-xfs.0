Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A965E2E1722;
	Mon,  6 Apr 2026 06:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775458779; cv=none; b=E0NHQ0vcXR+X2S0WTJ9lpHLybYiGfC41jo58/ydODkdAl+g4ReRVia4XrMeQAIXbvRC1vzfCPZEHy8hphYCVxxfd5y0ioAidMimnKgzzcPkjn3ZIKQTKKYZ7T8ZpK7CZ4ss5JFoHJrQTaQLc948nZxiI6W1bCmtIIxrwdVOMwM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775458779; c=relaxed/simple;
	bh=TINOOEzYXZk6Uyul8GJb/de3g2f7kAZbZ5P/QnqTTIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XsbYRQLe/9ulhCV1EbyYCFO3jJAIEN/vHWmYxiRgoT2jLHQbjuyjporLQuLr6j5TgnwH6rD3ORKq2qOOMXHNmPC+nf270izIQpoKFd0bLCGILVTDqqCZ18f6aCWfRvc72k7KtC8enVoxQEH2X0GwPPm9+I1eG8DDjGpQoVf4HEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IL7BpSmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IL7BpSmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D0AC4CEF7;
	Mon,  6 Apr 2026 06:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775458779;
	bh=TINOOEzYXZk6Uyul8GJb/de3g2f7kAZbZ5P/QnqTTIg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IL7BpSmTnlnaTWOvOcWyXSjKE+hOwx9vA2ojDNS9lYDWTVvKlJedDG14OG/vBIRbq
	 ASLwGnENjQ22YZGbM1Luw8PcrAIg7YrJbNzqE1v3m0bljjV5XNMFGfPSeEIEvGen7G
	 BrFMuVo6+zYlR8Onag77o5zmMLZgNnjRAPPHk3OkUfqI4VuaDXcVyFEchCiOtufSsW
	 TL556mill9znmaDcMtKALwyCt5Eg9cfwQV2U8Lo1bTmvn/UPxjGFLYqrk7zF7xGENP
	 dk+bHU9F2F92sjnoasxRzACl9TpV749XU1CXalKfg/T6RhVHD/pa/f6CyemUDwXJHf
	 Tot3fq4a1ZKuA==
Message-ID: <5327b55d-d66f-4830-abc7-6a890ebbfef4@kernel.org>
Date: Mon, 6 Apr 2026 08:59:35 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] block: unify the synchronous bi_end_io callbacks
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260406055728.472919-1-hch@lst.de>
 <20260406055728.472919-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260406055728.472919-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/04/06 7:57, Christoph Hellwig wrote:
> Put the bio in bio_await_chain after waiting for the completion, and
> share the now identical callbacks between submit_bio_wait and
> bio_await_chain.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
