Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE2B729E05
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:13:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A84068F8037
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 04:13:42 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	m9ABmPM8l49dSy7R for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 04:13:39 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UdIbM-0008Ra-TI
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:32 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UdIbM-0005ED-Pa
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/30] libxfs: add version 3 inode support
Date: Fri, 17 May 2013 21:13:02 +1000
Message-Id: <1368789205-19969-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>

Header from folded patch 'debug':

xfs_quota: fix report command parsing


The report command line needs to be parsed as a whole not as
individual elements - report_f() is set up to do this correctly.
When treated as non-global command line, the report function is
called once for each command line arg, resulting in reports being
issued multiple times.

Set the command to be a global command so that it is only called
once.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/dir2sf.c              |    9 +++--
 include/xfs_buf_item.h   |    4 +-
 include/xfs_dinode.h     |   33 +++++++++++++++--
 include/xfs_inode.h      |   26 +++++++++++++
 libxfs/trans.c           |    1 +
 libxfs/util.c            |   30 ++++++++++++++-
 libxfs/xfs_ialloc.c      |   23 +++++++++++-
 libxfs/xfs_inode.c       |   91 ++++++++++++++++++++++++++++++++++++++++------
 logprint/log_misc.c      |    2 +-
 logprint/log_print_all.c |    3 +-
 repair/phase6.c          |   63 +++++++++++++++++++++++++++++---
 11 files changed, 255 insertions(+), 30 deletions(-)

diff --git a/db/dir2sf.c b/db/dir2sf.c
index 92f8a66..271e08a 100644
--- a/db/dir2sf.c
+++ b/db/dir2sf.c
@@ -74,10 +74,11 @@ dir2_inou_i4_count(
 	void		*obj,
 	int		startoff)
 {
+	struct xfs_dinode *dip = obj;
 	xfs_dir2_sf_t	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(obj);
+	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
 	return sf->hdr.i8count == 0;
 }
 
@@ -87,10 +88,11 @@ dir2_inou_i8_count(
 	void		*obj,
 	int		startoff)
 {
+	struct xfs_dinode *dip = obj;
 	xfs_dir2_sf_t	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(obj);
+	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
 	return sf->hdr.i8count != 0;
 }
 
@@ -101,11 +103,12 @@ dir2_inou_size(
 	int		startoff,
 	int		idx)
 {
+	struct xfs_dinode *dip = obj;
 	xfs_dir2_sf_t	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(idx == 0);
-	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(obj);
+	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
 	return bitize(sf->hdr.i8count ?
 		      (uint)sizeof(xfs_dir2_ino8_t) :
 		      (uint)sizeof(xfs_dir2_ino4_t));
diff --git a/include/xfs_buf_item.h b/include/xfs_buf_item.h
index c256606..abae8c8 100644
--- a/include/xfs_buf_item.h
+++ b/include/xfs_buf_item.h
@@ -48,6 +48,7 @@ extern kmem_zone_t	*xfs_buf_item_zone;
 #define XFS_BLF_AGF_BUF		(1<<6)
 #define XFS_BLF_AGFL_BUF	(1<<7)
 #define XFS_BLF_AGI_BUF		(1<<8)
+#define XFS_BLF_DINO_BUF	(1<<9)
 
 #define XFS_BLF_TYPE_MASK	\
 		(XFS_BLF_UDQUOT_BUF | \
@@ -56,7 +57,8 @@ extern kmem_zone_t	*xfs_buf_item_zone;
 		 XFS_BLF_BTREE_BUF | \
 		 XFS_BLF_AGF_BUF | \
 		 XFS_BLF_AGFL_BUF | \
-		 XFS_BLF_AGI_BUF)
+		 XFS_BLF_AGI_BUF | \
+		 XFS_BLF_DINO_BUF)
 
 #define	XFS_BLF_CHUNK		128
 #define	XFS_BLF_SHIFT		7
