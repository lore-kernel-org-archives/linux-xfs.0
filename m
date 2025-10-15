Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01A41D47B4
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 04:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760502764; cv=none; b=e6xMS5Y7OJunGaaerl6jClzkxTNrhp4cj2LzeNEyr7hs3Vgm7cyadQnZfmCdAkEsCzlVNFrLG/Pt4M5aicoBSwA+G7qMQkwcqB7uO7NkA+45yEc5b0CcrRLNry5ViUdVSt65F6LIaEKNu3etIlInyrvC300J+JJZKHFhwA/4G4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760502764; c=relaxed/simple;
	bh=LQo/3k4KoqrG3+fh47WWi7CReigYCi2IM7w5Y9TygF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxAGJnuQKNq7AldFXqOL5XciU4aUyGam2wC9qSSeIssbB6e5iF267qXk87yK4kXcnJ39y3OSfvDraLbXtwvJmMftx51V6v9sT+N7CLRKftrWgvmXDr5fjf/S/YOsZ6By54zJnAUpWDQ5LRR7qgVTq1026zteATMFejeebGuF7GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AB498227A87; Wed, 15 Oct 2025 06:32:38 +0200 (CEST)
Date: Wed, 15 Oct 2025 06:32:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: add a on-disk log header cycle array accessor
Message-ID: <20251015043238.GA7253@lst.de>
References: <20251013024228.4109032-1-hch@lst.de> <20251013024228.4109032-3-hch@lst.de> <20251014212717.GH6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014212717.GH6188@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 14, 2025 at 02:27:17PM -0700, Darrick J. Wong wrote:
> > @@ -1543,14 +1538,6 @@ xlog_pack_data(
> >  	if (xfs_has_logv2(log->l_mp)) {
> >  		xlog_in_core_2_t *xhdr = iclog->ic_data;
> >  
> > -		for ( ; i < BTOBB(size); i++) {
> > -			j = i / XLOG_CYCLE_DATA_SIZE;
> > -			k = i % XLOG_CYCLE_DATA_SIZE;
> > -			xhdr[j].hic_xheader.xh_cycle_data[k] = *(__be32 *)dp;
> > -			*(__be32 *)dp = cycle_lsn;
> > -			dp += BBSIZE;
> > -		}
> 
> Just to orient myself -- this is the code that stamps (swazzled) LSN
> cycle numbers into the log headers, right?

Yes.

> > +static inline __be32 *xlog_cycle_data(struct xlog_rec_header *rhead, unsigned i)
> > +{
> > +	if (i >= XLOG_CYCLE_DATA_SIZE) {
> 
> Does this need a xfs_has_logv2() check?  The old callsites all seem to
> have them.
> 
> What should happen if i >= XLOG_CYCLE_DATA_SIZE && !logv2 ?  Should
> this helper return NULL so that callers can return EFSCORRUPTED or
> something like that?

It can't happen.  It is bound by l_iclog_hsize or h_len, which
can't go into the subsequent blocks for v1 logs.  For the recovery
case we also check for h_len being smaller than h_size, and h_size
is fixed to XLOG_BIG_RECORD_BSIZE for v1 logs.

