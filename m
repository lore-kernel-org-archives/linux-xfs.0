Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95EEBb9053232 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 09:14:11 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vifFpkS8akoHoNWV for
	<xfs@oss.sgi.com>; Fri, 05 Oct 2012 07:15:37 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q95EFbtQ031590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:37 -0400
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q95EFa7U014856
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 08/10] xfs: add quota id filtering to eofblocks scan
Date: Fri,  5 Oct 2012 10:17:14 -0400
Message-Id: <1349446636-8611-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
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

Support quota ID filtering in the eofblocks scan. The caller must
set the XFS_EOF_FLAGS_QUOTA flags bit, quota ID and quota type. The
associated quota type must be enabled on the mounted filesystem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fs.h     |    3 +++
 fs/xfs/xfs_icache.c |   24 ++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c  |    8 ++++++++
 3 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 5f48b3e..6ef9111 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -345,11 +345,14 @@ typedef struct xfs_error_injection {
 struct xfs_eofblocks {
 	__u32		eof_version;
 	__u32		eof_flags;
+	__u32		eof_q_id;
+	__u32		eof_q_type;
 	unsigned char	pad[12];
 };
 
 /* eof_flags values */
 #define XFS_EOF_FLAGS_SYNC		0x01	/* sync/wait mode scan */
+#define XFS_EOF_FLAGS_QUOTA		0x02	/* filter by quota id */
 
 
 /*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 35efdda..b39970b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1171,6 +1171,22 @@ xfs_reclaim_inodes_count(
 }
 
 STATIC int
+xfs_inode_match_quota_id(
+	struct xfs_inode	*ip,
+	struct xfs_eofblocks	*eofb)
+{
+	unsigned int type = xfs_quota_type(eofb->eof_q_type);
+	if (type == XFS_DQ_USER)
+		return ip->i_d.di_uid == eofb->eof_q_id;
+	else if (type == XFS_DQ_GROUP)
+		return ip->i_d.di_gid == eofb->eof_q_id;
+	else if (type == XFS_DQ_PROJ)
+		return xfs_get_projid(ip) == eofb->eof_q_id;
+
+	return 0;
+}
+
+STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
@@ -1178,6 +1194,7 @@ xfs_inode_free_eofblocks(
 	void			*args)
 {
 	int ret;
+	struct xfs_eofblocks *eofb = args;
 
 	if (!xfs_can_free_eofblocks(ip, false)) {
 		/* inode could be preallocated or append-only */
@@ -1194,6 +1211,13 @@ xfs_inode_free_eofblocks(
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
+	if (eofb) {
+		/* filter by quota id */
+		if (eofb->eof_flags & XFS_EOF_FLAGS_QUOTA &&
+		    !xfs_inode_match_quota_id(ip, eofb))
+			return 0;
+	}
+
 	ret = xfs_free_eofblocks(ip->i_mount, ip, true);
 
 	/* don't revisit the inode if we're not waiting */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ad4352f..547363b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1613,6 +1613,14 @@ xfs_file_ioctl(
 		if (eofb.eof_version != XFS_EOFBLOCKS_VERSION)
 			return -XFS_ERROR(EINVAL);
 
+		if (eofb.eof_flags & XFS_EOF_FLAGS_QUOTA) {
+			unsigned int type = xfs_quota_type(eofb.eof_q_type);
+			if ((type == XFS_DQ_USER && !XFS_IS_UQUOTA_ON(mp)) ||
+			    (type == XFS_DQ_GROUP && !XFS_IS_GQUOTA_ON(mp)) ||
+			    (type == XFS_DQ_PROJ && !XFS_IS_PQUOTA_ON(mp)))
+				return -XFS_ERROR(EINVAL);
+		}
+
 		flags = (eofb.eof_flags & XFS_EOF_FLAGS_SYNC) ? SYNC_WAIT : SYNC_TRYLOCK;
 		error = xfs_icache_free_eofblocks(mp, flags, &eofb);
 		return -error;
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
