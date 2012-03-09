Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29056uM109320 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 18:05:06 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vF074F2JvlO4AwdZ for
	<xfs@oss.sgi.com>; Thu, 08 Mar 2012 16:05:05 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q29054t7014607
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 19:05:04 -0500
Message-ID: <4F59492F.6020007@redhat.com>
Date: Thu, 08 Mar 2012 18:05:03 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests: clean up scsi_debug module handling
References: <4F59461B.7040608@redhat.com>
In-Reply-To: <4F59461B.7040608@redhat.com>
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

2 little fixes to common scsi_debug handling.

* don't consider the scsi_debug module in use in
  _require, unless it can't be rmmod'd
* don't try to rmmod it in _put unless it is currently
  loaded

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Argh.

diff --git a/common.scsi_debug b/common.scsi_debug
index 9f9177c..a085a67 100644
--- a/common.scsi_debug
+++ b/common.scsi_debug
@@ -26,7 +26,7 @@ _require_scsi_debug()
 {
 	# make sure we have the module and it's not already used
 	modinfo scsi_debug 2>&1 > /dev/null || _notrun "scsi_debug module not found"
-	lsmod | grep -wq scsi_debug && _notrun "scsi_debug module in use"
+	lsmod | grep -wq scsi_debug && (rmmod scsi_debug || _notrun "scsi_debug module in use")
 	# make sure it has the features we need
 	# logical/physical sectors plus unmap support all went in together
 	modinfo scsi_debug | grep -wq sector_size || _notrun "scsi_debug too old"
@@ -58,5 +58,6 @@ _get_scsi_debug_dev()
 _put_scsi_debug_dev()
 {
 	sleep 1
+	lsmod | grep -wq scsi_debug || return
 	rmmod scsi_debug || _fail "Could not remove scsi_debug module"
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
