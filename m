Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796384519B0;
	Tue, 11 Aug 2026 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786467952; cv=none; b=mnEyL5G+qLdhut/vtC4BUfoz+Vbn98ZZPhgS4CrKhq6Q30iob1PEQuCOmO5pTecgm0gZ8xTTRHEPn0SLPvwZsxnjJwGm1Tk+LCDVXZ52al/PK2NA8HRxQN6D8KfwbLSvKGa9XN2cwuSQcAWlF5A4KUhg1yYSIHLcpf1tgNNY43I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786467952; c=relaxed/simple;
	bh=aXL19osA6SWYLkJlRVrmBJ+EA7by69VLxmCaH7DDlW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HfQBgtbJ0E+/4zl3DIx9Y2ioS1yX2kU8GUL5bXCdZamzl08kA29uhnGAYq3i6FxLmnxJJmzVHcUt081Bp/fsD5NMo4XRY+Gx6iQhg3ggD5vDWmL7J4OIrHNEW2FTH6RucExgRNkHo4zBFi7amPS8ja7PJ12STkDuvMgSn5175H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eI4QtGCx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eI4QtGCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286EC1F000E9;
	Tue, 11 Aug 2026 17:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786467951;
	bh=7Nir5EBnYRn4x5EEwP8WhXeeGPZkbOr74/XfunZkKsg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eI4QtGCxjCilxDxAwor8qazaizBBS8rMUAezwtnLIagasWWhMw+yOgG0/Yk4nVBnK
	 FIq/TqJ4mHzmNLvIv5c+hcMwY8J3b5zEGp5rR/kdg1r3x7cX1bge8RcK6Q2d9aJPvc
	 D3dnbZLgKMSnFuojsB0tVoM6nChPuVk+uwqss6SiGcbfQnMaN6DtbhbdM9tsXxayc7
	 seGSNu7W4t9UVU4vrKJTLAkd1E4VsEVMLCEp6Ms9ipU2EVYqnodcld7Fqj+1BmlWPW
	 /U3L98tHDbl0GXfI+E1x9TQpU2QEiPSqvUDYu6MaWz9LuW3UFhDH62QGIJdonidt+K
	 6pdg0xPST7tlQ==
Message-ID: <26acc386-08c6-43b3-ae8e-cb7977be14d2@kernel.org>
Date: Tue, 11 Aug 2026 10:05:43 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] xfs: fix zoned write iomap flags assignments
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
 Hans Holmberg <hans.holmberg@wdc.com>,
 Andrey Albershteyn <aalbersh@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-xfs@vger.kernel.org, stable@vger.kernel.org
References: <20260811164912.124416-1-hch@lst.de>
 <20260811164912.124416-4-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260811164912.124416-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/08/11 9:48, Christoph Hellwig wrote:
> Don't overwrite IOMAP_F_DIRTY with IOMAP_F_ANON_WRITE, but ensure both
> flags are set instead.
> 
> Note that in practice this is harmless as all zoned writes force a metadata
> transaction anyway, but incorrectly assigned flags are still a landmine
> that will cause problems at some point.
> 
> Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
> Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
> Cc: <stable@vger.kernel.org> # v6.15
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
