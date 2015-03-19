Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5FB247F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 17:59:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3225AC003
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 15:59:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HVPbfrp4rdiXC5BA for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 15:59:39 -0700 (PDT)
Date: Fri, 20 Mar 2015 09:59:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxfs: don't write uninitialized heap contents into new
	directory blocks
Message-ID: <20150319225917.GJ10105@dastard>
References: <20150318232159.GA24608@birch.djwong.org>
	<20150319182834.GI11669@laptop.bfoster>
	<20150319210250.GF24608@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150319210250.GF24608@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Mar 19, 2015 at 02:02:50PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 19, 2015 at 02:28:34PM -0400, Brian Foster wrote:
> > On Wed, Mar 18, 2015 at 04:21:59PM -0700, Darrick J. Wong wrote:
> > > When we're initializing a new directory block, zero the buffer
> > > contents to avoid writing random heap contents (and crc thereof)
> > > to disk.  This eliminates a few valgrind complaints in xfs_repair.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > 
> > Well it seems Ok to me:
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > 
> > ... but I do notice that we start ending up with multiple memset() calls
> > throughout these codepaths. E.g., xfs_dir3_data_init() memsets the
> > target bytes for the header if crc is enabled, xfs_dir3_leaf_get_buf()
> > calls xfs_dir3_leaf_init() which does something similar, etc.
> > 
> > I wonder if we should just zero the buffer content unconditionally on
> > allocation?
> 
> I thought about that too -- certainly we could zero b_addr as soon as it's
> allocated in __initbuf, which would shut up Valgrind.  I think this is what
> Dave was getting at when he suggested __libxfs_getbufr(), even though that
> function only frees b_addr if it touches it at all.

It frees b_addr only if the buffer found on the free list does not
match the length of the new buffer. Otherwise it just reuses it
directly. It probably doesn't matter if zeroing is done in
__initbuf, it is always called after __libxfs_getbufr() returns a
buffer handle, anyway.

> On the other hand, the
> next thing could happen is that the buffer is read in from disk, which makes
> the zeroing unnecessary.  The readbuf functions call the getbuf functions,
> which makes it difficult to tell from the getbuf functions what's going to
> happen next.
> 
> However, I think there's a second problem: what if the xfsbuf is reused without
> freeing the b_addr?

Yup, that's what __libxfs_getbufr() does ;)

> This seems possible if we read in the block, detach it
> from whatever points to it, and then we want to allocate it to a directory.
> The buffer's still in memory and it's still the right size, so we don't free
> b_addr; the init function doesn't overwrite the whole buffer, and now we've
> just leaked old disk contents.  Adding a memset to getbuf would fix this, but
> again at a cost of unnecessary zeroing.

Leaked the contents to whom?

In the kernel we don't care about stale contents in metadata buffers
as the contents cannot be directly read from userspace. i.e. there
is no vector for information leakage (other than through the root
user reading the bdev directly), so we don't need to zero buffers to
prevent information leakage either in userspace or the kernel...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
