Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD85120468E
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 06:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767765889; cv=none; b=KLWEzeZPRDT3kqQjTapCpjx2tKLLFTQThlE6gl+n6Iab/Kj6DdMTpkia6EjOuU36uKWVVhAeW3XFzN1qjaZco8jOWXgeRgJgngZYYRm+PD2sJn4az/TocpEdKWPE6DyyQ5SPubcQfSCtq6MpAvq6AlInRjuil6sl9oiJIzKXBnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767765889; c=relaxed/simple;
	bh=BBS4O1wI+UU2WzfVZ4FhPdf4ncMU6jxfRSPmJveosdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WzICldw7DDhi5E4tyPgutvLfVhodqCyIZSy95nhrHnrb+zsxO10e6EIrqRdwgnZvOJw8ToDOjqvDTQmR+1XoGKXe9uRm4shJzJx/59xYqp/ps1xXfscxSnMSk2VvtMPwAl0PloPeVzj4PSWLyVmfLsnh4jQk+bWJTCfWrTO+V00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qsKAweED; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qsKAweED"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HBRNFBQwQhhtlZJbJMH1PmTlzgN4Sllgw1s9qDobtfc=; b=qsKAweED84ChNSaIuJlrkJ9zqA
	uQWCnadpggV+/pa84Vt4vdP36+C4KfD6I8Ij64zljlWxkvXkxBckXSwtRKWa4GMj44G0DBxR7HSyW
	nEHwpIO9m8nsksQS2IJhKgqNzIygmhHO6L5pBYEPJjGW7KberSXpjA8TGitcL2iA598mnilXkCIhB
	9BHvzfDwMdYACLsVucDiCpOMMLhRfdvwk0eHL95a773U8aLFcZ39KubZzfA+H26j3QuzyZJAKcStn
	CjkWgqb6/TJlPU2e5h6QaeHlsGbq9r+/akY212j+VBE2WWmHGkBTtQ6xtQCmKNGmVEpyIXCN5XGCL
	u08FF+pw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdMf0-0000000ECSQ-1wgN;
	Wed, 07 Jan 2026 06:04:46 +0000
Date: Tue, 6 Jan 2026 22:04:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH] xfs: speed up parent pointer operations
Message-ID: <aV33flV7zsiAeh7C@infradead.org>
References: <20251219154154.GP7753@frogsfrogsfrogs>
 <aVzE-5gMi1IHOLTW@infradead.org>
 <20260107000907.GM191501@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107000907.GM191501@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 06, 2026 at 04:09:07PM -0800, Darrick J. Wong wrote:
> In principle, yes.  For a generic xattr version you'd probably want to
> check for a large valuelen on the set side so that we don't waste time
> scanning the sf structure when we're just going to end up in remote
> value territory anyway.

Yeah.

> 
> >         It might be nice to just do this for set and remove in
> > xfs_attr_defer_add and have it handle all attr operations.
> 
> Yeah.  I think it's more logical to put these new shortcut calls in
> xfs_attr_set because we're be deciding /not/ to invoke the deferred
> xattr mechanism.

Or that, yes.

> > And for replace we should be able to optimize this even further
> > by adding a new xfs_attr_sf_replacename that just checks if the new
> > version would fit, and then memmove everything behind the changed
> > attr and update it in place.  This should improve the operation a lot
> > more.
> 
> That would depends on the frequency of non-parent pointer xattr
> operations where the value doesn't change size modulo the rounding
> factor.

Well, the same applies to value changes - in the shortform format name
and value are basically one blob, split by namelen.  So anything
replacing an existing attr with a new one, either due to a name change
for parent pointers, or due to a value change otherwise can just move
things beyond the attribute and update in place trivially.  For
replacing values with values of the same size things are even simpler.

> I also wonder how much benefit anyone really gets from doing this to
> regular xattrs, but once I'm more convinced that it's solid w.r.t.
> parent pointers it's trivial to move it to xattrs too.

Not sure what counts as regular, but I'm pretty sure it would help
quite a bit for inheriting xattrs or other security attributes.

