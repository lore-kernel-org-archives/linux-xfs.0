Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61543C5DF61
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 12:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 219AB21D6C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 12:08:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UY79Xf0A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfKGMIS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 07:08:18 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32792 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfKGMIS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 07:08:18 -0500
Received: by mail-pf1-f194.google.com with SMTP id c184so2616731pfb.0
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 04:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QTn/QbJoDkCWcd7OE/SOfWyF/lrIF/9S0QDdqz2gHQ8=;
        b=UY79Xf0Ae6EFJ+pcyFF7cEmLrwSrD9navpf7QRxp6GSXJKNpGq7ghIe+7dxSonO/ih
         6vJpWCeww4oohHro+qsmJHADAK9SJEP/wxa/LJYdj45yO8Gb/WIQDakSkh7iLizSsLxu
         I0ciiA5SNmMAmHaFIHXyTZUdiZj4B6XbLpGYWdaJ5UjQIWw5SrQfBjlOOJyS6/oo6Q7L
         +IoVDKX4mYimDPU5o8EsnCmGMfTp0r9jSs4lVqGdLleGRy0DH2IvptBtQtLekp8tDwm+
         7k07yq6WlNLga5zAUwO8EU4mlSJf5KFxNg/YiNkg58zrXu76OLGHKo8+f8+/AKCMNM3x
         e9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QTn/QbJoDkCWcd7OE/SOfWyF/lrIF/9S0QDdqz2gHQ8=;
        b=LqX/t+kaUkHfDn9UMmUnXl71EiAtIyMEO0DyHX9UWc8N0pTL+fKwMii0HulvnFWsZV
         oFE2Q/D61MkqrreY9x4+mz+ukRXwhWQ/qRa3JlLvuzC8VQjIz5/D/DzhinKkERVS850i
         o2Tr4u3+OgAuuPcsQ5mV8nrXgkIlQChvNuC8ZrMVvnrE+Q2p2eqXRCTqO3s5AfzFTTP9
         TVbofVh7iJV8J5mPjaIG/zpBxbKJuhTO2rYDHV/Q5+qfoBwIg1A46Iks7cINmf/O8zZK
         GdB3A8pRQfGgdXMH8RQycGrwhEKBVomUIMCXshYmuzLoyA5VWxgjazwfjcQL08sZSiUE
         q3sw==
X-Gm-Message-State: APjAAAV5kVPJLYWWq+1Hooau2cKRuyhbTu4cSZ0JRvA7o5c02LOBwoPL
        OW1+xDbOnMwbjUYHw6TWKULr0pw=
X-Google-Smtp-Source: APXvYqyFXaGY2c73ytdjXZ96QjxEF+UYOnei76TnlXmTq75otp3i/4P8c1J8nHm/oG3sMU6DLZXoEA==
X-Received: by 2002:a62:e219:: with SMTP id a25mr3532790pfi.252.1573128497366;
        Thu, 07 Nov 2019 04:08:17 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id u20sm2267469pgo.50.2019.11.07.04.08.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 04:08:16 -0800 (PST)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, bfoster@redhat.com, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: [PATCH v3] xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()
Date:   Thu,  7 Nov 2019 20:08:11 +0800
Message-Id: <1573128491-14996-1-git-send-email-kaixuxia@tencent.com>
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
Changes in v3:
 -Invoke xfs_dir2_sf_replace_needblock() call in xfs_inode.c
  directly.
 -Fix the typo.

 fs/xfs/libxfs/xfs_dir2.h    |  2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c | 21 +++++++++++++++++++++
 fs/xfs/xfs_inode.c          | 15 +++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f542447..d4a2b09 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
+extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
+				struct xfs_inode *src_ip);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 85f14fc..7098cdd 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -945,6 +945,27 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
 }
 
 /*
+ * Check whether the sf dir replace operation need more blocks.
+ */
+bool
+xfs_dir2_sf_replace_needblock(
+	struct xfs_inode	*dp,
+	struct xfs_inode	*src_ip)
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
+	return src_ip->i_ino > XFS_DIR2_MAX_SHORT_INUM &&
+	       sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp);
+}
+
+/*
  * Replace the inode number of an entry in a shortform directory.
  */
 int						/* error */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 18f4b26..cb0b93b 100644
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
@@ -3361,6 +3362,20 @@ struct xfs_iunlink {
 		 * In case there is already an entry with the same
 		 * name at the destination directory, remove it first.
 		 */
+
+		/*
+		 * Check whether the replace operation need more blocks.
+		 * If so, acquire the agi lock firstly to preserve locking
+		 * order (AGI/AGF). Only convert the shortform directory to
+		 * block form maybe need more blocks.
+		 */
+		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip)) {
+			error = xfs_read_agi(mp, tp,
+				XFS_INO_TO_AGNO(mp, target_ip->i_ino), &agibp);
+			if (error)
+				goto out_trans_cancel;
+		}
+
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, spaceres);
 		if (error)
-- 
1.8.3.1

