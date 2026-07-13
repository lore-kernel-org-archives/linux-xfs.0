Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AB63E5A35
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 10:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783936899; cv=none; b=mGLL0BA/Of96S6Kywviejz/yc6iL3MgqkvfQugIZmBRxSv9L8512sxMFkrBHvudy53rJUT7h6P9kdIgCdWpNoReq3bbdb9zh7wY29AI/7G5sglg7S4TZgkPPvoOKq3uomAC8Sm1PNWLwjn5VGBTlwF+iLCzzPM9W02UidZ558LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783936899; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EXmtAAZmxCx+f/wLZf5bD9/Z1SbqDLl4Dp35k7DrycGNwnRT+P9FpBBIx+8Kz6Nrl5HcfBeyzioJNyFCks/dRHUPYpKvtNgwFCCrZx83o5aeNIq84v4cKiy7EGFnp0RYIZ/+h146NTl9PgnbhZ9CpOA5aiVfi6/bQoWDPQY1Tao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CE96268BFE; Mon, 13 Jul 2026 12:01:34 +0200 (CEST)
Date: Mon, 13 Jul 2026 12:01:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org,
	gost.dev@samsung.com, Zhang Yi <yi.zhang@huaweicloud.com>,
	pankaj.raghav@linux.dev, andres@anarazel.de,
	kundan.kumar@samsung.com, hch@lst.de, cem@kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v9 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
Message-ID: <20260713100134.GB10795@lst.de>
References: <20260706084117.1455204-1-p.raghav@samsung.com> <20260706084117.1455204-3-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706084117.1455204-3-p.raghav@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

