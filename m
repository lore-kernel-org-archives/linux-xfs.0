Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 929527F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:14:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6134E304059
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 04:14:13 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	B90cjrN0K9pHMsvd for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 04:14:11 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UdIbw-0008Sy-Sj
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:14:08 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UdIbm-0005Ft-PP
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 27/30] xfs_db: disable modification for CRC enabled
	filessytems.
Date: Fri, 17 May 2013 21:13:22 +1000
Message-Id: <1368789205-19969-28-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

xfs_db does not have the IO infrastructure to calculate metadata
CRCs after modifying metadata. Hence xfs_db can only run in
read-only mode on filesystems with version 5 superblocks.

To fix this, xfs_db needs to have it's IO engine converted to use
the buffer based IO provided by libxfs rather than rolling it's own
IO routines. That is future work, so until this conversion is done,
only allow xfs_db to run in read-only mode on v5 filesystems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/init.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/db/init.c b/db/init.c
index 0e9e1a2..1033f3a 100644
--- a/db/init.c
+++ b/db/init.c
@@ -132,6 +132,21 @@ init(
 			exit(EXIT_FAILURE);
 	}
 
+	/*
+	 * Don't allow modifications to CRC enabled filesystems until we support
+	 * CRC recalculation in the IO path. Unless, of course, the user is in
+	 * the process of hitting us with a big hammer.
+	 */
+	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_5 &&
+	    !(x.isreadonly & LIBXFS_ISREADONLY)) {
+		fprintf(stderr, 
+	_("%s: modifications to %s are not supported in thi version.\n"
+	"Use \"-r\" to run %s in read-only mode on this filesystem .\n"),
+			progname, fsdevice, progname);
+		if (!force)
+			exit(EXIT_FAILURE);
+	}
+
 	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
 				LIBXFS_MOUNT_ROOTINOS | LIBXFS_MOUNT_DEBUGGER);
 	if (!mp) {
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
