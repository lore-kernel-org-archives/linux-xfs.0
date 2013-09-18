Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E9C257F50
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 00:18:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76F0DAC004
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 22:18:07 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id HexQEknybanctN8f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 22:18:06 -0700 (PDT)
From: Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH] xfstests/btrfs: do not test btrfs/010 with autodefrag
Date: Wed, 18 Sep 2013 13:17:55 +0800
Message-Id: <1379481475-10842-1-git-send-email-bo.li.liu@oracle.com>
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
To: linux-btrfs@vger.kernel.org
Cc: xfs@oss.sgi.com

btrfs/010 is going to create a fragmented file, however, with autodefrag
this is impossible, so just skip the test when we're with autodefrag.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 tests/btrfs/010 |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tests/btrfs/010 b/tests/btrfs/010
index 371f1b8..608942d 100755
--- a/tests/btrfs/010
+++ b/tests/btrfs/010
@@ -37,6 +37,14 @@ _cleanup()
     rm -f $tmp.*
 }
 
+is_autodefrag_set()
+{
+	case "$MOUNT_OPTIONS" in
+		*autodefrag*) return 0;;
+	esac
+	return 1
+}
+
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
@@ -49,6 +57,10 @@ _supported_os Linux
 _require_scratch
 _require_command "/usr/sbin/filefrag"
 
+if is_autodefrag_set; then
+	_notrun "this test makes no sense with autodefrag"
+fi
+
 rm -f $seqres.full
 
 _scratch_mkfs > /dev/null 2>&1
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
