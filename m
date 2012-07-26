Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8trxD003211 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:55:53 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id xPksUqEvYjBAYNMB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:55:52 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q6Q8tpSu002584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 08:55:52 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q6Q8toPI008045
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 08:55:51 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q6Q8toYn021506 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:55:50 -0500
Message-ID: <501105EC.5050903@oracle.com>
Date: Thu, 26 Jul 2012 16:55:08 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v5 0/4] xfs: seek_data/seek_hole refinements
Reply-To: jeff.liu@oracle.com
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
To: xfs@oss.sgi.com

Hello,

This is the v5 patch set for xfs_seek_data/xfs_seek_hole refinements with lookup
the offset from page cache for desired type.

I split those changes to 4 patches this time, maybe it could facilitate the review process.

v4->v5:
* Introduce a new routine xfs_find_get_desired_pgoff() to search the desired offset from page cache
  for unwritten and delayed-allocation extents.  This function is mainly based on the original xfs_has_unwritten_buffer() but
  revised to be able to fetch a hole offset directly for the refinement of xfs_seek_hole().
* Remove type argument from xfs_seek_data()/xfs_seek_hole() as it is already indicated by those function naming explicitly.

v3->v4:
xfs_seek_hole() refinement, suggested by Mark and Christoph.
* refine xfs_seek_hole() with unwritten extents search, treat it as a hole if no data buffer was found from page cache.
* s/goto out/break/g, break out of the extent maps reading loop rather than 'go to', I must have got my head up in the clouds when writing v3.
* xfs_has_unwritten_buffer(), remove 'offset <= XFS_FSB_TO_B(mp, last))' from BH state checking branch.
  The page index offset might less than '*start', so we will miss a data extent if so.
* xfs_has_unwritten_buffer(), don't reset '*offset' to ZERO if no data buffer was found because of xfs_seek_hole() will call this function to
   examine an unwritten extent has data or not. If not, it will use the returned '*offset' as a hole offset.  So set '*offset' to zero in
   xfs_has_unwritten_buffer() will lead to wrong result.
* avoid re-starting the next round search in both xfs_seek_data() and xfs_seek_hole() if the end offset of the 2nd extent map is hit the EOF.
  So for SEEK_DATA, it means there is no data extent beyond the current offset and return ENXIO, for SEEK_HOLE, return the file size to
  indicate hitting EOF.   The comments were also changed(s/reading offset not beyond/reading offset not beyond or hit EOF/)accordingly.

v2->v3:
Tested by Mark, hit BUG() for continuous unwritten extents without data wrote.
* xfs_seek_data(), remove BUG() and having extents map search in loop.

v1->v2:
suggested by Mark.
* xfs_has_unwritten_buffer(), use the input offset instead of bmap->br_startoff to calculate page index for data buffer probing.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
