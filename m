Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EEC2054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420546; cv=none; b=heODQmYH6d3ASJ8C+SKZv7Z6WqPq7N898UABsNeEmOa5zmFIMXH8DKo1Y4fqPSY2LwhCeXfhj8LMexK4AMKTRRjntc9lVQ8mJfQAKG9BNzGuS8MBg0L1EmEZTVY+6mDO3IfcYCMXsaQ3KTIxqZt/eAq+KAlfkHAuDQYFPjKpyro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420546; c=relaxed/simple;
	bh=/u0m983Jg2+ciVdnroY67GIY6ZTmZpu5cGDhS/EYWnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOnoLFFFIfd8iwL0tgbqwt1GmE5jMH+9KEGx/ouTbsBf9lsu53XVkyzQ8lQay7bwsrRr3hE4S3H8JWtL9/OyH1c+DuDNe795vC94IyfE4f0kDKbKuykiLK/MGKYa991UPSC3JqwNzu/JxAwF0iocp5sOpQSCBUJHmoa6RnOtPyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DRBv5g8H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DRBv5g8H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/u0m983Jg2+ciVdnroY67GIY6ZTmZpu5cGDhS/EYWnI=; b=DRBv5g8HlDPZNSmc10Aj58yebj
	LjoK7rZNeiyz7rbGsuxOVSfrppP2Wd0BxR9ul7Zz+NZJF85kPV2T/XDpBizepSQ1vKqSIxKSXQ4xP
	auUnN9XPNCClSKQiF1zIWRxggYroHDBI711WVMlpbmR/2flx4wRv9UXL5kzeLr3/0ezYbu7ZScadR
	uj4UIo0Kp96ssXDdSxXwEoSJzRi2yxZanY/gxZ1jgJtr0wlSKl/zZUaUdbC/75ho1jjE+K/7SDDUI
	TbjYOP1P61aOlAhQu8BuayWNoqx3ywnbfH8OPvTMZBVNU2UAWnsSHGnJJSFDLz/7btSgzoKO0Fb3a
	seTkQPXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQk4-00000009hza-2tPk;
	Thu, 13 Feb 2025 04:22:24 +0000
Date: Wed, 12 Feb 2025 20:22:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/22] xfs_db: display the realtime refcount btree
 contents
Message-ID: <Z61zgIjkF7o731Yn@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089026.2741962.9721869790463624969.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089026.2741962.9721869790463624969.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Same minor cosmetic comments as for the rmap version, otherwise looks
good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

