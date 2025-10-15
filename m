Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9103A8F7
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 05:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760504449; cv=none; b=c4t73O4AQ6niy6HHJE12+YWUZ4c+mA450xWrxX7R2J0u9c3JiFD0jHDwogrE1UykN5htEiEZwDn+XE+AAl5xrYAOSTVQihOI6FudWrrCnWwf42K9ZQSl0f96zyA/PVKGi+lJqmGRDE/4/vfkGl1AfuyNqGfBS3eNtF4/UKM+7Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760504449; c=relaxed/simple;
	bh=nqIe+frwXF3AtFx6+bADRJ/dQG1iTdWTzn44JxBBT0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+rcq7fhF1jkTVP0nc2qj7ahCL/qrAcyKkyC5ujJuc2KjABS31XBPxUR8jK0MFeEPP8xDS+zD1NpWLnufcJzvQANamioCoU1z6Mp+qcTlA7xs8Vgghmtm9VjOOZgVzkXjv7jg3acQjETJ6Gu0Wg2QFYF31Yn+ybsBJPvtY2O1+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AFB10227A87; Wed, 15 Oct 2025 07:00:43 +0200 (CEST)
Date: Wed, 15 Oct 2025 07:00:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/17] xfs: don't lock the dquot before return in
 xqcheck_commit_dquot
Message-ID: <20251015050043.GA8015@lst.de>
References: <20251013024851.4110053-1-hch@lst.de> <20251013024851.4110053-4-hch@lst.de> <20251014232244.GS6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014232244.GS6188@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 14, 2025 at 04:22:44PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 13, 2025 at 11:48:04AM +0900, Christoph Hellwig wrote:
> > While xfs_qm_dqput requires the dquot to be locked, the callers can use
> > the more common xfs_qm_dqrele helper that takes care of locking the dquot
> > instead.
> 
> But the start of xqcheck_commit_dquot does:
> 
> 	/* Unlock the dquot just long enough to allocate a transaction. */
> 	xfs_dqunlock(dq);
> 	error = xchk_trans_alloc(xqc->sc, 0);
> >>	xfs_dqlock(dq);
> 	if (error)
> 		return error;
> 
> So that'll cause a livelock in xfs_qm_dqrele in the loop body below if
> the transaction allocation fails.

I think livelock is the wrong term, it's just a leaked lock.  This gets
fixed towards the end of the series, and I'll fix it by reshuffling
the series so that this only happens later and at the same time as those
changes.  Same for the next patch.

