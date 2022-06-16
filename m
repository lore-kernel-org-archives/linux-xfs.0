Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38088CCA47E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 18:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiFPS2l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377954AbiFPS2e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 14:28:34 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8590D50060
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:33 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id g8so1914366plt.8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zlh3bSHgcXLmTXRzmupsjo6rxJg9WFeMtgLwa8hX99k=;
        b=XzNHKziwWeYbIp8lDfVKUh9E5+I/RDTiAyP7V1+SHcCtsa19BFi2CTCkw1zJybCxPi
         UI7tZzce020yWV7i6AkLcbfegceRvuxV32Jmc3XZ/yyU8X02NoumU9AoEzKXfaUltMld
         6b49/EUvpZ77C9uG8n0Pp+VO8A7XWhkt7TachTbNrhJgl956UTdMKEsIe9nrTEG6LHt7
         3PyC6FmQ33p4IpooNSyb8kzTs3pwB9gXr+Ol4NhwgNsTamYhJBhyvEPjBuW+o0YeAbGw
         o0G36P3fjuQGP1O4DkdVI2jjLyw1SS30HtxbkofJyzF0NV8zHCbBdC7UwJZFE1rsr2Pb
         koKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zlh3bSHgcXLmTXRzmupsjo6rxJg9WFeMtgLwa8hX99k=;
        b=uu0YDsfuoXGoJ0ee9y3GkZTtSErpaRHeD7hTCroQJK+QvcGGoDJa6QCa610tdNECf1
         UEevsNGBwhupirV4418Z56zyoj4aMmLk09p3iXyVOHSz6xWmmdi7sw4Rp0MAYKE8pUr1
         tc908IQrjcUX2NRrGaBr9gob4E1kkdMyrDTuN+0UsKH1ulIs+/eCZ5JZvqrujSF27xA5
         V1H+PfPrombSjz9izsdl+POqNZa0b/G5sEv/m8LSfF1Jamf37FixlUYPIDZ+FqAt2hKg
         i9EO/5Uh1u60Th1zar2e3wO1/01YnIYb/c1ULUkdwXD1piZKjV/r5orPpBegAEwuzwGt
         M1Xg==
X-Gm-Message-State: AJIora8LpxQtI4HT3Fcp3hMTM380fpYt/wv6HaTExW4Edo4gHc+lmemV
        /czkCdM+nhBcQb+Dqk1ecwlImRQyV0/t1g==
X-Google-Smtp-Source: AGRyM1sT0Y15u6hjSu1/0Yxv3xQ29QJ60nL8Xh6XbcBqU7ZaS+FPmtvtB/E2+MlNLV8yr3cC3D3UGQ==
X-Received: by 2002:a17:902:d702:b0:168:cfec:de55 with SMTP id w2-20020a170902d70200b00168cfecde55mr5569184ply.63.1655404112788;
        Thu, 16 Jun 2022 11:28:32 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:fd57:7edc:385a:c1be])
        by smtp.gmail.com with ESMTPSA id fs20-20020a17090af29400b001ea75a02805sm4131511pjb.52.2022.06.16.11.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:28:32 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     mcgrof@kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v2 8/8] xfs: use setattr_copy to set vfs inode attributes
Date:   Thu, 16 Jun 2022 11:27:49 -0700
Message-Id: <20220616182749.1200971-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220616182749.1200971-1-leah.rumancik@gmail.com>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit e014f37db1a2d109afa750042ac4d69cf3e3d88e ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_iops.c | 56 +++--------------------------------------------
 fs/xfs/xfs_pnfs.c |  3 ++-
 2 files changed, 5 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a607d6aca5c4..1eb71275e5b0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -634,37 +634,6 @@ xfs_vn_getattr(
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
 	struct user_namespace	*mnt_userns,
@@ -763,16 +732,6 @@ xfs_setattr_nonsize(
 		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
 		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
 
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
@@ -784,7 +743,6 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_GQUOTA_ON(mp)) {
@@ -795,15 +753,10 @@ xfs_setattr_nonsize(
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
+	setattr_copy(mnt_userns, inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
@@ -1028,11 +981,8 @@ xfs_setattr_size(
 		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
-	if (iattr->ia_valid & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (iattr->ia_valid & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(mnt_userns, inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 5e1d29d8b2e7..8865f7d4404a 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -283,7 +283,8 @@ xfs_fs_commit_blocks(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	xfs_setattr_time(ip, iattr);
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(&init_user_ns, inode, iattr);
 	if (update_isize) {
 		i_size_write(inode, iattr->ia_size);
 		ip->i_disk_size = iattr->ia_size;
-- 
2.36.1.476.g0c4daa206d-goog

