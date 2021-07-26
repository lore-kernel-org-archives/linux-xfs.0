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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0483FC4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E437660F4F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhGZLFh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbhGZLFg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:05:36 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0755C061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:46:04 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id e21so6734244pla.5
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vd1m9BkEbiXXE3/pf4xji9GW7ljAdFcqcBAA/yO6MUM=;
        b=hSDSl5TFX16pXLCM0oEClSYYZNObrtE5iBNo7vJCzhaEYlUKl1kvKTvrcOuiKHBKQs
         cMxa73b/AO/5DKpdiwIZR9jLrSoKNVU/J+AtefOwOQz56lktZBTL2ChwGcxblMZoS+EA
         9e/qAtWVeuUOL4O7CdcTaTrRDTXuZiMRHWDs+DF70cthW/3XIoAvj5VRDJGUF6Tgus0B
         5/lm9o58KSljIIaU7OXobWD9pGKOcyn5WbgSJ24PQevrS9wc/aHFhvxA++t2nZIAAqtR
         VIlzc1QqZnNEP7ahJ/ruW4M1kZQLep8x/U0uq2TQTsdjU/cOYHSdKVg9M7KYsEWKUAVa
         aflA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vd1m9BkEbiXXE3/pf4xji9GW7ljAdFcqcBAA/yO6MUM=;
        b=AGuk4ElcoRlmp2bDZ1QRR73kJc9D4iUG6eM0Tj8uQIgV1F224zKzotiT7MZf+EnIaF
         WvNqrFE23pGWZHYBcR+jw2EqfWVxpUxkJC9JCYSMdIMX3wcxf24aaK8kH0goo9CWPxgQ
         7ieAk/vLUVVvSL6yrkUVCUhnvzg3NfvCA5QR9u5y8Ld4IhaJQQBD/m3CZl0GSsNPDx/e
         Q94HrBbvQa2zIFSU3lAfLI6P6jZ1KOZ/VGCNqopIXFuuqEs9Uvqvv3e4Tdt87pIUTMOO
         PhdiLhFa8msTjmWqnv/vexh9eB18pvQ/V7ldwRL4bIO+ZaM4YFuq/3IUb1+RNsc6iWAz
         xcKQ==
X-Gm-Message-State: AOAM530CmebPFvLjRRPFzY4Oy13111RsNEPKtOcEktNlwRT5ufadQ338
        HvB64v/cgrcV9IKz/1BZYsFvuw/yDm8=
X-Google-Smtp-Source: ABdhPJzbjuV972RD/ZNDwPgxbsAXpv13C9BfgPiWMbsgtAHL2HsuLhB5Kj1i6WehmP48KwDz51BIEw==
X-Received: by 2002:a65:6487:: with SMTP id e7mr17756105pgv.27.1627299964237;
        Mon, 26 Jul 2021 04:46:04 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id k8sm50833919pgr.91.2021.07.26.04.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:46:04 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 07/12] xfs: Rename inode's extent counter fields based on their width
Date:   Mon, 26 Jul 2021 17:15:36 +0530
Message-Id: <20210726114541.24898-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114541.24898-1-chandanrlinux@gmail.com>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit renames extent counter fields in "struct xfs_dinode" and "struct
xfs_log_dinode" based on the width of the fields. As of this commit, the
32-bit field will be used to count data fork extents and the 16-bit field will
be used to count attr fork extents.

