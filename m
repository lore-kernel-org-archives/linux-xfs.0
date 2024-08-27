Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A885943169
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 04:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724734763; cv=none; b=cbJDHp7gtYn7++xWa0qIX57cwihSPKALerYkaCWYklmhgsIZzAHSCftwkGVMJGDZcR3pU9I+E1ES+xTdOJgGizfXvx02z73KQ8I4OyXqh6m1sY0R7aHynTrHLfGFre3QOsmvEvmrVbrW5FBPOzLWPpi1H9qs6NJI8EuLHfLtyEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724734763; c=relaxed/simple;
	bh=i8nj/j73K0HKlNLh9jcOUfCJOmWuYpLETAmimDiqrS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WCi8ZZJnAzm0FBgJWW+WtUA8+LExJYwQ4cwN1mgc6jyc0YrEwWE1VetCtzLWQ+G4AiRhjSO2H440ZhZPRiakFJYVcT2iox/GCYb2Ba0MdQt49qfSzCRyECTgoivmaZMyB9lWwO0PxNo7OmHqdtIYHI+uOQhDBdZZdsgJwah4SA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JPOmcBB+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JPOmcBB+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/tjntItYmHpIC1UjiTmLSygA/7aX41w9eRnAO7KB9xY=; b=JPOmcBB+qmoUyy8g6FFWaT1Lk7
	8uQ2Ji8UwBkv8PAQtFesVxv902UeG+0q1VIRdVGyh1bb35l/8RKgaJ2leed8w9bnr+BvXcq9rsYWv
	xa6RKrV1D5GHHX2cx9HAd9tA+hBYBHlnfG0fXnHNTZe3eSfKdkT1N55aS97gkxzKogo6BEPXJ18Oh
	NBNtGdqAJn9PcmzG/CnUMOwQ0er0eQzCZdVvX0/jWi7TwG0Z19aIxpPjeVeVEo+donPha6DqVHTwD
	lU8bLIrz5aiASf3UG9oFsF0RwJ6lK5WYP3XY9e2isB2H8hWDDM5+efoeoMzlvyYGcLgKlHtKZtZrA
	pB9dlTuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sioIb-00000009n4V-0ZMM;
	Tue, 27 Aug 2024 04:59:21 +0000
Date: Mon, 26 Aug 2024 21:59:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/26] xfs: make the RT allocator rtgroup aware
Message-ID: <Zs1dKSq_V1Juv1uY@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088886.60592.11418423460788700576.stgit@frogsfrogsfrogs>
 <ZswLBVOUvwhJZInN@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZswLBVOUvwhJZInN@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 26, 2024 at 02:56:37PM +1000, Dave Chinner wrote:
> > +	if (xfs_has_rtgroups(ap->ip->i_mount)) {
> > +		error = xfs_rtallocate_rtgs(ap->tp, bno_hint, raminlen, ralen,
> > +				prod, ap->wasdel, initial_user_data,
> > +				&ap->blkno, &ap->length);
> > +	} else {
> > +		error = xfs_rtallocate_rtg(ap->tp, 0, bno_hint, raminlen, ralen,
> > +				prod, ap->wasdel, initial_user_data,
> > +				&rtlocked, &ap->blkno, &ap->length);
> > +	}
> 
> The xfs_has_rtgroups() check is unnecessary.  The iterator in
> xfs_rtallocate_rtgs() will do the right thing for the
> !xfs_has_rtgroups() case - it'll set start_rgno = 0 and break out
> after a single call to xfs_rtallocate_rtg() with rgno = 0.

The iterator itself does, but the start_rgno calculation does not.
But we can make that conditional, which shouldn't be too bad especially
if we merge xfs_rtallocate_rtgs into xfs_bmap_rtalloc.

> Another thing that probably should be done here is push all the
> constant value calculations a couple of functions down the stack to
> where they are used. Then we only need to pass two parameters down
> through the rg iterator here, not 11...

Well, not too much of that actually is constant.

