Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192436;
	b=g6w3dYPv+VJOtDSM84jXFAB2OakhL1iWwyT1ewvzF1+WLGRXd1QB1MSm6n21M8qohV25
	 etvVzGn3MjwapUKTtsr+6h9Zs6jXQZVtHsOaf7LZRpO9PC+H6fRHg/DNKLX5QW+VQnP7J
	 ZgU7mgiRlesq1frvZcmK/nA4H/OM6SpMA8xTQgY7m7hNdkJAObYttZ+yyC13sxQhpaNOh
	 8DpMCf35Oceimkv3Kp+3uv/qWsoGfWOG+0TSqT8g0Fz1GERAMBrkCF7tuSadqkIsyUIrB
	 qle0yP6McT6afCh6RChr4CHlcIuoQ8MqY5zw3TdyHFyCCNxFtKKd1PiJWOVQuLika6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192436;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=Rtf1EmZwWBI/axr5wuw3Y97Qz3SlhVDrZCwKtOGMCSg=;
	b=SdI4uefnno2kq5+wgCU9eaCr+7AvqWIIunJ2gt9GjYEAe0xSGnq7Fjje/uEIif5NFVj5
	 PcpNqldX0b3sKQt+kzmTemN6cmoBnRy7fBOROctLQUEIRsxQyxvlWjTeaZMNqbm1RK/i9
	 1FYReX9gKYGok2Jt4/fnUEvJDcg5dxEzm0+OvO+x0BOL3fTiJ7ifPJUrc9EFjMf0vUc1Q
	 T3nAqLPAd1Lyx3sV7clJDBbSEKFXFjrr8iaw1u3X2CJZ7kFMABNUJXkeLj16OAhQZ+IVO
	 Xuool/KNqHW46CB0pfrWzz4WEpbYLPq2gMn0LvPxW42zAeqPLnZmqZaoaTbDH31sHLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ZuPdc0tu;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9022E606A32A
	for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 16:33:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9022E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ZuPdc0tu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Rtf1EmZwWBI/axr5wuw3Y97Qz3SlhVDrZCwKtOGMCSg=; b=ZuPdc0tuP2EwKeOwyFz6BJARL4
	dN6UgmHl/zv8FQlTS5Zc+3i8abFqFoVYrX4RbRNSrGcxM7abhSuY2OS4LYT/Gw2WQzRfQ6MwzRXCP
	MRL4hk6fXQs9MlwcAtCLwjfAByxLZGNuNWzp1N4eSfFXbRj+iLHdeLoAZSBztHvEzioCc9LKOOB4r
	7vBYyr8a3Vz8Yq89Wab5Ih4me5C5jQhAqVnqot/NDehjbUyRM3O58oljZYX5/ipuRcvQLXdZmVuE5
	WoQFdxm2YMIsptYgpuKaQFcSl6P6UpWnWXw0Q6cszhKkNmS4JaIA8ZXyM6WQbs3fqkigs5dNbJjQL
	K+Y5mdig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xURYh-0000000FZHE-1xrs;
	Fri, 20 Nov 2026 16:33:56 +0000
Date: Fri, 20 Nov 2026 08:33:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 02/59] xfs: fix the rt rmap btree maximum level checks
Message-ID: <awB2c9PeUd0KI_XF@infradead.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
 <20261116231707.3625263-3-dgc@kernel.org>
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
In-Reply-To: <20261116231707.3625263-3-dgc@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 17, 2026 at 10:14:19AM +1100, Dave Chinner wrote:
> m_rtrmap_maxlevels is the maximum height of the rt rmap btree, including the
> inode root level. The deepest valid root level is therefore one less than
> m_rtrmap_maxlevels. The root loader, the block verifier and the inode repair
> code all reject only levels greater than m_rtrmap_maxlevels, so they accept a
> root one level too deep.

Please fix your commit message to stick to the usual 73 (or 75 by some
definition) limit.

Otherwise looks good.

