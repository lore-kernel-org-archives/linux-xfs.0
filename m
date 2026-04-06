Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7B8332610;
	Mon,  6 Apr 2026 07:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775459135; cv=none; b=E6gbng8TwUXZa78PJdK6Ggi2EryyjBtK/jI16uNVphCAEuzKl7BIYi8COW3qahqgGZEAYh3N+QezivGxh4JtD0ARV+SMJWGFeHWEcN2I6Uv363N9/SOPxYbmsJy0jp8+wUWCevBGa4/m66tSaJUVSi64r4XTkRz0++6HkujXekw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775459135; c=relaxed/simple;
	bh=CypMNNskROgCAaj/ebFf+KxbywlDe53u1fJ3marv89Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZPOZJunWBsk+qNy4HBbG8DWLQr2F0u10IbAIWIEIi9pTPP/sIeOxLp2STM6TFZCrTRdoo2lPQGUhfmoHo9B8x7aPIOO+roxunquC5fYAHweADViL0RhmFYq2x37o17C3mIa+338ouLfT3qItDCjq2IXVgDyEM/1z6O86fmqRUjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g4zrqPpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4zrqPpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19AAC4CEF7;
	Mon,  6 Apr 2026 07:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775459134;
	bh=CypMNNskROgCAaj/ebFf+KxbywlDe53u1fJ3marv89Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g4zrqPpFnFLH/gYUXbh3TOZZOY5ieVqsHa9XzwlyaqCPiaUzFf5SNYd7z6ePeawCn
	 6azxMOCZgBySYsmnfAVU2WlPrkhOuk4qbg/Cf9zq7ssfr/gOWaSfEXMsyvcwWi7UNs
	 Lwp3RfkPfxzJ9++cKCzVVTUFe1eHAa6MzXmMVN/+rs2Pz9t2+0ReW3BDmKahAxO1W8
	 61/iVJFM2pAwhegQgKMl1w7K93zI41fCRojCM00uV8bUsO/Khs08vM74HnFA2HqqcE
	 vqXIJLR0nfSVUAXeb7FsznTG2ytDu8kobqaElEjBXDw0Qxh5IKrLtSL6u91M04+JQR
	 uYi5+YTwNiBaw==
Message-ID: <8814db8e-1494-4ea3-ae93-8dd3d714db3d@kernel.org>
Date: Mon, 6 Apr 2026 09:05:32 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] block: factor out a bio_await helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260406055728.472919-1-hch@lst.de>
 <20260406055728.472919-3-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260406055728.472919-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/04/06 7:57, Christoph Hellwig wrote:
> Add a new helper to wait for a bio and anything chained off it to
> complete synchronous after kicking it.  This factors common code out

s/synchronous after kicking it/synchronously after submitting it

(kicking is a little confusing as it could mean "rejecting")

> of submit_bio_wait and bio_await_chain and will also be useful for
> file system code and thus is exported.
> 
> Note that this will now set REQ_SYNC also for the bio_await case for
> consistency.  Nothing should look at the flag in the end_io handler,
> but if did, having the flag set makes more sense.

s/if did/if something does ?

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bio.c         | 53 +++++++++++++++++++++++++++++++--------------
>  include/linux/bio.h |  2 ++
>  2 files changed, 39 insertions(+), 16 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 434e41182c05..c7e75d532666 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1468,17 +1468,20 @@ static void bio_wait_end_io(struct bio *bio)
>  }
>  
>  /**
> - * submit_bio_wait - submit a bio, and wait until it completes
> - * @bio: The &struct bio which describes the I/O
> + * bio_await - call a function on a bio, and wait until it completes
> + * @bio:	the bio which describes the I/O
> + * @kick:	function called to "kick off" the bio

To be consistent with my comment above, I think a better (clearer) name her
would be simply "submit".

Other than these nits, looks all good to me. So feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
