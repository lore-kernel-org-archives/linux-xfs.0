Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E9B175A75;
	Thu,  9 Jul 2026 04:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783572464; cv=none; b=gGYEMFNxy7WhvYnqejonctjqAKmx/VUTYdo4ZEcDO1AlCquJb/TEA/1s8lPLP8W6czt8mqCdb41V1uzy41NoZ1fh3e9CbAHobIiw46ZuhuAQXx25kQkhz489YVMeG4FVIPwQJUqiDJQ/k6HzNzj9EC1DkZVxDujbtYKz07qIJYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783572464; c=relaxed/simple;
	bh=iehbMDj1kl3rIu5tuHr0V0pAjxjo0VZR2OIUuAFWrLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xt51Pe6iFoFnwOMhK7EkuAUHuqEgRl+0gOx8PSBsnUSvmLJCq6833O0Y7VW24MrtUcNw/m2hApG2hFasYPxHNPMlKjKzENMvcKvxytAnWMZV2A5Lypr3H3AAM3hdigsVQr5m0z5+JG5K8BLb8XVCZTbqo44ej4CthkiIQyJIswY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ACEE668BFE; Thu,  9 Jul 2026 06:47:38 +0200 (CEST)
Date: Thu, 9 Jul 2026 06:47:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: don't replace the wrong part of the cow fork
Message-ID: <20260709044738.GA15144@lst.de>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs> <178346726108.1271589.7681324440256265003.stgit@frogsfrogsfrogs> <20260708091220.GA5902@lst.de> <20260708152516.GG9392@frogsfrogsfrogs> <20260708175743.GI9392@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708175743.GI9392@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 08, 2026 at 10:57:43AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 08, 2026 at 08:25:16AM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 08, 2026 at 11:12:20AM +0200, Christoph Hellwig wrote:
> > > On Tue, Jul 07, 2026 at 10:03:24PM -0700, Darrick J. Wong wrote:
> > > >  static inline void
> > > >  xrep_cow_replace_mapping(
> > > > +	struct xfs_inode	*ip,
> > > > +	struct xfs_iext_cursor	*icur,
> > > > +	struct xfs_bmbt_irec	*got,
> > > > +	struct xfs_bmbt_irec	*rep)
> > > 
> > > This looks like something that should sit in xfs_bmap.c (or at
> > > least xfs_bmap_util.c) and not in random scrub code.
> 
> To push back on this: there's only one user of this, why not keep it
> local to the scrub code?  AFAICT there's nowhere else in xfs that needs
> to replace a subset of an existing cow fork mapping with another
> mapping.

Mostly so that all the code doing hairy operations on subsets of
bmbt_irecs is kept together...

