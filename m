Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2729358378
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 13:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783949584; cv=none; b=SB/J6j4ehTslRrCFdQYRarueNpZarwrWRhWRUscRnTQ58OKwdtw4iMftaGtd7aMgkQB+6PyD3vzuDvWfKK2eKJsnzC+jSFekRojtQbpakpLjgoOQE2S3tk4UEm+AYas4hixUZMz7FSDpZOnP/N08UD/NAf7KIyjMOd7dW0pfI+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783949584; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cyt8GoAJPOvlodt5DRJ2AWRsCYs5ePBW/SFzVtBm/9BO56D8QBdfBwCK3nrxTPKYa0NxFvPvdPNQ9LojM/noZRy8sfT1H3+h4q5X9CLpeVXaKgNg4Sh+6p6bZ887H/Jw3oirUCQods4n9XOb8oYEliO/o4xZjJJb5+18SLqcUC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 56A2F68C4E; Mon, 13 Jul 2026 15:33:00 +0200 (CEST)
Date: Mon, 13 Jul 2026 15:32:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v2 4/4] xfs: mark internal metadir file creation
 helpers static
Message-ID: <20260713133259.GB25950@lst.de>
References: <20260713124250.3978-1-johannes.thumshirn@wdc.com> <20260713124250.3978-5-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713124250.3978-5-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

