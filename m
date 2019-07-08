Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37234 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729474AbfGHVe0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jul 2019 17:34:26 -0400
Date: Mon, 8 Jul 2019 23:34:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 19/24] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190708213423.GA18177@lst.de>
References: <20190605191511.32695-1-hch@lst.de> <20190605191511.32695-20-hch@lst.de> <20190708073740.GI7689@dread.disaster.area> <20190708161919.GN1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708161919.GN1404256@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Jul 08, 2019 at 09:19:19AM -0700, Darrick J. Wong wrote:
> So I think the solution is that we have to call submit_bio_wait on that
> very first bio (bio0) since the bios created in the inner loop will be
> chained to it... ?  Thoughts/flames/"go finish your morning coffee"?

I think we could also just turn the direction of the chaining around,
then the newly allocated bio is the "parent" to the previous one and
we can simply wait for the last one.  Something like the patch below,
running it through xfstests now, and then after that I'll add a way
to inject chaining even into relatively small I/Os to actually
test this code path:

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 757c1d9293eb..e2148f2d5d6b 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -43,7 +43,7 @@ xfs_rw_bdev(
 			bio_copy_dev(bio, prev);
 			bio->bi_iter.bi_sector = bio_end_sector(prev);
 			bio->bi_opf = prev->bi_opf;
-			bio_chain(bio, prev);
+			bio_chain(prev, bio);
 
 			submit_bio(prev);
 		}
