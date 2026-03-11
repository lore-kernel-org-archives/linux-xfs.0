Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A7B26B2DA
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 07:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773212625; cv=none; b=ComWAm/J8Iq3X6/v8Cm7/g6OoBnR7l8TKsgu7CuNAOe7QEPqLI/IUsDNUWWmIS8sMoqYYpWOQah7Z20W+JkBsXaKjnaN2uOAiLqqgjwsP5TUSfCZGIIwySrK1pVf1eOdFxYfpxUlZsXEc2seBgtdrz3k+BV28xgmswmPpQFP5xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773212625; c=relaxed/simple;
	bh=gehtBxd6vp1gcdRjFNMo4f3u5kgzru2wV1Tf1Ez1iN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QE2Gnng21CdwkIGSrJasORLvhH4IeIhB56NNGbddE2gO6Ws7SsH6AKfVZBkAOVkLbLVSOC/0m70J6ht3Yyv04C9YKjQoinPOmwi2ObCjDyx07Ts98iMR6Wu5gCSsAu8vc2LzRLyFT+/M80sDXWDmfpQ/iB5pWxiXxDzsJrxU/0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4s+/gWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4s+/gWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50635C4CEF7;
	Wed, 11 Mar 2026 07:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773212624;
	bh=gehtBxd6vp1gcdRjFNMo4f3u5kgzru2wV1Tf1Ez1iN0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l4s+/gWAdTJS05JdZpMPL67FboxABITCKXEIHfugOs2HGXanaAChUi85bLhB1Fh/r
	 oE1AYXFGYbc1c0NB9qiTp6Dpr87seJY6Oqz9fr4o1mZTS9rKMJGSlA0NI4+KyomNlG
	 QxkT0dIi/ZqEloU5Hc3neuf+wHfVSzgC/RsQN4yklWIrb8PcQtQWSoJWe0ZvwQl1Ll
	 zVAlNZei3sIWi0XECYzxg2uALhGM1A+dDFtCeNMLGWKqqoWvxX4t5ONN8dVXaxRiWt
	 EG86pDg/+6Y1uKu1kDV9/Si9ceA6kOafOyNJqjexX4gUw+gVfR44va6jSGY1rIBs+4
	 q8dTsqWkW75+w==
Message-ID: <ff8f1134-d39e-4fb8-92d0-487a7afa2349@kernel.org>
Date: Wed, 11 Mar 2026 08:03:42 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] xfs: factor out xfs_dio_write_zoned_end_io
To: cem@kernel.org, linux-xfs@vger.kernel.org
Cc: hch@lst.de
References: <20260310173709.457047-1-cem@kernel.org>
 <20260310173709.457047-3-cem@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260310173709.457047-3-cem@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/03/10 18:36, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Stop sharing direct IO end_io between regular and zoned devices
> by factoring out zoned dio end_io to its own function.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
