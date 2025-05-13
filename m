Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E471A1F4E48
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 17:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157757; cv=none; b=OIv0LJJYSQJ++XkPqrkk1ObkGboHUOgAFf22Nhuzz3bHOTUGJFc27WRIJP5fw3KOiSoeF8Gqh9LLtGLtn9E4SQSywjPXAUw7wzG7EOvfuO0xxM5nNnYCZmbXnWcor/Nu4DGiYKE6ADk/BrcEvhgBJjqmw24/E1HI/EmDv7Q3VCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157757; c=relaxed/simple;
	bh=ahMoagECh87EqEuCXgIPCK9nOhCHrI8fIMdzc1CIQW0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mJY6h/ZITGuTVyXLLIknOkmY/PH1Yxtxzb3mH8S+rpssa7LCgW0BnLFOyaKrKT79Xa501/pRxLr/KWFhGwJZFj9ywNL77x7G+UO0BfYOQwWXOpEh9K1w4Qi5JDzW+fYylt/P8I5BG9wpAn01DIYtbFhwSboixgnAvuAHZ3xt40g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FxBuNoeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FxBuNoeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18182C4CEE4;
	Tue, 13 May 2025 17:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747157756;
	bh=ahMoagECh87EqEuCXgIPCK9nOhCHrI8fIMdzc1CIQW0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=FxBuNoeDr+3ykIsfqt9NAM8M2qfHk3UaqR56VQ2g/TsTByjc1pLGc9w/fpOzMc19M
	 HmH8M3qKSJ7KnLzJhZLybOHMbuIRGqBMn/7FJ6jJwtjwVK2GnK/SsICEUi4sXST2by
	 sT72XlONaeWEGkmqnvXArcjdnWUR6/0FHQJgqQoE+7K8sxi2rCt3VA9ne9+8g0cNWW
	 VgqlOXlQ2Wijl180yaLd6bRgxkuPBWjOXjZjLe8liPTzMWfX6gLOvqbO7bxvrpmS5c
	 TZw4bFzUasW5SRoaeAcSEcUGYKmrSMoYqkPVUEXnd0FJwmv53aJomzri+RUeEIddEg
	 +xSm65UC5E4OQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, hans.holmberg@wdc.com, linux-xfs@vger.kernel.org, 
 Hans Holmberg <Hans.Holmberg@wdc.com>
In-Reply-To: <20250512144306.647922-1-hch@lst.de>
References: <20250512144306.647922-1-hch@lst.de>
Subject: Re: [PATCH] xfs: fix zoned GC data corruption due to wrong
 bv_offset
Message-Id: <174715775473.709611.3303766064265385831.b4-ty@kernel.org>
Date: Tue, 13 May 2025 19:35:54 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 12 May 2025 16:43:05 +0200, Christoph Hellwig wrote:
> xfs_zone_gc_write_chunk writes out the data buffer read in earlier using
> the same bio, and currenly looks at bv_offset for the offset into the
> scratch folio for that.  But commit 26064d3e2b4d ("block: fix adding
> folio to bio") changed how bv_page and bv_offset are calculated for
> adding larger folios, breaking this fragile logic.
> 
> Switch to extracting the full physical address from the old bio_vec,
> and calculate the offset into the folio from that instead.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix zoned GC data corruption due to wrong bv_offset
      commit: 91ffea7cf2f0b53686bba24c3bd86fa5cedd48d6

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

