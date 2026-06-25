Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE643DFC61
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 12:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782388883; cv=none; b=cgF+1mpeoBRAqOxfK2CM7jfKgbqwpFhrqIj7Puw4VPZG2CgxOQKEYK1bKMIyCSaYmo4yiwMLfJ1NbFG+LnzVgcXkT21kOGBgiPWZ9fggYiwlUYLLkNZKFtyzbZM8dor0oR/wstxLvVLfdRxktCt4r+RH4TPTU+L6u4VclGbBlno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782388883; c=relaxed/simple;
	bh=dskG8G4e3wAp/kiav/2w54jri9PXn5ePppOqDVQ7n4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DB2WAvzKODPF3h8HUsu8hfQiCoZJEGLlYNd8Kqj3lzTnxR71Fum0VEAs0TtWEZP+eauwHi1B6cZjkuisI9MFmJHl6WFa/gx8H7PYbTeVNzt8gr/sPYWne3Ff/bT2HOxpHRVcs3jGwCTqQRWvrlvtpmanD50rrp6/GaVEoNVevCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 00EF868B05; Thu, 25 Jun 2026 14:01:19 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:01:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/11] xfs_scrub: handle media scans of internal rt
 devices correctly
Message-ID: <20260625120119.GD18766@lst.de>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs> <178232484494.915780.16900802517191563379.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178232484494.915780.16900802517191563379.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 11:15:17AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex noticed media scans of internal rt devices don't work at all
> correctly.  First, we fail to allocate a ctx->verify_disks[XFS_DEV_RT]
> for the internal rt section, and even if we did, phase 6 doesn't
> allocate media_verify_state.rvp[XFS_DEV_RT] if there's a media error on
> an internal rt volume, so we'll crash there too.
> 
> Fix both issues to make it work properly.

Do you have a test case for this?

The changes look good, but I'd love to have coverage for it...

Reviewed-by: Christoph Hellwig <hch@lst.de>