diff --git a/include/xfs_dinode.h b/include/xfs_dinode.h
index 6b5bd17..f7a0e95 100644
--- a/include/xfs_dinode.h
+++ b/include/xfs_dinode.h
@@ -19,7 +19,7 @@
 #define	__XFS_DINODE_H__
 
 #define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
-#define XFS_DINODE_GOOD_VERSION(v)	(((v) == 1 || (v) == 2))
+#define XFS_DINODE_GOOD_VERSION(v)	((v) >= 1 && (v) <= 3)
 
 typedef struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
@@ -70,11 +70,36 @@ typedef struct xfs_dinode {
 
 	/* di_next_unlinked is the only non-core field in the old dinode */
 	__be32		di_next_unlinked;/* agi unlinked list ptr */
-} __attribute__((packed)) xfs_dinode_t;
+
+	/* start of the extended dinode, writable fields */
+	__le32		di_crc;		/* CRC of the inode */
+	__be64		di_changecount;	/* number of attribute changes */
+	__be64		di_lsn;		/* flush sequence */
+	__be64		di_flags2;	/* more random flags */
+	__u8		di_pad2[16];	/* more padding for future expansion */
+
+	/* fields only written to during inode creation */
+	xfs_timestamp_t	di_crtime;	/* time created */
+	__be64		di_ino;		/* inode number */
+	uuid_t		di_uuid;	/* UUID of the filesystem */
+
+	/* structure must be padded to 64 bit alignment */
+} xfs_dinode_t;
 
 #define DI_MAX_FLUSH 0xffff
 
 /*
+ * Size of the core inode on disk.  Version 1 and 2 inodes have
+ * the same size, but version 3 has grown a few additional fields.
+ */
+static inline uint xfs_dinode_size(int version)
+{
+	if (version == 3)
+		return sizeof(struct xfs_dinode);
+	return offsetof(struct xfs_dinode, di_crc);
+}
+
+/*
  * The 32 bit link count in the inode theoretically maxes out at UINT_MAX.
  * Since the pathconf interface is signed, we use 2^31 - 1 instead.
  * The old inode format had a 16 bit link count, so its maximum is USHRT_MAX.
@@ -105,7 +130,7 @@ typedef enum xfs_dinode_fmt {
  * Inode size for given fs.
  */
 #define XFS_LITINO(mp, version) \
-	((int)(((mp)->m_sb.sb_inodesize) - sizeof(struct xfs_dinode)))
+	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
 
 #define XFS_BROOT_SIZE_ADJ(ip) \
 	(XFS_BMBT_BLOCK_LEN((ip)->i_mount) - sizeof(xfs_bmdr_block_t))
