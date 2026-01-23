Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C5E3EBF3B;
	Fri, 23 Jan 2026 08:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769157957; cv=none; b=c76YTwGl9D8a9sVCadjTSWwZ1kaytB5kBQaRlawISb/XyZ0D+u+mUXhwuH8vMsIoD1ZDic2N8zTyXpgvnFl0Y2RvgkEu44OvlizPCsjESryy5645t3n2DURulFlXkHf/HiOsMG9PQpid4vX83PH9zQCh5hLRT7DU6BH1ZBaB77Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769157957; c=relaxed/simple;
	bh=NVC/nIB8Ob0bKGjmOr7ocSkX4ZAvDbuXj9iNGRRIz+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KAfDY3z8HPArjyn2DPN/Dyj/TT1f+nGwjiXCYx/7WQC9cbZGsmkBDLMCxP8yqsTsh7rMGIep/evkfVWybLOhEdvl6eU1QGYUUORLd1dcrVV1rCjpaXxxYvznKV8UaBLI9CL/rZwQs+m/N8ZmGCjJixtufnYpUPs/IA5aMOHzUFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BzJ/YhhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BzJ/YhhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC62EC4CEF1;
	Fri, 23 Jan 2026 08:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769157957;
	bh=NVC/nIB8Ob0bKGjmOr7ocSkX4ZAvDbuXj9iNGRRIz+w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BzJ/YhhKdQ5mT4pBGG/HGmkZLNlr3C5obrNvGixbm4+zlnSmuKSXMZ/JfV23LUWWl
	 cY9sbId7lR5qiosT9mXeFN7a+m8aOHbtuaxNLaFofg/+ryd3EyGbAkxNPvsQBoj7TN
	 zDQl+AOW7yO9grDng6rAix1a9NAQowRjdUuxxsazh4qPHu3TqwrXMMxtplHjraRvlB
	 myFPxCcgQKKV6wzBXxhqPzLeZDeBRSjZ7W8LwDNdrtldA6IPG2/73pFW8oXnZ2Olwm
	 /FA38wwuQJ4WmB/tVMPA8VlelfOUl9gWePTCQgCUO5p9MbOdkXCIN/ts1CswWKL+6P
	 tvzdqBVPxxDHQ==
Message-ID: <2e85080d-d056-4cc9-99b2-46b8b571d943@kernel.org>
Date: Fri, 23 Jan 2026 19:45:52 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/14] block: refactor get_contig_folio_len
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260119074425.4005867-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/01/19 18:44, Christoph Hellwig wrote:
> Move all of the logic to find the contigous length inside a folio into
> get_contig_folio_len instead of keeping some of it in the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
