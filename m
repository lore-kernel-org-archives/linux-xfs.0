Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B7BEA29DFB
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 21:16:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3749BAC002
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 19:16:04 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CWpaDegjh7eyPekO for <xfs@oss.sgi.com>;
	Sun, 01 Sep 2013 19:16:02 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1VGJgN-0008Kc-CF
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 12:15:59 +1000
Date: Mon, 2 Sep 2013 12:15:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH V2] xfs: dtype changed xfs_dir2_sfe_put_ino to
	xfs_dir3_sfe_put_ino
Message-ID: <20130902021559.GC23571@dastard>
References: <1377843681-31878-1-git-send-email-david@fromorbit.com>
	<1377843681-31878-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377843681-31878-2-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Fri, Aug 30, 2013 at 04:21:20PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So fix up the export in xfs_dir2.h that is needed by userspace.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Well, this patch now causes a compilation failure.  Why?
xfs_dir3_sfe_put_ino() got marked as static because it didn't have a
matching export.

Perhaps we should be a little less hasty in merging auto-generated
patches from random build-farms? The patch was wrong - fixing the
prototype like in v1 of this patch was the correct thing to do....

So, the updated patch below adds the revert.

Cheers,

Dave.

PS: Ben, when you merge a patch from a reply in an email thread,
can you please pull the commit subject line from the patch, not the
title of the email thread? One of the recent commits got it wrong.
i.e. commit 3780437 

"XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length), file:"

should have had the title

"xfs: fix calculation of the number of node entries in a dir3 node"

-- 
Dave Chinner
david@fromorbit.com

xfs: dtype changed xfs_dir2_sfe_put_ino to xfs_dir3_sfe_put_ino

From: Dave Chinner <dchinner@redhat.com>

So fix up the export in xfs_dir2.h that is needed by userspace.

<sigh>

Now xfs_dir3_sfe_put_ino has been made static. Revert 98f7462 ("xfs:
xfs_dir3_sfe_put_ino can be static") to being non static so that the
code shared with userspace is identical again.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
V2: revert 98f7462 so that xfs_dir3_sfe_put_ino is exported again to
match what userspace needs.

 fs/xfs/xfs_dir2.h    | 5 +++--
 fs/xfs/xfs_dir2_sf.c | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 768ddad..9910401 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -70,8 +70,9 @@ extern void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *sfp,
 		xfs_ino_t ino);
 extern xfs_ino_t xfs_dir3_sfe_get_ino(struct xfs_mount *mp,
 		struct xfs_dir2_sf_hdr *sfp, struct xfs_dir2_sf_entry *sfep);
-extern void xfs_dir2_sfe_put_ino( struct xfs_dir2_sf_hdr *,
-		struct xfs_dir2_sf_entry *sfep, xfs_ino_t ino);
+extern void xfs_dir3_sfe_put_ino(struct xfs_mount *mp,
+		struct xfs_dir2_sf_hdr *hdr, struct xfs_dir2_sf_entry *sfep,
+		xfs_ino_t ino);
 
 extern int xfs_dir2_isblock(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
 extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 579b56b..bb6e284 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -129,7 +129,7 @@ xfs_dir3_sfe_get_ino(
 	return xfs_dir2_sf_get_ino(hdr, xfs_dir3_sfe_inop(mp, sfep));
 }
 
-static void
+void
 xfs_dir3_sfe_put_ino(
 	struct xfs_mount	*mp,
 	struct xfs_dir2_sf_hdr	*hdr,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
