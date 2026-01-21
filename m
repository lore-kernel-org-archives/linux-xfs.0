Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208833385B5
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 07:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979785; cv=none; b=W9OTof0vwpLxpoxIlMy11RNw8Tuax372VbAZV5j7/H8lEt4QNJpwkjHvpFJZIghruiDt+bQIyUkbwCJ6tdqqEqD4xxhgn8h0/0Z8DDbSDx7t1dIFufE3ltQlqFzG6iCsRuJSp9pqTy0pnSO+HktuvjG+tGu+yPMVrRqIe0FCH1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979785; c=relaxed/simple;
	bh=5aJulP/Ixd6TX6trPDKdqv+RUGspDF7LS3pY0w8BaW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bLLGkeZDszjGpYNr1U6rsFKyEqWNcfLE1KRDy8sSQP2kkU0VgrGhwq+GteflKrlZahb/ciGS3/mpz5KGTjDGuhUWQOkDV+BaC8UmlMaiOvYyEFdJHItqYMBs22T2HLhvpeqYhhzq3Kv4v+1gdvF/XwkeZMyiirle9+4vidj88hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 14D08227AAA; Wed, 21 Jan 2026 08:16:20 +0100 (CET)
Date: Wed, 21 Jan 2026 08:16:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	dlemoal@kernel.org, johannes.thumshirn@wdc.com
Subject: Re: [PATCH] xfs: always allocate the free zone with the lowest
 index
Message-ID: <20260121071619.GA11963@lst.de>
References: <20260120085746.29980-1-hans.holmberg@wdc.com> <20260120155329.GM15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120155329.GM15551@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 20, 2026 at 07:53:29AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 20, 2026 at 09:57:46AM +0100, Hans Holmberg wrote:
> > Zones in the beginning of the address space are typically mapped to
> > higer bandwidth tracks on HDDs than those at the end of the address
> > space. So, in stead of allocating zones "round robin" across the whole
> > address space, always allocate the zone with the lowest index.
> 
> Does it make any difference if it's a zoned ssd?  I'd imagine not, but I
> wonder if there are any longer term side effects like lower-numbered
> zones filling up and getting gc'd more often?

ZNS SSDs have to do wear leveling by mapping from logical to physical
zones or even recombine the internal arrangement from NAND blocks to
zones.  The interface does not expose wear counters, and for modern NAND
the numbers might be different for different cells in the SSD anyway
and/or depend on various other things.  Even read disturb where frequent
reads require a rewrite is a very real problem now.

So in short: no.  That's probably the biggest difference between the
old Open Channel SSD concept and ZNS or other zoned interfaces, and
what makes using them directly from a normal file system feasible.

