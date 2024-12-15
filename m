Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B5E11713
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 06:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734243235; cv=none; b=teEhjrIvrgAV2qfdlWu7BuEjaLtieTzC6ef+JsuDPQA0xJk5oFkk+PWbKKqBFb432uICxBpbLO9aOIrd0HDd4WWLokzHD71o+0NCZmHMUWcanivE2+DOz2Wd8HwOIpW6yN7SD04eJSB4YxGQikW+gadE/IsMJ1bvrrpSLRsjnTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734243235; c=relaxed/simple;
	bh=dpD3x4Di/amLwSc1FOIgQrF36CUphoozhHDGIgths2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h92ed0u5CHU5ZVc7XxUUjBAnUnTcCMpU4SPd8rUmVctXbf+v2jF2LdguERm2GBm6lf5NLhr3v2dOoy2VrE2WVzR6HTg+MHyVWmlmkalPeKeaM/KToFBW++4Y33NdR3mr7V48wroHN0YhVjmJuVRj4UAAeHRFeXKEScsiaxicoP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BBC5068C7B; Sun, 15 Dec 2024 07:13:49 +0100 (CET)
Date: Sun, 15 Dec 2024 07:13:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/43] xfs: support xchk_xref_is_used_rt_space on zoned
 file systems
Message-ID: <20241215061349.GB10855@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-34-hch@lst.de> <20241213224912.GW6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213224912.GW6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 02:49:12PM -0800, Darrick J. Wong wrote:
> > @@ -272,7 +273,6 @@ xchk_xref_is_used_rt_space(
> >  	xfs_extlen_t		len)
> >  {
> >  	struct xfs_rtgroup	*rtg = sc->sr.rtg;
> > -	struct xfs_inode	*rbmip = rtg_bitmap(rtg);


> >  	if (is_free)
> > -		xchk_ino_xref_set_corrupt(sc, rbmip->i_ino);
> > +		xchk_ino_xref_set_corrupt(sc, rtg_bitmap(rtg)->i_ino);
> 
> rbmip is already the return value from rtg_bitmap()

Yes, but it gets removed above.  Because it only has a single user,
and it keeps me from incorrectly referencing it in the zone branch,
which I did initially and which didn't end up well :)

