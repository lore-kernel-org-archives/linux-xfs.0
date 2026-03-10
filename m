Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FC442EECB;
	Tue, 10 Mar 2026 08:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773132251; cv=none; b=jy5n+aur3MIYFWkdYeEUvMnLlLa7ZkSXzjqppeucCVwViRfGBA7DKtCCcuq2ykYQhqYUQXsNBltltXWs71h4v2Uu4NTrnJ2gUmw9GHzgtmSuF4C6kFh+++v/wgoE7A3A2FpF0mJUX6XjBGny4wdaQB9D2Oz5dp9w6t+5z380ikc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773132251; c=relaxed/simple;
	bh=bO4CoERUMsZ0TON44WIK8gTeMmgpLszBQyrJ7vBOg4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XLF+Pv2qEbi3WKIzcPRhES9RUaCJECkNIExS4l+Ug1CvlRCqj4tuAV6QAkZ670Y8RVqsGJwkoaTqapqXBo5iv5JXDrZQzDBHdRfrmQhBASd84vIJg48NUe93jY9kDAtssmQ3tJ4wPfv4AUDnJJ0EMlGHeaAHqdRVOPoGO3DH82U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 064E968C4E; Tue, 10 Mar 2026 09:44:06 +0100 (CET)
Date: Tue, 10 Mar 2026 09:44:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v4 07/25] iomap: introduce IOMAP_F_FSVERITY and teach
 writeback to handle fsverity
Message-ID: <20260310084405.GA17112@lst.de>
References: <20260309192355.176980-1-aalbersh@kernel.org> <20260309192355.176980-8-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-8-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +static bool iomap_writeback_handle_eof(struct folio *folio,
> +				       struct iomap_writepage_ctx *wpc,
> +				       u64 *end_pos)

Please keep the old double tab indentation here instead of this very
hard to read and modify version.

Otherwise this looks good.
