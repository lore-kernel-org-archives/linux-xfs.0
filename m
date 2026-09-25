Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F50B3D0932;
	Fri, 25 Sep 2026 06:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790316746; cv=none; b=ielnG0KhdOFWAfpgDT0GTa5VLLu131zEbItA4o6QElubVWm1U0+nDb2iEipO3yTUvfjqeTZYYDvBUT57obMDf3inNijF/qcf0nvuX/jBHO3kNV0HWDsPy6bqz5BMZ+JgViLYbHGxb0spT409LsiDZlSOyqf06k6sGxoT3UU7MXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790316746; c=relaxed/simple;
	bh=pICFkdss9A0V31SM5zCd3Gs1FGoHzO0P1lu7mqk5A0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UvGdzLaL36VaxvoIo0MNqPBiigDCO2Fek3bxpIDyg1UaBeaIcnr71S8058YyjWA5AlC5DCbQ0q31epgIw86ihUMlEuLh8jvQRe/kB3le3K8lf8n8RSLnuVuhoZF+CHtGuxdylwZrku3hpvaTLXBRSIdayALOR2hTeeM4pHn8CLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D9F3568BFE; Fri, 25 Sep 2026 08:12:20 +0200 (CEST)
Date: Fri, 25 Sep 2026 08:12:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/21] xfs: calculate the log reservation for logging
 data checksum buffers
Message-ID: <20260925061220.GA3637@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-11-hch@lst.de> <20260924223021.GK2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924223021.GK2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 24, 2026 at 03:30:21PM -0700, Darrick J. Wong wrote:
> > +	resp->tr_csum.tr_logres =
> > +		xfs_calc_csum_reservation(mp, XFS_RTCSUM_MAX_WRITE);
> > +	resp->tr_csum.tr_logcount = XFS_DEFAULT_LOG_COUNT;
> 
> Going back to a question I had in "xfs: prepare
> xfs_rtfile_initialize_blocks for larger than FSB blocks", should we be
> using tr_csum for the transaction to write out new checksum file block
> contents?

They actually are different reservations.  Preparing the file writes
one csumblock at a time, while the write path can write upto three
right now as it only has an absolute size limit, but no alignment
limit.

