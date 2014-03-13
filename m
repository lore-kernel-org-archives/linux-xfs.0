Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 43D457F90
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 05:14:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C0038F8039
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 03:14:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id WXoP5qr4eKwTBalz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 03:14:33 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1WO2en-000837-DK
	for xfs@oss.sgi.com; Thu, 13 Mar 2014 10:14:33 +0000
Message-Id: <20140313101433.318632549@bombadil.infradead.org>
Date: Thu, 13 Mar 2014 03:13:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] common: add flink support to _require_xfs_io_command
References: <20140313101302.996355155@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0001-xfstests-add-flink-support-to-_require_xfs_io_comman.patch
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/rc b/common/rc
index 7f9db56..3bd4bcb 100644
--- a/common/rc
+++ b/common/rc
@@ -1318,6 +1318,10 @@ _require_xfs_io_command()
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
 			-c "fiemap -v" $testfile 2>&1`
 		;;
+	"flink" )
+		testio=`$XFS_IO_PROG -T -F -c "flink $testfile" \
+			$TEST_DIR 2>&1`
+		;;
 	*)
 		testio=`$XFS_IO_PROG -c "$command help" 2>&1`
 	esac
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
