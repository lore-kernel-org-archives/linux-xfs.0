Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F38AF7F5F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 08:35:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C42B6304048
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 06:35:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id j3RirBcdKpaGaF4Z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Sep 2015 06:35:08 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 96445A83
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 13:35:07 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs_repair: update btree ptr when attr node level moves to
	next buffer
Date: Wed,  2 Sep 2015 09:35:06 -0400
Message-Id: <1441200906-37170-1-git-send-email-bfoster@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

xfs_repair walks the attribute fork btree for files with a significant
number of extended attributes. It creates a cursor, walks the leaf
blocks, and verifies the path from each leaf block back to the root of
the tree. Eryu reports that the following test causes xfs_repair to
report corruption on 512b filesystems:

	num_xattrs=577
	for ((i = 1; i <= $num_xattrs; i++)); do
		name="user.attr_$(printf "%04d" $i)"
		setfattr -n $name -v "val_$(printf "%04d" $i)" <file>
	done

xfs_repair complains that the block number of the leaf (level 0) does
not match the block number of the level 1 node block entry. This occurs
as soon as the left-most level 1 node block is completely processed and
the cursor is walked to the next level 1 block in the array. The problem
is that while verify_da_path() updates level 1 of the cursor to the next
level 1 buffer, it fails to correctly update the btree pointer to the
entry list of the new buffer. As a result, the child leaf block of the
next node block is incorrectly validated against the entry list of the
previous node block.

Update verify_da_path() to correctly update the btree pointer to the
entry list of the new node block when the cursor is walked forward at
higher (non-leaf) levels.

Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/attr_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 83a07a8..b76618a 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -562,7 +562,7 @@ verify_da_path(xfs_mount_t	*mp,
 		}
 
 		newnode = (xfs_da_intnode_t *)XFS_BUF_PTR(bp);
-		btree = M_DIROPS(mp)->node_tree_p(node);
+		btree = M_DIROPS(mp)->node_tree_p(newnode);
 		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, newnode);
 
 		/*
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
