Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB315F86E
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 20:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710878970; cv=none; b=M//lDMNJ1PTIyGZsZ/e4xeFNqkj+AQU2U+LfFwrOkxazQbIx2d7u6mzfzXk+iFbybWaxaTF9oUVXlP4w67NxqveX5M1T+1uyRRoth4tehtqBYnYCBIjZWKU5Zq6WE2DY0ysQxn1b/eUQXez5Ho4qbhsSV2qmKQ4YvI9Es0LYSvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710878970; c=relaxed/simple;
	bh=bXGu8BbtH7+8pIBBPF/e9fo/mlTXOB5vyTRmML1zBks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=urjIIIhoWFis5v6T1o2CvmZI9IQg+984eKlgfTCRto3BgC/Nsv+4ZPO+0r/gXZjaKboQkmjZZNvsrDk9z6IbdBF5sMpky88EY1ZdDAWx7G2FX6plFAmSEyM/BvxvvfftJvgYpBaGG3MWzOa4IeZFI+pn1ND9VKDXVcRdgzC09Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E843768B05; Tue, 19 Mar 2024 21:09:24 +0100 (CET)
Date: Tue, 19 Mar 2024 21:09:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandan.babu@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: compile out v4 support if disabled
Message-ID: <20240319200924.GB8959@lst.de>
References: <20240319071952.682266-1-hch@lst.de> <20240319175909.GY1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319175909.GY1927156@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 19, 2024 at 10:59:09AM -0700, Darrick J. Wong wrote:
> > +static inline bool xfs_has_crc(struct xfs_mount *mp)
> > +{
> > +	return IS_ENABLED(CONFIG_XFS_SUPPORT_V4) &&
> > +		(mp->m_features & XFS_FEAT_CRC);
> 
> Can you save even more text bytes by defining
> xfs_has_{nlink,v3inodes,projid32,lazysbcount,pquotino,attr2} to 1?
> And I guess defining noattr2 to 0?

I guess I can give it a try.

