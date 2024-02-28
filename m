Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA3515CD61
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135110; cv=none; b=uu87rxn04WBj/8Tv5QEdLhLjcOBSHUd9dX6/HITMvXMjDxcJuk7vY+K7X95Pn+GUbTfssx2MF3MpY6VXfFXAC+QUDeip6w/0jufHuBxTT2b4MXwKf1uhM7GPFee3Wk/iLca0On6TLOyySgqZhaQZKewOc3EFgvI6IS47o0oEp5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135110; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZxihVpkUEYcHMiOqZuq6KoG6ibA0z1GWAAUPmVW3XosU2yZ4ipEBLrF2zFnNIxI3rEcCPtquIzlNiNQeBBr1Qyftriv2lsSB/v4MHbPBTuHCBEoUJsUE0tFJ5795kD3gv3xObe/fjosOcWNRhEBaWrZTCF/MuYmo/Ej9mVCzYWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=To7mBQtJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="To7mBQtJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=To7mBQtJR3dJdg+fUmVPe6ZQ8M
	96pAUcN9Af/EWW33g74H0vKSr1qjd5AtMeWxWf40h8vEquG1On5O5GosajDMvLiniT9AYD1V+6U04
	55KVre/eAGO293booVwn4ORVXVbE3Fgoir5MmF9OdzZhmzCv+ekc6CwRlnyV/QIvgop2MbpfPxqvu
	aRBD/DuP1h2jSHO4zIpSrRe4WFQPVcEXGqRFEC36opzj/I0VruNTDQcIHsEFdoxkRQVovAnB8Wxkw
	PeF/EvuMB4sTJfNfEFblhwY4MS1s723WDUT2pk4KkUFmRBrx2kMzLitloKe8hEitHAHHk8gHehQLM
	J4Za26WA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfM7J-00000009xgJ-0U2T;
	Wed, 28 Feb 2024 15:45:09 +0000
Date: Wed, 28 Feb 2024 07:45:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/14] xfs: introduce a file mapping exchange log intent
 item
Message-ID: <Zd9VBXTQTT5oOQ1C@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011706.938268.14880197686023126746.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011706.938268.14880197686023126746.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
