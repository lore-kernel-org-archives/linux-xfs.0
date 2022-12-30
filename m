Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A51C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbiLaDYz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236378AbiLaDYe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:24:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF4712A91
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:24:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D548B81E72
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFCFC433EF;
        Sat, 31 Dec 2022 03:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457071;
        bh=e/BwOndh6OfnYjUMlPMuOsKTUKteYguEs7BfA7P7bO4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AGxfMWM5rsQc/50ncw3+Tj1YiYYfqJS3TRSzRbR2dLhiLDRVEP6kCKbgwbZwVTLN2
         cWVcyPXIxeYB7pXgv0TOsxTcBU8wA00aHTeh1XoBneMkdbzfl36MNMzvg66adaLCck
         fUhJUCXIyNgrljTvNAGaldUtdNSr5mxXyXWpRFxo7YE12vBXyNkdvEakTjvWDYPRdC
         Xy+eiBNuHPUi6MmrsxxU9BlJTh7JZyGcPnp4pIxnhiyrChch4H/Ys2vXCY4ZADgk6E
         UI0THqoibjx/gyHMmxDpyQluHwPAGRp2/nYk+n4Il+/tnSOm8njwBCQpYysjc+2B48
         jTqWUvhYuaxWw==
Subject: [PATCH 1/2] xfs: capture the offset and length in fallocate
 tracepoints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:30 -0800
Message-ID: <167243877021.727784.15749904053525920523.stgit@magnolia>
In-Reply-To: <167243877005.727784.16278955284134985550.stgit@magnolia>
References: <167243877005.727784.16278955284134985550.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Change the class of the fallocate tracepoints to capture the offset and
length of the requested operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    8 ++++----
 fs/xfs/xfs_file.c      |    2 +-
 fs/xfs/xfs_trace.h     |   10 +++++-----
 3 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 558951710404..8515190d2bc6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -828,7 +828,7 @@ xfs_alloc_file_space(
 	xfs_bmbt_irec_t		imaps[1], *imapp;
 	int			error;
 
-	trace_xfs_alloc_file_space(ip);
+	trace_xfs_alloc_file_space(ip, offset, len);
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -1012,7 +1012,7 @@ xfs_free_file_space(
 	xfs_fileoff_t		endoffset_fsb;
 	int			done = 0, error;
 
-	trace_xfs_free_file_space(ip);
+	trace_xfs_free_file_space(ip, offset, len);
 
 	error = xfs_qm_dqattach(ip);
 	if (error)
@@ -1150,7 +1150,7 @@ xfs_collapse_file_space(
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 
-	trace_xfs_collapse_file_space(ip);
+	trace_xfs_collapse_file_space(ip, offset, len);
 
 	error = xfs_free_file_space(ip, offset, len);
 	if (error)
@@ -1220,7 +1220,7 @@ xfs_insert_file_space(
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 
-	trace_xfs_insert_file_space(ip);
+	trace_xfs_insert_file_space(ip, offset, len);
 
 	error = xfs_bmap_can_insert_extents(ip, stop_fsb, shift_fsb);
 	if (error)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 87e836e1aeb3..449146f9af41 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1096,7 +1096,7 @@ xfs_file_fallocate(
 			 */
 			unsigned int blksize = i_blocksize(inode);
 
-			trace_xfs_zero_file_space(ip);
+			trace_xfs_zero_file_space(ip, offset, len);
 
 			/* Unshare around the region to zero, if needed. */
 			if (xfs_inode_needs_cow_around(ip)) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b422a206edb5..8a7d08228586 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -817,11 +817,6 @@ DEFINE_INODE_EVENT(xfs_getattr);
 DEFINE_INODE_EVENT(xfs_setattr);
 DEFINE_INODE_EVENT(xfs_readlink);
 DEFINE_INODE_EVENT(xfs_inactive_symlink);
-DEFINE_INODE_EVENT(xfs_alloc_file_space);
-DEFINE_INODE_EVENT(xfs_free_file_space);
-DEFINE_INODE_EVENT(xfs_zero_file_space);
-DEFINE_INODE_EVENT(xfs_collapse_file_space);
-DEFINE_INODE_EVENT(xfs_insert_file_space);
 DEFINE_INODE_EVENT(xfs_readdir);
 #ifdef CONFIG_XFS_POSIX_ACL
 DEFINE_INODE_EVENT(xfs_get_acl);
@@ -1610,6 +1605,11 @@ DEFINE_SIMPLE_IO_EVENT(xfs_zero_eof);
 DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write);
 DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_unwritten);
 DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_append);
+DEFINE_SIMPLE_IO_EVENT(xfs_alloc_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_free_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_zero_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_collapse_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_insert_file_space);
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),

