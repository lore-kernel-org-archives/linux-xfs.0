Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B06A27F59
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 08:16:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 41F2FAC002
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 06:16:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7tbTkBbTBbQdE43W for
	<xfs@oss.sgi.com>; Fri, 28 Mar 2014 06:16:06 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2SDG5D5011937
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 09:16:05 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s2SDG5Oq015431
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 09:16:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/5] xfs: add scan owner field to xfs_eofblocks
Date: Fri, 28 Mar 2014 09:16:01 -0400
Message-Id: <1396012563-60973-4-git-send-email-bfoster@redhat.com>
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

The scan owner field represents an optional inode number that is
responsible for the current scan. The purpose is to identify that an
inode is under iolock and as such, the iolock shouldn't be attempted
when trimming eofblocks. This is an internal only field.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icache.c | 12 +++++++++++-
 fs/xfs/xfs_icache.h |  2 ++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d4e15db..bd0ab7d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1215,6 +1215,7 @@ xfs_inode_free_eofblocks(
 {
 	int ret;
 	struct xfs_eofblocks *eofb = args;
+	bool need_iolock = true;
 
 	if (!xfs_can_free_eofblocks(ip, false)) {
 		/* inode could be preallocated or append-only */
@@ -1234,6 +1235,15 @@ xfs_inode_free_eofblocks(
 
 		if (eofb->eof_flags & XFS_EOF_FLAGS_FLUSH)
 			filemap_flush(VFS_I(ip)->i_mapping);
+
+		/*
+		 * A scan owner implies we already hold the iolock. Skip it in
+		 * xfs_free_eofblocks() to avoid deadlock. This also eliminates
+		 * the possibility of EAGAIN being returned.
+		 */
+		if (eofb->eof_scan_owner != NULLFSINO &&
+		    eofb->eof_scan_owner == ip->i_ino)
+			need_iolock = false;
 	}
 
 	/*
@@ -1244,7 +1254,7 @@ xfs_inode_free_eofblocks(
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
-	ret = xfs_free_eofblocks(ip->i_mount, ip, true);
+	ret = xfs_free_eofblocks(ip->i_mount, ip, need_iolock);
 
 	/* don't revisit the inode if we're not waiting */
 	if (ret == EAGAIN && !(flags & SYNC_WAIT))
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 9ed68bb..4387b1d 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -27,6 +27,7 @@ struct xfs_eofblocks {
 	kgid_t		eof_gid;
 	prid_t		eof_prid;
 	__u64		eof_min_file_size;
+	xfs_ino_t	eof_scan_owner;
 };
 
 #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
@@ -86,6 +87,7 @@ xfs_fs_eofblocks_from_user(
 	dst->eof_flags = src->eof_flags;
 	dst->eof_prid = src->eof_prid;
 	dst->eof_min_file_size = src->eof_min_file_size;
+	dst->eof_scan_owner = NULLFSINO;
 
 	dst->eof_uid = INVALID_UID;
 	if (src->eof_flags & XFS_EOF_FLAGS_UID) {
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
