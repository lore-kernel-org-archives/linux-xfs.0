Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD64A3C1D5F;
	Thu,  3 Sep 2026 06:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415813; cv=none; b=dvjhbQ8BRcEwDxYsUopudKJkr3r0/CkaACCptzypR54d8RNgYKHJJ/zLs4q/8FWza68wzbBPonMa2JCNn8NE2Cyivjrk1XgMnXtdr854mkleCv+QYUiBHsTFgoV+IKO9optqMZLytQnyBoajwlz8fZqvunCjzwGiwynckIimbXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415813; c=relaxed/simple;
	bh=SzpDaaWkLEa29YKQwy5leUfa+GjQWsIvvKHozEb09Rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sd5mDrazfnz3Wkbc4jJGChEhjOqBQYwJKT0dXuamZME1kWPntO2Fe0BQ9kkosvsDqHSttx54YHcxq35+UqMS/K60R2vIcaX4uOmQvz+RFY/35XRq6sXcVfYCjj0IlJzu2Opbiu/MFELD2xf2/hMjMllNorTO/pwIff3BQ6MRmCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EEEB36732A; Thu,  3 Sep 2026 08:10:07 +0200 (CEST)
Date: Thu, 3 Sep 2026 08:10:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fix rtrefcount btree block counting in scrub
Message-ID: <20260903061007.GD17233@lst.de>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs> <178840969914.484660.12780329653421744867.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178840969914.484660.12780329653421744867.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 02, 2026 at 10:51:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM started on a long tangent about how xchk_refcount_xref_rmap
> shouldn't nope out if sc->sa.rmap_cur isn't set, because nothing ever
> sets that field.  It's right about the condition, but misses the bigger
> problem,

I see a pattern there :)

> which is that to count the rtrefcount btree blocks, we have to
> walk all rmap records in each AG in the data section.  That was papered
> over by the incorrect !sc->sa.rmap_cur test.
> 
> In other words, we need a perag iteration loop here.  Restructure the
> code to do that, and now it'll all work properly.  Fix the confusing
> function name prefix.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

