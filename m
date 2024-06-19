Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A9955886;
	Wed, 19 Jun 2024 06:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718778066; cv=none; b=KsbTVJ/hNJw9XcNfnXrTYPNXu3bzfuPg7c3NSSDJ/cY27xI7jwBFJC6vTkYX9h5BHLdpjQ24AE4kmW58GB9F0sa5faWXoWouzFFieKlVTADFPGHqj8IYMIlO1lWthJJwkLaosj1Hk8A6g6PRZ9iiqhwf4f2wzyZulJUh24m0N8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718778066; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qeYcR9Ik+/TNJ3pPVPVsFgt/YS8AKlyZqD110csoPDY/VPvZ20pVhwkzlFgUQlsW2JaW3VKOzj9q42mC3xgDq+wIBYWKKhq1a7BvijOYOu3jTTmgas1kpGfuWEiKaW/uKgK25FIxdal6y+V6VTjxz2mkoVxHyYBpD6PHvTAikjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TGc2UmMe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TGc2UmMe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=TGc2UmMea+LbKzWi9njkNNew3o
	brkK2wvA4qtP5NDPVX0+ZFMiKjkTHIKKfwWDEwOsoS3Vh5BJ1GkGZ8FAzlNrtEm+S9aAtyvvJTz7/
	Dq8aCWDWugJyygz9DRr2QxjQJ4HcoFcL5LMdZlDPpNtyoSVUcvi6aRn1VH/1kcNdOL6vMZG4mvbUr
	UYACeHwRMg0BWloPMYtxTvc0j7651bp+0WXaVzDKj8ujpqEo8k9xpdSTayMlbkH43D5eTqfA2ea55
	ZRm/GyUvOfhvSl7xUQcvQgscEnq7jGXqjxQ+KQgPEPxgJOGHMwKJowWf2R5ckiHI6H+t6SJSlDdxY
	8xzaAsuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJogq-000000002aV-3MYz;
	Wed, 19 Jun 2024 06:21:04 +0000
Date: Tue, 18 Jun 2024 23:21:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/122: update for vectored scrub
Message-ID: <ZnJ40FsoB6xkDnNB@infradead.org>
References: <171867146683.794493.16529472298540078897.stgit@frogsfrogsfrogs>
 <171867146699.794493.17172507664394990879.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867146699.794493.17172507664394990879.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
