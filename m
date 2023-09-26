Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14E7E7F14A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjI0AUD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbjI0ASC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:18:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E650D5243
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:39:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B2CC433C7;
        Tue, 26 Sep 2023 23:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771569;
        bh=Vj74v1rdOPZWX6SytJ61ukQyZ18q0V5YO/YqyFl/1+4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qmdnKqP1BBFvqyCmZ4blopdMm/7MwJAsq8rvOjegXIL7wzEkLiX1vI6r6wM44qfuc
         o+UNuRV/WCyPr7ZbJqWwdaC59bfp/efOgxJ+sO9IaKYsB9GCDwXs4T4OCRg7WzmimM
         M+LPaVzoweqKUq7HfxX9bH7ylecKOXwjHLH3KtqPO/wMqdZdEFkDU4PQy3THa2rHIM
         rybkRH1oGiAXTCLJrjlRj3S17QRjgNUtQP/FOmhq4zJck8cL/IMX9qTX6uEFNkQ3Ps
         Qkz6zx8ZEycawG019UVWpRrNXTBVeqbqVFgQekBdVRyRs5+/pYwQN9iukQ1FptyfRQ
         v3mEiV0nETybw==
Date:   Tue, 26 Sep 2023 16:39:29 -0700
Subject: [PATCH 1/5] xfs: check the ondisk space mapping behind a dquot
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577061592.3315644.4664727550665513734.stgit@frogsfrogsfrogs>
In-Reply-To: <169577061571.3315644.2567541587400012629.stgit@frogsfrogsfrogs>
References: <169577061571.3315644.2567541587400012629.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Each xfs_dquot object caches the file offset and daddr of the ondisk
block that backs the dquot.  Make sure these cached values are the same
as the bmapi data, and that the block state is written.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quota.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 5671c81534335..59350cd7a325b 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -6,6 +6,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_bit.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
@@ -75,6 +76,47 @@ struct xchk_quota_info {
 	xfs_dqid_t		last_id;
 };
 
+/* There's a written block backing this dquot, right? */
+STATIC int
+xchk_quota_item_bmap(
+	struct xfs_scrub	*sc,
+	struct xfs_dquot	*dq,
+	xfs_fileoff_t		offset)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_mount	*mp = sc->mp;
+	int			nmaps = 1;
+	int			error;
+
+	if (!xfs_verify_fileoff(mp, offset)) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		return 0;
+	}
+
+	if (dq->q_fileoffset != offset) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		return 0;
+	}
+
+	error = xfs_bmapi_read(sc->ip, offset, 1, &irec, &nmaps, 0);
+	if (error)
+		return error;
+
+	if (nmaps != 1) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		return 0;
+	}
+
+	if (!xfs_verify_fsbno(mp, irec.br_startblock))
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+	if (XFS_FSB_TO_DADDR(mp, irec.br_startblock) != dq->q_blkno)
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+	if (!xfs_bmap_is_written_extent(&irec))
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+
+	return 0;
+}
+
 /* Scrub the fields in an individual quota item. */
 STATIC int
 xchk_quota_item(
@@ -93,6 +135,17 @@ xchk_quota_item(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
+	/*
+	 * We want to validate the bmap record for the storage backing this
+	 * dquot, so we need to lock the dquot and the quota file.  For quota
+	 * operations, the locking order is first the ILOCK and then the dquot.
+	 * However, dqiterate gave us a locked dquot, so drop the dquot lock to
+	 * get the ILOCK.
+	 */
+	xfs_dqunlock(dq);
+	xchk_ilock(sc, XFS_ILOCK_SHARED);
+	xfs_dqlock(dq);
+
 	/*
 	 * Except for the root dquot, the actual dquot we got must either have
 	 * the same or higher id as we saw before.
@@ -103,6 +156,11 @@ xchk_quota_item(
 
 	sqi->last_id = dq->q_id;
 
+	error = xchk_quota_item_bmap(sc, dq, offset);
+	xchk_iunlock(sc, XFS_ILOCK_SHARED);
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, offset, &error))
+		return error;
+
 	/*
 	 * Warn if the hard limits are larger than the fs.
 	 * Administrators can do this, though in production this seems

