Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CB42D8396
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 15:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773676573; cv=none; b=gOC0/KOPEqKEm+ET+Ejfb4vyq0ZNCNCiypZHMmilmriXOblVT6e1MpQXyFOzS00WWdu5rzuZoYNfRO3wUBbpF6XmnfB7MtfzdRvIkvvpIp2EkgpU9J72mpy+ECZdOB0lv92nxrJqTw8oyTd/gAK3kVuhfBRVB9MH7GDY1zhIxMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773676573; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ej6yaVleM4R9toEDRVEte9CUQMQeiMMxviWwVG9FuKEPdGo/0AmzoBZhO1fp8qkxgbgEDvl8TXiAScgvO/zusa/wJ3MuqOIyoj9UFmF/7SAEHAiPzNHI2jxPMJkB3nGHqB2w/nHmXCWJJ+gPk+ig0ackRdxVbzgigsNlf79eFLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C71F068BEB; Mon, 16 Mar 2026 16:56:09 +0100 (CET)
Date: Mon, 16 Mar 2026 16:56:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: Re: [PATCH v2 2/4] xfs: fix a comment typo in
 xfs_select_zone_nowait()
Message-ID: <20260316155609.GB18936@lst.de>
References: <20260316114020.753228-1-dlemoal@kernel.org> <20260316114020.753228-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316114020.753228-3-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

