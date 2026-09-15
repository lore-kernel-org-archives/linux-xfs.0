Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BB3217723;
	Tue, 15 Sep 2026 06:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454367; cv=none; b=pAGw04bfAq1E84fcd9Tf51w5pq73a5eUKQASTDjlj0j7MgD3IMghdfI52GFedwWQ4geJXl0mNNwgcHiQh4mWWvxt1NfRq3o6iFj2m8bCkENJbIoehGVO/R8B2VNWJ1hGnX3uOgTfcjcOc/vx9LNz2RG6oOAkw3UP+7D5vhD6+sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454367; c=relaxed/simple;
	bh=ymuOc6ZkV3PbxOLugLkkCRimy3zoBZq7/eJaiFb5vdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vz2Y4IUlgjNwvo/nD2WbskU71GrSI8+squD3bTmrz2n7Of7m/41IWcZUla/pNlemUf6M3jAMYQIpOd+wcwFNTAyMohbWiaJAyaaw+Eke2H224QYmcSVeDNnGxcm8gNDxPIxllb5QqiTgjphyYs6BBLmPQVA9+4kcGnyRCjuPtjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0ADE268C4E; Tue, 15 Sep 2026 08:39:23 +0200 (CEST)
Date: Tue, 15 Sep 2026 08:39:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: check di_forkoff correctly in scrub
Message-ID: <20260915063922.GB13345@lst.de>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs> <178910162147.174887.15828411239184280666.stgit@frogsfrogsfrogs> <20260911150745.GA26822@lst.de> <20260911155919.GG6265@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911155919.GG6265@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 11, 2026 at 08:59:19AM -0700, Darrick J. Wong wrote:
> On Fri, Sep 11, 2026 at 05:07:45PM +0200, Christoph Hellwig wrote:
> > On Thu, Sep 10, 2026 at 10:54:58PM -0700, Darrick J. Wong wrote:
> > > The di_forkoff check in xchk_dinode is incorrect, according to LOLLM.
> > > XFS_DFORK_BOFF returns a byte count relative to the start of the literal
> > > area, not the start of the inode.  Therefore, this check won't flag
> > > di_forkoff values that are larger than the literal area but not the
> > > inode size itself.  Fix this check; sadly the old APTR code was correct.
> > 
> > The fi looks good, but I really which we could encapsulate this
> > magic >> 3 a bit better (here and elsewhere).
> 
> I /did/ think about adding a cleanup to do:
> 
> #define XFS_B_TO_FORKOFF(b)	((b) >> 3)
> #define XFS_FORKOFF_TO_B(f)	((f) << 3)
> 
> and then code like this:

That would be nice.  Especially with a comment explaining the odd
encoding a bit more.

