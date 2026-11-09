Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794232150;
	b=JdOLX0PG0OUC3CjfNpzAgjDMUaPIs+tqvOb0fsc7aJNcAECZrxe2MV0QDQki4VvbrUFM
	 iGioZHhUyN/6mJ7C0XStsWPdxGCuOqn6d4C5WagEoamquc7UZEnC+CZ0jNgtB1bRxFNBa
	 Px5IB4kkMOjb/8uDqJOfItgxHY+hahjUXHXaU9sMw/SXuJoP8qW0SjUXrgEQ0fYJOvwCR
	 Sf+fAZ0ns3irr4uJaMHw/R67X3mwXZzbqJzThMLwFUospznSeixkYVKn04ZYv3anZ+PVc
	 xk0vqJPfbMNZJbSb811mySyLSGPRl4Qpw/SbJiyaLSfYlYIaoZkNpdx4yu6ZZRHW7cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794232150;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9siUsLL7/GY6RpexSPJVJieZq61gcAcBoEm1aNGlNr4=;
	b=ciY7wH5kGD/HpLwkd9Uxh5MkJcZ1Yp6uBPU4ayD/u6rD/KLtPeUH3zTiTJvZYZUuEFsx
	 77i824XT3B6SGquaVqv7xOMJATubCEfwH19vkzOFhE5oKdRyCmJC5zcoMZQKNE27p/Ogq
	 EkviS+EESk5USIUISSlLp2+oO1vDj1mU5XJduqUVggfynD8SkCHVf/hlCi5UfKuMZvDvY
	 1KHkf7ZUWWeJ0XF4tzCU/MRdxA/g661xjF8h8tGm8q1K3SVViYz9nu5KbX6xzg7tkzRx/
	 hfPcOiGxDqjCxpOCB2lssD/TEJSMdoOw8yFKo+9v3WF8UlpS/Yv8eqYt8JgGhXmLIsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="gk/Af8uP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40168606A31C
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 13:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gk/Af8uP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FF31F0089F;
	Mon,  9 Nov 2026 13:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794232149;
	bh=9siUsLL7/GY6RpexSPJVJieZq61gcAcBoEm1aNGlNr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gk/Af8uPtHcE4zaLLPn1gq/smAEkdsrc8riGeS9EAniavZ3hnoyJB+LxP0YRSR3nU
	 O0mMlpE7s+QvqO0fTnW6MrkBz9FVEDk5C8ZbACBtht0+9KXFFWNHUR6GJNlvKyDjPm
	 mHS3DDcHbw6PGzxzebIcsFhUYkQZ4PrucheQTl6/OcIny4SMy1Jf09Ln0VIhcbZ13L
	 tU5wV4Pl2OgebIOehzeETzVrLCop36sO29jAkuvI6CXSYbIN21aGfneUSuXiFkQgKI
	 wvs1lo0knKpQqVbmsVHQ1zesdGCwkHEb7a5z+dwITlGGSZU0xMI3zO8cDygjSn2i3N
	 dfyxT9vL3BY2g==
Date: Mon, 9 Nov 2026 14:49:06 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Tristan Madani <tristmd@gmail.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, 
	Tristan Madani <tristan@talencesecurity.com>
Subject: Re: [PATCH xfsdump 2/2] xfsrestore: validate ah_sz in
 restore_extattr() before reading attribute data
Message-ID: <avHPQvinPko7nhEb@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261101162753.1443201-1-tristan@talencesecurity.com>
 <20261101162753.1443201-3-tristan@talencesecurity.com>
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
In-Reply-To: <20261101162753.1443201-3-tristan@talencesecurity.com>

On 2026-11-01 16:27:53, Tristan Madani wrote:
> restore_extattr() reads extended attribute records from dump archives
> into a heap buffer. The ah_sz field (uint32_t, up to ~4GB) is read
> from the archive and used as the read length, but validation was
> assert()-only and compiled out in release builds (-DNDEBUG).
> 
> Replace the two assert() calls with a runtime check that rejects
> records where ah_sz exceeds the allocated buffer or is smaller than
> the header size.
> 
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
> ---

Looks fine to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