@@ -133,7 +158,7 @@ typedef enum xfs_dinode_fmt {
  * Return pointers to the data or attribute forks.
  */
 #define XFS_DFORK_DPTR(dip) \
-	((char *)(dip) + sizeof(struct xfs_dinode))
+	((char *)dip + xfs_dinode_size(dip->di_version))
 #define XFS_DFORK_APTR(dip)	\
 	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
 #define XFS_DFORK_PTR(dip,w)	\
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 4733f85..cc14743 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -150,13 +150,38 @@ typedef struct xfs_icdinode {
 	__uint16_t	di_dmstate;	/* DMIG state info */
 	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 	__uint32_t	di_gen;		/* generation number */
+
+	/* di_next_unlinked is the only non-core field in the old dinode */
+	__be32		di_next_unlinked;/* agi unlinked list ptr */
+
+	/* start of the extended dinode, writable fields */
+	__uint32_t	di_crc;		/* CRC of the inode */
+	__uint64_t	di_changecount;	/* number of attribute changes */
+	xfs_lsn_t	di_lsn;		/* flush sequence */
+	__uint64_t	di_flags2;	/* more random flags */
+	__uint8_t	di_pad2[16];	/* more padding for future expansion */
+
+	/* fields only written to during inode creation */
+	xfs_ictimestamp_t di_crtime;	/* time created */
+	xfs_ino_t	di_ino;		/* inode number */
+	uuid_t		di_uuid;	/* UUID of the filesystem */
+
+	/* structure must be padded to 64 bit alignment */
 } xfs_icdinode_t;
 
+static inline uint xfs_icdinode_size(struct xfs_icdinode *dicp)
+{
+	if (dicp->di_version == 3)
+		return sizeof(struct xfs_icdinode);
+	return offsetof(struct xfs_icdinode, di_next_unlinked);
+}
+
 /*
  * Flags for xfs_ichgtime().
  */
 #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
 #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
+#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
 
 /*
  * Per-fork incore inode flags.
@@ -556,6 +581,7 @@ int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 			       struct xfs_buf **, uint, uint);
 int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, uint);
+void		xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 7cb3c8c..619aad1 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -218,6 +218,7 @@ libxfs_trans_inode_alloc_buf(
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
+	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DINO_BUF);
 }
 
 /*
diff --git a/libxfs/util.c b/libxfs/util.c
index 2ad4bfd..abe16cf 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -47,6 +47,10 @@ libxfs_trans_ichgtime(
 		ip->i_d.di_ctime.t_sec = (__int32_t)tv.tv_sec;
 		ip->i_d.di_ctime.t_nsec = (__int32_t)tv.tv_nsec;
 	}
+	if (flags & XFS_ICHGTIME_CREATE) {
+		ip->i_d.di_crtime.t_sec = (__int32_t)tv.tv_sec;
+		ip->i_d.di_crtime.t_nsec = (__int32_t)tv.tv_nsec;
+	}
 }
 
 /*
@@ -75,6 +79,7 @@ libxfs_ialloc(
 	xfs_inode_t	*ip;
 	uint		flags;
 	int		error;
+	int		times;
 
 	/*
 	 * Call the space management code to pick
@@ -103,6 +108,7 @@ libxfs_ialloc(
 	ip->i_d.di_gid = cr->cr_gid;
 	xfs_set_projid(&ip->i_d, pip ? 0 : fsx->fsx_projid);
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
 
 	/*
 	 * If the superblock version is up to where we support new format
@@ -128,7 +134,6 @@ libxfs_ialloc(
 	ip->i_d.di_size = 0;
 	ip->i_d.di_nextents = 0;
 	ASSERT(ip->i_d.di_nblocks == 0);
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG|XFS_ICHGTIME_MOD);
 	/*
 	 * di_gen will have been taken care of in xfs_iread.
 	 */
@@ -136,6 +141,18 @@ libxfs_ialloc(
 	ip->i_d.di_dmevmask = 0;
 	ip->i_d.di_dmstate = 0;
 	ip->i_d.di_flags = pip ? 0 : fsx->fsx_xflags;
+
+	if (ip->i_d.di_version == 3) {
+		ASSERT(ip->i_d.di_ino == ino);
+		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid));
+		ip->i_d.di_crc = 0;
+		ip->i_d.di_changecount = 1;
+		ip->i_d.di_lsn = 0;
+		ip->i_d.di_flags2 = 0;
+		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
+		ip->i_d.di_crtime = ip->i_d.di_mtime;
+	}
+
 	flags = XFS_ILOG_CORE;
 	switch (mode & S_IFMT) {
 	case S_IFIFO:
@@ -295,6 +312,10 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 	ASSERT(ip->i_d.di_nextents+ip->i_d.di_anextents <= ip->i_d.di_nblocks);
 	ASSERT(ip->i_d.di_forkoff <= mp->m_sb.sb_inodesize);
 
+	/* bump the change count on v3 inodes */
+	if (ip->i_d.di_version == 3)
+		ip->i_d.di_changecount++;
+
 	/*
 	 * Copy the dirty parts of the inode into the on-disk
 	 * inode.  We always copy out the core of the inode,
@@ -338,6 +359,13 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 	if (XFS_IFORK_Q(ip)) 
 		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK, bp);
 
+	/* update the lsn in the on disk inode if required */
+	if (ip->i_d.di_version == 3)
+		dip->di_lsn = cpu_to_be64(iip->ili_item.li_lsn);
+
+	/* generate the checksum. */
+	xfs_dinode_calc_crc(mp, dip);
+
 	return 0;
 }
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index feb4a4e..57fbae2 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -146,6 +146,7 @@ xfs_ialloc_inode_init(
 	int			version;
 	int			i, j;
 	xfs_daddr_t		d;
+	xfs_ino_t		ino = 0;
 
 	/*
 	 * Loop over the new block(s), filling in the inodes.
@@ -169,8 +170,18 @@ xfs_ialloc_inode_init(
 	 * the new inode format, then use the new inode version.  Otherwise
 	 * use the old version so that old kernels will continue to be
 	 * able to use the file system.
+	 *
+	 * For v3 inodes, we also need to write the inode number into the inode,
+	 * so calculate the first inode number of the chunk here as
+	 * XFS_OFFBNO_TO_AGINO() only works on filesystem block boundaries, not
+	 * cluster boundaries and so cannot be used in the cluster buffer loop
+	 * below.
 	 */
-	if (xfs_sb_version_hasnlink(&mp->m_sb))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		version = 3;
+		ino = XFS_AGINO_TO_INO(mp, agno,
+				       XFS_OFFBNO_TO_AGINO(mp, agbno, 0));
+	} else if (xfs_sb_version_hasnlink(&mp->m_sb))
 		version = 2;
 	else
 		version = 1;
