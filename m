Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BDD26CE2C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 05:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769577176; cv=none; b=om6YGQPq55rOt29JVZDCmUZQWyFY6q3SNe3HG5m5a/Bqd1ojnSrpL8k77KAeL8SkXHoVENsKA4hXeG6KiAmq52OKfuDXfCibjAqw2V0ggYIHZ1TvPEs6BvRYleDm7uxeLNaEyBxPrGEXOhlG8QOu6Oza8uUnBKsrKLICx+gsyss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769577176; c=relaxed/simple;
	bh=PI8JLrEEnptTft7nvO1GL7PGC5xd0gUNfIbxcBd50mY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ADhR0Y1iDluz4DujXGIqLgnbvFmJ31XYIzrptmrN3s/i7HwtgG9OB07qEcbWr5q/Y0DzF6/7gItq0fmAMigMdoQ7eJMQa0E0ZN8RDk3DCqO4TGmozKOog5ybj+s6tRn1Ag4+5xi5ESNM4OGjk3lxUu8XfseULkVl7kZor5Pwo7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 14B63227A8E; Wed, 28 Jan 2026 06:12:52 +0100 (CET)
Date: Wed, 28 Jan 2026 06:12:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: allow setting errortags at mount time
Message-ID: <20260128051251.GA990@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-7-hch@lst.de> <20260128013730.GF5945@frogsfrogsfrogs> <20260128034557.GC30989@lst.de> <20260128050710.GN5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128050710.GN5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 09:07:10PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 28, 2026 at 04:45:57AM +0100, Christoph Hellwig wrote:
> > On Tue, Jan 27, 2026 at 05:37:30PM -0800, Darrick J. Wong wrote:
> > > > +  errortag=tagname
> > > > +	When specified, enables the error inject tag named "tagname" with the
> > > > +	default frequency.  Can be specified multiple times to enable multiple
> > > > +	errortags.  Specifying this option on remount will reset the error tag
> > > > +	to the default value if it was set to any other value before.
> > > 
> > > Any interest in allowing people to specify the value too?  Seeing as we
> > > allow that the sysfs version of the interface.
> > 
> > I don't need it for my uses yet, but it would be nice in general.
> > The reason I didn't do it is because it adds complex non-standard
> > parsing, and I'd have to find a way to separate the tag and the value
> > that is not "=", which is already taken by the mount option parsing.
> 
> Huh.  I could've sworn there was a way to do suboption parsing with the
> new mount api, but maybe I hallucinated that.

Or I'm too stupid to find it.  I think for now the current version
does, and if needed we can extend it.

