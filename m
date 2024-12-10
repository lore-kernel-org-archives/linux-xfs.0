Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499AE22617D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808228; cv=none; b=KQQKW58nYQ/lbx7Awb8i1QwnfNAn0wSDlukEp3etyc8t0wx4IdcBfKlr4j+6fCEm7yGsShl2jzGFj9fT1gIJBvZJPDz1GwqKzqZLpPSt8T8x7Y8dH3cFEXnblsmPts/GSPdEizf0Lt8YoK+ztIbpuXlOdd9OK4RagSH413Kynrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808228; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0gAgO8yWmetY5riV5NvZ8+htwRUomJcw8/HKPAboJ/iapFwOMje/1lgq9IavJMFf474dgS+OLVFPnMNg9HhWX5Cr6EdRM5sHtrgNFqZywPdiX3KzJbcpZCsNMPqzc6czqQeLa5UoRrteyRnr5Nm/x1WeWzgx96Aeatd+CMopGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D72mYzBR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D72mYzBR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=D72mYzBREo3y/GaIKnbWyyOgky
	Z+AqxcWxJq6YW2gQ9h3t/juChPDD/z2RmwDacvRQCHfxsWAmgLefCUfLhXQJ077m74Fe/Ai3r142/
	6SQnXjNfXhnljy5ns8SaTYIs+EsjKXyPneDaULLNUSsCUsWPW3UldVroFBYiwyGeXcneX09xxN73K
	PaWLtRPDsN9YyqNihWUrv34hzK5lmrcWOnkWZJ5yTMn6OJiK7sWI7wHbjDGdSKRKZPpBMLeSBwq1Q
	S6SRXWGGg02B8/l/IB7236pOmEPcFoEYAF2wOgXn6oWn8YuTpWKEdFkSEL46yp7QqiXZh8Ug6h3B3
	u16+Yl0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsio-0000000AGs6-46AW;
	Tue, 10 Dec 2024 05:23:46 +0000
Date: Mon, 9 Dec 2024 21:23:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] mkfs: support copying in large or sparse files
Message-ID: <Z1fQYph6VNvPXgaV@infradead.org>
References: <173352749310.124368.15119896789476594437.stgit@frogsfrogsfrogs>
 <173352749346.124368.1797987373913222257.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352749346.124368.1797987373913222257.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

