Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E2867F67
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 12:05:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2ACC304062
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 10:05:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OHMGKrHDyqPvtf2D for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 10:05:50 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s42H5nIi008474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 2 May 2014 13:05:50 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s42H5ngY005992
	for <xfs@oss.sgi.com>; Fri, 2 May 2014 13:05:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/5] xfstests: add _require_xfs_[mkfs_]finobt() checks for
	finobt tests
Date: Fri,  2 May 2014 13:13:59 -0400
Message-Id: <1399050842-19633-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
References: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
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

Free inode btree tests must ensure that the userspace and kernel bits
are compatible. Add a couple checks for the associated support.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 common/rc | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/common/rc b/common/rc
index 5c13db5..66a3cb8 100644
--- a/common/rc
+++ b/common/rc
@@ -1113,6 +1113,24 @@ _require_xfs_crc()
 	umount $SCRATCH_MNT
 }
 
+# this test requires the finobt feature to be available in mkfs.xfs
+#
+_require_xfs_mkfs_finobt()
+{
+	_scratch_mkfs_xfs_supported -m crc=1,finobt=1 >/dev/null 2>&1 \
+	   || _notrun "mkfs.xfs doesn't have finobt feature"
+}
+
+# this test requires the xfs kernel support finobt feature
+#
+_require_xfs_finobt()
+{
+	_scratch_mkfs_xfs -m crc=1,finobt=1 >/dev/null 2>&1
+	_scratch_mount >/dev/null 2>&1 \
+	   || _notrun "Kernel doesn't support finobt feature"
+	umount $SCRATCH_MNT
+}
+
 # this test requires that external log/realtime devices are not in use
 #
 _require_nonexternal()
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
