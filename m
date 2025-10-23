Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777C435B152
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 06:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761201303; cv=none; b=OXUey6OuM1+LkFFF9zuHNkK5fB3bNpVhJUdDWLD/ZLxTJjs4RTiLc2Bt6FQoj3kIjQ3nafP69F7LkgXjud12FAgrTPqOnk33AtMhzbry27nUw8eq6WbNcUN4nBEPPCkw7I9V89t2ltPgA3hA9whekQTMGlqeIPiGlmcVF3CGcjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761201303; c=relaxed/simple;
	bh=WewLaNGkGfsC+Wm2yzMl17e1aHsq8lpqYVG0Hn4FpgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RW3rz2jVk97/47V7LNHNNHIGuzUd5lasbGQTRhyfQp3xjy/wvIJjtKM3OrtD4gxCUqgRtdJ2jRmQ3RBT0YKtzjvjhN3Ys5Gp6etKnOx0VsT/TtQ+P060uz1Y+TrULOFpmOL+3Oow3OT5TftzQH25TN/UQ+1nZMBIt+iYN1ASD8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aBSVNAOp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aBSVNAOp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=g47RGF+NdJ09gYzALbAf2k1vxFGE900LwvdbO56igb8=; b=aBSVNAOpvUkqii5iq9D07my5Jy
	lpZfs7Hu421Tdfrq+zYldsfAc55mCYQokdcSimGj2LIszs2a9EBwAc/bPSZR7kjajy6jrtX7fatGp
	qoFYKu/qfIUhHjwIY/ImOPzcoJNsJTJ220M+iYvRxblVkqvjNBUd6wXvAokRtVh3tA07Qc8mJpzz9
	nPPa9OLEo0bJ5C0YJ4GGIzwhHCgMLfIo/EcIKDozDBRHS7H4zd0BemdvZaimDQBcWZ5Dm45pIbdjI
	RYtT2qfe+XC+uEkWkndq/Z/1uGGhKcZWElFKvZsm6fnf7cMwT5LPuebM6HlWd+cyQjoAoTVyZqWY0
	uqnRqYUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBouZ-00000005E2m-2G17;
	Thu, 23 Oct 2025 06:34:59 +0000
Date: Wed, 22 Oct 2025 23:34:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, bfoster@redhat.com, david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: Re: [RFC V3 0/3] xfs: Add support to shrink multiple empty AGs
Message-ID: <aPnMk_2YNHLJU5wm@infradead.org>
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
 <aPiFBxhc34RNgu5h@infradead.org>
 <20251022160532.GM3356773@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022160532.GM3356773@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 22, 2025 at 09:05:32AM -0700, Darrick J. Wong wrote:
> > I'm still missing what the overall plan is here.  For "normal" XFS
> > setups you'll always have inodes that we can't migrate.  Do you plan
> > to use this with inode32 only?
> 
> ...or resurrect xfs_reno?

That only brings up some vague memories.  But anything in userspace
would not be transactional safe anyway.

> 
> Data/attr extent migration might not be too hard if we can repurpose
> xfs_zonegc for relocations.

The zonegc code is very heavily dependent on not having to deal with
freespace fragmentation for writes, so I don't think the code is
directly reusable.  But the overall idea applies, yes.

> I think moving inodes is going to be very
> very difficult because there's no way to atomically update all the
> parents.
> 
> (Not to mention whatever happens when the inumber abruptly changes)

Yes.  That's my big issues with all the shrink plans, what are we
going to do about inodes?
