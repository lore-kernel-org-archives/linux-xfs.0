Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD8931F9B7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 05:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780378671; cv=none; b=dS9KJgYRn8ovjGS15+YGlA1N4odptwxvhMOSIkbjBFhIlm3Me+NoN7gtqKpTSYBcqYjJeRr6fXcl/baJexPAR6W2MnEYaoY7vWDnraPE/n/1nui0x1/o9Ig4Zgc3mrmN896XdhpAUZjX6e0pSe+rsL02yW9DFbEn/3WU+lZCEhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780378671; c=relaxed/simple;
	bh=63XslZP340hVszzOaQnHapJZOy2RpAa5mCZ088RK+C8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a820/SSOSvOZg5nZ7F4NIKKDOPKV99maZzO6foZhgvPSEFlACEOuk/dVITM2263w94tI2FtKlRW500qx1nwpveAJUTRJCgSZf53bASA7F+cJMkZyhucxH1aik12q1gHzKv3F5Xgt55FuED42hcd3jI7h70GXdPM2o+QFUknS0vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DFD7168B05; Tue,  2 Jun 2026 07:37:47 +0200 (CEST)
Date: Tue, 2 Jun 2026 07:37:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: massage xfs_imap_to_bp into xfs_read_icluster
Message-ID: <20260602053746.GC32429@lst.de>
References: <20260601124410.3508980-1-hch@lst.de> <20260601124410.3508980-4-hch@lst.de> <20260602044707.GP6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602044707.GP6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 01, 2026 at 09:47:07PM -0700, Darrick J. Wong wrote:
> >  	struct xfs_mount	*mp,
> >  	struct xfs_trans	*tp,
> > -	struct xfs_imap		*imap,
> > +	xfs_daddr_t		bno,
> 
> Hmm.  Most of the code I've looked at in xfs uses "bno" for
> xfs_{fs,ag,rt,rg}block_t variables.
> 
> Though for xfs_daddr_t values it's less clear -- half seem to use bno,
> the rest just call it daddr.  Maybe this function should s/bno/daddr/ ?

Sounds reasonable, but as you noticed this is replaced by an agbno a
little later anyway.

