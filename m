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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10795C4320A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDEB360238
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbhGZLFj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbhGZLFi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:05:38 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C34C061760
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:46:06 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ca5so134669pjb.5
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rH5AlrKnAvQHjsk3yhTjD6OevEzHh93UPQA+LPt9xaM=;
        b=UY6VQh68PgaX5BJ8SrXbt9xE7/Di8v8pKc8F5Yh0L7nuoJ2CINHQacuxU3HbbzV/NI
         X6RxiQ18RCRwFEvv7bdOG555IooZKQqKMo/kTxB0WIniIsxOYRQkxxCYn9kQrXRMi7VL
         XeggZp5BHgisZB/0zohyW9C1mQbNG6VniAsl4DerT/WWU85drxHaZiEQp12Ye+Ar0dXQ
         RblU99BOhQRcKxEs9SGt7O4RjuA7a56fC5ljtEAQEAdi1rC43kvBwyyehFAPiHJstq9V
         1YUe9ymgJJMGJW4KKxZx57Fd4M49cxdt3jTanGqwdMe7oapn9iS6Qecd4PIAJ7hurI6j
         Ip3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rH5AlrKnAvQHjsk3yhTjD6OevEzHh93UPQA+LPt9xaM=;
        b=KgIaDEDj6AEDkSTJbSQlLKQXs4XK4OYH3C7qKEEkBN2kDGfk0juRMuM58CXcjAm0Ij
         OvlQwxI1XmdzKi3Di6XknlC+vF8ye57TI80I87I9HYkYvOHsXGkVEHKy5mAiNlKhLUVA
         UMC+I5krbNiuTEm2dodJAxWaMVuufVNvDPiJ7tItqoFM10LH2yFgOQRBrH+xNMx33VEt
         E073dO9tKUaodnhSjuVNuoJ4JW6CEw/hkcl//pytql+449qjK2F8b/ha14klS93h0hPF
         4S07HLOscuwgWLP/6mNHlx2wQOtgLTpsgLGMUJMVgeRpW068DZMl2jhy/eEKXzNdXABb
         vvAA==
X-Gm-Message-State: AOAM531A1kVYXpMBtwHo4JsVYU3qY/gDkaC0Fgql7vesdB5G4hUJVufW
        B8f3sA3c9XiazGiSqvX1u9FtUsMNsnQ=
X-Google-Smtp-Source: ABdhPJxH6ovHFoz8A9E33XPqw7T85Fp8BwTgEOvPOQznwyZ+DXPa4nKYZbsn+wfIBtHfTSJK+m5TBg==
X-Received: by 2002:a17:90b:1a92:: with SMTP id ng18mr17090886pjb.86.1627299965943;
        Mon, 26 Jul 2021 04:46:05 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id k8sm50833919pgr.91.2021.07.26.04.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:46:05 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 08/12] xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Mon, 26 Jul 2021 17:15:37 +0530
Message-Id: <20210726114541.24898-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114541.24898-1-chandanrlinux@gmail.com>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will introduce a 64-bit on-disk data extent counter and a
32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
of these quantities.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/libxfs/xfs_types.h      | 4 ++--
 fs/xfs/scrub/attr_repair.c     | 2 +-
 fs/xfs/scrub/trace.h           | 2 +-
 fs/xfs/xfs_inode.c             | 4 ++--
 fs/xfs/xfs_trace.h             | 4 ++--
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e5d243fd187d..a27d57ea301c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -472,7 +472,7 @@ xfs_bmap_check_leaf_extents(
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
-	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
+	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
 		__func__, i);
 	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7f7ffe29436d..336eee69703c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -126,7 +126,7 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
+		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
 			(unsigned long long) ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 8908346b1deb..584fa61e338e 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
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
 
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 7d92195d286b..aad4b269949d 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -769,7 +769,7 @@ xrep_xattr_fork_remove(
 		unsigned int		i = 0;
 
 		xfs_emerg(sc->mp,
-	"inode 0x%llx attr fork still has %u attr extents, format %d?!",
+	"inode 0x%llx attr fork still has %llu attr extents, format %d?!",
 				ip->i_ino, ifp->if_nextents, ifp->if_format);
 		for_each_xfs_iext(ifp, &icur, &irec) {
 			xfs_err(sc->mp, "[%u]: startoff %llu startblock %llu blockcount %llu state %u", i++, irec.br_startoff, irec.br_startblock, irec.br_blockcount, irec.br_state);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index a0303f692e52..f9be7812c8ce 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1363,7 +1363,7 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
 		__entry->attr_extents = attr_extents;
 		__entry->block0 = block0;
 	),
-	TP_printk("dev %d:%d ino 0x%llx dblocks %llu rtblocks %llu ablocks %llu dextents %u rtextents %u aextents %u block0 %llu",
+	TP_printk("dev %d:%d ino 0x%llx dblocks %llu rtblocks %llu ablocks %llu dextents %llu rtextents %llu aextents %u block0 %llu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->data_blocks,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f152f6dace0c..4070fb01350c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2510,8 +2510,8 @@ xfs_iflush(
 	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
 				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: detected corrupt incore inode %Lu, "
-			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
+			"%s: detected corrupt incore inode %llu, "
+			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
 			__func__, ip->i_ino,
 			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
 			ip->i_nblocks, ip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5ed11f894f79..af426b9824db 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2351,7 +2351,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__entry->broot_size = ip->i_df.if_broot_bytes;
 		__entry->fork_off = XFS_IFORK_BOFF(ip);
 	),
-	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
+	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %llu, "
 		  "broot size %d, fork offset %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
@@ -4588,7 +4588,7 @@ TRACE_EVENT(xfs_swapext_delta_nextents,
 		__entry->d_nexts1 = d_nexts1;
 		__entry->d_nexts2 = d_nexts2;
 	),
-	TP_printk("dev %d:%d ino1 0x%llx nexts %u ino2 0x%llx nexts %u delta1 %lld delta2 %lld",
+	TP_printk("dev %d:%d ino1 0x%llx nexts %llu ino2 0x%llx nexts %llu delta1 %lld delta2 %lld",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino1, __entry->nexts1,
 		  __entry->ino2, __entry->nexts2,
-- 
2.30.2

