Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1718A35949
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420921; cv=none; b=RmUKyv0AB0zkWmzVqx6zbpEXyCZOPpXhrQHsIc2rAuydJp8bEVKJyLVQufgTUMPqojJoqER5DJGuJUTcgNTDEfgdpYm4ZPZxJFHQ5M/SdWdg5Iz7XTb1WPuXqlby4Cw3sATfaTU9siw/Jfqe1JiZ3ajevoBBQk18qjiEZZHxmZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420921; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FFZf/63LuFNUjZF/fYUIVAZkfbjb0fS21RDg67gHi/qVWgM2tgUkCXuYedXTnXjAZuhTi7rpclooq1IrpVEjp9jX5s4mIcC4473y+RmPpIxJJwXAYryeVz8OW+Td9G9ChJluAb8F3L7m8LjMlOv6m3AgWIJldy9A8PsPRNyAnkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G6uc+6cS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G6uc+6cS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=G6uc+6cSIXyNvv18wAKp5xWJfc
	MPMEYemgCpDPKWBglMxpC2nbLUisOoMzdXeZEDYgjfynAta1KqJQpEugl3bMnx9poAdJeGSZZhsSz
	76J5RdFuwrwRwpwrDDY17RFIqtwTnYVTSulgWasoihD+dMo7BhyWsrxL5U0ywTInJUdEF+21JTq5F
	yEEv01fUKhobfcfv3+/zKh3+AGR74rnyOL8z/dLauvDCGp8QWqm1fxO9IgqqxLZ3+uQaPcUE1eD8k
	UiwDPiuLgbFeR+Kt6wumFVoj/yRFUbW9cARtjvvkiton+Yxko/CNXu+9/uKdGDvXDl8xcANxCfy1V
	5wP6laUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQq7-00000009iWp-27Gp;
	Thu, 13 Feb 2025 04:28:39 +0000
Date: Wed, 12 Feb 2025 20:28:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/22] mkfs: validate CoW extent size hint when rtinherit
 is set
Message-ID: <Z61092PDli1H_oF0@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089253.2741962.7311263148977317330.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089253.2741962.7311263148977317330.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

