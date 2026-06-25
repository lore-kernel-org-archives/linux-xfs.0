Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5661A382F28
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 12:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389009; cv=none; b=qkv+H8XH8lKTvIVG6nPhoMUaYls4r8Fl/NP301gXFLhA68KjW8E6tXnoD01VN4AVBKRPF9YFdT5jWtf1X48VIVvD6mWlAw6KtofzR35hUVAJUVduoq7Y0hgW4GlBxUpHcTty+HLJ+rqnRMNpGLu97CUA7MrtHIe02395f1K2udI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389009; c=relaxed/simple;
	bh=/lCv0z/BgyScaeRBW8AWJKAQAfU/BwTgp5kFjhOx23I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HO1K4qfqOvT1h0jlBLyeAVYYphoRHfRY6b5VZWyx5bm6KkbXtkKz+dmndp/45XX5unVQy/8BcPSoMAlX1WSMWZxb9TKdVT+Y0f57g3xjUee35UCZ8BDs5/GizJ90l5hM8gmWe/bV8VhJNqlSlDtLLQRGHQ/EsVexsjV5vwaBUNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 17CE468B05; Thu, 25 Jun 2026 14:03:26 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:03:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/11] xfs_scrub: don't skip bulkstat batch when
 scrub_scan_user_files helper returns ESTALE
Message-ID: <20260625120325.GF18766@lst.de>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs> <178232484531.915780.36902609750018112.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178232484531.915780.36902609750018112.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 11:15:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex complains that the ESTALE in the switch statement results in the
> rest of the bulkstat batch being skipped, and that ECANCELED doesn't
> actually abort the walk immediately.  scrub_scan_user_files is only
> called during phases 5 and 6, which is after we've verified all the file
> metadata in the filesystem.  Therefore, an ESTALE here means that the
> file was deleted, so we skip it and move on to the next file.  Fix both
> issues.


Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

