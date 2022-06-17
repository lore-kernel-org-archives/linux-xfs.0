Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DB0CCA480
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 10:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381743AbiFQKHo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 06:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381669AbiFQKHY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 06:07:24 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8B46A43D;
        Fri, 17 Jun 2022 03:07:06 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id m32-20020a05600c3b2000b0039756bb41f2so2138305wms.3;
        Fri, 17 Jun 2022 03:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+F6aTIXlSin5tx3PF0RUSLMxKLKa7f7bpvoyxuqglDY=;
        b=Y+Zd61v6ktTBXhWUVgV12t8pNlvHlYfwGz9eH2kZS7s66YkpVym6RrEISo/3SfJCG6
         XIjlSs4CQx21GfhrRhAJR6YMHSi6nyuyRucOc60xyD242QdoOuvJmPiiij9BBVPloHds
         iY0Z9A+a1n0DitsF9tusC8gjVHvIzELsLA70gZsOQCYFMhUSD6v9DTyzOtuX8Seyg4GA
         zk3DgJ1CyYGWBn37qFbma0BdIxP6Y7lraoROjxNl/mDt1s06IUfE6F92GYUG7oED6JxP
         1oJ210g5cS4L0uKSpVP6fXH5XZpyxZudBwEkBXcAPUy/bxIgkt7cgdDMX6q3gSMFJikR
         djFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+F6aTIXlSin5tx3PF0RUSLMxKLKa7f7bpvoyxuqglDY=;
        b=w/RfiICczQrailgO21KyQoAtCusg7rHVUzQNi7Lm4MQg3nvYvOTOAM1pOpFOOuEdYY
         4xXoRgZWsFCjlo6qfEzyGO08T6innhZlh6dbuKJZuzB0qH0nVF1mVshNg93ANQkrfFxS
         MsW8gKv3E+bZLUHZNtzg4Awj3T09jYqXGASAsUwyVxFbeEBYXzMVqV28CIHh/PzQPEyR
         5KS3MOkuY+CYCSUEyHP27irpUdkE/zemvq3XCgW5XQBjlpfrOJPog3YQbO6v+qy/aIKL
         rS1+79OHjmxoDpuYS2ScJjcOjHwAU14/uQgPITFZDUXbaNs8m8ttdKdo9gno3yU+hk5l
         hRhg==
X-Gm-Message-State: AOAM531S7mNHjRWHhhyyaFhk0BdT5+cBIqo3RkpKxoo+4t+twFEP20VQ
        oUBkNnHFJ+JRCsMtq2KCwUg=
X-Google-Smtp-Source: ABdhPJyCJKuxVWiduVnPGF4s7hzJEkNISVOvHq0ip+JFdNiwuQSNXJ0Ejm0J/7D8gaeOt+8IvkGWxg==
X-Received: by 2002:a7b:c1c1:0:b0:39c:58c4:c701 with SMTP id a1-20020a7bc1c1000000b0039c58c4c701mr20609265wmj.117.1655460425390;
        Fri, 17 Jun 2022 03:07:05 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id m42-20020a05600c3b2a00b003973435c517sm5265534wms.0.2022.06.17.03.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:07:05 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 CANDIDATE 11/11] xfs: use setattr_copy to set vfs inode attributes
Date:   Fri, 17 Jun 2022 13:06:41 +0300
Message-Id: <20220617100641.1653164-12-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617100641.1653164-1-amir73il@gmail.com>
References: <20220617100641.1653164-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit e014f37db1a2d109afa750042ac4d69cf3e3d88e upstream.

[remove userns argument of setattr_copy() for backport]

Filipe Manana pointed out that XFS' behavior w.r.t. setuid/setgid
revocation isn't consistent with btrfs[1] or ext4.  Those two
filesystems use the VFS function setattr_copy to convey certain
attributes from struct iattr into the VFS inode structure.

Andrey Zhadchenko reported[2] that XFS uses the wrong user namespace to
decide if it should clear setgid and setuid on a file attribute update.
This is a second symptom of the problem that Filipe noticed.

XFS, on the other hand, open-codes setattr_copy in xfs_setattr_mode,
xfs_setattr_nonsize, and xfs_setattr_time.  Regrettably, setattr_copy is
/not/ a simple copy function; it contains additional logic to clear the
setgid bit when setting the mode, and XFS' version no longer matches.

The VFS implements its own setuid/setgid stripping logic, which
establishes consistent behavior.  It's a tad unfortunate that it's
scattered across notify_change, should_remove_suid, and setattr_copy but
XFS should really follow the Linux VFS.  Adapt XFS to use the VFS
functions and get rid of the old functions.

[1] https://lore.kernel.org/fstests/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
[2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/

Fixes: 7fa294c8991c ("userns: Allow chown and setgid preservation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_iops.c | 56 +++--------------------------------------------
 fs/xfs/xfs_pnfs.c |  3 ++-
 2 files changed, 5 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b7f7b31a77d5..5711c8c12625 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -595,37 +595,6 @@ xfs_vn_getattr(
 	return 0;
 }
 
-static void
-xfs_setattr_mode(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr)
-{
-	struct inode		*inode = VFS_I(ip);
-	umode_t			mode = iattr->ia_mode;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	inode->i_mode &= S_IFMT;
-	inode->i_mode |= mode & ~S_IFMT;
-}
-
-void
-xfs_setattr_time(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	if (iattr->ia_valid & ATTR_ATIME)
-		inode->i_atime = iattr->ia_atime;
-	if (iattr->ia_valid & ATTR_CTIME)
-		inode->i_ctime = iattr->ia_ctime;
-	if (iattr->ia_valid & ATTR_MTIME)
-		inode->i_mtime = iattr->ia_mtime;
-}
-
 static int
 xfs_vn_change_ok(
 	struct dentry	*dentry,
@@ -740,16 +709,6 @@ xfs_setattr_nonsize(
 				goto out_cancel;
 		}
 
-		/*
-		 * CAP_FSETID overrides the following restrictions:
-		 *
-		 * The set-user-ID and set-group-ID bits of a file will be
-		 * cleared upon successful return from chown()
-		 */
-		if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
-		    !capable(CAP_FSETID))
-			inode->i_mode &= ~(S_ISUID|S_ISGID);
-
 		/*
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
@@ -761,7 +720,6 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
@@ -772,15 +730,10 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			inode->i_gid = gid;
 		}
 	}
 
-	if (mask & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	setattr_copy(inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
@@ -1025,11 +978,8 @@ xfs_setattr_size(
 		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
-	if (iattr->ia_valid & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (iattr->ia_valid & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f3082a957d5e..ae61094bc9d1 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -283,7 +283,8 @@ xfs_fs_commit_blocks(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	xfs_setattr_time(ip, iattr);
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(inode, iattr);
 	if (update_isize) {
 		i_size_write(inode, iattr->ia_size);
 		ip->i_d.di_size = iattr->ia_size;
-- 
2.25.1

