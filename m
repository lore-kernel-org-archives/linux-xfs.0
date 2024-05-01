Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3D8161936
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714597469; cv=none; b=LNgOfwdQkfD2z3OWMESe6yGLdFE+7n7NbRX2ZJrRXmZOrsEDWovY6yJ5EnRqrJhZA2hOtNWyfV0LJLQzWZGgEofsAKco7P5eV3dULFzPqOv6eiWI0fHwmII5I+5sV4bbeZavbWQyDqKj2l8O54fHLIR9DOhokUSCi3jL2wQiP1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714597469; c=relaxed/simple;
	bh=QdjCqTclnShejz2niZ+V5ScjZun6vQUlmF/gSucwITw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TDc3DMvH2xXrgoQ9DISziAqpNNHAs3Zl51CK7kdT+eKOSE+hf1Tl36MFgGJm5WpeUMWEJyhgZCLpQqTpP0v3P8C4i9sFhAvTFhpo5FgvwxJWPcs/6gvj/4Qd9Iaj29KbMEdMEQ6fGolj0Tvg3mVzJnFUoRI1zPDJkvXxgnWAvlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LusFotLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LusFotLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89DDC072AA;
	Wed,  1 May 2024 21:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714597468;
	bh=QdjCqTclnShejz2niZ+V5ScjZun6vQUlmF/gSucwITw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LusFotLaznh+0Pf+fSRv1ljrYL195P0rnPTYVWJ4wcFlN+0ysFhB2qIMoakea3grH
	 OD2pF94Vg6PIkV0ZYvj69+cgdz+6LRGd6ad6TLemfJZLMhLEFu9wDXBn9LarU8i8oX
	 Lmz7m1VLPrQ8gCYS5jNCRJ7z3IPnL9rxaLbvy0PQMB8xbYL/SH4iIBqD5zx//kDb/9
	 LZpH8sVVtV1JkC3SZA9awM4Vk05Js5FCbg+uubjR/U4+rntQiQ0hcIPVv5E6MabJ3j
	 Sbo6vdsO7nPEYABwi2swkEXvu2sQc6Hwghk+0yPsGJErDlaj+wWtQs8ys8A/gPe4wC
	 oHgtVX/RKCXAA==
Date: Wed, 1 May 2024 14:04:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs: allow non-empty forks in
 xfs_bmap_local_to_extents_empty
Message-ID: <20240501210427.GP360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-2-hch@lst.de>
 <20240430155131.GO360919@frogsfrogsfrogs>
 <20240501043734.GB31252@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501043734.GB31252@lst.de>

On Wed, May 01, 2024 at 06:37:34AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 30, 2024 at 08:51:31AM -0700, Darrick J. Wong wrote:
> > > Change xfs_bmap_local_to_extents_empty to return the old fork data and
> > > clear if_bytes to zero instead and let the callers free the memory for
> > 
> > But I don't see any changes in the callsites to do that freeing, is this
> > a memory leak?
> 
> Even before this patch, xfs_bmap_local_to_extents_empty never frees any
> memory, it just asserts the the local fork size has been changed to 0,
> which implies that the caller already freed the memory.  With this
> patch the caller can free the memory after calling
> xfs_bmap_local_to_extents_empty instead of before it, which the callers
> (all but one anyway) will make use of in the following patches.
> 
> I thought the commit log made that clear, but if you think it needs to
> improved feel free to suggest edits.

Ah, I see, currently all the callers /do/ free ifp->if_data, having
snapshotted the contents before doing so.  I guess I needed the words
"all callers do that".

How about:

"Currently, xfs_bmap_local_to_extents_empty expects the caller to set
the fork size to 0 and free if_data.  All callers do that, but they also
allocate a temporary shadow buffer because they need the contents of the
fork so they can copy it to the newly allocated extent after the
transition to extents format.  This is highly suboptimal."

?

With some wordsmithing like that,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D
