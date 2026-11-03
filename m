Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717372;
	b=UhWLF5O0qyVTeUADWg3Gp7katFjsLLWAJegvoW2nX+dcxmrG91wxOTLGdxdtubxuBxEL
	 8sJAN2bGAPOBNtsgfvDhNe7U1AYjKO7WSoYlrxLkMoYFse1kcXXob9ks/QgTzGk7ph6lA
	 xVJqMZ01QzrcvyrCkF4wxmlC+0mdzEsbku37uBFjUDXRJiDJXibrK/0bIlZFkKnf+8e6+
	 6RnHVbTcDDusT5DGf9aUOiDEScCBYbdYiMWoGPt3zcaviI4JX+wR9YiqJVjFxBSKfUkOk
	 NFjoSqkpG1jboQLeY0dRASY+e5SrdduyXh5aagvmWXe1nm2QphC7pR/Fqb1NFcYt3FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717372;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=8Ct5CQpwl14iFG14XocZzBAJzu50w4eZmz61RB5ucLM=;
	b=OIEQm8rxzKK7UjmIh7FTyHHzo/ImvqbKVMwmPkpkyz/wsXgaDik6ExB/ScQ6SDcUkdso
	 wQIA0+YpBbHHQS3Jm2MQpTGwKjT33mJVruoF/DVhPRvogmjtOkD6rtueGk7o0hH+Q6sKU
	 rVNIGdSpTI3CS0b4YFAp17mE2ZRzy0RCGlIY+Q0foIIz23gVSJ0MBuuZphEhUH03mTRk0
	 aLpmzmpGPYf3w+2Upq4b4yJhqDQ8rHBuKgSuY7AFVmoXC+gMugk/tuXaIzBSfnMgKL1Ga
	 45R1VvHrc8dN1yOOVFQKiN2V+yPWWxGQ63xvhVe0E/OiHkSdpqu0hLWyf6lnIcwkH6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zpfokM5y;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E03C606A332;
	Tue,  3 Nov 2026 14:49:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E03C606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=zpfokM5y
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8Ct5CQpwl14iFG14XocZzBAJzu50w4eZmz61RB5ucLM=; b=zpfokM5yn8OdUCX5khGHebRF0a
	gI6mN5mb4Q1vTwEZS4a9h8oTk0PVcU4U9aqzOTuHhWy3WaVPV5gchOGkS9InW/KbOp+vUmhYE61Lj
	p3d2ws/QaaHXw3cUZ0aGrnQbi184NQoJo8eIS+EVDM5hkKooXWlAehpw3fGivsW5LP16HwDYFO1vm
	Lg5vDzhWwiJXAwaGhpJwhTkqo/QPlyJmXOrr0xROCVUoRUzg9AU5SyjPHfIDtnLvYZHiMduMqA+1i
	1eFlQlwYl5gRywNQWKa/26Ak1MrdvhEu8i+cVcI4kNnqkVmIv86bRk3gdiv1bBAs+nfErF26hqHxR
	HkAFyDFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOFpK-00000002mOB-0alZ;
	Tue, 03 Nov 2026 14:49:30 +0000
Date: Tue, 3 Nov 2026 06:49:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, ebiggers@kernel.org, hch@lst.de,
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 07/15] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Message-ID: <aun0ehhlLgEdJC63@infradead.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-8-aalbersh@kernel.org>
 <aumsPwTUaMgsccSb@infradead.org>
 <aunvf0_84c4K3s8b@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <aunyEHubncj93edp@infradead.org>
 <aunynmhdqBMCTdBj@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
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
In-Reply-To: <aunynmhdqBMCTdBj@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 03, 2026 at 03:45:15PM +0100, Andrey Albershteyn wrote:
> 
> I see that sashiko also noticed that realtime could be enabled
> betwee _begin_enable() and _end_enable() as inode lock is not held
> over that period. I will also add check there to forbid that, but
> the xfs_dinode_verify() comment seems incorrect.

I don't think it's quite incorrect, although maybe a bit overzealous
given that we should not be reading an inode from disk that's not
been completed.  But adding a check there is cheap, so why not?

