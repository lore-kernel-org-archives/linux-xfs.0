Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E1B4C62
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 01:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724894156; cv=none; b=iooLcsU2Swc01CWMbDXkdE2UIwtjEZh2xg4vtbuCUcRBCHbIl9CviJMi8trIFIL2H0cA2zwD23iqnYNAxMPEprCNpqwwfoG50MLmh6Ys6RBysMHZxnNoXKl009xNsySBnGz4P2XfcS0y0TD5R5fOT1TZLr8okyoDP29sKIlPB9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724894156; c=relaxed/simple;
	bh=ekzP2ygaCBJTpyv8QhIEWYaKCZlvtlXAK+W8g+pGMsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxMt+dzeUXCfC/z2EsKYBEYoXQ64JohBOb+cSsm61+irn6Z0rtU212DjA9euSGPxvA+aoSUu9HccpNjCKmTbNM4iNWngb9f4DVL4a/rU85YGaesHke8/RtONXseKkglXtMzzGGakbNSFRsEVuSW15jsq3AyLyrCziQ6czuv9L7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sHi0uytf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sHi0uytf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F559C4CEC0;
	Thu, 29 Aug 2024 01:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724894156;
	bh=ekzP2ygaCBJTpyv8QhIEWYaKCZlvtlXAK+W8g+pGMsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sHi0uytfUzZgkNeV6APnXbqsjxciHOXL/s+S/HyO3UMRgz81zgpZzGNKSS8pMtwT/
	 VzJpYmc8v8/EWhmAj4lUmLnZnlvqyRnprASJGVLHp5njj8yRkfefQ0QGx3D499NKiz
	 qSTCvOPtUa0tfujazVx46u7faAMIaa8jFuhMN1wLBaeJolRts60RPwDkASSxGioztD
	 Ub2M61ui9kRaEaZm23QPc2w49LOmGUeXteHfz1ozi9tzoAGW8Lt4IzD5YDqtI7Dx7j
	 L11ZSl3B6xOgRjSxy3pmhczZKuggaB/0DNEI3qLLFvYdvGJrfIdX+zKSLSTbL/CRRd
	 q78pK5txJIbxQ==
Date: Wed, 28 Aug 2024 18:15:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: move the zero records logic into
 xfs_bmap_broot_space_calc
Message-ID: <20240829011555.GE6224@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <172480131591.2291268.4549323808410277633.stgit@frogsfrogsfrogs>
 <20240828041424.GE30526@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828041424.GE30526@lst.de>

On Wed, Aug 28, 2024 at 06:14:24AM +0200, Christoph Hellwig wrote:
> On Tue, Aug 27, 2024 at 04:35:01PM -0700, Darrick J. Wong wrote:
> > This helps us remove a level of indentation in xfs_iroot_realloc because
> > we can handle the zero-size case in a single place instead of repeatedly
> > checking it.  We'll refactor further in the next patch.
> 
> I think we can do the same cleanup in xfs_iroot_realloc without this
> special case:
> 
> This:
> 
> > +	new_size = xfs_bmap_broot_space_calc(mp, new_max);
> > +	if (new_size == 0) {
> > +		kfree(ifp->if_broot);
> > +		ifp->if_broot = NULL;
> > +		ifp->if_broot_bytes = 0;
> > +		return;
> 
> becomes:
> 
> 	if (new_max == 0) {
> 		kfree(ifp->if_broot);
> 		ifp->if_broot = NULL;
> 		ifp->if_broot_bytes = 0;
> 		return;
> 	}
> 	new_size = xfs_bmap_broot_space_calc(mp, new_max);
> 
> But either ways is fine with me:

This got me thinking about the rtrmap and refcount btrees -- could we
save 72 bytes per inode when the btree is completely empty by returning
0 from xfs_{rtrmap,rtrefcount}_broot_space_calc?  The answer to
that was a bunch of null pointer dereferences because there's a fair
amount of code in the rtrmap/rtrefcount/btree code that assumes that
if_broot isn't null if you've created a btree cursor.

OTOH if you're really going to have 130000 zns rtgroups then maybe we
actually want this savings?  That's 9MB of memory that we don't have to
waste on an empty device -- for rtrmaps the savings are minimal because
eventually you'll write *something*; for rtrefcounts, this might be
meaningful because you format with reflink but don't necessarily use it
right away.

Thoughts?

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
