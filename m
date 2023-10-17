Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B88CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344114AbjJQPt3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344119AbjJQPt2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:49:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B56F7
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:49:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0191C433AB;
        Tue, 17 Oct 2023 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557765;
        bh=pHooymGNbbdwU2p/FjZIsCjz93wt67Vm5P2Rq9oAxxU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=VP8MJIpMOOO8yzEy18nQfVz8ZsfHfM2A/iSe9wCiPqpizeFOYHo6J0vQwzTq5Alwq
         aMGFYupVFXwMZ0XiswcOyNZqUZ/mTTgRCwyFYn7KOrrM+zpnP1yN1dBMZboODarbVf
         Wa5en/z1l6GzIaMXwUNV4RSYQWPcTLYB16nY9HLaPhBtIzYYq0HA/VVJ8Vzq/a3kgm
         E3H7V8r4C+JvKC4Og8UN3nsXKctbRClOqG0bNdb6/Jot+1TgK/U2usD2dlL7GQg25d
         nvRXOqLO3lujg/bKAkitBrKK1oQbb5AxY6cIXpWopZ0XLUf7eiW1pz+4TueATKGU8t
         FcfX9+LWEaVnw==
Date:   Tue, 17 Oct 2023 08:49:25 -0700
Subject: [PATCH 6/8] xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755741372.3165534.4543473581450945579.stgit@frogsfrogsfrogs>
In-Reply-To: <169755741268.3165534.11886536508035251574.stgit@frogsfrogsfrogs>
References: <169755741268.3165534.11886536508035251574.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XFS uses xfs_rtblock_t for many different uses, which makes it much more
difficult to perform a unit analysis on the codebase.  One of these
(ab)uses is when we need to store the length of a free space extent as
stored in the realtime bitmap.  Because there can be up to 2^64 realtime
extents in a filesystem, we need a new type that is larger than
xfs_rtxlen_t for callers that are querying the bitmap directly.  This
means scrub and growfs.

Create this type as "xfs_rtbxlen_t" and use it to store 64-bit rtx
lengths.  'b' stands for 'bitmap' or 'big'; reader's choice.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h   |    2 +-
 fs/xfs/libxfs/xfs_rtbitmap.h |    2 +-
 fs/xfs/libxfs/xfs_types.h    |    1 +
 fs/xfs/scrub/trace.h         |    3 ++-
 4 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 371dc07233e0..20acb8573d7a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -98,7 +98,7 @@ typedef struct xfs_sb {
 	uint32_t	sb_blocksize;	/* logical block size, bytes */
 	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks */
 	xfs_rfsblock_t	sb_rblocks;	/* number of realtime blocks */
-	xfs_rtblock_t	sb_rextents;	/* number of realtime extents */
+	xfs_rtbxlen_t	sb_rextents;	/* number of realtime extents */
 	uuid_t		sb_uuid;	/* user-visible file system unique id */
 	xfs_fsblock_t	sb_logstart;	/* starting block of log if internal */
 	xfs_ino_t	sb_rootino;	/* root inode number */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index e2ea6d31c38b..b0a81fb8dbda 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -13,7 +13,7 @@
  */
 struct xfs_rtalloc_rec {
 	xfs_rtblock_t		ar_startext;
-	xfs_rtblock_t		ar_extcount;
+	xfs_rtbxlen_t		ar_extcount;
 };
 
 typedef int (*xfs_rtalloc_query_range_fn)(
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 713cb70311ef..9af98a975239 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -32,6 +32,7 @@ typedef uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
 typedef uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
 typedef uint64_t	xfs_fileoff_t;	/* block number in a file */
 typedef uint64_t	xfs_filblks_t;	/* number of blocks in a file */
+typedef uint64_t	xfs_rtbxlen_t;	/* rtbitmap extent length in rtextents */
 
 typedef int64_t		xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cbd4d01e253c..df49ca2e8c23 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1037,7 +1037,8 @@ TRACE_EVENT(xfarray_sort_stats,
 #ifdef CONFIG_XFS_RT
 TRACE_EVENT(xchk_rtsum_record_free,
 	TP_PROTO(struct xfs_mount *mp, xfs_rtblock_t start,
-		 uint64_t len, unsigned int log, loff_t pos, xfs_suminfo_t v),
+		 xfs_rtbxlen_t len, unsigned int log, loff_t pos,
+		 xfs_suminfo_t v),
 	TP_ARGS(mp, start, len, log, pos, v),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)

