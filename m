Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D843F19D081
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765297402; cv=none; b=RPjzApDf8u68/xvF1PBfcv3lWk4UsPbj3fpayRWIGcf1dpfR06aoBpANdMwtCyiV1LtPRWwGLmRM8EYHv1Mjrl4FmWIzANouxxfo51NcuF/8b4+g0LT2FocJNE4XlbcCXciKbR5PWLAWOPpR1dWP6Fm9PHe155SDpiSjhze+Nn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765297402; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LaU67oPutH1CIWvENs8kYHZwbpNwXg5qFbtpC2S8bCqCC1Z8DHp70FcbBqhEsIeGyrK1fZHKaQeBkFQ8vczFheIV+QE3qz3d9ZcqA22AJHCP30jQoLRBl1tq7fkHSho0jJ6p7Ua0aaSmsviFEMTuwe9lvUNiu/FD4siM1H3xNwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aTQBe6ix; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aTQBe6ix"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=aTQBe6ixIzEgSS0AmLDNPgX9xX
	q8dnrEkHHHBMP6QVqbmylOiQyhLuNdeRVJrMIFFOj6vr0nYpsQBVn6VB1pUGMGmXwm0vPlfXdM6SB
	j96iWT2AGD5v6SeT2p5kSe1k4mINXNuUCzY8UqnEg9WprukhmQkOJmqUCRPiCHUJcN/F/LR4PJIya
	pePQShWz9f2fhbDsk5yJmYvy+/xKWTKkuwFibtd0yFpBjBjguBYdhd9Ey5RQCoGYeN2d0wtWBvtvp
	2/l9Tb2WFZdC+9/Nb1GReVo9agVe4aty/xHMUMOrogaDAEfvG8EnvKbiCcy06/0Mza//332CBDCr9
	8sj3DuUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vT0Uh-0000000EVxw-1QT8;
	Tue, 09 Dec 2025 16:23:19 +0000
Date: Tue, 9 Dec 2025 08:23:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mkfs: add 2025 LTS config file
Message-ID: <aThM9_M23vUZ3j4Y@infradead.org>
References: <176529676119.3974899.4941979844964370861.stgit@frogsfrogsfrogs>
 <176529676164.3974899.5005702998496231177.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176529676164.3974899.5005702998496231177.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

