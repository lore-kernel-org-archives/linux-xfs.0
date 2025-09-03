Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C942561AE
	for <linux-xfs@vger.kernel.org>; Wed,  3 Sep 2025 06:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756880866; cv=none; b=aiyyclWozQccQ/UZ61LG/pkLhmRJDDj6zSgvTVtJUVwS+rgMqT/zFHzmCZjQEjqIWxTnA2qb858TwbymAOUmd+Keu/mI5w7nLCGGfdpZnz3V9RdgtSVRswNogGHvZ9On2cNB3SJed68k0VGgEG0fQ1ptcj3N8AMjFJhXvFKC/60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756880866; c=relaxed/simple;
	bh=HMcbSTCmLbYEc4YPVDPAcKF5GH7LVi02UPKhIwiTpcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HoMd6bp0+mRRHImeXlMxfCYcpbOKctMPd0M2fD2Was9G6NmfcZJ8eHYWU0NMN5eWSmcjVObEd2wzX9+dQnVqvNkwkNsVqZTEeIneaHQjCqac4Y6uCLsqsqfj4c8cKQwpFpPnSBNcLloBh8K00wCxrkgRzhw6RWLsctJRj+Lh9pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ToXzl2Fp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ToXzl2Fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F32C4CEF1;
	Wed,  3 Sep 2025 06:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756880866;
	bh=HMcbSTCmLbYEc4YPVDPAcKF5GH7LVi02UPKhIwiTpcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ToXzl2Fp7zl0sCIdV+GD/UUvYKmusJIPUUFi7aPxKtVwEdRVgglAChwhPW+ix0Odt
	 bMaK5J/DxNMvZ4UT2H2lWxWPLk9oC0UvE8EeqTw/VpK/Ub/X0bzSnqyIJ2tl5fNRMQ
	 bBByomWIJDVjGF+KZicnxu95Y1N188KBlllf6zjQhTLr6f5bRedtvcZoD1eJsMa7fb
	 zDwOaVmT7JnkADKH0QAtRb2/L+hI5w9rxtZR93cd8FMD/TQgF8ptqdFD2ncRqY5ApQ
	 4kbo85RpRfKEHUFoMueYh0q72wQ59JqRCnHaRc38uwhLuKkvusT+I/MV5w+j+qpJD2
	 sVczWKXEczEvw==
Date: Tue, 2 Sep 2025 23:27:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: remove static reap limits
Message-ID: <20250903062745.GJ8117@frogsfrogsfrogs>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
 <175639126605.761138.1788578695179861070.stgit@frogsfrogsfrogs>
 <20250902062829.GG12229@lst.de>
 <20250902223203.GJ8096@frogsfrogsfrogs>
 <20250903060311.GB10069@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903060311.GB10069@lst.de>

On Wed, Sep 03, 2025 at 08:03:11AM +0200, Christoph Hellwig wrote:
> On Tue, Sep 02, 2025 at 03:32:03PM -0700, Darrick J. Wong wrote:
> > It's only needed in newbt.c.  What if I change the commit message to:
> > 
> > "xfs: remove static reap limits from repair.h
> > 
> > "Delete XREAP_MAX_BINVAL and XREAP_MAX_DEFER_CHAIN because the reap code
> > now calculates those limits dynamically, so they're no longer needed.
> > 
> > "Move the third limit (XREP_MAX_ITRUNCATE_EFIS) to the one file that
> > uses it.  Note that the btree rebuilding code should reserve exactly the
> > number of blocks needed to rebuild a btree, so it is rare that the newbt
> > code will need to add any EFIs to the commit transaction.  That's why
> > that static limit remains."
> > 
> > Would that make it clearer?
> 
> Yes. With that:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Cool, thank you!

--D
