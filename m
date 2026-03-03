Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5FF1891A9
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552763; cv=none; b=i7DvwvYDLcE/aOmxlUUYp6GPWg6uhO2+z7f4LWjWZG6Y9ce1F0HyR+ubFJRrRywQM+OZ/H0tJNO/h5iUQ8zShQ/1R2lhFbxw0LXSxHIDRImlewaIVexHaekxv4daoExzgknyI0+4UA0iVNMxuZdPOZwhtYy0F4fRZ/w/nKmt5u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552763; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J4j36jT8oUryJxUkqp3dcV33uHByY2G1w0QthCUMaEOWo0SSkGEXSiEEq+vK3hvQa3WlG1rSOBdbeGEpZeZRiu6tEGcBcVg7FXvbr5CYVKR39fMkInIOj3HIeYd0yvVOktDfcawnlSRyQwzLb4X+Cc5azTPSh9hTUZ3OnklD/g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=scjM9U/m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="scjM9U/m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=scjM9U/mmNvdE28vDydrOuCceo
	fJ8e7j5IP3Dp7cymN7xq34qwK6MlZ9OrIhxKlnf7+3GhLBJT7tAKShF04BoU9rEcZuEBkh1HCX8U5
	rKTVZK3+L5v6EYJEOgF8+vbkJAF3PcZmvKXnWkyCVHEqnqIO8cP2F6Z0MEF0QQUDdhrLmzsEi30t8
	JE4fYOU2WP+Dvmam4QCyQaNYyWlLD5eaGi0y+/uwx842fL2TCd2yh/vyZ7xvSnPfedfjP15gt9NGY
	IitwQbH5iC0NFo61V9UZPUvTd5HP7j7MdDDgWHsBU57rdYWWwEv3NBLjONQHnrhu0vTLYylP5nS5S
	+nd+3geQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRwg-0000000FS9o-0RjB;
	Tue, 03 Mar 2026 15:46:02 +0000
Date: Tue, 3 Mar 2026 07:46:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] man2: document the healthmon ioctl
Message-ID: <aacCOkRXRdva8MxX@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783384.482027.17022650157700588082.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783384.482027.17022650157700588082.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
