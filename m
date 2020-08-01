Return-Path: <SRS0=tAZO=BL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F396FC433DF
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Aug 2020 08:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4540206E9
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Aug 2020 08:28:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E/DFgomx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgHAI2e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 1 Aug 2020 04:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgHAI2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Aug 2020 04:28:33 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D24C06174A
        for <linux-xfs@vger.kernel.org>; Sat,  1 Aug 2020 01:28:33 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k1so8432911pjt.5
        for <linux-xfs@vger.kernel.org>; Sat, 01 Aug 2020 01:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Y8hajanOafttS0sefGkmYj5qnA1qMnPErSljL32SSA=;
        b=E/DFgomxp5/yajze5NL3JzFxpntoZ5i00jbMsiO4qIlgk3dtIZhDdmPYzlQT3QLBBc
         yG0ttQ8HRFeyNVrHv2IHpHEw/1z6Xd/WTavDoa+2v/9m/v8NRMlTIpxdxR90kbel/QWq
         Jd4JN/dUNvJNQXmEC8bfpjJ8eQDdziSok41Lcdh3iQDRK63eb0E3+vbykFzqD9pGa7X5
         FxfpaDZXWUDn+W2geE5OQWu5WBsrqI4XVQjSwYyAVXy3lRiAlC+zDyARJKHeuhgxJyE0
         bV+Q8o2HkVvQCtsmV8AXzVAUh6MPG6Ac9eEjxdE5wsffSk+LZhfzLoqmEaWuQqMjyMn2
         66aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Y8hajanOafttS0sefGkmYj5qnA1qMnPErSljL32SSA=;
        b=NKitL73vWL0IBMk/0fAb0IllwpBa0xO3na87ArPlFD2Ab7pROKHeYE/H5pUb9VXcdj
         2ILmOT6+sc4rO8KQy1mz43GwxnkNAfuYGERy/5mwRX0As58ID9mSxjV9uocCc2hmDFtZ
         v64RX4cu21I6KitMHpy5mcsSZUQRRzhnar9AtSxm0QvV50mishsqsqXNPR4zivKKjXic
         E3VsZa3hUtBH8Yag+ogaElLVYGURE9KH23vqFiSwPcD51ZhlVYl2cH7jouLq2W6+m0Gp
         q/fll7sJlKwsadUSry3drGCPqRkIn9VLx/cNzxQjShfsBS790zF+fynv6I0B+yAZCbGS
         msAQ==
X-Gm-Message-State: AOAM530kO/fkMtvGfrDRKOFgmZfRPmL6C4Voka5gVV/sh+H0n3+Y9F8U
        KSGB+nXGUwwd+jS8zj0XJMAE5QEV
X-Google-Smtp-Source: ABdhPJzkPpffTagjeV47LsqMcheShDTfZMUdZcu8/AfrtqSJfVqnTQH5pSeMrrtpj4tI3p2q9iJZZQ==
X-Received: by 2002:a17:902:aa42:: with SMTP id c2mr6939057plr.218.1596270512845;
        Sat, 01 Aug 2020 01:28:32 -0700 (PDT)
Received: from localhost.localdomain ([122.182.254.175])
        by smtp.gmail.com with ESMTPSA id 127sm13433380pgf.5.2020.08.01.01.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 01:28:32 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH RESEND 2/2] xfs: Bail out if transaction can cause extent count to overflow
