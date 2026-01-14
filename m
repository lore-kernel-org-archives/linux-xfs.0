Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3237F31E11F
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 10:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768385241; cv=none; b=DHKEevI4Gc1Pr9bo5wm9ogizN0Ny0C5ekRJjBzfDcrdRF4ibBZkJ7+FwjzfAtr66XtyEGtAcllbQ6QvzKE6qNfeyXXoMjZhEz4qLWKNihXiIe/zJma0ITTQHHxQEv+J85+eubyzpWGkWdXtEOLxkh8wJQhv72KIaAbEPah6A3lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768385241; c=relaxed/simple;
	bh=OSvxg2ObwX556wQ4VUOLwJ+GfagrYltc6AEauDBSm6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P1RVwAK50QLbzUyJevz0Ugg5wv0Wj8LLE6Ug/61ww+QixT/yGsnZZL73OLqsmRW5GC2rek6bmF+pjwd1SkoE+nl8PHRulJERLd7ij5Wl4pVBC9ttuhaW8b8zoSPE0UOHdCNmCSYHElSUbynv9J/qjHVGbmXPGq43LAyQQ+0+Vsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MTAnPWCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MTAnPWCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EE7C19421;
	Wed, 14 Jan 2026 10:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768385241;
	bh=OSvxg2ObwX556wQ4VUOLwJ+GfagrYltc6AEauDBSm6Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MTAnPWCVb2cfV67LDuv//iwLG+2QkpC6N0T+wbEidN36V440Nv0xzd+LQhOykd5Vr
	 31j0GNoNsZCRnqSFqiwCPFRBv/P2BoGp29dvNRtUwRiguNCGChCtrmuNLRH9pJjqdO
	 MhDomg0BEMeHYf6qauBIeXu2Z0f4By6UUI1ExK2hhF9m7G2lBgXtLoRWxea1llwp+u
	 dwIz7lTRn4tYbUUo5LNx4lbeHWSKQI10Jf33aKm+FHUqveEnfSmxif0e7D+W2FCIqw
	 kP/PEAS5Ua4LITyq1hYY4f8kZDDoPiu9meh6HbuWWPaEFKZ6VvIn941c/qEF1wb+q4
	 DXQoW3wHgOZ1g==
Message-ID: <4ae44244-1ee7-4ab8-bc9c-912c3b6bef31@kernel.org>
Date: Wed, 14 Jan 2026 11:07:18 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] xfs: use blkdev_get_zone_info to simplify zone
 reporting
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20260114065339.3392929-1-hch@lst.de>
 <20260114065339.3392929-7-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260114065339.3392929-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/26 07:53, Christoph Hellwig wrote:
> Unwind the callback based programming model by querying the cached
> zone information using blkdev_get_zone_info.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Nice cleanup !

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
