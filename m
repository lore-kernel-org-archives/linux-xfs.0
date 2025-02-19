Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6A0169397;
	Wed, 19 Feb 2025 07:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949709; cv=none; b=ax8wsANpQACBGHW7vAYyY30xK1oqyGHLuWeHMEr1IH7LB2EY2U34fahh19cOwhFnQB58fDI72S9KmadiHc6TUDQ9rY0nsVvwtx4qFPSnY7KR5HPVIFKySEDAnSwAM+nMR4uEyZQBUgK6K06NH5Ye6qSKdfLYsUnc2mbd5ZZg9mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949709; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E6dBSMweQjr65chdB3T8yO26Wwc7/D8afKbBSg1ut3a70mPhQx2HJ9JOr267L3tkYbut6+SodKM9NLv/LMm+DJ8jATohm+zBcX01vDTU8ishxzIYcrDjWAXwezBBxHyATgFA/CtmcZNlFjijzkkrOilpmv6WwYjzGdz8JFBGz3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Iw54u7nP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Iw54u7nP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Iw54u7nPVz74LgBF8u+UxC9cFQ
	m/8tEwrb0OQQH6aQDBY2hnadTg2Ha2jF4qik954iAVUDZAsR191vUtdtTCIjFZVxX52RsWMG/m4zG
	XVRRcsHH3W7zgbCPTWmK3dsPdca8HZ+p5eBH33OiVTTux4vEAQpAqs7Av15Tq3SCadnRnCZTwxK9M
	K4Hk+NCxjs0rjh4S3xo4el33gQG8/BfP2NnK7uslgmR4foIXNCX/lSieckhB3x6zuYXQ+6Ji4Sb8d
	HnBcPTfWTRY8BY02yJVKimmV4Z1u+eK7mAHnk/8jReFJM8Xcv6qh8ZCaNwXDC/HMlAi70eIChyoqW
	COVYbjLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeOy-0000000BDN3-05o7;
	Wed, 19 Feb 2025 07:21:48 +0000
Date: Tue, 18 Feb 2025 23:21:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: regression testing of quota on the realtime
 device
Message-ID: <Z7WGi4Sb-galJZ6O@infradead.org>
References: <173992590283.4080282.6960202898585263825.stgit@frogsfrogsfrogs>
 <173992590350.4080282.9399181647893669069.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992590350.4080282.9399181647893669069.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

