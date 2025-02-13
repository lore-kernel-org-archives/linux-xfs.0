Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A812054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420771; cv=none; b=DnVRMMHdtk+c1d5CKaDi7ZbhFcmqZbEhSBl1/T/YUL4EvdtdM6Gpfab2diGVHD+Qkgvw6wuCx9FeVXNppJbwgJYp4L/aBxH+TSK3c24zIxxBFWL20Hs0K4NmDd+F74EeBEkrXj1poLYWvcu3nTLWjzvuupPOwHyhADYGMJbhS7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420771; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qDuVQLCy3ZKklt5D7ELrPUN8Kzok7SPD60uTAMNPwl/usfunXT9Ye0gpHXwkNUIdiPdgHppgqRCKRu0gY4XLGmy5EpS7gMXAcCNEsqSnoGLe2niaGCCzIwzYDTEgaR3w2jti9dSJ0B0e3eZWEO5M3TbdPQ3gPyS97Gr5c+DUN2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=znA45BlG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="znA45BlG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=znA45BlGf4lFz+0emsJjth5cmQ
	7pTPWCRP3ijdWXICmNL1RtmZvwJHeSOCaTTrcJbtwLwvy6ZUH4UP28u9xLwEmCGfwhw/gLtoM4NmC
	T3hI8/8WZZXJdIly6P7rNl7GCxXt76cKqWxR7t3J465sayFzXeMoAUsO1EwzOZeDksl/R4sLmXzmi
	7u1QeURkSxNTVI3oA/3i2c8TqalFHzrqlmCZprxhWU101cl2F8hUqQJ3kjHDxHL39V4uCF5+a57Jh
	wxaK5B9YNilXI7NoMLO6qzV2u1rsLhnqgojc5LGLojSVTrgBuion6pslv3cWb/ZO5sQPDrENoOlwS
	NB1Vmh6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQnh-00000009iFF-1xbP;
	Thu, 13 Feb 2025 04:26:09 +0000
Date: Wed, 12 Feb 2025 20:26:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/22] xfs_repair: check existing realtime refcountbt
 entries against observed refcounts
Message-ID: <Z610YejRQzvXw7Om@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089162.2741962.5490397729857671375.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089162.2741962.5490397729857671375.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

