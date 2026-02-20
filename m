Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892883164D4
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 15:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771601813; cv=none; b=pVCSkLRv2tLUDX+9Du8qJe4nt9ZtDR2y/JwYUXrsekfe8QfYmrSx30uypIHqGbWacA7BHCJ6n7TXVVDkBOXwoHBEOlpCqRy82aSXuELG2XQV3htSqCPic02PkPFPaBtVrgxBJu4EN8UdPlHiFweoSQHuXek4AzWD6usxbntUOPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771601813; c=relaxed/simple;
	bh=HGhl81iHdLWGR6TwrJDjIfjfxaQZkvCJkz59EbpLl/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FV+ej3NKu4Srq+umut0/5WeB/zhTRIBlAE+JTdtQI4HE19LsFBy8JXRQXG8i55kBKT9Bz7EOuTXTorOnXepwmY78u8d28RhI8l8WBIoZuh49XXZI7jOdCD8mvatJS941t+WAk6bTXAHFEOo+9lRpXPrPfMqTuT4YEWzIOTzUSUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lShnd7g5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lShnd7g5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HGhl81iHdLWGR6TwrJDjIfjfxaQZkvCJkz59EbpLl/0=; b=lShnd7g53Sq80+p03IfvrcrQtn
	EXuaS7lfbpIdRTKTlfQwBNZWtqOGwIg29mkXlnz85eHLui5bDgeuItYwHQMqCbgi1NsiH9Gdc4Igp
	udUgCiLFgUezMRL2UNYPt9X4TEOFwrTRdI8M9RDACmgn+jNibqI+l7TVBc/f6h72QFxHvb5e1Q+Z8
	oYKmGEU1itpjv0CjZD9vnfI5JrKsfJURQmQBD43ZPSNByMzET2Ulv65UeX+PADTXgd1pMxhy3c7eD
	dgXxIflO7aEKemowKkd5YgQq8aQ75gxTVbx4fbPvHdn+93vgBc6WLDHKxAjHy2Yu8oMm3+R6AkqGz
	KOtC+RnA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vtSYl-0000000F3Lv-2YtC;
	Fri, 20 Feb 2026 15:36:51 +0000
Date: Fri, 20 Feb 2026 07:36:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, axboe@kernel.dk, dlemoal@kernel.org,
	martin.petersen@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: use blkdev_report_zones_cached()
Message-ID: <aZh_k0ierLk6iHAZ@infradead.org>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
 <177154456766.1285810.14453766592409357328.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177154456766.1285810.14453766592409357328.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

A different userspace port of this already is in xfsprogs for-next.

I'm a little biassed as I did it, but I prefer not having to deal
with autoconf :)
