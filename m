Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61E08493
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389908; cv=none; b=LQyNEhEjJIYJ1SJ0GGRJSevWZe14s82t1rymyEXIpSVhjywncycf4PlmA6vGfJlk/C+TyEGvYXTQHQJ2dAJdpVcoiRtzz7hQ003zkTg44dNOjy1rOE5r6/9f1oq8/eAqyw+2I5SbgqgzzegxZyW2uvTvpMyAWCTgeLtYRMeUzIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389908; c=relaxed/simple;
	bh=WRtWa4kyCa12YgU4llNkolMplCvg0sAGbW6qM2ohZcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CUygZOV92QmW5SKVYJEJFmWHnLu2Hvq4CREwLJswKA7xsnuModlHV3N5qkQ+c8JLW5L45G4DhxLge/n9d/8Fhlu4qVjCsSxaRDm/JzrxsenjidpCAzBv1iPdpOV+ivJ2eC6jCswGIUQF2+gxcnbNeUQE7oP/pajqGMI2Y3P66uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q0Z3SSkc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q0Z3SSkc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qRJWNSkN1DTeDNWs9AuLyNjQ6yMXK48niTlpOFC/qHg=; b=Q0Z3SSkcA5w6CAD9hVPfvVp/pj
	N/tvIwPNNQIybELN//ONREg66O/ia9WckFdaapipklydS8I1/AZV6Ltfne8ILOidE3PP0rPGpxjps
	j6oybr7Ivc25i1fCaa5ox7OdvC62QIqEfRMtrwC5TGMFD1O48Q+nLyVFHmrRGmuJmRu+dShfBu6m4
	a8SvRwVDNfsQqFbBXsXMLL3JMsD9hF4wISzw2eXinHfaJhEdn4dxpIsHKHLUquJJ4G57htcfqrgYk
	Q24IndFQQqGKfB3s2tsI9/MHzokSB49TS+j3+OUBVpUX5VnJVul6QeVlwxl6CJOurLvvAQzquZnHg
	vSEoPgAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMaR-0000000FGqa-1DJc;
	Fri, 23 Aug 2024 05:11:47 +0000
Date: Thu, 22 Aug 2024 22:11:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/26] xfs: check the realtime superblock at mount time
Message-ID: <ZsgaEz33I1mT5Ant@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088552.60592.7439081149023620735.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088552.60592.7439081149023620735.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 05:21:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Check the realtime superblock at mount time, to ensure that the label
> and uuids actually match the primary superblock on the data device.  If
> the rt superblock is good, attach it to the xfs_mount so that the log
> can use ordered buffers to keep this primary in sync with the primary
> super on the data device.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

