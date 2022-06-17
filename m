Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC12CCA479
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 10:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381583AbiFQKHr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 06:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381581AbiFQKHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 06:07:23 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F676A436;
        Fri, 17 Jun 2022 03:07:05 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id z9so2058826wmf.3;
        Fri, 17 Jun 2022 03:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VPwd3V/mnJTePijepg+bg6gI8KKUf3jNlg+9LNT8k34=;
        b=E5Y+jdBNSP6FJgv01znY/FqvVxDVRzuTA0E6/KWltR7AQvsYNt9YDm+rL/qzpI0/LE
         p1moFKNmkPA05tehp9CVBxKJm3rQW102IV6rKzYRosIjOjT/bReYMDvUTmD13zZzPEit
         FWvtfBWCAyL8MsTMeynedbm0jE4TkmTvB5N/1r1G/ydySmOz56/2DBXnMT5EV8REKPGn
         TNkPOCj7//At1V+B+0XfJiO1t3+V8ovSVI2ZfBJ8O3c2/aCRHWzP5sSVcKPiXG8Hou3U
         TSlodWgAR1UZC1fvgWEVziy5uKo8H4Reo5gyTuGwzv2NAvXPtYrPmPDZJFPNMLdvS/ZN
         hcvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VPwd3V/mnJTePijepg+bg6gI8KKUf3jNlg+9LNT8k34=;
        b=gZ7abM8lderM5aLFJNK0B08/Fq9fE9Bx4sBkAUhvYgX9macsfM6FSKZ3l2+vtP+4w3
         9YvG25EY5fC7hxcG/RvhTe2Dn2L5WMHP35Mj5oUSslFy46WLEbKNEvaNWp6bhbzaAq9y
         0m6I1Yh/oeCs+hI8Jh7BAK+JmJXZdSBKkwlwkzfdyF9NS35Vrto+90k0i5opZoIkx8c6
         KlXIm1RppHXLuJFBYhRkkbAv+wqsMmHDaQJDyYe1k0J1D9UsixbGOKJQ/HrGcF05zZYv
         IjAl/81Bd6DZ+o2Zs+Gu96nYducVInK07gJ4gEpRDd4Qaz3Fk4kKNVFP2RVAPAiyhQfm
         hBjw==
X-Gm-Message-State: AJIora/TlIls7V3usfJzVDKefYlqNLg98nfcq1jdhnO93NqfHIS7E4YW
        JWnp+L/u+CXpgifue1xulKw=
X-Google-Smtp-Source: AGRyM1u2GxiarAuwK9CPF5PGhoMntxA+rwQDI1ys2Luxn5j5Y3sG+3sii7xe9daGZ4qK12PklJWb/w==
X-Received: by 2002:a05:600c:b51:b0:39d:b58f:67bf with SMTP id k17-20020a05600c0b5100b0039db58f67bfmr9391616wmr.195.1655460423753;
        Fri, 17 Jun 2022 03:07:03 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id m42-20020a05600c3b2a00b003973435c517sm5265534wms.0.2022.06.17.03.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:07:03 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 10/11] xfs: fix up non-directory creation in SGID directories
Date:   Fri, 17 Jun 2022 13:06:40 +0300
Message-Id: <20220617100641.1653164-11-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617100641.1653164-1-amir73il@gmail.com>
References: <20220617100641.1653164-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 01ea173e103edd5ec41acec65b9261b87e123fc2 upstream.

XFS always inherits the SGID bit if it is set on the parent inode, while
the generic inode_init_owner does not do this in a few cases where it can
create a possible security problem, see commit 0fa3ecd87848
("Fix up non-directory creation in SGID directories") for details.

Switch XFS to use the generic helper for the normal path to fix this,
just keeping the simple field inheritance open coded for the case of the
non-sgid case with the bsdgrpid mount option.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_inode.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1ae669d12301..ae86fbdc1bab 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -802,6 +802,7 @@ xfs_ialloc(
 	xfs_buf_t	**ialloc_context,
 	xfs_inode_t	**ipp)
 {
+	struct inode	*dir = pip ? VFS_I(pip) : NULL;
 	struct xfs_mount *mp = tp->t_mountp;
 	xfs_ino_t	ino;
 	xfs_inode_t	*ip;
@@ -847,18 +848,17 @@ xfs_ialloc(
 		return error;
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
-	inode->i_mode = mode;
 	set_nlink(inode, nlink);
-	inode->i_uid = current_fsuid();
 	inode->i_rdev = rdev;
 	ip->i_d.di_projid = prid;
 
-	if (pip && XFS_INHERIT_GID(pip)) {
-		inode->i_gid = VFS_I(pip)->i_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
-			inode->i_mode |= S_ISGID;
+	if (dir && !(dir->i_mode & S_ISGID) &&
+	    (mp->m_flags & XFS_MOUNT_GRPID)) {
+		inode->i_uid = current_fsuid();
+		inode->i_gid = dir->i_gid;
+		inode->i_mode = mode;
 	} else {
-		inode->i_gid = current_fsgid();
+		inode_init_owner(inode, dir, mode);
 	}
 
 	/*
-- 
2.25.1

