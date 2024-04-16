Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9B837719
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713286456; cv=none; b=jZQV2PL7oRglzOnciKovVJU/gk04aYpJfe+sV1h0IKvQRA3UlgqkVSjqfS6NFFl1IO2uyg1r95gzC++lqxgYroT4x/I3QfVV6h8D7bkOHxjZM2gkhSfVC1HCdLC7agXgByeGZZHt/bMFnEJUEk31lO2gg6fpkp1pCWWb3sNue/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713286456; c=relaxed/simple;
	bh=oDhxKcnYOPHjJtEHOEBDYNP0RX3k1lqdvXl/YGndcpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K6PfGgwSU0tFG7PDIMsIY/RhBi7Osoi5E3tXBXex3Xx8d0qNlWSNVKPy94ktoGjstuxXHdH4saKF6g2NuNlYwrmOuJzDDSxwqOFsStZMOD76XO5mmD8+xx9W9C9PdaGhxIzE7UIbDYQ9Vd2Jycr+B90j+7u6HOkrTvHQXz//tKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4TY7Z6NP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4TY7Z6NP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FK0hheNpPXqI/xeJIG48ZGWMVF0r2F35oEaLsAhVQuM=; b=4TY7Z6NPpCFmI/v1WLxuvHilcs
	+j3VB5spvFCg2QyQ2zivlc1dIaCzydkJujgW6CasuZNzKvQA4JmHXVgCm43QlO0c0uoZ0zlMOOSrO
	MVrcFfyWPeT9k5OvpUs3y5FYLl6HWebjtoN4ZHKsQiNqqbC2odA6wMPJ6zy/JQU/STafXA9LQm6y8
	aUrWRzMS45aNbKLr/ll3FitobNgV4Os+hGYSSAawmcp0VhOiXCsPD8Hh3Yq9a8aPA+rVRsLagyKz4
	kUtnc2Os5YeT01CRlYQDwMqKUYG57KS8VJQ9sJgLMyUrMnSZ7aOfH2DuCYS2VqhxHAdoN0MyXGstK
	U7Wcxp0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwm4U-0000000D53x-1iJC;
	Tue, 16 Apr 2024 16:54:14 +0000
Date: Tue, 16 Apr 2024 09:54:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <Zh6tNvXga6bGwOSg@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs>
 <20240412173957.GB11948@frogsfrogsfrogs>
 <20240414051816.GA1323@lst.de>
 <20240415194036.GD11948@frogsfrogsfrogs>
 <20240416044716.GA23062@lst.de>
 <20240416165056.GO11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416165056.GO11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 09:50:56AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 16, 2024 at 06:47:16AM +0200, Christoph Hellwig wrote:
> > On Mon, Apr 15, 2024 at 12:40:36PM -0700, Darrick J. Wong wrote:
> > > True, libhandle is a very nice wrapper for the kernel ioctls.  I wish
> > > Linux projects did that more often.  But suppose you're calling the
> > > ioctls directly without libhandle and mess it up?
> > 
> > The you get different inodes back.  Not really any different from
> > pointing your path name based code to the wrong fs or directory,
> > is it?
> 
> I suppose not.  But why bother setting the fsid at all, then?

I suspect that's a leftover from IRIX where the by handle operations
weren't ioctls tied to a specific file system.

> > But as we never generate the file handles that encode the parent
> > we already never connect files to their parent directory anyway.
> 
> I pondered whether or not we should encode parent info in a regular
> file's handle.

We shouldn't.  It's a really a NFS thing.


> Would that result in an invalid handle if the file gets
> moved to another directory?

Yes.

> That doesn't seem to fit with the behavior
> that fds remain attached to the file even if it gets moved/deleted.

Exactly.

> 
> > OTOH we should be able to optimize ->get_parent a bit with parent
> > pointers, as we can find the name in the parent directory for
> > a directory instead of doing linear scans in the parent directory.
> > (for non-directory files we currenty don't fully connect anwyay)
> 
> <nod> But does exportfs actually want parent info for a nondirectory?
> There aren't any stubs or XXX/FIXME comments, and I've never heard any
> calls (at least on fsdevel) for that functionality.

It doesn't.  It would avoid having disconnected dentries, but
disconnected non-directory dentries aren't really a problem.
