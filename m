Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE44158DC4
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 17:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736442238; cv=none; b=KXUXq9khISQu5UdSA3NYYnaCL+R6sf/R73MnUqwVywrT2s+fhTr1cfotCHYR/l508gZlUE1e0HYxgeLQUR9YX0QXViraqJdwViDLwQBEDJSam0hZp1DpZXFQghhZ6OuOx6a4dLQXg8jKYA6MLSup/jhl3kJkvJWH1pkoo+/H5q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736442238; c=relaxed/simple;
	bh=z6+FF1xFiWxbNWFBuwDmXZfBTyGz5kzrbuaB9OQa5JA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AP+gsseKK7pfSO5rO0nB9Rnl9JFQXY3BSOOCinL/IT9geGzrq2l1hgUI4xsw83NylDkeZJgT8ZGVr5tKEhTivBpFO409uagmNhMB7hjcoo1OfSuKvG1xxrzfgXkTRZtGRR6X+OXXJWttAVniYf5GxwKfZ6Z4JVMFp3CtqXBlSDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=APAfFwAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="APAfFwAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778E5C4CED2;
	Thu,  9 Jan 2025 17:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736442237;
	bh=z6+FF1xFiWxbNWFBuwDmXZfBTyGz5kzrbuaB9OQa5JA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=APAfFwAJvwyIEjZPkpOZAcYGrj3lVe8NWWj2yKqlnAQNtrdYwk7KK1Nb82Ak8PZ/J
	 nvCgZvrAjqBYVbCrJU2TCxgxsHyAhSpu5Yd35YPi6Vah5A20QPiP79xMuVPX+cCPAv
	 RB5JGEK45JrfoRQ549/4mfUaXuPL6XVvqC+FABQ7zwhG/wEsoWU4V475HrMJiQ6jpq
	 eCJsjeO79Dl+QOKGrbgrJMHdA52MUengJRhgLr3NQ7UlPyQmLYyu8pP+6kJgh2Uojg
	 82wUbblWQplfrAhbohZraLH+IgKZM4saYqNK7+VqKGGK4YVZYZpxUBV1IKbEGcOSYu
	 K1hauika0PYVw==
Date: Thu, 9 Jan 2025 09:03:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org,
	david@fromorbit.com, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [RFC] Directly mapped xattr data & fs-verity
Message-ID: <20250109170356.GN1387004@frogsfrogsfrogs>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20250106154212.GA27933@lst.de>
 <prijdbxigrvzr5xsjviohbkb3gjzrans6yqzygncqrwdacfhcu@lhc3vtgd6ecw>
 <20250107165057.GA371@lst.de>
 <j7barlm3iix22ytjuu5y5mptfqzjme5pfdxk2a3vgb43ukoqxg@uhbobs5fs2uz>
 <20250109073908.GL1387004@frogsfrogsfrogs>
 <20250109074403.GA18326@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109074403.GA18326@lst.de>

On Thu, Jan 09, 2025 at 08:44:03AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 08, 2025 at 11:39:08PM -0800, Darrick J. Wong wrote:
> > > > 
> > > > Maybe we can used it for $HANDWAVE is not a good idea. 
> > > 
> > > > Hash based verification works poorly for mutable files, so we'd
> > > > rather have a really good argument for that.
> > > 
> > > hmm, why? Not sure I have an understanding of this
> > 
> > Me neither.  I can see how you might design file data block checksumming
> > to be basically an array of u32 crc[nblocks][2].  Then if you turned on
> > stable folios for writeback, the folio contents can't change so you can
> > compute the checksum of the new data, run a transaction to set
> > crc[nblock][0] to the old checksum; crc[nblock][1] to the new checksum;
> > and only then issue the writeback bio.
> 
> Are you (plural) talking about hash based integrity protection ala
> fsverity or checksums.  While they look similar in some way those are
> totally different things!  If we're talking about "simple" data
> checksums both post-EOF data blocks and xattrs are really badly wrong,
> as the checksum need to be assigned with the physical block due to
> reflinks, not the file.  The natural way to implement them for XFS
> if we really wanted them would be a new per-AG/RTG metabtree that
> is indexed by the agblock/rgblock.

Agreed.  For simple things like crc32 I would very much rather we stuff
them in a per-group btree because we only have to store the crc once in
the filesystem and now it protects all owners of that block.  In theory
the double-crc scheme would work fine for untorn data block writes, I
think.

I only see a reason for per-file hash structures in the dabtree if the
hashes themselves have some sort of per-file configuration (like
distributor-signed merkle trees or whatever).  I asked Eric Biggers if
he had any plans for mutable fsverity files and he said no.

> > But I don't think that works if you crash.  At least one of the
> > checksums might be right if the device doesn't tear the write, but that
> > gets us tangled up in the untorn block writes patches.  If the device
> > does not guarantee untorn writes, then you probably have to do it the
> > way the other checksumming fses do it -- write to a new location, then
> > run a transaction to store the checksum and update the file mapping.
> 
> Yes.  That's why for data checksums you'd always need to either write
> out of place (as with the pending zoned allocator) or work with intent /
> intent done items.  That's assuming you can't offload the atomicy to the
> device by uisng T10 PI or at least per-block metadata that stores the
> checksum.  Which would also remove the need for any new file system
> data struture, but require enterprise hardware that supports PI or
> metadata.

<nod>

--D
