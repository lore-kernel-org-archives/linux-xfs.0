Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2C522083;
	Fri, 25 Sep 2026 00:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790294683; cv=none; b=AQahv4xLj+zxBq8zqef5hlqLMBBCOXDBNrp+moDxVLGsppkWoICzgFMKko+g7n3IX2i0NVywluqS9C6L/zg8OcByUANC/9EQHFrQtufSbmay4niqHh5wNoae/RDHdZ1T1UpcBpc7ZnPkyDlhbvt3fTlowwbVKSeNF61DdsKL28o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790294683; c=relaxed/simple;
	bh=I+ZQcAQ7XWpphXSFQ7RdvwDBO+zyWb4Rh4Hs14sriQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DSQaDDHwZIOPICeuEMZvUgRRcQM0Hnnrx8kpP+vLmj4Oqm8hFpaRIt9WiAJMft7IUpAoa7JZEdLv/ec8gZL9uAx7SH/GneGyDozbhtRcj+CygWpVmLGDGtwR3m0fVntXCvX1qX4XnSgi3tgIrVIVEYeg8JhoVmL0gYhWJ4ORl8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inFLBRqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inFLBRqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79AE1F000FF;
	Fri, 25 Sep 2026 00:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790294682;
	bh=0M1k0NUyTq+ikzJ3p6YuOB6AxC7bY+mvgKtRPD78rks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=inFLBRqEvR9yghWwURf4VcOQv+/Vv1weSAMPRs6qeNJn8PB3gIffg07miO4VoYRaB
	 8p1jAgRKwEjX4A0keQ0tNwAOcrpCXt8Cta++HIdyfeuLY0uTSETuPv1vbZewtpc+cO
	 sFwk5O80x00gfvvtl4rvGCXIJ/gg7C8DgtwN3jM21ZMQD9jrrSByFiGv+q9dMAoRcy
	 6R922fsslAsK6c6cFyFAVjDJEsejwXTAzNzOcg5iYofpWoMHJHx++RNmLyZKiQCD9q
	 lAUQwsGCW97EHiT2BUVHCjOCgzHMtSkKjllToW2ZX5ocrqBbU4Ezr/n7C+2atUHg6W
	 70gRB3izej+ZQ==
Date: Fri, 25 Sep 2026 00:04:40 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/21] xfs: define the RT data checksum on-disk format
Message-ID: <20260925000440.GA3191386@google.com>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-9-hch@lst.de>
 <20260924221359.GI2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924221359.GI2705364@frogsfrogsfrogs>

On Thu, Sep 24, 2026 at 03:13:59PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 24, 2026 at 11:59:40AM +0200, Christoph Hellwig wrote:
> > Add the on-disk format for the new RT data checksum format.
> > 
> > Keyed off a new read-only compat feature flag, this adds new fields to
> > the superblock to indicate the checksum algorithm used and the size of
> > the blocks containing the checksums.  These new fields reuse the
> > previously reserved padding to make efficient use of the space in the
> > on-disk superblock.
> > 
> > Data checksums are only supported on zoned RT devices, because they
> > require out of places writes to safely update the checksums for file
> > overwrites and a data/metadata split to be able to store the checksums
> > for a group in a file without causing recursion.  This means they can't
> > be supported directly on the data device at all, and only when using
> > the always_cow mode on regular RT devices, but that has no benefit
> > over the zoned allocator which is designed for out of place writes.
> > 
> > The initially supported data checksum algorithms are crc32c and crc64 as
> > specified by NVMe.  Both have extremely fast kernel implementations and
> > the strong data protection guarantees offered by CRC-style algorithms.
> > Both also happen to be support by NVMe for protection information so that
> > the userspace PI passthrough support (once extended to files on file
> > systems) can be reused to expose the checksums to applications and thus
> > provide true end-to-end data integrity.
> 
> And just to play the peanut gallery here, xxhash? <duck>

lib/xxhash.c is kind of outdated and just supports XXH32 and XXH64 with
generic C code.  CRCs of the same width would generally be better.

(CRCs used to be kind of slow.  But with carryless multiplication
instructions, which the kernel uses on most architectures, they're super
fast.  They also have "unlimited" parallelism, unlike XXH32 and XXH64,
which have a data dependency after each 4 words processed.) 

XXH3 could be more competitive and would also offer 128-bit hashes.  But
it seems it would be quite a bit of work to add XXH3 to the kernel.

Unless someone really wants 128-bit checksums for this feature, I think
the two options proposed here (CRC-32C and CRC64-NVME) sound good.

- Eric
