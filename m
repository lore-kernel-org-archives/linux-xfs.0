Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67GSSOd182580 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 11:28:28 -0500
Date: Thu, 7 Jul 2011 12:28:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 23/28] xfs: byteswap constants instead of variables
Message-ID: <20110707162824.GA7830@infradead.org>
References: <20110707110535.205001532@bombadil.infradead.org>
	<20110707110645.046387162@bombadil.infradead.org>
	<1310055860.1980.23.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310055860.1980.23.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jul 07, 2011 at 11:24:20AM -0500, Alex Elder wrote:
> On Thu, 2011-07-07 at 07:05 -0400, Christoph Hellwig wrote:
> > Micro-optimize various comparisms by always byteswapping the constant
> > instead of the variable, which allows to do the swap at compile instead
> > of runtime.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Ha!!!  You missed one!  File "fs/xfs/xfs_dir2_node.c"
> lines 412-413 (after applying this patch):
> 
>   ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);

I left a few where we are doing the same byteswap a little later again,
but this one doesn't seem to fall into the category.  Oh, I see why now:
my grep only found the _MAGIC and the byteswap on the same line.

> Also, xfs_magics[] in "fs/xfs/xfs_btree.c" could be
> initialized with the pre-byte-swapped versions of
> the constants (and the array should be given static
> scope as well).

Yeah, but let's keep this patch simple for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
