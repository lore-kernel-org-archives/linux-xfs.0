Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BC4CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 09:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF8B2208C0
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 09:49:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KDwFRngd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfJ3Jtm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 05:49:42 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36116 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfJ3Jtm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 05:49:42 -0400
Received: by mail-pf1-f194.google.com with SMTP id v19so1225790pfm.3
        for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2019 02:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HCItthn03Z3vmBJC93PvYDkwDCU5aJyasi/lj2MFG0c=;
        b=KDwFRngd9HaDrHAAAo/O1Ds6y3x74SVkgbQvesqTY7PYMvZv3cru1dtyKPRFwEbeGk
         9Tcdrey2A+1nuZ2wboT9PnJT5n+Ws6d6sBTvRAJCXjGSJsD4jJ5gjN0z+4CM0EpdZv/a
         mINjd/HMCSObLRVw5k0bfTf0Zy4+I2X51NQxuNUtKIMBPwe7dNNeyANwqdbj/31CDF2g
         R2VpyqZtFOJTjoKTmCd8mP6hxCvUuPg7Y60LaD9M49yvOEdzVthy4cdWx5lPD+IfnlIr
         rUeSTqYpN4uOsitbxrdifZ6riJpnWTfI89NRj5jPUMmLDKXqv2rA0Jw55lUuR/D0iPzs
         rjtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HCItthn03Z3vmBJC93PvYDkwDCU5aJyasi/lj2MFG0c=;
        b=qSarEEKAPJ+iwFiYb53hUb5MoUqigxpOgp5iu4f1VEk5mFryycM9Cm84OJc12IpPj0
         Y3nYs5NyowqLDsz/NgoGxOH+sVMAjZaGiQ7AvBrBMX50NhnyotLCjloGCmLKbpWewIsU
         5BQFdtdOCEay8DCkeWBlbqMY4mJ6XxKf5KpePS5ckRBn+IDIOtEifJnQvQR5rj9SEqFV
         +nYhTmjRxxsZwPaKrJEOIDcdOvly61B/S+d/wUG5irCoUFbIeCkuqwQVTrI4H8B0qxui
         ne7MquIpF9fb7w9S0H9ieYZw0QlNJPYmXEu19P26njasRMtvsBT0CuaJsmgzB2+45a7K
         uZjg==
X-Gm-Message-State: APjAAAXC/X+4CE0r4FRQKc/sWnkiCK9ZEZMfbJnr2SdrsErfypvksbsZ
        ySPx3gPuqYju+uZFBI7VsJtZz/4=
X-Google-Smtp-Source: APXvYqy9zdJoXwg83Jxm3HEQ0W8kILeVtv7PRtrWWCKlhQdD5HxSnCFn5z6zCD0eKWb/Z92GE3gwhQ==
X-Received: by 2002:a63:5d10:: with SMTP id r16mr112635pgb.41.1572428980840;
        Wed, 30 Oct 2019 02:49:40 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id bb15sm1680741pjb.22.2019.10.30.02.49.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 02:49:40 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: [PATCH RFC] xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()
Date:   Wed, 30 Oct 2019 17:49:34 +0800
Message-Id: <1572428974-8657-1-git-send-email-kaixuxia@tencent.com>
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
 fs/xfs/libxfs/xfs_dir2.c | 30 ++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |  2 ++
 fs/xfs/xfs_inode.c       | 14 ++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 867c5de..9d9ae16 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -463,6 +463,36 @@
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
+	int			newsize;
+	xfs_dir2_sf_hdr_t	*sfp;
+
+	/*
+	 * Only convert the shortform directory to block form maybe need
+	 * more blocks.
+	 */
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

