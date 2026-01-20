Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58ED389447
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 07:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768893022; cv=none; b=sVefdbzdUPacYHq0Zfl7ukopkcMGDmCE8KghWNM5besXOgNwC5XoumCkmOxDsNtBXCTZfcLBFAmPTKaXrUDxI00attEzHdg9rUTa6hlkF5Zq9ruqGEKxp5QuH0GzONELkm9lAjvZ7/oKCjbhgupjjnU8EanEW9pRBuMmzJCPUW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768893022; c=relaxed/simple;
	bh=4WI4bZHHNd4wsKVG1itb2B77RPajKvYrqz/WZqUM+PE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTdm1dKfErmrQLRm7pG64+onYYuME+cS4CT8Ofnee6KYPKGTYljr8eErfERvX2nD4d3EK6pmmMzpZF5DezCQ0eY04WQCHFZBu+i7LWzkvHlbRi06DT2AZPn1YUS5vlxvEv1eU0XexBQaqVUXPJwdsKiBvFXZghwODn3OBgSQvqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UqFA2KJa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UqFA2KJa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fj8+o3z2YkZQM86Gsf7+0ckScyownYwtv4Ecasi6WYY=; b=UqFA2KJaPwPhII0LnLMs+D1Zmi
	gr6IC8fjsfAGHc+q+Rz1BuBx3R0dRn2nCnWy8kvRxqT64Hi09e6DmawfPt4zaa3tbjXJ3/wDMZmkm
	oBq+lVTg9xRl4KE6v3G0q6EzgGEQAXpnHD1arfRJzubhHHcHWjfD81p4oNxLL3aQ8ydmBVIHKFKCX
	9biQkSsgyxzL+1/Vvb+O8mZZ81p4IMOiOOOEyXJjPCCokAJdUjrERfzysn86R8iFK6S72kKjm7pVl
	P6pEqXv2WOF18pNkZRZvbsk3Hn/o5j2s61CgHMcI+ylksbsDC9njkbBUYdJ4knmlBj7ZZLFNTeI4e
	xmX0L2Sg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vi5sR-00000003KNv-1GKS;
	Tue, 20 Jan 2026 07:10:11 +0000
Date: Mon, 19 Jan 2026 23:10:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Wenwu Hou <hwenwur@gmail.com>,
	linux-xfs@vger.kernel.org, cem@kernel.org, dchinner@redhat.com
Subject: Re: [PATCH] xfs: fix incorrect context handling in xfs_trans_roll
Message-ID: <aW8qU2sMGfmMeBhW@infradead.org>
References: <20260116103807.109738-1-hwenwur@gmail.com>
 <aWpYhpNFTfMqdh-r@infradead.org>
 <20260116161133.GW15551@frogsfrogsfrogs>
 <aW3QmibHRf49gZYd@infradead.org>
 <20260119181407.GF15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119181407.GF15551@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 19, 2026 at 10:14:07AM -0800, Darrick J. Wong wrote:
> On Sun, Jan 18, 2026 at 10:35:06PM -0800, Christoph Hellwig wrote:
> > On Fri, Jan 16, 2026 at 08:11:33AM -0800, Darrick J. Wong wrote:
> > > Also it might be a nice cleanup if we could avoid touching the PF_ flags
> > > at all, at least if the transaction can be rolled successfully.
> > 
> > That would mean passing a flag to not clear them into __xfs_trans_commit
> > and xfs_trans_free.  Which sounds pretty ugly to me, just to avoid to
> > clear and reset a flag.
> 
> I was more thinking that xfs_trans_alloc would set PF_MEMALLOC_NOFS, and

What about xfs_trans_alloc_empty?

> that would be cleared at the end of xfs_trans_cancel or
> __xfs_trans_commit if !regrant.

I guess we could do that.  Not sure it's any cleaner than the clear and
reset approach, though.

