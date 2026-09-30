Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1656D35A39F;
	Wed, 30 Sep 2026 07:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790752329; cv=none; b=eTzpJNiUfcGwymCuuP9O5/uptPK/+nHLH5nsvsb1rLcWKb4vklFkgMW5rPxT165kMdnilTdVWYCJTDswQSIlnAIawBNw4kSaEA/4xa610UMfE4vhjE0MwJivM32SVMGXBPqvpCXNilOUteRvGFo7w7K1dStRA0phkMnmXYf4JtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790752329; c=relaxed/simple;
	bh=pS349Z8xU4f/qTl88UNMf0Yp0/aQ9dO/kOg/fe9Xcpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jhjXqtT82EY+ugEXwiY4oHtQIfv5B/JNXnb8NKjUps4rnx/ZxV7E6E5RjpYtch3Av6Nn6CuHNYqedCK3t5H6Coq0D8//vKTjKk8KbaWYYT6gdjdF/KKE0hkhbZpcDGbrfXpKCjt/JPl5o46R05pG78FOXvBZmgOTaw+00gxQMO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oTI5d0xO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oTI5d0xO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32221F000FF;
	Wed, 30 Sep 2026 07:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790752327;
	bh=J333w9DUq7vV0t6ovavoHzB/qQLM0sK3o+lwAf70oeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oTI5d0xOoBTIJMbIaj/hl3xQJ1aE91L7OUElw9SJ62ek6saSJgEDLrTTqkptNifyR
	 R1eBnI2j1uf6P6Nxxa5t9hmMjDsoj5NW+UgWaBVmvvrMasrXRPZbxslMTCdy59rEcG
	 auBXFkRC8ubc+LlelDzoNp0F3EXPGfTrVg0VkGRlhY5a7ylr+V/q00zXFH+pXn54R3
	 Kkg+K1nxN2ulT6zlcNDq7aqC61AEP8Fiws8mCLgqvG0/3nC7ZPVkwnSHB7uRySnGFw
	 n3cMzYeol+p8Cal64CJiaqV20zKlNiBiZELo5H4H3SVUIGIhQ/t4lb984zzV15cmtc
	 EtdPh6DSUl0rQ==
Date: Wed, 30 Sep 2026 17:11:58 +1000
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: support for RT data checksums
Message-ID: <ary2PpSp1xTgrd3k@dread>
References: <20260924100032.2733101-1-hch@lst.de>
 <arWpyhFyV3ouYAEx@dread>
 <20260925062710.GA3798@lst.de>
 <armf05yfzhSBUsUh@dread>
 <20260928052436.GA18925@lst.de>
 <arvHFOjF-CD5Vd3g@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arvHFOjF-CD5Vd3g@dread>

On Wed, Sep 30, 2026 at 12:11:32AM +1000, Dave Chinner wrote:
> My concerns about the checksum buffer transactionsi are about not
> using existing APIs. By open coding them, you've skipped all the
> transaction/BLI recursion detection. i.e. you've encoded an
> assumption that a buffer will never get relogged within a given
> transaction. You've also encoded that external values bound
> memcpy()s in to the buffer and logging ranges to within the buffer
> length, but the buffer length itself is never checked. 
> 
> I don't know enough about the design to validate these assumptions,
> and there is no documentation (code, comments or commit messages)
> describing why the code is safe the way it is written...

After a day having this stuff percolate through my brain, I realised
why the CSUM logging code and the BLI_PREALLOC hack just didn't seem
right.

TL;DR: csum record logging should use the ICREATE item + ordered
buffer model for efficient one-shot updates to the csum buffers.

Long story:

+/*
+ * Size of a RT data checksum block.  Data reads must be contained in a single
+ * block, so this should be fairly large.
+ *
+ * The default is 32k, matching the default inode cluster size and the maximum
+ * memory allocation the Linux MM can handle in the fast path.  64k is primarily
+ * there so that his value never needs to be below the FSB size, even for 64k
+ * blocks.
+ */
+#define XFS_RTCSUM_BSIZE_LOG_MIN	15
+#define XFS_RTCSUM_BSIZE_LOG_MAX	16

My initial thought was that on disk format structures shouldn't be
defined by the limitations of the OS memory allocation, but <shrug>.
It kept nagging at me, though.

