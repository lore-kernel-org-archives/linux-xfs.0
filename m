Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0558A17BB21
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 09:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841077; cv=none; b=lQ2q8UDxw/r32r2ysjXJ3Rde9yR+4p8VioQqs3I8dbF8Iy4b/0IOd22XAe3Q3/Cyrg03inju/dsXxPd1Mbu1aeYTzBeenznVMCi6yesL3f4PF2p4rqHOtajglx2aGjCG49s6gBxIEoYVxq0+GxkhR5dEyfBCWqTvncQLe2N7AxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841077; c=relaxed/simple;
	bh=CoEdtncSNxex4aw+TgtLwNJVVD+aVpRH3HAKCNsOBwY=;
	h=Date:From:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=McxezKMFFzXU68nUDtwd7ToTftrnXE1+/DnhjgezUXvxzc0VPy6Tfg2cVGYLZd/OuvClrCd3+4T6veNYXTVrLw/+1eW2D0GMKyK3m9IJ5l73d/qPwSp0gfD8W/1QTwLb2qICsY0CEiCJrCd0yAG07XTh9bwkxcIeWYObkIEkzHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4kzBm9JJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4kzBm9JJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:From:Date:Sender:Reply-To:To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CoEdtncSNxex4aw+TgtLwNJVVD+aVpRH3HAKCNsOBwY=; b=4kzBm9JJQBLRASCN3pS3SAgF6H
	rhQHr2k2NLyhWoDq19a1/LPSe+JK+661C4+DI9lxGZHE1XmZX2xhj0NEuPxf2uQ2XiojT2ORDKO/5
	RdfM6TR2wXRm5RUeGMEr3UMQ+5gywOoJzxjooNuCsXZCeUxpw9SwhVbqW9CYuZv6CFsqrDKljZSOL
	lA7/jB0js8VbeSwZnMb6y+U9SGxQ4njVxBTDH6rP9s14UkEoIAwxxW6KSgd2ZFyO7zNTI09WRxldR
	1N0oDzAsNo37vWzKq+SD+o2GgxaUD4yZK4qn1nHBvmrKZnUN7+bb4AEEhNETLT1hPBCEjLD1s85Jc
	/zs0Txig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR5md-00000007mHw-1Ews;
	Thu, 04 Dec 2025 09:37:55 +0000
Date: Thu, 4 Dec 2025 01:37:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Cc: Nathan Scott <nathans@debian.org>,
	XFS Development Team <linux-xfs@vger.kernel.org>, bage@debian.org
Subject: Re: xfsprogs_6.17.0-1_source.changes ACCEPTED into unstable
Message-ID: <aTFWc3Zr9Ffp4NOM@infradead.org>
References: <E1vQpZg-008QhA-3A@fasolo.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1vQpZg-008QhA-3A@fasolo.debian.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Be aware that xfsprogs 6.17 has a nasty bug rendering xfs_quota
unsuable at least for some (project quota) use cases:

https://lore.kernel.org/linux-xfs/905377ba-b2cb-4ca7-bf41-3d3382b48e1d@maven.pl/

