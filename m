Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380BC17546
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855225; cv=none; b=nZZ0r7DLhDlzxDtfogfFsxdYfJFSiNIjb2aMrZ+bsTUNYpzP17CwFLxShTqfUrgqYaOtNUH0qaaalHa0cq3+j7/gaMOn161439TqyOVjFUE37RHycEkXAbCfQIHM/RQNGppyZBDdjOcbvelOudkZ/lFhCVG9JC8ICftPAa4cioY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855225; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VL8EV1dBgqUqUpUuxKpZ1sipegKeHsfv6/lhoSfmEpsBzITdAyVICtXPjZyuH7I4ZgfT1jApumzQyXTm8TBNtQ7+DMpkCBmNx53SGN4WrJPyRSDVbyzHw2Lkeqec5IV377xsnAqr9V7HwuOSl5/px64/0DIcDjovCI46pRUx5Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E3xpS2OV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E3xpS2OV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=E3xpS2OV5YsJgLJdDbVFjlGDdG
	tplft/aOWRjXaPc8ljB4TSk2Z7bD5C2ySuilQ+sdJGW3iDWngJoQj1PHDlY8rmUSyzi3v6+H2QGHy
	k3Ml9zz1h8sKPJTJcRxgVq2UiIe2bEGLEmj7j1bYeKrsVyvBofFT67Moyu8W66BrWvJcFHIbTIiEy
	XcsrPDwdQNJes8NDl1cQWsml5jPaMJvDU7sVVVDORC1slMLbbBzvU2FKeu+xqU3vUZctvR9MwA4KO
	/F1IjjRgF2IiBxViM56X7bDBmVV4ZvXm4pfsD01seGF0h9ejkR4VaPMAqeRNZr9mUAAH7F6afGv24
	+x+0sqNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVn0x-0000000APpu-2o1Z;
	Fri, 02 Feb 2024 06:27:03 +0000
Date: Thu, 1 Feb 2024 22:27:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 2/5] xfs: support in-memory buffer cache targets
Message-ID: <ZbyLN-FnM6unhPCy@infradead.org>
References: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
 <170681336991.1608400.653884475555695110.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681336991.1608400.653884475555695110.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
