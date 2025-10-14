Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AC3F9C0
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 04:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760415428; cv=none; b=ccCCoAUHkTNdnR7oiW3b909SdN/T7/dwFeHGhn0jsA7atGhos0d9XLRVWDPSDxsgdSfLzgm9jfWt6BJw8NWoP1qKGYlqdaK3VVBZg1wa0f6tIGFvfFx3k2Pw8d4OsG3wkVz7EbOkIV1N90z9XrmVuamSjhmvVh9kL9GGG1oK188=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760415428; c=relaxed/simple;
	bh=dzCl5rkoO2z2ZEgskkWYfXAlgD7/ynoO8F4nBdZSuxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3J0aUyhTLZNYsChxUkD8FyzeORFdcAP68bAkkcOHtm7qZL/S4iIiyz6Kwa1DeN6mS2Zdjet+thy/10mSR2y7oMWiwhFQF+XenJe3MVjKUTCGzH1anZJbI9GZPqNKG77arPt4Z4Gh0OsEJJrRR8vTs4s2T0u3kvZOLAudJsaBH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ECC63227A87; Tue, 14 Oct 2025 06:17:00 +0200 (CEST)
Date: Tue, 14 Oct 2025 06:17:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: Re: [PATCH v3] xfs: do not tightly pack-write large files
Message-ID: <20251014041700.GA30243@lst.de>
References: <20251014040729.759700-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014040729.759700-1-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 14, 2025 at 01:07:29PM +0900, Damien Le Moal wrote:
> +	/*
> +	 * Do not pack write files that are already using a full group (zone)
> +	 * to avoid fragmentation.
> +	 */

Same nitpick as first time, please either say realtime group / RTG or
zone, but this doubling up just adds confusion.

Given that the rest of this file talks about zones, zone might be the
best choice, but I don't have a strict preference.
