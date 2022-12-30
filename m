Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E69DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbiLaDXH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236379AbiLaDW7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:22:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CD912A91
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:22:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26A4161D66
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8047EC433EF;
        Sat, 31 Dec 2022 03:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456977;
        bh=vLc+GxpPbpk24+X4SakA0dNbcvVmem6Wbki191LYqKo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=esgB8vS00t67D8RbnYhCS5350GEanPUnizIhF2v0aCtYcPTF79cz8YAiofJzTTbwf
         FyGIqyFW7tE0/YIFkP99zqGqYWZ+QpKBYQk9IF8IAENuiIZslPA0ECbpr8jbpdAkMi
         F5TM0HcxBqfAWSSNgd+ViP12YGnmKMtlkFD5/lKFUJtFkqA3W7XGoB8pI021AqxM/g
         e5jlMQJ73lbCOi0rA3OFyU7KI++lGEkF4HH3Lsszg+qUWRpWLDFw6vy9fAiwYLqu13
         T58hvdPkbn2XhveN1N/UmVThj9YlzF+youM/QxCtxRSxBV5xa4IuERoTUdIGqhC/nx
         LH5slGppJFSkQ==
Subject: [PATCH 2/3] xfs: don't free EOF blocks on read close
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:20 -0800
Message-ID: <167243876052.726374.3477350707567259751.stgit@magnolia>
In-Reply-To: <167243876021.726374.15071907725836376245.stgit@magnolia>
References: <167243876021.726374.15071907725836376245.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we have a workload that does open/read/close in parallel with other
allocation, the file becomes rapidly fragmented. This is due to close()
calling xfs_release() and removing the speculative preallocation beyond
EOF.

The existing open/*/close heuristic in xfs_release() does not catch this
as a sync writer does not leave delayed allocation blocks allocated on
the inode for later writeback that can be detected in xfs_release() and
hence XFS_IDIRTY_RELEASE never gets set.

In xfs_file_release(), we know more about the released file context, and
so we need to communicate some of the details to xfs_release() so it can
do the right thing here and skip EOF block truncation. This defers the
EOF block cleanup for synchronous write contexts to the background EOF
block cleaner which will clean up within a few minutes.

Before:

Test 1: sync write fragmentation counts

/mnt/scratch/file.0: 919
/mnt/scratch/file.1: 916
/mnt/scratch/file.2: 919
/mnt/scratch/file.3: 920
/mnt/scratch/file.4: 920
/mnt/scratch/file.5: 921
/mnt/scratch/file.6: 916
/mnt/scratch/file.7: 918

After:

Test 1: sync write fragmentation counts

/mnt/scratch/file.0: 24
/mnt/scratch/file.1: 24
/mnt/scratch/file.2: 11
/mnt/scratch/file.3: 24
/mnt/scratch/file.4: 3
/mnt/scratch/file.5: 24
/mnt/scratch/file.6: 24
/mnt/scratch/file.7: 23

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick: wordsmithing, fix commit message]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |   14 ++++++++++++--
 fs/xfs/xfs_inode.c |    9 +++++----
 fs/xfs/xfs_inode.h |    2 +-
 3 files changed, 18 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e172ca1b18df..87e836e1aeb3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1381,12 +1381,22 @@ xfs_dir_open(
 	return error;
 }
 
+/*
+ * When we release the file, we don't want it to trim EOF blocks if it is a
+ * readonly context.  This avoids open/read/close workloads from removing
+ * EOF blocks that other writers depend upon to reduce fragmentation.
+ */
 STATIC int
 xfs_file_release(
 	struct inode	*inode,
-	struct file	*filp)
+	struct file	*file)
 {
-	return xfs_release(XFS_I(inode));
+	bool		free_eof_blocks = true;
+
+	if ((file->f_mode & (FMODE_WRITE | FMODE_READ)) == FMODE_READ)
+		free_eof_blocks = false;
+
+	return xfs_release(XFS_I(inode), free_eof_blocks);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f0e44c96b769..763f07867325 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1311,10 +1311,11 @@ xfs_itruncate_extents_flags(
 
 int
 xfs_release(
-	xfs_inode_t	*ip)
+	struct xfs_inode	*ip,
+	bool			want_free_eofblocks)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	int		error = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error = 0;
 
 	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
 		return 0;
@@ -1356,7 +1357,7 @@ xfs_release(
 	 * another chance to drop them once the last reference to the inode is
 	 * dropped, so we'll never leak blocks permanently.
 	 */
-	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
+	if (!want_free_eofblocks || !xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
 		return 0;
 
 	if (xfs_can_free_eofblocks(ip, false)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 32a1d114dfaf..4ab0a63da367 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -493,7 +493,7 @@ enum layout_break_reason {
 #define XFS_INHERIT_GID(pip)	\
 	(xfs_has_grpid((pip)->i_mount) || (VFS_I(pip)->i_mode & S_ISGID))
 
-int		xfs_release(struct xfs_inode *ip);
+int		xfs_release(struct xfs_inode *ip, bool can_free_eofblocks);
 void		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, const struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);

