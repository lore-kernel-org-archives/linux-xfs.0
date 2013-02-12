Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 32ACA7F86
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 03:22:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25138304051
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 01:22:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KUCTTHF9NcHjTgks for
	<xfs@oss.sgi.com>; Tue, 12 Feb 2013 01:22:16 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1C9MFKd027432
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 04:22:15 -0500
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH 2/3 V2] Add new standard loop handling functions
Date: Tue, 12 Feb 2013 10:21:59 +0100
Message-Id: <1360660919-13535-1-git-send-email-tracek@redhat.com>
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

V1->V2: Fix possible race

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 common.rc | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/common.rc b/common.rc
index 0cccb94..2f4a9f4 100644
--- a/common.rc
+++ b/common.rc
@@ -1833,6 +1833,19 @@ _require_dumpe2fs()
 	fi
 }
 
+_create_loop_device()
+{
+	file=$1
+	dev=`losetup -f --show $file` || _fail "Cannot assign $file to a loop device"
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
