Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D86C433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8A8864EAC
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBMFrc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:47:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:57422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhBMFrc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:47:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0103E64E74;
        Sat, 13 Feb 2021 05:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613195211;
        bh=OYiyP837CurqJRYs6FuBJ0Qxl69t2MG/Zj2AokbBU4k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Rks8S6BCK3XGAH25d7ATK9hCN55pg3aXONjvlYtfBcC7eFcshorR+tp3OwaJA2Wzl
         GUZyOLSHqRtIbECLsknzBhWs+gOKiZqRS/dBho75XFZ8e0eEt+dbeoTdJLQx+Et6Ki
         QIRT4NpaFp2qQcC0md4OHchgVl12Oy33VLFJoN7h9/PMlEkIRbYRi+vIOm88vWELn4
         nW8/qBGvv9+5v/ex9zl/v4cBk6afn5XnM1PD6gndglggtKg4DCWRlY3NQqftkyM+0Q
         UxXCr15SAgjm9CSkI9bPc4euKCtMLhHjrRgAVRDhBqaPGatufDfxQFP/mthvyGuKs4
         HXfBj9pRsdAgA==
Subject: [PATCH 1/3] xfs_repair: set NEEDSREPAIR the first time we write to a
 filesystem
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Fri, 12 Feb 2021 21:46:50 -0800
Message-ID: <161319521070.422860.2540813932323979688.stgit@magnolia>
In-Reply-To: <161319520460.422860.10568013013578673175.stgit@magnolia>
References: <161319520460.422860.10568013013578673175.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a hook to the buffer cache so that xfs_repair can intercept the
first write to a V5 filesystem to set the NEEDSREPAIR flag.  In the
event that xfs_repair dirties the filesystem and goes down, this ensures
that the sysadmin will have to re-start repair before mounting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h |    4 ++
 libxfs/rdwr.c       |    4 ++
 repair/xfs_repair.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 103 insertions(+)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 75230ca5..f93a9f11 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -11,6 +11,8 @@ struct xfs_inode;
 struct xfs_buftarg;
 struct xfs_da_geometry;
 
+typedef void (*buf_writeback_fn)(struct xfs_buf *bp);
+
 /*
  * Define a user-level mount structure with all we need
  * in order to make use of the numerous XFS_* macros.
@@ -95,6 +97,8 @@ typedef struct xfs_mount {
 		int	qi_dqperchunk;
 	}			*m_quotainfo;
 
+	buf_writeback_fn	m_buf_writeback_fn;
+
 	/*
 	 * xlog is defined in libxlog and thus is not intialized by libxfs. This
 	 * allows an application to initialize and store a reference to the log
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index ac783ce3..ca272387 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -812,6 +812,10 @@ libxfs_bwrite(
 		return bp->b_error;
 	}
 
+	/* Trigger the writeback hook if there is one. */
+	if (bp->b_mount->m_buf_writeback_fn)
+		bp->b_mount->m_buf_writeback_fn(bp);
+
 	/*
 	 * clear any pre-existing error status on the buffer. This can occur if
 	 * the buffer is corrupt on disk and the repair process doesn't clear
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 90d1a95a..12e319ae 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -720,6 +720,8 @@ clear_needsrepair(
 	struct xfs_buf		*bp;
 	int			error;
 
+	mp->m_buf_writeback_fn = NULL;
+
 	/*
 	 * If we're going to clear NEEDSREPAIR, we need to make absolutely sure
 	 * that everything is ok with the ondisk filesystem.  Make sure any
@@ -751,6 +753,95 @@ clear_needsrepair(
 		libxfs_buf_relse(bp);
 }
 
+static void
+update_sb_crc_only(
+	struct xfs_buf		*bp)
+{
+	xfs_buf_update_cksum(bp, XFS_SB_CRC_OFF);
+}
+
+/* Forcibly write the primary superblock with the NEEDSREPAIR flag set. */
+static void
+force_needsrepair(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf_ops	fake_ops;
+	struct xfs_buf		*bp;
+	int			error;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
+	    xfs_sb_version_needsrepair(&mp->m_sb))
+		return;
+
+	bp = libxfs_getsb(mp);
+	if (!bp || bp->b_error) {
+		do_log(
+	_("couldn't get superblock to set needsrepair, err=%d\n"),
+				bp ? bp->b_error : ENOMEM);
+		return;
+	} else {
+		/*
+		 * It's possible that we need to set NEEDSREPAIR before we've
+		 * had a chance to fix the summary counters in the primary sb.
+		 * With the exception of those counters, phase 1 already
+		 * ensured that the geometry makes sense.
+		 *
+		 * Bad summary counters in the primary super can cause the
+		 * write verifier to fail, so substitute a dummy that only sets
+		 * the CRC.  In the event of a crash, NEEDSREPAIR will prevent
+		 * the kernel from mounting our potentially damaged filesystem
+		 * until repair is run again, so it's ok to bypass the usual
+		 * verification in this one case.
+		 */
+		fake_ops = xfs_sb_buf_ops; /* struct copy */
+		fake_ops.verify_write = update_sb_crc_only;
+
+		mp->m_sb.sb_features_incompat |=
+				XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+
+		/* Force the primary super to disk immediately. */
+		bp->b_ops = &fake_ops;
+		error = -libxfs_bwrite(bp);
+		bp->b_ops = &xfs_sb_buf_ops;
+		if (error)
+			do_log(_("couldn't force needsrepair, err=%d\n"), error);
+	}
+	if (bp)
+		libxfs_buf_relse(bp);
+}
+
+/* Intercept the first write to the filesystem so we can set NEEDSREPAIR. */
+static void
+repair_capture_writeback(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	static pthread_mutex_t	wb_mutex = PTHREAD_MUTEX_INITIALIZER;
+
+	/* Higher level code modifying a superblock must set NEEDSREPAIR. */
+	if (bp->b_ops == &xfs_sb_buf_ops || bp->b_bn == XFS_SB_DADDR)
+		return;
+
+	pthread_mutex_lock(&wb_mutex);
+
+	/*
+	 * If someone else already dropped the hook, then needsrepair has
+	 * already been set on the filesystem and we can unlock.
+	 */
+	if (mp->m_buf_writeback_fn != repair_capture_writeback)
+		goto unlock;
+
+	/*
+	 * If we get here, the buffer being written is not a superblock, and
+	 * needsrepair needs to be set.
+	 */
+	force_needsrepair(mp);
+	mp->m_buf_writeback_fn = NULL;
+unlock:
+	pthread_mutex_unlock(&wb_mutex);
+}
+
 int
 main(int argc, char **argv)
 {
@@ -847,6 +938,10 @@ main(int argc, char **argv)
 	if (verbose > 2)
 		mp->m_flags |= LIBXFS_MOUNT_WANT_CORRUPTED;
 
+	/* Capture the first writeback so that we can set needsrepair. */
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		mp->m_buf_writeback_fn = repair_capture_writeback;
+
 	/*
 	 * set XFS-independent status vars from the mount/sb structure
 	 */

