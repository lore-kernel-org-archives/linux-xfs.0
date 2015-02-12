Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EBB7E7F54
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 12:17:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7747BAC006
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 10:17:31 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cxEI56NUHX5G46UU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2015 10:17:30 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1CIHStf016488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:29 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1CIHSvW025870
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 04/18] xfs: add sparse inode chunk alignment superblock
	field
Date: Thu, 12 Feb 2015 13:17:11 -0500
Message-Id: <1423765045-15791-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1423765045-15791-1-git-send-email-bfoster@redhat.com>
References: <1423765045-15791-1-git-send-email-bfoster@redhat.com>
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

Add sb_spino_align to the superblock to specify sparse inode chunk
alignment. This also currently represents the minimum allowable sparse
chunk allocation size.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 6 +++---
 fs/xfs/libxfs/xfs_sb.c     | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 8eb7189..dbca93d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -170,7 +170,7 @@ typedef struct xfs_sb {
 	__uint32_t	sb_features_log_incompat;
 
 	__uint32_t	sb_crc;		/* superblock crc */
-	__uint32_t	sb_pad;
+	xfs_extlen_t	sb_spino_align;	/* sparse inode chunk alignment */
 
 	xfs_ino_t	sb_pquotino;	/* project quota inode */
 	xfs_lsn_t	sb_lsn;		/* last write sequence */
@@ -256,7 +256,7 @@ typedef struct xfs_dsb {
 	__be32		sb_features_log_incompat;
 
 	__le32		sb_crc;		/* superblock crc */
-	__be32		sb_pad;
+	__be32		sb_spino_align;	/* sparse inode chunk alignment */
 
 	__be64		sb_pquotino;	/* project quota inode */
 	__be64		sb_lsn;		/* last write sequence */
@@ -282,7 +282,7 @@ typedef enum {
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
 	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_FEATURES_COMPAT,
 	XFS_SBS_FEATURES_RO_COMPAT, XFS_SBS_FEATURES_INCOMPAT,
-	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_PAD,
+	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_SPINO_ALIGN,
 	XFS_SBS_PQUOTINO, XFS_SBS_LSN,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b0a5fe9..a461c2e 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -382,7 +382,7 @@ __xfs_sb_from_disk(
 				be32_to_cpu(from->sb_features_log_incompat);
 	/* crc is only used on disk, not in memory; just init to 0 here. */
 	to->sb_crc = 0;
-	to->sb_pad = 0;
+	to->sb_spino_align = be32_to_cpu(from->sb_spino_align);
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
 	/* Convert on-disk flags to in-memory flags? */
@@ -524,7 +524,7 @@ xfs_sb_to_disk(
 				cpu_to_be32(from->sb_features_incompat);
 		to->sb_features_log_incompat =
 				cpu_to_be32(from->sb_features_log_incompat);
-		to->sb_pad = 0;
+		to->sb_spino_align = cpu_to_be32(from->sb_spino_align);
 		to->sb_lsn = cpu_to_be64(from->sb_lsn);
 	}
 }
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
