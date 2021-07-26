Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB64C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DF69601FD
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbhGZLH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbhGZLH0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:07:26 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09208C061760
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:55 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j1so12500779pjv.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AuYAiDlMHDSUwElFVfGK6stg68LFnfCa70f00m7gXE0=;
        b=E02jAYhfrTYK7AOXoZgoTn8CBxB0CpxpdNnIhHrrfbsT+a/Qr0wXBMd4yqNv+V62Dw
         od5T50rSvdIcSTxNFQ9C8WqMdEM2ZoRuUBx2pmQL/pFDTXYGTPS3eLVZyl3ikq38/1FT
         KkhurqjFWmp0H6GMUJEbQUrBkgf+WbyCiAj7KqPN2H1J4pbTWQm4xtvjIQNDo2FULlxR
         osDtM6vgRDQxx6IOIXfvuJ6/GIEd5tqOjuaTz23HsEwM4QPSAbcq1dRSo0rplEE1cTqQ
         SqyEm9ZxtlfTW6n98uPgzXwFd7iWt/KG94cdoP0WdDyaFqLxfrWIWW/v9PvwrYOJ+tbq
         Knvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AuYAiDlMHDSUwElFVfGK6stg68LFnfCa70f00m7gXE0=;
        b=NxK8dGo8XOZEZz1btm4jdzUw8hEZOPmVbW+0zfMzwfwoZyfWeP3nBOoKTCU8XvxuwE
         hoEOsQTanYhGaBV3ZINJeXPYI3cjn/XHQrm19+GOoGxXAEW8v5WeNImY8Xv2zAT6v/Xk
         g+fYttltf4kvoOyRlUCL+OEHVqy5MuBoND7ew1TWKaNfJEz1AMdn75GqlHJgysGiT79Z
         gnxflDGmJFYou1Uyoa/UNR4OXVBSlGyJrqIOCQTbWNoEM+7/PiTagl4rYZZpB8p3w7qh
         swTZwAiocc25KTnPn6pjUDPE/ObjBXP131ZXgJIGfwGV0Z7C7JNAtA3acngMJSlgRi+n
         UHHQ==
X-Gm-Message-State: AOAM531Ft1EqGwBQt15AUAJV+Z4sP4HXSjhfCLJzZukYvC8kJYJH55BA
        V/rjXqwPDC/NuhHEkUxnSdJ6hiEK2nA=
X-Google-Smtp-Source: ABdhPJx4MGx4kUSlcx8zlsGlHbsGUECU0tgv3cuMu4LDFc6cgMhLSTzTOL4C8qBh+IvH7vYEsaZGPg==
X-Received: by 2002:a17:90b:212:: with SMTP id fy18mr5819122pjb.52.1627300074388;
        Mon, 26 Jul 2021 04:47:54 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id y10sm35936900pjy.18.2021.07.26.04.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:47:54 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 11/12] xfsprogs: Extend per-inode extent counter widths
Date:   Mon, 26 Jul 2021 17:17:23 +0530
Message-Id: <20210726114724.24956-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114724.24956-1-chandanrlinux@gmail.com>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a new 64-bit per-inode data extent counter. However the
maximum number of extents that a data fork can hold is limited to 2^48
extents. This feature is available only when
XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT feature bit is enabled on the
filesystem. Also, enabling this feature bit causes attr fork extent counter to
use the 32-bit extent counter that was previously used to hold the data fork
extent counter. This implies that the attr fork can now occupy a maximum of
2^32 extents.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 db/field.c                 |  4 ----
 db/field.h                 |  2 --
 db/inode.c                 | 30 +++++++++++++++++++++++++++---
 include/libxlog.h          |  6 ++++--
 libxfs/xfs_bmap.c          |  8 +++-----
 libxfs/xfs_format.h        | 15 +++++++++++++--
 libxfs/xfs_inode_buf.c     | 30 +++++++++++++++++++++++++-----
 libxfs/xfs_inode_fork.h    | 18 ++++++++++++++----
 libxfs/xfs_log_format.h    |  3 ++-
 logprint/log_misc.c        | 23 ++++++++++++++++++-----
 logprint/log_print_all.c   | 34 +++++++++++++++++++++++++++-------
 logprint/log_print_trans.c |  2 +-
 repair/bmap_repair.c       | 10 ++++++++--
 repair/dinode.c            | 15 ++++++++++++---
 14 files changed, 154 insertions(+), 46 deletions(-)

