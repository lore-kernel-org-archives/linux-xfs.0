Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5E324A076
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 04:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782449453; cv=none; b=uvYlEcWYnbQ6YwJ3HhRoXrE3p7+B+NT4Pr/P+NBnvjFhnAQxa7j8Tf+v1PUNisPk8gQLEGyOtjj/ipZJMArx3MzPpKovMnCsQ4rbzsqFwCNizY1Y+EKniU0iHxx6aCVomtZcxsREY/hBC4tsostCKAnNNuVba4HVUAiEOz7gXLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782449453; c=relaxed/simple;
	bh=KnZc0kvmCs7HJnntb01MBn2Pnh1aYKu0DCdh+KMfLlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOU+KhbH9/85rCxemMrCmpev3KABGbySw2YLd/PsC36gt2lW7DKtZhjwUP+l0hhqwJLa77py5EMZFBuf1RwUCn+pY9m/jfyarUCoWpFsvQ/+Zr+LSASCfSZ1Qu8xkt+LDA2w0GpabBIbSv/Py6l+CmAwEV9GmDihLJlFGnR6YCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD7E568B05; Fri, 26 Jun 2026 06:50:49 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:50:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs_scrub: handle media scans of internal rt
 devices correctly
Message-ID: <20260626045049.GC8613@lst.de>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs> <178232484494.915780.16900802517191563379.stgit@frogsfrogsfrogs> <20260625120119.GD18766@lst.de> <20260625224854.GM6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625224854.GM6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 03:48:54PM -0700, Darrick J. Wong wrote:
> 
> Sort of -- xfs/556 is the media verification test, but it _notruns on
> zoned filesystems because of _require_xfs_scratch_non_zoned.  The
> _notrun logic isn't quite right because while dm-error doesn't work for
> zoned disks, it works fine with -rzoned=1 on conventional storage.
> 
> Well, not entirely -- with zoned=1 and conventional external rt storage
> it works fine, but with an internal rt volume, it does:

[...]

> So I have to patch fstests further to avoid setting errordev=RT when
> there's no external volume.

Cool, thanks!

