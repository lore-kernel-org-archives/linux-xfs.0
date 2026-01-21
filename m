Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ED53A63FD
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 07:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979818; cv=none; b=uIw5iFlyW98JUG/4rXDURSwKX1bc27ElDmKsIOfrpc9gq8uTeQSsSSDbJxohG//v+NIFkyl0m2XbhEFbJwYqdBjinqv7dDEEHF/RDCR96FQawaezn04TJsdJOcfjzLZHi33B0JwfniJA6IvjEns/5Q4k+4ZqPEo5MZx5aPSMMyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979818; c=relaxed/simple;
	bh=dMFLkkPsgdXoy/83+LrrIYtMFRMTMFScB3S/UYrfDyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kLu6ktOhRhgjUW4d4kRC9js62v0FXhsrsknvO9syOauAA8Hz//lQVkbs9OHF0ZkaMXwFsE/OmfxgnVJDZZTe1auYlzUlfGxNKbIAGac5EucGeK9OfwvpAZ3WGDj3IcDAe1/FXfAIQRBxbFsHXHwRB6E6APASc3AZR3tSuXGX1Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7BC86227AAA; Wed, 21 Jan 2026 08:16:53 +0100 (CET)
Date: Wed, 21 Jan 2026 08:16:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, dlemoal@kernel.org,
	johannes.thumshirn@wdc.com
Subject: Re: [PATCH] xfs: always allocate the free zone with the lowest
 index
Message-ID: <20260121071652.GB11963@lst.de>
References: <20260120085746.29980-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120085746.29980-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 20, 2026 at 09:57:46AM +0100, Hans Holmberg wrote:
> Zones in the beginning of the address space are typically mapped to
> higer bandwidth tracks on HDDs than those at the end of the address
> space. So, in stead of allocating zones "round robin" across the whole
> address space, always allocate the zone with the lowest index.
> 
> This increases average write bandwidth for overwrite workloads
> when less than the full capacity is being used. At ~50% utilization
> this improves bandwidth for a random file overwrite benchmark
> with 128MiB files and 256MiB zone capacity by 30%.
> 
> Running the same benchmark with small 2-8 MiB files at 67% capacity
> shows no significant difference in performance. Due to heavy
> fragmentation the whole zone range is in use, greatly limiting the 
> number of free zones with high bw.

Cool, thanks!

Reviewed-by: Christoph Hellwig <hch@lst.de>

I always like patches that speed things up by removing code :)

