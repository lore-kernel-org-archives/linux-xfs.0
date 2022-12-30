Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DCA3C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236139AbiLaCCU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiLaCCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:02:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC39A2AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:02:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 893E461C99
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C35C433D2;
        Sat, 31 Dec 2022 02:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452138;
        bh=QaJrL2cmIQ2WOM9q2+cPjG9Xg218Vs8JTI7fxOmRSy8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ptnQqWum8eShm3WMoi/uNvg+MbdD5Euz1soO/FTAVvflHJa385q3hGBbZa2eZYEQ2
         IsZSWDKH9nuU0T3hFTmJYkfakf/4KhBjIdn/7EdVuHo8vX5Er8XqZ9DeQD9F4/FTeo
         tMtRUiu9BZJ8XDJG5jzLDrimYIbX8ktIuqoBH1qWwKp+tIxWkE3azNK9OSZFnLGMTQ
         5qqYM8JGwLDSksj928vXFp2CdZ1e8yU+4i5JeWZxs4DBLb1AvUTWqM2c7KzlCTygEU
         FNKIC5WEg9WUBmEywt/r8KXGdMPYU84tUkxveftKQKzmSN3c23QcCGvC+0cvmhOP3b
         mr2/pmWzVRiIQ==
Subject: [PATCH 1/4] xfs_repair: check free space requirements before allowing
 upgrades
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:09 -0800
Message-ID: <167243874992.722663.6667434379472157722.stgit@magnolia>
In-Reply-To: <167243874979.722663.18268822003736829003.stgit@magnolia>
References: <167243874979.722663.18268822003736829003.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, the V5 feature upgrades permitted by xfs_repair do not affect
filesystem space usage, so we haven't needed to verify the geometry.

However, this will change once we start to allow the sysadmin to add new
metadata indexes to existing filesystems.  Add all the infrastructure we
need to ensure that there's enough space for metadata space reservations
and per-AG reservations the next time the filesystem will be mounted.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
[david: Recompute transaction reservation values; Exit with error if upgrade fails]
Signed-off-by: Dave Chinner <david@fromorbit.com>
[djwong: Refuse to upgrade if any part of the fs has < 10% free]
---
 include/libxfs.h |    1 
 repair/phase2.c  |  134 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 135 insertions(+)


diff --git a/include/libxfs.h b/include/libxfs.h
index d4b5d8e564d..14f6d629c9f 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -80,6 +80,7 @@ struct iomap;
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_ag_resv.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/repair/phase2.c b/repair/phase2.c
index 2ada95aefd1..cdfc98bf39f 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -242,6 +242,137 @@ install_new_state(
 	libxfs_trans_init(mp);
 }
 
+#define GIGABYTES(count, blog)     ((uint64_t)(count) << (30 - (blog)))
+static inline bool
+check_free_space(
+	struct xfs_mount	*mp,
+	unsigned long long	avail,
+	unsigned long long	total)
+{
+	/* Ok if there's more than 10% free. */
+	if (avail >= total / 10)
+		return true;
+
+	/* Not ok if there's less than 5% free. */
+	if (avail < total / 5)
+		return false;
+
+	/* Let it slide if there's at least 10GB free. */
+	return avail > GIGABYTES(10, mp->m_sb.sb_blocklog);
+}
+
+static void
+check_fs_free_space(
+	struct xfs_mount		*mp,
+	const struct check_state	*old,
+	struct xfs_sb			*new_sb)
+{
+	struct xfs_perag		*pag;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	/* Make sure we have enough space for per-AG reservations. */
+	for_each_perag(mp, agno, pag) {
+		struct xfs_trans	*tp;
+		struct xfs_agf		*agf;
+		struct xfs_buf		*agi_bp, *agf_bp;
+		unsigned int		avail, agblocks;
+
+		/* Put back the old super so that we can read AG headers. */
+		restore_old_state(mp, old);
+
+		/*
+		 * Create a dummy transaction so that we can load the AGI and
+		 * AGF buffers in memory with the old fs geometry and pin them
+		 * there while we try to make a per-AG reservation with the new
+		 * geometry.
+		 */
+		error = -libxfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			do_error(
+	_("Cannot reserve resources for upgrade check, err=%d.\n"),
+					error);
+
+		error = -libxfs_ialloc_read_agi(pag, tp, &agi_bp);
+		if (error)
+			do_error(
+	_("Cannot read AGI %u for upgrade check, err=%d.\n"),
+					pag->pag_agno, error);
+
+		error = -libxfs_alloc_read_agf(pag, tp, 0, &agf_bp);
+		if (error)
+			do_error(
+	_("Cannot read AGF %u for upgrade check, err=%d.\n"),
+					pag->pag_agno, error);
+		agf = agf_bp->b_addr;
+		agblocks = be32_to_cpu(agf->agf_length);
+
+		/*
+		 * Install the new superblock and try to make a per-AG space
+		 * reservation with the new geometry.  We pinned the AG header
+		 * buffers to the transaction, so we shouldn't hit any
+		 * corruption errors on account of the new geometry.
+		 */
+		install_new_state(mp, new_sb);
+
+		error = -libxfs_ag_resv_init(pag, tp);
+		if (error == ENOSPC) {
+			printf(
+	_("Not enough free space would remain in AG %u for metadata.\n"),
+					pag->pag_agno);
+			exit(1);
+		}
+		if (error)
+			do_error(
+	_("Error %d while checking AG %u space reservation.\n"),
+					error, pag->pag_agno);
+
+		/*
+		 * Would the post-upgrade filesystem have enough free space in
+		 * this AG after making per-AG reservations?
+		 */
+		avail = pag->pagf_freeblks + pag->pagf_flcount;
+		avail -= pag->pag_meta_resv.ar_reserved;
+		avail -= pag->pag_rmapbt_resv.ar_asked;
+
+		if (!check_free_space(mp, avail, agblocks)) {
+			printf(
+	_("AG %u will be low on space after upgrade.\n"),
+					pag->pag_agno);
+			exit(1);
+		}
+		libxfs_trans_cancel(tp);
+	}
+
+	/*
+	 * Would the post-upgrade filesystem have enough free space on the data
+	 * device after making per-AG reservations?
+	 */
+	if (!check_free_space(mp, mp->m_sb.sb_fdblocks, mp->m_sb.sb_dblocks)) {
+		printf(_("Filesystem will be low on space after upgrade.\n"));
+		exit(1);
+	}
+
+	/*
+	 * Release the per-AG reservations and mark the per-AG structure as
+	 * uninitialized so that we don't trip over stale cached counters
+	 * after the upgrade/
+	 */
+	for_each_perag(mp, agno, pag) {
+		libxfs_ag_resv_free(pag);
+		pag->pagf_init = 0;
+		pag->pagi_init = 0;
+	}
+}
+
+static bool
+need_check_fs_free_space(
+	struct xfs_mount		*mp,
+	const struct check_state	*old)
+{
+	return false;
+}
+
 /*
  * Make sure we can actually upgrade this (v5) filesystem without running afoul
  * of root inode or log size requirements that would prevent us from mounting
@@ -284,6 +415,9 @@ install_new_geometry(
 		exit(1);
 	}
 
+	if (need_check_fs_free_space(mp, &old))
+		check_fs_free_space(mp, &old, new_sb);
+
 	/*
 	 * Restore the old state to get everything back to a clean state,
 	 * upgrade the featureset one more time, and recompute the btree max

