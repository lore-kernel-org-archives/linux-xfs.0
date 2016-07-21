Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E40747CA0
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:46:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 67187AC004
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:46:55 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id bJuiYGZ0DxdpxPMU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:46:54 -0700 (PDT)
Subject: [PATCH 05/17] common/reflink: actually test dedupe on scratch device
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jul 2016 16:46:48 -0700
Message-ID: <146914480842.11762.9490852645886489605.stgit@birch.djwong.org>
In-Reply-To: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
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
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

In _require_scratch_dedupe, test the scratch device, not the testdev.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/reflink |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/reflink b/common/reflink
index 4ec390d..1363971 100644
--- a/common/reflink
+++ b/common/reflink
@@ -107,7 +107,7 @@ _require_scratch_dedupe()
 	_scratch_mount
 	"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 65536" "$SCRATCH_MNT/file1" > /dev/null
 	"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 65536" "$SCRATCH_MNT/file2" > /dev/null
-	testio="$("$XFS_IO_PROG" -f -c "dedupe $TEST_DIR/file1 0 0 65536" "$TEST_DIR/file2" 2>&1)"
+	testio="$("$XFS_IO_PROG" -f -c "dedupe $SCRATCH_MNT/file1 0 0 65536" "$SCRATCH_MNT/file2" 2>&1)"
 	echo $testio | grep -q "Operation not supported" && \
 		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
 	echo $testio | grep -q "Inappropriate ioctl for device" && \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
