Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pJprTJkK"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07B792
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 20:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5ykWLlh8jhHjFZfhiIZWkEVtLCSD4gKdWhrMeCeRGtw=; b=pJprTJkKHWsCyL4lGiTXjyMHzy
	M01AkaahrgfmrDzChCbSm5qapGOgCvWsr9NI9mZeGJeS3nxV3mUqKEL3qZjbrYiFv2gYViBDYcBCm
	nmU2XnmtdCz+usBKgEdFi63zN9Lyr1lGhagiNJwweIqzFaMHt4qvslnWxXSIWdZ/5kpkJvLl65zwl
	odm2nmsN2lj6gDRbQ10J/1N3TlBenCE2meOz/8v1p3x6qCZQfq1XtYaj3NNr1+mb6t36nlZVDlwbu
	FdsJHjOPPWnIu3xYqPywNAOo1IEumZpX19to3I4D4TqgPwgSnwg8pjWCb3Af6IdBHqJrYXOnI/x9A
	oaxwZyKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rA0nE-002zx7-24;
	Mon, 04 Dec 2023 04:42:52 +0000
Date: Sun, 3 Dec 2023 20:42:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: reintroduce reaping of file metadata blocks to
 xrep_reap_extents
Message-ID: <ZW1YzFZcQCtDub73@infradead.org>
References: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
 <170086927926.2771366.6168941084200917015.stgit@frogsfrogsfrogs>
 <ZWgVPxNT80LFzvx+@infradead.org>
 <20231130214824.GQ361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130214824.GQ361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 30, 2023 at 01:48:24PM -0800, Darrick J. Wong wrote:
> > Can you expand a bit on why it was buggy, in what commit is was dropped
> > and what we're doing better this time around?
> 
> Oh!  We merged that one!  Let me change the commit message:
> 
> "Back in commit a55e07308831b ("xfs: only allow reaping of per-AG
> blocks in xrep_reap_extents"), we removed from the reaping code the
> ability to handle bmbt blocks.  At the time, the reaping code only
> walked single blocks, didn't correctly detect crosslinked blocks, and
> the special casing made the function hard to understand.  It was easier
> to remove unneeded functionality prior to fixing all the bugs.
> 
> "Now that we've fixed the problems, we want again the ability to reap
> file metadata blocks.  Reintroduce the per-file reaping functionality
> atop the current implementation.  We require that sc->sa is
> uninitialized, so that we can use it to hold all the per-AG context for
> a given extent."

That looks much better, thanks!
