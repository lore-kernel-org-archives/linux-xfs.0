Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3ECF27CB9
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2FDF0304039
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:21 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7bis3tKqGQGF1prF for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:17 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004m1-Qb
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00014X-Pn
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/15] xfs: cull unnecessary icdinode fields
Date: Wed, 17 Feb 2016 18:20:47 +1100
Message-Id: <1455693652-3899-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1455693652-3899-1-git-send-email-david@fromorbit.com>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit 93f958f9c41f0bfd10627a2279457df64004d957

Now that the struct xfs_icdinode is not directly related to the
on-disk format, we can cull things in it we really don't need to
store:

- magic number never changes
- padding is not necessary
- next_unlinked is never used
- inode number is redundant
- uuid is redundant
- lsn is accessed directly from dinode
- inode CRC is only accessed directly from dinode

Hence we can remove these from the struct xfs_icdinode and redirect
the code that uses them to the xfs_dinode appripriately.  This
reduces the size of the struct icdinode from 152 bytes to 88 bytes,
and removes a fair chunk of unnecessary code, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 db/check.c             |  4 ++--
 libxfs/util.c          | 11 +----------
 libxfs/xfs_inode_buf.c | 39 +++++++++++++--------------------------
 libxfs/xfs_inode_buf.h | 25 ++++++-------------------
 repair/phase6.c        | 18 ------------------
 5 files changed, 22 insertions(+), 75 deletions(-)

diff --git a/db/check.c b/db/check.c
index 2203f41..95a68d4 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2672,10 +2672,10 @@ process_inode(
 		blkmap = NULL;
 	}
 	v = (!sflag || (id && id->ilist) || CHECK_BLIST(bno));
-	if (xino.i_d.di_magic != XFS_DINODE_MAGIC) {
+	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC)) {
 		if (isfree || v)
 			dbprintf(_("bad magic number %#x for inode %lld\n"),
-				xino.i_d.di_magic, ino);
+				be16_to_cpu(dip->di_magic), ino);
 		error++;
 		return;
 	}
diff --git a/libxfs/util.c b/libxfs/util.c
index 86fadc3..a893c3a 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -224,7 +224,6 @@ libxfs_ialloc(
 	ip->i_d.di_uid = cr->cr_uid;
 	ip->i_d.di_gid = cr->cr_gid;
 	xfs_set_projid(&ip->i_d, pip ? 0 : fsx->fsx_projid);
-	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
 
 	/*
@@ -261,11 +260,8 @@ libxfs_ialloc(
 	if (ip->i_d.di_version == 3) {
 		ASSERT(ip->i_d.di_ino == ino);
 		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid));
-		ip->i_d.di_crc = 0;
 		ip->i_d.di_changecount = 1;
-		ip->i_d.di_lsn = 0;
 		ip->i_d.di_flags2 = 0;
-		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
 		ip->i_d.di_crtime.t_sec = (__int32_t)VFS_I(ip)->i_mtime.tv_sec;
 		ip->i_d.di_crtime.t_nsec = (__int32_t)VFS_I(ip)->i_mtime.tv_nsec;
 	}
@@ -376,7 +372,6 @@ libxfs_iprint(
 
 	dip = &ip->i_d;
 	printf("\nOn disk portion\n");
-	printf("    di_magic %x\n", dip->di_magic);
 	printf("    di_mode %o\n", dip->di_mode);
 	printf("    di_version %x\n", (uint)dip->di_version);
 	switch (ip->i_d.di_format) {
@@ -449,16 +444,12 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 	 * because if the inode is dirty at all the core must
 	 * be.
 	 */
-	xfs_inode_to_disk(ip, dip);
+	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
 
 	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
 	if (XFS_IFORK_Q(ip))
 		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK);
 
