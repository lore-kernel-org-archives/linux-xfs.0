Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793978486;
	b=hpovEfCYyxCMu9T51ja8KkBEEKQcmQSLQZpnV05QjIpdtMDQ/PuD+QpcPdIalmFexbh0
	 pDGBH19LQQSPdENdU8PIaZdajB+zRq5mdQELUjGUb61EvsHD0fgPQ6D07djpeI1TXb3iy
	 P064HkqSeso3uEseHrtQyTR8VIRZWEKvMx8I4j6yeTP/AdzG0rQ5E6K20uCZMCVsdOwsz
	 ercZMeTi+YgzGVmY3rHKoFAkEqCG+PGO7nvd2QdrwWYogBIH/wxM/UiWnNKOECssEthoO
	 ShfLwFbEUfraS6JQTTPInDyUQLDBZM3AhSHN10iUDqG5hgrucRm9ejl+CYGAYVXnldA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793978486;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=Q1NE3WJ6X7I6EvJyqTueFcBcKQ9APRrKdguN5HxGMUc=;
	b=xhW3+i6GIndWQ6PWQg1xqIoWx2YRPGPVEFnNqGEgXI9/2z1bVt1zrAuQyCHQZu1aqU9+
	 O1vlbye7C07ciFZuNiZPmHVdjHzXnP+EnxOyaj5E536ziZE95X7QP4SE4ecsVRmnAIYsG
	 xeUwM/n5qRY5uD2anfWknH857STuole4LJ1YuQkJQ6bSXkOGDoGf1nuXhsWu+dSVNU9yV
	 bw6WwhXPIPJlPtJY63twbJTqctnTRf1eY2X174DnqS6sBZBwnO8q9oTwjbV6QHXB6BmhC
	 ygukZpl+p/JDVKID/Ppe2IllPv8hPH0xaW/gKVsxBoJMFeJ5a3ubdue0KhvfuDFUOLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=wGx51Sk4;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C24606D825
	for <linux-xfs@vger.kernel.org>; Fri,  6 Nov 2026 15:21:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58C24606D825
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=wGx51Sk4
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Q1NE3WJ6X7I6EvJyqTueFcBcKQ9APRrKdguN5HxGMUc=; b=wGx51Sk4ryvBmOtc6EBfiPRitJ
	uvg80bD0n62b5k9n3Q5yl90zNqGpZ7ptPUiLSvUcU3OlfveCv9E8McHoOzwJ+FWVnyt5vJ96uhYL5
	ALPmfpfkqjaB2nw6QZ360kiSnb9PaH2q/qrY764II9sPVPpAdXP2t9JDyO9pcOzKQLnW8KEZG4LTO
	/QofK9uIiS4I+CVwe+1zaNjwHAOiHodxHahKlbAtyBGaKL8sjL+Zn+ftoKipFVomv9Bd+ZKKvFrXj
	2r+vbTVuPIfqYQHpTU0oifvB1mL3oJUHxM8h+namA555EGE8TcE74NVIMx+RTSJFqb/n6zXIYbFFb
	2mdunmbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xPLkp-0000000Cnsm-3PQR;
	Fri, 06 Nov 2026 15:21:23 +0000
Date: Fri, 6 Nov 2026 07:21:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lauri Gates <lauri.gates@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
Message-ID: <au3wczh22TiioGK6@infradead.org>
References: <aulwLCnibXfaMzR_@infradead.org>
 <20261104124118.34200-1-lauri.gates@gmail.com>
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
In-Reply-To: <20261104124118.34200-1-lauri.gates@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 04, 2026 at 02:41:16PM +0200, Lauri Gates wrote:
> Would the refcount-sum ioctl you describe be callable without
> CAP_SYS_ADMIN? A device-wide total reveals much less than per-file
> owners.

I was pointed that patches for refcount reporting already exist:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=report-refcounts&id=9f3eca4098ff8226911f84af7b21d79670413876

and that does not require privileges, although in this form it might
not be very useful for you.

