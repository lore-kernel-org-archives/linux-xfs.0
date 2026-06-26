Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6716C211A14
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 04:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782448521; cv=none; b=RY+dcnCRXmB/KTKtpag2hsgP7Ptokk0nLnAlQS7WIumnJ04q8b7FE4NEoiwrhczJjNuoQcX1n+h69dzE9p03llgCOahlTbzMRMX8ccUQzzCrLLJtbq1/gXi4Vow54IkS+HdjQXiBBSkdiCMBLJszPT+OaVlAxjQU66sWPZvu8ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782448521; c=relaxed/simple;
	bh=ZOH5BeKn8NxxgVMPWGlK58KVt1MhG2l9RMAdk61nvY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F26zqdLkvihH24YkFQWcGCCExoeqiCuPAPtIWjumN5r73Pmv7PZptHL7rGNi3nkYVSNENulgzir+RgljscZvYxzYFxRjcU0ziO8xZJgN505JNaueAVb8i0xB+dzC5rB5fiTA+ZLstB1Lkusw0kkWUWAEixciRuxkVH/DBzURvFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2740768B05; Fri, 26 Jun 2026 06:35:17 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:35:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/6] xfs: also mark the buffer stale on verifier
 failure in xfs_buf_submit
Message-ID: <20260626043516.GD8078@lst.de>
References: <20260625135849.2494779-1-hch@lst.de> <20260625135849.2494779-3-hch@lst.de> <20260625180002.GG6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625180002.GG6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 11:00:02AM -0700, Darrick J. Wong wrote:
> > -	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log))
> > +	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log)) {
> > +		xfs_buf_ioerror(bp, -EIO);
> >  		goto ioerror;
> 
> IDGI.  If the filesystem was already shut down, we set EIO on the
> buffer, stale it, and complete the ioend...
> 
> > +	}
> >  
> >  	if (bp->b_flags & XBF_WRITE)
> >  		xfs_buf_wait_unpin(bp);
> > @@ -1397,7 +1399,7 @@ xfs_buf_submit(
> >  
> >  	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
> >  		xfs_force_shutdown(bp->b_mount, SHUTDOWN_CORRUPT_INCORE);
> > -		goto end_io;
> > +		goto ioerror;
> 
> ...but if bp itself causes the shutdown, we now leave b_error at 0, but
> do the same stale-and-complete thing?  Shouldn't we set EIO on the
> buffer in both cases?

->verify_write is expected to set b_error when it fails (and yes,
the API in that area is awful).

