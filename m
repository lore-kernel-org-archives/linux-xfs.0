Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A89D7CA1
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 00:31:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8AA8DAC001
	for <xfs@oss.sgi.com>; Sun,  4 Sep 2016 22:31:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3CyUGsMKfBxip09u (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 04 Sep 2016 22:31:48 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs/279: filter scsi debug device correctly
Date: Mon,  5 Sep 2016 13:30:27 +0800
Message-Id: <1473053427-15498-1-git-send-email-eguan@redhat.com>
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
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

This test assumes scsi debug device is "/dev/sd." when doing the
filter, but that isn't always true, I've seen failure like

  -mkfs with opts: DEVICE
  +mkfs with opts: DEVICEl

So use $SCSI_DEBUG_DEV to match the correct scsi debug device name.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/xfs/279 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/279 b/tests/xfs/279
index cde7d21..9dee4cf 100755
--- a/tests/xfs/279
+++ b/tests/xfs/279
@@ -61,7 +61,7 @@ _wipe_device()
 _check_mkfs()
 {
 	echo "===================" 
-	echo "mkfs with opts: $@" | sed -e "s,/dev/sd.,DEVICE,"
+	echo "mkfs with opts: $@" | sed -e "s,$SCSI_DEBUG_DEV,DEVICE,"
 	$MKFS_XFS_PROG $@ 2>/dev/null > $tmp.mkfs.full
 	if [ $? -ne 0 ]; then
 		echo "Failed."
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
