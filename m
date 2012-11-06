Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6EkwdP065730 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 08:46:58 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hssvfVuqYwlddYsO for
	<xfs@oss.sgi.com>; Tue, 06 Nov 2012 06:48:55 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA6EmsMO024883
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 09:48:54 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id qA6EmsCA002587
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 09:48:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v6 08/10] xfs: support multiple inode id filtering in
	eofblocks scan
Date: Tue,  6 Nov 2012 09:50:45 -0500
Message-Id: <1352213447-59791-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
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

Enhance the eofblocks scan code to filter based on multiply specified
inode id values. When multiple inode id values are specified, only
inodes that match all id values are selected.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icache.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 699d1b0..d7372b1 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1175,14 +1175,19 @@ xfs_inode_match_id(
 	struct xfs_inode	*ip,
 	struct xfs_eofblocks	*eofb)
 {
-	if (eofb->eof_flags & XFS_EOF_FLAGS_UID)
-		return ip->i_d.di_uid == eofb->eof_uid;
-	else if (eofb->eof_flags & XFS_EOF_FLAGS_GID)
-		return ip->i_d.di_gid == eofb->eof_gid;
-	else if (eofb->eof_flags & XFS_EOF_FLAGS_PRID)
-		return xfs_get_projid(ip) == eofb->eof_prid;
+	if (eofb->eof_flags & XFS_EOF_FLAGS_UID &&
+	    ip->i_d.di_uid != eofb->eof_uid)
+		return 0;
 
-	return 0;
+	if (eofb->eof_flags & XFS_EOF_FLAGS_GID &&
+	    ip->i_d.di_gid != eofb->eof_gid)
+		return 0;
+
+	if (eofb->eof_flags & XFS_EOF_FLAGS_PRID &&
+	    xfs_get_projid(ip) != eofb->eof_prid)
+		return 0;
+
+	return 1;
 }
 
 STATIC int
@@ -1210,10 +1215,7 @@ xfs_inode_free_eofblocks(
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
-	if (eofb &&
-	    (eofb->eof_flags & (XFS_EOF_FLAGS_UID|XFS_EOF_FLAGS_GID|
-			       XFS_EOF_FLAGS_PRID)) &&
-	    !xfs_inode_match_id(ip, eofb))
+	if (eofb && !xfs_inode_match_id(ip, eofb))
 		return 0;
 
 	ret = xfs_free_eofblocks(ip->i_mount, ip, true);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
