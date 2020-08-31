Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F316C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB3D420936
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:02:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bns/5Kwo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHaNBn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgHaNBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 09:01:24 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398B3C061236
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:01:24 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ls14so2912638pjb.3
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PgOkq/1P7FrtVRUIES8U5RkzxWx8uafGmpfkhfunN1g=;
        b=bns/5KwoK4Ig5EQgFljuPDSTjAODeihhVVqgyjOnjy6lAm3zQPCzhNbsx8yv84bRvI
         NgrPT5hc4LxTiT2intsUd4KS5IaiSqrk5cSgyEAMfloLqogzqy6SWczgTv8d1b509cPV
         4PZoRR62Rt3cONWYALH41XhSNB+qNiQVH4vxwFU42B1hIPGmcfD3gBtS2HcV5RefsYhC
         hZaM1dBIGL67PahtQ61TTONvVdDUqDHAXNDtpn+8iBM5gxj5ss/jTdRo2jB4xYZOHdyo
         hdEIuG4UPACWeNEsuq+AFq8GZAZl2dLBBvRuxPW11prRxGK67LW4TlXUx368oF5WnvHa
         qCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PgOkq/1P7FrtVRUIES8U5RkzxWx8uafGmpfkhfunN1g=;
        b=AtDgP65xz2AgVaJ5dBla0EgFEJ4JgXFwpKRnuUxKV3n/Nv4y/wG1iIodNJZabkkYfu
         nAFzOntfl6jeOqtxl7GGmpBxfTXiviDNYsIfp39bENfReHMcJEJ5A1ZNcNLL97BB4Coo
         ECpX8R1ck+CpFT/Rn/a8gjrGRqMq1YdGbJcuLFSAkF2jHI+tMz4kit0kMepoePUz9xx5
         clcRZk9ZnnkfBSQbdcBCPm99HAPQtOhTgUK5U2zCfsvNLt6ahYW+GdDF6QQuq8d7qvzc
         LWfEXowUctA8+caeEJPByars4Oitfq15Vc6BCTH2UVQunu10TdphD6rnWdskfC4Pw5t6
         AXQw==
X-Gm-Message-State: AOAM531OEr5GzjK/q3E7XUoMx5l917JoQZEAERSsZkaUI9TzURTVBro9
        FLpz9e6UxIIR/ypgrQlwTBnCjSjTrog=
X-Google-Smtp-Source: ABdhPJwL/mht47NWok03U2g3vMdxIWM2+pKt+roYB2rHBWgRzkFcMyKy68sNBL24EFzgfImw7AUTIQ==
X-Received: by 2002:a17:902:b108:: with SMTP id q8mr955218plr.161.1598878882874;
        Mon, 31 Aug 2020 06:01:22 -0700 (PDT)
Received: from localhost.localdomain ([122.167.36.194])
        by smtp.gmail.com with ESMTPSA id o2sm7643220pjh.4.2020.08.31.06.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 06:01:22 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH 3/4] xfsprogs: Extend data/attr fork extent counter width
