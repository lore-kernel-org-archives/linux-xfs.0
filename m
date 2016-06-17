Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E1B2A82D0
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:41:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3060304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:41:27 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id nhBXkpFaD4NJw9rn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:41:25 -0700 (PDT)
Subject: [PATCH 100/145] xfs: create a separate cow extent size hint for the
	allocator
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:41:18 -0700
Message-ID: <146612767885.16048.6454121864397119567.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Create a per-inode extent size allocator hint for copy-on-write.  This
hint is separate from the existing extent size hint so that CoW can
take advantage of the fragmentation-reducing properties of extent size
hints without disabling delalloc for regular writes.

The extent size hint that's fed to the allocator during a copy on
write operation is the greater of the cowextsize and regular extsize
hint.

During reflink, if we're sharing the entire source file to the entire
destination file and the destination file doesn't already have a
cowextsize hint, propagate the source file's cowextsize hint to the
destination file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/darwin.h        |    3 ++-
 include/freebsd.h       |    3 ++-
 include/irix.h          |    3 ++-
 include/linux.h         |    3 ++-
 libxfs/libxfs_priv.h    |    1 +
 libxfs/xfs_bmap.c       |   13 +++++++++++--
 libxfs/xfs_format.h     |    3 ++-
 libxfs/xfs_fs.h         |    3 ++-
 libxfs/xfs_inode_buf.c  |    4 +++-
 libxfs/xfs_inode_buf.h  |    1 +
 libxfs/xfs_log_format.h |    3 ++-
 11 files changed, 30 insertions(+), 10 deletions(-)


diff --git a/include/darwin.h b/include/darwin.h
index abb2a22..2cbd058 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -293,7 +293,8 @@ struct fsxattr {
 	__u32		fsx_extsize;	/* extsize field value (get/set)*/
 	__u32		fsx_nextents;	/* nextents field value (get)	*/
 	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
+	__u32		fsx_cowextsize;	/* cow extsize field value (get/set) */
+	unsigned char	fsx_pad[8];
 };
 
 /*
diff --git a/include/freebsd.h b/include/freebsd.h
index fc58a74..1d84b14 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -183,7 +183,8 @@ struct fsxattr {
 	__u32		fsx_extsize;	/* extsize field value (get/set)*/
 	__u32		fsx_nextents;	/* nextents field value (get)	*/
 	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
+	__u32		fsx_cowextsize;	/* cow extsize field value (get/set) */
+	unsigned char	fsx_pad[8];
 };
 
 /*
diff --git a/include/irix.h b/include/irix.h
index c4d25b5..0cf796a 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -428,7 +428,8 @@ struct fsxattr {
 	__u32		fsx_extsize;	/* extsize field value (get/set)*/
 	__u32		fsx_nextents;	/* nextents field value (get)	*/
 	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
+	__u32		fsx_cowextsize;	/* cow extsize field value (get/set) */
+	unsigned char	fsx_pad[8];
 };
 
 /*
diff --git a/include/linux.h b/include/linux.h
index d47a29c..2aeecd0 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -186,7 +186,8 @@ struct fsxattr {
 	__u32		fsx_extsize;	/* extsize field value (get/set)*/
 	__u32		fsx_nextents;	/* nextents field value (get)	*/
 	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
+	__u32		fsx_cowextsize;	/* cow extsize field value (get/set) */
+	unsigned char	fsx_pad[8];
 };
 
 /*
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ba16544..41f6b96 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -426,6 +426,7 @@ do { \
 #define xfs_rotorstep				1
 #define xfs_bmap_rtalloc(a)			(-ENOSYS)
 #define xfs_get_extsz_hint(ip)			(0)
+#define xfs_get_cowextsz_hint(ip)		(0)
 #define xfs_inode_is_filestream(ip)		(0)
 #define xfs_filestream_lookup_ag(ip)		(0)
 #define xfs_filestream_new_ag(ip,ag)		(0)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4b77ed0..e81ade5 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3657,7 +3657,13 @@ xfs_bmap_btalloc(
 	else if (mp->m_dalign)
 		stripe_align = mp->m_dalign;
 
-	align = ap->userdata ? xfs_get_extsz_hint(ap->ip) : 0;
+	if (ap->userdata) {
+		if (ap->flags & XFS_BMAPI_COWFORK)
+			align = xfs_get_cowextsz_hint(ap->ip);
+		else
+			align = xfs_get_extsz_hint(ap->ip);
+	} else
+		align = 0;
 	if (unlikely(align)) {
 		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 						align, 0, ap->eof, 0, ap->conv,
@@ -4170,7 +4176,10 @@ xfs_bmapi_reserve_delalloc(
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 
 	/* Figure out the extent size, adjust alen */
-	extsz = xfs_get_extsz_hint(ip);
+	if (whichfork == XFS_COW_FORK)
+		extsz = xfs_get_cowextsz_hint(ip);
+	else
+		extsz = xfs_get_extsz_hint(ip);
 	if (extsz) {
 		error = xfs_bmap_extsize_align(mp, got, prev, extsz, rt, eof,
 					       1, 0, &aoff, &alen);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 820dfde..de29220 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -890,7 +890,8 @@ typedef struct xfs_dinode {
 	__be64		di_changecount;	/* number of attribute changes */
 	__be64		di_lsn;		/* flush sequence */
 	__be64		di_flags2;	/* more random flags */
-	__u8		di_pad2[16];	/* more padding for future expansion */
+	__be32		di_cowextsize;	/* basic cow extent size for file */
+	__u8		di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_timestamp_t	di_crtime;	/* time created */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index bb70066..df58c1c 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -302,7 +302,8 @@ typedef struct xfs_bstat {
 #define	bs_projid	bs_projid_lo	/* (previously just bs_projid)	*/
 	__u16		bs_forkoff;	/* inode fork offset in bytes	*/
 	__u16		bs_projid_hi;	/* higher part of project id	*/
-	unsigned char	bs_pad[10];	/* pad space, unused		*/
+	unsigned char	bs_pad[6];	/* pad space, unused		*/
+	__u32		bs_cowextsize;	/* cow extent size		*/
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 572c101..8a804e2 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -265,6 +265,7 @@ xfs_inode_from_disk(
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
+		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
 }
 
@@ -314,7 +315,7 @@ xfs_inode_to_disk(
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
-
+		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
@@ -366,6 +367,7 @@ xfs_log_dinode_to_disk(
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
+		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
 		to->di_lsn = cpu_to_be64(from->di_lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 958c543..6848a0a 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -47,6 +47,7 @@ struct xfs_icdinode {
 	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 
 	__uint64_t	di_flags2;	/* more random flags */
+	__uint32_t	di_cowextsize;	/* basic cow extent size for file */
 
 	xfs_ictimestamp_t di_crtime;	/* time created */
 };
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 320a305..9cab67f 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -423,7 +423,8 @@ struct xfs_log_dinode {
 	__uint64_t	di_changecount;	/* number of attribute changes */
 	xfs_lsn_t	di_lsn;		/* flush sequence */
 	__uint64_t	di_flags2;	/* more random flags */
-	__uint8_t	di_pad2[16];	/* more padding for future expansion */
+	__uint32_t	di_cowextsize;	/* basic cow extent size for file */
+	__uint8_t	di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_ictimestamp_t di_crtime;	/* time created */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
