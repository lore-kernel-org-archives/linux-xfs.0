Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B5A8329E04
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 09:01:19 -0500 (CDT)
Message-Id: <20150821193241.973348815@gulag1.americas.sgi.com>
From: rjohnston@sgi.com
Subject: [PATCH 2/2] xfsdump: don't do pointer math twice
References: <20150821193047.661578219@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=fix-pointer-math-in-cb_add_inogrp.patch
Date: Fri, 21 Aug 2015 09:01:15 -0500 (CDT)
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

The pointer math when calculating the address for the call to memset
is incorrect, so we are clearing the wrong memory location.

i2gmap is of type i2gseg_t 

oldsize has already computed the pointer offset
	oldsize = inomap.hnkmaplen * SEGPERHNK * sizeof(i2gseg_t);
the memset call is using
	inomap.i2gmap + oldsize == &inomap.i2gmap[oldsize]
so we were doing the pointer math twice.

We already compensate for the length of each item in oldsize so
adding need to add a (char *) cast to the memset parameter.

---
 dump/inomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/dump/inomap.c
===================================================================
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -1143,7 +1143,7 @@ cb_add_inogrp( void *arg1, intgen_t fsfd
 				return -1;
 
 			/* zero the new portion of the i2gmap */
-			memset(inomap.i2gmap + oldsize,
+			memset((char *)inomap.i2gmap + oldsize,
 			       0,
 			       SEGPERHNK * sizeof(i2gseg_t));
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
