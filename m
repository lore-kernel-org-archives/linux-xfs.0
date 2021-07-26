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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FEFC4320A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EB8A60C51
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhGZLHU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhGZLHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:07:20 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C71EC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:49 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so13921570pjd.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iSek/iZwhI/RmFnKiiXTQu8ADqsJeXWGzPg1R/aKhYA=;
        b=pV++FbGuh46KrMnOROmd3jHMVtAvr9ZEVrCl83Vs0hA6WWTKvommxhaZBdiMoRMWvX
         ZtJszIUj4Cy7JNWcHtrxNJyeBu63/HPq0gTp2PY1dDCnauZFHhbIyyYADqWvwj6B1NeJ
         hffR5tY6nbzqD0acvxU8qsXYIhcro4ExYXcNSLUMcQgreHax2xAi5IJuFW66lJ2Rc9Oj
         xUvr1MJYgueo7f7D5dfxAXYL0RKAKl8M6ugimN8ttnwRLpERhK49ar9iROguSvYo47UR
         QcPY6EqQSBOkEvwRfyGyrZ3X7jUmMogPjpSUokDpoKQwCZyOvBFBFi3fQcrp1FrzQZQ5
         hShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iSek/iZwhI/RmFnKiiXTQu8ADqsJeXWGzPg1R/aKhYA=;
        b=hA3meaqQpcW1NsHncHFaSgd0n2Zm1qEeT7TQ+gm0OXcIX2Up2EObbqj03WBi5GVXgr
         0MYJJWXJftOToYTMqaVtHHVUin6L8YrGltTZew4z2bGa2JUUgsRYVlAFqajD9q1L0EEc
         qH11VvxkUobRIevNDwPW3b5uU4DLcseAb/2d8Mkd7csBVGHLI7vigEzvBGeB7JWkGylp
         V7ABVOrajs05KR+RXsvf5ouujy5OpQ1hKdmQC26tqF++7EGeSyrETVygswUw+NBlT1ns
         1aTQa6EDDdmcJaGWdM0IkblUKfvE3ATQmqJ1qk7/rOSqoevhlxdc4jN+WpiyMWXUcJrB
         1WHg==
X-Gm-Message-State: AOAM530UM9OD61ky+EN7Yfaq+bqNr4ZZq55UHtsuamj0gXuCSJ26of4l
        diSxsQXVhJh2nr0dJSmjo7g43georq0=
X-Google-Smtp-Source: ABdhPJxa9x0HFJCgeandDXzFkuCj+8novaAxUx0UhZIPAVUeGI5VSB/7USGJRYBjJJLVgJ5x16wzdw==
X-Received: by 2002:a17:902:e04f:b029:eb:66b0:6d08 with SMTP id x15-20020a170902e04fb02900eb66b06d08mr14121123plx.50.1627300068845;
        Mon, 26 Jul 2021 04:47:48 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id y10sm35936900pjy.18.2021.07.26.04.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:47:48 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 08/12] xfsprogs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Mon, 26 Jul 2021 17:17:20 +0530
Message-Id: <20210726114724.24956-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114724.24956-1-chandanrlinux@gmail.com>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
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
 libxfs/xfs_inode_fork.c |  2 +-
 libxfs/xfs_types.h      |  4 ++--
 repair/dinode.c         | 20 ++++++++++----------
 repair/dinode.h         |  4 ++--
 repair/scan.c           |  6 +++---
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 699bac823..8e2da89c7 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -124,7 +124,7 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
+		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %llu).",
 			(unsigned long long) ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 8908346b1..584fa61e3 100644
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
 
diff --git a/repair/dinode.c b/repair/dinode.c
index efff83ef9..beeb9ed07 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -357,7 +357,7 @@ static int
 process_bmbt_reclist_int(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
@@ -680,7 +680,7 @@ int
 process_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
@@ -703,7 +703,7 @@ int
 scan_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
@@ -1089,7 +1089,7 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
 	 */
 	if (numrecs > max_symlink_blocks)  {
 		do_warn(
-_("bad number of extents (%d) in symlink %" PRIu64 " data fork\n"),
+_("bad number of extents (%lu) in symlink %" PRIu64 " data fork\n"),
 			numrecs, lino);
 		return(1);
 	}
@@ -1650,7 +1650,7 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 
 		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%d) for realtime summary inode %" PRIu64 "\n"),
+_("bad # of extents (%lu) for realtime summary inode %" PRIu64 "\n"),
 				nextents, lino);
 			return 1;
 		}
@@ -1675,7 +1675,7 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 
                 if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%d) for realtime bitmap inode %" PRIu64 "\n"),
+_("bad # of extents (%lu) for realtime bitmap inode %" PRIu64 "\n"),
 				nextents, lino);
 			return 1;
 		}
@@ -1868,13 +1868,13 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 	if (nextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
-_("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
+_("correcting nextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, nextents);
 			dino->di_nextents32 = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
-_("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
+_("bad nextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 				dnextents, lino, nextents);
 		}
 	}
@@ -1892,13 +1892,13 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 	if (anextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
-_("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
+_("correcting anextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, anextents);
 			dino->di_nextents16 = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
-_("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
+_("bad anextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 				dnextents, lino, anextents);
 		}
 	}
diff --git a/repair/dinode.h b/repair/dinode.h
index e190b7435..09129e7b5 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -20,7 +20,7 @@ convert_extent(
 int
 process_bmbt_reclist(xfs_mount_t	*mp,
 		xfs_bmbt_rec_t		*rp,
-		int			*numrecs,
+		xfs_extnum_t		*numrecs,
 		int			type,
 		xfs_ino_t		ino,
 		xfs_rfsblock_t		*tot,
@@ -34,7 +34,7 @@ int
 scan_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
diff --git a/repair/scan.c b/repair/scan.c
index 86fa8b4dd..76021cff0 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -223,7 +223,7 @@ scan_bmapbt(
 	xfs_fileoff_t		first_key;
 	xfs_fileoff_t		last_key;
 	char			*forkname = get_forkname(whichfork);
-	int			numrecs;
+	xfs_extnum_t		numrecs;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	int			state;
@@ -443,7 +443,7 @@ _("couldn't add inode %"PRIu64" bmbt block %"PRIu64" reverse-mapping data."),
 		if (numrecs > mp->m_bmap_dmxr[0] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[0])) {
 				do_warn(
-_("inode %" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
+_("inode %" PRIu64 " bad # of bmap records (%lu, min - %u, max - %u)\n"),
 					ino, numrecs, mp->m_bmap_dmnr[0],
 					mp->m_bmap_dmxr[0]);
 			return(1);
@@ -495,7 +495,7 @@ _("out-of-order bmap key (file offset) in inode %" PRIu64 ", %s fork, fsbno %" P
 	if (numrecs > mp->m_bmap_dmxr[1] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[1])) {
 		do_warn(
-_("inode %" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
+_("inode %" PRIu64 " bad # of bmap records (%lu, min - %u, max - %u)\n"),
 			ino, numrecs, mp->m_bmap_dmnr[1], mp->m_bmap_dmxr[1]);
 		return(1);
 	}
-- 
2.30.2

