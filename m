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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7E0C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 956ED60F38
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhGZLHT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhGZLHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:07:19 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD90C061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:47 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id e14so11274376plh.8
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mblDGjHuZZH5Cofhcd7XKrVVYKrhUlzU1vwBPWokEA8=;
        b=aj3F1mxkhjcrKiZeqAv3MepHM90O075CdGgzCAv55IDCuctC528SnOJesbZ4AIYmoW
         zZ1MXX62zCsYurP947KSqC/xAPY6S6dA+iSiXbkhusG6/9miz2uQrtC/Lrj25cfavQUs
         htsySdsgZnT0d+ztRfQqYB88ncYfe0uy5RPkzvsd3YhTNgO6nrOWEf2rM7P/mEIAGw6X
         18gQOxAmhlhpqyEuGOP3h8KglS95CrBdgowI15LyqiztH8Mh+i3m5eON0RSIfqah3X8H
         ZIfBeCNIS27uyiKpESxhsC6DXVjkAap3mZkddNdGEuvAN2dCraLQvfx7IBW1kuAvMNas
         CBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mblDGjHuZZH5Cofhcd7XKrVVYKrhUlzU1vwBPWokEA8=;
        b=oYFp048CQvGLvcW6eRZ4oq5GBYmOfqXHjzJ7IVcGFgOnmxlDIML7XySUv++hnbbNwH
         14uLEw4dfT2kHzZlaI/FJ++vyM+qjkwXOQnW0UQU2Z9F6as/JGGYRi+ehl6UmpOuyQyL
         oiL4SClLbvrf/9EvMS55AjIEM2fdnAR6LFTDYGDyhDgXr3LfZpLVaWFNSYNcrHIuElKa
         QmbZGQEmZkm4Sg97dRbOLFErwJBSOsglHQZ0qTFw+k2aQWxb/1+7Mi5f/FD/2iznOQki
         XeQENNjLglMqDQOoT0XytoEt4CsqtCkbLfr+7ckSx1CgDfuc4P9xSfOtoBdzIWy97hWN
         aebg==
X-Gm-Message-State: AOAM532ULdWtYEkii9H24UkHPCLcdJxvmGBLU4iox+EN23QLYe7C40tO
        /qI3CzIdKMTrrqrzLVjEwm28kSN7Jr4=
X-Google-Smtp-Source: ABdhPJzA7ZGFdRxZVK3tEMlYIP+TKtGZ3MCkrDvuljEUBbsmW8uQh11ZcsQQtc2CTSr2yZrhGcTzRQ==
X-Received: by 2002:aa7:81cd:0:b029:329:fcb0:1b44 with SMTP id c13-20020aa781cd0000b0290329fcb01b44mr17598320pfn.5.1627300067114;
        Mon, 26 Jul 2021 04:47:47 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id y10sm35936900pjy.18.2021.07.26.04.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:47:46 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 07/12] xfsprogs: Rename inode's extent counter fields based on their width
Date:   Mon, 26 Jul 2021 17:17:19 +0530
Message-Id: <20210726114724.24956-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114724.24956-1-chandanrlinux@gmail.com>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
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
 db/inode.c               | 4 ++--
 libxfs/xfs_format.h      | 4 ++--
 libxfs/xfs_inode_buf.c   | 8 ++++----
 libxfs/xfs_log_format.h  | 4 ++--
 logprint/log_misc.c      | 4 ++--
 logprint/log_print_all.c | 2 +-
 repair/bmap_repair.c     | 4 ++--
 repair/dinode.c          | 6 +++---
 8 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/db/inode.c b/db/inode.c
