Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7FB328529
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:47:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34147304053
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:47:51 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id aBxBVLDDAYYVgDOp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:47:48 -0700 (PDT)
Subject: [PATCH 15/20] xfstests: fix unreferenced variables in generic/186
	and generic/187
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:47:36 -0700
Message-ID: <146612805661.25024.577635269102170354.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

From: Christoph Hellwig <hch@lst.de>

There is not i variable in scope, and the comments suggest the operation
is to be done on ${file}.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/186 |    2 +-
 tests/generic/187 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/generic/186 b/tests/generic/186
index 70a0280..5de120a 100755
--- a/tests/generic/186
+++ b/tests/generic/186
@@ -87,7 +87,7 @@ _fragment_freesp()
 
 	# Try again anyway
 	avail=`_get_available_space $SCRATCH_MNT`
-	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" ${file}.${i}
+	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" ${file}
 
 	# Punch out whatever we need
 	seq 1 $((nr * 4)) | while read f; do
diff --git a/tests/generic/187 b/tests/generic/187
index 25cbcd9..3f534c8 100755
--- a/tests/generic/187
+++ b/tests/generic/187
@@ -88,7 +88,7 @@ _fragment_freesp()
 
 	# Try again anyway
 	avail=`_get_available_space $SCRATCH_MNT`
-	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" ${file}.${i}
+	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" ${file}
 
 	# Punch out whatever we need
 	seq 1 $((nr * 4)) | while read f; do

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
