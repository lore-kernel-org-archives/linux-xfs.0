Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D815B2DC334
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 05:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780378498; cv=none; b=T1l5H6FmMP5eQpxEFMv7mVqPELgMwmppN7brQUMz5wc1Wk52zcAKUCUqyUvN++VObzalc0OGtuOwuxCOGe2H4CciCIWI99efNPdtvtqKdTDpFZUuYXSZontaaKMjKc/+gRmmnK0EwfCmE/x8fSopHhcMO3odVcFVh7eb4AIw5rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780378498; c=relaxed/simple;
	bh=bxBcxVKi/Th62Vu8A2YVhRjnAJGro/O4XGTV2AXjpbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ktosq5R5L71NFhViPrEAfOUznwiFgWBCHSgMv2H4VPGQD3J1JaBBXdQghZBvfcDPaqQrvztdeCEbpljMYX/pCFf1Xgbi4O60DfyNV0jRUrOugjYYTluQyMSi21J1+KWdUo+Aak1fDGyK0juLJjT8ahIl61i1AZfr1UkqtWwGmPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3011D68B05; Tue,  2 Jun 2026 07:34:52 +0200 (CEST)
Date: Tue, 2 Jun 2026 07:34:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Nirjhar Roy <nirjhar.roy.lists@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: pass back updated nb from
 xfs_growfs_compute_deltas
Message-ID: <20260602053451.GA32429@lst.de>
References: <20260601110824.3392683-1-hch@lst.de> <20260601110824.3392683-2-hch@lst.de> <20260602043640.GM6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602043640.GM6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 01, 2026 at 09:36:40PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 01, 2026 at 01:07:52PM +0200, Christoph Hellwig wrote:
> > xfs_growfs_compute_deltas can update nb for corner cases like a number
> > of blocks that would create a less the minimal sized AG, or running
> > past the max AG limit.  Pass back the calculated value to the caller,
> > as it relies on that for a few things.
> 
> A few things, like getting the fs size right after the grow?

Heh, yes.  I gues I'll have to reword this a bit to not sound silly.

