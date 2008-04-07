Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 14:51:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m37LpVlr032473
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 14:51:35 -0700
Date: Tue, 8 Apr 2008 07:52:03 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [Patch] unique per-AG inode generation number initialisation
Message-ID: <20080407215203.GB108924158@sgi.com>
References: <20080401231815.GW103491721@sgi.com> <20080407125738.GD27350@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407125738.GD27350@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 07, 2008 at 08:57:38AM -0400, Christoph Hellwig wrote:
> I don't really like this.  The chance to hit a previously used generation
> seems to high.

The chance to hit an existing generation number is almost non-existant.

The counter is incremented on every allocation and not just when
inode chunks are allocated on disk. Hence a series of "allocate
chunk, unlink + free chunk, realloc chunk" is guaranteed to get a
higher generation number on reallocation, as is the "allocate a
chunk, while [1] {allocate; unlink}, unlink chunk, reallocate
chunk." These are the issues that are causing use problems right
now.

The generation number won't get reused at all until it wraps at 2^32
allocations within the AG, and then you've got to have a chunk of inodes
get freed and reallocated at the same time the counter matches an inode
generation number. While not impossible, it'll be pretty rare....

> What about making the first few bits of each generation
> number a per-ag counter that's incremented anytime we deallocate an inode
> cluster?

First thing I considered - increment on chunk freeing is not
sufficient guarantee of short-term uniqueness. To guarantee short
term uniqueness, the generation number used to initialise the inode
chunk if it is immediately reallocated needs to be greater than the
maximum used by any inode in the chunk that got freed. Now the "counter"
becomes a "maximum generation number used in the AG" value. This
also adds significant complexity to xfs_icluster_free() as we have to
look at every inode in the chunk and not just the ones that are
in-core.

FWIW, the biggest complexity with this approach is wrapping - how do
you tell what the highest highest generation number in the inode
chunk being freed is when some have wrapped through zero?

I basically gave up on this approach because of the extra complexity
and nasty, untestable corner cases it introduced into code that is
already complex. A simple incrementing counter solves the short-term
uniqueness problem while still making it very hard to get duplicates in
the long term. If you really, really need long term uniqueness, then
use 'ikeep'.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
