Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q290AVXb109661 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 18:10:32 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4LvMIBj9eRTTaBWN for
	<xfs@oss.sgi.com>; Thu, 08 Mar 2012 16:10:30 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q290AUtN022896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 19:10:30 -0500
Message-ID: <4F59461B.7040608@redhat.com>
Date: Thu, 08 Mar 2012 17:51:55 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: test for scsi_debug before trying to rmmod it
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Dave Chinner <dchinner@redhat.com>

_cleanup does _put_scsi_debug_dev but there's a chance
the module has already been removed in the non-error
case.

If it's not loaded, don't try to rmmod it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common.scsi_debug b/common.scsi_debug
index 9f9177c..08efa58 100644
--- a/common.scsi_debug
+++ b/common.scsi_debug
@@ -58,5 +58,6 @@ _get_scsi_debug_dev()
 _put_scsi_debug_dev()
 {
 	sleep 1
+	grep -q scsi_debug /proc/modules || return
 	rmmod scsi_debug || _fail "Could not remove scsi_debug module"
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
