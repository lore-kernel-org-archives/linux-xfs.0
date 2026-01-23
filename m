Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258CF2EFDA4;
	Fri, 23 Jan 2026 09:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769158849; cv=none; b=XtkVAIiVrls+btVP/rff8Epl974xwLkeRPSibSt4V9BMRqxdFWMwqxzUeFP/BrR3fFvWYPfgLMROeSXCar3fNCKTU7+LOofRDH+DhX3h6ozM3LXfb6aZHYNMvwQC43m7HZGbYNilVtJWS5F81wJWJOCkTBGL8WAyCU5nrKX67Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769158849; c=relaxed/simple;
	bh=pToJvEtdbpwdGl5lnBQ6BjWknjdVmmPbW2qjatpsbIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FrsqBVRTFic11za5+ddYF+CXKpv2iHlHxINkVOP/K4gAIbkT5p84jhKQEJj0gity2zRZcfMb+vApFCenCKhtVdagj58xj16Q6Ve/RPxtuf5e0os35uh2nkHNhv1gzJSIbs630eUtbR753RcJMQJi5aJ5EWtNEfVT5aOfvmS7wFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GWbVwJt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GWbVwJt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3E4C4CEF1;
	Fri, 23 Jan 2026 09:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769158848;
	bh=pToJvEtdbpwdGl5lnBQ6BjWknjdVmmPbW2qjatpsbIY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GWbVwJt2RlBGELCZzuT/f6PYMnxU9T0jWbhdg/+IrHokoU4raKG2Z84F6lliAon8f
	 T7nxEMeFtQv9xZm1jLtfxi2/QqrTWsB5mex2/OpxZ6Ai0gbZ4+dpixNlGaYGbQ+u5S
	 7mn1M/qyBSpyyrxQ1MfjkrvDbQl8URwCz7A8mG3nrMnrTuYv53MvXUggvY+yKWnf2+
	 nxwnpETh2w4BQpb63XHylJEW6QPyI/h/Nd/XS7SMrgZd6U4vecpQ+SmoFiqDkJWgow
	 b24lEbC6PJVdj8DDU8GQr/auVQPfyNbCJgg/17uNFSgcfNl8sf5VOwhdUV8zKVbPJS
	 C1Q4tGnb8xEqg==
Message-ID: <48b4f230-ff67-4cf9-9873-6b7b95c04e5a@kernel.org>
Date: Fri, 23 Jan 2026 20:00:44 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/14] iomap: rename IOMAP_DIO_DIRTY to
 IOMAP_DIO_USER_BACKED
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-12-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260119074425.4005867-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/01/19 18:44, Christoph Hellwig wrote:
> Match the more descriptive iov_iter terminology instead of encoding
> what we do with them for reads only.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
