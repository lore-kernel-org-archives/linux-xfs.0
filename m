Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CB98E7F4E
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 10:12:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC07A304032
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 08:12:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id z2LY6gHEJy3q3o3G (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2015 08:12:47 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t2UFCkCK010825
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 11:12:46 -0400
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t2UFCkLB025477
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 11:12:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 3/3] xfs: kill unnecessary firstused overflow check on
	attr3 leaf removal
Date: Mon, 30 Mar 2015 11:12:45 -0400
Message-Id: <1427728365-15842-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1427728365-15842-1-git-send-email-bfoster@redhat.com>
References: <1427728365-15842-1-git-send-email-bfoster@redhat.com>
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

xfs_attr3_leaf_remove() removes an attribute from an attr leaf block. If
the attribute nameval data happens to be at the start of the nameval
region, a new start offset (firstused) for the region is calculated
(since the region grows from the tail of the block to the start). Once
the new firstused is calculated, it is checked for zero in an apparent
overflow check.

Now that the in-core firstused is 32-bit, overflow is not possible and
this check can be removed. Since the purpose for this check is not
documented and appears to exist since the port to Linux, be conservative
and replace it with an assert.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 149ef3f..04e79d5 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1996,8 +1996,7 @@ xfs_attr3_leaf_remove(
 				tmp = be16_to_cpu(entry->nameidx);
 		}
 		ichdr.firstused = tmp;
-		if (!ichdr.firstused)
-			ichdr.firstused = tmp - XFS_ATTR_LEAF_NAME_ALIGN;
+		ASSERT(ichdr.firstused != 0);
 	} else {
 		ichdr.holes = 1;	/* mark as needing compaction */
 	}
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
