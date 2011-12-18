Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIMDHjN254239 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 16:13:18 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	NEMb0yVNRKnvL0D2 for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 14:13:15 -0800 (PST)
Date: Mon, 19 Dec 2011 09:13:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/11] xfs: remove the i_new_size field in struct xfs_inode
Message-ID: <20111218221311.GG23662@dastard>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200132.299481659@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218200132.299481659@bombadil.infradead.org>
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

On Sun, Dec 18, 2011 at 03:00:12PM -0500, Christoph Hellwig wrote:
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
> 
> A downside is that we lose the support for parallel non-overlapping O_DIRECT
> appending writes that recently was added.  I don't think keeping the complex
> and fragile i_new_size infrastructure for this is a good tradeoff - if we
> really care about parallel appending writers we should investigate turning
> the iolock into a range lock, which would also allow for parallel
> non-overlapping buffered writers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
