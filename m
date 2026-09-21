Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ABB4F68CB
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 18:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790014631; cv=none; b=QqWwQe8oTeXWtq9k5QS8+iXV1L5kQyQi7jHPhaBhjyVbA+QWH9hl6J4QwqWXxjL1bNOQgljJv06vgREQmugA5xAf+8kL5k+R4ZAhz9kJT6dxgNnsJtH5Nhkj2cfhKzkVPsnPSrm7ftFnSGf64hDFtPWajz4KgRu0sCxGa7v3ifo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790014631; c=relaxed/simple;
	bh=ZxBsY85y3H19nc4tR/fB3LmojMu6hZq1I1Ra/DDhl78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FMTwwKjF6txskMsw1/oEEz5Pwo/OyX8HX2bF8niO44A0xHyOmIELvj9wbpdPhR2uwhe/Qv4VH+Xg+sxmxF+CQ7Ydho/BvhTc68f3fzlgjVpUfu+wkPjMF/x5b23pRA3oacHuRAd/cZw/CY8qVgbshxTSzkELbXA71q2R9qoop+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efzI8LrM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efzI8LrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0990B1F000FF;
	Mon, 21 Sep 2026 18:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790014627;
	bh=WTBUFY4rlLUpCchPHTsDgqflvQP6elt6MNVSMM11gag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=efzI8LrMKddYaYn+3RnzY80o+784u2u3SDzQQM+Eo8YlGzhhynRyZew8TSVELDd5+
	 7ZPdiowtmRgNE2aPJUvtl3jdVp4HNMhzpsU10AaulJcu0YnVrpiWlw/iJwo78xKJ+t
	 xbt84Esmgo1IjNfzDbvLdUdrOdQY+dHMh58oLVJI3kg+FGXk4yf/GR11WhorjSEl65
	 j/V0vXCewit3M6YJsdikP+8mJj4wVwHq9kGMUaWcFQ8YgXJJgPL3I2pAu+uHNzO7uw
	 FmnFTv5fI2QxLvH+Ik+KRkqJ/6WPf9tc7RAGn7ZYcdXQGcYo2Q0G+ShCjRuCltJgOn
	 skgBwsy/CyOrw==
Date: Mon, 21 Sep 2026 20:17:02 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] xfs: dedupe realtime rmap btree code
Message-ID: <arF0f9HTnMfcBo2M@cronus.toxiclabs.cc>
References: <20260918181324.2472127-1-sandeen@redhat.com>
 <20260921034003.GG2705364@frogsfrogsfrogs>
 <arDprUJAb7QP1EVx@infradead.org>
 <9d77197e-4d5e-49f3-a7cf-fdaf33c285cf@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d77197e-4d5e-49f3-a7cf-fdaf33c285cf@sandeen.net>

On Mon, Sep 21, 2026 at 12:56:58PM -0500, Eric Sandeen wrote:
> On 9/21/26 3:24 AM, Christoph Hellwig wrote:
> > On Sun, Sep 20, 2026 at 08:40:03PM -0700, Darrick J. Wong wrote:
> >> In general this looks good to me, though I'll add that the same sort of
> >> code deduplication could likely be done to the refcount btree code too.
> > 
> > I thought the same while reading over the patches.  Also the exported
> > in patch 1 threw me off, but it didn't actually export anything.
> > 
> > I'd be tempted to just merge the two patches as that's easier to follow,
> > but otherwise this looks good to me:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> Oh, ok - I can merge them if folks prefer. (I kinda thought a prep patch
> / use patch was simpler to follow but I really don't care either way.)
> 
> And yeah, you're both right about the refcount code, I should have thought
> of that. It's much shorter functions and my duplicate code scan was looking
> for bigger chunks, but I didn't fully engage my brain.
> 
> Happy to send V2 with both, and merge each into a single patch if that's
> what people want.

This sounds like a good plan for me :)

For the code in these patches though:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> -Eric
> 
