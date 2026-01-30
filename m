Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103ED33D512
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 06:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769755305; cv=none; b=DkexPDKkapjzxDAWVrBN8H4YOb08Mk72KJYNj5Yas4VZEa1foyt/WAuFen1sgKoUo3tkagZJP4QeZ/8LolxVnhtTeq7Uiok3Ab1kTh25Yq90hE/RIAjdlQ6OGGtWBTsGTTiTeEydYyjJ2Oasdp/YCoiIuuc0C18/BMI5xeUVa1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769755305; c=relaxed/simple;
	bh=adDzHg5EimOOMRq2eDqbNBsgA86t+1i9hVj6IdvCRLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RkIior8Kb1Z1h4kJyt8sDBoZm+16GPCgYsPUPAti5PYC0lio67FJB52PXIfmbNux+YlAQjg1+2FLfpu2E9PXqRuY45mEz7xePesvQXsg3k4lDqaWMk75Xam2YescuK7FDahN4/zvbudpJgPhhpBuIAD6J6kmUs9UEsFm8u+Sz/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/5W0PLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/5W0PLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD04C4CEF7;
	Fri, 30 Jan 2026 06:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769755304;
	bh=adDzHg5EimOOMRq2eDqbNBsgA86t+1i9hVj6IdvCRLg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F/5W0PLq1XP6fxMK54bo7nMMiQav+TIHpbNrgW8UUaqYPgyrrVHQNkuVYamXfjYYr
	 B630tsdPkTDml974ATymIg8HZSAiy4YkubuxpzqdvFtpz9AHebb4M5sluh0b/D4ohU
	 fUuIDfbrq4cqxPAi7ZqdSfhJTMa7kL9GLZSTpvke6qaqUsBYJzR8NlS40LImkD1Vju
	 6U8VC9eClrifqm4/dGKW79lPIvWBWAFoaKYi2WmCzNEcvqkZoHxpWtt0ZV0yRqCnSf
	 1xgc6woRaJEuGMCawATI9u9cuq3HJC/eiFHWXEq3HJG9eDIF6058c+ayB+uvYn4h7S
	 yuk8TOxnMlzgw==
Message-ID: <34e20771-d036-4ffe-b443-c27e30bd2eb8@kernel.org>
Date: Fri, 30 Jan 2026 15:41:42 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/11] xfs: give the defer_relog stat a xs_ prefix
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20260130052012.171568-1-hch@lst.de>
 <20260130052012.171568-11-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260130052012.171568-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/30/26 14:19, Christoph Hellwig wrote:
> Make this counter naming consistent with all the others.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
