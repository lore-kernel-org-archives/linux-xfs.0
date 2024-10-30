Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3C18F58
	for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2024 04:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730262890; cv=none; b=fmufExV8VWhmO7MMGEz7uB5rKsqT4hGtbYrAlNUxt5Hyw84u/tkZUnLvM+nDfe4vsDR5Qp8hwRgip/kI14WY8b2HCD7h/iSfiwA1RC0CI6Y1on2jrk9sR/YNq0htYWrfPBfONZyBOQA17EssKkpFzs9O01+Nl60X0XhnUJuVaDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730262890; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Caf7xd3TqKSlXiO/C0jio94m2nRxyP3N5h7/4WmCX1U2ehxwT0ae35J36gKfjMfAB3DYdZbrMCNUOlWYeVVdL3Qag5x1lbUMtj90Pp263+SZRMHGmM3diKN1zmTvCV6UXcGuGFzLjmczrh/fC4RXBTXi6FHiJTd7vXx9m1v9YAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YjwlijEM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YjwlijEM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YjwlijEMFnqKVKvrX04fQkmv9I
	6tq5RktALY3HiErDSfdX/PuZxRlR4bQysj2tg+hrcaERmMw39FIF9FLuou8JpefOoRfMAPn30n44x
	vyhrNdQG4GTjzK51L3bMEoNCA4sP3W9VG2tzGNqMfQzaF5sABgLUgPYgvrGmnZZ2lzxpolIketfM6
	ejMv66PQ8THtHhwabKX+bkYf1+aOHrdNDrE5kcfciSTHh+OwRPPkv66ojBJHeohA1d0iDkQq28LJ/
	maorgV8g7FNEzVmElhC1GxOOp5cg0sg/fLZXgNAkSHPo1q2x9K0XW99CLrmj44nasNovGOODCYTzR
	c3jryYIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t60Pv-0000000GgEu-2iSw;
	Wed, 30 Oct 2024 04:34:47 +0000
Date: Tue, 29 Oct 2024 21:34:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 4/8] xfs_db: access realtime file blocks
Message-ID: <ZyG3Z-8O1_iZ9hpX@infradead.org>
References: <173021673227.3128727.17882979358320595734.stgit@frogsfrogsfrogs>
 <173021673296.3128727.1175236924173292657.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173021673296.3128727.1175236924173292657.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

