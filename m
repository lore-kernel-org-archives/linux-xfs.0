Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SMEbSJ179595 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 17:14:52 -0500
Date: Fri, 28 Aug 2009 18:15:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: fix unaligned access in libxfs
Message-ID: <20090828221530.GB17666@infradead.org>
References: <20090828153718.GA26409@infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83ABEF@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABEF@cf--amer001e--3.americas.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Gabriel Vlasiu <gabrielvlasiu@gmail.com>, xfs@oss.sgi.com

On Fri, Aug 28, 2009 at 04:39:49PM -0500, Alex Elder wrote:
> > +static inline __uint32_t __get_unaligned_be32(const __uint8_t *p)
> 
> 
> It would be nice for this interface (and others) to take a (void *)
> argument, but that would also mean immediately casting it to do
> pointer arithmetic portably.  Not a big deal.

the __ routines are internal implementation details, the kernel
has non-__ prefixed versions that take void pointers, but I didn't
bother to add them to xfsprogs as we only do unaligned access to
64bit values.

That beeing said I dislike the interface taking void pointers as
it removes important error checking.  The actually visible interface
should take __be16/32/64 types to enforce they are used on the right
type.  Once I get some time I will push for that in the kernel again,
but for xfsprogs I really do want to stick to the kernel interfaces so
that we can share the code unmodified.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
