Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A8CC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 11:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E5292084E
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 11:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p8b8gjLr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfKLLNj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 06:13:39 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40460 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfKLLNi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 06:13:38 -0500
Received: by mail-pg1-f194.google.com with SMTP id 15so11622806pgt.7
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2019 03:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zWNSQcCFmuSOKDvATRK9v7sUJmCdp0M5XvTIycyYjdM=;
        b=p8b8gjLrp42Uwp4TXCL564zC4zpfoHBsXLiTWTMLHVLOqZK8CPwy2URbEAAhk69uQ7
         t1VBGPmbbZE7VwMOO3OGTNoJp3cH3msd3nrgeBaE/HV9pCdXXDL15t8o3kYyzTrTF1P9
         ly96cS0pXRTPbtDR6fgvU2FXIrR+gKstBnS7/3WEIhJdOlfgWWpd7vPDcWYwn33bRbI3
         yjtr0IDZv7xiv30U6S1DcwrtecVkaBjXJvGBZhA+DzWAznqeL8hpTMYrjIWdXFfG2iLq
         aSt/h9HbWXVTiBXAasc4FUpW+Ekn7aBIUgglwmW4/BJUyR/grM+Ih4Wd+9Nk7PyZ2egq
         EVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zWNSQcCFmuSOKDvATRK9v7sUJmCdp0M5XvTIycyYjdM=;
        b=hzSMXtmT8tu58Lqy0pc6vlJfS3RpwmuE8PqqmgN7254Ym0sEY5REKt+8SR6tUDb87C
         D5LMsR+v5Y5wihB3S7szoZi9+Cb8G178cHvNp+hWrbhs/NnswfxDAZUZ+g+XkjEqoW9O
         IKj3ktOK9YIakjdyQyAtQhh3YjcFxRr70zZ1LyKBeypYqj+vMAdAIxylwQumKufjKpVt
         DRDg3h/EIDe5G799UlKjGgig5RLAu5ce+Fp73OLafZfgccq8TCqInIoX95TliyXxseky
         qpwBYBhueFUG8alJtsO9/zimmscOOmdCs5fjTASYfdpJn6GO5zzapGw63GgiyXlv1raN
         muKA==
X-Gm-Message-State: APjAAAXvNu5DKBzRnSjG8zJ4Ms6UNkWDpEOmWgDJyomA5dyFVJip8bvi
        SJKO01DVvLwOcsFbjt8iMMjzIPo=
X-Google-Smtp-Source: APXvYqyIm+ABGubqJKWAKwzVHdIZ/Vh0dMb3cNKL7b8fd9AaITNIEEIGaXHfFuLza8dR4b+DZQu1VQ==
X-Received: by 2002:a63:535a:: with SMTP id t26mr35265941pgl.215.1573557217456;
        Tue, 12 Nov 2019 03:13:37 -0800 (PST)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id x25sm17920856pfq.73.2019.11.12.03.13.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 03:13:36 -0800 (PST)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, bfoster@redhat.com, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: [PATCH v4] xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()
Date:   Tue, 12 Nov 2019 19:13:30 +0800
Message-Id: <1573557210-6241-1-git-send-email-kaixuxia@tencent.com>
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
Changes in v4:
 -Remove the typedef usages.
 -Invoke xfs_dir2_sf_replace_needblock() in
  xfs_dir2_sf_replace() directly.

 fs/xfs/libxfs/xfs_dir2.h    |  2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c | 28 +++++++++++++++++++++++-----
 fs/xfs/xfs_inode.c          | 15 +++++++++++++++
 3 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f542447..01b1722 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
+extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
+				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 85f14fc..0e112e1 100644
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
+	xfs_ino_t		inum)
+{
+	int			newsize;
+	struct xfs_dir2_sf_hdr	*sfp;
+
+	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+		return false;
+
+	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
+	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
+
+	return inum > XFS_DIR2_MAX_SHORT_INUM &&
+	       sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp);
+}
+
+/*
  * Replace the inode number of an entry in a shortform directory.
  */
 int						/* error */
@@ -980,17 +1001,14 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
 	 */
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->i8count == 0) {
 		int	error;			/* error return value */
-		int	newsize;		/* new inode size */
 
-		newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
 		/*
 		 * Won't fit as shortform, convert to block then do replace.
 		 */
-		if (newsize > XFS_IFORK_DSIZE(dp)) {
+		if (xfs_dir2_sf_replace_needblock(dp, args->inumber)) {
 			error = xfs_dir2_sf_to_block(args);
-			if (error) {
+			if (error)
 				return error;
-			}
 			return xfs_dir2_block_replace(args);
 		}
 		/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 18f4b26..5dc3796 100644
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
+		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
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

