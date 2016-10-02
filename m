Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43612 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbcJBTBm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2016 15:01:42 -0400
Date: Sun, 2 Oct 2016 12:01:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: XFS reflink trees updated for 4.9
Message-ID: <20161002190106.GC21076@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, amir73il@gmail.com

Seeing as 4.8 is probably going out today, here's the latest for-4.9 branch:

https://github.com/djwong/linux/tree/for-dave-for-4.9-9
https://github.com/djwong/xfsprogs/tree/for-dave-for-4.9-9
https://github.com/djwong/xfstests/tree/djwong-devel

I've rolled up all the comment fixes that have come in this week.
Thanks to everyone who's reviewed the patches (Dave, Christoph, and
Brian come to mind)!

I've also sped up stale CoW staging extent recovery by stashing all
those records in the right side of the refcount btree per a suggestion
from Dave on Friday afternoon.  It was a relatively small change, so
I didn't bother holding off, and everything still passes the same
tests they did before, AFAICT.

---

Dave: the two xfs_repair patches I posted yesterday are for xfsprogs
4.8.  One fixes some garbled rmap code that crashed when we
overestimated the freespace btree space requirements in phase5, and
needs to go in before the release.  The second patch re-adds the lost
blocks to the freesp btree so we get rid of those "sorry, lost XXX
blocks" messages.  That one isn't so urgent.

--D
