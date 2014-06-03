Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 363887F3F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 09:49:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 199B58F8040
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 07:49:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9y3gtElrSdM1WgG9 for
	<xfs@oss.sgi.com>; Tue, 03 Jun 2014 07:49:41 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s53EndIk017570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 10:49:39 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s53End8q007347
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 10:49:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 2/4] xfs: support a union-based filter for eofblocks scans
Date: Tue,  3 Jun 2014 10:49:36 -0400
Message-Id: <1401806978-59205-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1401806978-59205-1-git-send-email-bfoster@redhat.com>
References: <1401806978-59205-1-git-send-email-bfoster@redhat.com>
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

The eofblocks scan inode filter uses intersection logic by default.
E.g., specifying both user and group quota ids filters out inodes that
are not covered by both the specified user and group quotas. This is
suitable for behavior exposed to userspace.

Scans that are initiated from within the kernel might require more broad
semantics, such as scanning all inodes under each quota associated with
an inode to alleviate low free space conditions in each.

Create the XFS_EOF_FLAGS_UNION flag to support a conditional union-based
filtering algorithm for eofblocks scans. This flag is intentionally left
out of the valid mask as it is not supported for scans initiated from
userspace.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fs.h     |  3 +++
 fs/xfs/xfs_icache.c | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index d34703d..ffdabc6 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -375,6 +375,9 @@ struct xfs_fs_eofblocks {
 #define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid */
 #define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by project id */
 #define XFS_EOF_FLAGS_MINFILESIZE	(1 << 4) /* filter by min file size */
+#define XFS_EOF_FLAGS_UNION		(1 << 5) /* union filter algorithm;
+						  * kernel only, not included in
+						  * valid mask */
 #define XFS_EOF_FLAGS_VALID	\
 	(XFS_EOF_FLAGS_SYNC |	\
 	 XFS_EOF_FLAGS_UID |	\
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ee87bcb..6be93e7 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1203,6 +1203,30 @@ xfs_inode_match_id(
 	return 1;
 }
 
+/*
+ * A union-based inode filtering algorithm. Process the inode if any of the
+ * criteria match. This is for global/internal scans only.
+ */
+STATIC int
+xfs_inode_match_id_union(
+	struct xfs_inode	*ip,
+	struct xfs_eofblocks	*eofb)
+{
+	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
+	    uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
+		return 1;
+
+	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
+	    gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
+		return 1;
+
+	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
+	    xfs_get_projid(ip) == eofb->eof_prid)
+		return 1;
+
+	return 0;
+}
+
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
@@ -1212,6 +1236,7 @@ xfs_inode_free_eofblocks(
 	int ret;
 	struct xfs_eofblocks *eofb = args;
 	bool need_iolock = true;
+	int match;
 
 	ASSERT(!eofb || (eofb && eofb->eof_scan_owner != 0));
 
@@ -1231,7 +1256,11 @@ xfs_inode_free_eofblocks(
 		return 0;
 
 	if (eofb) {
-		if (!xfs_inode_match_id(ip, eofb))
+		if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
+			match = xfs_inode_match_id_union(ip, eofb);
+		else
+			match = xfs_inode_match_id(ip, eofb);
+		if (!match)
 			return 0;
 
 		/* skip the inode if the file size is too small */
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
