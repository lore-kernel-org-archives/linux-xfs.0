Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88D3E7F8E
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 76150304089
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OBdUFZmOVKmdVEq5 for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:45 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVt-0003vV-Hj
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVt-0001LX-0N
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 27/48] xfs_db: disable modification for CRC enabled
	filessytems.
Date: Fri,  7 Jun 2013 10:25:50 +1000
Message-Id: <1370564771-4929-28-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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
