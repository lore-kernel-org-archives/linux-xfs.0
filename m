Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D246A48
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724819632; cv=none; b=joP9g15voi80KWQFcpnF3XEb84J6KBqXB3YOJJUE6L7KP6psVsbMoLmW/Nc1sz66B0bWzkIAWlCBW1ahASvQfORIGBXIXR/AOlRMNpgP6Furh8OMWhBqOqahNaNeG2A0qRJiwxWrPAK7YBpHvr4s+joNhfEyvJ4xER7xi85FjLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724819632; c=relaxed/simple;
	bh=gWC7UfaMGNjs1q/sR81yT5lql0Sf25CY++233e2aHGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jqkP8kfYQxfhaF/MsDa+Yhy/x2eABYMFfGmbyx7LYyKMhxPpuxDLKhkpLRYSbzBhmuxjzuVEAnT6CV1TvahChLN6/UcGKOAV/P0RCXEI9wRDZrPRpmwhhv0GeAMsazc0r2jeCVl7SVm4ht6JmB08j95FinsGiVA7w0PsaVnspXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fmA6/lyv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fmA6/lyv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=929BYojgbcNB1Lx7GAjyCXCe3IPKnD72MpWG0d9cDpk=; b=fmA6/lyvar+wNeK+nj4RiHZ21I
	Rs5s55AGuMDqkJale9k7BGPtvsOoOuM+25IShBppnDHjdkG+TewnNan4XkawmJiDJ0oVLxlVkUtKH
	YTRVVOhmhIqcQUHpDxWelQPBVMcHzh4ILn2BRcmEYDvyWGJMPlU18vpvrU4QvWrkXvtOU+Z0g9QOF
	FtLaUmV2CJQ1LgeH+MEkDpgFhQUPIQ9PbRUBr+myrMqI7eb4i8lhgYyf9Z6MGNaGCW/MrNIPdaGJ6
	pgolzza8Lk/df98NMxhEca3jajFruB6wFv9ar1jG4fOmrQ//BQPyqXqdmpcK+nCF6wThqu8GDXqor
	9bD6DN7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjANS-0000000Do9j-3CeU;
	Wed, 28 Aug 2024 04:33:50 +0000
Date: Tue, 27 Aug 2024 21:33:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/3] libhandle: Remove libattr dependency
Message-ID: <Zs6orusFSi2jG2qm@infradead.org>
References: <20240827115032.406321-1-cem@kernel.org>
 <20240827115032.406321-2-cem@kernel.org>
 <Zs3CuTVfX1f2oZTD@infradead.org>
 <20240827144423.GO865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827144423.GO865349@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 27, 2024 at 07:44:23AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 27, 2024 at 05:12:41AM -0700, Christoph Hellwig wrote:
> > On Tue, Aug 27, 2024 at 01:50:22PM +0200, cem@kernel.org wrote:
> > > +	struct xfs_attrlist_cursor	cur = { };
> > > +	char				attrbuf[XFS_XATTR_LIST_MAX];
> > > +	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
> > 
> > Not really changed by this patch, but XFS_XATTR_LIST_MAX feels pretty
> > large for an on-stack allocation.  Maybe this should use a dynamic
> > allocation, which would also remove the need for the cast?
> > 
> > Same in few other spots.
> 
> Yeah, the name list buffer here and in scrub could also be reduced
> in size to 4k or something like that.  Long ago the attrlist ioctl had a
> bug in it where it would loop forever, which is why scrub allocated such
> a huge buffer to try to avoid falling into that trap.  But that was
> ~2017, those kernels should have been retired or patched by now.

One nice thing about the dynamic allocation is that we can get rid
of the silly char buffer and the casting..

