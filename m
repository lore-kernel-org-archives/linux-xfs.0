Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E513A7F69
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 09:33:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C571F304048
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 07:33:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AOzPg8pa3Ubn9jYH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2015 07:33:16 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 8834D2931EC
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 14:33:15 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t51EXFFN026121
	for <xfs@oss.sgi.com>; Mon, 1 Jun 2015 10:33:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] xfs: fix sparse inodes 32-bit compile failure
Date: Mon,  1 Jun 2015 10:33:13 -0400
Message-Id: <1433169194-41808-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433169194-41808-1-git-send-email-bfoster@redhat.com>
References: <1433169194-41808-1-git-send-email-bfoster@redhat.com>
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

The kbuild test robot reports the following compilation failure with a
32-bit kernel configuration:

	fs/built-in.o: In function `xfs_ifree_cluster':
	>> xfs_inode.c:(.text+0x17ac84): undefined reference to `__umoddi3'

This is due to the use of the modulus operator on a 64-bit variable in
the ASSERT() added as part of the following commit:

	xfs: skip unallocated regions of inode chunks in xfs_ifree_cluster()

This ASSERT() simply checks that the offset of the inode in a sparse
cluster is appropriately aligned. Since the maximum inode record offset
is 63 (for a 64 inode record) and the calculated offset here should be
something less than that, cast the offset value to a 32-bit type before
the mod to prevent the error.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4c054f6..16bd01b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2265,7 +2265,7 @@ xfs_ifree_cluster(
 		 * a sparse region.
 		 */
 		if ((xic->alloc & XFS_INOBT_MASK(inum - xic->first_ino)) == 0) {
-			ASSERT(((inum - xic->first_ino) %
+			ASSERT(((int)(inum - xic->first_ino) %
 				inodes_per_cluster) == 0);
 			continue;
 		}
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