-	/* update the lsn in the on disk inode if required */
-	if (ip->i_d.di_version == 3)
-		dip->di_lsn = cpu_to_be64(iip->ili_item.li_lsn);
-
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index f546b41..5a7a118 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -211,7 +211,6 @@ xfs_inode_from_disk(
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
-	to->di_magic = be16_to_cpu(from->di_magic);
 	to->di_mode = be16_to_cpu(from->di_mode);
 	to->di_version = from ->di_version;
 	to->di_format = from->di_format;
@@ -221,7 +220,6 @@ xfs_inode_from_disk(
 	to->di_nlink = be32_to_cpu(from->di_nlink);
 	to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
 	to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
@@ -254,24 +252,22 @@ xfs_inode_from_disk(
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
-		to->di_ino = be64_to_cpu(from->di_ino);
-		to->di_lsn = be64_to_cpu(from->di_lsn);
-		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		uuid_copy(&to->di_uuid, &from->di_uuid);
 	}
 }
 
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
-	struct xfs_dinode	*to)
+	struct xfs_dinode	*to,
+	xfs_lsn_t		lsn)
 {
 	struct xfs_icdinode	*from = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
-	to->di_magic = cpu_to_be16(from->di_magic);
+	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+
 	to->di_mode = cpu_to_be16(from->di_mode);
-	to->di_version = from ->di_version;
+	to->di_version = from->di_version;
 	to->di_format = from->di_format;
 	to->di_onlink = cpu_to_be16(from->di_onlink);
 	to->di_uid = cpu_to_be32(from->di_uid);
@@ -279,8 +275,8 @@ xfs_inode_to_disk(
 	to->di_nlink = cpu_to_be32(from->di_nlink);
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
+	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
 	to->di_atime.t_nsec = cpu_to_be32(inode->i_atime.tv_nsec);
 	to->di_mtime.t_sec = cpu_to_be32(inode->i_mtime.tv_sec);
@@ -305,10 +301,11 @@ xfs_inode_to_disk(
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
-		to->di_ino = cpu_to_be64(from->di_ino);
-		to->di_lsn = cpu_to_be64(from->di_lsn);
-		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		uuid_copy(&to->di_uuid, &from->di_uuid);
+
+		to->di_ino = cpu_to_be64(ip->i_ino);
+		to->di_lsn = cpu_to_be64(lsn);
+		memset(to->di_pad2, 0, sizeof(to->di_pad2));
+		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
@@ -443,13 +440,10 @@ xfs_iread(
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
-		ip->i_d.di_magic = XFS_DINODE_MAGIC;
 		ip->i_d.di_gen = prandom_u32();
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (xfs_sb_version_hascrc(&mp->m_sb))
 			ip->i_d.di_version = 3;
-			ip->i_d.di_ino = ip->i_ino;
-			uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid);
-		} else
+		else
 			ip->i_d.di_version = 2;
 		return 0;
 	}
@@ -493,16 +487,10 @@ xfs_iread(
 		 * Partial initialisation of the in-core inode. Just the bits
 		 * that xfs_ialloc won't overwrite or relies on being correct.
 		 */
-		ip->i_d.di_magic = be16_to_cpu(dip->di_magic);
 		ip->i_d.di_version = dip->di_version;
 		ip->i_d.di_gen = be32_to_cpu(dip->di_gen);
 		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
 
-		if (dip->di_version == 3) {
-			ip->i_d.di_ino = be64_to_cpu(dip->di_ino);
-			uuid_copy(&ip->i_d.di_uuid, &dip->di_uuid);
-		}
-
 		/*
 		 * Make sure to pull in the mode here as well in
 		 * case the inode is released without being used.
@@ -523,7 +511,6 @@ xfs_iread(
 	 */
 	if (ip->i_d.di_version == 1) {
 		ip->i_d.di_version = 2;
-		memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 		ip->i_d.di_nlink = ip->i_d.di_onlink;
 		ip->i_d.di_onlink = 0;
 		xfs_set_projid(&ip->i_d, 0);
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 6242974..974d060 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -22,24 +22,22 @@ struct xfs_inode;
 struct xfs_dinode;
 
 /*
- * In memory representation of the XFS inode. This is held in the in-core
- * struct xfs_inode to represent the on disk values, but no longer needs to be
- * identical to the on-disk structure as it is always translated to on-disk
+ * In memory representation of the XFS inode. This is held in the in-core struct
+ * xfs_inode and represents the current on disk values but the structure is not
+ * in on-disk format.  That is, this structure is always translated to on-disk
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
 	__uint16_t	di_mode;	/* mode and type of file */
 	__int8_t	di_version;	/* inode version */
 	__int8_t	di_format;	/* format of di_c data */
 	__uint16_t	di_onlink;	/* old number of links to file */
+	__uint16_t	di_flushiter;	/* incremented on flush */
 	__uint32_t	di_uid;		/* owner's user id */
 	__uint32_t	di_gid;		/* owner's group id */
 	__uint32_t	di_nlink;	/* number of links to file */
 	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
-	__uint8_t	di_pad[6];	/* unused, zeroed space */
-	__uint16_t	di_flushiter;	/* incremented on flush */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
@@ -52,22 +50,10 @@ struct xfs_icdinode {
 	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 	__uint32_t	di_gen;		/* generation number */
 
-	/* di_next_unlinked is the only non-core field in the old dinode */
-	xfs_agino_t	di_next_unlinked;/* agi unlinked list ptr */
-
-	/* start of the extended dinode, writable fields */
-	__uint32_t	di_crc;		/* CRC of the inode */
 	__uint64_t	di_changecount;	/* number of attribute changes */
-	xfs_lsn_t	di_lsn;		/* flush sequence */
 	__uint64_t	di_flags2;	/* more random flags */
-	__uint8_t	di_pad2[16];	/* more padding for future expansion */
 
-	/* fields only written to during inode creation */
 	xfs_ictimestamp_t di_crtime;	/* time created */
-	xfs_ino_t	di_ino;		/* inode number */
-	uuid_t		di_uuid;	/* UUID of the filesystem */
-
-	/* structure must be padded to 64 bit alignment */
 };
 
 /*
@@ -86,7 +72,8 @@ int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
 		  struct xfs_inode *, uint);
 void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
-void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to);
+void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
+			  xfs_lsn_t lsn);
 void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
diff --git a/repair/phase6.c b/repair/phase6.c
index 3aa109d..00142e2 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -510,7 +510,6 @@ mk_rbmino(xfs_mount_t *mp)
 	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 2;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
-	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = S_IFREG;
 	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
@@ -520,13 +519,8 @@ mk_rbmino(xfs_mount_t *mp)
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
 	if (ip->i_d.di_version == 3) {
-		ip->i_d.di_crc = 0;
 		ip->i_d.di_changecount = 1;
-		ip->i_d.di_lsn = 0;
 		ip->i_d.di_flags2 = 0;
-		ip->i_d.di_ino = mp->m_sb.sb_rbmino;
-		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
-		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid);
 		times |= XFS_ICHGTIME_CREATE;
 	}
 	libxfs_trans_ichgtime(tp, ip, times);
@@ -769,7 +763,6 @@ mk_rsumino(xfs_mount_t *mp)
 	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 1;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
-	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = S_IFREG;
 	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
@@ -779,13 +772,8 @@ mk_rsumino(xfs_mount_t *mp)
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
 	if (ip->i_d.di_version == 3) {
-		ip->i_d.di_crc = 0;
 		ip->i_d.di_changecount = 1;
-		ip->i_d.di_lsn = 0;
 		ip->i_d.di_flags2 = 0;
-		ip->i_d.di_ino = mp->m_sb.sb_rsumino;
-		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
-		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid);
 		times |= XFS_ICHGTIME_CREATE;
 	}
 	libxfs_trans_ichgtime(tp, ip, times);
@@ -884,7 +872,6 @@ mk_root_dir(xfs_mount_t *mp)
 	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 2;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
-	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = (__uint16_t) mode|S_IFDIR;
 	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
@@ -894,13 +881,8 @@ mk_root_dir(xfs_mount_t *mp)
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
 	if (ip->i_d.di_version == 3) {
-		ip->i_d.di_crc = 0;
 		ip->i_d.di_changecount = 1;
-		ip->i_d.di_lsn = 0;
 		ip->i_d.di_flags2 = 0;
-		ip->i_d.di_ino = mp->m_sb.sb_rootino;
-		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
-		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid);
 		times |= XFS_ICHGTIME_CREATE;
 	}
 	libxfs_trans_ichgtime(tp, ip, times);
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
