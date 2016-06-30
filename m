Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 741897CA6
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 12:22:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3540730408A
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 10:22:43 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id bA63Pp87D1sGI7P8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 30 Jun 2016 10:22:41 -0700 (PDT)
Date: Thu, 30 Jun 2016 19:22:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: iomap infrastructure and multipage writes V5
Message-ID: <20160630172239.GA23082@lst.de>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
	<20160628002649.GI12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160628002649.GI12670@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 28, 2016 at 10:26:49AM +1000, Dave Chinner wrote:
> Christoph, it look slike there's an ENOSPC+ENOMEM behavioural regression here.
> generic/224 on my 1p/1GB RAM VM using a 1k lock size filesystem has
> significantly different behaviour once ENOSPC is hit withi this patchset.
> 
> It ends up with an endless stream of errors like this:

I've spent some time trying to reproduce this.  I'm actually getting
the OOM killer almost reproducible for for-next without the iomap
patches as well when just using 1GB of mem.  1400 MB is the minimum
I can reproducibly finish the test with either code base.

But with the 1400 MB setup I see a few interesting things.  Even
with the baseline, no-iomap case I see a few errors in the log:

[   70.407465] Filesystem "vdc": reserve blocks depleted! Consider increasing
reserve pool
size.
[   70.195645] XFS (vdc): page discard on page ffff88005682a988, inode 0xd3, offset 761856.
[   70.408079] Buffer I/O error on dev vdc, logical block 1048513, lost async
page write
[   70.408598] Buffer I/O error on dev vdc, logical block 1048514, lost async
page write
 27s

With iomap I also see the spew of page discard errors your see, but while
I see a lot of them, the rest still finishes after a reasonable time,
just a few seconds more than the pre-iomap baseline.  I also see the
reserve block depleted message in this case.

Digging into the reserve block depleted message - it seems we have
too many parallel iomap_allocate transactions going on.  I suspect
this might be because the writeback code will not finish a writeback
context if we have multiple blocks inside a page, which can
happen easily for this 1k ENOSPC setup.  I've not had time to fully
check if this is what really happens, but I did a quick hack (see below)
to only allocate 1k at a time in iomap_begin, and with that generic/224
finishes without the warning spew.  Of course this isn't a real fix,
and I need to fully understand what's going on in writeback due to
different allocation / dirtying patterns from the iomap change.


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 620fc91..d9afba2 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1018,7 +1018,7 @@ xfs_file_iomap_begin(
 		 * Note that the values needs to be less than 32-bits wide until
 		 * the lower level functions are updated.
 		 */
-		length = min_t(loff_t, length, 1024 * PAGE_SIZE);
+		length = min_t(loff_t, length, 1024);
 		if (xfs_get_extsz_hint(ip)) {
 			/*
 			 * xfs_iomap_write_direct() expects the shared lock. It

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
