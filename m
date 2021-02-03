Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D30C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDA9E64F60
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhBCTo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:44:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhBCTo2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 14:44:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 300F564F51;
        Wed,  3 Feb 2021 19:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612381421;
        bh=p8b7C+D3zczSGZOluNSRspCGp037HNZ5gg3AFLtrnOs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ftXZj5LEU5XCcaNOo1oHwDj6MRrZrESMEN04B1bGNdGEaHILVJ3tOWHtZ1x8e30/e
         4wmUXiWdNnyckQ4ODLY84eDh2zxhWNck05sH7Up8UKmlAiF5Rm39FXyxJb/loFsBbr
         i1wvcUIpg2FuwgK1n94HG7WYSwCNKY1J9lfNHL3R89h5bM721Y8FDRojVWTiK/PCvK
         Sdp+2zkOWVpV+lXfvVHjVf/tFo3VqpFNlIUX9CE+T/HP0ImW4w1L8fxEkBi3YH8mE+
         LV34dilMIWitbGYZDco7uf0DMPTBqdTT7KznfgvlDpURVOoo7L3qXx9TekSS5nAdBd
         YSr9HxB+YkY3A==
Subject: [PATCH 5/5] xfs_repair: clear the needsrepair flag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 03 Feb 2021 11:43:40 -0800
Message-ID: <161238142078.1278306.10769412408846256451.stgit@magnolia>
In-Reply-To: <161238139177.1278306.5915396345874239435.stgit@magnolia>
References: <161238139177.1278306.5915396345874239435.stgit@magnolia>
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
---
 include/xfs_mount.h |    1 +
 libxfs/init.c       |   12 ++++++++----
 repair/agheader.c   |   21 +++++++++++++++++++++
 repair/xfs_repair.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+), 4 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 36594643..77574045 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -181,6 +181,7 @@ xfs_perag_resv(
 
 extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
 				dev_t, dev_t, dev_t, int);
+int libxfs_flush_mount(struct xfs_mount *mp, bool purge);
 int		libxfs_umount(struct xfs_mount *mp);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 9fe13b8d..99b1f72a 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -870,9 +870,10 @@ _("%s: Flushing the %s failed, err=%d!\n"),
  * Flush all dirty buffers to stable storage and report on writes that didn't
  * make it to stable storage.
  */
-static int
+int
 libxfs_flush_mount(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	bool			purge)
 {
 	int			error = 0;
 	int			err2;
@@ -884,7 +885,10 @@ libxfs_flush_mount(
 	 * cannot be written will cause the LOST_WRITE flag to be set in the
 	 * buftarg.
 	 */
-	libxfs_bcache_purge();
+	if (purge)
+		libxfs_bcache_purge();
+	else
+		libxfs_bcache_flush();
 
 	/* Flush all kernel and disk write caches, and report failures. */
 	if (mp->m_ddev_targp) {
@@ -923,7 +927,7 @@ libxfs_umount(
 
 	libxfs_rtmount_destroy(mp);
 
-	error = libxfs_flush_mount(mp);
+	error = libxfs_flush_mount(mp, true);
 
 	for (agno = 0; agno < mp->m_maxagi; agno++) {
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
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
index 9409f0d8..4ca4fe5a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -712,6 +712,52 @@ check_fs_vs_host_sectsize(
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
+	 * that everything is ok with the ondisk filesystem.  At this point
+	 * we've flushed the filesystem metadata out of the buffer cache and
+	 * possibly rewrote the log, but we haven't forced the disks to persist
+	 * the writes to stable storage.  Do that now, and if anything goes
+	 * wrong, leave NEEDSREPAIR in place.  Don't purge the buffer cache
+	 * here since we're not done yet.
+	 */
+	error = -libxfs_flush_mount(mp, false);
+	if (error) {
+		do_warn(
+	_("Cannot clear needsrepair from primary super due to metadata checkpoint failure, err=%d.\n"),
+			error);
+		return;
+	}
+
+	/* Clear needsrepair from the superblock. */
+	bp = libxfs_getsb(mp);
+	if (!bp) {
+		do_warn(
+	_("Cannot clear needsrepair from primary super, out of memory.\n"));
+		return;
+	}
+	if (bp->b_error) {
+		do_warn(
+	_("Cannot clear needsrepair from primary super, IO err=%d.\n"),
+			bp->b_error);
+	} else {
+		mp->m_sb.sb_features_incompat &=
+				~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+		libxfs_buf_mark_dirty(bp);
+	}
+	libxfs_buf_relse(bp);
+	return;
+}
+
 int
 main(int argc, char **argv)
 {
@@ -1132,6 +1178,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	libxfs_bcache_flush();
 	format_log_max_lsn(mp);
 
+	if (xfs_sb_version_needsrepair(&mp->m_sb))
+		clear_needsrepair(mp);
+
 	/* Report failure if anything failed to get written to our fs. */
 	error = -libxfs_umount(mp);
 	if (error)

