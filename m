Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2550DC43381
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E631764EC8
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhBIERZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:17:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230313AbhBIENr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:13:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1DA964EC3;
        Tue,  9 Feb 2021 04:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843838;
        bh=AwAzJCERb3Y7dbFUNVbtIH+XXe+qJ2iDTTeFTrB7g5E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nWjdgJ9x8kwX/p51De4DThOec6SBcSQLrwDVuIv767cNqt49b5DUUS2BIXxen+pv2
         pf95VpJRxb9DafY76Yk2GT+gLx7tlzWJ6MNfFFjV6hzwB77kGJAJETlD7EC3i0HK+b
         pXH6O2NuGDcjNgBJxpKdoKPWMLpQcYYBBS+CMFHYTM8e7Onz1gN3Qj0LyxW2iixaOM
         GO5mBa9IA9VPco2lveqJw7+WaHdo2Mkp9BHWmx0vxmtg8k8H1k9mIXzZakfErt5l1N
         HgXbHxCf0DONXDkIMMLaxyy25Xc3DjeBDSCn83k6XY7ocZn4jAxX0WmM4+p8Mp52HV
         23GMFXgLYFPjA==
Subject: [PATCH 06/10] xfs_repair: clear the needsrepair flag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:10:38 -0800
Message-ID: <161284383828.3057868.1762356472271947821.stgit@magnolia>
In-Reply-To: <161284380403.3057868.11153586180065627226.stgit@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
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
 libxfs/init.c       |   25 +++++++++++++------------
 repair/agheader.c   |   21 +++++++++++++++++++++
 repair/xfs_repair.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 80 insertions(+), 12 deletions(-)


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
index 9fe13b8d..98057b78 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -867,25 +867,17 @@ _("%s: Flushing the %s failed, err=%d!\n"),
 }
 
 /*
- * Flush all dirty buffers to stable storage and report on writes that didn't
- * make it to stable storage.
+ * Persist all disk write caches and report on writes that didn't make it to
+ * stable storage.  Callers should flush (or purge) the libxfs buffer caches
+ * before calling this function.
  */
-static int
+int
 libxfs_flush_mount(
 	struct xfs_mount	*mp)
 {
 	int			error = 0;
 	int			err2;
 
-	/*
-	 * Purge the buffer cache to write all dirty buffers to disk and free
-	 * all incore buffers.  Buffers that fail write verification will cause
-	 * the CORRUPT_WRITE flag to be set in the buftarg.  Buffers that
-	 * cannot be written will cause the LOST_WRITE flag to be set in the
-	 * buftarg.
-	 */
-	libxfs_bcache_purge();
-
 	/* Flush all kernel and disk write caches, and report failures. */
 	if (mp->m_ddev_targp) {
 		err2 = libxfs_flush_buftarg(mp->m_ddev_targp, _("data device"));
@@ -923,6 +915,15 @@ libxfs_umount(
 
 	libxfs_rtmount_destroy(mp);
 
+	/*
+	 * Purge the buffer cache to write all dirty buffers to disk and free
+	 * all incore buffers.  Buffers that fail write verification will cause
+	 * the CORRUPT_WRITE flag to be set in the buftarg.  Buffers that
+	 * cannot be written will cause the LOST_WRITE flag to be set in the
+	 * buftarg.  Once that's done, instruct the disks to persist their
+	 * write caches.
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
index 32755821..f607afcb 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -712,6 +712,48 @@ check_fs_vs_host_sectsize(
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
+	libxfs_bcache_flush();
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
@@ -1131,6 +1173,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	libxfs_bcache_flush();
 	format_log_max_lsn(mp);
 
+	if (xfs_sb_version_needsrepair(&mp->m_sb))
+		clear_needsrepair(mp);
+
 	/* Report failure if anything failed to get written to our fs. */
 	error = -libxfs_umount(mp);
 	if (error)

