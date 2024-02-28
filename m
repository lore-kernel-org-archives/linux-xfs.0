Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE182146015
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135863; cv=none; b=HEiAdhKCRO5JmeWEzFQsc5JG3+/iGfrN3BothN1iCNCeLUfkVPN5i1QHxh/3bVw4+Q2ZXtix9BU95iye0oku4omWP/ZJU+/OztAdhk2lkSS5E9qQhCTDiTZn1vi7ZMHWybl0+Rx7KsnLEFP6Y6s4YruhNJyso7NbBUDWkSEdGVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135863; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jCjUNeQ3QuKo5f8NnWBYvHAzEhQ8l/CdxPYu9nMb1hQXckRdviT6v7QfAKc3DrBk48Scq4o+ACZcvldYo2tIwA/1h33KzPvl8zzbQJ6SsvIBce6XTXRGT/l1fRpcSdon7QCwYao5nfwrQ4pIznm9JjtoBNVn3HXqeYVY/FydT94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vNb9eQfI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vNb9eQfI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vNb9eQfIK2QUXzp39fYtqiV9ZF
	OHoGQZxRE8UvaOTDLORE8V9r/SJaWO3zdFDWEVg581hK1fkDAXBka4yk04cQZPeV9hgRkW956uz58
	nKiHAL8MS8GsWsU+OBNLgP1uBtfQg6zSLq1AH/c2R6jN4PSWXJC7BIDgd6xstyxI19BAfDXgm18fw
	8nK2A10Di8yxwvqAipCGWiThdTiZs9emZnjnaNnuTc4/Lqv4u3P0cfb2IKtZvaxXfQl9ZwOvJvhfM
	xPwCqDzYwQDX6hg7DCqjbJ9wzmLfXj/gdiXFtyyNdZGx4Sj515x2jIABRWA9cIFpC3LeCHx/eDoqd
	4uMnAHtw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMJS-0000000A00E-25GZ;
	Wed, 28 Feb 2024 15:57:42 +0000
Date: Wed, 28 Feb 2024 07:57:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/9] xfs: validate attr remote value buffer owners
Message-ID: <Zd9X9pfFKdcMBgzw@infradead.org>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
 <170900013160.938940.3980607749296840778.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013160.938940.3980607749296840778.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
