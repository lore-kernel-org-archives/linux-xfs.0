Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DACD1891A9
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552774; cv=none; b=ZWdG2mLcMDo+t6eO5I+y9PzOF8gXi+81Qb3QkDQXTOToGmcDVXfgwZTil9k/ioXsb/+Hap85kmu16w93e5RjGZrsWA1exlXouaCP40lDsVn7K2W8+03tfRo0Z6hBDL2eXVgFYd9hrlKnh7nL474LrCaFxxhn4zSWPiu/Qo5dTLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552774; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pIUQFEXCbmigw9dqfoVZfvH3jK9BYdM54ry+LcO44MrEBQ+vr7L5XKf69w9knnh18Kx0vHOnQxdg4OGaSHUpk2C07Dv3tZ8SOxT5AWP/H9XKFgK4W7nubzseSYWHt7VFURfxQKakTerERIH/6T0/1lWjv58yKX2uO9XaPJACWWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bTja/me5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bTja/me5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bTja/me5qzEUqRIRdMd1cTaqH/
	oK822O5uxb6rRBgWszFwGMpfT6Hh69Iq4N9Isd7Uw+LnOOq47hiJ5w83kfIm+0oM9JxKJi7hVsMSO
	6+6VAngPuf1sy61fwrUb2g1wxIpgM7ziFiQxcPdOc9HdIWcqeFJZ5wUWqu2cp11wNvWqbZYa/3F6e
	NWv6h5WwaX0coTvcyad+FuES8ApcPckzwEfRvVeXUyvxQlDGyBVBOFv7EOq5hv40+P9+z3EQDNfgw
	4Jn6NfdWEq4NeoXVKRqU3TqGfRux50D1b/49NBLA2y/j3LotuMFZWKy1mKr7GmAQcc8ArrnY0OP7A
	+QVQQM3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRwr-0000000FSBV-0ozr;
	Tue, 03 Mar 2026 15:46:13 +0000
Date: Tue, 3 Mar 2026 07:46:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/26] man2: document the media verification ioctl
Message-ID: <aacCRQg-I-Htw9ch@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783402.482027.4208314092550733404.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783402.482027.4208314092550733404.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

