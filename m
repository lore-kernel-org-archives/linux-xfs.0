Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E274D1F76BC
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 19:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734465495; cv=none; b=YVh1HnL2p5xm5hkTmZkqDvhkDkr+XHy4Lz4qrSMdBhZ3St9jBaDiwB9/Mt9HzVFHwxKROO8ZktAEQCu6hscjWwmYuC6W9kQDFXvovKE9v2hegMpAkoW1YmNcNUWButwb4NJybeB4o+4PcDp83KLIg0MqN33/9ZJR+5zQJRK7YQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734465495; c=relaxed/simple;
	bh=6dPfcfVfFa6POxCuNsOvV5dndvkOIVsjHLKVKuqvZac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U9WTmDzKWDSHWX7vK1/w783a4hDKM3LgjsqFeGRswb5IRpNukFmKynEnNrm73Nj0ZoW4WlL4rkqsIVnR8pD4MRG5UrWSGeD/rqqQpri0jlf8NPR4mHxKHzvwXPfit+WVdHi+cSGDub3tL/2SROZcx5vI3d1WDLEq6up4y2IQB7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hf6VHwHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hf6VHwHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D350C4CED3;
	Tue, 17 Dec 2024 19:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734465494;
	bh=6dPfcfVfFa6POxCuNsOvV5dndvkOIVsjHLKVKuqvZac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hf6VHwHBxOh+xnYjsi2W2ITxWmiZlLodq3269wCLVmyIY67r6B56LS7tFjryZshY4
	 MYbZS/eMhqRnnrwdBA4g4WPx1SwJmJyoI1f+XrDXkyOgx/GUs3XAqxaswHbeFzpLtA
	 KdKcM1As/Psqpq5Rf6hl1bKwwIStf6Vj7ZNj+w1nGVpfoWKxgKG5HmNLoODGeBvA8j
	 2kfpS2e6MVxYXAErIq62dSpgkibaWnNed4octM9ldbwrmNcmlOp8m/clStibqssJLd
	 kYQCTw/Finf6X3pKJQc7dG7afHkpealc/9zlzNfhE2DwXfCHPUXUQCf2VDzjjIv38Y
	 PklMvin41xahg==
Date: Tue, 17 Dec 2024 11:58:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: allow inode-based btrees to reserve space in
 the data device
Message-ID: <20241217195813.GP6174@frogsfrogsfrogs>
References: <173405122694.1181241.15502767706128799927.stgit@frogsfrogsfrogs>
 <173405122737.1181241.12229622781538486656.stgit@frogsfrogsfrogs>
 <Z1vP9qDWdywLExjt@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1vP9qDWdywLExjt@infradead.org>

On Thu, Dec 12, 2024 at 10:11:02PM -0800, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 05:00:35PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a new space reservation scheme so that btree metadata for the
> > realtime volume can reserve space in the data device to avoid space
> > underruns.
> 
> Can you explain this scheme a bit more here?

Back when we were testing the rmap and refcount btrees for the data
device, Dave and I observed occasional shutdowns when xfs_btree_split
would be called for either of those two btrees.  This happened when
certain operations (mostly writeback ioends) created new rmap or
refcount records, which would expand the size of the btree.  If there
were no free blocks available the allocation would fail and the split
would shut down the filesystem.

We thought about pre-reserving blocks for btree expansion at the time of
a write() call, but there wasn't any good way to attach the blocks to
the inode and keep them there all the way to ioend processing.  Unlike
delalloc reservations which have that indlen mechanism, there's no way
to do that for mapped extents; and indlen blocks are given back during
the delalloc -> unwritten transition.

Therefore, we chose to reserve sufficient blocks for rmap/refcount btree
expansion at mount time.  This is what the XFS_AG_RESV_* flags provide;
any expansion of those two btrees can come from the pre-reserved space.

This patch brings that pre-reservation ability to inode-rooted btrees
so that the rt rmap and refcount btrees can also save room for future
expansion.

How about I put a somewhat massaged version of this into the commit log?

--D
