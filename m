Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C0217F47
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 06:52:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5C8F304032
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 04:52:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NXoYjTJtvv6vQARF for
	<xfs@oss.sgi.com>; Fri, 23 May 2014 04:52:32 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4NBqW85025563
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 23 May 2014 07:52:32 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s4NBqV7B029023
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 07:52:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 1/3] xfs: add scan owner field to xfs_eofblocks
Date: Fri, 23 May 2014 07:52:28 -0400
Message-Id: <1400845950-41435-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
References: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
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
index c48df5f..f4191f6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1211,6 +1211,7 @@ xfs_inode_free_eofblocks(
 {
 	int ret;
 	struct xfs_eofblocks *eofb = args;
+	bool need_iolock = true;
 
 	if (!xfs_can_free_eofblocks(ip, false)) {
 		/* inode could be preallocated or append-only */
@@ -1235,9 +1236,18 @@ xfs_inode_free_eofblocks(
 		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
 		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
 			return 0;
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
 
-	ret = xfs_free_eofblocks(ip->i_mount, ip, true);
+	ret = xfs_free_eofblocks(ip->i_mount, ip, need_iolock);
 
 	/* don't revisit the inode if we're not waiting */
 	if (ret == EAGAIN && !(flags & SYNC_WAIT))
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 9cf017b..152757f 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -27,6 +27,7 @@ struct xfs_eofblocks {
 	kgid_t		eof_gid;
 	prid_t		eof_prid;
 	__u64		eof_min_file_size;
+	xfs_ino_t	eof_scan_owner;
 };
 
 #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
@@ -84,6 +85,7 @@ xfs_fs_eofblocks_from_user(
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
