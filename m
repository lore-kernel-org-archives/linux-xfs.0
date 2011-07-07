Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67GOPwG182380 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 11:24:25 -0500
Subject: Re: [PATCH 23/28] xfs: byteswap constants instead of variables
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110707110645.046387162@bombadil.infradead.org>
References: <20110707110535.205001532@bombadil.infradead.org>
	<20110707110645.046387162@bombadil.infradead.org>
Date: Thu, 7 Jul 2011 11:24:20 -0500
Message-ID: <1310055860.1980.23.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Thu, 2011-07-07 at 07:05 -0400, Christoph Hellwig wrote:
> Micro-optimize various comparisms by always byteswapping the constant
> instead of the variable, which allows to do the swap at compile instead
> of runtime.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ha!!!  You missed one!  File "fs/xfs/xfs_dir2_node.c"
lines 412-413 (after applying this patch):

  ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);

Also, xfs_magics[] in "fs/xfs/xfs_btree.c" could be
initialized with the pre-byte-swapped versions of
the constants (and the array should be given static
scope as well).

There are a few other things remaining which are
compared against constant values and they could
get the same treatment at some point. For example,
"fs/xfs/xfs_dir2_block.c" line 142:
  if (be16_to_cpu(enddup->freetag) != XFS_DIR2_DATA_FREE_TAG)

But I've glanced all of them below and they seem
to have been done correctly.  I scanned for matching
bit counts and the appropriate change from using
be.._to_cpu() on the left to cpu_to_be..() on
the right.  I notice that you dropped the byte
conversion in a comparison with 0 in one case
but not in all of them.

To be clear, I do *not* expect you to re-post
this one (and if you do, I'm not going to review
it again)...

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
