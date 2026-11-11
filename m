Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409806;
	b=v1uSS/K8H6lO62FrnIPsShXaWHS6JO9DPWjRUyfRV3VK51kUEt9QZ+B5tr3CBxOdiauK
	 CjOEBKEH33AqZ9Yq2w2/ctuuAhnGJgLVr+g8qEserQEEaBe4E9dxjO4WTozhpops0H5iu
	 hJoNp+X+4zHWjxGIyiWma0tKI2YlcrE4B06cIiW1xRAVlEQrPEpyu54CtfIWCdw6gb4w7
	 Xw16/tuXip+L4D/HXq45JLvOI6orUPKXlDP1BinR0YQh1yXTTWCUc75aXzLXmOi/zwbMz
	 2Qdevz/7oS0/XkbaRwF140r6Iy8iUZTeUhUfgELqh6y1q4MdM09hIe5wKmJpdDdPFmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409806;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=4K2zefmMeabEZ/NslnSSpZAVl2LKQTM3FNNlgIfHieVx0dLBjiv+lOLCczUA93GcOBa1
	 /53v+j4PIAKZYZlB2vbz70fcorawG4KsUqFz1qBBu652nmo3uaU3xYaEDEWxkdj2voENJ
	 BJaGUhKDPUO4v+dZqY/ZQiGL0bACJe3heRiavzwKkxUBINvoIOB4gPfi6lV6L1cdKFg9o
	 o0wdFDqy/4vkIFZQ71aN3sNCWEhDMouC9eXDWA0F9hMC4mBinKRsXf2NJ1k50w90jnDwt
	 eWG3a80XSOkPnDss/Eu0ep2MdzbJf+eqIRVIjE5A7BNmeirF7lmtyHYINrU4FIouxNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=p1kD+MaY;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157F8606A8A9;
	Wed, 11 Nov 2026 15:10:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 157F8606A8A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=p1kD+MaY
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=p1kD+MaYK4Tqn+qQHjFcE5Gcfi
	aLx+Y7OWSq7o4nQG6zHxvdAtqB7sD34A7+mcelUQg4S9+g4DOxyjxhON4uGY8ygR+HyohIiHxA8nF
	gitD8TSuxCjJqZ3wR8THDOZULgrl4OnMsE9IQn5hXOegg226vfq+0keL/Jcn4lyfByaaz4Wl2f7X5
	YRC9MtsMCYqmDNH0RwAAEB707gVWuMvqYiROQuBhKtsv45E/j+w2TduR3kJ+l0ykvky61d8giycRq
	K6PBaEjmHpKobrk8fOW1mr77FdRubyhI+PvX0n51VWThPEbv6GS+SpXa1COoN2rDJDVdN81uvSsj0
	zgag++Xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xR9xd-000000073cl-0ScY;
	Wed, 11 Nov 2026 15:10:05 +0000
Date: Wed, 11 Nov 2026 07:10:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: break layouts before swapping extents
Message-ID: <avSFTRlX7T5gJwP2@infradead.org>
References: <20261109-xfs-swapext-break-layout-v1-1-7f6f137d18bb@samsung.com>
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
In-Reply-To: <20261109-xfs-swapext-break-layout-v1-1-7f6f137d18bb@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

