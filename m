Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5N1ZOCu141047 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 20:35:24 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64A62274F2
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 18:35:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	to56fQCOyvAO12O7 for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 18:35:21 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QZYpD-0003zZ-5D
	for xfs@oss.sgi.com; Thu, 23 Jun 2011 11:35:19 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QZYoy-0005xv-PQ
	for xfs@oss.sgi.com; Thu, 23 Jun 2011 11:35:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: prevent bogus assert when trying to remove
	non-existent attribute
Date: Thu, 23 Jun 2011 11:35:01 +1000
Message-Id: <1308792901-22880-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1308792901-22880-1-git-send-email-david@fromorbit.com>
References: <1308792901-22880-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

If the attribute fork on an inode is in btree format and has
multiple levels (i.e node format rather than leaf format), then a
lookup failure will trigger an assert failure in xfs_da_path_shift
if the flag XFS_DA_OP_OKNOENT is not set. This flag is used to
indicate to the directory btree code that not finding an entry is
not a fatal error. In the case of doing a lookup for a directory
name removal, this is valid as a user cannot insert an arbitrary
name to remove from the directory btree.

However, in the case of the attribute tree, a user has direct
control over the attribute name and can ask for any random name to
be removed without any validation. In this case, fsstress is asking
for a non-existent user.selinux attribute to be removed, and that is
causing xfs_da_path_shift() to fall off the bottom of the tree where
it asserts that a lookup failure is allowed. Because the flag is not
set, we die a horrible death on a debug enable kernel.

Prevent this assert from firing on attribute removes by adding the
op_flag XFS_DA_OP_OKNOENT to atribute removal operations.

Discovered when testing on a SELinux enabled system by fsstress in
test 070 by trying to remove a non-existent user.selinux attribute.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index c863753..01d2072 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -490,6 +490,13 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	args.whichfork = XFS_ATTR_FORK;
 
 	/*
+	 * we have no control over the attribute names that userspace passes us
+	 * to remove, so we have to allow the name lookup prior to attribute
+	 * removal to fail.
+	 */
+	args.op_flags = XFS_DA_OP_OKNOENT;
+
+	/*
 	 * Attach the dquots to the inode.
 	 */
 	error = xfs_qm_dqattach(dp, 0);
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
