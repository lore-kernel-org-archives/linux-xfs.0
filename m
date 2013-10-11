Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E56287F3F
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 14:11:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 953EA304048
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 12:11:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id aPPVDczGtob56qXQ for <xfs@oss.sgi.com>;
	Fri, 11 Oct 2013 12:11:23 -0700 (PDT)
Message-ID: <52584D56.7090902@sandeen.net>
Date: Fri, 11 Oct 2013 14:11:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/4] xfs: reject completely bogus remount options
References: <52584C8A.1060808@redhat.com>
In-Reply-To: <52584C8A.1060808@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

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

Note, not really sure what KM_* flag would be appropriate here,
if it fails, it really is ok, other than missing the verification.
But maybe that's too "nice?"

commit 72e6ddd901dc8a8ecb835324eb4e11b0d7ad8cf8
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Oct 11 14:03:59 2013 -0500

    xfs: reject completely bogus remount options
    
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

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 15188cc..00a06d6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1202,11 +1202,25 @@ xfs_fs_remount(
 	int			*flags,
 	char			*options)
 {
-	struct xfs_mount	*mp = XFS_M(sb);
+	struct xfs_mount	*mp = XFS_M(sb), *dummy_mp;
 	substring_t		args[MAX_OPT_ARGS];
 	char			*p;
 	int			error;
 
+	/*
+	 * Check all the mount options presented to be sure
+	 * there's nothing too crazy in there.  Non-remountable
+	 * but valid options are a different issue.
+	 */
+	dummy_mp = kmem_zalloc(sizeof(*dummy_mp), KM_MAYFAIL);
+	if (dummy_mp) {
+		dummy_mp->m_super = sb;
+		error = xfs_parseargs(dummy_mp, options);
+		kfree(dummy_mp);
+		if (error)
+			return -error;
+	}
+
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
