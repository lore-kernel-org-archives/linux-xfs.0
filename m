Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBDNGG0t178613 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 17:16:16 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43665156F8D1
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 15:16:14 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dI4EfxcWqtKfO9tB for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 15:16:14 -0800 (PST)
Date: Wed, 14 Dec 2011 10:16:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/11] xfs: remove the i_new_size field in struct xfs_inode
Message-ID: <20111213231611.GG3179@dastard>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155919.025710280@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111208155919.025710280@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 08, 2011 at 10:58:04AM -0500, Christoph Hellwig wrote:
> Now that we use the VFS i_size field throughout XFS there is no need for the
> i_new_size field any more given that the VFS i_size field gets updated
> in ->write_end before unlocking the page, and thus is a) always uptodate when
> writeback could see a page.  Removing i_new_size also has the advantage that
> we will never have to trim back di_size during a failed buffered write,
> given that it never gets updated past i_size.
> 
> Note that currently the generic direct I/O code only updates i_size after
> calling our end_io handler, which requires a small workaround to make
> sure di_size actually makes it to disk.  I hope to fix this properly in
> the generic code.

I think there's a couple of issues with the work around - the
generic code marks the inode dirty when it updates the inode size.
With your early setting of the size, it will no longer do this
because it doesn't see that it needs to update the inode size.
This may not be a problem if we mark the inode dirty elsewhere, but
I'm not sure we do in the direct IO path.

Apart from that, I don't see anything wrong with the change. I'll
wait for you to clarify whether we need to mark the inode dirty
before signing off on it, though....

> A downside is that we lose the support for parallel non-overlapping O_DIRECT
> appending writes that recently was added.  I don't think keeping the complex
> and fragile i_new_size infrastructure for this is a good tradeoff - if we
> really care about parallel appending writers we should investigate turning
> the iolock into a range lock, which would also allow for parallel
> non-overlapping buffered writers.

Yeah, i think we can live without that for the moment. Range locks
are a much better idea for many reasons (like concurrent buffered
write support).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
