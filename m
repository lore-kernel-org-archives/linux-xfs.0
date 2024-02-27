Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C694A1487FE
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709057873; cv=none; b=DJxt8PqPlOlyg6OvCLMhH7w1VrMiQem1noL/JCq2ZczO+OrRppSFqbL7JHUMY1FOchumaembjly2I4V3ctDafF0lYWgs/3dc0ZR7xTJTC9so89rfa03aqxI1j+pG3zgvdUDrm5Xw0pt+wPVOOAkRFMFvQO9mASI0ZI0eWJ0VSZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709057873; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rSVCmGVTKH2TE9uh7Dy2eFstpSEVdfj505eNHo6U9l+s4Yf9PXJOlZM2TzDWkQ+jQFfL+IHDmExZrEe9blVsaLFLV2PHGjrDz6C7r2L1WvBCag0Z2r3pBxJ6Y8Mvk2MXL1DKuAxyhKpMVUrmemyryR5yV+898alMAfRPhQN8Q84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FdBCzsQA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FdBCzsQA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FdBCzsQAqQEoP8WYXf7ZB9JAG3
	eJCWHBb3ffLDXqKGZBsSf+QUDxUaJzLg3DB72kdPPe/7hf/k07gmklAoaYW67jrnz2Q+T935p4KY2
	VqzmbDmy/Pjx+IRlCsVxeDh4WJmWYozR8hAPG22R2cUUhzh6f2ct5eCqEYQnnbv2Vt2hSTT8zarVa
	Yq7kZi6GIwqif9IA6pldoCMfeeEmImD+oZtRMo/n7kV/3/AKzTgfphc1j1G/QqUT6ysOY7BadWbPl
	l8aync/c5VBlWHteoRTbD0YIdwnebFnnNqRxkEq+wdYHRFR5j6qnxucu0yYOokxovW0CsL6Usdx2J
	gJSKQuvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rf21X-00000006PED-0sdD;
	Tue, 27 Feb 2024 18:17:51 +0000
Date: Tue, 27 Feb 2024 10:17:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: support preallocating and copying content into
 temporary files
Message-ID: <Zd4nT2MCYq98mVFG@infradead.org>
References: <170900012647.938812.317435406248625314.stgit@frogsfrogsfrogs>
 <170900012670.938812.12444028906814157466.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900012670.938812.12444028906814157466.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
