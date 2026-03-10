Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E781397E70
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147418; cv=none; b=au6bLKfNHH8w8jqMIyGyYd7VMJAlU1XUNBX9+XIs7gteWVUbkRqP5cMijuh+eeR5KUkyWZSMbyje/qM5wouv0d8zlu0kFOG4hCz6crgXI4FxrbJELtRRHPVPrBtgYfn7XxAcFoQ+P4TNWBoD2uxl/kirFL8bHsGI9d3YXuxAQmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147418; c=relaxed/simple;
	bh=+2nIBTTX5HuLXdl/fn4EA0NSepyj6/WEtOAmoSg/3o4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZqPVjOMDG2OVgkJguCX5lShplx6mIis5LOc+EN3jVzStFnQ9d4gSa5ijm+rq4GUkgA1TkhdObzE/SMJdlACPjjQ9AyB3sius4buuOiZNZQ82Xmcv53+Ipmim/aA6m05SoPyXpSXnNd06ru6b3mS+6X3mYeeGvS0kI6nRkXGnR0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5USOdmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5USOdmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB40C19425;
	Tue, 10 Mar 2026 12:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773147418;
	bh=+2nIBTTX5HuLXdl/fn4EA0NSepyj6/WEtOAmoSg/3o4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a5USOdmRmbBQl7Lsicy/fAbvELzzwsYXVnj1wKca7Gz4E+YHo2FQmhky3mLs5JqcC
	 sKp0vtrwHtOekKnPiooX9deC8BrXstWPAloLT8iXId1FmuBBInmYIXOzBjo5aLBrDy
	 N2Up5atJ0l19Kk3BdHSYzRwgj/cqqsYnhoA6+xzg96BqhKsTkR/RQL8zH1LftGRo3N
	 o/KKmkSx+/2GEYKskchQJfuBevmH0mA+f1ipGVY/92lonm37KuI32iZZfNnKAFFJs+
	 v/3j8xMCFrDOi48aikz2dj4q1JANke339h+QsTJI7vqfd1QKNzXYX3noDMxkBESmiN
	 7kkQa4cJ7jYoQ==
Message-ID: <96cc9d33-4f84-4cc5-a408-2586b269ace6@kernel.org>
Date: Tue, 10 Mar 2026 13:56:56 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] xfs: opencode xfs_zone_record_blocks
To: cem@kernel.org, linux-xfs@vger.kernel.org
Cc: hch@lst.de
References: <20260310115555.114197-1-cem@kernel.org>
 <20260310115555.114197-5-cem@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260310115555.114197-5-cem@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/03/10 12:55, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> We only have a single caller, no need to keep it in its own function.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
