Return-Path: <SRS0=3UjW=7T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3212FC433DF
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Jun 2020 08:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1C8A207D0
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Jun 2020 08:28:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OAeiEX76"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgFFI2o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 6 Jun 2020 04:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728637AbgFFI2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jun 2020 04:28:43 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EEEC08C5C2
        for <linux-xfs@vger.kernel.org>; Sat,  6 Jun 2020 01:28:43 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id m2so3814074pjv.2
        for <linux-xfs@vger.kernel.org>; Sat, 06 Jun 2020 01:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1FfzURtyHK1nUeHXeUuUFQ84XlezpTNwgY45BD7Rqqg=;
        b=OAeiEX76OfjxEY4r0SGI8NQ1sJvji4IExJdWi/NXNwhgUVySxWPUmBZQLdRB0mgsUH
         MrtbiXGwHFWrMgNfUlvrPOMEuFTUCtshs8D8NBAOTLC4PHWreK+SH0pngh6bsF5I/pHY
         duFNY7EzDnNP9xAQmFst0fzap3Qp13nc7+DvM8K/a041R4mj68JaBCzYsnAyd7WEkTPt
         QKLplIwpT7ud/Rse0MMMEnuVZ17FS1epWnL11Bgpv1Jkj10JLjy9dlOWrUHu6IkLpzYm
         C9GEhizGS+AltMPIxN2Ag36kWQWwmCcPlJQo33qKJEJi2WAtFDcc2RNkoszD+TP9i+qm
         pC+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1FfzURtyHK1nUeHXeUuUFQ84XlezpTNwgY45BD7Rqqg=;
        b=pqVPe7IqGdB4wAuBEi4bGZq1tzOpWcWnWBkqJMuxDqrTN0Wr+uYqNFYC1LvUMaseUR
         H1Pk4LSm+SmW98PuGhAAaZwAuX97pFMqKonVqzbf+Q5fIp5pt6Fwk6OJTRpiyy30EW/E
         QVlP6G6uY3O+cpP0oqzq7nZlrJPh9p0Q+wx4/Zo2HbB2EVhwj3YlK5W1neHEMmN+Rmn3
         8KqRc9Oy47HuPf4N+RBkVKjAhrTxUnCNh+fSdlHm6V3VSnlL0pvxAakSr+1azWZimbnU
         AjuinLCPbQVCDuGBz4vqyxKwqs427jcStf3lqAa9JDEjl+3yzA9TbU0hmr1jDLN9Sk8X
         KocQ==
X-Gm-Message-State: AOAM532rN2M9FKtTL6AscgiIFB8tHMvDJY6AA9LvUSBvV2ntOWclKm2I
        I+j4wjrnm6IpfugMrg/4zSPeCjlC
X-Google-Smtp-Source: ABdhPJwMKfh/6uuhRHUx/Xg8oPRs+EgMIOM/1o7OLvHElALqye4IOhfuhFSDK+RwZDmpjSKVU0XHIg==
X-Received: by 2002:a17:90a:218c:: with SMTP id q12mr6530728pjc.116.1591432122392;
        Sat, 06 Jun 2020 01:28:42 -0700 (PDT)
Received: from localhost.localdomain ([122.167.144.243])
        by smtp.gmail.com with ESMTPSA id j3sm1678130pfh.87.2020.06.06.01.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 01:28:42 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com, hch@infradead.org
Subject: [PATCH 7/7] xfs: Extend attr extent counter to 32 bits
Date:   Sat,  6 Jun 2020 13:57:45 +0530
Message-Id: <20200606082745.15174-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200606082745.15174-1-chandanrlinux@gmail.com>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit extends the per-inode attr extent counter to 32 bits.

The following changes are made to accomplish this,
1. A new ro-compat superblock flag to prevent older kernels from
   mounting the filesystem in read-write mode. This flag is set for the
   first time when an inode would end up having more than 2^15 extents.
3. Carve out a new 16-bit field from xfs_dinode->di_pad2[]. This field
   holds the most significant 16 bits of the attr extent counter.
