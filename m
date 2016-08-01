Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A36B7D02
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 04:03:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6DC63304048
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 02:03:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rbkEob6WR8JziSpZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 02:03:00 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] generic/095: update warning whitelist
Date: Mon,  1 Aug 2016 11:02:56 +0200
Message-Id: <1470042176-31447-1-git-send-email-hch@lst.de>
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
To: fstests@vger.kernel.org
Cc: xfs@oss.sgi.com

The recent direct I/O path refactor changed the function name in the
racing read case.  Update the test case to handle the new name in
addition to the old one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/095 | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tests/generic/095 b/tests/generic/095
index c656ef1..4754992 100755
--- a/tests/generic/095
+++ b/tests/generic/095
@@ -125,9 +125,11 @@ $FIO_PROG $fio_config >>$seqres.full 2>&1
 filter_xfs_dmesg()
 {
 	local warn1="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_dio_aio_write.*"
-	local warn2="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_read_iter.*"
+	local warn2="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_dio_aio_read.*"
+	local warn3="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_read_iter.*"
 	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
-	    -e "s#$warn2#Intentional warnings in xfs_file_read_iter#"
+	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
+	    -e "s#$warn3#Intentional warnings in xfs_file_read_iter#"
 }
 
 # umount before checking dmesg in case umount triggers any WARNING or Oops
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
