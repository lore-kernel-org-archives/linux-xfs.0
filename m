Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA66D531
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 05:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766122090; cv=none; b=I0j4eKEdTGcDMnFP/ERG6RBDhBf1MgvHbxxWzIBo2P7gWzcIkAH6+v+gUTdbiHfunxnUp3VS/7ofjV14DKIqHdoiWLTSuW7NgVrjOwhEoCAlAcqGnJAVld2q4mIy4/EWioNqujRedFgx4iZyndqBljnby7BPlQhwNNvVCbZpRRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766122090; c=relaxed/simple;
	bh=uTOe68RdJUC0cEwQDDHQPLA1EaYw4dEe+yhJsHAaumc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJNZDXAYp3Bbpdmg4MsZaMUkLKPtlQO4aA8XucIFGPRXhOp1wnHGxxWIrZBNk3AFufHRK1KcGWuVwMy1U/UjaZbPIQIPYKhHx6PMqcFFoegYo98Nc3x6E5rD+h1GOaktzxtRr8LEKqoRPkoPvyCZ3NHDn96rH5S3m425Fay9eYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0967F227A88; Fri, 19 Dec 2025 06:28:04 +0100 (CET)
Date: Fri, 19 Dec 2025 06:28:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <20251219052803.GA29788@lst.de>
References: <20251215060654.478876-1-hch@lst.de> <aUGrpyS6BG0CD-kn@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUGrpyS6BG0CD-kn@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 16, 2025 at 01:57:43PM -0500, Brian Foster wrote:
> > +	if (xfs_is_zoned_inode(ip)) {
> > +		if (ac->reserved_blocks > XFS_ZONED_ZERO_EDGE_SPACE_RES) {
> > +			ASSERT(IS_ENABLED(CONFIG_XFS_DEBUG));
> 
> JFYI the reason I suggested a config check was as a safeguard against
> forced zeroing on production kernels. The assert here would compile out
> in that case, so won't necessarily provide that benefit (unless you
> wanted to use ASSERT_ALWAYS() or WARN() or something..).
> 
> A warning on WARN && !DEBUG is still useful so I don't really care if
> you leave it as is or tweak it. I just wanted to point that out.

I really think that anyone who modidifies this area should run a debug
kernel to test.  And if they the usual automated runs will catch it.
Having allocation beahvior modified based on CONFIG_XFS_DEBUG, and only
for a case that isn't supposed to happen seems weird and in would cause
weird heisenbugs if it ever hit.

