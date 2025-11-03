Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A4D2472BB
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 10:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762166605; cv=none; b=shydE5EwijWXjkqkLEsVpeMoGHRUL6Z/OCYY5803HiCZGenQPhIbgQPcT+UcHznqFiRGoTbCG/WZvMq2TtiGCT7rtS6PPIiy5DluPoNm+GH7hLDoDTDa1M1dMbqdP9rkEFflU6TuGxHMNtdhs1ZQ2UJziIHCGK4ouCBrZSAOC8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762166605; c=relaxed/simple;
	bh=nCpTjCEa3UF0kbPR1BL5y4WqNuoXNUkRRzHD9fDTwdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dr2htJeRTropKbfcQyJrHdtVBvQ94q3aB4slHbSDU+fBBQIsHsLrLhH2JrAPf/FlPLvPynRh9bRaQM9yR5FepRZ1LogZ/CxnM6D9L2kNvk1zGDAw2BPikgtGD/2kbhz+ZHq/SoPKBj2MqrkpuBvNCnIh72UO1mVh2GzFQzFfQ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8113B227A87; Mon,  3 Nov 2025 11:43:19 +0100 (CET)
Date: Mon, 3 Nov 2025 11:43:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: set lv_bytes in xlog_write_one_vec
Message-ID: <20251103104318.GA9158@lst.de>
References: <20251030144946.1372887-1-hch@lst.de> <20251030144946.1372887-3-hch@lst.de> <20251101000409.GR3356773@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251101000409.GR3356773@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 31, 2025 at 05:04:09PM -0700, Darrick J. Wong wrote:
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index ed83a0e3578e..382c55f4d8d2 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -858,14 +858,15 @@ xlog_write_one_vec(
> >  	struct xfs_log_vec	lv = {
> >  		.lv_niovecs	= 1,
> >  		.lv_iovecp	= reg,
> > +		.lv_bytes	= reg->i_len,
> 
> I'm surprised that nothing's noticed the zero lv_bytes, but I guess
> unmount and commit record writes have always wanted a full write anyway?
> 
> Question: if lv_bytes is no longer zero, can this fall into the
> xlog_write_partial branch?

The unmount format is smaller than an opheader, so we won't split it
because of that, but unless I'm misreading things it could fix a bug
where we'd not get a new iclog when needed for it otherwise?

The commit record is just an an opheader without any payload, so there
is no way to even split it in theory.

> 
