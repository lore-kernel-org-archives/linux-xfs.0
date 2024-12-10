Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ECF224CC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807010; cv=none; b=QIE0Qw8avnsTLMuKyl8V00pWI3zVfu1hy7Yyt4GgraQPipHfyW9y11IqpVGCoE8mwPn14rI0v70f7WEt9FSo7wxn3heUvQhrpnWl4VAYCSZxUbDFV7PHGv2N2KwNe5iwSzsla/GngVe+vHFPiEBKvdZXHz+wFHK8K21np8st460=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807010; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ODKAj38kjuAt7H2aJlv7TX/BYx6Qb4Y4L0tcn+8rzP/5gxUYTZQ2eHN6iLAOgmnqBhnSaaQiLTRyeQNNGhYt3khR+aX/xGwUQWhRvdnjEuVCBkZffLgriAiDCSqYA6NaMsbdUS9JsTofmtM4/H3MNpEGgKm/ddekeFCOK8W0MfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gaFtkUbO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gaFtkUbO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gaFtkUbOy85hBkbWKIxLq7sGpw
	em7bFT1iZx9aYcQ0yoF80CfoZw9FlAjKbWYoxZESRuEyo/C0bdjlwd2vCo27dt8VIZ8u/i/O0W76E
	Ke+Pf3W52jJHxaixfnJvBByGPNfTbtgEmZVtigJRYHGnpZit/frfrWHOgxG/9PYccGzwV3L7WV74f
	QUE9NpdwhMjZoADmqNSKiBuANbuKpLvkjgSvG3trco37W57sryzJfsebOX98Sxj6QymP/Jtc1Po0D
	YC3mAuZJDOhEBHG5shnBHTZ9mzC/uQEEtVx+rikeLFb0VJi2pHZp3UflZ8sWzZcSgbrBpL4B3jZbn
	0aK1Rafg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsP9-0000000AF8P-3c7z;
	Tue, 10 Dec 2024 05:03:27 +0000
Date: Mon, 9 Dec 2024 21:03:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/41] xfs_scrub: scan metadata directories during phase 3
Message-ID: <Z1fLn8YOaFSJmJiI@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748528.122992.10939627158010208077.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748528.122992.10939627158010208077.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

