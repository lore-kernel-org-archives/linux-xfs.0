Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D21A94D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810018; cv=none; b=H+BEmnPUSnP9qZ2TXl2HW4a/Zap3pOx8/dhow9NXnovZm9J12coa8Wdgl/RV5k15fhO+BA13Aaom3QMeet/CUrJ6KjFgOFM+OiGznY0TDPLv20zUb0+Z/4au0oTjYMtm+ctg38OrdzKX/3msAbxS00T5lV+wS4lz1GDlQW7P4Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810018; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g560UOx0RNQHSXoWF+itpheyCBQKtM3fF0GfA0Ukb0b1W9JjVzWjb9GwK45/QOHy9YTdjf/XqHeSzSM8VKu5Dm31nRbuuooBJs/nDQT69qpmqt8wBrqWpr33z4ea4MOh7ZhZitEeVurZ7SZMuK/ZQZ9FYSTQZHh+Mw57ZZfJN70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=av5IqkGn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="av5IqkGn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=av5IqkGnvO36pEybsRX75+KJuv
	xyVzXOysIg7zlihymirRnAX1CfWrp2/JAYBhgmtNwgTTHzNP79KiprarHADoEXeJPy3hOTKpIMuj+
	M0bUZTrGnJlCO2QBn3ijbq05FmOnD89Gtf7jsfMUkBFtZ0s3mfmUGluQyMI3WuFd8K86NbPBvDOcF
	RxAmCn99BiFt6usTLSqtaQ7jcCZDwGSRF5gZQH05l3UL6Pc1ICkkdE3YJj/hXL0CgmbDMrJuQMhXh
	HjC8PPzQfBdLUu9CAjPXjgaTFpyipkDKNXemR4NvNd0QJzwW40SNUu3+BOXZuX2dJbkDi6awxKFpK
	Ro4sPn5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtBh-0000000AJj5-0wza;
	Tue, 10 Dec 2024 05:53:37 +0000
Date: Mon, 9 Dec 2024 21:53:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 38/50] xfs_io: support scrubbing rtgroup metadata paths
Message-ID: <Z1fXYdQWjustJZ-g@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752526.126362.1330837670564192968.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752526.126362.1330837670564192968.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

