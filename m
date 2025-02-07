Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD685232386
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902364; cv=none; b=ez524FNSmOa0wQw554x0LbrTMiKM+c3GFa/rMdcGzZcCmkPzPYDlbYDnmXJqPll/O4PdJEDP/z8KitOJiSJy2x28ryldQA9zkcbnpOJDbc867dTVcXgf+wtRcl+fxv9ew9GM1IAKKvGOPSLzLb9snbOYG0JIx9Lxw9mQyKiyVRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902364; c=relaxed/simple;
	bh=tcNW/PYx9Gy1g13eLzaJyqYcpDSzNEvbCyk4oXJgNNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oZUQUYUg7iwMqpRyRaajeuLYefmHGHs6Xzx3fLg9FZIaQnpJM287cav5if4s93xJ0J2Q+jAmg4FA3rHP6KSnUZTHCOQrsGt0cjdR795MRMJrnigYJz+qJssivYS05DYyK2105ROejzWItDMM6MnGji9LLspXGLblus6xdYrwVDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TrBSUZ4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TrBSUZ4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34282C4CED1;
	Fri,  7 Feb 2025 04:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738902364;
	bh=tcNW/PYx9Gy1g13eLzaJyqYcpDSzNEvbCyk4oXJgNNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TrBSUZ4BSZ9+gSlh6ekYLw8rgrR6Oeq9dCky2TnkN+/3X14p8ksf65/iX+KbvkYaS
	 59ZOteKkt6IYQYImMGdg9JD8xCFKCkSQ9FFIZgWgDAzJnN/UyByOmVWQR5goNjaasa
	 GFgQfy4F+sSQ0YDbkwSdW2+EeKIBMyMU+GVzxhPFDKGFN16u4I3Bf7/k6aEpgWh/Ij
	 VYuJGRgb6nakNQxyPq7sqFofEjH5fcy+oN1pTJJPsI3NV9mWQ7x908QWwQ8iBvbiOZ
	 vI688SptOBFTCBoQG/NQ9hlkIGA5UKQV8wfmud73/PKHNEB9JeSQr9slbWRR2uMMUQ
	 V17nBdeUdzQdA==
Date: Thu, 6 Feb 2025 20:26:03 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/43] xfs: reduce metafile reservations
Message-ID: <20250207042603.GI21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-12-hch@lst.de>
 <20250206205249.GM21808@frogsfrogsfrogs>
 <20250207041931.GC5467@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207041931.GC5467@lst.de>

On Fri, Feb 07, 2025 at 05:19:31AM +0100, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 12:52:49PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 06, 2025 at 07:44:27AM +0100, Christoph Hellwig wrote:
> > > There is no point in reserving more space than actually available
> > > on the data device for the worst case scenario that is unlikely to
> > > happen.  Reserve at most 1/4th of the data device blocks, which is
> > > still a heuristic.
> > 
> > I wonder if this should be a bugfix for 6.14?  Since one could format a
> > filesystem with a 1T data volume and a 200T rt volume and immediately be
> > out of space on the data volume.
> 
> Yeah.  But for this to be safe I think we also need the previous patch
> to sitch to the global reservations.  Which at least in the current
> form sits on top of the freecounter refactoring..

<nod> Well at the moment we're safe against that scenario because mkfs
will blow up and not complete the format. :D

--D