I looked more closely at what XFS_BLI_PREALLOC did to try to
understand why it existed.  It triggers a max-sized CIL logvec
structure for the buffer object. For a 32kB buffer logged as a
single contiguous range, this ends up being about 32kB + a logvec
header, plus a log iovec, plus a BLF, plus a couple of ophdrs. So
it's about 32kB + 200-250 bytes.

That means the shadow buffer for a csum buffer is always considered
a costly allocation by the MM subsystem.

Shadow buffers are ephmeral - they disappear from the log item
whenever the CIL flushes. Hence as the item is repeatedly logged,
they often need to be reallocated becaus something else caused the
CIL to flush (e.g. a fsync operation).

Hence for csum BLI, if a CIL flush happens on a partially filled
buffer, a good amount of that shadow buffer will go unused. Then we
allocate another (costly) shadow buffer on the next update. If CIL
flushes happen frequently enough then we will be repeatedly doing
costly allocations for shadow buffers that we don't actually use.

Not ideal - I think that means the original "sized for mm fast path"
intent is really only valid for the read side of the csum
algorithms as implemented by the patchset.

Then it got me wondering, because the more I thought about it, the
more BLI_PREALLOC smelt of premature optimisation. CIL formatting
has lots of other overhead, especially when re....

Duh. Relogging.

The root cause of the performance issues is interaction of repeated
small delta updates to the buffer and the BLI relogging algorithms
that the CIL and AIL require for correct journal/metadata writeback
ordering. 

Worst case:  Start with an empty csum buffer, assuming no header for
simplicity, using crc32 (4 bytes) for each 4kB data block. The
relogging pattern looks like for single record updates (small
independent 4kB data writes):

	dirtys		dirtied range 	CIL formatting memcpy
T0	0-3		0-127		128 bytes
T1	4-7		0-127		128 bytes
...
T32	128-131		0-255		256 bytes
T33	132-135		0-255		256 bytes
....
T8191	32764-32767	0-32767		32768 bytes

If BLI_PREALLOC didn't exist, the shadow buffer would be reallocated
every 32 updates (i.e. every time the dirtied range increases). So,
for this worst case, that's a 1024 reallocs. Yes, I can see why
that's an obvious optimisation target.

However, what BLI_PREALLOC misses is the CIL formatting memcpy
overhead from the same relogging algorithm.

In this case, the first csum is copied into the shadow buffer 8192
times, even though it was only updated once.  A quick calculation of
how much csum data is actually copied in this scenario is:

$ val=0; for i in `seq 128 128 32768`; do let val+=$(( 32 * $i )); echo $i $val ; done |tail -1
32768 134742016
$

~128MB of csum data is memcpy()d from the buffer to the BLI logvec
to fully update a 32kB csum buffer.

Yes, that's worst case, but even if we update 32 records at a
time (128kB IOs on 4kb rtblksz), the relogging still copies 4MB of
csum data to fully log that 32kB csum buffer. It hurts, even on
decent sized write IOs.

Ok, we have a solution to this problem. I created ordered buffers
and one-shot log items to avoid the journalling overhead of static
inode buffer initialisation back in 2013. The ICREATE log item is
the one-shot log item that records a buffer should be initialised,
and the ordered buffer allows the modified buffer to be passed
through the journal to metadta writeback without it's contents being
logged.

Given that csum updates are a small, known size, non-overlapping
one-shot update to a buffer, they fit the same model that
ICREAT+ordered implements. Adding a new CSUM log item made up of a
format header and varible size csum payload region provides the
equivalent of the ICREAT item for journalled inode buffer
initialisation.

At runtime: the buffer is updated, ordered and joined to the
transaction. A CSUM item with the csum payload is built and logged.
The transaction commit pins the buffer in memory until the CSUM item
is in the journal, then the buffer gets pushed into the AIL at the
CSUM item LSN and the CSUM item is freed.

Hence we only need to copy csum items once. We don't need to
optimise away the overhead of relogging buffers with a constantly
growing dirty range. The shadow buffer is always sized by the number
of csum records being updated this transaction, and it never just
pushed to the journal underutilised.

So it appears to me that using a CSUM item and ordered buffers is a
far more CPU, memory and journal space efficient algorithm for
logging the csum updates. I suspect there may also be some potential
ordered buffer locking optimisations we can also do because nothing
ever reads from ordered buffers in the commit code path.

I'm going to wait for the design doc, though, before going any
further - I've spent enough time reverse engineering design and
algorithms from this patchset for now.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
