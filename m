Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8BE567F37
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2015 08:38:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1AB4BAC006
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2015 06:38:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DR9loOhHxu7MUEcu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Jun 2015 06:38:52 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 054848F27D
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2015 13:38:52 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t5MDcpUn015403
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2015 09:38:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: don't truncate attribute extents if no extents exist
Date: Mon, 22 Jun 2015 09:38:50 -0400
Message-Id: <1434980330-45272-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1434631741-50856-2-git-send-email-bfoster@redhat.com>
References: <1434631741-50856-2-git-send-email-bfoster@redhat.com>
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

The xfs_attr3_root_inactive() call from xfs_attr_inactive() assumes that
attribute blocks exist to invalidate. It is possible to have an
attribute fork without extents, however. Consider the case where the
attribute fork is created towards the beginning of xfs_attr_set() but
some part of the subsequent attribute set fails.

If an inode in such a state hits xfs_attr_inactive(), it eventually
calls xfs_dabuf_map() and possibly xfs_bmapi_read(). The former emits a
filesystem corruption warning, returns an error that bubbles back up to
xfs_attr_inactive(), and leads to destruction of the in-core attribute
fork without an on-disk reset. If the inode happens to make it back
through xfs_inactive() in this state (e.g., via a concurrent bulkstat
that cycles the inode from the reclaim state and releases it), i_afp
might not exist when xfs_bmapi_read() is called and causes a NULL
dereference panic.

A '-p 2' fsstress run to ENOSPC on a relatively small fs (1GB)
reproduces these problems. The behavior is a regression caused by:

6dfe5a0 xfs: xfs_attr_inactive leaves inconsistent attr fork state behind

... which removed logic that avoided the attribute extent truncate when
no extents exist. Restore this logic to ensure the attribute fork is
destroyed and reset correctly if it exists without any allocated
extents.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Here's v2 of the attr inactive fix with the additional comment requested
by Christoph. After beating my head against reproducing this with
xfstests a bit last week, I determined that selinux was a contributing
factor in my original fsstress reproducer. I found a
non-selinux/fsstress reproducer sequence, so I'll cook up an xfstest
based on that soon...

Brian

v2:
- Added comment to explain logic behind skipping the inval/truncate in
  the no attribute case.
v1: http://oss.sgi.com/archives/xfs/2015-06/msg00276.html

 fs/xfs/xfs_attr_inactive.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 69a154c..2bb959a 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -433,8 +433,14 @@ xfs_attr_inactive(
 	 */
 	xfs_trans_ijoin(trans, dp, 0);
 
-	/* invalidate and truncate the attribute fork extents */
-	if (dp->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
+	/*
+	 * Invalidate and truncate the attribute fork extents. Make sure the
+	 * fork actually has attributes as otherwise the invalidation has no
+	 * blocks to read and returns an error. In this case, just do the fork
+	 * removal below.
+	 */
+	if (xfs_inode_hasattr(dp) &&
+	    dp->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
 		error = xfs_attr3_root_inactive(&trans, dp);
 		if (error)
 			goto out_cancel;
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
