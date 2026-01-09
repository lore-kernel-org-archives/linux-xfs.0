Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A195F50097A;
	Fri,  9 Jan 2026 16:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975917; cv=none; b=iM+Grd43eV4forW/ZceCao3bzwtQykEgB/xbGRR67EPcHAtm8zvrpXBBk6WHlOSM+dptPdZg9QIh/kcYFQEdg90PJFiJRKTxXg3Y/oA+ckXABgRG+cIiqyKL0d3dNMlsLZTXL2ar4Tp4aqscZbQRNCKmkosbTY/ExMZwKMBjfbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975917; c=relaxed/simple;
	bh=jPWprWAjTi2zoDcFNXOjS0r/wdpfeYrOcVsGbWSIJcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AKC61BS+lt9dpLd6l5ZvVGRkbgBEm81OLLW1+b6ef+Tf4Q0D85RFG8cNNo8S+6ZzmH6e3diMMgAHtPyA5lbCRqs4Q42i4P+O6TTtVSxFGZZTMaLpInWj8YxGC0zaf+SQIvDtlDuzsc+MAXAlF3CNFD/9f5bgdn/tMQhQPN8sauU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7AC6A227AA8; Fri,  9 Jan 2026 17:25:06 +0100 (CET)
Date: Fri, 9 Jan 2026 17:25:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] block: add a bio_reuse helper
Message-ID: <20260109162506.GA16090@lst.de>
References: <20260106075914.1614368-1-hch@lst.de> <20260106075914.1614368-2-hch@lst.de> <20260109161906.GN15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109161906.GN15551@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 09, 2026 at 08:19:06AM -0800, Darrick J. Wong wrote:
> General question about bio_reset -- it calls bio_uninit, which strips
> off the integrity and crypt metadata.  I /think/ that will all get
> re-added if necessary during the subsequent bio submission, right?

Yes.

> For your zonegc case, I wonder if it's actually a good idea to keep that
> metadata attached as long as the bdev doesn't change across reuse?

We need to generate different metadata for a different block location.
Reusing the allocation might be useful, but it would really complicate
this API, especially as the currently most common way to use integrity
metadata is through the block layer auto PI, which allocates it below
submit_bio and frees it before calling back into the submitter on I/O
completion.

But it might be worth writing up another sentence on this in the comment.
