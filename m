Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17128C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 10:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352358AbiFAKqC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 06:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352264AbiFAKp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 06:45:59 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48888813C6;
        Wed,  1 Jun 2022 03:45:56 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id z17so737458wmf.1;
        Wed, 01 Jun 2022 03:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dTtVKM9UT0CLXD1zwfcjWb0IVAoLGPcfVYgpuoOmr9I=;
        b=f7DxPeDuS8HGSyat8Ed08BgrgGjpLdyuBfoh6GpcEHsdj0t1uSwCjMeWJ44L6jDpjL
         ICH4FVLIlmkb97ICah1qsJlTJyVSeCprbh42N7FStXOS7gJJcWjt6/C2X7s73bKDzWsO
         pxrlRICgDKJHOUoezTEYdYL1e7kPQn4kDPcIGrsyLwPRsZhqizjNHqLTChByHEydj93I
         VeWprcatXOiO6HOGTMdHxSg9BYjnSYwYKAEq3d77ViQHdK7hMSq74huilwum30QAAGSM
         5Sh4NEbH1PP51nAclMvZhIWasbwfgSlAYlV+nJ29FAi1b1JfJteKZU3NDXcxfXsCVfxR
         fKfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dTtVKM9UT0CLXD1zwfcjWb0IVAoLGPcfVYgpuoOmr9I=;
        b=jsDUEodCqLTkPSPISl4QdktW8JaMf9aVfCmQrXiYOeBedAgokpMz7hGI83zrxyu+Ec
         42vVHtpJA0ZY4MUI63k/M4f+N3O89MkYhbX6Vkze9uOMpDGJHzdAIaK0SNwHOeeIaqHS
         WKd/bFo/XypFV62afnkz+4EteR1RIiWgMbglnRijidwByLdySHI21kt95h0mLUfSjxho
         HN0cyRas01JnnoVoPEfymgFpH42wbLEt8vN7khu31f+PKLKcKCgX7W+to31dkQnAUxy4
         BntxL9rkFRWb6YRi/GFltWs2Ca3JosOULR1ow0OzEdC2Z9zVLEj+r86viMnxhUPT62kS
         9HMQ==
X-Gm-Message-State: AOAM532gGAfsSc6d3HqZ5x5PNAIi7/3MA64ZsVALwJoKaUPq6uOnhEsB
        WLk+nr7tFZJBpEhx+BtSaZc=
X-Google-Smtp-Source: ABdhPJxSSaYbxMlqeAvyOWjTvhw3BpQAGjxNPmTKLqJlSjVA4egLp8rO1W2CyNU3o/+h1+pAxiQgVg==
X-Received: by 2002:a05:600c:1e2a:b0:397:780a:b7f1 with SMTP id ay42-20020a05600c1e2a00b00397780ab7f1mr27948417wmb.188.1654080354517;
        Wed, 01 Jun 2022 03:45:54 -0700 (PDT)
Received: from localhost.localdomain ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id h9-20020a5d4309000000b002102af52a2csm1562150wrq.9.2022.06.01.03.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 03:45:54 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.10 CANDIDATE 1/8] xfs: fix up non-directory creation in SGID directories
Date:   Wed,  1 Jun 2022 13:45:40 +0300
Message-Id: <20220601104547.260949-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601104547.260949-1-amir73il@gmail.com>
References: <20220601104547.260949-1-amir73il@gmail.com>
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
index e958b1c74561..e20d8af80216 100644
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

