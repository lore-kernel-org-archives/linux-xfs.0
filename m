Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8622D4508E7
	for <linux-xfs@vger.kernel.org>; Thu,  8 Jan 2026 09:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767864639; cv=none; b=nqdVPLD2hLxrWMYw45ApNNT5V5NZl2tfI2Sjg+wGHZ9gwvC+Qk1F+7Uz71XIzzsKt3lwBWFbOjzqLx9sIWuwI2G0Caz8CQW30wo6KGduJyBd0NPiYAZQS0hkZsc3yJTwY1D5zTBG1BBcapRl8CSi2Suw0B72qndpGCeYcFKbh8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767864639; c=relaxed/simple;
	bh=SPSuQByJHuSHG5cT93v1lFtQLowu5ibTX/ZSFHMzx/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FbrZkRlb/LFYGcmPbWsjnuyqESLv93Us3h+MqSlUSlFWVrvzl184DbuNvK/JPlvN+sFF3kZT1aSNt1YJT5qz9DFWLv0YXjUYK7L+n9LI+jaIaY0v1A9OCMAW7hXv9fuCFp833e9IjfCdkbSggo6EIV2D/Ow05lCxdF+BUbXFwtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UASrdDCV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UASrdDCV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Lkl6v4f9jk2pvOfrdeMfjqUR697JoL2KR3+LZ9+92D8=; b=UASrdDCVCQqV8DoTrB/kY1mrdp
	s9z7aY68gSTTvsCLXN6j62rejryNsUVDQL+BFBHUqIqd0uIzr/eOfJbC1H0ydBKJXd7Y0PDOD9xk8
	Gz+QNiNdXnnkexT9iCgK+PwVFrkXcXP6b1XsvVtGFBJiywkbFu1Rqm2fVgXiLhj4ZT5lnFxbf6j/Q
	+kHtqawr/s93CjIu58VTwFhODIbkAgRiPrTNBOaTA78JPPlps8HfenYAPlw3FkNeGuEfLlxNFVWL+
	l1uejAQEQRcGvC8XRNj0NawMFYil80kOJeQrVtOvfVb8mJWsEzXlNIAkMfaDpDX0gZOfA966JSzC2
	i7kDAJUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdmLe-0000000GTP2-0YSY;
	Thu, 08 Jan 2026 09:30:30 +0000
Date: Thu, 8 Jan 2026 01:30:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH] xfs: speed up parent pointer operations
Message-ID: <aV95NpD3Jow6UgOj@infradead.org>
References: <20251219154154.GP7753@frogsfrogsfrogs>
 <aVzE-5gMi1IHOLTW@infradead.org>
 <20260107000907.GM191501@frogsfrogsfrogs>
 <aV33flV7zsiAeh7C@infradead.org>
 <20260107182242.GB15583@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107182242.GB15583@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 07, 2026 at 10:22:42AM -0800, Darrick J. Wong wrote:
> > > xattr mechanism.
> > 
> > Or that, yes.
> 
> It turns out that for replace, it's more convenient to do it separately
> in the xattr and parent pointer code because parent pointer replacements
> require switching new_name -> name and new_value -> value after the
> remove step; and the rename optimization is different for parent
> pointers vs. every other xattr.

I don't really follow, but I trust you on the parent pointers.

> > for parent pointers, or due to a value change otherwise can just move
> > things beyond the attribute and update in place trivially.  For
> > replacing values with values of the same size things are even simpler.
> 
> Yes it is pretty simple:

This is the same sized value and name, and it indeed is trivial.

But even a change in size of the value (or name for that matter, except
that outside of parent pointers that operation doesn't exist) is trivial
in an sf attr fork with enough space, you just need to either move out
anything beyond the attr first (larger name + value size) or down after
(smaller large and value size).

> IIRC there's no rounding applied to shortform attr entries, so we have
> to have an exact match on the value length.

Exactly.

> > > I also wonder how much benefit anyone really gets from doing this to
> > > regular xattrs, but once I'm more convinced that it's solid w.r.t.
> > > parent pointers it's trivial to move it to xattrs too.
> > 
> > Not sure what counts as regular, but I'm pretty sure it would help
> > quite a bit for inheriting xattrs or other security attributes.
> 
> Here, by "regular" I meant "not parent pointers" but yeah.  It'll
> probably help everyone to implement the shortcuts.

For user attributes it really depends on how people use it.  But for
applications that update fixed sized attributes, which doesn't sound too
unusual, it would be a nice improvement as well.

