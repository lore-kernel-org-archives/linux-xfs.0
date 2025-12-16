Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC80535FF68
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765900742; cv=none; b=hFUHSYGxJFdu3Hxyo2xcjL5fNCFnLSz205ydUGlA2iaTCcd1rq7MWOXy3glVRlvipBhAl1L5NKSRjFnCc/uzf3puTt9hDW/BkzfvB8k1fe6H/CaW/lJP+ImEQgEv2eWkmyRJcba/anLc+OCUKLjXYrcoIftxASr09UTavKKK5us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765900742; c=relaxed/simple;
	bh=ZMi3spAiKyJlSM4q6JLNsf9baRJRTntfWd+OaPTKOsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NTQw3a6qWwC2ndi+IYtDqdx/VuldeDE2eHsI5aCn5ofpCW39lOXi1jQKZYGx1w4fsHF5jhYQGw/kOK6gW2JtTM2d1FuniRMhbbbIvW0k/+8tT6R4Uhx/zfUs/6uBz8FcjKXcouUfHnIoh9lzVN7YZ2yJRCY12A4uI2pKcOOI2P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYaAnyni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYaAnyni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4015CC113D0;
	Tue, 16 Dec 2025 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765900741;
	bh=ZMi3spAiKyJlSM4q6JLNsf9baRJRTntfWd+OaPTKOsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oYaAnyniaiqsMfMCPeBAxONcOlrCDBtCNYcCaBn/z69Fd+t8wwLVyvIsw+hZs+TBp
	 jrGl74nJeFFyREz28MurBk7y0DcyYphKqqNLofFJqVCufFC6sxIygngOPJfrLBxXNT
	 led1TXTnPUU0l6eIQLQeZ1LHzQtajRguJO8BaCF6+6vaUgGdEVm8zDYRn32nI+fTcE
	 v+bnTjcKBn70lCY7GVYtGhIItSzTQmNNJ18FwLzcJWkUbPCIFhQFqcn+FODNdn4cPG
	 PzmytwBO2DPr8jeozylNHc5Khg5kcrXwAUklhogmspCim1FNt9OE/tQmdBdXMyzhBJ
	 +ST5pxbhSb63g==
Date: Tue, 16 Dec 2025 07:59:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: validate that zoned RT devices are zone aligned
Message-ID: <20251216155900.GQ7725@frogsfrogsfrogs>
References: <20251215094843.537721-1-hch@lst.de>
 <20251215094843.537721-2-hch@lst.de>
 <20251215191506.GI7725@frogsfrogsfrogs>
 <20251216051002.GA26237@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216051002.GA26237@lst.de>

On Tue, Dec 16, 2025 at 06:10:02AM +0100, Christoph Hellwig wrote:
> On Mon, Dec 15, 2025 at 11:15:06AM -0800, Darrick J. Wong wrote:
> > > +	if (xfs_sb_is_v5(sbp) &&
> > > +	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
> > > +		uint32_t		mod;
> > > +
> > > +		/*
> > > +		 * Zoned RT devices must be aligned to the rtgroup size, because
> > > +		 * garbage collection can't deal with rump RT groups.
> > 
> > I've decided that I'm ok with imposing this new restriction after the
> > fact, but only because actual zoned hardware will never expose a runt
> > group, so the only way you could end up with one now is if you formatted
> > with zoned=1 without a hardware-zoned storage device.
> > 
> > Could this comment be expanded to say that explicitly?
> 
> That comment would not actually be true.  The hardware specs do allow
> for runt zones.

Bah.  That figures. :(

> No shipping hardware that I know of does that, and
> mkfs protects against it, but the statement would be at best misleading
> if not outright wrong.  The real reason why this is fine is because
> mkfs rounds the capacity down to the zone size.

"...garbage collection won't deal with rump RT groups because the size
increase isn't worth the corner case complexity.", then? :D

--D
