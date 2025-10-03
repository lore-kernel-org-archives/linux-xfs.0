Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083A61862
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 07:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759478339; cv=none; b=POB3phIJXPtP4ieJN85K7Bv4T7vuX4rWtaplytM8wXYLkwhyOWUkxVCNTqFHmYFByJwV+EZRvfzEWA+7irdQ31yd0n9s5n6rezvCQpGKd7AwMzcUyfp/RqM2Dbl3cms8VISVlX4PUGUyD2KUE0XEW0l0Qn1BconCs9TAYK0E3nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759478339; c=relaxed/simple;
	bh=yajsVhQT6JSNsD1hUv6m/HHqH432Nea+LRuRLajB56A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DXCZCCmrih5HnAtXuohXWZFwMmPlK7x+jrtuTFbikafdYegyutcq5I/OTFwvqqwyI/18HtNEyp5T9Sv9BwAr4VizYtfCGYQH5kcVS76YT3hIQPGqNq8D0E3kw8PoZMJVZKKZMe6nPH7dhJmeWFrI/dKeDFkx1AvzPbum2UpmAs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B7095227AB1; Fri,  3 Oct 2025 09:58:52 +0200 (CEST)
Date: Fri, 3 Oct 2025 09:58:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't use __GFP_NOFAIL in xfs_init_fs_context
Message-ID: <20251003075851.GC13238@lst.de>
References: <20250929064154.2239442-1-hch@lst.de> <20250929183437.GB8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929183437.GB8096@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 29, 2025 at 11:34:37AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 29, 2025 at 08:41:54AM +0200, Christoph Hellwig wrote:
> > xfs_init_fs_context is early in the mount process, and if we really
> > are out of memory there we'd better give up ASAP.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Is this the fix for that recent sysbot report?  If so, maybe you ought
> to link to the syzbot thread:
> Link: https://lore.kernel.org/linux-xfs/3d54a546-77dd-4913-bcd0-7472aec8f53c@suse.cz/T/#md6876fda5ae060700801623ee18fa59317c5cbc4

At least if my theory there was correct the bug is in the mm code and
it doesn't actually fix the bug, it just removes one way to trigger it.

> In any case the logic is sound and it's quite easy to bloat xfs_mount
> to be larger than 4k so the kzalloc is simply fallible:

If OTOH your theory here is correct, it does fix the bug.  Let me check
their .config to see which theory is correct.

