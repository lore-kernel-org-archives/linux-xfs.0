Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0CC3806BD;
	Wed,  8 Jul 2026 15:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783524318; cv=none; b=WbpRlh7KXVbzJZItvFNHG6hOTacCQXf7skcwZpZJuGCx5FJfGFt7fbl/v5SO9iUJ/5AjdszYVUmiGfzxmAqdzluo2R8+dbCnOFqRUf0YK66FeepGTD9+QxqNdDEKnXx2TByQUQn7ssx8riHaSLn31AvJ8ccimloJs5ecyJzWtuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783524318; c=relaxed/simple;
	bh=L87jY2l1prKZSPErfDYgeIAB7+PKLGOeH4j0f/2+wBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQ4703TgqAWGFcMKEPfq72nlnJB15Kc/hNraK7+pzw5bMygEeTqptlpPmGijnDnu/wDToTiNpaM01KAf8TBB4vApNaeENUHumm8F1taj3WLR2WW2yQJdSYrHPQq7PiOna1sHImJe0RI7MTmWJOIksMbuCt+v3lLo8w8h0odP22M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OxSmhqmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OxSmhqmm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 364FA1F000E9;
	Wed,  8 Jul 2026 15:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783524317;
	bh=5gGRL4ZLOSsaSjp3pYemlf97g5Viwl8WVY4EQX8Vulo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OxSmhqmm7IaQlngm2h0JCV8Ovw3/X/ZBrA4r5+LHr/uCPJPD4iax9PgDsi5L/fqpp
	 H/EJEXc/hXXcbmN/szku1BJAexEBl8VHnAVJc2BoSCdyhtTlB1yV/fie+rPzaapo3O
	 oZXF8UFTulzh/L53dnDCtE9uYln7dsL2DGFUEQFIx/bTKTRoD7jV54+jpwKw2uqsA2
	 id15yheicImvb2KljsrIOIiDfUEMsDDLPeNiNgrHSAnbknI9HfVqfqiL1g3SwcKuH/
	 cTbvpZIXXWr7AHaMTUZyQLsfUiTtYXAC9CeYc6ZrbrgZOUbuM8SVwpZFgzmLHxE/ap
	 j7CXGATz5xxFQ==
Date: Wed, 8 Jul 2026 08:25:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: don't replace the wrong part of the cow fork
Message-ID: <20260708152516.GG9392@frogsfrogsfrogs>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
 <178346726108.1271589.7681324440256265003.stgit@frogsfrogsfrogs>
 <20260708091220.GA5902@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708091220.GA5902@lst.de>

On Wed, Jul 08, 2026 at 11:12:20AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 07, 2026 at 10:03:24PM -0700, Darrick J. Wong wrote:
> >  static inline void
> >  xrep_cow_replace_mapping(
> > +	struct xfs_inode	*ip,
> > +	struct xfs_iext_cursor	*icur,
> > +	struct xfs_bmbt_irec	*got,
> > +	struct xfs_bmbt_irec	*rep)
> 
> This looks like something that should sit in xfs_bmap.c (or at
> least xfs_bmap_util.c) and not in random scrub code.
> 
> And I really wonder how we can get good test coverage for this, including
> for the original bug that this tries to address.

I'll post the debug patch I made that hijacks the errortag knob to make
it randomly shrink the range passed to mark_cow_range instead of the
entire iext record.

The original bug that this tries to address was a pile of bug fixes to
the xfs cow code that you posted for 5.1 that we neglected to backport
to 4.14, resulting in corruption of the cow fork mappings.

--D
