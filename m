Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85536349CFF;
	Thu,  3 Sep 2026 05:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788413723; cv=none; b=RME5x3IXyVAy+9Y8jkV549lHMSMNg+uuDM4zxfKFyJc+clTVwgVgt/Wwp8eaIdmg9ofKrQcOjb/0APiTfx1Kg5HXaK0grQ9dXnVmhzGKZcsmaS/EPitnPq/jPeYmuyX22oRcWBYznVRehr9SaQhvnTft7mVffweHKj0rohsM9z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788413723; c=relaxed/simple;
	bh=TWshLR8Y3K5xvHq9EH55z9FfuhoFHft7M5nED2E0B90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wh0y5FANHTBSynfsiVDk9yAi1hr4sTpaWe49grMFpQH+2v7HnGx12pi66/h+LqMj+nOxeK9CKj6kHyFpSgu1r5I9JhXncv5kaQDZXtni2WpeCrr5hogxmhh1xYs0e9NUeTgEotjEbRLrM0f/hXeUOlVoSCYbfoLTcB9uKEnC47k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 095D96732A; Thu,  3 Sep 2026 07:35:18 +0200 (CEST)
Date: Thu, 3 Sep 2026 07:35:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: compute dquot checksum after resetting dd_lsn
 in repair
Message-ID: <20260903053517.GC16469@lst.de>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs> <178832750773.3508131.8667220003399042973.stgit@frogsfrogsfrogs> <20260902072341.GC26173@lst.de> <20260902153703.GN1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902153703.GN1933798@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 02, 2026 at 08:37:03AM -0700, Darrick J. Wong wrote:
> On Wed, Sep 02, 2026 at 09:23:41AM +0200, Christoph Hellwig wrote:
> > On Tue, Sep 01, 2026 at 10:49:16PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > LOLLM complains that xrep_quota_block updates dd_lsn after calculating
> > > the crc of the ondisk dquot.  That's clearly broken, so fix that.
> > 
> > Yeah:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Also why do we set the lsn to 0, shouldn't that contain a valid value
> > (probably the current LSN, but I'd have to look deeper at what this
> > does in detail)
> 
> Hmm.  When I wrote this dquot repair code I was mirroring what
> xfs_qm_init_dquot_blk does (memsets the new dquot buffer to zeroes,
> doesn't explicitly touch dd_lsn).
> 
> It probably ought to be set to the current LSN but we don't really have
> a dquot log item for determining that, and assigning 0 here means that
> any subsequent logged dquot item will always be recovered into the
> ondisk dquot that xrep_quota_block writes.

Can we capture this for the future in comments somewhere?

