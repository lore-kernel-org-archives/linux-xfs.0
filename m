Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03AC79FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808904; cv=none; b=L24pRNbka/KvDWWFGHOEqHOM4erOOv/qCUM7x+9mmnkcciuyow8Qp5KKS3P+kXpFC3Mkjq1xXxCyR6Ap/zJmH3ispJa7N4jMQYyM1W5Erd3I8JQ/L/pSQJd8waqMhWKxGyN4ReZ0o89/2ZP6p1wsaZn86nB80GPvMtcu+7dFboo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808904; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ErGXscD65ik92qR9+MpD1dimCyQs8vRxxtrrxsqKdqKpAir/TbnfaZXEAu0R3GMKswlkEkKafxp/WNUYDPWZov7Sb4yZa60C1KhDBrJXwUO8uxVjDWp2S2rxRBDkypw1ynI27amP+FKoVTkEYmthZ6W1ymYZqXoA6RCBfahGg0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qSQdEvvx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qSQdEvvx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qSQdEvvxiA2+mGOs7/WM1cuWiA
	PoJSIPFr89gGgysvQTUbaOSsSi45sFN2PylJmUk2togCEKHyKAV1DzgwJVCM5ThGTefUPaafuozvl
	SL4wc7oZqnzjho95Z2Ktoke0SoDhlqmxGvJsf4sycAGvGtG7E51BEiX/6g49ol+aPchQtfHakXG/T
	Dj8IXluiYO0VeeAJxC87tHjosAWfQdfII6pvQmQL0ViT+5snofH1tgwvXPalN80YlB6tztbBLiMLk
	/rtdBRUUpRqC70rNWGAa0faNqOkZH34Jj6j50V4QyeLDtW/SRAFkdfEwFsbj7EvVszy02QHYCU/CF
	nHuKRRoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsti-0000000AI5M-2npC;
	Tue, 10 Dec 2024 05:35:02 +0000
Date: Mon, 9 Dec 2024 21:35:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/50] xfs_logprint: report realtime EFIs
Message-ID: <Z1fTBvzMOnWOMTPt@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752129.126362.2344806594434228770.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752129.126362.2344806594434228770.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

