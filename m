Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E339D17C73
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855452; cv=none; b=PLYr1TF+aMNSrLwtZVQ/xt0yhOBcR9ruUm9xS061JkGgv0lVpYixoL0jUsveQ16SF30igfrS/7PS4t9TeYJXw0YOFDX/KtwryPoudDHFtuBlPYTtLRtCCc7vRQQ6O3lIId3pRDlAe4nqXfvQi72+u/CwB301TU4KTU3NMX8X3BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855452; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ig3Yrp80kdEM4MF+a4catROO9z8+VkGXcQkiEyc3Rj3VRN3cmlgwGuQwOT8xiXlgyeBVJLqSnSiGePQZSqJoxLilBOMisMfx4vvz20jhTQ1SqkUP+Til4EbRAsZH7rk0B2tyVcamV6A9EI9TGcehf1Mf4o2+4ZahbZOqEGveYyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3E3NuvCu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3E3NuvCu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3E3NuvCufBMSlepc+pQqnTJYnE
	JGF5OmaFxw0VLr2mvRbi/zGnnITUuJeCmzMzBrfcMHdIzLNZqSiJ0HgmfGLeC1KAKCN5N3CrcKCZh
	xFYKxyyDMiNPU5hNWTYhe+vJ4+LIXfaJYSUBP7ecPYTAjX9qv+7r389hgP5PPD7pkK9mqsBbtC1bu
	5BqOvPPbICNeqocz8ut/A9d4XmEXOYluSv+GR4piQ3eoNmOpwwouDTH3PxvQ+FMgnXymYWMMgRMB/
	A+qSB+nUTSCyze4KIm2liMu8+yV/m2S6tOzqrKjGoVYho3NgMDLF7N0zucZcKQdTYctjdvJt5BH4q
	FAMj4kMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVn4c-0000000AQVn-1StK;
	Fri, 02 Feb 2024 06:30:50 +0000
Date: Thu, 1 Feb 2024 22:30:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: define an in-memory btree for storing refcount
 bag info during repairs
Message-ID: <ZbyMGmKrgHSTiXx7@infradead.org>
References: <170681337865.1608752.14424093781022631293.stgit@frogsfrogsfrogs>
 <170681337888.1608752.10921448345076669658.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681337888.1608752.10921448345076669658.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
