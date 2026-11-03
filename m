Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715208;
	b=LDAWo7bxNEF/QtWF+nf/ujdCtB1k6d0RBPEXLmX0Yr0l6nM/an/vb2majLS0hlZPFy29
	 9R4rMLbR4WdFWphixqVPBxN5o2k3WUiOfDsMwpXajUdiv5dVKAFrolHkjcC4b/odIZs/b
	 D5DyAW8qz2TN1Sa/F0NjLToj9C/1UN6OyBJRJ3eWuCGCJEryrOh475TxTL3aJL0kY0yH8
	 zhNPxc1U2+W3v0+6yKxb+TMsb+J4I7ak0NmDSIhEiVM5HGQk/qsz96rqDRMUhadewUvvH
	 V5tLRsL/wy+5I5jshkhTNtzHIEamQ0KO5B6YMSLiVkBtyIK/UNPyuCnxvGQ21nt5SwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715208;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=lqZVSFx0P4gruX3mrDwAOvKFMHFIa8vh6yz0LT+CPeM=;
	b=vHrdis//g1zNAUjToj6e6k9eJgmVETklGhuDHMsHaMfblCdTzVJ+mcg7aE4Krt8ikVgw
	 gToMOhn2cNEZTCbG5cY6UX1tcUMWPncZgDqUCjurfJEtiKin7aETpqhfG4IpVihbhh5YI
	 eXotnpLiEqzAJHZM8y8E2vlqkfjlPddCaWoPfKPFTAQbGlUivqVjzZc5LqEaxxUF19L9v
	 r9CQZqeovpvxZxncPBINo1N/CB0Bj6Pm+5Wt93GEEMzx1j1zHs/45kWv2A9IfVFcUD+rg
	 gquhbMku+lniBPTmn3wX41ESVycglViIxPPKRRAPPaSLWKr65l323ecgBebLbgG2AtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XfJkfrYc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864B5606A326
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 14:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XfJkfrYc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440E71F000C1;
	Tue,  3 Nov 2026 14:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793715208;
	bh=lqZVSFx0P4gruX3mrDwAOvKFMHFIa8vh6yz0LT+CPeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XfJkfrYc9NbhEEQ7nNO7nOVtfolfZD6u1hWP+9jEeKnL4LMcPScE+zxXq0rStMu6p
	 VHaCWlf3cwIGkdSXMqlLiYzpZF6q0jG8zHBXBM23Wue02qBhgAT4rFER0HbprucbAS
	 69wrRXu6cA1C9nasxQuUdtutgAedZrFlhXjLG6kHOU8WfFwRTvBlpLuq6vYIiwdvEC
	 FgJs9rggiPFYaN/xVLmFGsqmwMJHZ8iaaVKYJAMaRpPzKtheX5LY08a1dko55mTn2I
	 smkLdJ1Mkp7sw7Byq8FEUiRDZ7QluNi11K00iVw5dB9kvLiId3vmrLeJ+1F3BUtQxn
	 jjnRHiGGwXoow==
Date: Tue, 3 Nov 2026 15:13:24 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Subject: [ANNOUNCE] xfs-linux: for-next is now 9dde020e1968
Message-ID: <aunr8OdKsxtpUM1-@nidhogg.toxiclabs.cc>
References: <aumw9Gazayh1SxZh@nidhogg.toxiclabs.cc>
 <aunYa5PKsKxzvquz@infradead.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aunYa5PKsKxzvquz@infradead.org>

On Tue, Nov 03, 2026 at 04:49:47AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 03, 2026 at 11:09:24AM +0100, Carlos Maiolino wrote:
> > Daejun Park (9):
> >       [77d5d75d727a] xfs: mark the inode preallocated for pNFS write layouts past EOF
> >       [e0fbfbec7d5b] xfs: add a flag to convert unwritten extents without allocating blocks
> >       [faf5f20d6c00] xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks
> >       [351fccff2881] xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
> >       [cefa7c7b065d] xfs: cap the block count of xfs_iomap_write_direct() at one extent
> >       [e4211f8034ce] xfs: clamp the pNFS layout range to the maximum file size
> >       [d58a23e183d5] xfs: take the invalidate lock while mapping a pNFS layout
> >       [c92cc6514b9c] xfs: add datasync and log_flushed arguments to xfs_log_force_inode()
> >       [c3b00a553cbb] xfs: make pNFS LAYOUTCOMMIT stable the way fdatasync does
> 
> While relatively large, these are fixes for nasty holes in the pNFS block
> export.  Given that we're only at -rc1 right now I'd love to see them go
> into the current merge window.
> 

Sounds good to me, I'll move them to -fixes.
