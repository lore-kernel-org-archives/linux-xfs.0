Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B76CE79A4
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjIYV6Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIYV6Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:58:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CDE112
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:58:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F43C433C8;
        Mon, 25 Sep 2023 21:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679098;
        bh=cwWgxKiaLTAupHSqmb01sFQh3r+f/v4Q+ZxRQvgOCYA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=azg+6oMV1LE5yfGDpG2tMQ++ihioXg5AGBABaZCL8SqL1jonO3i8nnH0V8Mg35ulB
         RPWoDB8wIwIEIhORXH69ifCoikKsc2H5i2uKA+Z5LBLXo9yRrpJ17UzMQC0cweb4VD
         ur0Gg+1+lZ21lfeEu7gvCXQwP9TaIR6VsPo514BchlrfhL3Ra31WX0OZTVcxW8KWN7
         zoexJQqz5ciaIgbWLjcvXIhBa9fehfUtuIMVOIN+tcLDe3zgwKtNge/yznNBfaIY0s
         Zj5fa9bA3CwMq1xUAVlDDwF1ipE0xBGWaAR31ueq0ylAgoLFKdYoMR0jX40olMwvhX
         6eQtByj8NsnBg==
Subject: [PATCH 1/5] xfs: convert to ctime accessor functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:58:18 -0700
Message-ID: <169567909810.2318286.5030096286410299417.stgit@frogsfrogsfrogs>
In-Reply-To: <169567909240.2318286.10628058261852886648.stgit@frogsfrogsfrogs>
References: <169567909240.2318286.10628058261852886648.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Source kernel commit: a0a415e34b57368acd262e1172720252c028b936

In later patches, we're going to change how the inode's ctime field is
used. Switch to using accessor functions instead of raw accesses of
inode->i_ctime.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-Id: <20230705190309.579783-80-jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 include/xfs_inode.h      |   22 +++++++++++++++++++++-
 libxfs/xfs_inode_buf.c   |    5 +++--
 libxfs/xfs_trans_inode.c |    2 +-
 3 files changed, 25 insertions(+), 4 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 069fcf362ec..39b1bee8444 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -43,7 +43,7 @@ struct inode {
 	uint64_t		i_version;
 	struct timespec64	i_atime;
 	struct timespec64	i_mtime;
-	struct timespec64	i_ctime;
+	struct timespec64	__i_ctime; /* use inode_*_ctime accessors! */
 	spinlock_t		i_lock;
 };
 
@@ -69,6 +69,26 @@ static inline void ihold(struct inode *inode)
 	inode->i_count++;
 }
 
+/* Userspace does not support multigrain timestamps incore. */
+#define I_CTIME_QUERIED		(0)
+
+static inline struct timespec64 inode_get_ctime(const struct inode *inode)
+{
+	struct timespec64 ctime;
+
+	ctime.tv_sec = inode->__i_ctime.tv_sec;
+	ctime.tv_nsec = inode->__i_ctime.tv_nsec & ~I_CTIME_QUERIED;
+
+	return ctime;
+}
+
+static inline struct timespec64 inode_set_ctime_to_ts(struct inode *inode,
+						      struct timespec64 ts)
+{
+	inode->__i_ctime = ts;
+	return ts;
+}
+
 typedef struct xfs_inode {
 	struct cache_node	i_node;
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index cbcaadbcf69..fccab419354 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -219,7 +219,8 @@ xfs_inode_from_disk(
 	 */
 	inode->i_atime = xfs_inode_from_disk_ts(from, from->di_atime);
 	inode->i_mtime = xfs_inode_from_disk_ts(from, from->di_mtime);
-	inode->i_ctime = xfs_inode_from_disk_ts(from, from->di_ctime);
+	inode_set_ctime_to_ts(inode,
+			      xfs_inode_from_disk_ts(from, from->di_ctime));
 
 	ip->i_disk_size = be64_to_cpu(from->di_size);
 	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
@@ -313,7 +314,7 @@ xfs_inode_to_disk(
 
 	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
 	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
-	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
+	to->di_ctime = xfs_inode_to_disk_ts(ip, inode_get_ctime(inode));
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
 	to->di_gen = cpu_to_be32(inode->i_generation);
 	to->di_mode = cpu_to_be16(inode->i_mode);
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index c4f81e5d12a..ca8e823762c 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -64,7 +64,7 @@ xfs_trans_ichgtime(
 	if (flags & XFS_ICHGTIME_MOD)
 		inode->i_mtime = tv;
 	if (flags & XFS_ICHGTIME_CHG)
-		inode->i_ctime = tv;
+		inode_set_ctime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CREATE)
 		ip->i_crtime = tv;
 }

