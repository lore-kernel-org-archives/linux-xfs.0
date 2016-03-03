Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 694207CB7
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 22:38:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3BFC48F8033
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 20:38:57 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AkKkGbagiAyIvIU5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2016 20:38:53 -0800 (PST)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs/137: require scratch to be CRC enabled XFS
Date: Thu,  3 Mar 2016 12:38:19 +0800
Message-Id: <1456979899-7221-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

This test is only valid for CRC enabled XFS, and test fails with
MKFS_OPTIONS="-m crc=0" being set (no mount failure detected).

Fix it by adding _require_scratch_xfs_crc, which ensures scratch device
has CRC support and enabled.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/xfs/137 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/137 b/tests/xfs/137
index f162264..dec9fc9 100755
--- a/tests/xfs/137
+++ b/tests/xfs/137
@@ -52,7 +52,7 @@ rm -f $seqres.full
 _supported_fs xfs
 _supported_os Linux
 _require_scratch
-_require_xfs_crc
+_require_scratch_xfs_crc
 _require_xfs_db_command "logformat"
 
 _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
