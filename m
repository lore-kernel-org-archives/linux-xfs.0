Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB34C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05D9B64E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhBWDBp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:01:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231268AbhBWDBl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:01:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09B2664E61;
        Tue, 23 Feb 2021 03:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049259;
        bh=l9byE+vEpHyQMhdKtt31hUHYUkLVaiiecx4uzQGv0iA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EJgHD7MNN8IRKNgUdEHjqZc7dTvIZwgR/0PGi0mKmeOet13erb40EVeiwCwx8RDrc
         pl/Q4eSx4Kqm2gyYFLrXxLxrQODx/r3edaR/O85tycVN+kdtP6BXPb1nwEFtfC5DrG
         G4pqBsyKz/+SpY+FIwHCydFD4Mcn6L3dIShBx5LgBXPfvqGcB+p+J+HOIwREYsOCfW
         catm5cEjO+5moiHGMw0EcioVLXbn4jmLISpz0eroX4AnUGDMnEVRDtNkFB5HpaJp0f
         RwxQUO8mvGwvyOUEvbwKK2QW09lcY/HVHuGsFyubYWUYXQtVs44JbQjQfedRVx2pk7
         /2PICXzzX+dFA==
Subject: [PATCH 7/7] xfs_repair: clear the needsrepair flag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:00:58 -0800
Message-ID: <161404925861.425352.15560707043185552680.stgit@magnolia>
In-Reply-To: <161404921827.425352.18151735716678009691.stgit@magnolia>
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clear the needsrepair flag, since it's used to prevent mounting of an
inconsistent filesystem.  We only do this if we make it to the end of
repair with a non-zero error code, and all the rebuilt indices and
corrected metadata are persisted correctly.

Note that we cannot combine clearing needsrepair with clearing the quota
checked flags because we need to clear the quota flags even if
reformatting the log fails, whereas we can't clear needsrepair if the
log reformat fails.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 include/xfs_mount.h |    1 +
 libxfs/init.c       |   20 +++++++++++++-------
 repair/agheader.c   |   21 +++++++++++++++++++++
 repair/xfs_repair.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 7 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 36594643..75230ca5 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -181,6 +181,7 @@ xfs_perag_resv(
 
 extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
 				dev_t, dev_t, dev_t, int);
+int libxfs_flush_mount(struct xfs_mount *mp);
 int		libxfs_umount(struct xfs_mount *mp);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 9fe13b8d..8a8ce3c4 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -870,7 +870,7 @@ _("%s: Flushing the %s failed, err=%d!\n"),
  * Flush all dirty buffers to stable storage and report on writes that didn't
  * make it to stable storage.
  */
-static int
+int
 libxfs_flush_mount(
 	struct xfs_mount	*mp)
 {
@@ -878,13 +878,13 @@ libxfs_flush_mount(
 	int			err2;
 
 	/*
-	 * Purge the buffer cache to write all dirty buffers to disk and free
-	 * all incore buffers.  Buffers that fail write verification will cause
-	 * the CORRUPT_WRITE flag to be set in the buftarg.  Buffers that
-	 * cannot be written will cause the LOST_WRITE flag to be set in the
-	 * buftarg.
+	 * Flush the buffer cache to write all dirty buffers to disk.  Buffers
+	 * that fail write verification will cause the CORRUPT_WRITE flag to be
+	 * set in the buftarg.  Buffers that cannot be written will cause the
+	 * LOST_WRITE flag to be set in the buftarg.  Once that's done,
+	 * instruct the disks to persist their write caches.
 	 */
-	libxfs_bcache_purge();
+	libxfs_bcache_flush();
 
 	/* Flush all kernel and disk write caches, and report failures. */
 	if (mp->m_ddev_targp) {
@@ -923,6 +923,12 @@ libxfs_umount(
 
 	libxfs_rtmount_destroy(mp);
 
+	/*
+	 * Purge the buffer cache to write all dirty buffers to disk and free
+	 * all incore buffers, then pick up the outcome when we tell the disks
+	 * to persist their write caches.
+	 */
+	libxfs_bcache_purge();
 	error = libxfs_flush_mount(mp);
 
 	for (agno = 0; agno < mp->m_maxagi; agno++) {
diff --git a/repair/agheader.c b/repair/agheader.c
index 8bb99489..2af24106 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -452,6 +452,27 @@ secondary_sb_whack(
 			rval |= XR_AG_SB_SEC;
 	}
 
+	if (xfs_sb_version_needsrepair(sb)) {
+		if (i == 0) {
+			if (!no_modify)
+				do_warn(
+	_("clearing needsrepair flag and regenerating metadata\n"));
+			else
+				do_warn(
+	_("would clear needsrepair flag and regenerate metadata\n"));
+		} else {
+			/*
+			 * Quietly clear needsrepair on the secondary supers as
+			 * part of ensuring them.  If needsrepair is set on the
+			 * primary, it will be cleared at the end of repair
+			 * once we've flushed all other dirty blocks to disk.
+			 */
+			sb->sb_features_incompat &=
+					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+			rval |= XR_AG_SB_SEC;
+		}
+	}
+
 	return(rval);
 }
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 40352458..e2e99b21 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -712,6 +712,45 @@ check_fs_vs_host_sectsize(
 	}
 }
 
+/* Clear needsrepair after a successful repair run. */
+void
+clear_needsrepair(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	/*
+	 * If we're going to clear NEEDSREPAIR, we need to make absolutely sure
+	 * that everything is ok with the ondisk filesystem.  Make sure any
+	 * dirty buffers are sent to disk and that the disks have persisted
+	 * writes to stable storage.  If that fails, leave NEEDSREPAIR in
+	 * place.
+	 */
+	error = -libxfs_flush_mount(mp);
+	if (error) {
+		do_warn(
+	_("Cannot clear needsrepair due to flush failure, err=%d.\n"),
+			error);
+		return;
+	}
+
+	/* Clear needsrepair from the superblock. */
+	bp = libxfs_getsb(mp);
+	if (!bp || bp->b_error) {
+		do_warn(
+	_("Cannot clear needsrepair from primary super, err=%d.\n"),
+			bp ? bp->b_error : ENOMEM);
+	} else {
+		mp->m_sb.sb_features_incompat &=
+				~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+		libxfs_buf_mark_dirty(bp);
+	}
+	if (bp)
+		libxfs_buf_relse(bp);
+}
+
 int
 main(int argc, char **argv)
 {
@@ -1128,6 +1167,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	libxfs_bcache_flush();
 	format_log_max_lsn(mp);
 
+	if (xfs_sb_version_needsrepair(&mp->m_sb))
+		clear_needsrepair(mp);
+
 	/* Report failure if anything failed to get written to our fs. */
 	error = -libxfs_umount(mp);
 	if (error)

