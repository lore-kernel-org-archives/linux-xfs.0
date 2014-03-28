Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B7AA7F59
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 08:16:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22D1B304075
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 06:16:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ON5pVOi2CxChe61z for
	<xfs@oss.sgi.com>; Fri, 28 Mar 2014 06:16:05 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2SDG5X4009888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 09:16:05 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s2SDG5IY013038
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 09:16:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/5] xfs: add flush flag to xfs_eofblocks
Date: Fri, 28 Mar 2014 09:16:00 -0400
Message-Id: <1396012563-60973-3-git-send-email-bfoster@redhat.com>
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

The flush flag allows the caller to issue a flush for scanned inodes. In
ENOSPC conditions caused by project quotas, a flush is required to free
up reserved metadata allocations.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fs.h     | 4 +++-
 fs/xfs/xfs_icache.c | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index c5fc116..fa3a58e 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -374,12 +374,14 @@ struct xfs_fs_eofblocks {
 #define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid */
 #define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by project id */
 #define XFS_EOF_FLAGS_MINFILESIZE	(1 << 4) /* filter by min file size */
+#define XFS_EOF_FLAGS_FLUSH		(1 << 5) /* issue a flush */
 #define XFS_EOF_FLAGS_VALID	\
 	(XFS_EOF_FLAGS_SYNC |	\
 	 XFS_EOF_FLAGS_UID |	\
 	 XFS_EOF_FLAGS_GID |	\
 	 XFS_EOF_FLAGS_PRID |	\
-	 XFS_EOF_FLAGS_MINFILESIZE)
+	 XFS_EOF_FLAGS_MINFILESIZE | \
+	 XFS_EOF_FLAGS_FLUSH)
 
 
 /*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7ff59c9..d4e15db 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1231,6 +1231,9 @@ xfs_inode_free_eofblocks(
 		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
 		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
 			return 0;
+
+		if (eofb->eof_flags & XFS_EOF_FLAGS_FLUSH)
+			filemap_flush(VFS_I(ip)->i_mapping);
 	}
 
 	/*
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
