Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472A310A13
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725669; cv=none; b=pBEIK8QnK9LcyT3fpH51cvfT8h0kzIPRvxSoGQo4MvXYGI/GDmOuHW86ji8IflvjC7EwU7RJBNItDZCxuXW+ThI8x57GoFPgXprW91xndbWEavj2PtwJtC9viq19iHGqDQywiJO9D+LrqL+zlM1TDmoFgbtalZtn3nnbykWzK0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725669; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TpUd31p6qI+eGKCztvcRt2lge/sPBku4Pgz5cHrOWxW3UCQUL67wxld9pONec/YmlX1MOq4++9YVf3W53Le8cPlii2QHVynxdp4Gpu2Suf+CFkKw52+ntSepx3PxIYVYVnnbxUfTdlQmY+qm/8f2ecBuSiOCKkjHKcz+/Ajgf8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zMtKeVGB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zMtKeVGB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zMtKeVGBBS59QnUYsqGfBZ0Z+x
	yorDz4xlUD3JnADkbALg48eEfC4BB94xu6ScAZoWFMbBnB4/bGCrvbwo0AmBxvjXAZUv+Xxf2gy8k
	dQS5x4OOys/OO8atomv+J+Kw2+ZqdsejvcLhKEeIej58K/zQhcXTzaUeyZY2PWIgyFimLzVsEfxXG
	7qz/UI6BwDkbiXjYtlnWVxWsk/ksNEjpMX6iPukDt07rYK9+dxqyJhdcTYP+TSLsIYAuaoNH0bHFU
	TwLseZDq0rRZAJcpVIL2+KK5L4i8HOooknxbg103eeGijUjypOih2TEQzfd38Rvi3ujzxive4ljw3
	VJ31d40Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQBX-000000057fA-3jS9;
	Wed, 10 Apr 2024 05:07:47 +0000
Date: Tue, 9 Apr 2024 22:07:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: use helpers to extract xattr op from opflags
Message-ID: <ZhYeowP7ArMxOAU9@infradead.org>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270968966.3631545.12587444590975333070.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968966.3631545.12587444590975333070.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
