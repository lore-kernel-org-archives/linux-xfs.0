Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93763090C2
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 16:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616577; cv=none; b=S0cSUeECOgcVOdZT5gj0OK5mEDHCzfNrHGuVtIoW7Fq4Lx0DBqZ+wxVtxvPab+COkQrxnpqLvViO5Wf9Dbfs2Vt8vvkV5hSxk+O0icQX2amRmKAkEwrAIPzD+1Tg8FYrd4tfD/hE0A1oU68sZOf6s1skkK0ZiaU2bTWY6oE7+eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616577; c=relaxed/simple;
	bh=S6kFl2YnzRTcdGgK6BMKP1y68bKKsNZltT1vVYBuUXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDiIKpld8V0Svrp3LZ/tQsA6myzmco5UxzH+XcasBbe+H7PMIOGY4JSJN2p/61DdTd5R1Q2jT47tQy4EDidbFG0X/4oi7HLPnchjXD/0xZRejfMkMwCGfUhZzUJAjOui7bfa8bd22Cp+9YFiTGup6xG9s8h73rgoIMsA6csI+r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JgH32w3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JgH32w3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4988C4CEF1;
	Wed, 28 Jan 2026 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769616577;
	bh=S6kFl2YnzRTcdGgK6BMKP1y68bKKsNZltT1vVYBuUXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JgH32w3MP587IgdMOGue1c5sWt4NHB7UfDlJOG4O6Zlsh0hOm2nDxXDh9it/da3pu
	 Rf5iNeeMKq/FF4v6j7GmZp56yrA2uaxeSYVruAtTTehX7CjEZR44uFcah0hqO9oCcD
	 8aPGAJBEX9qpJcfd6XkXOr/HskovhA3l7XELqAXQTxkqXr6jQsCL9rbUvMogf2SY3J
	 0R1szxtwhDHLWAxWlgjkhcTOEd/mAFOomb+yo0/jP2aQj/6miyqZsXXnwMH9CdfPq+
	 9F0dmIB1+VuiBsPalga9JiVTK97cX49EZqk0RdNbyGAly4MoWQCZbcatBGpot9ZW0W
	 PiDogt+NMF4ZA==
Date: Wed, 28 Jan 2026 08:09:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of
 line
Message-ID: <20260128160937.GS5945@frogsfrogsfrogs>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-5-hch@lst.de>
 <20260128013525.GD5945@frogsfrogsfrogs>
 <aXnv3tWiFlHwOheE@nidhogg.toxiclabs.cc>
 <20260128141016.GA2054@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128141016.GA2054@lst.de>

On Wed, Jan 28, 2026 at 03:10:16PM +0100, Christoph Hellwig wrote:
> On Wed, Jan 28, 2026 at 12:18:38PM +0100, Carlos Maiolino wrote:
> > I'm curious though if is there any reason why those are ratelimited?
> > It's not like users would be running with error injection enabled or,
> > they would be flooding the message ring buffer with it.
> 
> Good question.  I'd rather not open that can of worms in this series,
> though.

Well... activating an error injector /can/ trigger a lot of activations,
and it's annoying to try to sift through pages and pages of the same
message whilst trying to figure out why an fstest broke.  So I'd leave
the ratelimiting in.

--D
