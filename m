Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70B638B12A;
	Thu,  8 Oct 2026 16:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791476270; cv=none; b=uWmbRDCT4J3GBSDPNxEZVtQS4354t74Usm1A3pI1+qp+n1rEWapZCEqewlUeI3QMiHqWyITXBeUhirRDvvVGgoxSJAnxATztexNhPIMAjK4sBN65ZFvHCA6gflrEmB7M6suD4nx22/HOvtTQDoFWEX1NeHw+AaYWlNkYoP1K11c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791476270; c=relaxed/simple;
	bh=EPIBoQhpTYhrMFg/y0UiMgc+AptK6Kkz2JFxWe9PGiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KZLF6rlOZwIOrJ0LTYcAOi6Z7ykY2W6zWhi4XAO3zaHyhAyoJ4r32OPATF5KclEDYxWLNXWR1i7T9tt1BfWxQofcWCgdfUMqQ8iFUowI0+OHgOwewJk/K1EJw5Hyw4JGbiQRKVK3Gc6VFhnRrtLb5XHPLonKVJe0/LShhsLjb1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2x/Xlhh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2x/Xlhh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 807871F000FF;
	Thu,  8 Oct 2026 16:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791476267;
	bh=KO67nrhviXgUSQTFZMnA6Z+1mSsykgUbuv+p2dnL4Sg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f2x/Xlhhv8FyOLymx1cVzKn8l7boQMC/aoJ7WGbhgIxcHWdBM2c0TbhJsRuXZ743K
	 1sZu+z9RRsuBiGjVwZ4fnZ6+3XpKzw2fnCgwL6Ii4K0rnyiIVplswNyU0IkqHmsZy5
	 aySfTyzLJm3ri4xZ9msKOX/1N8tLFdtlNwZg9njme+ZUb5CrBx89Uxei48KiI6FEKe
	 Ji3haPD82nLQpL3UwsQXFqUdKusr5QBZ2IidtlYwDVnq5rGB2TulCzf/eXiHPRH3sw
	 hG8MjHtXoewzLkF8IGEr4yvnQTLB+wQY9T/TNSwlouz6VI/t4XCuqW9BukKTkbuhef
	 HA+L3SdBqfDag==
Date: Thu, 8 Oct 2026 09:17:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: check for buffer overruns when examining
 local/remote xattr entries
Message-ID: <20261008161746.GS2705364@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521472.2728617.17391389777619283843.stgit@frogsfrogsfrogs>
 <aseGmj8np-ovaiuh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aseGmj8np-ovaiuh@infradead.org>

On Thu, Oct 08, 2026 at 05:03:38AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 07, 2026 at 10:57:26PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM noticed that the xattr scrub and repair code can walk off the end
> > of the buffer if the xattr entry record starts so close to the end of
> > the buffer that there's not even space for the entry structure itself.
> > Strengthen the bounds checking here.
> > 
> > Cc: <stable@vger.kernel.org> # v4.15
> > Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > Assisted-by: LOLLM # finding obvious bugs
> > ---
> >  fs/xfs/scrub/attr.c        |   12 ++++++++++++
> >  fs/xfs/scrub/attr_repair.c |   16 ++++++++++++++--
> >  2 files changed, 26 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> > index 842d65834afbc9..4ce7299060fbba 100644
> > --- a/fs/xfs/scrub/attr.c
> > +++ b/fs/xfs/scrub/attr.c
> > @@ -335,6 +335,12 @@ xchk_xattr_entry(
> >  	/* Check the name information. */
> >  	if (ent->flags & XFS_ATTR_LOCAL) {
> >  		lentry = xfs_attr3_leaf_name_local(leaf, idx);
> > +		name_end = (char *)lentry +
> > +				offsetof(struct xfs_attr_leaf_name_local, nameval[0]);
> 
> Overly long line.
> 
> > +		if (name_end > buf_end) {
> > +			xchk_da_set_corrupt(ds, level);
> > +			return;
> > +		}
> >  		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
> >  				be16_to_cpu(lentry->valuelen));
> >  		name_end = (char *)lentry + namesize;
> > @@ -342,6 +348,12 @@ xchk_xattr_entry(
> >  			xchk_da_set_corrupt(ds, level);
> >  	} else {
> >  		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
> > +		name_end = (char *)rentry +
> > +				offsetof(struct xfs_attr_leaf_name_remote, name[0]);
> 
> Same here.
> 
> Can you split the local vs remote code into separate helpers as
> that would really help with readability here?

Will do, as a prep patch that comes before this one.

> Also for this long type names just using typeof might be nicer than
> spelling out the type.

Ooh, that works.  I'll fix that too.

--D
