Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 71A6229DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 21:09:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1754AC001
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 19:09:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	YwQhAA1KUo2aB4HD for <xfs@oss.sgi.com>;
	Tue, 04 Jun 2013 19:09:26 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Uk3AB-0006hu-30
	for xfs@oss.sgi.com; Wed, 05 Jun 2013 12:09:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Uk3A1-00039k-0w
	for xfs@oss.sgi.com; Wed, 05 Jun 2013 12:09:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: disable noattr2/attr2 mount options for CRC enabled
	filesystems
Date: Wed,  5 Jun 2013 12:09:09 +1000
Message-Id: <1370398150-12084-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1370398150-12084-1-git-send-email-david@fromorbit.com>
References: <1370398150-12084-1-git-send-email-david@fromorbit.com>
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

attr2 format is always enabled for v5 superblock filesystems, so the
mount options to enable or disable it need to be cause mount errors.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 Documentation/filesystems/xfs.txt |    3 +++
 fs/xfs/xfs_super.c                |   11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 3e4b3dd..83577f0 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -33,6 +33,9 @@ When mounting an XFS filesystem, the following options are accepted.
 	removing extended attributes) the on-disk superblock feature
 	bit field will be updated to reflect this format being in use.
 
+	CRC enabled filesystems always use the attr2 format, and so
+	will reject the noattr2 mount option if it is set.
+
   barrier
 	Enables the use of block layer write barriers for writes into
 	the journal and unwritten extent conversion.  This allows for
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ea341ce..3033ba5 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1373,6 +1373,17 @@ xfs_finish_flags(
 	}
 
 	/*
+	 * V5 filesystems always use attr2 format for attributes.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    (mp->m_flags & XFS_MOUNT_NOATTR2)) {
+		xfs_warn(mp,
+"Cannot mount a V5 filesystem as %s. %s is always enabled for V5 filesystems.",
+			MNTOPT_NOATTR2, MNTOPT_ATTR2);
+		return XFS_ERROR(EINVAL);
+	}
+
+	/*
 	 * mkfs'ed attr2 will turn on attr2 mount unless explicitly
 	 * told by noattr2 to turn it off
 	 */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
