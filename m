Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5FE13E043
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 17:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711559018; cv=none; b=ie0pW2vSOXzIWl7FrOhBGmLDMPfoO+0e7YcqhmK3PSWgCwPcvfASPDHdz077tBxlw61ejwYUgihbMNntYnhI0JsnWLv7FXvKRMYZMmhvmdhERcMuGmdJ0oTDWg9eo29DydSjUX3tn6gri1HMB8yc2784EWIHC37HqI6NXSfilcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711559018; c=relaxed/simple;
	bh=91Asip5rgbKnzSZZa/PT3Hcf4n+BRO8NYXrCqz3Bh4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7uv3g9CMwV7bgKSVUEb3vwmSrInXVCjNVatcUCd7JrA9TLYNF81ReXOxynrhPd/KXL/5gR5nM7rd6cY2XZaYCQ8c+d/eWjGJHohO5E6q9uMIutpkiXIEuZ+dXkbAJoSNmDivI8V/S2Pors2laxjiRfMlTDGZ2WL3gPqHyTm5PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 67D1768B05; Wed, 27 Mar 2024 18:03:29 +0100 (CET)
Date: Wed, 27 Mar 2024 18:03:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs: free RT extents after updating the bmap
 btree
Message-ID: <20240327170329.GA32019@lst.de>
References: <20240327110318.2776850-1-hch@lst.de> <20240327110318.2776850-4-hch@lst.de> <20240327145540.GW6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327145540.GW6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 27, 2024 at 07:55:40AM -0700, Darrick J. Wong wrote:
> ...and the realtime rmap/reflink patchsets will want to reuse the data
> device's ordering (bmap -> rmap -> refcount -> efi) for the rt volume.

Yes.

> 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I'm ok with moving this now since I'm mostly going to pave over it later
> anyway :)

Actually the rt extent free item and refcount work will fit in very
nicely with this.  Basically the rt branch added here needs another
condition so that's it's skipped when using extent free items for
RT.  And the extent free item branch needs to pass the RT flag
as already done in your series of course.

