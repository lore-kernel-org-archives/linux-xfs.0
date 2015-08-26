Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 547D67F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 12:36:46 -0500 (CDT)
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3038AC009
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 10:36:42 -0700 (PDT)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by estes.americas.sgi.com (Postfix) with ESMTP id 8432E7002E03
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 12:36:42 -0500 (CDT)
Message-ID: <55EDF3BA.60409@sgi.com>
From: rjohnston@sgi.com
Subject: [PATCH V2] xfsdump: prevent segfault in cb_add_inogrp
References: <20150924193241.975348815@gulag1.americas.sgi.com>
In-Reply-To: <20150924193241.975348815@gulag1.americas.sgi.com>
Content-Disposition: inline;
	filename=prevent-segfault-in-cb_add_inogrp-V2.patch
Date: Wed, 26 Aug 2015 12:36:42 -0500 (CDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The call to memset will segfault because the offset for the first
parameter is done twice. We are using pointer math to do the
calculation.
The first time is when calculating oldsize, the size of i2gseg_t
is accounted for.
	oldsize = (numsegs - SEGPERHNK) * sizeof(i2gseg_t);
Then in the call to memset, oldsize is again multiplied by the size
of i2gmap_t.
	memset(inomap.i2gmap + oldsize, ...)
	
i2gmap holds the used inodes in each chunk. When there are 2^31 chunk
entries, it could describe 2^31 (1 inode/chunk)- 2^40 (64 inodes/chunk).

With 100s of millions of inodes there are enough entries to wrap the
32 bit variable oldsize.

Switching to use array index notation instead of calculating the
pointer address twice ;) would resolve this issue. The unneeded
local variable oldsize can be removed as well.

numsegs is used to calculate an array index, change it from a
signed int (intgen_t) to an unsigned (uint32_t).
---
 dump/inomap.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: b/dump/inomap.c
===================================================================
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -1125,8 +1125,7 @@ cb_add_inogrp( void *arg1, intgen_t fsfd
 		lastsegp->segoff = 0;
 
 		if (lastsegp->hnkoff == inomap.hnkmaplen) {
-			intgen_t numsegs;
-			intgen_t oldsize;
+			int32_t numsegs;
 
 			inomap.hnkmaplen++;
 			inomap.hnkmap = (hnk_t *)
@@ -1140,10 +1139,7 @@ cb_add_inogrp( void *arg1, intgen_t fsfd
 				return -1;
 
 			/* zero the new portion of the i2gmap */
-			oldsize = (numsegs - SEGPERHNK) * sizeof(i2gseg_t);
-
-			memset(inomap.i2gmap + oldsize,
-			       0,
+			memset(&inomap.i2gmap[numsegs - SEGPERHNK], 0,
 			       SEGPERHNK * sizeof(i2gseg_t));
 		}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