@@ -196,13 +207,21 @@ xfs_ialloc_inode_init(
 		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
 		for (i = 0; i < ninodes; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
-			uint	isize = sizeof(struct xfs_dinode);
+			uint	isize = xfs_dinode_size(version);
 
 			free = xfs_make_iptr(mp, fbuf, i);
 			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 			free->di_version = version;
 			free->di_gen = cpu_to_be32(gen);
 			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
+
+			if (version == 3) {
+				free->di_ino = cpu_to_be64(ino);
+				ino++;
+				uuid_copy(&free->di_uuid, &mp->m_sb.sb_uuid);
+				xfs_dinode_calc_crc(mp, free);
+			}
+
 			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
 		}
 		xfs_trans_inode_alloc_buf(tp, fbuf);
diff --git a/libxfs/xfs_inode.c b/libxfs/xfs_inode.c
index f9f792c..d6513b9 100644
--- a/libxfs/xfs_inode.c
+++ b/libxfs/xfs_inode.c
@@ -572,6 +572,17 @@ xfs_dinode_from_disk(
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
 	to->di_flags	= be16_to_cpu(from->di_flags);
 	to->di_gen	= be32_to_cpu(from->di_gen);
+
+	if (to->di_version == 3) {
+		to->di_changecount = be64_to_cpu(from->di_changecount);
+		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
+		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		to->di_flags2 = be64_to_cpu(from->di_flags2);
+		to->di_ino = be64_to_cpu(from->di_ino);
+		to->di_lsn = be64_to_cpu(from->di_lsn);
+		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
+		platform_uuid_copy(&to->di_uuid, &from->di_uuid);
+	}
 }
 
 void
@@ -608,6 +619,58 @@ xfs_dinode_to_disk(
 	to->di_dmstate = cpu_to_be16(from->di_dmstate);
 	to->di_flags = cpu_to_be16(from->di_flags);
 	to->di_gen = cpu_to_be32(from->di_gen);
+
+	if (from->di_version == 3) {
+		to->di_changecount = cpu_to_be64(from->di_changecount);
+		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
+		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		to->di_flags2 = cpu_to_be64(from->di_flags2);
+		to->di_ino = cpu_to_be64(from->di_ino);
+		to->di_lsn = cpu_to_be64(from->di_lsn);
+		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
+		platform_uuid_copy(&to->di_uuid, &from->di_uuid);
+	}
+}
+
+static bool
+xfs_dinode_verify(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
+		return false;
+
+	/* only version 3 or greater inodes are extensively verified here */
+	if (dip->di_version < 3)
+		return true;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return false;
+	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
+			      offsetof(struct xfs_dinode, di_crc)))
+		return false;
+	if (be64_to_cpu(dip->di_ino) != ip->i_ino)
+		return false;
+	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_uuid))
+		return false;
+	return true;
+}
+
+void
+xfs_dinode_calc_crc(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip)
+{
+	__uint32_t		crc;
+
+	if (dip->di_version < 3)
+		return;
+
+	ASSERT(xfs_sb_version_hascrc(&mp->m_sb));
+	crc = xfs_start_cksum((char *)dip, mp->m_sb.sb_inodesize,
+			      offsetof(struct xfs_dinode, di_crc));
+	dip->di_crc = xfs_end_cksum(crc);
 }
 
 /*
@@ -638,17 +701,13 @@ xfs_iread(
 	if (error)
 		return error;
 
-	/*
-	 * If we got something that isn't an inode it means someone
-	 * (nfs or dmi) has a stale handle.
-	 */
-	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC)) {
-#ifdef DEBUG
-		xfs_alert(mp,
-			"%s: dip->di_magic (0x%x) != XFS_DINODE_MAGIC (0x%x)",
-			__func__, be16_to_cpu(dip->di_magic), XFS_DINODE_MAGIC);
-#endif /* DEBUG */
-		error = XFS_ERROR(EINVAL);
+	/* even unallocated inodes are verified */
+	if (!xfs_dinode_verify(mp, ip, dip)) {
+		xfs_alert(mp, "%s: validation failed for inode %lld failed",
+				__func__, ip->i_ino);
+
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);
+		error = XFS_ERROR(EFSCORRUPTED);
 		goto out_brelse;
 	}
 
