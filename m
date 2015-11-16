Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 84E3A7CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 11:32:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C465304043
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 09:32:40 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cvXuy1HERrurIqff (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 09:32:39 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 2E0D78F29C
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 17:32:39 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: get mp from bma->ip in xfs_bmap code
Message-ID: <564A1335.6080304@redhat.com>
Date: Mon, 16 Nov 2015 11:32:37 -0600
MIME-Version: 1.0
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
Cc: Bill O'Donnell <billodo@redhat.com>

In my earlier commit

  c29aad4 xfs: pass mp to XFS_WANT_CORRUPTED_GOTO

I added some local mp variables with code which indicates that
mp might be NULL.  Coverity doesn't like this now, because the
updated per-fs XFS_STATS macros dereference mp.

I don't think this is actually a problem; from what I can tell,
we cannot get to these functions with a null bma->tp, so my NULL
check was probably pointless.  Still, it's not super obvious.

So switch this code to get mp from the inode on the xfs_bmalloca
structure, with no conditional, because the functions are already
using bmap->ip directly.

Addresses-Coverity-Id: 1339552
Addresses-Coverity-Id: 1339553
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 119c242..bb3c659 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1725,7 +1725,7 @@ xfs_bmap_add_extent_delay_real(
 	int			tmp_rval;	/* partial logging flags */
 	struct xfs_mount	*mp;
 
-	mp  = bma->tp ? bma->tp->t_mountp : NULL;
+	mp = bma->ip->i_mount;
 	ifp = XFS_IFORK_PTR(bma->ip, XFS_DATA_FORK);
 
 	ASSERT(bma->idx >= 0);
@@ -2939,7 +2939,7 @@ xfs_bmap_add_extent_hole_real(
 	int			state;	/* state bits, accessed thru macros */
 	struct xfs_mount	*mp;
 
-	mp = bma->tp ? bma->tp->t_mountp : NULL;
+	mp = bma->ip->i_mount;
 	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 
 	ASSERT(bma->idx >= 0);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
