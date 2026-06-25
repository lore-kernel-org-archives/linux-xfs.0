Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4B4382F28
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 12:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389037; cv=none; b=fp0z/XzTL4G90jZTG1SIOkxLBQYD4azoceacz3fREORwEZBU9qc+66x299khGzyryQEyi2RzVoclx4wwhEh7K3IkoYB1m1GaJ2H4gr0DdFZ+tNH4liWJu/uSktlKaPzmR0bzZr0pAJHbyuHHUZKWRFfiOouDhmAFp9zH8eqzJ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389037; c=relaxed/simple;
	bh=egzvfmgMkfAiX3MN5yGiXEIqQO2wZv+ZLd7SXJfVerI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujisReS5B6wfIZ81VzlVpsjh6nseeVQfQ/EUNmg2NdjN3W1MxqvqGNMi8N/glKIs14lqRPAn6FmapRFIYBAcKbK4YgL16IPGsYfr2/pleyModUYVwvgUcB1fowPA1UHhwz6YjevmJcsCG9W106ZL1YMTS9pv9Lfy7hY2kREOaRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 57D5968B05; Thu, 25 Jun 2026 14:03:54 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:03:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs_scrub: warn about incomplete repairs if we
 never get to them
Message-ID: <20260625120354.GG18766@lst.de>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs> <178232484549.915780.14963277252337117139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178232484549.915780.14963277252337117139.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 11:16:04AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If the final pass at repairs fails because the kernel says the
> filesystem is busy, we should emit this error to the caller instead of
> dropping it silently.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

