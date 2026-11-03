Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699057;
	b=GrJ0iBDlEF/dbx3lbYxGq4dYV/Ju8BvutC8s2XCyXRo1AmZ1y0OcEFYiOvKH5cp/H888
	 Ij1khajRXxjYsM/NNw5hh+Uqtw4XGXUo32kK3g7kt4ewCvERhzmBR8uRDh1ILZQOMp60C
	 xa5DMj1NiRSOic/Hl0Nh95nBxX5Z0AsCc3wWaVx1quChw4BHdkZb1p5ag5tEu30br+wHM
	 lVtaH4m6gZXiUXSHAN4MEhmRoK1hwsqRjJe8ES0E3GxbmzC30uPfUjj1lE+clqzTTlnRa
	 THweZY5Pjzf2AbQXVIZAu/mT/HwR/zcS6tKSQp1jfEA4VzFmrkGbwFX6HsDC/6lCAgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699057;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=qC7bVX25yVHxpZRWnWsEQAWyeAjoX7Ln+fxwlJ7EAVU=;
	b=GX4xWIAApuAushOIl6KYmkERHsPMs/D2+GdgeIY0rCzboo0i4F9hRGbAyeEeb8zKT/kS
	 dqhE972qixmf32nzKZqFtWgHb5+iLi+YCswaFwzvAbiKzclinZOETluEELpz34CVvzsz+
	 56kn2d1I5kXSXQI+qT7pD76DBemHgMhkpi+Y+RLtifJOiCprxPrZMRrUuJXPfAF7FRT8h
	 Nf974EMmcIvwBUhFy1k5vNO8X9frMKkbQfCT2vzSDKkKk1jSTL90Mlp4cvvQtdv8r2yjp
	 qUak2+caZJXKOHy/tfyFn2yBAiMwBFtXTyD1efeVEAX4gMpkQvtdeDmpiJ2Jv3ZbkCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="MLM/12WO";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E581606A324;
	Tue,  3 Nov 2026 09:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E581606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=MLM/12WO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qC7bVX25yVHxpZRWnWsEQAWyeAjoX7Ln+fxwlJ7EAVU=; b=MLM/12WOZF+MJ1RD+lXiCZvxTy
	yfkXTsrNFVp3j0tuMrsf6ZM5X2d5fEoNDjOHXPPlKj6TA6PLoL3HJ+Euw/7SnZZds57yJRXoqr2Px
	SmNj/OAYeulSRjrkbNOFhS0Cd9t4meKDNgwF/eBN/TlVFCXdftEhpcYbRAWziFtcfOXKqu4HrFS/l
	CEL5ekDSLs2iv5dIoexGkXMdAi6dbXFkZVxWsmTx/wqGyGv14wlLxCfutX8/D8tuQyhfp+Kwat+gO
	ratrq4SN/422jF38Dohh7xcq7L/t33OuDVffgZKXGrQql1/3MMDPC7EkHRchZwMLW9gErvucEd+iE
	dcHmLvaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOB3w-00000001nBy-2QoT;
	Tue, 03 Nov 2026 09:44:16 +0000
Date: Tue, 3 Nov 2026 01:44:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 15/15] xfs: enable ro-compat fs-verity flag
Message-ID: <aums8EgQ8eIoDL_w@infradead.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-16-aalbersh@kernel.org>
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
In-Reply-To: <20261102144147.2393369-16-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Kinda skipped over a lot more of the Sashiko comments that look
at least remotely sensible to the one here, which seems most
important:  XFS_SB_FEAT_RO_COMPAT_VERITY for sure should not
be allowed if CONFIG_FS_VERITY is not set.

