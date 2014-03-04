Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F0A17F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B171304043
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:18 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8HqEmaN1imkh0dNK for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:17 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006HV-Kf
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-0006yQ-Jl
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/13] libxfs: sanitize sb_inopblock in xfs_mount_validate_sb
Date: Tue,  4 Mar 2014 19:51:46 +1100
Message-Id: <1393923117-9559-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1393923117-9559-1-git-send-email-david@fromorbit.com>
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
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

[userspace port]

xfs_mount_validate_sb doesn't check sb_inopblock for sanity
(as does its xfs_repair counterpart, FWIW).

If it's out of bounds, we can go off the rails in i.e.
xfs_inode_buf_verify(), which uses sb_inopblock as a loop
limit when stepping through a metadata buffer.

The problem can be demonstrated easily by corrupting
sb_inopblock with xfs_db and trying to mount the result:

# mkfs.xfs -dfile,name=fsfile,size=1g
# xfs_db -x fsfile
xfs_db> sb 0
xfs_db> write inopblock 512
inopblock = 512
xfs_db> quit

# mount -o loop fsfile  mnt
and we blow up in xfs_inode_buf_verify().

With this patch, we get a (very noisy) corruption error,
and fail the mount as we should.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_sb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 16088a6..4be7366 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -258,6 +258,7 @@ xfs_mount_validate_sb(
 	    sbp->sb_inodelog < XFS_DINODE_MIN_LOG			||
 	    sbp->sb_inodelog > XFS_DINODE_MAX_LOG			||
 	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
+	    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
 	    (sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog)	||
 	    (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE)	||
 	    (sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)	||
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
