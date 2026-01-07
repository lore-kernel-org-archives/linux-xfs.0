Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1753C2F
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 06:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767766981; cv=none; b=petfb2BzVdi9678Pawrlyz6d7q8YcPbhnShxtRfr9gC/gLz6BCqeLPVmYW/kvofze7rOH78OICsZ5T2t7vzDdzrwfunugt/Yl3Q2BG07DEcrIejOtRCPLtg7Cw4lvmLhWTYIv6hoO9SHyEtcO3hutPhmXKRkbVxZS8FcNMl41sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767766981; c=relaxed/simple;
	bh=1Nw4o6fd30y4ddIfEDR5gIjr9scP8X8vFKJxizcP0NI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lj80Ngoj6IeHON5ZxZolFqlhuniMKqMzoFrwUWre/Dsc1AD77Bi3yrBda9Qz6qtP9rAspcxXluEwmw6rZVBqeVqi6agDUXJlG3+KQWtFwDPIVqFwd+Q6ae+ImqKs4tPp2AaV0TGIgbUiyB/IoxdOHHjWaesr7rckDcPyqhLFU7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5E2F2227A87; Wed,  7 Jan 2026 07:22:55 +0100 (CET)
Date: Wed, 7 Jan 2026 07:22:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v3 6/6] libfrog: enable cached report zones
Message-ID: <20260107062255.GC15430@lst.de>
References: <20251220025326.209196-1-dlemoal@kernel.org> <20251220025326.209196-7-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220025326.209196-7-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Dec 20, 2025 at 11:53:26AM +0900, Damien Le Moal wrote:
> diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
> index 7a81d83f5b3e..3c89a89ca21e 100644
> --- a/libxfs/xfs_zones.c
> +++ b/libxfs/xfs_zones.c

This file is shared with the kernel, so we'll need to get the changes
from a libxfs sync as well.

> @@ -3,7 +3,7 @@
>   * Copyright (c) 2023-2025 Christoph Hellwig.
>   * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
>   */
> -#include <linux/blkzoned.h>
> +#include <libfrog/zones.h>

.. and we'll need this include to be hidden in the xfsprogs-wide
headers.


