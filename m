Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C15CCDB475
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbjJKSiE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbjJKSDz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:03:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E33F94
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:03:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17D4C433C8;
        Wed, 11 Oct 2023 18:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047433;
        bh=VOltanzmOVp0JEYhAyhyecjP/sVrFA+5LN5S6dRAV28=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=orNZrie+JQOYC3+cueJ4LICZJr0+X6b9S8JDBpiqZS5OT5+ZdW97WwHnsri+Mrdku
         SxnKxA/Rg20a0XNmu38/VbplGzJ3y/CtahvC7DwlMIhHUH4vecLguqQf3xZyeFOGY+
         foUwA70BO25gM33d+9iUJ/GY/WTbgTFBIWY4ms1oWXG9zE39Yy40bQkTel3Mx7fNfd
         Wu5EA9xG450lbGrvQ6Sltz7IR6qoD6R37LIFHqWIs7VzFH1I80aua7tabzcKt8omgh
         wC/s977BY15eCchtqv7C+XqBbINCCa3E4L5IF0ZkHyFuPfbOVZ3LJkC1qZdUaaRBZ0
         c6i3l8yFNjaXw==
Date:   Wed, 11 Oct 2023 11:03:53 -0700
Subject: [PATCH 5/7] xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704720803.1773388.2340578935063895607.stgit@frogsfrogsfrogs>
In-Reply-To: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
References: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_format.h   |    2 +-
 fs/xfs/libxfs/xfs_rtbitmap.h |    2 +-
 fs/xfs/libxfs/xfs_types.h    |    1 +
 fs/xfs/scrub/trace.h         |    3 ++-
 4 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4c784bccb1e43..9ce2ebf96667a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -97,7 +97,7 @@ typedef struct xfs_sb {
 	uint32_t	sb_blocksize;	/* logical block size, bytes */
 	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks */
 	xfs_rfsblock_t	sb_rblocks;	/* number of realtime blocks */
-	xfs_rtblock_t	sb_rextents;	/* number of realtime extents */
+	xfs_rtbxlen_t	sb_rextents;	/* number of realtime extents */
 	uuid_t		sb_uuid;	/* user-visible file system unique id */
 	xfs_fsblock_t	sb_logstart;	/* starting block of log if internal */
 	xfs_ino_t	sb_rootino;	/* root inode number */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index e2ea6d31c38b1..b0a81fb8dbda2 100644
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
index 0856997f84d6d..a2fb880433b56 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -32,6 +32,7 @@ typedef uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
 typedef uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
 typedef uint64_t	xfs_fileoff_t;	/* block number in a file */
 typedef uint64_t	xfs_filblks_t;	/* number of blocks in a file */
+typedef uint64_t	xfs_rtbxlen_t;	/* rtbitmap extent length in rtextents */
 
 typedef int64_t		xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index b0c4acc6f5d22..70cb27e8c292e 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1261,7 +1261,8 @@ TRACE_EVENT(xfarray_sort_stats,
 #ifdef CONFIG_XFS_RT
 TRACE_EVENT(xchk_rtsum_record_free,
 	TP_PROTO(struct xfs_mount *mp, xfs_rtblock_t start,
-		 uint64_t len, unsigned int log, loff_t pos, xfs_suminfo_t v),
+		 xfs_rtbxlen_t len, unsigned int log, loff_t pos,
+		 xfs_suminfo_t v),
 	TP_ARGS(mp, start, len, log, pos, v),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)

