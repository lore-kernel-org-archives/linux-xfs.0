Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7143FBB9
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709141004; cv=none; b=OBmQzzdV/pv7zwWw/luhD98jL8JA2q0gNFdvqoha0uYtsnOqzj5VsihiVBvDBnCASSTuS8Wtq3xfwxUBEpe8WSFaMjZAyOAbHXjOTrlkiweOdMIBnEoJeJlATID1p/O6EO2H5TgH4HWGzTxPuBgyJ8R+AURsDNh8TmZR7/fawnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709141004; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CY0F2udJZzfp5T4QXS5ESv/ZCcEXLAJ+qrS0+z1dSmxg0TnMNVTnDbjkgtFnF/E1zl9z2pxNDrw53qpHShbfiJ6WPSqebwWaibzj7yhOjuYHdtJfy4AuoaS0pw544mE2Vtmsw5va071LDCDRWGf2YtcVfNjWPpwMi2M1uNAPfUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PLm49cfU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PLm49cfU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PLm49cfUW8SI/JHTX7bHvLTkD/
	a5Ai9B8JYovB6HizVbLHZNSn7xLBY7GsAb+3nxoJXBvfX/MEKKgAZ+/14baD4Su96DA/palY/hjky
	Vu4E/VzdZ1xYlFK5sMAtGP+S4Q4m5UhyvMfhUhXWqLUYc+6R8af4KkzkpBQ2ATTUoNGenDqr+sRNo
	k6VAUVX/lq9ULoarxCjCs7uYSRyZ3J32Z2TaE2nVPTnbyAZu4JiuBA/AKJBnFPq4AhWtw1lr7y45a
	hG9gP5f47a8VhMKb3vX+z/GhF/j6Y3dbNikZVER7r0dFlKOO0YF1kVLZcm4qDKljXRQx4G9lS7aXo
	yLTL/hCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNeM-0000000AHRA-3Eca;
	Wed, 28 Feb 2024 17:23:22 +0000
Date: Wed, 28 Feb 2024 09:23:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/3] xfs: move files to orphanage instead of letting
 nlinks drop to zero
Message-ID: <Zd9sCjc0UO_5H6JK@infradead.org>
References: <170900014852.939668.10415471648919853088.stgit@frogsfrogsfrogs>
 <170900014894.939668.7469648935720759924.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900014894.939668.7469648935720759924.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
