Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC80ECAAD3
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Sep 2022 09:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiIIJ5p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiIIJ5Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Sep 2022 05:57:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DF812897C
        for <linux-xfs@vger.kernel.org>; Fri,  9 Sep 2022 02:57:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2047F61F78
        for <linux-xfs@vger.kernel.org>; Fri,  9 Sep 2022 09:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED86CC433D6;
        Fri,  9 Sep 2022 09:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662717432;
        bh=ltjBU5cA765XvoJb4CkEqgX+uARUcqn4FE2C3RIyyFA=;
        h=From:To:Cc:Subject:Date:From;
        b=vObyOi/+onUGOIfBNCKM2mSgzzLYXLkoium+VJVY3MKIVyArHhulIhbImgfGYJmnC
         lY9cft1ZU2I/pxc2mIYg/5y8825nUgoYWVCWW/fclZR2iRQxnrXMlHYlLawjZ6rhhO
         OcPcRgC84BBRrppkx1e3OMd/W1D+yEgxzqP/uQaZdT1V5gHnAYSzaCFs8tHUxcMx+Y
         bbMrEmrfBkR9dKYhvTHNImfGuqkjMyCVI6bH/9oSXz9g3Z+afziYtxXuS34Dvk+zXJ
         cHAbDEtWQUUePxW//ljgtscNmYomCerdKgpS3BGQYTyakNt8d1s9DZt5EWwllOQLxF
         SNt6XdPAYQRVg==
From:   Christian Brauner <brauner@kernel.org>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Seth Forshee <sforshee@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: port to vfs{g,u}id_t and associated helpers
Date:   Fri,  9 Sep 2022 11:56:59 +0200
Message-Id: <20220909095659.944062-1-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3450; i=brauner@kernel.org; h=from:subject; bh=ltjBU5cA765XvoJb4CkEqgX+uARUcqn4FE2C3RIyyFA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSRL8z6Y9OxHFdtyMdWg/OUf3v5bWx9juPdh3dH8xCbpjJxL 0oECHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN58oyR4fBfi4XFEWXnJgf4xGi+Un g/+X+nhW7RfE6jM6kvQ1scGBj+1zsuUbyXfPuq5TQmn57PGtUbL7PWtPUXXPg2+7na/l3nuAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A while ago we introduced a dedicated vfs{g,u}id_t type in commit
1e5267cd0895 ("mnt_idmapping: add vfs{g,u}id_t"). We already switched
over a good part of the VFS. Ultimately we will remove all legacy
idmapped mount helpers that operate only on k{g,u}id_t in favor of the
new type safe helpers that operate on vfs{g,u}id_t.

Cc: Dave Chinner <dchinner@redhat.com>
Cc: Seth Forshee (Digital Ocean) <sforshee@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/xfs/xfs_inode.c  | 5 ++---
 fs/xfs/xfs_iops.c   | 6 ++++--
 fs/xfs/xfs_itable.c | 8 ++++++--
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 28493c8e9bb2..bca204a5aecf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -835,9 +835,8 @@ xfs_init_new_inode(
 	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
 	 * (and only if the irix_sgid_inherit compatibility variable is set).
 	 */
-	if (irix_sgid_inherit &&
-	    (inode->i_mode & S_ISGID) &&
-	    !in_group_p(i_gid_into_mnt(mnt_userns, inode)))
+	if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
+	    !vfsgid_in_group_p(i_gid_into_vfsgid(mnt_userns, inode)))
 		inode->i_mode &= ~S_ISGID;
 
 	ip->i_disk_size = 0;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 45518b8c613c..5d670c85dcc2 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -558,6 +558,8 @@ xfs_vn_getattr(
 	struct inode		*inode = d_inode(path->dentry);
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
+	vfsuid_t		vfsuid = i_uid_into_vfsuid(mnt_userns, inode);
+	vfsgid_t		vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
 
 	trace_xfs_getattr(ip);
 
@@ -568,8 +570,8 @@ xfs_vn_getattr(
 	stat->dev = inode->i_sb->s_dev;
 	stat->mode = inode->i_mode;
 	stat->nlink = inode->i_nlink;
-	stat->uid = i_uid_into_mnt(mnt_userns, inode);
-	stat->gid = i_gid_into_mnt(mnt_userns, inode);
+	stat->uid = vfsuid_into_kuid(vfsuid);
+	stat->gid = vfsgid_into_kgid(vfsgid);
 	stat->ino = ip->i_ino;
 	stat->atime = inode->i_atime;
 	stat->mtime = inode->i_mtime;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 36312b00b164..a1c2bcf65d37 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -66,6 +66,8 @@ xfs_bulkstat_one_int(
 	struct xfs_bulkstat	*buf = bc->buf;
 	xfs_extnum_t		nextents;
 	int			error = -EINVAL;
+	vfsuid_t		vfsuid;
+	vfsgid_t		vfsgid;
 
 	if (xfs_internal_inum(mp, ino))
 		goto out_advance;
@@ -81,14 +83,16 @@ xfs_bulkstat_one_int(
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_imap.im_blkno != 0);
 	inode = VFS_I(ip);
+	vfsuid = i_uid_into_vfsuid(mnt_userns, inode);
+	vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
 
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */
 	buf->bs_projectid = ip->i_projid;
 	buf->bs_ino = ino;
-	buf->bs_uid = from_kuid(sb_userns, i_uid_into_mnt(mnt_userns, inode));
-	buf->bs_gid = from_kgid(sb_userns, i_gid_into_mnt(mnt_userns, inode));
+	buf->bs_uid = from_kuid(sb_userns, vfsuid_into_kuid(vfsuid));
+	buf->bs_gid = from_kgid(sb_userns, vfsgid_into_kgid(vfsgid));
 	buf->bs_size = ip->i_disk_size;
 
 	buf->bs_nlink = inode->i_nlink;

base-commit: 7e18e42e4b280c85b76967a9106a13ca61c16179
-- 
2.34.1

