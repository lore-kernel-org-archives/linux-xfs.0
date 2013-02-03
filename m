Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C1FB47F54
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 04:20:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6020BAC001
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 02:20:32 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lVJCzhHt5JXNKiOO for
	<xfs@oss.sgi.com>; Sun, 03 Feb 2013 02:20:31 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r13AKRdl030070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 3 Feb 2013 05:20:28 -0500
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH 2/3] xfstests: Add new standard loop handling functions
Date: Sun,  3 Feb 2013 11:19:57 +0100
Message-Id: <1359886798-8818-2-git-send-email-tracek@redhat.com>
In-Reply-To: <1359886798-8818-1-git-send-email-tracek@redhat.com>
References: <1359886798-8818-1-git-send-email-tracek@redhat.com>
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
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>

Add _create_loop_device and _destroy_loop_device to uniformly handle
loopback devices.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 common.rc | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/common.rc b/common.rc
index 0cccb94..67a5e3a 100644
--- a/common.rc
+++ b/common.rc
@@ -1833,6 +1833,20 @@ _require_dumpe2fs()
 	fi
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
 ################################################################################
 
 if [ "$iam" != new -a "$iam" != bench ]
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
