Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD453161A1;
	Thu, 24 Sep 2026 05:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229305; cv=none; b=LDaW3xegfkepkNobhac8mv1PB3/+1pbO5RKpRkDDST7FWBpasvMxg2u9tRpgJ+FYpaUy1Nq7Y84Sy9kk9Fq/gszvSYJsgDbrKuelmMDO6xCRoP+CIvu730h2KdeseBoasUNFcUUpSdc3fOpZztqqJEoYHem75Qa2q9I9FKhv+j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229305; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r+ZFbrZimkY2QvGW7KUP5RpeDm3/rqH/YeCLs/TioJCxFfLXpv8jWK7LU6OrzD30xo+ZxPjDwA+erRnsJ1O/NvfC80oc+eeGyr+hy6TVIQEjyqQCDi1QJ973JwDrF0hDWivUXPdgUMI089R/eT6BIkG6vX10VjRb47XmcApFjkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LFTweUVh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LFTweUVh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LFTweUVhs3Mpd8efPgoWM2vl8o
	QuIWG14s8tCAeixN99FbOuArrjktFeB1t9Y1XmCWRX5ExD1IgvQq0H+cq2wu0MM589z+30MBMhdrQ
	DsKlmPPIlUlkG+G3t7L2kC15BQE6DoKPanAD/D8jCChkwSTmRxeu7l5TL43Ay9kOvqHMRtLIZukeO
	n3hGpLIrZDl0w8iHCWOaBLpGrMzp6EzoWZsElnYUwxlY44zY8291P9TXbhb3++W6UjpMiEJKVovmP
	jFoXFZfK7tsKQKC36XFYjpHMuptfoGXF3C5UpRfyIQ90lS9GNLVXszK4kybtQABfiWxrXg7oPZ5GT
	bntXYzXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9cQB-0000000A5ts-157y;
	Thu, 24 Sep 2026 05:55:03 +0000
Date: Wed, 23 Sep 2026 22:55:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: actually lock the metafile reservation when
 adjusting after repair
Message-ID: <arS7N80qGgz5MSYK@infradead.org>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159777.1875436.9839611902429627901.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159777.1875436.9839611902429627901.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