index e3b7d04c0..27251f02f 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -100,8 +100,8 @@ const field_t	inode_core_flds[] = {
 	{ "size", FLDT_FSIZE, OI(COFF(size)), C1, 0, TYP_NONE },
 	{ "nblocks", FLDT_DRFSBNO, OI(COFF(nblocks)), C1, 0, TYP_NONE },
 	{ "extsize", FLDT_EXTLEN, OI(COFF(extsize)), C1, 0, TYP_NONE },
-	{ "nextents", FLDT_EXTNUM, OI(COFF(nextents)), C1, 0, TYP_NONE },
-	{ "naextents", FLDT_AEXTNUM, OI(COFF(anextents)), C1, 0, TYP_NONE },
+	{ "nextents32", FLDT_EXTNUM, OI(COFF(nextents32)), C1, 0, TYP_NONE },
+	{ "nextents16", FLDT_AEXTNUM, OI(COFF(nextents16)), C1, 0, TYP_NONE },
 	{ "forkoff", FLDT_UINT8D, OI(COFF(forkoff)), C1, 0, TYP_NONE },
 	{ "aformat", FLDT_DINODE_FMT, OI(COFF(aformat)), C1, 0, TYP_NONE },
 	{ "dmevmask", FLDT_UINT32X, OI(COFF(dmevmask)), C1, 0, TYP_NONE },
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 2a5e7e3a3..6564bc135 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1039,8 +1039,8 @@ typedef struct xfs_dinode {
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	__be32		di_nextents32;	/* 32-bit extent counter */
+	__be16		di_nextents16;	/* 16-bit extent counter */
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	__s8		di_aformat;	/* format of attr fork's data */
 	__be32		di_dmevmask;	/* DMIG event mask */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 353050365..95fd95cc0 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -310,8 +310,8 @@ xfs_inode_to_disk(
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
@@ -386,11 +386,11 @@ xfs_dfork_nextents(
 
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
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 0c888f921..ca8e4ad83 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
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
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index c06fd233b..4e8760c43 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -452,9 +452,9 @@ xlog_print_trans_inode_core(
 		xlog_extract_dinode_ts(ip->di_ctime));
     printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%x\n"),
 	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
-	   ip->di_extsize, ip->di_nextents);
+	   ip->di_extsize, ip->di_nextents32);
     printf(_("naextents 0x%x forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
-	   ip->di_anextents, (int)ip->di_forkoff, ip->di_dmevmask,
+	   ip->di_nextents16, (int)ip->di_forkoff, ip->di_dmevmask,
 	   ip->di_dmstate);
     printf(_("flags 0x%x gen 0x%x\n"),
 	   ip->di_flags, ip->di_gen);
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 37669372e..403c56372 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -257,7 +257,7 @@ xlog_recover_print_inode_core(
 	printf(_("		size:0x%llx  nblks:0x%llx  exsize:%d  "
 	     "nextents:%d  anextents:%d\n"), (unsigned long long)
 	       di->di_size, (unsigned long long)di->di_nblocks,
-	       di->di_extsize, di->di_nextents, (int)di->di_anextents);
+	       di->di_extsize, di->di_nextents32, (int)di->di_nextents16);
 	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "
 	     "gen:%u\n"),
 	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 84f3a7048..f41a18f00 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -536,7 +536,7 @@ rebuild_bmap(
 		if (nextents == 0)
 			return 0;
 		(*dinop)->di_format = XFS_DINODE_FMT_EXTENTS;
-		(*dinop)->di_nextents = 0;
+		(*dinop)->di_nextents32 = 0;
 		libxfs_dinode_calc_crc(mp, *dinop);
 		*dirty = 1;
 		break;
@@ -547,7 +547,7 @@ rebuild_bmap(
 		if (nextents == 0)
 			return 0;
 		(*dinop)->di_aformat = XFS_DINODE_FMT_EXTENTS;
-		(*dinop)->di_anextents = 0;
+		(*dinop)->di_nextents16 = 0;
 		libxfs_dinode_calc_crc(mp, *dinop);
 		*dirty = 1;
 		break;
diff --git a/repair/dinode.c b/repair/dinode.c
index 096335191..efff83ef9 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -78,7 +78,7 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	if (anextents != 0) {
 		if (no_modify)
 			return(1);
-		dino->di_anextents = cpu_to_be16(0);
+		dino->di_nextents16 = cpu_to_be16(0);
 	}
 
 	if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
@@ -1870,7 +1870,7 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
 				lino, dnextents, nextents);
-			dino->di_nextents = cpu_to_be32(nextents);
+			dino->di_nextents32 = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
@@ -1894,7 +1894,7 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
 				lino, dnextents, anextents);
-			dino->di_anextents = cpu_to_be16(anextents);
+			dino->di_nextents16 = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
-- 
2.30.2

