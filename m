Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2243254A9
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 07:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768290457; cv=none; b=oN5XmtdQR5Ovx+U+BrvhI4SYCv9Tfh/w1cvrpTk3ADCQbDJJ/sFGHxZQ+9qsEQesP2fzeMw1jtxCeHml79krnhTJtsMjeCTTA5rW8pHJxRjb8t71uym+b7e7UIAA9KY6BinQsLV6f94IOT0NeEYucAVhdMPd7atFrSAQBaDy3PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768290457; c=relaxed/simple;
	bh=ct4PvStdEvIXJB1jMy7AvnKA3fUs5rV1GQYEZbGXSiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZEdwkHbv3nwVGWQruZFnaqiRIxPipTes9hOZGKA0Q+0ZwXU3QwSBQkWfUFUiD3b2Ho7vfkQ36zhlk2YUcSZLnidj4gxBP7LZFhStRnGW7n2Dk38bsjA+R3q3PaaMtrF5k/Bd6DRuVUudYojKYgn0Rf/SfTrHVehSQPU25nmUYQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 77E89227AA8; Tue, 13 Jan 2026 08:47:33 +0100 (CET)
Date: Tue, 13 Jan 2026 08:47:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: pass the write pointer to xfs_init_zone
Message-ID: <20260113074732.GC28727@lst.de>
References: <20260109172139.2410399-1-hch@lst.de> <20260109172139.2410399-4-hch@lst.de> <ce23e24a-d671-43bc-a5e1-28ccf7083aff@kernel.org> <20260112215008.GD15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112215008.GD15551@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 12, 2026 at 01:50:08PM -0800, Darrick J. Wong wrote:
> > > +	if (!xfs_zone_validate(zone, rtg, &write_pointer)) {
> 
> I had wondered by the time I got to the end of this series if this
> function should be renamed to xfs_validate_hw_zone() or something like
> that?

I've renamed it to xfs_validate_blk_zone to match the struct name.

