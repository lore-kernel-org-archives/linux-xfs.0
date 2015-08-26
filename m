Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E4DC77F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 17:29:55 -0500 (CDT)
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA6038F8033
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 15:29:55 -0700 (PDT)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by estes.americas.sgi.com (Postfix) with ESMTP id 999A1700262B
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 17:29:55 -0500 (CDT)
Message-ID: <77EDF3BA.60409@sgi.com>
From: rjohnston@sgi.com
Subject: [PATCH V3] xfsdump: prevent segfault in cb_add_inogrp
References: <20150924193241.975348815@gulag1.americas.sgi.com>
In-Reply-To: <20150924193241.975348815@gulag1.americas.sgi.com>
Content-Disposition: inline;
	filename=prevent-segfault-in-cb_add_inogrp-V3.patch
Date: Wed, 26 Aug 2015 17:29:55 -0500 (CDT)
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

Adding a bounds check (numsegs < 0) and switching to use array
index notation instead of calculating the pointer address twice
would resolve this issue. The unneeded local variable oldsize
can be removed as well.
---
V3:
Per review comments:
	add a bounds check after calculating numsegs:
		if (numsegs < 0)
			return -1;

	Remove the description that does not match the code and
	leave numsegs as is (intgen_t) 

 dump/inomap.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: b/dump/inomap.c
===================================================================
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -1126,13 +1126,14 @@ cb_add_inogrp( void *arg1, intgen_t fsfd
 
 		if (lastsegp->hnkoff == inomap.hnkmaplen) {
 			intgen_t numsegs;
-			intgen_t oldsize;
 
 			inomap.hnkmaplen++;
 			inomap.hnkmap = (hnk_t *)
 				realloc(inomap.hnkmap, inomap.hnkmaplen * HNKSZ);
 
 			numsegs = inomap.hnkmaplen * SEGPERHNK;
+			if (numsegs < 0)
+				return -1;
 			inomap.i2gmap = (i2gseg_t *)
 				realloc(inomap.i2gmap, numsegs * sizeof(i2gseg_t));
 
@@ -1140,10 +1141,7 @@ cb_add_inogrp( void *arg1, intgen_t fsfd
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
