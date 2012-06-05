Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55Gfca4103956 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 11:41:39 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P9yX5sbBqAoa5Of3 for
	<xfs@oss.sgi.com>; Tue, 05 Jun 2012 09:41:38 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q55GfbnU002097
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 12:41:37 -0400
Message-ID: <4FCE36C0.6070408@redhat.com>
Date: Tue, 05 Jun 2012 11:41:36 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: reject completely bogus remount options
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
Cc: Vijay Bellur <vbellur@redhat.com>

There's a long comment about handling non-remountable
options in xfs_fs_remount, but nothing addresses the case
of completely bogus mount options at remount time, which
can lead to some severe strangeness:

# for I in `seq 1 10`; do mount -o remount,noacl /mnt/test2; done
# for I in `seq 1 10`; do mount -o remount,badoption /mnt/test2; done
# grep sdb4 /etc/mtab
/dev/sdb4 /mnt/test2 xfs rw,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,badoption,badoption,badoption,badoption,badoption,badoption,badoption,badoption,badoption,badoption 0 0

This is a bit of a hack, but we can re-use xfs_parseargs()
with a dummy mount struct to just vet all of the remount
options which were passed in.  With this, we get a saner
result:

[44898.102990] EXT4-fs (sdb4): Unrecognized mount option "badoption" or missing value

if we try to remount with something ridiculous.

In the long run we should probably revamp a lot of the mount option
handling...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 9a72dda..0402f9c 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1157,11 +1157,22 @@ xfs_fs_remount(
 	int			*flags,
 	char			*options)
 {
-	struct xfs_mount	*mp = XFS_M(sb);
+	struct xfs_mount	*mp = XFS_M(sb), dummy_mp;
 	substring_t		args[MAX_OPT_ARGS];
 	char			*p;
 	int			error;
 
+	/*
+	 * Check all the mount options presented to be sure
+	 * there's nothing too crazy in there.  Non-remountable
+	 * but valid options are a different issue.
+	 */
+	memset(&dummy_mp, 0, sizeof(struct xfs_mount));
+	dummy_mp.m_super = sb;
+	error = xfs_parseargs(&dummy_mp, options);
+	if (error)
+		return -error;
+
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
