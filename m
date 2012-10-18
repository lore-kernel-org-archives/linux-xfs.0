Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9I8iFLo168633 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 03:44:15 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OZlmBB5uaX2kAbBI for
	<xfs@oss.sgi.com>; Thu, 18 Oct 2012 01:45:54 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9I8jrAE019256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 04:45:53 -0400
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH 1/3] Add new standard loop handling functions
Date: Thu, 18 Oct 2012 10:45:44 +0200
Message-Id: <1350549946-17192-1-git-send-email-tracek@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>

Add _create_loop_device and _destroy_loop_device to uniformly handle
loopback devices.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 common.rc | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/common.rc b/common.rc
index 966fc93..b5edd22 100644
--- a/common.rc
+++ b/common.rc
@@ -1804,6 +1804,21 @@ _test_batched_discard()
 	$FSTRIM_PROG ${1} &>/dev/null
 }
 
+_create_loop_device()
+{
+	file=$1
+	dev=`losetup -f`
+	losetup $dev $file || _fail "Cannot associate $file with $dev"
+	echo $dev
+}
+
+_destroy_loop_device()
+{
+	dev=$1
+	losetup -d $dev || _fail "Cannot destroy loop device $dev"
+}
+
+
 ################################################################################
 
 if [ "$iam" != new -a "$iam" != bench ]
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
