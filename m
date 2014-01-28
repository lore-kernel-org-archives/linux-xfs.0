Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2912E7F91
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 12:01:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDBD2304064
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 10:01:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nOsuBHH28c3gO8po for
	<xfs@oss.sgi.com>; Tue, 28 Jan 2014 10:01:35 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0SI1Yrf023497
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 13:01:34 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s0SI1YcN025396
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 13:01:34 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfstests: remove spurious line continuation from
	_require_xfs_crc
Date: Tue, 28 Jan 2014 13:01:32 -0500
Message-Id: <1390932092-44727-1-git-send-email-bfoster@redhat.com>
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

This causes the mkfs to fail and leads to tests being skipped.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 common/rc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 49c86de..e91568b 100644
--- a/common/rc
+++ b/common/rc
@@ -1180,7 +1180,7 @@ _require_xfs_mkfs_crc()
 #
 _require_xfs_crc()
 {
-	_scratch_mkfs_xfs -m crc=1 >/dev/null 2>&1 \
+	_scratch_mkfs_xfs -m crc=1 >/dev/null 2>&1
 	_scratch_mount >/dev/null 2>&1 \
 	   || _notrun "Kernel doesn't support crc feature"
 	umount $SCRATCH_MNT
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
