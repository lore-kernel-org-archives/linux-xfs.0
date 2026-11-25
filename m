Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795588691;
	b=HgTgwhyDhgaq+NcuFFqatooj2nScJC3eSN039BaQiCL146uSOqOPz0wWsAWZVMg74mza
	 de37WW5lyf34ckKmjBWwFAuuZ4xXOe0SxZOhq02IQ55yIyi8BEMk9axSDKQkwiRud0c6B
	 dcj4hAramgp9eBB8nll3oXG8TXj1+mkUlLPawkTfRVhRpzQGGOFn/fSZF+xrCXmBzaiBc
	 L3wVXGbFi5qabZOhO8JED65VsMCghReboZ7Md1LkCm4951nnQ5gB32AM8Hk9khcndB/Tp
	 GfV+s5P1CnLdxbPeJjws0yMUfZFXj5kZkZXblPj75cCt3+zIuJfbMzMvYNXz9fehFmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795588691;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=W8AEHwAAGVQVVX8QssQI74Gq3nnbdM9uF1uTzqakqns=;
	b=h2A+LsealheppsXweaWd5KPuPufuvX70E0SL2HUkcuDXhT0y5HfkTJZU/puU9yQSLMMW
	 8OWzbc+ZoIUpFuEoPa+Bd4wDBCQwA+9zAxUOOr4YuJFvaTNoB2XQqY2ip2cFCLikMmvDG
	 4QiQjcJdUtwLxm0qzHIa3HULGjsvG+GkkGAykJtdsTm5C7xfH3tX4l0SA81MjMmZNQhRo
	 A+fjz5ctyn1ZRYbmX/VXEGjJcQCnGKfMcP3/tZl+OUV26qnpV211kkfkgkt0J/UYVnpef
	 EIiKIuBaSHjnF+osZTWOtxNYSknV4YMZ0t3aonBgbr6le93T99Rojpqrl2xyzSMWzxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=JVt1RGIp;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD3A606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 06:38:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDD3A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=JVt1RGIp
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W8AEHwAAGVQVVX8QssQI74Gq3nnbdM9uF1uTzqakqns=; b=JVt1RGIpWICJw9yaPVKWXlM5Be
	nevh2uqyxcxzPD5Tl0LnGw6fEDOKwcL0X70brofOLy/ULp2PsmW2bZEzfIWs6UV/TZB7uK5ZcFM9f
	2gSBgjiBCnXelEL/u58GZ4TqtBmYHZlXv+1QyVVyQn5zqgmFrpDh8wZ9a5InW/csQv7vEPvsoJVdO
	2lRPRkxqdrvK6ZjpY5YxFnaZl9rHlEqa/nMENGt737hm+x0F4AucFg1Hi/AOfT/5TF6x2N0Ddmm0F
	zwY1nt9oAduRZRMvynKqNZq5oiJVT7GSI2AJqanRiDjepF8BmAFqOTl1RuztGctdzI5kWwc92oV/3
	MFpNoSuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6ds-00000008ixa-48Mo;
	Wed, 25 Nov 2026 06:38:09 +0000
Date: Tue, 24 Nov 2026 22:38:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] xfs: pass proper leaf argument from
 xfs_rtrefcountbt_broot_realloc()
Message-ID: <awaCUBjzpjuvUQgN@infradead.org>
References: <20261124213906.2130272-1-sandeen@redhat.com>
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
In-Reply-To: <20261124213906.2130272-1-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 24, 2026 at 03:39:06PM -0600, Eric Sandeen wrote:
> xfs_rtrefcountbt_maxrecs() takes a third boolean "leaf" argument, but
> the caller in xfs_rtrefcountbt_broot_realloc() passes level directly,
> rather than "level == 0" as is done correctly in
> xfs_rtrefcountbt_get_minrecs and xfs_rtrefcountbt_get_maxrecs.

So we basically get the wrong maxrecs here.  I assume you found this
by code inspection and not by testing?

Reviewed-by: Christoph Hellwig <hch@lst.de>

