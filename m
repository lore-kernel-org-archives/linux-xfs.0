Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447A73A0E8B;
	Wed, 20 May 2026 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779282008; cv=none; b=lR7wlVILNecgrfgupFhTacJImPSARMuClCdq1AEH168MNBX3UHvx4swdnMKerlfl9PlXbzKOE+3KRnXooghHbh3/pb32ibxPN76LryeoQJprjxJHDzRrfg2CzSykFMZs0dwgTY4ADDIiRQPOZGoLkTGSEGh20uNHiRN0ulbIxHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779282008; c=relaxed/simple;
	bh=uXnnHQKMrCSOdu2bVoHvgzPuwH1dkqo5QL+LDLxheFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jlwLro7/mZj566MiCHslTvOC1Y1x5VB7VphERmbCORdTM7xawRVxPvkzLvyEvjjPYrw/LPq9ezXbV9dmUGMcjqqlL/mXcFDfV5wmaOBDw8itQtBBX8fkTFjptgPzh3p6P0IanZFQkXM3XIVIgvRFquetJ2LlAyQr94P5tp60T+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ti+uanOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ti+uanOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCC31F000E9;
	Wed, 20 May 2026 13:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779282006;
	bh=ClG4/C+5mYq+t59LC5XHz2fpJbwcGP5l3m4ymgEXWGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ti+uanOk1Mddxg6MKm+ncOXW/DoVwhy9VmgC3mCcz8cQuS+PwtF9TGv1Y6HZO9dlY
	 HsWVLD+oYLtIBrmd5/6qgK9p4k3cii8fQKC7nkEQ1a2xqCUZrXTK8bCfGPYnHGlHDv
	 HbWdWMEaCyD/mchbv+/sQT+iKYUIe895dfHoK/Mn0PZDO8XDY1IyM6rvHBPzoKm7Nf
	 SYNOb7o9Eq7VgjkES2e+MsC4ThxtpDVkMsXJPrYkChycGfa0xR07MlaQYCiM1D/4j2
	 4zr2JyovgsoxabqZ+wfeOemswpAVRNJa8R0F/u9tqqZ0p8ggmMO8a6Pb6pGWCx19GZ
	 eOUC0vBeti5cQ==
Date: Wed, 20 May 2026 15:00:01 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, amir73il@gmail.com
Cc: hch@lst.de, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
Message-ID: <oqipgmsueopp53xpegpvjgff3mac5npn6llwxz6l2cudfl5kwv@6fyn6qxr72eo>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260520123722.405752-4-aalbersh@kernel.org>
 <n67pde3prjxt2c2u2pvjytfw7uzwbeij2yljlrwh7fixcgnzhp@piqsltgpcc4v>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n67pde3prjxt2c2u2pvjytfw7uzwbeij2yljlrwh7fixcgnzhp@piqsltgpcc4v>

> the last patch missing a review

oh sorry, the 04 patch is also one without

-- 
- Andrey