Date:   Sat,  1 Aug 2020 13:58:03 +0530
Message-Id: <20200801082803.12109-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200801082803.12109-1-chandanrlinux@gmail.com>
References: <20200801082803.12109-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit computes the maximum number of new extents that can be added
to per-inode forks (data and xattr) at the beginning of a
transaction. It then uses the helper function xfs_trans_resv_ext_cnt()
to verify that the resulting sum does not overflow the corresponding
on-disk inode extent counter.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 33 ++++++++++++--
 fs/xfs/libxfs/xfs_bmap.c |  7 +++
 fs/xfs/xfs_bmap_item.c   | 12 +++++
 fs/xfs/xfs_bmap_util.c   | 40 +++++++++++++++++
 fs/xfs/xfs_dquot.c       |  7 ++-
 fs/xfs/xfs_inode.c       | 96 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c       | 19 ++++++++
 fs/xfs/xfs_reflink.c     | 35 +++++++++++++++
 fs/xfs/xfs_rtalloc.c     |  4 ++
 fs/xfs/xfs_symlink.c     | 18 ++++++++
 10 files changed, 267 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d4583a0d1b3f..745bf9293a17 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -142,7 +142,8 @@ xfs_attr_get(
 STATIC int
 xfs_attr_calc_size(
 	struct xfs_da_args	*args,
-	int			*local)
+	int			*local,
+	int			*dsplit)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
 	int			size;
