Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E06227F3F
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 11:45:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6601DAC001
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 09:45:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1YqBoAL8fqLno35a for
	<xfs@oss.sgi.com>; Thu, 27 Jun 2013 09:45:56 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5RGjuJi032363
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 12:45:56 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests generic/285: find the correct block device name
Date: Fri, 28 Jun 2013 00:45:13 +0800
Message-Id: <1372351513-26892-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

If $TEST_DEV is a symlink to a device, most likely a lvm, generic/285
fails with the following error

+./tests/generic/285: line 53: /sys/fs/ext4/testvg-testlv1/extent_max_zeroout_kb: No such file or directory

Here TEST_DEV is /dev/mapper/testvg-testlv1

Fix it by following the link to find the correct device name.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/285 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/285 b/tests/generic/285
index 8078b1c..be31852 100755
--- a/tests/generic/285
+++ b/tests/generic/285
@@ -48,7 +48,7 @@ BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
 
 # Disable extent zeroing for ext4 as that change where holes are created
 if [ "$FSTYP" = "ext4" ]; then
-	DEV=`basename $TEST_DEV`
+	DEV=$(basename $(readlink -f $TEST_DEV))
 	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
 fi
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
