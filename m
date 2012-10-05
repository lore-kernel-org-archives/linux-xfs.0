Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95EEB6M053236 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 09:14:11 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n0IBYiWOV1GBrGsH for
	<xfs@oss.sgi.com>; Fri, 05 Oct 2012 07:15:37 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q95EFbDS025355
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:37 -0400
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q95EFa2U008184
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 09/10] xfs: add minimum file size filtering to eofblocks
	scan
Date: Fri,  5 Oct 2012 10:17:15 -0400
Message-Id: <1349446636-8611-10-git-send-email-bfoster@redhat.com>
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

Support minimum file size filtering in the eofblocks scan. The
caller must set the XFS_EOF_FLAGS_MINFILESIZE flags bit and minimum
file size value in bytes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fs.h     |    2 ++
 fs/xfs/xfs_icache.c |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 6ef9111..6d42b0d 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -347,12 +347,14 @@ struct xfs_eofblocks {
 	__u32		eof_flags;
 	__u32		eof_q_id;
 	__u32		eof_q_type;
+	__u32		eof_min_file_size;
 	unsigned char	pad[12];
 };
 
 /* eof_flags values */
 #define XFS_EOF_FLAGS_SYNC		0x01	/* sync/wait mode scan */
 #define XFS_EOF_FLAGS_QUOTA		0x02	/* filter by quota id */
+#define XFS_EOF_FLAGS_MINFILESIZE	0x04	/* filter by min file size */
 
 
 /*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b39970b..ffd7f86 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1216,6 +1216,11 @@ xfs_inode_free_eofblocks(
 		if (eofb->eof_flags & XFS_EOF_FLAGS_QUOTA &&
 		    !xfs_inode_match_quota_id(ip, eofb))
 			return 0;
+
+		/* skip the inode if the file size is too small */
+		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
+		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
+			return 0;
 	}
 
 	ret = xfs_free_eofblocks(ip->i_mount, ip, true);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