Date:   Mon, 31 Aug 2020 18:31:01 +0530
Message-Id: <20200831130102.507-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831130102.507-1-chandanrlinux@gmail.com>
References: <20200831130102.507-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The kernel commit xfs: fix inode fork extent count overflow
(3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
data fork extents should be possible to create. However the
corresponding on-disk field has a signed 32-bit type. Hence this
commit extends the per-inode data extent counter to 47 bits. The
length of 47-bits was chosen because,
Maximum file size = 2^63.
Maximum extent count when using 64k block size = 2^63 / 2^16 = 2^47.

Also, XFS has a per-inode xattr extent counter which is 16 bits
wide. A workload which
1. Creates 1 million 255-byte sized xattrs,
2. Deletes 50% of these xattrs in an alternating manner,
3. Tries to insert 400,000 new 255-byte sized xattrs
   causes the xattr extent counter to overflow.

Dave tells me that there are instances where a single file has more than
100 million hardlinks. With parent pointers being stored in xattrs, we
will overflow the signed 16-bits wide xattr extent counter when large
number of hardlinks are created. Hence this commit extends the on-disk
field to 32-bits.

The following changes are made to accomplish this,

1. A new incompat superblock flag to prevent older kernels from mounting
   the filesystem. This flag has to be set during mkfs time.
2. Carve out a new 32-bit field from xfs_dinode->di_pad2[]. This field
   holds the most significant 15 bits of the data extent counter.
3. Carve out a new 16-bit field from xfs_dinode->di_pad2[]. This field
   holds the most significant 16 bits of the attr extent counter.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 db/bmap.c                  |  2 +-
 db/field.c                 |  4 ---
 db/field.h                 |  2 --
 db/inode.c                 | 17 ++++++++++--
 include/libxlog.h          |  6 +++--
 libxfs/xfs_bmap.c          | 12 +++++----
 libxfs/xfs_format.h        | 20 ++++++++++----
 libxfs/xfs_inode_buf.c     | 53 ++++++++++++++++++++++++++++++--------
 libxfs/xfs_inode_buf.h     |  4 +--
 libxfs/xfs_inode_fork.c    |  4 +--
 libxfs/xfs_inode_fork.h    | 15 ++++++++---
 libxfs/xfs_log_format.h    |  8 +++---
 libxfs/xfs_types.h         |  6 +++--
 logprint/log_misc.c        | 21 +++++++++++----
 logprint/log_print_all.c   | 30 ++++++++++++++++-----
 logprint/log_print_trans.c |  2 +-
 repair/dinode.c            | 28 ++++++++++++--------
 17 files changed, 165 insertions(+), 69 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 9800a909..c374fa48 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -47,7 +47,7 @@ bmap(
 	int			n;
 	int			nex;
 	xfs_fsblock_t		nextbno;
-	int			nextents;
+	xfs_extnum_t		nextents;
 	xfs_bmbt_ptr_t		*pp;
 	xfs_bmdr_block_t	*rblock;
 	typnm_t			typ;
diff --git a/db/field.c b/db/field.c
index aa0154d8..2d707e4e 100644
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
index 15065373..7ebc9a1e 100644
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
index 3853092c..50a942b6 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -37,6 +37,7 @@ static int	inode_u_muuid_count(void *obj, int startoff);
 static int	inode_u_sfdir2_count(void *obj, int startoff);
 static int	inode_u_sfdir3_count(void *obj, int startoff);
 static int	inode_u_symlink_count(void *obj, int startoff);
+static int	inode_v3_wideextcnt_count(void *obj, int startoff);
 
 static const cmdinfo_t	inode_cmd =
 	{ "inode", NULL, inode_f, 0, 1, 1, "[inode#]",
@@ -100,8 +101,8 @@ const field_t	inode_core_flds[] = {
 	{ "size", FLDT_FSIZE, OI(COFF(size)), C1, 0, TYP_NONE },
 	{ "nblocks", FLDT_DRFSBNO, OI(COFF(nblocks)), C1, 0, TYP_NONE },
 	{ "extsize", FLDT_EXTLEN, OI(COFF(extsize)), C1, 0, TYP_NONE },
-	{ "nextents", FLDT_EXTNUM, OI(COFF(nextents)), C1, 0, TYP_NONE },
-	{ "naextents", FLDT_AEXTNUM, OI(COFF(anextents)), C1, 0, TYP_NONE },
+	{ "nextents_lo", FLDT_UINT32D, OI(COFF(nextents_lo)), C1, 0, TYP_NONE },
+	{ "naextents_lo", FLDT_UINT16D, OI(COFF(anextents_lo)), C1, 0, TYP_NONE },
 	{ "forkoff", FLDT_UINT8D, OI(COFF(forkoff)), C1, 0, TYP_NONE },
 	{ "aformat", FLDT_DINODE_FMT, OI(COFF(aformat)), C1, 0, TYP_NONE },
 	{ "dmevmask", FLDT_UINT32X, OI(COFF(dmevmask)), C1, 0, TYP_NONE },
@@ -162,6 +163,10 @@ const field_t	inode_v3_flds[] = {
 	{ "lsn", FLDT_UINT64X, OI(COFF(lsn)), C1, 0, TYP_NONE },
 	{ "flags2", FLDT_UINT64X, OI(COFF(flags2)), C1, 0, TYP_NONE },
 	{ "cowextsize", FLDT_EXTLEN, OI(COFF(cowextsize)), C1, 0, TYP_NONE },
+	{ "nextents_hi", FLDT_UINT32D, OI(COFF(nextents_hi)),
+	  inode_v3_wideextcnt_count, FLD_COUNT, TYP_NONE },
+	{ "naextents_hi", FLDT_UINT16D, OI(COFF(anextents_hi)),
+	  inode_v3_wideextcnt_count, FLD_COUNT, TYP_NONE },
 	{ "pad2", FLDT_UINT8X, OI(OFF(pad2)), CI(12), FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
 	{ "crtime", FLDT_TIMESTAMP, OI(COFF(crtime)), C1, 0, TYP_NONE },
 	{ "inumber", FLDT_INO, OI(COFF(ino)), C1, 0, TYP_NONE },
@@ -396,6 +401,14 @@ inode_core_projid_count(
 	return dic->di_version >= 2;
 }
 
+static int
+inode_v3_wideextcnt_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_sb_version_haswideextcnt(&mp->m_sb);
+}
+
 static int
 inode_f(
 	int		argc,
diff --git a/include/libxlog.h b/include/libxlog.h
index 5e94fa1e..1aab108c 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -89,13 +89,15 @@ extern int	xlog_find_tail(struct xlog *log, xfs_daddr_t *head_blk,
 
 extern int	xlog_recover(struct xlog *log, int readonly);
 extern void	xlog_recover_print_data(char *p, int len);
-extern void	xlog_recover_print_logitem(xlog_recover_item_t *item);
+extern void	xlog_recover_print_logitem(struct xlog *log,
+			xlog_recover_item_t *item);
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
index dae4d339..118b6e96 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -45,19 +45,21 @@ xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	int		whichfork)	/* data or attr fork */
 {
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
 	int		sz;		/* root block size */
 
 	/*
-	 * The maximum number of extents in a file, hence the maximum
-	 * number of leaf entries, is controlled by the type of di_nextents
-	 * (a signed 32-bit number, xfs_extnum_t), or by di_anextents
-	 * (a signed 16-bit number, xfs_aextnum_t).
+	 * The maximum number of extents in a file, hence the maximum number of
+	 * leaf entries, is controlled by the size of the on-disk extent count,
+	 * either a signed 32-bit number for the data fork, or a signed 16-bit
+	 * number for the attr fork. With mkfs.xfs' wide-extcount option
+	 * enabled, the data fork extent count is unsigned 47-bits wide, while
+	 * the corresponding attr fork extent count is unsigned 32-bits wide.
 	 *
 	 * Note that we can no longer assume that if we are in ATTR1 that
 	 * the fork offset of all the inodes will be
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 188deada..ab44bcb4 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -464,11 +464,13 @@ xfs_sb_has_ro_compat_feature(
 
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
 #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
-#define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
+#define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)        /* metadata UUID */
+#define XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT	(1 << 3)	/* Wider data/attr fork extent counters */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
-		 XFS_SB_FEAT_INCOMPAT_META_UUID)
+		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
+		 XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
@@ -551,6 +553,12 @@ static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
 }
 
+static inline bool xfs_sb_version_haswideextcnt(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT);
+}
+
 static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
@@ -873,8 +881,8 @@ typedef struct xfs_dinode {
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	__be32		di_nextents_lo;	/* lower part of data fork extent count */
+	__be16		di_anextents_lo;/* lower part of attr fork extent count */
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	__s8		di_aformat;	/* format of attr fork's data */
 	__be32		di_dmevmask;	/* DMIG event mask */
@@ -891,7 +899,9 @@ typedef struct xfs_dinode {
 	__be64		di_lsn;		/* flush sequence */
 	__be64		di_flags2;	/* more random flags */
 	__be32		di_cowextsize;	/* basic cow extent size for file */
-	__u8		di_pad2[12];	/* more padding for future expansion */
+	__be32		di_nextents_hi; /* higher part of data fork extent count */
+	__be16		di_anextents_hi;/* higher part of attr fork extent count */
+	__u8		di_pad2[6];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_timestamp_t	di_crtime;	/* time created */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index d5584372..219d0234 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -188,6 +188,7 @@ xfs_inode_from_disk(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*from)
 {
+	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
@@ -228,8 +229,8 @@ xfs_inode_from_disk(
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
 	to->di_extsize = be32_to_cpu(from->di_extsize);
-	to->di_nextents = be32_to_cpu(from->di_nextents);
-	to->di_anextents = be16_to_cpu(from->di_anextents);
+	to->di_nextents = be32_to_cpu(from->di_nextents_lo);
+	to->di_anextents = be16_to_cpu(from->di_anextents_lo);
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat	= from->di_aformat;
 	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
@@ -243,6 +244,13 @@ xfs_inode_from_disk(
 		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
+
+		if (xfs_sb_version_haswideextcnt(sbp)) {
+			to->di_nextents |=
+				((uint64_t)(be32_to_cpu(from->di_nextents_hi)) << 32);
+			to->di_anextents |=
+				((uint32_t)(be16_to_cpu(from->di_anextents_hi)) << 16);
+		}
 	}
 }
 
@@ -252,6 +260,7 @@ xfs_inode_to_disk(
 	struct xfs_dinode	*to,
 	xfs_lsn_t		lsn)
 {
+	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
 	struct xfs_icdinode	*from = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
@@ -278,8 +287,8 @@ xfs_inode_to_disk(
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
-	to->di_nextents = cpu_to_be32(from->di_nextents);
-	to->di_anextents = cpu_to_be16(from->di_anextents);
+	to->di_nextents_lo = cpu_to_be32(from->di_nextents);
+	to->di_anextents_lo = cpu_to_be16(from->di_anextents);
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat = from->di_aformat;
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
@@ -293,6 +302,12 @@ xfs_inode_to_disk(
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
+		if (xfs_sb_version_haswideextcnt(sbp)) {
+			to->di_nextents_hi
+				= cpu_to_be32(from->di_nextents >> 32);
+			to->di_anextents_hi
+				= cpu_to_be16(from->di_nextents >> 16);
+		}
 		to->di_ino = cpu_to_be64(ip->i_ino);
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
@@ -306,9 +321,12 @@ xfs_inode_to_disk(
 
 void
 xfs_log_dinode_to_disk(
+	struct xfs_mount	*mp,
 	struct xfs_log_dinode	*from,
 	struct xfs_dinode	*to)
 {
+	struct xfs_sb		*sbp = &mp->m_sb;
+
 	to->di_magic = cpu_to_be16(from->di_magic);
 	to->di_mode = cpu_to_be16(from->di_mode);
 	to->di_version = from->di_version;
@@ -331,8 +349,8 @@ xfs_log_dinode_to_disk(
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
-	to->di_nextents = cpu_to_be32(from->di_nextents);
-	to->di_anextents = cpu_to_be16(from->di_anextents);
+	to->di_nextents_lo = cpu_to_be32(from->di_nextents_lo);
+	to->di_anextents_lo = cpu_to_be16(from->di_anextents_lo);
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat = from->di_aformat;
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
@@ -346,6 +364,10 @@ xfs_log_dinode_to_disk(
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
+		if (xfs_sb_version_haswideextcnt(sbp)) {
+			to->di_nextents_hi = cpu_to_be32(from->di_nextents_hi);
+			to->di_anextents_hi = cpu_to_be16(from->di_anextents_hi);
+		}
 		to->di_ino = cpu_to_be64(from->di_ino);
 		to->di_lsn = cpu_to_be64(from->di_lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
@@ -363,7 +385,7 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	xfs_extnum_t		max_extents;
-	uint32_t		di_nextents;
+	xfs_extnum_t		di_nextents;
 
 	di_nextents = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
 
@@ -400,10 +422,19 @@ xfs_dinode_verify_fork(
 xfs_extnum_t
 xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip, int whichfork)
 {
-	if (whichfork == XFS_DATA_FORK)
-		return be32_to_cpu(dip->di_nextents);
-	else
-		return be16_to_cpu(dip->di_anextents);
+	xfs_extnum_t nextents;
+
+	if (whichfork == XFS_DATA_FORK) {
+		nextents = be32_to_cpu(dip->di_nextents_lo);
+		if (xfs_sb_version_haswideextcnt(sbp))
+			nextents |= ((uint64_t)be32_to_cpu(dip->di_nextents_hi) << 32);
+	} else {
+		nextents = be16_to_cpu(dip->di_anextents_lo);
+		if (xfs_sb_version_haswideextcnt(sbp))
+			nextents |= ((uint32_t)be16_to_cpu(dip->di_anextents_hi) << 16);
+	}
+
+	return nextents;
 }
 
 static xfs_failaddr_t
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index f97b3428..0dee0235 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -55,8 +55,8 @@ void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
 void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
 			  xfs_lsn_t lsn);
 void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
-void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
-			       struct xfs_dinode *to);
+void	xfs_log_dinode_to_disk(struct xfs_mount *mp,
+			struct xfs_log_dinode *from, struct xfs_dinode *to);
 
 #if defined(DEBUG)
 void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 8c32f993..af4f893f 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -213,14 +213,14 @@ xfs_iformat_extents(
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
 	struct xfs_bmbt_irec	new;
-	int			i;
+	xfs_extnum_t		i;
 
 	/*
 	 * If the number of extents is unreasonable, then something is wrong and
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
+		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %llu).",
 			(unsigned long long) ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index e318dfdd..22f3c9b3 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -90,10 +90,17 @@ static inline xfs_extnum_t xfs_iext_max(struct xfs_sb *sbp, int whichfork)
 {
 	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
 
-	if (whichfork == XFS_DATA_FORK)
-		return MAXEXTNUM;
-	else
-		return MAXAEXTNUM;
+	if (whichfork == XFS_DATA_FORK) {
+		if (xfs_sb_version_haswideextcnt(sbp))
+			return MAXEXTNUM_HI;
+		else
+			return MAXEXTNUM;
+	} else {
+		if (xfs_sb_version_haswideextcnt(sbp))
+			return MAXAEXTNUM_HI;
+		else
+			return MAXAEXTNUM;
+	}
 }
 
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index e3400c9c..809f8ce6 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -396,8 +396,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents_lo;	/* lower part of data fork extent count */
+	uint16_t	di_anextents_lo;/* lower part of attr fork extent count*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
@@ -414,7 +414,9 @@ struct xfs_log_dinode {
 	xfs_lsn_t	di_lsn;		/* flush sequence */
 	uint64_t	di_flags2;	/* more random flags */
 	uint32_t	di_cowextsize;	/* basic cow extent size for file */
-	uint8_t		di_pad2[12];	/* more padding for future expansion */
+	uint32_t	di_nextents_hi; /* higher part of data fork extent count */
+	uint16_t	di_anextents_hi;/* higher part of attr fork extent count */
+	uint8_t		di_pad2[6];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_ictimestamp_t di_crtime;	/* time created */
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 397d9477..23ff8166 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -12,8 +12,8 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
-typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
-typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
+typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
+typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
 typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
@@ -61,6 +61,8 @@ typedef void *		xfs_failaddr_t;
 #define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
 #define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
 #define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+#define MAXEXTNUM_HI	((xfs_extnum_t)0x7fffffffffff)	/* unsigned 47 bits */
+#define MAXAEXTNUM_HI	((xfs_aextnum_t)0xffffffff)	/* unsigned 32 bits */
 
 /*
  * Minimum and maximum blocksize and sectorsize.
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index be889887..4d09f357 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -438,8 +438,11 @@ xlog_print_trans_qoff(char **ptr, uint len)
 
 static void
 xlog_print_trans_inode_core(
+	struct xfs_mount	*mp,
 	struct xfs_log_dinode	*ip)
 {
+	xfs_extnum_t		nextents;
+
     printf(_("INODE CORE\n"));
     printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
 	   ip->di_magic, ip->di_mode, (int)ip->di_version,
@@ -448,11 +451,19 @@ xlog_print_trans_inode_core(
 	   ip->di_nlink, ip->di_uid, ip->di_gid);
     printf(_("atime 0x%x mtime 0x%x ctime 0x%x\n"),
 	   ip->di_atime.t_sec, ip->di_mtime.t_sec, ip->di_ctime.t_sec);
-    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%x\n"),
+
+    nextents = ip->di_nextents_lo;
+    if (xfs_sb_version_haswideextcnt(&mp->m_sb))
+	    nextents |= ((xfs_extnum_t)ip->di_nextents_hi << 32);
+    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%lx\n"),
 	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
-	   ip->di_extsize, ip->di_nextents);
-    printf(_("naextents 0x%x forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
-	   ip->di_anextents, (int)ip->di_forkoff, ip->di_dmevmask,
+	   ip->di_extsize, nextents);
+
+    nextents = ip->di_anextents_lo;
+    if (xfs_sb_version_haswideextcnt(&mp->m_sb))
+	    nextents |= ((xfs_extnum_t)ip->di_anextents_hi << 16);
+    printf(_("naextents 0x%lx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
+	   nextents, (int)ip->di_forkoff, ip->di_dmevmask,
 	   ip->di_dmstate);
     printf(_("flags 0x%x gen 0x%x\n"),
 	   ip->di_flags, ip->di_gen);
@@ -562,7 +573,7 @@ xlog_print_trans_inode(
     memmove(&dino, *ptr, sizeof(dino));
     mode = dino.di_mode & S_IFMT;
     size = (int)dino.di_size;
-    xlog_print_trans_inode_core(&dino);
+    xlog_print_trans_inode_core(log->l_mp, &dino);
     *ptr += xfs_log_dinode_size(log->l_mp);
     skip_count--;
 
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index e2e28b9c..aa171dfb 100644
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
+	xfs_aextnum_t		anextents;
+	xfs_extnum_t		nextents;
+
+        printf(_("	CORE inode:\n"));
 	if (!print_inode)
 		return;
 	printf(_("		magic:%c%c  mode:0x%x  ver:%d  format:%d\n"),
@@ -252,10 +257,17 @@ xlog_recover_print_inode_core(
 	printf(_("		atime:%d  mtime:%d  ctime:%d\n"),
 	       di->di_atime.t_sec, di->di_mtime.t_sec, di->di_ctime.t_sec);
 	printf(_("		flushiter:%d\n"), di->di_flushiter);
+
+	nextents = di->di_nextents_lo;
+	anextents = di->di_anextents_lo;
+	if (xfs_sb_version_haswideextcnt(sbp)) {
+		nextents |= ((xfs_extnum_t)di->di_nextents_hi << 32);
+		anextents |= ((xfs_aextnum_t)di->di_anextents_hi << 16);
+	}
 	printf(_("		size:0x%llx  nblks:0x%llx  exsize:%d  "
-	     "nextents:%d  anextents:%d\n"), (unsigned long long)
+	     "nextents:%lu  anextents:%u\n"), (unsigned long long)
 	       di->di_size, (unsigned long long)di->di_nblocks,
-	       di->di_extsize, di->di_nextents, (int)di->di_anextents);
+	       di->di_extsize, nextents, anextents);
 	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "
 	     "gen:%u\n"),
 	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
@@ -268,6 +280,7 @@ xlog_recover_print_inode_core(
 
 STATIC void
 xlog_recover_print_inode(
+	struct xlog		*log,
 	xlog_recover_item_t	*item)
 {
 	struct xfs_inode_log_format	f_buf;
@@ -289,7 +302,7 @@ xlog_recover_print_inode(
 	ASSERT(item->ri_buf[1].i_len ==
 			offsetof(struct xfs_log_dinode, di_next_unlinked) ||
 	       item->ri_buf[1].i_len == sizeof(struct xfs_log_dinode));
-	xlog_recover_print_inode_core((struct xfs_log_dinode *)
+	xlog_recover_print_inode_core(log, (struct xfs_log_dinode *)
 				      item->ri_buf[1].i_addr);
 
 	hasdata = (f->ilf_fields & XFS_ILOG_DFORK) != 0;
@@ -384,6 +397,7 @@ xlog_recover_print_icreate(
 
 void
 xlog_recover_print_logitem(
+	struct xlog		*log,
 	xlog_recover_item_t	*item)
 {
 	switch (ITEM_TYPE(item)) {
@@ -394,7 +408,7 @@ xlog_recover_print_logitem(
 		xlog_recover_print_icreate(item);
 		break;
 	case XFS_LI_INODE:
-		xlog_recover_print_inode(item);
+		xlog_recover_print_inode(log, item);
 		break;
 	case XFS_LI_EFD:
 		xlog_recover_print_efd(item);
@@ -434,6 +448,7 @@ xlog_recover_print_logitem(
 
 static void
 xlog_recover_print_item(
+	struct xlog		*log,
 	xlog_recover_item_t	*item)
 {
 	int			i;
@@ -493,11 +508,12 @@ xlog_recover_print_item(
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
@@ -510,5 +526,5 @@ xlog_recover_print_trans(
 	print_xlog_record_line();
 	xlog_recover_print_trans_head(trans);
 	list_for_each_entry(item, itemq, ri_list)
-		xlog_recover_print_item(item);
+		xlog_recover_print_item(log, item);
 }
diff --git a/logprint/log_print_trans.c b/logprint/log_print_trans.c
index 2004b5a0..c6386fb0 100644
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
 
diff --git a/repair/dinode.c b/repair/dinode.c
index 98bb4a17..5a8de0f6 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -71,7 +71,9 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	if (xfs_dfork_nextents(&mp->m_sb, dino, XFS_ATTR_FORK) != 0) {
 		if (no_modify)
 			return(1);
-		dino->di_anextents = cpu_to_be16(0);
+		dino->di_anextents_lo = cpu_to_be16(0);
+		if (xfs_sb_version_haswideextcnt(&mp->m_sb))
+			dino->di_anextents_hi = cpu_to_be16(0);
 	}
 
 	if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
@@ -959,7 +961,7 @@ process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
 	xfs_fileoff_t		expected_offset;
 	xfs_bmbt_rec_t		*rp;
 	xfs_bmbt_irec_t		irec;
-	int			numrecs;
+	xfs_extnum_t		numrecs;
 	int			i;
 	int			max_blocks;
 
@@ -989,7 +991,7 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
 	 */
 	if (numrecs > max_symlink_blocks)  {
 		do_warn(
-_("bad number of extents (%d) in symlink %" PRIu64 " data fork\n"),
+_("bad number of extents (%lu) in symlink %" PRIu64 " data fork\n"),
 			numrecs, lino);
 		return(1);
 	}
@@ -1556,7 +1558,7 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 		nextents = xfs_dfork_nextents(&mp->m_sb, dinoc, XFS_DATA_FORK);
 		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%u) for realtime summary inode %" PRIu64 "\n"),
+_("bad # of extents (%lu) for realtime summary inode %" PRIu64 "\n"),
 				nextents, lino);
 			return 1;
 		}
@@ -1579,7 +1581,7 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 		nextents = xfs_dfork_nextents(&mp->m_sb, dinoc, XFS_DATA_FORK);
 		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%u) for realtime bitmap inode %" PRIu64 "\n"),
+_("bad # of extents (%lu) for realtime bitmap inode %" PRIu64 "\n"),
 				nextents, lino);
 			return 1;
 		}
@@ -1772,13 +1774,15 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 	if (nextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
-_("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
+_("correcting nextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, nextents);
-			dino->di_nextents = cpu_to_be32(nextents);
+			dino->di_nextents_lo = cpu_to_be32(nextents);
+			if (xfs_sb_version_haswideextcnt(&mp->m_sb))
+				dino->di_nextents_hi = cpu_to_be32(nextents >> 32);
 			*dirty = 1;
 		} else  {
 			do_warn(
-_("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
+_("bad nextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 				dnextents, lino, nextents);
 		}
 	}
@@ -1795,13 +1799,15 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 	if (anextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
-_("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
+_("correcting anextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, anextents);
-			dino->di_anextents = cpu_to_be16(anextents);
+			dino->di_anextents_lo = cpu_to_be16(anextents);
+			if (xfs_sb_version_haswideextcnt(&mp->m_sb))
+				dino->di_anextents_hi = cpu_to_be16(anextents >> 16);
 			*dirty = 1;
 		} else  {
 			do_warn(
-_("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
+_("bad anextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 				dnextents, lino, anextents);
 		}
 	}
-- 
2.28.0