This change is done to enable a future commit to introduce a new 64-bit extent
counter field.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_format.h      |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.c   |  8 ++++----
 fs/xfs/libxfs/xfs_log_format.h  |  4 ++--
 fs/xfs/scrub/inode_repair.c     |  4 ++--
 fs/xfs/scrub/trace.h            | 14 +++++++-------
 fs/xfs/xfs_inode_item.c         |  4 ++--
 fs/xfs/xfs_inode_item_recover.c |  8 ++++----
 7 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 001a4077a7c6..2362cc005cc6 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1039,8 +1039,8 @@ typedef struct xfs_dinode {
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	__be32		di_nextents32;	/* number of extents in data fork */
+	__be16		di_nextents16;	/* number of extents in attribute fork*/
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	__s8		di_aformat;	/* format of attr fork's data */
 	__be32		di_dmevmask;	/* DMIG event mask */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 9ed04da2e2b1..65d753e16007 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -313,8 +313,8 @@ xfs_inode_to_disk(
 	to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
-	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
-	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+	to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
+	to->di_nextents16 = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
@@ -389,11 +389,11 @@ xfs_dfork_nextents(
 
 	switch (whichfork) {
 	case XFS_DATA_FORK:
-		*nextents = be32_to_cpu(dip->di_nextents);
+		*nextents = be32_to_cpu(dip->di_nextents32);
 		break;
 
 	case XFS_ATTR_FORK:
-		*nextents = be16_to_cpu(dip->di_anextents);
+		*nextents = be16_to_cpu(dip->di_nextents16);
 		break;
 
 	default:
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 0c888f92184e..ca8e4ad8312a 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -402,8 +402,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents32;	/* number of extents in data fork */
+	uint16_t	di_nextents16;	/* number of extents in attribute fork*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 521c8df00990..4d773a16f886 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -736,7 +736,7 @@ xrep_dinode_zap_dfork(
 {
 	trace_xrep_dinode_zap_dfork(sc, dip);
 
-	dip->di_nextents = 0;
+	dip->di_nextents32 = 0;
 
 	/* Special files always get reset to DEV */
 	switch (mode & S_IFMT) {
@@ -823,7 +823,7 @@ xrep_dinode_zap_afork(
 	trace_xrep_dinode_zap_afork(sc, dip);
 
 	dip->di_aformat = XFS_DINODE_FMT_EXTENTS;
-	dip->di_anextents = 0;
+	dip->di_nextents16 = 0;
 
 	dip->di_forkoff = 0;
 	dip->di_mode = cpu_to_be16(mode & ~0777);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index fd03685b1f6b..a0303f692e52 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1209,8 +1209,8 @@ DECLARE_EVENT_CLASS(xrep_dinode_class,
 		__field(uint64_t, size)
 		__field(uint64_t, nblocks)
 		__field(uint32_t, extsize)
-		__field(uint32_t, nextents)
-		__field(uint16_t, anextents)
+		__field(uint32_t, nextents32)
+		__field(uint16_t, nextents16)
 		__field(uint8_t, forkoff)
 		__field(uint8_t, aformat)
 		__field(uint16_t, flags)
@@ -1229,8 +1229,8 @@ DECLARE_EVENT_CLASS(xrep_dinode_class,
 		__entry->size = be64_to_cpu(dip->di_size);
 		__entry->nblocks = be64_to_cpu(dip->di_nblocks);
 		__entry->extsize = be32_to_cpu(dip->di_extsize);
-		__entry->nextents = be32_to_cpu(dip->di_nextents);
-		__entry->anextents = be16_to_cpu(dip->di_anextents);
+		__entry->nextents32 = be32_to_cpu(dip->di_nextents32);
+		__entry->nextents16 = be16_to_cpu(dip->di_nextents16);
 		__entry->forkoff = dip->di_forkoff;
 		__entry->aformat = dip->di_aformat;
 		__entry->flags = be16_to_cpu(dip->di_flags);
@@ -1238,7 +1238,7 @@ DECLARE_EVENT_CLASS(xrep_dinode_class,
 		__entry->flags2 = be64_to_cpu(dip->di_flags2);
 		__entry->cowextsize = be32_to_cpu(dip->di_cowextsize);
 	),
-	TP_printk("dev %d:%d ino 0x%llx mode 0x%x version %u format %u uid %u gid %u size %llu nblocks %llu extsize %u nextents %u anextents %u forkoff %u aformat %u flags 0x%x gen 0x%x flags2 0x%llx cowextsize %u",
+	TP_printk("dev %d:%d ino 0x%llx mode 0x%x version %u format %u uid %u gid %u size %llu nblocks %llu extsize %u nextents32 %u nextents16 %u forkoff %u aformat %u flags 0x%x gen 0x%x flags2 0x%llx cowextsize %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->mode,
@@ -1249,8 +1249,8 @@ DECLARE_EVENT_CLASS(xrep_dinode_class,
 		  __entry->size,
 		  __entry->nblocks,
 		  __entry->extsize,
-		  __entry->nextents,
-		  __entry->anextents,
+		  __entry->nextents32,
+		  __entry->nextents16,
 		  __entry->forkoff,
 		  __entry->aformat,
 		  __entry->flags,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 35de30849fcc..f54ce7468ba1 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -385,8 +385,8 @@ xfs_inode_to_log_dinode(
 	to->di_size = ip->i_disk_size;
 	to->di_nblocks = ip->i_nblocks;
 	to->di_extsize = ip->i_extsize;
-	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
-	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
+	to->di_nextents32 = xfs_ifork_nextents(&ip->i_df);
+	to->di_nextents16 = xfs_ifork_nextents(ip->i_afp);
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = ip->i_diflags;
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 7b79518b6c20..40af9d1265c7 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -166,8 +166,8 @@ xfs_log_dinode_to_disk(
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
-	to->di_nextents = cpu_to_be32(from->di_nextents);
-	to->di_anextents = cpu_to_be16(from->di_anextents);
+	to->di_nextents32 = cpu_to_be32(from->di_nextents32);
+	to->di_nextents16 = cpu_to_be16(from->di_nextents16);
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat = from->di_aformat;
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
@@ -332,7 +332,7 @@ xlog_recover_inode_commit_pass2(
 			goto out_release;
 		}
 	}
-	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
+	if (unlikely(ldip->di_nextents32 + ldip->di_nextents16 > ldip->di_nblocks)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
 				     sizeof(*ldip));
@@ -340,7 +340,7 @@ xlog_recover_inode_commit_pass2(
 	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
 	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
 			__func__, item, dip, bp, in_f->ilf_ino,
-			ldip->di_nextents + ldip->di_anextents,
+			ldip->di_nextents32 + ldip->di_nextents16,
 			ldip->di_nblocks);
 		error = -EFSCORRUPTED;
 		goto out_release;
-- 
2.30.2

