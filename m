Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Oct 2006 02:47:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9Q9llaG026405
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 02:47:49 -0700
Date: Thu, 26 Oct 2006 19:46:42 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [REVIEW 1 of 4] Clean up i_flags handling
Message-ID: <20061026094642.GM8394166@melbourne.sgi.com>
References: <20061024071723.GR11034@melbourne.sgi.com> <20061024213822.GA23909@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061024213822.GA23909@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, t-nagano@ah.jp.nec.com, xfs-dev@sgi.com

On Tue, Oct 24, 2006 at 10:38:22PM +0100, Christoph Hellwig wrote:
> > +static inline int
> > +__xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
> > +{
> > +	return (ip->i_flags & flags);
> > +}
> > +
> > +static inline int
> > +xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
> > +{
> > +	int ret;
> > +	spin_lock(&ip->i_flags_lock);
> > +	ret = __xfs_iflags_test(ip, flags);
> > +	spin_unlock(&ip->i_flags_lock);
> > +	return ret;
> 
> This is not actually guaranteed to work on machiens with very weak
> memory ordering.  Please use the *_bit routines from bitops.h instead.

Hmm - don't you have that the wrong way around?

Documentation/memory-barriers.txt:

...
Therefore, from (1), (2) and (4) an UNLOCK followed by an unconditional LOCK is
equivalent to a full barrier, but a LOCK followed by an UNLOCK is not.
....

But the bitops don't guarantee ordering or barriers e.g. from
include/asm-i386/bitops.h:

/**
 * set_bit - Atomically set a bit in memory
 * @nr: the bit to set
 * @addr: the address to start counting from
 *
 * This function is atomic and may not be reordered.  See __set_bit()
 * if you do not require the atomic guarantees.
 *
 * Note: there are no guarantees that this function will not be reordered
 * on non x86 architectures, so if you are writting portable code,
 * make sure not to rely on its reordering guarantees.
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 */

So I think the code is fine as it stands.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
