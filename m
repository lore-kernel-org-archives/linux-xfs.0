Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B070B8C1F
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 06:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774246135; cv=none; b=hjFcGT7RHgDN2f3xskBxc2BdwuUr++61TeEtpS6VoKuNMTg2b/n4CN+gudxykGI4MmnhEDI9J5XtX93ruLh+4R+rjKrskbupOUPZeVflCuJlcDDfPH/A9E3ySIg2PPZ/PAv8vyN1fOFaau1zioURuWwgc+eiLdRGPUSvM9fAmrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774246135; c=relaxed/simple;
	bh=t1SLyPCAsiLh8ilhHx7lVz07xjZyYGplkFPUFIZOvrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=opoodd+cRiAXgzZdoKNGgHB0ik2F8ZH53WPKR3iMFHdQN9PJeaX0Yn9RZgz73nP6J4z9Yoct3P0+q/2A49lPhhz3w6emjkYSRB+uDjBaRPiuq0M/up1hHGoxJ1RhQSn6/0JAoBVQ+PUw9RvdkL86gnyi1kI8zs7+JOsHwIJ4A9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W/uXx9dD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W/uXx9dD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IeDz6qIVWdcKhj6GFDvwFJyodoC0fmL+b03pqymBmN8=; b=W/uXx9dDoT+twHPVuEM/GbLIx+
	cgawqssSt2Se4L/PI38arvhROU+Jj2qKOy5wxC5TLkwnJepDmnLxfg6tLoPcZBXiwqtiilHN7a+c+
	o0faCXcEreBXF9eiMF2+ThB+cAee9rzXgWlke/w+SXcZwGXS/CnRTX6bu8WElpo4zSqA+O4rdQdZh
	r9A1iS+OMRElpLvo41BUYhtkbnKmgxnSdMtFc6NRRjwaxFVBuFh520AAdPbdMUPCCacMXFX6cTWNN
	BkmUWvHjWkm6FBvS8o30kS9Z1CXU9qhA1IQOAnTmrV/C3ZsNEacgyLO2PkFvlZ6QMBoAj9b2Sk/a6
	ni4NgBTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4YT7-0000000G6Yq-1NGN;
	Mon, 23 Mar 2026 06:08:53 +0000
Date: Sun, 22 Mar 2026 23:08:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/22] xfs_scrub: allow overrides of the media
 verification IO limits
Message-ID: <acDY9Vu8BIyTbUtC@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507344.3681140.4424251568194204096.stgit@frogsfrogsfrogs>
 <abz0jpxjiVBe0hEQ@infradead.org>
 <20260320154453.GC6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320154453.GC6223@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 08:44:53AM -0700, Darrick J. Wong wrote:
> > So you'll need to hack the systemd unit files?  How could we set this
> > on a per-file system basis?
> > 
> > Not really arguing against this, but we might end up needing more
> > flexbility in the end.
> 
> I'd do per-fs tweaks by defining an xfs_property and telling users to
> set it, e.g.
> 
> # xfs_property /home set scrub_verify_max_size=128M

Sounds reasonable.

> I don't think we need to define the property right now, that can wait
> until someone has time to do a more in depth analysis of what settings
> adjustments are needed for modern hardware.  I'm keener on figuring out
> something that'd work more automagically because sysadmins are lazy. :)

Agreed.  Another thing we might want is to record the scrub progress
somewhere so that we don't always start from the beginning when
interrupted.  Also not really needed now, I'd rather land the code
first.

