Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC24737A83B
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 06:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403800; cv=none; b=TeB3hEf6jBao6iLAJbEFQiD9uRxvuRnOJ2YPFoxaxWqjHSGiDYU27Wm4rmdlayC8hFKbC8s4SXTHUdk7EywWBTRZopknNF79FJr3CsTUvKFjILXjU0K1aTrgIChpuQCXNSlF53Z12uEJPfn9FDPF1DODUnOiWX41Z3bOP0E3xYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403800; c=relaxed/simple;
	bh=fTBfF+xiUAkz2et5oCOlB32KwhCPgXm7sL48kGgj8To=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uz+prwVtdBeRO5GYR9MYFQhs6xrmgTuyrGxxDoTwPSRQhhJNckpUq/79BoDdNV2wEgsY0T+rKBiM6wQAL6Wr9SRE2MLFBdf1TLoy/tvcxmqGm429sv2iW1RlXGZan9QtjwGG0fPKE8dXxYTv7vFaSqBcboRwiGBzBFSN/o0s5SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 453E268C7B; Sat, 26 Sep 2026 08:23:14 +0200 (CEST)
Date: Sat, 26 Sep 2026 08:23:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/32] repair: support RT data checksums
Message-ID: <20260926062313.GM20636@lst.de>
References: <20260924100512.2733748-1-hch@lst.de> <20260924100512.2733748-32-hch@lst.de> <20260925235435.GR2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925235435.GR2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 04:54:35PM -0700, Darrick J. Wong wrote:
> > +		}
> > +		ip = rtg->rtg_inodes[XFS_RTGI_CSUM];
> > +		error = -xfs_rtcsum_alloc_blocks(rtg);
> 
> Does this need the usual -libxfsification macros?

Probably.  Or I should go for another attempt to kill them everywhere...

> > +		xfs_csum_seed(mp, &csum);
> > +		xfs_csum_gen(mp, data_buf + XFS_FSB_TO_B(mp, i),
> > +				 mp->m_sb.sb_blocksize, &csum);
> > +		if (i == 0)
> > +			printf("calculated checksum 0x%x\n", csum.crc32c);
> 
> Debug code?

Yes.

> > +
> > +		nr_blocks = min(DATA_BLOCKS_PER_BUF, rtg_blocks(rtg) - rgbno);
> > +		error = read_data(mp->m_rtdev_targp,
> > +				xfs_gbno_to_daddr(rtg_group(rtg), rgbno),
> > +				XFS_FSB_TO_BB(mp, nr_blocks),
> > +				data_buf);
> > +		if (error) {
> > +			do_warn(
> > +_("Reading data at RG %u/%u failed, error %d"),
> > +				rtg_rgno(rtg), rgbno, error);
> > +			continue;
> 
> Er... so a read failure means we just leave broken checksums?

A zero-initialized one to be exact, yes.  I don't think there is
much more we can do here?

