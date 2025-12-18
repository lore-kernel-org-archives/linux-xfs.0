Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E2B2DECC2;
	Thu, 18 Dec 2025 05:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766034875; cv=none; b=cVTNMTjAzePIoG8ejro/YnI6x9B8HSejJbXUFj6zWD6IfsIKuM9wjrOJ4gdVRVkpg3ZxExwTgLmn0Rpqqx25pr8USTAQGl/WS/doM8/38ItGzLl5RWLYzmXrk3I41B/UMB1axOI1/1bXIesxQsHDP9WKLC+YqBxVuBoFJrxYl8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766034875; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZCK6PoDoym0YqzEWebrCtS1r0P453sTa51NhtNcGgtlJop1MLhF6Kei5A0b9VrwBbyOO0NwUvU8upuVuK2+b+RyBXvhIFXKfyUFMNIlJipDN/fbga2s0hokKYVIX//jN+ujYpezvHpoT6bX8OD22aYpqY1yIo/FDIh/pRvemTQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Su97BhUq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Su97BhUq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Su97BhUqIyBrJBNDAdQoo8x9nf
	0G7TDdo9yfdB+6F2MuVs6qbMCoa33uXvo8tjm7Vll/GbSk/fUCoenJep8/QcTve6Pd8e/0BX7Vnb9
	VoXNh5gmDtxjHF9eRivPbm27VhRs/d4F8kq2lAxJ82NyF5ZcfTWUefdZ8wbV/XT85jo2RTw3Z/9OU
	yVMr3nxy8Xatw4oj2xI8TkLEhkk7jlZMtYAeznx9Mnj3zLAVp058vhQYaeY96lOwfJUDy5YJPLpKp
	GuqvvjPme546mUnDiXqzA01ocLAvT9x3jJYKGhXSvCZn+5QZko20m41RDB+u2R4QzaSL2Wz5sMvDZ
	7JAdonDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vW6LR-00000007opk-0kWz;
	Thu, 18 Dec 2025 05:14:33 +0000
Date: Wed, 17 Dec 2025 21:14:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
	hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH v5] xfs: test reproducible builds
Message-ID: <aUONuan0zvzekmiK@infradead.org>
References: <20251217110653.2969069-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217110653.2969069-1-luca.dimaio1@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