@@ -670,10 +729,20 @@ xfs_iread(
 			goto out_brelse;
 		}
 	} else {
+		/*
+		 * Partial initialisation of the in-core inode. Just the bits
+		 * that xfs_ialloc won't overwrite or relies on being correct.
+		 */
 		ip->i_d.di_magic = be16_to_cpu(dip->di_magic);
 		ip->i_d.di_version = dip->di_version;
 		ip->i_d.di_gen = be32_to_cpu(dip->di_gen);
 		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
+
+		if (dip->di_version == 3) {
+			ip->i_d.di_ino = be64_to_cpu(dip->di_ino);
+			uuid_copy(&ip->i_d.di_uuid, &dip->di_uuid);
+		}
+
 		/*
 		 * Make sure to pull in the mode here as well in
 		 * case the inode is released without being used.
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 334b6bf..f368e5a 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -655,7 +655,7 @@ xlog_print_trans_inode(xfs_caddr_t *ptr,
     mode = dino.di_mode & S_IFMT;
     size = (int)dino.di_size;
     xlog_print_trans_inode_core(&dino);
-    *ptr += sizeof(xfs_icdinode_t);
+    *ptr += xfs_icdinode_size(&dino);
 
     if (*i == num_ops-1 && f->ilf_size == 3)  {
 	return 1;
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index dfd76b7..70b0905 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -295,7 +295,8 @@ xlog_recover_print_inode(
 	       f->ilf_dsize);
 
 	/* core inode comes 2nd */
-	ASSERT(item->ri_buf[1].i_len == sizeof(xfs_icdinode_t));
+	ASSERT(item->ri_buf[1].i_len == xfs_icdinode_size((xfs_icdinode_t *)
+							item->ri_buf[1].i_addr));
 	xlog_recover_print_inode_core((xfs_icdinode_t *)
 				      item->ri_buf[1].i_addr);
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 5c33797..039e8ae 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -427,6 +427,8 @@ mk_rbmino(xfs_mount_t *mp)
 	xfs_bmap_free_t	flist;
 	xfs_dfiloff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
+	int		vers;
+	int		times;
 
 	/*
 	 * first set up inode
@@ -443,16 +445,31 @@ mk_rbmino(xfs_mount_t *mp)
 			error);
 	}
 
-	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
+	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 1;
+	ip->i_d.di_version = vers;
+	memset(&ip->i_d, 0, xfs_icdinode_size(&ip->i_d));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = S_IFREG;
-	ip->i_d.di_version = 1;
+	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
 	ip->i_d.di_nlink = 1;		/* account for sb ptr */
 
+	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
+	if (ip->i_d.di_version == 3) {
+		ip->i_d.di_crc = 0;
+		ip->i_d.di_changecount = 1;
+		ip->i_d.di_lsn = 0;
+		ip->i_d.di_flags2 = 0;
+		ip->i_d.di_ino = mp->m_sb.sb_rbmino;
+		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
+		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
+		times |= XFS_ICHGTIME_CREATE;
+	}
+	libxfs_trans_ichgtime(tp, ip, times);
+
 	/*
 	 * now the ifork
 	 */
@@ -659,6 +676,8 @@ mk_rsumino(xfs_mount_t *mp)
 	xfs_bmap_free_t	flist;
 	xfs_dfiloff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
+	int		vers;
+	int		times;
 
 	/*
 	 * first set up inode
@@ -676,16 +695,31 @@ mk_rsumino(xfs_mount_t *mp)
 			error);
 	}
 
-	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
+	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 1;
+	ip->i_d.di_version = vers;
+	memset(&ip->i_d, 0, xfs_icdinode_size(&ip->i_d));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = S_IFREG;
-	ip->i_d.di_version = 1;
+	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
 	ip->i_d.di_nlink = 1;		/* account for sb ptr */
 
+	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
+	if (ip->i_d.di_version == 3) {
+		ip->i_d.di_crc = 0;
+		ip->i_d.di_changecount = 1;
+		ip->i_d.di_lsn = 0;
+		ip->i_d.di_flags2 = 0;
+		ip->i_d.di_ino = mp->m_sb.sb_rsumino;
+		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
+		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
+		times |= XFS_ICHGTIME_CREATE;
+	}
+	libxfs_trans_ichgtime(tp, ip, times);
+
 	/*
 	 * now the ifork
 	 */
@@ -758,6 +792,8 @@ mk_root_dir(xfs_mount_t *mp)
 	int		error;
 	const mode_t	mode = 0755;
 	ino_tree_node_t	*irec;
+	int		vers;
+	int		times;
 
 	ASSERT(xfs_sb_version_hasdirv2(&mp->m_sb));
 
@@ -776,16 +812,31 @@ mk_root_dir(xfs_mount_t *mp)
 	/*
 	 * take care of the core -- initialization from xfs_ialloc()
 	 */
-	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
+	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 1;
+	ip->i_d.di_version = vers;
+	memset(&ip->i_d, 0, xfs_icdinode_size(&ip->i_d));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = (__uint16_t) mode|S_IFDIR;
-	ip->i_d.di_version = 1;
+	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
 	ip->i_d.di_nlink = 1;		/* account for . */
 
+	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
+	if (ip->i_d.di_version == 3) {
+		ip->i_d.di_crc = 0;
+		ip->i_d.di_changecount = 1;
+		ip->i_d.di_lsn = 0;
+		ip->i_d.di_flags2 = 0;
+		ip->i_d.di_ino = mp->m_sb.sb_rootino;
+		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
+		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
+		times |= XFS_ICHGTIME_CREATE;
+	}
+	libxfs_trans_ichgtime(tp, ip, times);
+
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	/*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