2. A new inode->di_flags2 flag to indicate that the newly added field
   contains valid data. This flag is set when one of the following two
   conditions are met,
   - When the inode is about to have more than 2^15 extents.
   - When flushing the incore inode (See xfs_iflush_int()), if
     the superblock ro-compat flag is already set.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_format.h      | 25 ++++++++++---
 fs/xfs/libxfs/xfs_inode_buf.c   | 23 +++++++++---
 fs/xfs/libxfs/xfs_inode_fork.c  | 62 ++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_log_format.h  |  5 +--
 fs/xfs/libxfs/xfs_types.h       |  5 +--
 fs/xfs/scrub/inode.c            |  5 +--
 fs/xfs/xfs_inode.c              |  4 +++
 fs/xfs/xfs_inode_item.c         |  5 ++-
 fs/xfs/xfs_inode_item_recover.c |  8 ++++-
 9 files changed, 113 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 91bee33aa988..2e37d887fd35 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -450,11 +450,13 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR (1 << 3)	/* 47bit data extents */
+#define XFS_SB_FEAT_RO_COMPAT_32BIT_AEXT_CNTR (1 << 4)	/* 32bit attr extents */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
 		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
-		 XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR)
+		 XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR | \
+		 XFS_SB_FEAT_RO_COMPAT_32BIT_AEXT_CNTR)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
@@ -577,6 +579,18 @@ static inline void xfs_sb_version_add47bitext(struct xfs_sb *sbp)
 	sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR;
 }
 
+static inline bool xfs_sb_version_has32bitaext(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_ro_compat &
+			XFS_SB_FEAT_RO_COMPAT_32BIT_AEXT_CNTR);
+}
+
+static inline void xfs_sb_version_add32bitaext(struct xfs_sb *sbp)
+{
+	sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_32BIT_AEXT_CNTR;
+}
+
 /*
  * end of superblock version macros
  */
