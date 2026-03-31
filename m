Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E7B2C11C4
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 09:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774950017; cv=none; b=LygNmJHILPxLwAUoMIVaqyaAwJObfBbzzIV3vqZ40qalcupnPu+hY06UzlYeZJ7Ds06/VTcw32Sy0dhhS6cBzSzC/6j4tqrD583FOZcat27T+qwUWXVXvZI/PSLW7wkPniBBL4icMO3phnYMN5tGTTSiSfi9vRrKJgdquQ8hPmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774950017; c=relaxed/simple;
	bh=aj7CsLap9Ku+rssXpDisokYs0AagBFzqm0RF9h6YqKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GchdHlfRQlAAt8fLVgo0GLMMhPzUIi4wQRsho7znA6UdHTuqlsKau1NeGsyZtgOi3r5r5/TBmnX2Vsf0R0LlXVdAhvsbFxHvWbLz2D+JeIv38iOdaqLKG8VOko1aVsexgr8rs3Nm7X0gB9W+EJ3UKZvoCjEAqAsjhZsQZuhNAH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5vaO8gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5vaO8gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD52CC2BCB0;
	Tue, 31 Mar 2026 09:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774950017;
	bh=aj7CsLap9Ku+rssXpDisokYs0AagBFzqm0RF9h6YqKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a5vaO8guvG1gW1i40jZxrBCycqZFXcakyTj/3LUBiLTrYdaVcxVhD/vXq9Ex+36Xd
	 VRc7My6hd0E7/BqCpFw0AJ+Vr4IBz/3w0PSf1HNhBqZdl7PS+ct1aGDUE61963lewO
	 2HjLgEGhnk3vFbtX9wOXkrbKL5iws8WnU+aEGGNo1YgYdPBCrXd0BfEUUF4uvhvEY9
	 CpL27OZc0dE+uyYYztuR0SsSBqYPsFQD0s+bM7vI9BvxdfPgwNCTxgARPX1wCmExw5
	 pGsYmIvyqVuq+GGCnCLMddTQIuYpysN5t033NG/UpE09VgAelPpsyvGtfwRmPQOe25
	 hfCQXpoe+BrDw==
Message-ID: <d1a43328-8025-4e6b-ae7e-3b105d426894@kernel.org>
Date: Tue, 31 Mar 2026 18:40:15 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] xfs: add a separate tracepoint for stealing an open
 zone for GC
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-3-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260330054533.3856339-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 14:44, Christoph Hellwig wrote:
> The case where we have to reuse an already open zone warrants a different
> trace point vs the normal opening of a GC zone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
