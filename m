Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A184C7F50
	for <xfs@oss.sgi.com>; Sat,  5 Oct 2013 21:25:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C600AC003
	for <xfs@oss.sgi.com>; Sat,  5 Oct 2013 19:25:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id i6ICgTeOIPZKwQca for
	<xfs@oss.sgi.com>; Sat, 05 Oct 2013 19:25:26 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r962PPJ4028896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 5 Oct 2013 22:25:25 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r962POLK022947
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 5 Oct 2013 22:25:25 -0400
Message-ID: <5250CA13.8040006@redhat.com>
Date: Sat, 05 Oct 2013 21:25:23 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: restrict 259 device sizes to multiples of 512
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
To: xfs-oss <xfs@oss.sgi.com>

Test 259 tries to make a loop device size which is 1 byte less
than 4T; losetup now warns that this makes little sense, and
the warning breaks the test output:

    +losetup: /mnt/test/259.image: warning: file does not fit into a 512-byte sector the end of the file will be ignored.

The RH QE testcase did originally use loopback, so
did not test anything other than 512 boundaries.

Just drop the 1-byte-shy case, because it produces a device
exactly the same size as the 512-bytes-shy case.

(FWIW, this is a regression test for the bug that
d943b11 mkfs: get size of device properly
fixed.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/xfs/259 b/tests/xfs/259
index 59eeaca..9c12ccf 100755
--- a/tests/xfs/259
+++ b/tests/xfs/259
@@ -48,7 +48,7 @@ testfile=$TEST_DIR/259.image
 
 # Test various sizes slightly less than 4 TB
 four_TB=$(_math "2^42")
-for del in 1 512 1024 1025 2048 4096; do
+for del in 512 1024 1025 2048 4096; do
 	ddseek=$(_math "$four_TB - $del")
 	echo "Trying to make (4 TB - $del) B long xfs fs image"
 	rm -f "$testfile"


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