@@ -888,7 +902,7 @@ typedef struct xfs_dinode {
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
 	__be32		di_nextents_lo;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	__be16		di_anextents_lo;/* lower part of xattr extent count */
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	__s8		di_aformat;	/* format of attr fork's data */
 	__be32		di_dmevmask;	/* DMIG event mask */
@@ -906,7 +920,8 @@ typedef struct xfs_dinode {
 	__be64		di_flags2;	/* more random flags */
 	__be32		di_cowextsize;	/* basic cow extent size for file */
 	__be32		di_nextents_hi;
-	__u8		di_pad2[8];	/* more padding for future expansion */
+	__be16		di_anextents_hi;/* higher part of xattr extent count */
+	__u8		di_pad2[6];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_timestamp_t	di_crtime;	/* time created */
@@ -1073,14 +1088,16 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_47BIT_NEXTENTS_BIT 3 /* Uses di_nextents_hi field */
+#define XFS_DIFLAG2_32BIT_ANEXTENTS_BIT 4 /* Uses di_anextents_hi field  */
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_47BIT_NEXTENTS (1 << XFS_DIFLAG2_47BIT_NEXTENTS_BIT)
+#define XFS_DIFLAG2_32BIT_ANEXTENTS (1 << XFS_DIFLAG2_32BIT_ANEXTENTS_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_47BIT_NEXTENTS)
+	 XFS_DIFLAG2_47BIT_NEXTENTS | XFS_DIFLAG2_32BIT_ANEXTENTS)
 
 /*
  * Inode number format:
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 8b89fe080f70..285cbce0cd10 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -309,7 +309,8 @@ xfs_inode_to_disk(
 	to->di_extsize = cpu_to_be32(from->di_extsize);
 	to->di_nextents_lo = cpu_to_be32(xfs_ifork_nextents(&ip->i_df) &
 					0xffffffffU);
-	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+	to->di_anextents_lo = cpu_to_be16(xfs_ifork_nextents(ip->i_afp) &
+					0xffffU);
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
@@ -327,6 +328,10 @@ xfs_inode_to_disk(
 			to->di_nextents_hi
 				= cpu_to_be32(xfs_ifork_nextents(&ip->i_df)
 					>> 32);
+		if (from->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
+			to->di_anextents_hi
+				= cpu_to_be16(xfs_ifork_nextents(ip->i_afp)
+					>> 16);
 		to->di_ino = cpu_to_be64(ip->i_ino);
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
@@ -366,7 +371,7 @@ xfs_log_dinode_to_disk(
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
 	to->di_nextents_lo = cpu_to_be32(from->di_nextents_lo);
-	to->di_anextents = cpu_to_be16(from->di_anextents);
+	to->di_anextents_lo = cpu_to_be16(from->di_anextents_lo);
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat = from->di_aformat;
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
@@ -383,6 +388,9 @@ xfs_log_dinode_to_disk(
 		if (from->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
 			to->di_nextents_hi =
 				cpu_to_be32(from->di_nextents_hi);
+		if (from->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
+			to->di_anextents_hi =
+				cpu_to_be16(from->di_anextents_hi);
 		to->di_ino = cpu_to_be64(from->di_ino);
 		to->di_lsn = cpu_to_be64(from->di_lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
@@ -566,7 +574,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
 			return __this_address;
 	}
 
@@ -745,8 +753,13 @@ xfs_dfork_nextents(
 			&& (dip->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS))
 			nextents |= (u64)(be32_to_cpu(dip->di_nextents_hi))
 				<< 32;
-		return nextents;
 	} else {
-		return be16_to_cpu(dip->di_anextents);
+		nextents = be16_to_cpu(dip->di_anextents_lo);
+		if (xfs_sb_version_has_v3inode(sbp)
+			&& (dip->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS))
+			nextents |= (u32)(be16_to_cpu(dip->di_anextents_hi))
+				<< 16;
 	}
+
+	return nextents;
 }
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index ec682e2d5bcb..169e16947ece 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -301,7 +301,10 @@ xfs_iformat_attr_fork(
 	ip->i_afp->if_format = dip->di_aformat;
 	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
 		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
-	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
+	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents_lo);
+	if (ip->i_d.di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
+		ip->i_afp->if_nextents |=
+			(u32)(be16_to_cpu(dip->di_anextents_hi)) << 16;
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -777,6 +780,48 @@ xfs_next_set_data(
 	return 0;
 }
 
+static int
+xfs_next_set_attr(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_ifork	*ifp,
+	int			delta)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_aextnum_t		nr_exts;
+
+	nr_exts = ifp->if_nextents + delta;
+
+	if ((delta > 0 && nr_exts < ifp->if_nextents) ||
+		(delta < 0 && nr_exts > ifp->if_nextents))
+		return -EOVERFLOW;
+
+	if (ifp->if_nextents <= MAXAEXTNUM15BIT &&
+		nr_exts > MAXAEXTNUM15BIT &&
+		!(ip->i_d.di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS) &&
+		xfs_sb_version_has_v3inode(&mp->m_sb)) {
+		if (!xfs_sb_version_has32bitaext(&mp->m_sb)) {
+			bool log_sb = false;
+
+			spin_lock(&mp->m_sb_lock);
+			if (!xfs_sb_version_has32bitaext(&mp->m_sb)) {
+				xfs_sb_version_add32bitaext(&mp->m_sb);
+				log_sb = true;
+			}
+			spin_unlock(&mp->m_sb_lock);
+
+			if (log_sb)
+				xfs_log_sb(tp);
+		}
+
+		ip->i_d.di_flags2 |= XFS_DIFLAG2_32BIT_ANEXTENTS;
+	}
+
+	ifp->if_nextents = nr_exts;
+
+	return 0;
+}
+
 int
 xfs_next_set(
 	struct xfs_trans	*tp,
@@ -785,23 +830,16 @@ xfs_next_set(
 	int			delta)
 {
 	struct xfs_ifork	*ifp;
-	int64_t			nr_exts;
 	int			error = 0;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
+	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
 		error = xfs_next_set_data(tp, ip, ifp, delta);
-	} else if (whichfork == XFS_ATTR_FORK) {
-		nr_exts = ifp->if_nextents + delta;
-		if ((delta > 0 && nr_exts > MAXAEXTNUM)
-			|| (delta < 0 && nr_exts < 0))
-			return -EOVERFLOW;
-
-		ifp->if_nextents = nr_exts;
-	} else {
+	else if (whichfork == XFS_ATTR_FORK)
+		error = xfs_next_set_attr(tp, ip, ifp, delta);
+	else
 		ASSERT(0);
-	}
 
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 879aadff7692..db419fc862bc 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -397,7 +397,7 @@ struct xfs_log_dinode {
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
 	uint32_t	di_nextents_lo;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint16_t	di_anextents_lo;/* lower part of xattr extent count */
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
@@ -415,7 +415,8 @@ struct xfs_log_dinode {
 	uint64_t	di_flags2;	/* more random flags */
 	uint32_t	di_cowextsize;	/* basic cow extent size for file */
 	uint32_t	di_nextents_hi;
-	uint8_t		di_pad2[8];	/* more padding for future expansion */
+	uint16_t	di_anextents_hi;/* higher part of xattr extent count */
+	uint8_t		di_pad2[6];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_ictimestamp_t di_crtime;	/* time created */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index c68ff2178976..974737a9e9c1 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -13,7 +13,7 @@ typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
 typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
-typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
+typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
 typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
@@ -62,7 +62,8 @@ typedef void *		xfs_failaddr_t;
 #define	MAXEXTNUM31BIT	((xfs_extnum_t)0x7fffffff)	/* 31 bits */
 #define	MAXEXTNUM	((xfs_extnum_t)0x7fffffffffff)	/* 47 bits */
 #define	MAXDIREXTNUM	((xfs_extnum_t)0x7ffffff)	/* 27 bits */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+#define	MAXAEXTNUM15BIT	((xfs_aextnum_t)0x7fff)		/* 15 bits */
+#define	MAXAEXTNUM	((xfs_aextnum_t)0xffffffff)	/* 32 bits */
 
 /*
  * Minimum and maximum blocksize and sectorsize.
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index be41fd242ff2..01e60c78a3a3 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -371,10 +371,12 @@ xchk_dinode(
 		break;
 	}
 
+	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
+
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
-	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
+	if (nextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
 		xchk_ino_set_corrupt(sc, ino);
@@ -386,7 +388,6 @@ xchk_dinode(
 		xchk_ino_set_corrupt(sc, ino);
 
 	/* di_anextents */
-	nextents = be16_to_cpu(dip->di_anextents);
 	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4418a66cf6d6..6ec34e069344 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3789,6 +3789,10 @@ xfs_iflush_int(
 		&& xfs_sb_version_has47bitext(&mp->m_sb))
 		ip->i_d.di_flags2 |= XFS_DIFLAG2_47BIT_NEXTENTS;
 
+	if (!(ip->i_d.di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
+		&& xfs_sb_version_has32bitaext(&mp->m_sb))
+		ip->i_d.di_flags2 |= XFS_DIFLAG2_32BIT_ANEXTENTS;
+
 	/*
 	 * Copy the dirty parts of the inode into the on-disk inode.  We always
 	 * copy out the core of the inode, because if the inode is dirty at all
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6f27ac7c8631..40f0a19d1c07 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -327,7 +327,7 @@ xfs_inode_to_log_dinode(
 	to->di_nblocks = from->di_nblocks;
 	to->di_extsize = from->di_extsize;
 	to->di_nextents_lo = xfs_ifork_nextents(&ip->i_df) & 0xffffffffU;
-	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
+	to->di_anextents_lo = xfs_ifork_nextents(ip->i_afp) & 0xffffU;
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_dmevmask = from->di_dmevmask;
@@ -347,6 +347,9 @@ xfs_inode_to_log_dinode(
 		if (from->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
 			to->di_nextents_hi =
 				xfs_ifork_nextents(&ip->i_df) >> 32;
+		if (from->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
+			to->di_anextents_hi =
+				xfs_ifork_nextents(ip->i_afp) >> 16;
 		to->di_ino = ip->i_ino;
 		to->di_lsn = lsn;
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 8d64b861fb66..c8b5fbba848b 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -135,6 +135,7 @@ xlog_recover_inode_commit_pass2(
 	uint				isize;
 	int				need_free = 0;
 	xfs_extnum_t			nextents;
+	xfs_aextnum_t			anextents;
 
 	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
 		in_f = item->ri_buf[0].i_addr;
@@ -262,7 +263,12 @@ xlog_recover_inode_commit_pass2(
 		ldip->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
 		nextents |= ((u64)(ldip->di_nextents_hi) << 32);
 
-	nextents += ldip->di_anextents;
+	anextents = ldip->di_anextents_lo;
+	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
+		ldip->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
+		anextents |= ((u32)(ldip->di_anextents_hi) << 16);
+
+	nextents += anextents;
 
 	if (unlikely(nextents > ldip->di_nblocks)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
-- 
2.20.1

