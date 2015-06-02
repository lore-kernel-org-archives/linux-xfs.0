Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 29E327F8E
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 14:39:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 196EE8F8070
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 12:39:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9Fw9QjF9SXmJqxW1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 12:39:35 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id AE88F2CAF35
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 19:39:34 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig30S016924
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 04/28] xfs: add sparse inode chunk alignment superblock field
Date: Tue,  2 Jun 2015 14:41:37 -0400
Message-Id: <1433270521-62026-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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
 libxfs/xfs_format.h | 4 ++--
 libxfs/xfs_sb.c     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 4d313d3..20acbc4 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 6844cd8..f34c676 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -357,7 +357,7 @@ __xfs_sb_from_disk(
 				be32_to_cpu(from->sb_features_log_incompat);
 	/* crc is only used on disk, not in memory; just init to 0 here. */
 	to->sb_crc = 0;
-	to->sb_pad = 0;
+	to->sb_spino_align = be32_to_cpu(from->sb_spino_align);
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
 	/* Convert on-disk flags to in-memory flags? */
@@ -499,7 +499,7 @@ xfs_sb_to_disk(
 				cpu_to_be32(from->sb_features_incompat);
 		to->sb_features_log_incompat =
 				cpu_to_be32(from->sb_features_log_incompat);
-		to->sb_pad = 0;
+		to->sb_spino_align = cpu_to_be32(from->sb_spino_align);
 		to->sb_lsn = cpu_to_be64(from->sb_lsn);
 	}
 }
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
