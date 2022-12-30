Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA084C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbiLaD3O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiLaD3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:29:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8670713D49
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:29:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12F9261CC2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E60CC433D2;
        Sat, 31 Dec 2022 03:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457351;
        bh=3bG9yTr4Dkqvr+Naa8WtyIJ22oxARrO1MtjZdD9AJ3Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oFbK3+Nqcg8yLowsQR46gFm9Iqt9+ELJq5Jh9DY56+wlhexJ5p4wwmZm8lnIHS0Oa
         QYNoitoAeSKACrisyH4bCAivCJZIHTuKmVqjSIYXs0dUi25Zf9arCsn05bNbbkovTJ
         xzYzVYtbG89RTMOSjPfKyBtJrfBmL2Jp4lvY6dr2O/x/RPX14F8OEE8FJYSeSOHQLi
         m+jkyzEyUgb/j8oEw8BQfKSVLupw+amqaGz65IfB3Q/f35REJaAYkhXrs+ORGEqXmU
         C+pIdVRF5R7MfBnKdyCGOwVRjsRbKpMuUwqGPwxs9uc/Jxf1n8FN57u5stC20va/Po
         tBc8qRngPNXBA==
Subject: [PATCH 5/5] xfs_spaceman: defragment free space with normal files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:48 -0800
Message-ID: <167243884832.740087.10783826311621665516.stgit@magnolia>
In-Reply-To: <167243884763.740087.13414287212519500865.stgit@magnolia>
References: <167243884763.740087.13414287212519500865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/clearspace.c |  377 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 297 insertions(+), 80 deletions(-)


diff --git a/libfrog/clearspace.c b/libfrog/clearspace.c
index 601257022b8..452cd13db45 100644
--- a/libfrog/clearspace.c
+++ b/libfrog/clearspace.c
@@ -1362,6 +1362,17 @@ csp_evac_dedupe_loop(
 			fdr->src_length = old_reqlen;
 			continue;
 		}
