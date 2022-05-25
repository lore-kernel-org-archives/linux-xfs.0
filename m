Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB390C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 11:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiEYLRn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 07:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiEYLRm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 07:17:42 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FFFBF57;
        Wed, 25 May 2022 04:17:40 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id s28so29517665wrb.7;
        Wed, 25 May 2022 04:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JLC0ja767iUSkq7vhFyAS50rOOoNLE8fxflV1RxjsDw=;
        b=B+8Uuiwetwr3EOaHPsTSCuyBeUtYD3wotxWuLsZ/8+ouP/h7TN1hOBCFUI94i8Y2ds
         Axl10hnC52K54iu3cuDniX7s3r2m82CfSFemaB3+r71i8RO+u5Yki0iwRbmNPK/qJMga
         5PkhP5tJukVPGeelnyl5Se+lwISg/hmCxKQH+kmtV3kArjiI51As8Gd7g51uTSNkRB+O
         WP5pDCjYwEXJsJ09/d8Zircnz7kSr5LpOQahAVOuVtUauj7BSOGeiFfsP2rXADzlg8Hn
         waHBBj1XeqkMxwnxU1ReLyUKV33NW+o0MKOGE96U9IEsX/jh6DX1Eg3q8Ydxr0khkzko
         GqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JLC0ja767iUSkq7vhFyAS50rOOoNLE8fxflV1RxjsDw=;
        b=I4lgmPzxjrRRvjzODQ+uinrTd7tDPp2FllL5SIlk0kovrf2VxSPeSyNhiZ+6a8gsS7
         dX/Kjiz1oUgbOU/Kec881jP4uTVIxoJNMW9Ws/P5hEbOhE6FG7ZFPse6UGNM0HQrem1y
         ghij8E7bDcJvI4qSYG2sPJeg5/RFiI6EUQ2Y6gCsayD5/CehP+ilIPu4IxO7y9Q+/1p4
         5EmuH2wfzC2PwvRbF6dYqKEsn/UQ09eazQSrwkYzw5O8VkM/hghh3BTMLfodRMk6Txrs
         MbG8dM4RkNKWVX8VjDUI0EFQau1oMV0PSZ559CAzsET2wGCjEXxCmEYcBGWi0Cr6D642
         jKMw==
X-Gm-Message-State: AOAM531YUUq9DY+ug8Jh4zBJrnSRXTWEJkRhSuAcf81gesPyW9gJBfLK
        GQBfcKXjukRrWo9NNRD1U32pFM8d2xjBJA==
X-Google-Smtp-Source: ABdhPJyRsykgXShW1kfR8nTS4vulfeVnDHcE4JVzPJOnlSdvecXYC0KCPSKqL7CBMDcxapjIkwehZA==
X-Received: by 2002:adf:f582:0:b0:210:f0:24ac with SMTP id f2-20020adff582000000b0021000f024acmr1647830wro.444.1653477459408;
        Wed, 25 May 2022 04:17:39 -0700 (PDT)
Received: from localhost.localdomain ([5.29.19.200])
        by smtp.gmail.com with ESMTPSA id e12-20020a056000178c00b0020c5253d8besm2059904wrg.10.2022.05.25.04.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 04:17:38 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, wenli xie <wlxie7296@gmail.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATH 5.10 4/4] xfs: fix an ABBA deadlock in xfs_rename
Date:   Wed, 25 May 2022 14:17:15 +0300
Message-Id: <20220525111715.2769700-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220525111715.2769700-1-amir73il@gmail.com>
References: <20220525111715.2769700-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 6da1b4b1ab36d80a3994fd4811c8381de10af604 upstream.

When overlayfs is running on top of xfs and the user unlinks a file in
the overlay, overlayfs will create a whiteout inode and ask xfs to
"rename" the whiteout file atop the one being unlinked.  If the file
being unlinked loses its one nlink, we then have to put the inode on the
unlinked list.

This requires us to grab the AGI buffer of the whiteout inode to take it
off the unlinked list (which is where whiteouts are created) and to grab
the AGI buffer of the file being deleted.  If the whiteout was created
in a higher numbered AG than the file being deleted, we'll lock the AGIs
in the wrong order and deadlock.

Therefore, grab all the AGI locks we think we'll need ahead of time, and
in order of increasing AG number per the locking rules.

Reported-by: wenli xie <wlxie7296@gmail.com>
Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_dir2.h    |  2 --
 fs/xfs/libxfs/xfs_dir2_sf.c |  2 +-
 fs/xfs/xfs_inode.c          | 42 ++++++++++++++++++++++---------------
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index e55378640b05..d03e6098ded9 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -47,8 +47,6 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
-extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
-				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 2463b5d73447..8c4f76bba88b 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1018,7 +1018,7 @@ xfs_dir2_sf_removename(
 /*
  * Check whether the sf dir replace operation need more blocks.
  */
-bool
+static bool
 xfs_dir2_sf_replace_needblock(
 	struct xfs_inode	*dp,
 	xfs_ino_t		inum)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2bfbcf28b1bd..e958b1c74561 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3152,7 +3152,7 @@ xfs_rename(
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	struct xfs_buf		*agibp;
+	int			i;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
@@ -3265,6 +3265,30 @@ xfs_rename(
 		}
 	}
 
+	/*
+	 * Lock the AGI buffers we need to handle bumping the nlink of the
+	 * whiteout inode off the unlinked list and to handle dropping the
+	 * nlink of the target inode.  Per locking order rules, do this in
+	 * increasing AG order and before directory block allocation tries to
+	 * grab AGFs because we grab AGIs before AGFs.
+	 *
+	 * The (vfs) caller must ensure that if src is a directory then
+	 * target_ip is either null or an empty directory.
+	 */
+	for (i = 0; i < num_inodes && inodes[i] != NULL; i++) {
+		if (inodes[i] == wip ||
+		    (inodes[i] == target_ip &&
+		     (VFS_I(target_ip)->i_nlink == 1 || src_is_directory))) {
+			struct xfs_buf	*bp;
+			xfs_agnumber_t	agno;
+
+			agno = XFS_INO_TO_AGNO(mp, inodes[i]->i_ino);
+			error = xfs_read_agi(mp, tp, agno, &bp);
+			if (error)
+				goto out_trans_cancel;
+		}
+	}
+
 	/*
 	 * Directory entry creation below may acquire the AGF. Remove
 	 * the whiteout from the unlinked list first to preserve correct
@@ -3317,22 +3341,6 @@ xfs_rename(
 		 * In case there is already an entry with the same
 		 * name at the destination directory, remove it first.
 		 */
-
-		/*
-		 * Check whether the replace operation will need to allocate
-		 * blocks.  This happens when the shortform directory lacks
-		 * space and we have to convert it to a block format directory.
-		 * When more blocks are necessary, we must lock the AGI first
-		 * to preserve locking order (AGI -> AGF).
-		 */
-		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
-			error = xfs_read_agi(mp, tp,
-					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
-					&agibp);
-			if (error)
-				goto out_trans_cancel;
-		}
-
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, spaceres);
 		if (error)
-- 
2.25.1

