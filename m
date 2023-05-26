Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331F6C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjEZBua (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZBu3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:50:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8270219D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FED560B6C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9C6C433EF;
        Fri, 26 May 2023 01:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065822;
        bh=EOoLb40hMpq/REU+q2IPQ/tfvrOlaftIoEjCIsN4JQM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=I+BZnwdR1qBqYjQNlRLdWdplAz8j4viX2RqdeDSJJgsKJf7hxY9f6CFeT26obHEPK
         ByYW2XV3kj5gGs5iV2KBFw/j4rspiT+zWNPsCqAQoRgqxKHGWPyrBDybBlUZdmXGCU
         k7Olmv7/iC0DC0/rrwCViKmMgROCZpb3tN0vlAD5V+PbcvbwV4uLQLvI1VXlOAZvXw
         L+fu0z37SiUZGvdjJCZOEV3Wy+76arwdVw52XeaETO7jXdYSfbDcW7/6U26l+V0cCR
         14ofrrpDEYfmx5bRq/Nr7s/zs1UF9CX55SjNJTvDWyXLW4mY7aHsFXS9m7KpW+C/ZP
         c0APHbI0Nft0w==
Date:   Thu, 25 May 2023 18:50:22 -0700
Subject: [PATCH 7/8] xfs_scrub: don't trim the first agbno of each AG for
 better performance
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073174.3744829.17181628429493007273.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073077.3744829.468307851541842353.stgit@frogsfrogsfrogs>
References: <168506073077.3744829.468307851541842353.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XFS issues discard IOs while holding the free space btree and the AGF
buffers locked.  If the discard IOs are slow or the free space is
extremely fragmented, this can lead to long stalls for every other
thread trying to access that AG.  On a 10TB high performance flash
storage device with a severely fragmented free space btree in every AG,
this results in many threads tripping the hangcheck warnings while
waiting for the AGF.  This happens even after we've run fstrim a few
times and waited for the nvme namespace utilization counters to
stabilize.

Strace for the entire 10TB looks like:
ioctl(3, FITRIM, {start=0x0, len=10995116277760, minlen=0}) = 0 <686.209839>

Reducing the size of the FITRIM requests to a single AG at a time
produces lower times for each individual call, but even this isn't quite
acceptable, because the lock hold times are still high enough to cause
stall warnings:

Strace for the first 4x 1TB AGs looks like (2):
ioctl(3, FITRIM, {start=0x0, len=1099511627776, minlen=0}) = 0 <68.352033>
ioctl(3, FITRIM, {start=0x10000000000, len=1099511627776, minlen=0}) = 0 <68.760323>
ioctl(3, FITRIM, {start=0x20000000000, len=1099511627776, minlen=0}) = 0 <67.235226>
ioctl(3, FITRIM, {start=0x30000000000, len=1099511627776, minlen=0}) = 0 <69.465744>

The fstrim code has to synchronize discards with block allocations, so
we must hold the AGF lock while issuing discard IOs.  Breaking up the
calls into smaller start/len segments ought to reduce the lock hold time
and allow other threads a chance to make progress.  Unfortunately, the
current fstrim implementation handles this poorly because it walks the
entire free space by length index (cntbt) and it's not clear if we can
cycle the AGF periodically to reduce latency because there's no
less-than btree lookup.

The first solution I thought of was to limit latency by scanning parts
of an AG at a time, but this doesn't solve the stalling problem when the
free space is heavily fragmented because each sub-AG scan has to walk
the entire cntbt to find free space that fits within the given range.
In fact, this dramatically increases the runtime!

Ultimately, I forked the kernel implementations -- for full AG fstrims,
it still trims by length.  However, for a sub-AG scan, it will walk the
bnobt and perform the trims in block number order.  Since the cursor
has an obviously monotonically increasing value, it is easy to cycle the
AGF periodically to allow other threads to do work.  This implementation
avoids the worst problems of the original code, though it lacks the
desirable attribute of freeing the biggest chunks first.

This second algorithm is what we want for xfs_scrub, which generally
runs as a background service.  Skip the first block of each AG to ensure
that we get the sub-AG algorithm,

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++---------
 scrub/vfs.c    |   10 ++++++---
 scrub/vfs.h    |    2 +-
 3 files changed, 61 insertions(+), 14 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index d21f62099b9..ac64c82980e 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -45,29 +45,72 @@ fstrim_ok(
 	return true;
 }
 
-/* Trim the filesystem, if desired. */
-int
-phase8_func(
-	struct scrub_ctx	*ctx)
+/* Trim a certain range of the filesystem. */
+static int
+fstrim_fsblocks(
+	struct scrub_ctx	*ctx,
+	uint64_t		start_fsb,
+	uint64_t		fsbcount)
 {
+	uint64_t		start = cvt_off_fsb_to_b(&ctx->mnt, start_fsb);
+	uint64_t		len = cvt_off_fsb_to_b(&ctx->mnt, fsbcount);
 	int			error;
 
-	if (!fstrim_ok(ctx))
-		return 0;
-
-	error = fstrim(ctx);
+	error = fstrim(ctx, start, len);
 	if (error == EOPNOTSUPP)
 		return 0;
-
 	if (error) {
-		str_liberror(ctx, error, _("fstrim"));
+		char		descr[DESCR_BUFSZ];
+
+		snprintf(descr, sizeof(descr) - 1,
+				_("fstrim start 0x%llx len 0x%llx"),
+				(unsigned long long)start,
+				(unsigned long long)len);
+		str_liberror(ctx, error, descr);
 		return error;
 	}
 
+	return 0;
+}
+
+/* Trim each AG on the data device. */
+static int
+fstrim_datadev(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_fsop_geom	*geo = &ctx->mnt.fsgeom;
+	uint64_t		fsbno;
+	int			error;
+
+	for (fsbno = 0; fsbno < geo->datablocks; fsbno += geo->agblocks) {
+		uint64_t	fsbcount;
+
+		/*
+		 * Skip the first block of each AG to ensure that we get the
+		 * partial-AG discard implementation, which cycles the AGF lock
+		 * to prevent foreground threads from stalling.
+		 */
+		fsbcount = min(geo->datablocks - fsbno + 1, geo->agblocks);
+		error = fstrim_fsblocks(ctx, fsbno + 1, fsbcount);
+		if (error)
+			return error;
+	}
+
 	progress_add(1);
 	return 0;
 }
 
+/* Trim the filesystem, if desired. */
+int
+phase8_func(
+	struct scrub_ctx	*ctx)
+{
+	if (!fstrim_ok(ctx))
+		return 0;
+
+	return fstrim_datadev(ctx);
+}
+
 /* Estimate how much work we're going to do. */
 int
 phase8_estimate(
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 5366e005746..c47db5890a5 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -298,11 +298,15 @@ struct fstrim_range {
 /* Call FITRIM to trim all the unused space in a filesystem. */
 int
 fstrim(
-	struct scrub_ctx	*ctx)
+	struct scrub_ctx	*ctx,
+	uint64_t		start,
+	uint64_t		len)
 {
-	struct fstrim_range	range = {0};
+	struct fstrim_range	range = {
+		.start		= start,
+		.len		= len,
+	};
 
-	range.len = ULLONG_MAX;
 	if (ioctl(ctx->mnt.fd, FITRIM, &range) == 0)
 		return 0;
 	if (errno == EOPNOTSUPP || errno == ENOTTY)
diff --git a/scrub/vfs.h b/scrub/vfs.h
index e512df647b4..db222d9c7ee 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -24,6 +24,6 @@ typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
-int fstrim(struct scrub_ctx *ctx);
+int fstrim(struct scrub_ctx *ctx, uint64_t start, uint64_t len);
 
 #endif /* XFS_SCRUB_VFS_H_ */

