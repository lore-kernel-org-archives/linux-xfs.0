Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F60031A051
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 05:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765861817; cv=none; b=ufleLg/znQQHGJj0YCCJQUGPQWVsPRE2ZL4WZcPMxRDvq1/cH+pCMop7Vg9xX6Nhfm0R9xhIPMfym8Yk2UKHD2NO9WwcgQxwiHeUM7DR2mNdxtYonOPn2Rla0YZ67eFf1hbR+yhL6S/1VK5G6n7yM0UfO1ullaO1QXDxk+cKpyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765861817; c=relaxed/simple;
	bh=q7zVisZUp5as9bfAAlcnDMOHvhgpSCXfWxhrJQw1iVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlF+2Ytxu+S48x1icgK9GFwwOsbhnpkqu4ZYGbhnRH556q+amDDvibsELKDxjpu/xISwNCLYF2GFdNumTKyf5jdLgAH5hCiI4ZQeGnsBcpMPLFCEPHILAE3eCDw0tzIyqHSVfHxOpFf2zSAHIwVGXNJS2ouShw2bro/jA4dYGVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A7483227A87; Tue, 16 Dec 2025 06:10:03 +0100 (CET)
Date: Tue, 16 Dec 2025 06:10:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: validate that zoned RT devices are zone
 aligned
Message-ID: <20251216051002.GA26237@lst.de>
References: <20251215094843.537721-1-hch@lst.de> <20251215094843.537721-2-hch@lst.de> <20251215191506.GI7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215191506.GI7725@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 15, 2025 at 11:15:06AM -0800, Darrick J. Wong wrote:
> > +	if (xfs_sb_is_v5(sbp) &&
> > +	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
> > +		uint32_t		mod;
> > +
> > +		/*
> > +		 * Zoned RT devices must be aligned to the rtgroup size, because
> > +		 * garbage collection can't deal with rump RT groups.
> 
> I've decided that I'm ok with imposing this new restriction after the
> fact, but only because actual zoned hardware will never expose a runt
> group, so the only way you could end up with one now is if you formatted
> with zoned=1 without a hardware-zoned storage device.
> 
> Could this comment be expanded to say that explicitly?

That comment would not actually be true.  The hardware specs do allow
for runt zones.  No shipping hardware that I know of does that, and
mkfs protects against it, but the statement would be at best misleading
if not outright wrong.  The real reason why this is fine is because
mkfs rounds the capacity down to the zone size.