diff --git a/db/field.c b/db/field.c
index 51268938a..1e274ffc4 100644
--- a/db/field.c
+++ b/db/field.c
@@ -25,8 +25,6 @@
 #include "symlink.h"
 
 const ftattr_t	ftattrtab[] = {
-	{ FLDT_AEXTNUM, "aextnum", fp_num, "%d", SI(bitsz(xfs_aextnum_t)),
-	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_AGBLOCK, "agblock", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
 	  FTARG_DONULL, fa_agblock, NULL },
 	{ FLDT_AGBLOCKNZ, "agblocknz", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
@@ -300,8 +298,6 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_DONULL, fa_drtbno, NULL },
 	{ FLDT_EXTLEN, "extlen", fp_num, "%u", SI(bitsz(xfs_extlen_t)), 0, NULL,
 	  NULL },
-	{ FLDT_EXTNUM, "extnum", fp_num, "%d", SI(bitsz(xfs_extnum_t)),
-	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_FSIZE, "fsize", fp_num, "%lld", SI(bitsz(xfs_fsize_t)),
 	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_INO, "ino", fp_num, "%llu", SI(bitsz(xfs_ino_t)), FTARG_DONULL,
diff --git a/db/field.h b/db/field.h
index 387c189ec..614fd0ab4 100644
--- a/db/field.h
+++ b/db/field.h
@@ -5,7 +5,6 @@
  */
 
 typedef enum fldt	{
-	FLDT_AEXTNUM,
 	FLDT_AGBLOCK,
 	FLDT_AGBLOCKNZ,
 	FLDT_AGF,
@@ -143,7 +142,6 @@ typedef enum fldt	{
 	FLDT_DRFSBNO,
 	FLDT_DRTBNO,
 	FLDT_EXTLEN,
-	FLDT_EXTNUM,
 	FLDT_FSIZE,
 	FLDT_INO,
 	FLDT_INOBT,
diff --git a/db/inode.c b/db/inode.c
index 27251f02f..6f941184c 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -37,6 +37,8 @@ static int	inode_u_muuid_count(void *obj, int startoff);
 static int	inode_u_sfdir2_count(void *obj, int startoff);
 static int	inode_u_sfdir3_count(void *obj, int startoff);
 static int	inode_u_symlink_count(void *obj, int startoff);
+static int	inode_v3_64bitext_count(void *obj, int startoff);
+static int	inode_v3_pad2_count(void *obj, int startoff);
 
 static const cmdinfo_t	inode_cmd =
 	{ "inode", NULL, inode_f, 0, 1, 1, "[inode#]",
@@ -100,8 +102,8 @@ const field_t	inode_core_flds[] = {
 	{ "size", FLDT_FSIZE, OI(COFF(size)), C1, 0, TYP_NONE },
 	{ "nblocks", FLDT_DRFSBNO, OI(COFF(nblocks)), C1, 0, TYP_NONE },
 	{ "extsize", FLDT_EXTLEN, OI(COFF(extsize)), C1, 0, TYP_NONE },
-	{ "nextents32", FLDT_EXTNUM, OI(COFF(nextents32)), C1, 0, TYP_NONE },
-	{ "nextents16", FLDT_AEXTNUM, OI(COFF(nextents16)), C1, 0, TYP_NONE },
+	{ "nextents32", FLDT_UINT32D, OI(COFF(nextents32)), C1, 0, TYP_NONE },
+	{ "nextents16", FLDT_UINT16D, OI(COFF(nextents16)), C1, 0, TYP_NONE },
 	{ "forkoff", FLDT_UINT8D, OI(COFF(forkoff)), C1, 0, TYP_NONE },
 	{ "aformat", FLDT_DINODE_FMT, OI(COFF(aformat)), C1, 0, TYP_NONE },
 	{ "dmevmask", FLDT_UINT32X, OI(COFF(dmevmask)), C1, 0, TYP_NONE },
@@ -162,7 +164,10 @@ const field_t	inode_v3_flds[] = {
 	{ "lsn", FLDT_UINT64X, OI(COFF(lsn)), C1, 0, TYP_NONE },
 	{ "flags2", FLDT_UINT64X, OI(COFF(flags2)), C1, 0, TYP_NONE },
 	{ "cowextsize", FLDT_EXTLEN, OI(COFF(cowextsize)), C1, 0, TYP_NONE },
-	{ "pad2", FLDT_UINT8X, OI(OFF(pad2)), CI(12), FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
+	{ "nextents64", FLDT_UINT64D, OI(COFF(nextents64)),
+	  inode_v3_64bitext_count, FLD_COUNT, TYP_NONE },
+	{ "pad2", FLDT_UINT8X, OI(OFF(pad2)), inode_v3_pad2_count,
+	  FLD_ARRAY|FLD_COUNT|FLD_SKIPALL, TYP_NONE },
 	{ "crtime", FLDT_TIMESTAMP, OI(COFF(crtime)), C1, 0, TYP_NONE },
 	{ "inumber", FLDT_INO, OI(COFF(ino)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(COFF(uuid)), C1, 0, TYP_NONE },
@@ -410,6 +415,25 @@ inode_core_projid_count(
 	return dic->di_version >= 2;
 }
 
+static int
+inode_v3_64bitext_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_sb_version_hasextcount_64bit(&mp->m_sb);
+}
+
+static int
+inode_v3_pad2_count(
+	void		*obj,
+	int		startoff)
+{
+	if (xfs_sb_version_hasextcount_64bit(&mp->m_sb))
+		return 4;
+	else
+		return 12;
+}
+
 static int
 inode_f(
 	int		argc,
diff --git a/include/libxlog.h b/include/libxlog.h
index adaa9963c..fe30481cf 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -89,13 +89,15 @@ extern int	xlog_find_tail(struct xlog *log, xfs_daddr_t *head_blk,
 
 extern int	xlog_recover(struct xlog *log, int readonly);
 extern void	xlog_recover_print_data(char *p, int len);
-extern void	xlog_recover_print_logitem(struct xlog_recover_item *item);
+extern void	xlog_recover_print_logitem(struct xlog *log,
+			struct xlog_recover_item *item);
 extern void	xlog_recover_print_trans_head(struct xlog_recover *tr);
 extern int	xlog_print_find_oldest(struct xlog *log, xfs_daddr_t *last_blk);
 
 /* for transactional view */
 extern void	xlog_recover_print_trans_head(struct xlog_recover *tr);
-extern void	xlog_recover_print_trans(struct xlog_recover *trans,
+extern void	xlog_recover_print_trans(struct xlog *log,
+				struct xlog_recover *trans,
 				struct list_head *itemq, int print);
 extern int	xlog_do_recovery_pass(struct xlog *log, xfs_daddr_t head_blk,
 				xfs_daddr_t tail_blk, int pass);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index dd60d8105..155d1e935 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -47,18 +47,16 @@ xfs_bmap_compute_maxlevels(
 	int		whichfork)	/* data or attr fork */
 {
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	uint64_t	maxblocks;	/* max blocks at this level */
 	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
 	int		sz;		/* root block size */
 
 	/*
-	 * The maximum number of extents in a file, hence the maximum number of
-	 * leaf entries, is controlled by the size of the on-disk extent count,
-	 * either a signed 32-bit number for the data fork, or a signed 16-bit
-	 * number for the attr fork.
+	 * The maximum number of extents in a fork, hence the maximum number of
+         * leaf entries, is controlled by the size of the on-disk extent count.
 	 *
 	 * Note that we can no longer assume that if we are in ATTR1 that the
 	 * fork offset of all the inodes will be
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 6564bc135..db3085974 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -485,13 +485,15 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 5)	/* metadata dir tree */
+#define XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT (1 << 6) 	/* 64-bit inode fork extent counters */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_METADIR)
+		 XFS_SB_FEAT_INCOMPAT_METADIR| \
+		 XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
@@ -591,6 +593,12 @@ static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
 }
 
+static inline bool xfs_sb_version_hasextcount_64bit(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT);
+}
+
 static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
@@ -1057,7 +1065,8 @@ typedef struct xfs_dinode {
 	__be64		di_lsn;		/* flush sequence */
 	__be64		di_flags2;	/* more random flags */
 	__be32		di_cowextsize;	/* basic cow extent size for file */
-	__u8		di_pad2[12];	/* more padding for future expansion */
+	__u8		di_pad2[4];	/* more padding for future expansion */
+	__be64		di_nextents64;	/* 64-bit extent counter */
 
 	/* fields only written to during inode creation */
 	xfs_timestamp_t	di_crtime;	/* time created */
@@ -1113,6 +1122,8 @@ enum xfs_dinode_fmt {
  * Max values for extlen, disk inode's extent counters.
  */
 #define	MAXEXTLEN		((uint32_t)0x1fffff) /* 21 bits */
+#define XFS_IFORK_EXTCNT_MAXU48	((uint64_t)0xffffffffffff) /* Unsigned 48-bits */
+#define XFS_IFORK_EXTCNT_MAXU32	((uint32_t)0xffffffff) 	/* Unsigned 32-bits */
 #define XFS_IFORK_EXTCNT_MAXS32 ((int32_t)0x7fffffff)  /* Signed 32-bits */
 #define XFS_IFORK_EXTCNT_MAXS16 ((int16_t)0x7fff)      /* Signed 16-bits */
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 95fd95cc0..25877251f 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -288,6 +288,7 @@ xfs_inode_to_disk(
 	struct xfs_dinode	*to,
 	xfs_lsn_t		lsn)
 {
+	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
@@ -307,11 +308,9 @@ xfs_inode_to_disk(
 	to->di_gen = cpu_to_be32(inode->i_generation);
 	to->di_mode = cpu_to_be16(inode->i_mode);
 
-	to->di_size = cpu_to_be64(ip->i_disk_size);
+        to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
-	to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
-	to->di_nextents16 = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
@@ -331,6 +330,19 @@ xfs_inode_to_disk(
 		to->di_version = 2;
 		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
 	}
+
+	if (xfs_sb_version_hasextcount_64bit(sbp)) {
+		to->di_nextents64 = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
+		to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
+		/*
+		 * xchk_dinode() passes an uninitialized disk inode. Hence,
+		 * clear di_nextents16 field explicitly.
+		 */
+		to->di_nextents16 = cpu_to_be16(0);
+	} else {
+		to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
+		to->di_nextents16 = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+	}
 }
 
 static xfs_failaddr_t
@@ -383,14 +395,22 @@ xfs_dfork_nextents(
 	xfs_extnum_t		*nextents)
 {
 	int			error = 0;
+	bool			has_64bit_extcnt;
+
+	has_64bit_extcnt = xfs_sb_version_hasextcount_64bit(&mp->m_sb);
+
+	if (has_64bit_extcnt && dip->di_nextents16 != 0)
+		return -EFSCORRUPTED;
 
 	switch (whichfork) {
 	case XFS_DATA_FORK:
-		*nextents = be32_to_cpu(dip->di_nextents32);
+		*nextents = has_64bit_extcnt ? be64_to_cpu(dip->di_nextents64)
+			: be32_to_cpu(dip->di_nextents32);
 		break;
 
 	case XFS_ATTR_FORK:
-		*nextents = be16_to_cpu(dip->di_nextents16);
+		*nextents = has_64bit_extcnt ? be32_to_cpu(dip->di_nextents32)
+			: be16_to_cpu(dip->di_nextents16);
 		break;
 
 	default:
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 1eda21636..cc8145941 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -135,10 +135,20 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 
 static inline xfs_extnum_t xfs_iext_max(struct xfs_mount *mp, int whichfork)
 {
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return XFS_IFORK_EXTCNT_MAXS32;
-	else
-		return XFS_IFORK_EXTCNT_MAXS16;
+	bool has_64bit_extcnt = xfs_sb_version_hasextcount_64bit(&mp->m_sb);
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+	case XFS_COW_FORK:
+		return has_64bit_extcnt ? XFS_IFORK_EXTCNT_MAXU48 : XFS_IFORK_EXTCNT_MAXS32;
+
+	case XFS_ATTR_FORK:
+		return has_64bit_extcnt ? XFS_IFORK_EXTCNT_MAXU32 : XFS_IFORK_EXTCNT_MAXS16;
+
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index ca8e4ad83..9b5d64708 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -420,7 +420,8 @@ struct xfs_log_dinode {
 	xfs_lsn_t	di_lsn;		/* flush sequence */
 	uint64_t	di_flags2;	/* more random flags */
 	uint32_t	di_cowextsize;	/* basic cow extent size for file */
-	uint8_t		di_pad2[12];	/* more padding for future expansion */
+	uint8_t		di_pad2[4];	/* more padding for future expansion */
+	uint64_t	di_nextents64; /* higher part of data fork extent count */
 
 	/* fields only written to during inode creation */
 	xfs_log_timestamp_t di_crtime;	/* time created */
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 4e8760c43..1fb580c58 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -438,8 +438,11 @@ xlog_print_trans_qoff(char **ptr, uint len)
 
 static void
 xlog_print_trans_inode_core(
+	struct xfs_mount	*mp,
 	struct xfs_log_dinode	*ip)
 {
+    xfs_extnum_t		nextents;
+
     printf(_("INODE CORE\n"));
     printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
 	   ip->di_magic, ip->di_mode, (int)ip->di_version,
@@ -450,11 +453,21 @@ xlog_print_trans_inode_core(
 		xlog_extract_dinode_ts(ip->di_atime),
 		xlog_extract_dinode_ts(ip->di_mtime),
 		xlog_extract_dinode_ts(ip->di_ctime));
-    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%x\n"),
+
+    if (xfs_sb_version_hasextcount_64bit(&mp->m_sb))
+	    nextents = ip->di_nextents64;
+    else
+	    nextents = ip->di_nextents32;
+    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%lx\n"),
 	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
-	   ip->di_extsize, ip->di_nextents32);
-    printf(_("naextents 0x%x forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
-	   ip->di_nextents16, (int)ip->di_forkoff, ip->di_dmevmask,
+	   ip->di_extsize, nextents);
+
+    if (xfs_sb_version_hasextcount_64bit(&mp->m_sb))
+	    nextents = ip->di_nextents32;
+    else
+	    nextents = ip->di_nextents16;
+    printf(_("naextents 0x%lx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
+	   nextents, (int)ip->di_forkoff, ip->di_dmevmask,
 	   ip->di_dmstate);
     printf(_("flags 0x%x gen 0x%x\n"),
 	   ip->di_flags, ip->di_gen);
@@ -564,7 +577,7 @@ xlog_print_trans_inode(
     memmove(&dino, *ptr, sizeof(dino));
     mode = dino.di_mode & S_IFMT;
     size = (int)dino.di_size;
-    xlog_print_trans_inode_core(&dino);
+    xlog_print_trans_inode_core(log->l_mp, &dino);
     *ptr += xfs_log_dinode_size(log->l_mp);
     skip_count--;
 
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 403c56372..b528e1c57 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -238,9 +238,14 @@ xlog_recover_print_dquot(
 
 STATIC void
 xlog_recover_print_inode_core(
+	struct xlog		*log,
 	struct xfs_log_dinode	*di)
 {
-	printf(_("	CORE inode:\n"));
+	struct xfs_sb		*sbp = &log->l_mp->m_sb;
+	xfs_extnum_t		nextents;
+	xfs_aextnum_t		anextents;
+
+        printf(_("	CORE inode:\n"));
 	if (!print_inode)
 		return;
 	printf(_("		magic:%c%c  mode:0x%x  ver:%d  format:%d\n"),
@@ -254,10 +259,21 @@ xlog_recover_print_inode_core(
 			xlog_extract_dinode_ts(di->di_mtime),
 			xlog_extract_dinode_ts(di->di_ctime));
 	printf(_("		flushiter:%d\n"), di->di_flushiter);
+
+	if (xfs_sb_version_hasextcount_64bit(sbp))
+		nextents = di->di_nextents64;
+	else
+		nextents = di->di_nextents32;
+
+	if (xfs_sb_version_hasextcount_64bit(sbp))
+		anextents = di->di_nextents32;
+	else
+		anextents = di->di_nextents16;
+
 	printf(_("		size:0x%llx  nblks:0x%llx  exsize:%d  "
-	     "nextents:%d  anextents:%d\n"), (unsigned long long)
+	     "nextents:%lu  anextents:%u\n"), (unsigned long long)
 	       di->di_size, (unsigned long long)di->di_nblocks,
-	       di->di_extsize, di->di_nextents32, (int)di->di_nextents16);
+	       di->di_extsize, nextents, anextents);
 	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "
 	     "gen:%u\n"),
 	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
@@ -270,6 +286,7 @@ xlog_recover_print_inode_core(
 
 STATIC void
 xlog_recover_print_inode(
+	struct xlog		*log,
 	struct xlog_recover_item *item)
 {
 	struct xfs_inode_log_format	f_buf;
@@ -291,7 +308,7 @@ xlog_recover_print_inode(
 	ASSERT(item->ri_buf[1].i_len ==
 			offsetof(struct xfs_log_dinode, di_next_unlinked) ||
 	       item->ri_buf[1].i_len == sizeof(struct xfs_log_dinode));
-	xlog_recover_print_inode_core((struct xfs_log_dinode *)
+	xlog_recover_print_inode_core(log, (struct xfs_log_dinode *)
 				      item->ri_buf[1].i_addr);
 
 	hasdata = (f->ilf_fields & XFS_ILOG_DFORK) != 0;
@@ -386,6 +403,7 @@ xlog_recover_print_icreate(
 
 void
 xlog_recover_print_logitem(
+	struct xlog			*log,
 	struct xlog_recover_item	*item)
 {
 	switch (ITEM_TYPE(item)) {
@@ -396,7 +414,7 @@ xlog_recover_print_logitem(
 		xlog_recover_print_icreate(item);
 		break;
 	case XFS_LI_INODE:
-		xlog_recover_print_inode(item);
+		xlog_recover_print_inode(log, item);
 		break;
 	case XFS_LI_EFD:
 		xlog_recover_print_efd(item);
@@ -442,6 +460,7 @@ xlog_recover_print_logitem(
 
 static void
 xlog_recover_print_item(
+	struct xlog		*log,
 	struct xlog_recover_item *item)
 {
 	int			i;
@@ -507,11 +526,12 @@ xlog_recover_print_item(
 		       (long)item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 	}
 	printf("\n");
-	xlog_recover_print_logitem(item);
+	xlog_recover_print_logitem(log, item);
 }
 
 void
 xlog_recover_print_trans(
+	struct xlog		*log,
 	struct xlog_recover	*trans,
 	struct list_head	*itemq,
 	int			print)
@@ -524,5 +544,5 @@ xlog_recover_print_trans(
 	print_xlog_record_line();
 	xlog_recover_print_trans_head(trans);
 	list_for_each_entry(item, itemq, ri_list)
-		xlog_recover_print_item(item);
+		xlog_recover_print_item(log, item);
 }
diff --git a/logprint/log_print_trans.c b/logprint/log_print_trans.c
index 2004b5a0e..c6386fb0c 100644
--- a/logprint/log_print_trans.c
+++ b/logprint/log_print_trans.c
@@ -24,7 +24,7 @@ xlog_recover_do_trans(
 	struct xlog_recover	*trans,
 	int			pass)
 {
-	xlog_recover_print_trans(trans, &trans->r_itemq, 3);
+	xlog_recover_print_trans(log, trans, &trans->r_itemq, 3);
 	return 0;
 }
 
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index f41a18f00..a9fca82f1 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -536,7 +536,10 @@ rebuild_bmap(
 		if (nextents == 0)
 			return 0;
 		(*dinop)->di_format = XFS_DINODE_FMT_EXTENTS;
-		(*dinop)->di_nextents32 = 0;
+		if (xfs_sb_version_hasextcount_64bit(&mp->m_sb))
+			(*dinop)->di_nextents64 = cpu_to_be64(0);
+		else
+			(*dinop)->di_nextents32 = cpu_to_be32(0);
 		libxfs_dinode_calc_crc(mp, *dinop);
 		*dirty = 1;
 		break;
@@ -547,7 +550,10 @@ rebuild_bmap(
 		if (nextents == 0)
 			return 0;
 		(*dinop)->di_aformat = XFS_DINODE_FMT_EXTENTS;
-		(*dinop)->di_nextents16 = 0;
+		if (xfs_sb_version_hasextcount_64bit(&mp->m_sb))
+			(*dinop)->di_nextents32 = cpu_to_be32(0);
+		else
+			(*dinop)->di_nextents16 = cpu_to_be16(0);
 		libxfs_dinode_calc_crc(mp, *dinop);
 		*dirty = 1;
 		break;
diff --git a/repair/dinode.c b/repair/dinode.c
index beeb9ed07..5d2dff70a 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -78,7 +78,10 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	if (anextents != 0) {
 		if (no_modify)
 			return(1);
-		dino->di_nextents16 = cpu_to_be16(0);
+		if (xfs_sb_version_hasextcount_64bit(&mp->m_sb))
+			dino->di_nextents32 = cpu_to_be32(0);
+		else
+			dino->di_nextents16 = cpu_to_be16(0);
 	}
 
 	if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
@@ -1870,7 +1873,10 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting nextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, nextents);
-			dino->di_nextents32 = cpu_to_be32(nextents);
+			if (xfs_sb_version_hasextcount_64bit(&mp->m_sb))
+				dino->di_nextents64 = cpu_to_be64(nextents);
+			else
+				dino->di_nextents32 = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
@@ -1894,7 +1900,10 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting anextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, anextents);
-			dino->di_nextents16 = cpu_to_be16(anextents);
+			if (xfs_sb_version_hasextcount_64bit(&mp->m_sb))
+				dino->di_nextents32 = cpu_to_be32(anextents);
+			else
+				dino->di_nextents16 = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
-- 
2.30.2