+		if (ret == EINVAL) {
+			/*
+			 * If we can't dedupe get the block, it's possible that
+			 * src_fd was punched or truncated out from under us.
+			 * Treat this the same way we would if the contents
+			 * didn't match.
+			 */
+			trace_dedupe(req, "cannot evac space, moving on", 0);
+			same = false;
+			ret = 0;
+		}
 		if (ret) {
 			fprintf(stderr, _("evacuating inode 0x%llx: %s\n"),
 					ino, strerror(ret));
@@ -1939,8 +1950,14 @@ csp_evac_fs_metadata(
  * the space capture file, or 1 if there's nothing to transfer to the space
  * capture file.
  */
-static int
-csp_freeze_check_attempt(
+enum freeze_outcome {
+	FREEZE_FAILED = -1,
+	FREEZE_DONE,
+	FREEZE_SKIP,
+};
+
+static enum freeze_outcome
+csp_freeze_check_outcome(
 	struct clearspace_req	*req,
 	const struct fsmap	*mrec,
 	unsigned long long	*len)
@@ -1950,13 +1967,12 @@ csp_freeze_check_attempt(
 
 	*len = 0;
 
-	ret = bmapx_one(req, req->work_fd, mrec->fmr_physical,
-			mrec->fmr_length, &brec);
+	ret = bmapx_one(req, req->work_fd, 0, mrec->fmr_length, &brec);
 	if (ret)
-		return ret;
+		return FREEZE_FAILED;
 
 	trace_freeze(req,
- "does workfd pos 0x%llx len 0x%llx map to phys 0x%llx len 0x%llx?",
+ "check if workfd pos 0x0 phys 0x%llx len 0x%llx maps to phys 0x%llx len 0x%llx",
 			(unsigned long long)mrec->fmr_physical,
 			(unsigned long long)mrec->fmr_length,
 			(unsigned long long)BBTOB(brec.bmv_block),
@@ -1964,8 +1980,8 @@ csp_freeze_check_attempt(
 
 	/* freeze of an unwritten extent punches a hole in the work file. */
 	if ((mrec->fmr_flags & FMR_OF_PREALLOC) && brec.bmv_block == -1) {
-		*len = BBTOB(brec.bmv_length);
-		return 1;
+		*len = min(mrec->fmr_length, BBTOB(brec.bmv_length));
+		return FREEZE_SKIP;
 	}
 
 	/*
@@ -1974,8 +1990,8 @@ csp_freeze_check_attempt(
 	 */
 	if (!(mrec->fmr_flags & FMR_OF_PREALLOC) &&
 	    BBTOB(brec.bmv_block) == mrec->fmr_physical) {
-		*len = BBTOB(brec.bmv_length);
-		return 0;
+		*len = min(mrec->fmr_length, BBTOB(brec.bmv_length));
+		return FREEZE_DONE;
 	}
 
 	/*
@@ -1984,20 +2000,15 @@ csp_freeze_check_attempt(
 	 * have been mapped into the work file.  Set @len to zero and return so
 	 * that we try again with the next mapping.
 	 */
+	trace_falloc(req, "reset workfd isize 0x0", 0);
 
-	trace_falloc(req, "fpunch workfd pos 0x%llx bytecount 0x%llx",
-			(unsigned long long)mrec->fmr_physical,
-			(unsigned long long)mrec->fmr_length);
-
-	ret = fallocate(req->work_fd,
-			FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-			mrec->fmr_physical, mrec->fmr_length);
+	ret = ftruncate(req->work_fd, 0);
 	if (ret) {
 		perror(_("resetting work file after failed freeze"));
-		return ret;
+		return FREEZE_FAILED;
 	}
 
-	return 1;
+	return FREEZE_SKIP;
 }
 
 /*
@@ -2014,6 +2025,7 @@ csp_freeze_open(
 	int			*fd)
 {
 	struct xfs_bulkstat	bulkstat;
+	int			oflags = O_RDWR;
 	int			target_fd;
 	int			ret;
 
@@ -2041,7 +2053,10 @@ csp_freeze_open(
 	if (!S_ISREG(bulkstat.bs_mode) && !S_ISDIR(bulkstat.bs_mode))
 		return 0;
 
-	target_fd = csp_open_by_handle(req, O_RDONLY, mrec->fmr_owner,
+	if (S_ISDIR(bulkstat.bs_mode))
+		oflags = O_RDONLY;
+
+	target_fd = csp_open_by_handle(req, oflags, mrec->fmr_owner,
 			bulkstat.bs_gen);
 	if (target_fd == -2)
 		return 0;
@@ -2061,6 +2076,122 @@ csp_freeze_open(
 	return 0;
 }
 
+static inline uint64_t rounddown_64(uint64_t x, uint64_t y)
+{
+	return (x / y) * y;
+}
+
+/*
+ * Deal with a frozen extent containing a partially written EOF block.  Either
+ * we use funshare to get src_fd to release the block, or we reduce the length
+ * of the frozen extent by one block.
+ */
+static int
+csp_freeze_unaligned_eofblock(
+	struct clearspace_req	*req,
+	int			src_fd,
+	const struct fsmap	*mrec,
+	unsigned long long	*frozen_len)
+{
+	struct getbmapx		brec;
+	struct stat		statbuf;
+	loff_t			work_offset, length;
+	int			ret;
+
+	ret = fstat(req->work_fd, &statbuf);
+	if (ret) {
+		perror(_("statting work file"));
+		return ret;
+	}
+
+	/*
+	 * The frozen extent is less than the size of the work file, which
+	 * means that we're already block aligned.
+	 */
+	if (*frozen_len <= statbuf.st_size)
+		return 0;
+
+	/* The frozen extent does not contain a partially written EOF block. */
+	if (statbuf.st_size % statbuf.st_blksize == 0)
+		return 0;
+
+	/*
+	 * Unshare what we think is a partially written EOF block of the
+	 * original file, to try to force it to release that block.
+	 */
+	work_offset = rounddown_64(statbuf.st_size, statbuf.st_blksize);
+	length = statbuf.st_size - work_offset;
+
+	trace_freeze(req,
+ "unaligned eofblock 0x%llx work_size 0x%llx blksize 0x%x work_offset 0x%llx work_length 0x%llx",
+			*frozen_len, statbuf.st_size, statbuf.st_blksize,
+			work_offset, length);
+
+	ret = fallocate(src_fd, FALLOC_FL_UNSHARE_RANGE,
+			mrec->fmr_offset + work_offset, length);
+	if (ret) {
+		perror(_("unsharing original file"));
+		return ret;
+	}
+
+	ret = fsync(src_fd);
+	if (ret) {
+		perror(_("flushing original file"));
+		return ret;
+	}
+
+	ret = bmapx_one(req, req->work_fd, work_offset, length, &brec);
+	if (ret)
+		return ret;
+
+	if (BBTOB(brec.bmv_block) != mrec->fmr_physical + work_offset) {
+		fprintf(stderr,
+ _("work file offset 0x%llx maps to phys 0x%llx, expected 0x%llx"),
+				(unsigned long long)work_offset,
+				(unsigned long long)BBTOB(brec.bmv_block),
+				(unsigned long long)mrec->fmr_physical);
+		return -1;
+	}
+
+	/*
+	 * If the block is still shared, there must be other owners of this
+	 * block.  Round down the frozen length and we'll come back to it
+	 * eventually.
+	 */
+	if (brec.bmv_oflags & BMV_OF_SHARED) {
+		*frozen_len = work_offset;
+		return 0;
+	}
+
+	/*
+	 * Not shared anymore, so increase the size of the file to the next
+	 * block boundary so that we can reflink it into the space capture
+	 * file.
+	 */
+	ret = ftruncate(req->work_fd,
+			BBTOB(brec.bmv_length) + BBTOB(brec.bmv_offset));
+	if (ret) {
+		perror(_("expanding work file"));
+		return ret;
+	}
+
+	/* Double-check that we didn't lose the block. */
+	ret = bmapx_one(req, req->work_fd, work_offset, length, &brec);
+	if (ret)
+		return ret;
+
+	if (BBTOB(brec.bmv_block) != mrec->fmr_physical + work_offset) {
+		fprintf(stderr,
+ _("work file offset 0x%llx maps to phys 0x%llx, should be 0x%llx"),
+				(unsigned long long)work_offset,
+				(unsigned long long)BBTOB(brec.bmv_block),
+				(unsigned long long)mrec->fmr_physical);
+		return -1;
+	}
+
+	return 0;
+}
+
 /*
  * Given a fsmap, try to reflink the physical space into the space capture
  * file.
@@ -2074,6 +2205,7 @@ csp_freeze_req_fsmap(
 	struct fsmap		short_mrec;
 	struct file_clone_range	fcr = { };
 	unsigned long long	frozen_len;
+	enum freeze_outcome	outcome;
 	int			src_fd;
 	int			ret, ret2;
 
@@ -2126,33 +2258,86 @@ csp_freeze_req_fsmap(
 	}
 
 	/*
-	 * Reflink the mapping from the source file into the work file.  If we
+	 * Reflink the mapping from the source file into the empty work file so
+	 * that a write will be written elsewhere.  The only way to reflink a
+	 * partially written EOF block is if the kernel can reset the work file
+	 * size so that the post-EOF part of the block remains post-EOF.  If we
 	 * can't do that, we're sunk.  If the mapping is unwritten, we'll leave
 	 * a hole in the work file.
 	 */
+	ret = ftruncate(req->work_fd, 0);
+	if (ret) {
+		perror(_("truncating work file for freeze"));
+		goto out_fd;
+	}
+
 	fcr.src_fd = src_fd;
 	fcr.src_offset = mrec->fmr_offset;
 	fcr.src_length = mrec->fmr_length;
-	fcr.dest_offset = mrec->fmr_physical;
+	fcr.dest_offset = 0;
 
-	trace_freeze(req, "freeze to workfd pos 0x%llx",
-			(unsigned long long)fcr.dest_offset);
+	trace_freeze(req,
+ "reflink ino 0x%llx offset 0x%llx bytecount 0x%llx into workfd",
+			(unsigned long long)mrec->fmr_owner,
+			(unsigned long long)fcr.src_offset,
+			(unsigned long long)fcr.src_length);
 
 	ret = clonerange(req->work_fd, &fcr);
-	if (ret) {
-		fprintf(stderr, _("freezing space to work file: %s\n"),
-				strerror(ret));
-		goto out_fd;
+	if (ret == EINVAL) {
+		/*
+		 * If that didn't work, try reflinking to EOF and picking out
+		 * whatever pieces we want.
+		 */
+		fcr.src_length = 0;
+
+		trace_freeze(req,
+ "reflink ino 0x%llx offset 0x%llx to EOF into workfd",
+				(unsigned long long)mrec->fmr_owner,
+				(unsigned long long)fcr.src_offset);
+
+		ret = clonerange(req->work_fd, &fcr);
 	}
-
-	req->trace_indent++;
-	ret = csp_freeze_check_attempt(req, mrec, &frozen_len);
-	req->trace_indent--;
-	if (ret < 0)
-		goto out_fd;
-	if (ret == 1) {
+	if (ret == EINVAL) {
+		/*
+		 * If we still can't get the block, it's possible that src_fd
+		 * was punched or truncated out from under us, so we just move
+		 * on to the next fsmap.
+		 */
+		trace_freeze(req, "cannot freeze space, moving on", 0);
 		ret = 0;
-		goto advance;
+		goto out_fd;
+	}
+	if (ret) {
+		fprintf(stderr, _("freezing space to work file: %s\n"),
+				strerror(ret));
+		goto out_fd;
+	}
+
+	req->trace_indent++;
+	outcome = csp_freeze_check_outcome(req, mrec, &frozen_len);
+	req->trace_indent--;
+	switch (outcome) {
+	case FREEZE_FAILED:
+		ret = -1;
+		goto out_fd;
+	case FREEZE_SKIP:
+		*cursor += frozen_len;
+		goto out_fd;
+	case FREEZE_DONE:
+		break;
+	}
+
+	/*
+	 * If we tried reflinking to EOF to capture a partially written EOF
+	 * block in the work file, we need to unshare the end of the source
+	 * file before we try to reflink the frozen space into the space
+	 * capture file.
+	 */
+	if (fcr.src_length == 0) {
+		ret = csp_freeze_unaligned_eofblock(req, src_fd, mrec,
+				&frozen_len);
+		if (ret)
+			goto out_fd;
 	}
 
 	/*
@@ -2164,11 +2349,11 @@ csp_freeze_req_fsmap(
 	 * the contents of the work file.
 	 */
 	fcr.src_fd = req->work_fd;
-	fcr.src_offset = mrec->fmr_physical;
+	fcr.src_offset = 0;
 	fcr.dest_offset = mrec->fmr_physical;
 	fcr.src_length = frozen_len;
 
-	trace_freeze(req, "link phys 0x%llx len 0x%llx to spacefd",
+	trace_freeze(req, "reflink phys 0x%llx len 0x%llx to spacefd",
 			(unsigned long long)mrec->fmr_physical,
 			(unsigned long long)mrec->fmr_length);
 
@@ -2187,7 +2372,6 @@ csp_freeze_req_fsmap(
 		goto out_fd;
 	}
 
-advance:
 	*cursor += frozen_len;
 out_fd:
 	ret2 = close(src_fd);
@@ -2278,6 +2462,79 @@ csp_collect_garbage(
 	return 0;
 }
 
+static int
+csp_prepare(
+	struct clearspace_req	*req)
+{
+	blkcnt_t		old_blocks = 0;
+	int			ret;
+
+	/*
+	 * Empty out CoW forks and speculative post-EOF preallocations before
+	 * starting the clearing process.  This may be somewhat overkill.
+	 */
+	ret = syncfs(req->xfd->fd);
+	if (ret) {
+		perror(_("syncing filesystem"));
+		return ret;
+	}
+
+	ret = csp_collect_garbage(req);
+	if (ret)
+		return ret;
+
+	/*
+	 * Set up the space capture file as a large sparse file mirroring the
+	 * physical space that we want to defragment.
+	 */
+	ret = ftruncate(req->space_fd, req->start + req->length);
+	if (ret) {
+		perror(_("setting up space capture file"));
+		return ret;
+	}
+
+	/*
+	 * If we don't have reflink, just grab the free space and move on to
+	 * copying and exchanging file contents.
+	 */
+	if (!req->use_reflink)
+		return csp_grab_free_space(req);
+
+	/*
+	 * Try to freeze as much of the requested range as we can, grab the
+	 * free space in that range, and run freeze again to pick up anything
+	 * that may have been allocated while all that was going on.
+	 */
+	do {
+		struct stat	statbuf;
+
+		ret = csp_freeze_req_range(req);
+		if (ret)
+			return ret;
+
+		ret = csp_grab_free_space(req);
+		if (ret)
+			return ret;
+
+		ret = fstat(req->space_fd, &statbuf);
+		if (ret)
+			return ret;
+
+		if (old_blocks == statbuf.st_blocks)
+			break;
+		old_blocks = statbuf.st_blocks;
+	} while (1);
+
+	/*
+	 * If reflink is enabled, our strategy is to dedupe to free blocks in
+	 * the area that we're clearing without making any user-visible changes
+	 * to the file contents.  For all the written file data blocks in area
+	 * we're clearing, make an identical copy in the work file that is
+	 * backed by blocks that are not in the clearing area.
+	 */
+	return csp_prepare_for_dedupe(req);
+}
+
 /* Set up the target to clear all metadata from the given range. */
 static inline void
 csp_target_metadata(
@@ -2330,50 +2587,10 @@ clearspace_run(
 		return ret;
 	}
 
-	/*
-	 * Empty out CoW forks and speculative post-EOF preallocations before
-	 * starting the clearing process.  This may be somewhat overkill.
-	 */
-	ret = syncfs(req->xfd->fd);
-	if (ret) {
-		perror(_("syncing filesystem"));
-		goto out_bitmap;
-	}
-
-	ret = csp_collect_garbage(req);
-	if (ret)
-		goto out_bitmap;
-
-	/*
-	 * Try to freeze as much of the requested range as we can, grab the
-	 * free space in that range, and run freeze again to pick up anything
-	 * that may have been allocated while all that was going on.
-	 */
-	ret = csp_freeze_req_range(req);
-	if (ret)
-		goto out_bitmap;
-
-	ret = csp_grab_free_space(req);
-	if (ret)
-		goto out_bitmap;
-
-	ret = csp_freeze_req_range(req);
+	ret = csp_prepare(req);
 	if (ret)
 		goto out_bitmap;
 
-	/*
-	 * If reflink is enabled, our strategy is to dedupe to free blocks in
-	 * the area that we're clearing without making any user-visible changes
-	 * to the file contents.  For all the written file data blocks in area
-	 * we're clearing, make an identical copy in the work file that is
-	 * backed by blocks that are not in the clearing area.
-	 */
-	if (req->use_reflink) {
-		ret = csp_prepare_for_dedupe(req);
-		if (ret)
-			goto out_bitmap;
-	}
-
 	/* Evacuate as many file blocks as we can. */
 	do {
 		ret = csp_find_target(req, &target);

