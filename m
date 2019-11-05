Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F13C49EAD
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 09:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5537120869
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 09:52:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVwItkj2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbfKEJwT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 04:52:19 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38351 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730571AbfKEJwS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 04:52:18 -0500
Received: by mail-pg1-f195.google.com with SMTP id 15so533817pgh.5
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 01:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=V8OBTtUWTzGOCSpYH08rjc8MjO5PZRdCvlOtkGaKeag=;
        b=jVwItkj2FYVSF7Ra6jz6Kueih/lNhXhGM7GNDIDfpM3rCXUHdaPdUX3jHyaDbpYSoa
         nRD1vekhWXLXwMWHmWvW2yVWzcr18wLY7N1+ytQ+QsrC/FCH8+v4KNUswYsStpH1OAGn
         JeWqwk3Kwq22Rq8lU14wNRn7Un1UaFJZb/CCfJOt9WL+oCRumviCdVootpOLnVd/6Ufu
         tfnQhLrxL42ME/U8pESY58ZLM3X3cXAXn/9fWjyc3DvkZHH9iodXwKOOY3yz8I4HMu34
         dV/DxktDSG+N76JP3GP7ZfQ2aq6EIswJ8zXBoGQ9sHPxECSMjyot/XpB2NttTgdwBHdD
         xy0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V8OBTtUWTzGOCSpYH08rjc8MjO5PZRdCvlOtkGaKeag=;
        b=KmdFQ4Nl0jweYBGxCBDYgLsyy11QcQ+wqcXV3dzBcjlk+5fZ6WFddMjnnE5hORUsql
         cp5bV7s5OyzNdu/36wGTdNp7jvVqpa9V+rEmdVcQs6iTUjCL4iM7MXijJ910cRcFJC23
         DHSfPspJ6AK9NffjWuDwHVHuz0qOK7qXhDnZRFOp4fpL163cS+wzBEzz3FeP8lTZxFHW
         pRx1ejs5kP66DwxDSwFTq6XNlkQ0tCzLeKba3mWqJoRdhhfMFPZ8YNCU3fp5YZpgcQlA
         fOBGKsBUVrV+io+TH7EfU1fPp7Mj7nJ7iKTv9LdGsXSVqaxACgzfgrVDtLaK76A50Nkq
         TnJw==
X-Gm-Message-State: APjAAAWjVuKCnu/F3TCh+RdcYvLZagXXXf3XkcWk4UlHnmrFayHQSSpM
        mxymDsHKMykAPrPYsvIICbZn+VbESw==
X-Google-Smtp-Source: APXvYqxVDQBd6XyjHdyoW0uAcoiuUFEEICoUy9Zqfn0u2MvlTErrYItqqegDHJv3/8auaOhAV9iE3Q==
X-Received: by 2002:a63:801:: with SMTP id 1mr35552599pgi.58.1572947537307;
        Tue, 05 Nov 2019 01:52:17 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id e1sm17561439pgv.82.2019.11.05.01.52.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 01:52:16 -0800 (PST)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, bfoster@redhat.com, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: [PATCH v2] xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()
Date:   Tue,  5 Nov 2019 17:52:12 +0800
Message-Id: <1572947532-4972-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When target_ip exists in xfs_rename(), the xfs_dir_replace() call may
need to hold the AGF lock to allocate more blocks, and then invoking
the xfs_droplink() call to hold AGI lock to drop target_ip onto the
unlinked list, so we get the lock order AGF->AGI. This would break the
ordering constraint on AGI and AGF locking - inode allocation locks
the AGI, then can allocate a new extent for new inodes, locking the
AGF after the AGI.

In this patch we check whether the replace operation need more
blocks firstly. If so, acquire the agi lock firstly to preserve
locking order(AGI/AGF). Actually, the locking order problem only
occurs when we are locking the AGI/AGF of the same AG. For multiple
AGs the AGI lock will be released after the transaction committed.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
Changes in v2:
 - Add xfs_dir2_sf_replace_needblock() helper in
   xfs_dir2_sf.c.

 fs/xfs/libxfs/xfs_dir2.c      | 23 +++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h      |  2 ++
 fs/xfs/libxfs/xfs_dir2_priv.h |  2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c   | 24 ++++++++++++++++++++++++
 fs/xfs/xfs_inode.c            | 14 ++++++++++++++
 5 files changed, 65 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 867c5de..1917990 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -463,6 +463,29 @@
 }
 
 /*
+ * Check whether the replace operation need more blocks. Ignore
+ * the parameters check since the real replace() call below will
+ * do that.
+ */
+bool
+xfs_dir_replace_needblock(
+	struct xfs_inode	*dp,
+	xfs_ino_t		inum)
+{
+	int			rval;
+
+	rval = xfs_dir_ino_validate(dp->i_mount, inum);
+	if (rval)
+		return false;
+
+	/*
+	 * Only convert the shortform directory to block form maybe
+	 * need more blocks.
+	 */
+	return xfs_dir2_sf_replace_needblock(dp, inum);
+}
+
+/*
  * Replace the inode number of a directory entry.
  */
 int
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f542447..e436c14 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
+extern bool xfs_dir_replace_needblock(struct xfs_inode *dp,
+				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 59f9fb2..002103f 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -116,6 +116,8 @@ extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
 extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
 extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
+extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
+		xfs_ino_t inum);
 extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
 extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 85f14fc..0906f91 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -945,6 +945,30 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
 }
 
 /*
+ * Check whether the replace operation need more blocks.
+ */
+bool
+xfs_dir2_sf_replace_needblock(
+	struct xfs_inode	*dp,
+	xfs_ino_t		inum)
+{
+	int			newsize;
+	xfs_dir2_sf_hdr_t	*sfp;
+
+	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+		return false;
+
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
+
+	if (inum > XFS_DIR2_MAX_SHORT_INUM &&
+	    sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp))
+		return true;
+	else
+		return false;
+}
+
+/*
  * Replace the inode number of an entry in a shortform directory.
  */
 int						/* error */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 18f4b26..c239070 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3196,6 +3196,7 @@ struct xfs_iunlink {
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
+	struct xfs_buf		*agibp;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
@@ -3361,6 +3362,19 @@ struct xfs_iunlink {
 		 * In case there is already an entry with the same
 		 * name at the destination directory, remove it first.
 		 */
+
+		/*
+		 * Check whether the replace operation need more blocks.
+		 * If so, acquire the agi lock firstly to preserve locking
+		 * order(AGI/AGF).
+		 */
+		if (xfs_dir_replace_needblock(target_dp, src_ip->i_ino)) {
+			error = xfs_read_agi(mp, tp,
+					XFS_INO_TO_AGNO(mp, target_ip->i_ino), &agibp);
+			if (error)
+				goto out_trans_cancel;
+		}
+
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, spaceres);
 		if (error)
-- 
1.8.3.1

