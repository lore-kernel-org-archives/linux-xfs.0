Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41170 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbcKQULI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2016 15:11:08 -0500
Date: Thu, 17 Nov 2016 12:11:02 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [BUG] dd doesn't return on ENOSPC and hang when fulfilling
 rmapbt XFS
Message-ID: <20161117201102.GK16813@birch.djwong.org>
References: <20161117163515.GB27776@eguan.usersys.redhat.com>
 <20161117173639.GJ16813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161117173639.GJ16813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 17, 2016 at 09:36:39AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 18, 2016 at 12:35:15AM +0800, Eryu Guan wrote:
> > Hi all,
> > 
> > I hit a test hang in generic/224 when testing rmapbt enabled XFS on a
> > host that has non-zero sunit/swidth reported from underlying device. And
> > I simplified the reproducer to the following script, and the hang can be
> > reproduced on any host now.
> > 
> > -----
> > #!/bin/bash
> > 
> > dev=/dev/sda5
> > mnt=/mnt/xfs
> > 
> > mkfs -t xfs -m rmapbt=1 -d agcount=8,size=1g -f $dev
> 
> Hm.  I formatted with:
> mkfs.xfs -m rmapbt=1 -d sunit=4096,swidth=40960 -f /dev/sdf
> 
> (made up sunit numbers just to see how whacky it could get)
> 
> and got a different hang instead.  It looks like we are unable to
> allocate any blocks to the bmbt and various things blow up from
> there.  Will go retry with tracepoints on to see if we're running
> out of AG reservation or if we're really out of disk blocks or what.
> 
> Crash message attached at the end.

Hm.  Looking at the indlen calculations, I see that we don't include the
space that the rmapbt might need to store all the reverse mappings.  I
think this is a problem, since we decline delalloc reservations if (len
+ indlen) > fdblocks, but we potentially end up using more than indlen
blocks to map len blocks into the file, so the allocator goes nuts.

Eryu, does the following patch fix the problem you see?  I ran your
reproducer and mine and it fixed the problem in both cases.  I didn't
observe any issues running generic/224 either.

--D

---
From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: [PATCH] xfs: factor rmap btree size into the indlen calculations

When we're estimating the amount of space it's going to take to satisfy
a delalloc reservation, we need to include the space that we might need
to grow the rmapbt.  This helps us to avoid running out of space later
when _iomap_write_allocate needs more space than we reserved.  Eryu Guan
observed this happening on generic/224 when sunit/swidth were set.

Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b80a294..afedf96 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -49,6 +49,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
+#include "xfs_rmap_btree.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -190,8 +191,12 @@ xfs_bmap_worst_indlen(
 	int		maxrecs;	/* maximum record count at this level */
 	xfs_mount_t	*mp;		/* mount structure */
 	xfs_filblks_t	rval;		/* return value */
+	xfs_filblks_t   orig_len;
 
 	mp = ip->i_mount;
+
+	/* Calculate the worst-case size of the bmbt. */
+	orig_len = len;
 	maxrecs = mp->m_bmap_dmxr[0];
 	for (level = 0, rval = 0;
 	     level < XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK);
@@ -199,12 +204,20 @@ xfs_bmap_worst_indlen(
 		len += maxrecs - 1;
 		do_div(len, maxrecs);
 		rval += len;
-		if (len == 1)
-			return rval + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) -
+		if (len == 1) {
+			rval += XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) -
 				level - 1;
+			break;
+		}
 		if (level == 0)
 			maxrecs = mp->m_bmap_dmxr[1];
 	}
+
+	/* Calculate the worst-case size of the rmapbt. */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		rval += 1 + xfs_rmapbt_calc_size(mp, orig_len) +
+				mp->m_rmap_maxlevels;
+
 	return rval;
 }
