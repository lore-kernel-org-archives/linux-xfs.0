Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E6B457F37
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 01:21:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D4F318F8049
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 23:21:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5Uwg1qDhw8vBBFou for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 23:21:32 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VFI5D-0001bQ-Gj
	for xfs@oss.sgi.com; Fri, 30 Aug 2013 16:21:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VFI5D-0008Iy-G4
	for xfs@oss.sgi.com; Fri, 30 Aug 2013 16:21:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: dtype changed xfs_dir2_sfe_put_ino to
	xfs_dir3_sfe_put_ino
Date: Fri, 30 Aug 2013 16:21:20 +1000
Message-Id: <1377843681-31878-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1377843681-31878-1-git-send-email-david@fromorbit.com>
References: <1377843681-31878-1-git-send-email-david@fromorbit.com>
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

So fix up the export in xfs_dir2.h that is needed by userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
