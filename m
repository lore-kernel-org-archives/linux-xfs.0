Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD54EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945488; cv=none; b=EQw8ALFAO40NucDbVJ+t16eD0eWqELzB1PbjD9gyOS8HX/GYcg+PS8KrlwYNC0EdXVMyIuGWxjIyOkI7QYAXMZt+QSVt6ZlCYKagjHsRA7sgHNStgVh0suV1XMphAF4gHlFdZnz2XN9nkHELw2n2NLzLrkm/MHfcCno28Vahqzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945488; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PU1Oh4UDAfaCakGy7HqLp/mWRdSLbRBm9cD2r6L7vs+0XnHkOlhCtB6b0Tc5opsfW/Escvme0eWcdQNBVEm8y/GGD2v+XQraBLsPvoTkCLpYugEUX5ZbuP3DOf3AxLQID7k9hprgyGpZM97zUm7Lkq/Wf3kmylbPrUKLPH9LFHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wPWnlo28; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wPWnlo28"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wPWnlo28sjEufC4O+rkcVxsiHP
	quvSSOEaWuf+bnsBNWAUT6FwkGrxzO49fw1MlknW/bV91yaeV5ulD1tD2foCqOpxrUmaEvoXSHodT
	Vy40SUO2xSHh0ZLBpjnDawNJeDN0gceZA5uvocN3Qc5EpfZMpsiG/OwRc/oB663HTn8SmrGZddrgV
	PXh23+We5uborv3Wyj/QXXJ/plfK5v4VPKy3gli1TLyVQHqMo9tJUxdTefRgA6UQRarZ1GTjLRW/3
	I0f5wca0kGXoIKP4RrPYVirvPXL5DmsCApDvktX2xAy24rLJtX6zGLoCiVlAQkhGPh1BvZZiJsRXF
	MibtAfOw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWFD-00000007gmD-09hH;
	Fri, 21 Jun 2024 04:51:27 +0000
Date: Thu, 20 Jun 2024 21:51:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: give refcount btree cursor error tracepoints
 their own class
Message-ID: <ZnUGzzD5VcVtwe8i@infradead.org>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
 <171892419788.3184748.13995968067171093141.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419788.3184748.13995968067171093141.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