@@ -157,7 +158,10 @@ xfs_attr_calc_size(
 	if (*local) {
 		if (size > (args->geo->blksize / 2)) {
 			/* Double split possible */
+			*dsplit = 1;
 			nblks *= 2;
+		} else {
+			*dsplit = 0;
 		}
 	} else {
 		/*
@@ -395,7 +399,8 @@ xfs_attr_set(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
-	int			error, local;
+	int			error, local, dsplit;
+	int			rsv_exts = 0;
 	unsigned int		total;
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
@@ -420,7 +425,7 @@ xfs_attr_set(
 		XFS_STATS_INC(mp, xs_attr_set);
 
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		args->total = xfs_attr_calc_size(args, &local);
+		args->total = xfs_attr_calc_size(args, &local, &dsplit);
 
 		/*
 		 * If the inode doesn't have an attribute fork, add one.
@@ -442,11 +447,19 @@ xfs_attr_set(
 		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
 		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 		total = args->total;
+
+		if (local) {
+			if (dsplit)
+				++rsv_exts;
+		} else {
+			rsv_exts += xfs_attr3_rmt_blocks(mp, args->valuelen);
+		}
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
 
 		tres = M_RES(mp)->tr_attrrm;
 		total = XFS_ATTRRM_SPACE_RES(mp);
+		rsv_exts += xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
 	/*
@@ -460,6 +473,20 @@ xfs_attr_set(
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(args->trans, dp, 0);
+
+	rsv_exts += XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
+
+	if (args->value || xfs_inode_hasattr(dp)) {
+		/*
+		 * XFS_DA_NODE_MAXDEPTH blocks for dabtree.
+		 * One extra block for dabtree in case of a double split.
+		 * Extents for remote attributes.
+		 */
+		error = xfs_trans_resv_ext_cnt(dp, XFS_ATTR_FORK, rsv_exts);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	if (args->value) {
 		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9c40d5971035..462869ab26b9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4527,6 +4527,13 @@ xfs_bmapi_convert_delalloc(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	if (whichfork == XFS_DATA_FORK) {
+		error = xfs_trans_resv_ext_cnt(ip, whichfork, 1);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ijoin(tp, ip, 0);
 
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ec3691372e7c..de427444cc8a 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -519,6 +519,18 @@ xfs_bui_item_recover(
 	}
 	xfs_trans_ijoin(tp, ip, 0);
 
+	/*
+	 * Removing an extent from the middle of an existing extent
+	 * can cause the extent count to increase by 1.
+	 * i.e. | Old extent | Hole | Old extent |
+	 *
+	 * Mapping a new extent into a file can cause the extent
+	 * count to increase by 1.
+	 */
+	error = xfs_trans_resv_ext_cnt(ip, whichfork, 1);
+	if (error)
+		goto err_inode;
+
 	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
 			bmap->me_startoff, bmap->me_startblock, &count, state);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index afdc7f8e0e70..a8cd0f7c6005 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -822,6 +822,10 @@ xfs_alloc_file_space(
 		if (error)
 			goto error1;
 
+		error = xfs_trans_resv_ext_cnt(ip, XFS_DATA_FORK, 1);
+		if (error)
+			goto error0;
+
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
@@ -886,6 +890,15 @@ xfs_unmap_extent(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
+	/*
+	 * One extent encompasses the complete file offset range.
+	 * Removing the file offset range causes extent count to
+	 * increase by 1.
+	 */
+	error = xfs_trans_resv_ext_cnt(ip, XFS_DATA_FORK, 1);
+	if (error)
+		goto out_trans_cancel;
+
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
 	if (error)
 		goto out_trans_cancel;
@@ -1155,6 +1168,14 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	/*
+	 * Splitting the extent mapping containing stop_fsb will cause
+	 * extent count to increase by 1.
+	 */
+	error = xfs_trans_resv_ext_cnt(ip, XFS_DATA_FORK, 1);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * The extent shifting code works on extent granularity. So, if stop_fsb
 	 * is not the starting block of extent, we need to split the extent at
@@ -1356,6 +1377,25 @@ xfs_swap_extent_rmap(
 		/* Unmap the old blocks in the source file. */
 		while (tirec.br_blockcount) {
 			ASSERT(tp->t_firstblock == NULLFSBLOCK);
+
+			/*
+			 * Removing an initial part of source file's extent and
+			 * adding a new extent (from donor file) in its place
+			 * will cause extent count to increase by 1.
+			 */
+			error = xfs_trans_resv_ext_cnt(ip, XFS_DATA_FORK, 1);
+			if (error)
+				goto out;
+
+			/*
+			 * Removing an initial part of donor file's extent and
+			 * adding a new extent (from source file) in its place
+			 * will cause extent count to increase by 1.
+			 */
+			error = xfs_trans_resv_ext_cnt(tip, XFS_DATA_FORK, 1);
+			if (error)
+				goto out;
+
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
 
 			/* Read extent from the source file */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 04dc2be19c3a..582f050595bc 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -290,8 +290,13 @@ xfs_dquot_disk_alloc(
 		return -ESRCH;
 	}
 
-	/* Create the block mapping. */
 	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
+
+	error = xfs_trans_resv_ext_cnt(quotip, XFS_DATA_FORK, 1);
+	if (error)
+		return error;
+
+	/* Create the block mapping. */
 	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
 			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
 			&nmaps);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 407d6299606d..007a719c2cdf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1175,6 +1175,24 @@ xfs_create(
 	if (error)
 		goto out_trans_cancel;
 
+	/*
+	 * Directory entry addition can cause the following,
+	 * 1. Data block can be added.
+	 *    A new extent can cause extent count to increase by 1.
+	 * 2. Free disk block can be added.
+	 *    Same behaviour as described above for Data block.
+	 * 3. Dabtree blocks.
+	 *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
+	 *    can be new extents. Hence extent count can increase by
+	 *    XFS_DA_NODE_MAXDEPTH.
+	 * Total = XFS_DA_NODE_MAXDEPTH + 1 + 1;
+	 */
+	error = xfs_trans_resv_ext_cnt(dp, XFS_DATA_FORK,
+			(XFS_DA_NODE_MAXDEPTH + 1 + 1) *
+			mp->m_dir_geo->fsbcount);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * A newly created regular or special file just has one directory
 	 * entry pointing to them, but a directory also the "." entry
@@ -1391,6 +1409,24 @@ xfs_link(
 	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
 
+	/*
+	 * Creating a new link can cause the following,
+	 * 1. Data block can be added.
+	 *    A new extent can cause extent count to increase by 1.
+	 * 2. Free disk block can be added.
+	 *    Same behaviour as described above for Data block.
+	 * 3. Dabtree blocks.
+	 *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
+	 *    can be new extents. Hence extent count can increase by
+	 *    XFS_DA_NODE_MAXDEPTH.
+	 * Total = XFS_DA_NODE_MAXDEPTH + 1 + 1;
+	 */
+	error = xfs_trans_resv_ext_cnt(tdp, XFS_DATA_FORK,
+			(XFS_DA_NODE_MAXDEPTH + 1 + 1) *
+				mp->m_dir_geo->fsbcount);
+	if (error)
+		goto error_return;
+
 	/*
 	 * If we are using project inheritance, we only allow hard link
 	 * creation in our tree when the project IDs are the same; else
@@ -2861,6 +2897,26 @@ xfs_remove(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
+	/*
+	 * Directory entry removal can cause the following,
+	 * 1. Data block can be freed.
+	 *    3 data blocks can be contiguous. Deletion of a single
+	 *    data block can cause this single extent to be split into
+	 *    two. Hence extent count can increase by 1.
+	 * 2. Free disk block
+	 *    Same behaviour as described above for Data block.
+	 * 3. Dabtree blocks.
+	 *    XFS_DA_NODE_MAXDEPTH blocks can be freed. Each of these
+	 *    blocks can cause a single extent to be split into two.
+	 *    Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
+	 * Total = XFS_DA_NODE_MAXDEPTH + 1 + 1;
+	 */
+	error = xfs_trans_resv_ext_cnt(dp, XFS_DATA_FORK,
+			(XFS_DA_NODE_MAXDEPTH + 1 + 1) *
+				mp->m_dir_geo->fsbcount);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * If we're removing a directory perform some additional validation.
 	 */
@@ -3221,6 +3277,46 @@ xfs_rename(
 	if (wip)
 		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
 
+	/*
+	 * Directory entry removal can cause the following,
+	 * 1. Data block can be freed.
+	 *    3 data blocks can be contiguous. Deletion of a single
+	 *    data block can cause this single extent to be split into
+	 *    two. Hence extent count can increase by 1.
+	 * 2. Free disk block
+	 *    Same behaviour as described above for Data block.
+	 * 3. Dabtree blocks.
+	 *    XFS_DA_NODE_MAXDEPTH blocks can be freed. Each of these
+	 *    blocks can cause a single extent to be split into two.
+	 *    Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
+	 * Total = XFS_DA_NODE_MAXDEPTH + 1 + 1;
+	 */
+	error = xfs_trans_resv_ext_cnt(src_dp, XFS_DATA_FORK,
+			(XFS_DA_NODE_MAXDEPTH + 1 + 1) *
+				mp->m_dir_geo->fsbcount);
+	if (error)
+		goto out_trans_cancel;
+
+	/*
+	 * Directory entry addition can cause the following,
+	 * 1. Data block can be added.
+	 *    A new extent can cause extent count to increase by 1.
+	 * 2. Free disk block can be added.
+	 *    Same behaviour as described above for Data block.
+	 * 3. Dabtree blocks.
+	 *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
+	 *    can be new extents. Hence extent count can increase by
+	 *    XFS_DA_NODE_MAXDEPTH.
+	 * Total = XFS_DA_NODE_MAXDEPTH + 1 + 1;
+	 */
+	if (target_ip == NULL) {
+		error = xfs_trans_resv_ext_cnt(target_dp, XFS_DATA_FORK,
+			(XFS_DA_NODE_MAXDEPTH + 1 + 1) *
+				mp->m_dir_geo->fsbcount);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If we are using project inheritance, we only allow renames
 	 * into our tree when the project IDs are the same; else the
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0e3f62cde375..e7ea3b7bbb0d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -250,6 +250,14 @@ xfs_iomap_write_direct(
 	if (error)
 		goto out_trans_cancel;
 
+	/*
+	 * Writing to a hole or extending a file can cause
+	 * the extent count to increase by 1.
+	 */
+	error = xfs_trans_resv_ext_cnt(ip, XFS_DATA_FORK, 1);
+	if (error)
+		goto out_trans_cancel;
+
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
@@ -561,6 +569,17 @@ xfs_iomap_write_unwritten(
 		if (error)
 			goto error_on_bmapi_transaction;
 
+		/*
+		 * We might be writing to the middle region of an
+		 * existing unwritten extent. This causes the original
+		 * extent to be split into 3 extents
+		 * i.e. | Unwritten | Real | Unwritten |
+		 * Hence extent count can increase by 2.
+		 */
+		error = xfs_trans_resv_ext_cnt(ip, XFS_DATA_FORK, 2);
+		if (error)
+			goto error_on_bmapi_transaction;
+
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index aac83f9d6107..45fa89558cdb 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -29,6 +29,7 @@
 #include "xfs_iomap.h"
 #include "xfs_sb.h"
 #include "xfs_ag_resv.h"
+#include "xfs_trans_resv.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -628,6 +629,17 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	/*
+	 * Extents are unmapped starting from "end_fsb - 1" and moves
+	 * towards offset_fsb.  A data fork extent containing
+	 * "end_fsb - 1" can be split into three parts i.e.
+	 * | Old extent | New extent | Old extent |
+	 * Hence number of extents increases by 2.
+	 */
+	error = xfs_trans_resv_ext_cnt(ip, XFS_DATA_FORK, 2);
+	if (error)
+		goto out_cancel;
+
 	/*
 	 * In case of racing, overlapping AIO writes no COW extents might be
 	 * left by the time I/O completes for the loser of the race.  In that
@@ -1002,6 +1014,7 @@ xfs_reflink_remap_extent(
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
 	int			nimaps;
+	int			resv_exts = 0;
 	int			error;
 
 	/* Start a rolling transaction to switch the mappings */
@@ -1094,6 +1107,28 @@ xfs_reflink_remap_extent(
 			goto out_cancel;
 	}
 
+	/*
+	 * When unmapping, an extent containing the entire unmap
+	 * range can be split into two extents,
+	 * i.e. | old extent | hole | old extent |
+	 * Hence extent count increases by 1.
+	 */
+	if (smap_real)
+		++resv_exts;
+
+	/*
+	 * Mapping in the new extent into the destination file can
+	 * increase the extent count by 1.
+	 */
+	if (dmap_written)
+		++resv_exts;
+
+	if (resv_exts) {
+		error = xfs_trans_resv_ext_cnt(ip, XFS_DATA_FORK, resv_exts);
+		if (error)
+			goto out_cancel;
+	}
+
 	if (smap_real) {
 		/*
 		 * If the extent we're unmapping is backed by storage (written
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6209e7b6b895..a2e640f43f1e 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -787,6 +787,10 @@ xfs_growfs_rt_alloc(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
+		error = xfs_trans_resv_ext_cnt(ip, XFS_DATA_FORK, 1);
+		if (error)
+			goto out_trans_cancel;
+
 		/*
 		 * Allocate blocks to the bitmap file.
 		 */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8e88a7ca387e..1bc71576289d 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -220,6 +220,24 @@ xfs_symlink(
 	if (error)
 		goto out_trans_cancel;
 
+	/*
+	 * Creating a new symlink can cause the following,
+	 * 1. Data block can be added.
+	 *    A new extent can cause extent count to increase by 1.
+	 * 2. Free disk block can be added.
+	 *    Same behaviour as described above for Data block.
+	 * 3. Dabtree blocks.
+	 *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
+	 *    can be new extents. Hence extent count can increase by
+	 *    XFS_DA_NODE_MAXDEPTH.
+	 * Total = XFS_DA_NODE_MAXDEPTH + 1 + 1;
+	 */
+	error = xfs_trans_resv_ext_cnt(dp, XFS_DATA_FORK,
+			(XFS_DA_NODE_MAXDEPTH + 1 + 1) *
+				mp->m_dir_geo->fsbcount);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-- 
2.20.1

