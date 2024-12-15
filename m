Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6597B1FDD
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 05:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734240284; cv=none; b=UwA4/WZjbnYaZGtseZ1vgwZQMSdmGg8xwtChkRtNUmIN8JTopIn9yF3UJwpIC3248vWfgrCkkPgC17VC2bSdCQ5b+nSHlFM/vuSDfcKIoTh+3aw/sofZ3D3TYQWBJz64ksYXwzGiVqCDKGkCAvPUdbpHX2q2cXEjb+0vqvaESNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734240284; c=relaxed/simple;
	bh=r4miWoBJ51em3V1QWpN51AmiazPvCH16QZNgElPndts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GX8eenyHI3VssTVJRQssLzdZUG6/N0ScwEnz4FcGyJdT/W8J/Sq3xWS6mz6To3Bxa9JuEi58LLBq2y0/xH3loM7GiP483wtx7fiV/PerTJIFa5JbB7N6gmmtzgSwRyBM8hgl5Sv7xYHdy34Bu8rkjQdR4xtYTUxJqGRWplivn58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2E9F068C7B; Sun, 15 Dec 2024 06:24:37 +0100 (CET)
Date: Sun, 15 Dec 2024 06:24:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/43] xfs: parse and validate hardware zone information
Message-ID: <20241215052437.GC10051@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-24-hch@lst.de> <20241213173132.GM6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213173132.GM6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 09:31:32AM -0800, Darrick J. Wong wrote:
> > +	xfs_rgblock_t		*write_pointer)
> > +{
> > +	struct xfs_mount	*mp = rtg_mount(rtg);
> > +
> > +	if (rtg_rmap(rtg)->i_used_blocks > 0) {
> > +		xfs_warn(mp, "empty zone %u has non-zero used counter (0x%x).",
> > +			 rtg_rgno(rtg), rtg_rmap(rtg)->i_used_blocks);
> > +		return -EIO;
> 
> Why do some of these validation failures return EIO vs. EFSCORRUPTED?
> Is "EIO" used for "filesystem metadata out of sync with storage device"
> whereas "EFSCORRUPTED" is used for "filesystem metadata inconsistent
> with itself"?

If there was a rule I forgot about it :)  This should be changed to
return the same error everywhere, and that should probably be
EFSCORRUPTED, or maybe the whole code should be changed to return a
bool.

> Do the _validate_{empty,full} functions need to validate zone->wp is
> zero/rtg_extents, respectively?

zone->wp is not defined for them in the hardware specs, so the only
thing we'd validate is what the block layer / drivers put into it.

