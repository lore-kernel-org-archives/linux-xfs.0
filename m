Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA22202C5C
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 08:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742287395; cv=none; b=fm2/3xIyFu43aRmukItbH3SMGYvfbFrSNSAKqNsJ6p0VY06qVSVZYpSpp0dWY0GuTFHrDKbQkUEsElRJXEPMFPU+HsY2Y8YVSgkZpiLlEcIiJ2diqebZF7DhYgjI6FPvhzX7IsrjZQvXN9FydhKQE2/kj8dqMlAeFR4IWzsmatE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742287395; c=relaxed/simple;
	bh=Hp+Lmu+4fXPPb9wK+fceDmWS4cbOa8e7qLO5UOmRbUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DZQJCCjaVc6XLxLdGpkxuXMCXEDVaMm6hVDQzK5vSWE9og7tjedXPZXLDvFmSL1859+ex27TvBtZD0EwWo/tSzrFwJw7uqUPyLmgxfsq4m5EpkH50HsKPH3qliivRjhZ0zynZqc3+TdFW6WLZaGvcgBFhnyysovh7yxgC4ndwl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AB82168C7B; Tue, 18 Mar 2025 09:43:09 +0100 (CET)
Date: Tue, 18 Mar 2025 09:43:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: use vmalloc instead of vm_map_area for
 buffer backing memory
Message-ID: <20250318084309.GA19274@lst.de>
References: <91be50b2-1c02-4952-8603-6803dd64f42d@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91be50b2-1c02-4952-8603-6803dd64f42d@stanley.mountain>
User-Agent: Mutt/1.5.17 (2007-11-01)

Hi Dan,

thanks for the report!

Even before we really would not want to call xfs_buf_rele with
locks held (or other preemption disabling), so I'll look into fixing
that.

