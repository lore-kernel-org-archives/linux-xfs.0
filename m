Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792488164;
	b=N2cmKBP0ozHOYFF+LR/ejrWdt+3qzmGL6PeGh+3xMlmJAL+yFSchAxrw6TmXe8W8aVXw
	 IISOJHuTn+r87KhDhd6wwPpTsT2QcNJ9Uw595b5ky+Th2IoPCSRHtI6N1X4f6fhSmlwEG
	 O9CHCaxclVoozwlBWWVfMuU857ga0R8WlSNemMr5m8EBgw5M6pPGiOxtslcGMCIpRjesi
	 EojTGWi4uoEPJhvern4HVGaZAMrqBUg5xwwSoB6h3Aer+YQGlobXDGewPgrMdvzlJ8idk
	 PQVaeUsS5jOZYxMrRtIs5yj39Bq0jGkF+vO2cuy3vymXkPByN4H1F9hXX1MNUA+0R6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792488164;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=q8f9OGNfcMrOcnC58pTEdqXLqzu54ZSXeimyIW2n9nU=;
	b=q2r2IOzYCfRcy91Aze5aM3w1pLiqGb3xnxrkGGdhHXLuyuKStDiUmToUXMBZak/kJbgu
	 qz20WZvIG76rC+28QgZGO/vnU2oYLC5CqJeJwpQ2B745JxPFaFpt7eTCZM0gFEymnxWrf
	 3jwrSw2CDC/L2gIttXZGaDw+7Ve+673ra09IYx/wGBjBB992xrLBLi9mblE2R4nJY9JcR
	 7nPa5JGvFwbO6zERAIap1Rd3UCJZwOHkyigM2DrMK57SE4Mm6OipJaszKHeVzhv8xWX5T
	 IeyjYz+utPh3UbONO0g/fes19l8V7mDrJw+InVXy+4VR9tTMzngOlacqzxTQrJehvEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VeCdgQ2r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8609606A319
	for <linux-xfs@vger.kernel.org>; Tue, 20 Oct 2026 09:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VeCdgQ2r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34241F000C5;
	Tue, 20 Oct 2026 09:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792488163;
	bh=q8f9OGNfcMrOcnC58pTEdqXLqzu54ZSXeimyIW2n9nU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VeCdgQ2r+9hLO6AbAUaB6TaVoDKUBZLyf/48LSaf1xBrrrGaUlVsNJAauUrWMmto4
	 Y7xe/f8yw+8xkWfhBymmMpu9VL0ShrHCe+zZqgaDwUwKGBea51I5h6oN6PX19thd3y
	 BtbjPfPpogi2aRDd9WIZXPHHH1rVE30xHaE4btMRQyYGdhUiw96vhZKe5KhpZLlBYm
	 lG6bscizP+CIszYKU5s4bhMb2dT2siqDBYJIJr7KthzVNnKLqoTiXT11vhad6ORzfT
	 XJOoEkIs6ZTGiHifLer+6ezR7L1CjQMTL3EGb2NoFCruAkglCbhxvtsJvHfFybBRvh
	 qzUKDawAZDJyg==
Date: Tue, 20 Oct 2026 11:22:40 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] tools: add a new script to generate fixes tags
Message-ID: <atcuKJZssVmzmE5R@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261019155655.GD1612213@frogsfrogsfrogs>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019155655.GD1612213@frogsfrogsfrogs>

On 2026-10-19 08:56:55, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a program that can generate Fixes: tags for a new bugfix commit to
> cite an older buggy commit.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
> v2: add a description of the program to the --help output
> ---

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
