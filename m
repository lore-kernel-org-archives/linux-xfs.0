Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6EkwUW065727 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 08:46:58 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rFYmiRDvvWuscHyS for
	<xfs@oss.sgi.com>; Tue, 06 Nov 2012 06:48:54 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA6EmsqJ025644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 09:48:54 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id qA6Emsrd028644
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 09:48:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v6 09/10] xfs: add minimum file size filtering to eofblocks
	scan
Date: Tue,  6 Nov 2012 09:50:46 -0500
Message-Id: <1352213447-59791-10-git-send-email-bfoster@redhat.com>
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

Support minimum file size filtering in the eofblocks scan. The
caller must set the XFS_EOF_FLAGS_MINFILESIZE flags bit and minimum
file size value in bytes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fs.h     |    6 ++++--
 fs/xfs/xfs_icache.c |   11 +++++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 88eb1bc..082b743 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -348,7 +348,8 @@ struct xfs_eofblocks {
 	uid_t		eof_uid;
 	gid_t		eof_gid;
 	prid_t		eof_prid;
-	__u32		pad[27];
+	__u64           eof_min_file_size;
+	__u32		pad[25];
 };
 
 /* eof_flags values */
@@ -356,9 +357,10 @@ struct xfs_eofblocks {
 #define XFS_EOF_FLAGS_UID		(1 << 1) /* filter by uid */
 #define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid */
 #define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by project id */
+#define XFS_EOF_FLAGS_MINFILESIZE	(1 << 4) /* filter by min file size */
 #define XFS_EOF_FLAGS_VALID	\
 	(XFS_EOF_FLAGS_SYNC|XFS_EOF_FLAGS_UID|XFS_EOF_FLAGS_GID| \
-	 XFS_EOF_FLAGS_PRID)
+	 XFS_EOF_FLAGS_PRID|XFS_EOF_FLAGS_MINFILESIZE)
 
 
 /*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d7372b1..6e63228 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1215,8 +1215,15 @@ xfs_inode_free_eofblocks(
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
-	if (eofb && !xfs_inode_match_id(ip, eofb))
-		return 0;
+	if (eofb) {
+		if (!xfs_inode_match_id(ip, eofb))
+			return 0;
+
+		/* skip the inode if the file size is too small */
+		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
+		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
+			return 0;
+	}
 
 	ret = xfs_free_eofblocks(ip->i_mount, ip, true);
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
