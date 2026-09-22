Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4907537473A
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084707; cv=none; b=DS357C2HpkgLVJ6aAmKM3vAQtSmQ9oRJNgMbnBm5Hb4XsfgntAAl7lWmx927IPj0l3qoFzGPX291QQEMuwbC0vSYvtfba4pcyp8MBsVDQnPiYUzA1V9RGiYEGBhBBXN3JNNB61eP4IO2mw8kNc7tbDIm8U7p4Y2ENfd/yVDTuvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084707; c=relaxed/simple;
	bh=KIchwBTN3p2gsU1R20ySnbtv+sCfoxg7aNbvFYkVA8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BzhKGQXV7z42GdzI/Xtakh9PSJfjipKfcq829/KBeOIfbyY9G6RU9Vi03zBVz7vcrq+PV+vCfeTpP/6UAPWJWCtIHP5nEBEiyz/fpsWDE8SX6Xva8PK2U6bMrTOU+joQENWF5GcDcRu6+ZisnbR0OudNnGYjFsS+NJ/vs2eFmHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g/7i2+LP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g/7i2+LP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OkGc6NRJUVPHFWH7VZvqe9lIlN33De9xxNbtrvFZcgA=; b=g/7i2+LPYEwil+ugNDfxCEQJHm
	VFzc6OP3fO07C0qAimM2emsnXPi5ttn1Rr9qAyVA+2FF8mxXYuXsJFTpR36N35XWKBYr3aI4zTAt7
	omCHzWA3FmiHoYUcyeUZXSRydL7rlFZLtjZQ2TJfKcV5ykS+nBrDSatKBZN9k8YBN//cIA7gr9dN0
	cbGTIFzrQwea5z7IvFFOAWlqtRFjtd6PvkCpARGr0/rkHpzGoKJR7TadIICOiIO1s47uabQBXovY2
	D4s3q+2kiKxeolDBEyA+jDzA7lRrqDTV8oZSgHWXyOlphYKPQf1jzodsJ8eqi0nDAXETPvFPW7UVz
	QdxWoHnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x90nw-00000005aNe-0ezw;
	Tue, 22 Sep 2026 13:45:04 +0000
Date: Tue, 22 Sep 2026 06:45:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: aalbersh@kernel.org, Wilfred Mallawa <wilfred.opensource@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Damien Le'Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH 1/3] xfs: add write pointer to xfs_rtgroup_geometry
Message-ID: <arKGYI0cMIEE_VAW@infradead.org>
References: <20260313002456.3823811-1-wilfred.opensource@gmail.com>
 <arJ5oJeAOezhOGsP@infradead.org>
 <arKFdAhuxSq32e-P@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arKFdAhuxSq32e-P@nidhogg.toxiclabs.cc>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 22, 2026 at 03:41:59PM +0200, Carlos Maiolino wrote:
> On Tue, Sep 22, 2026 at 05:50:40AM -0700, Christoph Hellwig wrote:
> > It looks like patches 2 and 3 in this series never made it into
> > the xfsprogs repository despite being fully reviewed.  Can we get them
> > picked up?
> 
> Cc'ing Andrey here.

That might help indeed :)

