Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1F41E98E3;
	Mon, 26 Jan 2026 06:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769408756; cv=none; b=ck67HBEKCigmgARY4w2E/pCltwJF2VAYMXG8TVwpPt5JxI0JEtoTwwyJHkg2UfDZn3+EGS9QYXBmR0jImJWEmVRtj6BesEtlI3TPKSAwjM/Oe24Gmk6YyfyYl8P0C4rAJ9U8RJ+CJfJBXcH1wNlwOBYAMCu+WLJSb3CElx0HHsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769408756; c=relaxed/simple;
	bh=SSqDAoXbgjcNNsaZbS/cwuJuFxnb/y1raEv1zXP2ORk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dbUaSrC98sYLh1UlhQ6TFVVoYnKn2cEfwAPUMyDKiHkU4wS4bpUOkPQuaHWUowpfNJ6tFNmOfJI4A5Miu8dv5/6UGPjWBXyok+lmBnB4oa2lFyf2Dwo0+w19xG+7802IBOBgG7MKL3wSoBYaYKXvGjv6O+McerwJQOEWEI3fOjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6g2FgFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6g2FgFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F7AC116C6;
	Mon, 26 Jan 2026 06:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769408756;
	bh=SSqDAoXbgjcNNsaZbS/cwuJuFxnb/y1raEv1zXP2ORk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i6g2FgFFAcGBl9re4KFa+A8ZYe7oQbIy6AVBDF3BWBbfh5PKr8cbNf/AnY7jcwf8B
	 7l+P4R5f4KzNsrLZ6h8zApw8Qom6+KMaMB5ouy/oD4O2R2trxn0I3v5pyAZ/p89THx
	 439i+wclbK3sxM72azYn7GUk0Vwa9Nt40OePyIasqqIeB6eEtV9X0b++cv4euc5hOG
	 XxHcFT4ZIkhbkkEJL6zeUW7yJiGjyIXP3nFz1liWJgyhwV9EC0y2MOVHVA4QxBXFc2
	 bBJJ+T8iBS4L4rMRIxn3+OD9Bu6lZghaiySUGi0STgfhb0ilh3QYRBU3i+7XjIQHdR
	 +/sQST6FXQf5g==
Message-ID: <55acfbf0-67f7-4acb-9d3e-ae608263cdb4@kernel.org>
Date: Mon, 26 Jan 2026 15:20:56 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/15] block: add a BIO_MAX_SIZE constant and use it
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260126055406.1421026-1-hch@lst.de>
 <20260126055406.1421026-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260126055406.1421026-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/26/26 2:53 PM, Christoph Hellwig wrote:
> Currently the only constant for the maximum bio size is BIO_MAX_SECTORS,
> which is in units of 512-byte sectors, but a lot of user need a byte
> limit.
> 
> Add a BIO_MAX_SIZE constant, redefine BIO_MAX_SECTORS in terms of it, and
> switch all bio-related uses of UINT_MAX for the maximum size to use the
> symbolic names instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup !

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
