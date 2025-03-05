Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3791FCCE8
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 23:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741217629; cv=none; b=Lg3E9Mf5hnccAMIuKjSNnSz/7hYEeM88PYcjD42b0CQnWahH4BZewYHP7bhfKPVMyBmc+6KjaZ9EWIcx0b+wCNWaUWQSku0iIbh+9hT5B93B2Qh7r13zbJeCEYZQaO8HLEWeMvmri5G6bDgEuCmjr0t7NvtfZ1FK0PGfYGnSSJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741217629; c=relaxed/simple;
	bh=KDi1MwnDBuAVV/l7B2X84fl9RiiW7VYOCyU+jbYFxhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NcWkhS27pGJMlr+ml0A0fnW+TTn4wLTArgVDrzRMx0JjsiIPDskzbnndrh+vY0uUppgok41+VHAW7qm/8/vmFtlZ8lGQkN1Y5MaJRu7VWusOQW4sKWVJAMntnKYHm+pIOf/slpMDm5cw5srg/BE2X3wm4WuHIrBtO5Uvg4ZI+Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4E3F968BEB; Thu,  6 Mar 2025 00:33:43 +0100 (CET)
Date: Thu, 6 Mar 2025 00:33:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: convert buffer cache to use high order
 folios
Message-ID: <20250305233342.GB613@lst.de>
References: <20250305140532.158563-1-hch@lst.de> <20250305140532.158563-8-hch@lst.de> <Z8i5HSS1ppbtQiJc@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8i5HSS1ppbtQiJc@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 06, 2025 at 07:50:37AM +1100, Dave Chinner wrote:
> This may be one of the reasons why you don't see any change in real
> performance with 64kB directory blocks - we spend more time in
> folio allocation because of compaction overhead than we gain back
> from avoiding the use of vmapped buffers....
> 
> i.e.
> 	if (size > PAGE_SIZE) {
> 		if (!is_power_of_2(size))
> 			goto fallback;
> 		gfp_mask ~= __GFP_DIRECT_RECLAIM;
> 		gfp_mask |= __GFP_NORETRY;
> 	}
> 	folio = folio_alloc(gfp_mask, get_order(size));

I'll give it a try.

