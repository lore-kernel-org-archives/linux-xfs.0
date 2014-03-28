Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9EBD37F51
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 08:16:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 70E5630406A
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 06:16:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XWDWL7fszQ9dyBDG for
	<xfs@oss.sgi.com>; Fri, 28 Mar 2014 06:16:06 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2SDG5Be019372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 09:16:05 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s2SDG5N4003795
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 09:16:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/5] xfs: do eofb filtering before dirty check
Date: Fri, 28 Mar 2014 09:15:59 -0400
Message-Id: <1396012563-60973-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1396012563-60973-1-git-send-email-bfoster@redhat.com>
References: <1396012563-60973-1-git-send-email-bfoster@redhat.com>
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

Reorder xfs_inode_free_eofblocks() so the explicit eofb filtering (i.e.,
uid, etc.) occurs before the dirty mapping check. This facilitates the
addition of a flush flag.

If we want to issue a flush, we should do so after the filtering logic
but before the dirty check since a flush reduces the likelihood we skip
an inode due to a dirty mapping.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icache.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 98d3524..7ff59c9 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1223,14 +1223,6 @@ xfs_inode_free_eofblocks(
 		return 0;
 	}
 
-	/*
-	 * If the mapping is dirty the operation can block and wait for some
-	 * time. Unless we are waiting, skip it.
-	 */
-	if (!(flags & SYNC_WAIT) &&
-	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
-		return 0;
-
 	if (eofb) {
 		if (!xfs_inode_match_id(ip, eofb))
 			return 0;
@@ -1241,6 +1233,14 @@ xfs_inode_free_eofblocks(
 			return 0;
 	}
 
+	/*
+	 * If the mapping is dirty the operation can block and wait for some
+	 * time. Unless we are waiting, skip it.
+	 */
+	if (!(flags & SYNC_WAIT) &&
+	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
+		return 0;
+
 	ret = xfs_free_eofblocks(ip->i_mount, ip, true);
 
 	/* don't revisit the inode if we're not waiting */
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
