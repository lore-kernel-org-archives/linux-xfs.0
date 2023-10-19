Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B424CDB483
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbjJSQX4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbjJSQXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:23:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4E89B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:23:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95253C433C7;
        Thu, 19 Oct 2023 16:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732633;
        bh=pHooymGNbbdwU2p/FjZIsCjz93wt67Vm5P2Rq9oAxxU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=M2zM2C/VWYLDUPeZPPG5LJ0EX+5Id0WOXa5Smd2x6I2+Ver4nRzg7j5wQnVpBd58n
         oVyPVtwVMl9jRqVxbfq2eYJ19vM4SswD+s/80m79pJ9/by1KmdWcRIwuzn6rbDDzM6
         lXemH1X/87/eFwNXLWjMvjXFzDbxIn9cLkSgoFL/gfjdvNCHJeFoImBpdp3FsEiMR/
         mLOwxjzo96HUJhzG+ocAXHinQBQ92cMPkncnYJpPw5iG/Lst//plSqmcWjvncWUA9A
         WUG+OzZMYNUZgMeQQhdlVJTLR+y3pojqyH0ViRW08v/BfB78sh9n1FNPKlW4cU4QQR
         /O6Fs1pN2dJLA==
Date:   Thu, 19 Oct 2023 09:23:53 -0700
Subject: [PATCH 6/8] xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210218.225045.363501883513730307.stgit@frogsfrogsfrogs>
In-Reply-To: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
References: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
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

