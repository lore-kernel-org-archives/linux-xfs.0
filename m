Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BA61CF7DB
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732033443; cv=none; b=RPI+6FdxrjLV+OwJiUhv7vSynjfD4dFHPLwk52cBXxPhrIR5ND2kVHrR7CGOKaXMq6FzVooZ5HsZukNh8SrQR/6D91GuQXJwDKrBeUcX+KMmFBCmTAYHHudg7bn48A1xlNLWktz+rsNID9lt7n7ZSA4K+FV9pg9/eM16zP/HLZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732033443; c=relaxed/simple;
	bh=Kt+CbGpGNP0LIAEF3oso3gmkmEVipIrnn3Cq8E+zuS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LnF/FTOYMsR1TQt0Gf4+SKHqOQM6yk8LMotlOK0BBeM6kdzDEbiXvrLt8YSMtxSj80UlaqKgAuP/M0gG38vnIzn0p69k8DfztOEe/JPya9gqnH77Ln1Lf0TS0MU8eS3TRbldgTem6d8ArhGhcxEP57iBUlzYiFXBfp5D73UcxOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0BB5068D8D; Tue, 19 Nov 2024 17:23:58 +0100 (CET)
Date: Tue, 19 Nov 2024 17:23:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: use the proper conversion helpers in
 xfs_rt_check_size
Message-ID: <20241119162357.GA15163@lst.de>
References: <20241119154959.1302744-1-hch@lst.de> <20241119154959.1302744-3-hch@lst.de> <20241119162142.GX9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119162142.GX9438@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 19, 2024 at 08:21:42AM -0800, Darrick J. Wong wrote:
> > -	xfs_daddr_t		daddr = XFS_FSB_TO_BB(mp, last_block);
> > +	xfs_daddr_t		daddr = xfs_rtb_to_daddr(mp, last_block);
> >  	struct xfs_buf		*bp;
> >  	int			error;
> >  
> > -	if (XFS_BB_TO_FSB(mp, daddr) != last_block) {
> > +	if (xfs_daddr_to_rtb(mp, daddr) != last_block) {
> 
> Er... this converts the daddr to a segmented xfs_rtblock_t type, but
> last_block is a non segmented xfs_rfsblock_t type.  You can't compare
> the two directly.  I think the code was correct without this patch.

Hmm.  Yeah, it just breaks the other things I'm about to overload
xfs_rtb_to_daddr/xfs_daddr_to_rtb with..  Time for even more
helpers probably..

