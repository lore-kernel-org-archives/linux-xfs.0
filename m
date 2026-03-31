Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93083D6688
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 09:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774950124; cv=none; b=s8GP7iEU1gNUGzKtkuuXkgEdTBxRfzUFmc+K7mDxR98ZiBr8rSXDpj7QLGbbgbtmsGJTOkgvtR+pa5QBzFrvFKlmQQpWZ1XWQFD/CXsKX074rqM4F3dVls3V8BIcejAaRCTi5V39VPA3U/Vq4OIS/w/VseECDsGyb8YU9eBJUYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774950124; c=relaxed/simple;
	bh=H1j1sMD1CdC2rQjWn9VBKVGHVvv6VSyL9knyiHQxbKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RAhwxk5E+zr3FshJTP7IONEM2H22fV07t9vA4W8tKXOP4m/cD1abYb4FU6kIeh4joR4bR8y7LyyykE1bJPJ07l6hxH2euUO9NSyZvJNf43DSaEo/v8ILwMWUFwByJDE1ElT0xN1q8tRk2LCG9Dhpxw4TNsKPg6Bf7yjMd22CacQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WtcvvMx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WtcvvMx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9F1C19423;
	Tue, 31 Mar 2026 09:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774950124;
	bh=H1j1sMD1CdC2rQjWn9VBKVGHVvv6VSyL9knyiHQxbKw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WtcvvMx9HoUNimvTjhtS7fOxRXbjGNCRXgdiqMKuiNWNczpyOABC8oX+2edKVTBy0
	 4L+zFkG9fA9gLapBokxWfuVk0dg/iBr/lADKW5SLSqEB9m7f8Z3sRM5MR7wNcTWO3R
	 RUSO6OcODZchY73In7EYhOKOaeDWBV28QuAfWC2SZfrAjxWzw6jPrmJDLF59MWT0Ir
	 21fQvgyNHaFEBZiFk74Wm3qpnW8H5i0Djr2teN6+olODwTOF/PRERVAE2D1ieI6rBu
	 ED8E+yIm0tWMFpSTwB9Z5KylpgLYFmcJP/4ZmrziC+bICGHxvT6GVs5QXASIHkAnF1
	 ApTG0tRXKl2+A==
Message-ID: <62f17858-e984-4d2f-8a69-5d713ad0e6a5@kernel.org>
Date: Tue, 31 Mar 2026 18:42:02 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] xfs: rename xfs_zone_gc_iter_next to
 xfs_zone_gc_iter_irec
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-5-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260330054533.3856339-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 14:44, Christoph Hellwig wrote:
> This function returns the current iterator position, which makes the
> _next postfix a bit misleading.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
