Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18463 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932717AbdJRE6C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 00:58:02 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9I4w1rQ022772
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 04:58:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9I4w00g028126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 04:58:00 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9I4w0u2013854
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 04:58:00 GMT
Date: Tue, 17 Oct 2017 21:57:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfsdocs: fix description of directory free block nvalid and
 nused header fields
Message-ID: <20171018045759.GC4703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

The descriptions of the directory free block header's nvalid and nused
fields are backwards, so flip them.  While we're fixing them, augment
the description to relate it to the rest of the directory structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../XFS_Filesystem_Structure/directories.asciidoc  |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/design/XFS_Filesystem_Structure/directories.asciidoc b/design/XFS_Filesystem_Structure/directories.asciidoc
index 06d682e..23645a7 100644
--- a/design/XFS_Filesystem_Structure/directories.asciidoc
+++ b/design/XFS_Filesystem_Structure/directories.asciidoc
@@ -1221,10 +1221,14 @@ The magic number of the free block, ``XD2F'' (0x0x58443246).
 The starting directory block number for the bests array.
 
 *nvalid*::
-Number of elements in the bests array.
+Number of valid elements in the bests array.  This number must
+correspond with the number of directory blocks can fit under the inode
++di_size+.
 
 *nused*::
-Number of valid elements in the bests array.
+Number of used elements in the bests array.  This number must correspond
+with the number of directory blocks actually mapped under the inode
++di_size+.
 
 [source, c]
 ----
@@ -1262,10 +1266,14 @@ v3 directory block header.  The magic number is "XDF3" (0x0x58444633).
 The starting directory block number for the bests array.
 
 *nvalid*::
-Number of elements in the bests array.
+Number of valid elements in the bests array.  This number must
+correspond with the number of directory blocks can fit under the inode
++di_size+.
 
 *nused*::
-Number of valid elements in the bests array.
+Number of used elements in the bests array.  This number must correspond
+with the number of directory blocks actually mapped under the inode
++di_size+.
 
 *pad*::
 Padding to maintain alignment.
@@ -1304,9 +1312,9 @@ value is decremented and the associated +bests[]+ entry is set to 0xffff.
 * As the first data block always contains ``.'' and ``..'', it's invalid for the
 directory to have a hole at the start.
 
-* The freeindex's +hdr.nvalid+ should always be the same as the number of
+* The freeindex's +hdr.nused+ should always be the same as the number of
 allocated data directory blocks containing name/inode data and will always be
-less than or equal to +hdr.nused+.  The value of +hdr.nused+ should be the same
+less than or equal to +hdr.nvalid+.  The value of +hdr.nvalid+ should be the same
 as the index of the last data directory block plus one (i.e. when the last data
 block is freed, +nused+ and +nvalid+ are decremented).
 
