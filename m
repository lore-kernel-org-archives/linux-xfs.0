Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793697790;
	b=LiLZW+T8Dw2QU7kuyZYmL4PTXUU1FuJIl2QX20NLZYQVKlMoIvvtVO6SB1h3hhsE8hNo
	 GskRVOdep/6zGrrkakItaeHmDxmigZoWxAQQv7LdaVL19/0Ez2wzCvZY/nxhf6dHbgUpv
	 zlgZo4I48Jo7Qg92/wQEVoGYHAP00ceXz5TNhf9KeKsEG5VtRI38MLbp/NQ8K8Qo3xI+i
	 CTYVraUTR7svfFHmJNV4Zq7qqDTEpR4dcMNq+f0HMS5UFT7kmDLiMF/bQAj0ph/XMafHE
	 HZnhJ+aGulw9NTm6IBKwecAIi1TLbpwzcHSKKXGGmoe99N0DO1JNemC77EpA4xo9czg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793697790;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M/TzfbzfWwzQ+WKfKCge6q9Z6sEOvQF5XO3AHOK/QBw=;
	b=w4NEg58d3kAiBYtRmmzLj8Phy4e9/GjRO68DUNnCQkDBdURyX8J7B4NXDQ9OsY6x6QjW
	 +iwzAmi0/cCNA4hm2gFfIhB/A0I5hyMvHZ9BXyj/U1W5RwCDUTNLn4CpSgVa5imozEY4L
	 oCETmfVIPWS9qLN5LaYgQVmwTdIx1fG4tNKWDw9aflhZErlNW7yb7Yhzb9w9/YvozPonP
	 /klcM99K2jSvLo3BpY9+LpOkfQCjTcZnpfZc8GaVK/fITedHEpAhiV371AXCKSOoWKZqI
	 tZe6sz/B0kIN+uKHuQjntTlxz1Djof6c7Q32n2qzZ48GKN0z7PWbiMuGiCZQloLo8pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=OTSQ75Gi;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC02606A326;
	Tue,  3 Nov 2026 09:23:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AC02606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=OTSQ75Gi
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M/TzfbzfWwzQ+WKfKCge6q9Z6sEOvQF5XO3AHOK/QBw=; b=OTSQ75GilPMYFQ/1FdNI4mXSVM
	cDHT3jRez2aeh1naZ6kMjYP7krflKeJkAL+xEgweouvpHOQZEVypuPDczz/afKtHVr5rX555laZXV
	5wZu8GKmcCY4TnGpeiNm2ZXfj9iNF6HnShdn7KayiVS5KY9Pza7RRSeOF4HDHHeDjrFJ+vKychAsb
	bmZpUgsGEnzoZOXzKyNieUqsFsskJoX0SpyB94ScJkptAxIi6g7zAtTRA51PsL72/NFL/azRQueZ5
	BDGVjVqX9wxzE4yKjRCR1+a9vpv3TX3kZUdMgUpIR/PjOn6ceOp7ux4R+dAioI0nXApSaQhUT8wAU
	ZONMJG6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOAjS-00000001jkt-3jF2;
	Tue, 03 Nov 2026 09:23:06 +0000
Date: Tue, 3 Nov 2026 01:23:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 04/15] xfs: don't report dio_mem_align and
 dio_offset_align for fsverity files
Message-ID: <aumn-nXavmu_vsZY@infradead.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-5-aalbersh@kernel.org>
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
In-Reply-To: <20261102144147.2393369-5-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 02, 2026 at 03:41:34PM +0100, Andrey Albershteyn wrote:
>  	struct block_device	*bdev = target->bt_bdev;
>  
>  	stat->result_mask |= STATX_DIOALIGN | STATX_DIO_READ_ALIGN;
> +
> +	if (fsverity_active(VFS_I(ip)))
> +		return;
> +

A comment based on the commit message on why filling out the comments
here is fine would probably be helpful.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
