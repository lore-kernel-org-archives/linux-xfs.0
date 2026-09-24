Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C03F446066;
	Thu, 24 Sep 2026 22:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290391; cv=none; b=tmnEVdVs+J8fVH104tDyjK/RDw4cL5TU7cLe+4Ir033FFWP1lV/CCqfI9qNS84vtDgYnXdfGmD1it1xcgwiiBcTEOPmB8xsAqjTjzjJYI1mojHZ1ERlEOYwYEviJePxUq4Z59xdHjTPaKEuuedYIQhLPuPxRMneWhR4pItMG7o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290391; c=relaxed/simple;
	bh=U9tMMTuTepdpCJjPqgTa/dmc9MtzQNdsSJeusuThhh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PnvqKoWLqjHluGtPPz/dYb/LocXIXACghUXM94Z+bDiAWJfYbJrprzbRMiWO/xIlmNfZTJK9qnSwZ31i5r9coX9PidkC3cerU8f+nsWm1A2xh0bLq3U5MhJ06fMTKi+PBG7L+Lu9jPJ3asP67WM/36YbMcPGYMpiPYNSr5qGHnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FRSLaJHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FRSLaJHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C661F000FF;
	Thu, 24 Sep 2026 22:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790290387;
	bh=ZxfoMV2m5K5jA7hcjiGUODyyQvQWv/XLQ5pi39fAkEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FRSLaJHzS1hZhrAaCpDGJ+LWVHfR/70CT5yKPgEd5ZY+Bo9VBfcVJIRuqarWkbpe9
	 vSGAJ2LhDvlMlUk35YZeD2YMDdRv0THGgi2fMXJxKCKUDx6eTNQJxXDy8BW4805SZV
	 tKHAMxx2Mun7Nbvi448mFHeC6BDnHc5KnrlgOZ6vaLqd8ncO1awJZyNKIRYnni6R9h
	 5OvfZYnFtSTWOMbb/GAox2HZ3Yhij7FkuEgcIuAcSztsqmPYZIvPDDgBeEi+9ewKz2
	 zPYVDwMXqTHhTH78u58TTHhelGpS2wQODA5YqXyot+kQD23kVPFYDqhq7kI7G8Zn5H
	 SUcmv4SEZlzVQ==
Date: Fri, 25 Sep 2026 08:52:58 +1000
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: support for RT data checksums
Message-ID: <arWpyhFyV3ouYAEx@dread>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:32AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> data checksums provide an additional safeguard against silent data loss.
> 
> In classic XFS they were hard to support because they need to be
> atomically updated with the written data.  The zoned allocator solves
> that problem because it always writes out of place, and the checksums
> can be committed at the same as the metadata linking the newly written
> file data into place.  In theory, a conventional allocator could be used
> in combination with the always_cow option, but there are few upsides of
> this compared to using the zoned allocator.
> 
> Data checksums are stored in per-realtime group files in the metadir,
> similar to other modern RT metadata.  Unlike the checksum design in btrfs
> or some other file system, the checksums are associated with the
> physical blocks, and not with logical data in files.  This reduces the
> mapping overhead, and significantly reduces the write amplification,
> and also avoids duplicate checksums for reflinked files (although those
> are not yet supported with the zoned allocator anyway).
> 
> The initial version provides two checksums algorithms: crc32c and crc64.
> Both of those are cyclic redundancy check algorithms which provide known
> good detection of bit flips that is better than general purpose hash
> functions.  Both are not cryptographic hashes and thus do not provide any
> kind of protection against intentional tampering with the data.
> The crc32c parameters exactly match those use for xfs metadata checksums,
> and also those used by the default btrfs checksum, and the NVMe PI
> formats using crc32c.  The crc64 parameters exactly match those using
> the NVMe PI formats using crc64.  crc32c provides reasonable assurance
> for today's hardware, but might prove limiting for extremely large data
> sets, crc64 fills that void, but probably warrants using > 4k file system
> block sizes to amortize the overhead.

Ok, so this really needs a design doc to explain how it all works,
what the new on-disk format is, scope, constraints, etc, as the
first patch in the series (i.e. in
Documentation/filesystems/xfs/data_checksum_design.rst) so that we
have high level descriptions of the functionality being implemented.
Stuff like why certain crc alrgorithms are supported, how we can add
new ones in the future, constraints of doing so, how different sized
checksums are cleanly supported, etc will make doing such things
much easier.

There's new buffer and inode locking in transactions, and there's a
whole new buffer cache interface to "read a buffer", and that is
used to open code reading checksum buffers and joining them to a
transaction rather than using the existing xfs_trans_read_buf...()
interfaces.  That in itself needs careful consideration, and clear
justification for why it must be duplicated to stand outside all the
existing BLI/transaction APIs, especially given all the "use the new
async buf read interface to do sync buffer reads" behaviour across
the patchset that could just use the existing interfaces.

I'd also like to have the format of the new on disk log item format
structures clearly documented (because we're going to have to
validate them) at recovery time, and also have a clear explaination
of the data vs metadata ordering algorithms that ensures that
checksums are always valid in crash+recovery situations, especially
w.r.t. data integrity operations like fsync.

These are the sorts of details that we need to get right, and it's
really hard to extract the actual design intent from the code that
implements it to determine if the algorithms, ordering and recovery
strategies are solid.

Hence I'd like to see the actual design documented first, then we
can understand and review algorithms, etc, and then verify the code
matches the described algorithms, behaviours, etc. checksums are all
about data integrity, so I'd really like to be able to understand
how it is supposed to work and where it doesn't work. Being forced
to understand design and implementation descisions and constraints
by reverse engineering disjoint chunks of code is not an efficient
use of reviewer time...

Cheers,

-Dave.
-- 
Dave Chinner
dgc@kernel.org
