Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B06D3822A8
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 14:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776090966; cv=none; b=EetjYJqHSoCWt764w8JwskC+uTsQ2nZJioQTA17bs/yTqf2fj8td0N7kp8u3OFEbKXhUFcoWFXEIdOEMU5GKdGovCWUaYOsQ0y4jXFlVLNXVoIx5ZYutSShZ88yVMHaDVYYxdvFX5dBDRulM56s+oQysm6KmobLf2BS/RZAgHoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776090966; c=relaxed/simple;
	bh=nBsZ7vXXzFsES/pILTCoxqCY04QBYcNMEeOv76ipu7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWaNvU4yQMdTP8QRLrjUPfvWQIcGeu/obFHhuHxo5aF7IzlPSXHHkybsR43bxNlocf29lr21P08wpXnHeRvFBtg4EJn4s7OoMZco3dwmXsxSpC7Wj7775zE/NuF2H56XnOgE3CgmRmsnSQ2rQVR6COcwJ3btplesTp6l2inRACA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ku7LO0jY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ku7LO0jY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D2BC2BCAF;
	Mon, 13 Apr 2026 14:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776090965;
	bh=nBsZ7vXXzFsES/pILTCoxqCY04QBYcNMEeOv76ipu7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ku7LO0jYbbHYMASgSjArtTF+6LfkfsxYF9/1lDnN8iNkMDrKpCl6LUFljGlyBP1Ly
	 QrhMl9yI5Usf1hIDJDuU3sNbGrUjYEnfWnh0aM2Kla/8qz8KsejurLYwG2ycrdC8s+
	 zo5pAaEUz69t5XUU7Lr1GpGJCfzho927xtP728bT3TvWzKqjmTFYujbwY0kNDlfSQP
	 OTB2/YtK74whMNX4QkHzHS5JFiyY10R0qH5Izkc39LLuBeKSwF4P1ykZLl+72FGgfO
	 pf3O521pWzc8gcxNoXeWBIjKcqBQ/11rxsZkIShK5W1IzoRAi9Z98kHw2O4CNyZPzt
	 bggdFKxsI1z+A==
Date: Mon, 13 Apr 2026 07:36:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andreas Tille <tille@debian.org>,
	XFS Development Team <linux-xfs@vger.kernel.org>,
	Anibal Monsalve Salazar <anibal@debian.org>,
	Nathan Scott <nathans@debian.org>
Subject: Re: Please migrate xfsdump and xfsprogs Debian packaging to Salsa
Message-ID: <20260413143605.GH1048989@frogsfrogsfrogs>
References: <ads96yii8bij-UQQ@an3as.eu>
 <adzGdfbByADzoXWr@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adzGdfbByADzoXWr@nidhogg.toxiclabs.cc>

On Mon, Apr 13, 2026 at 12:37:20PM +0200, Carlos Maiolino wrote:
> Hi Andreas.
> 
> On Sun, Apr 12, 2026 at 08:38:35AM +0200, Andreas Tille wrote:
> > Hi XFS Development Team,
> > 
> > I'm currently reviewing team-maintained packages that are not exposing
> > Vcs fields.  I assume for some efficient team work you are maintaining
> > 
> >   xfsdump
> >   xfsprogs 
> > 
> > in some Git repository, but the Vcs fields are not set and I could not
> > find corresponding repositories on Salsa.  I'm not even sure whether you
> > might have some team space there or whether the Debian team might
> > sufficiently fulfill your needs.
> > 
> > I'd be happy if these packages could be maintained in a publicly visible
> > Git repository on Salsa, with appropriate Vcs fields set.
> > 
> > If there are specific reasons why this is currently not the case, I
> > would be interested to understand them as well.
> > 
> > If you need any help with creating some Git repository I can happily
> > do so since I have developed some training in doing this.
> > 
> > Thanks for your work on XFS in Debian, and best regards,
> >    Andreas.
> 
> I'm not sure what Salsa is, nor what Vcs fields are, I'm assuming this
> is a Debian specific thing and I'm not that familiar with Debian
> ecosystem...
> 
> I'm assuming this is something debian-specific? Perhaps Nathan can chime
> in here, because this does not think something related to xfsprogs
> upstream development?!
> 
> I'm not the xfsprogs maintainer though, but this doesn't seem to be
> concerning with xfsprogs upstream development.

It is, in the sense that (at least at one time) the debian/ files in the
upstream master branch were used to generate the debian packages.
Nowadays there's a slight divergence every now and then for Debian to
integrate patch backports to old release.

--D
