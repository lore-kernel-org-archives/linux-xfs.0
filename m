Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3688BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbiLaCFL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiLaCFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:05:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64E92AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:05:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8319461CAA
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE997C433D2;
        Sat, 31 Dec 2022 02:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452308;
        bh=mFfOvtEVcrc5Vkc68RqXpVGDcJWrgAQ3DMvn8TI1aaQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hOwBohAuIKs2OjxNY1FrY40d750/U63p9Yid3mW8QJ9honQ9nlKkcFVumyl+s6iuY
         meuul0Qr5asshU+0CG4uj5as/lYBgVhDKjoube5Z+LQfIn4Ao9ZxIvmx0kPmbD9tgp
         IT54gBKIts0a4Al9BJeT4bFmH0yfNBKHki7JCYsXetkj6LyLP5feVInbd37L2ACfuV
         hge+bwBFNzcFZCiUnFH8huBTPJCb0//sgJnVQgLLTqNSXzfbxfgHCmATLyDgDqrb82
         t/0W6srWj2cUIBuKbjzpotU+NIwM/HaBCxNRLMO3kHpDOD4BQT+CFWTM1RS4t+GYXL
         ccLyY2kOqkOvA==
Subject: [PATCH 08/26] libxfs: rearrange libxfs_trans_ichgtime call when
 creating inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:14 -0800
Message-ID: <167243875420.723621.13673052362667514239.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rearrange the libxfs_trans_ichgtime call in libxfs_ialloc so that we
call it once with the flags we want.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 63150422b01..c14a4c5a27f 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -73,6 +73,7 @@ libxfs_icreate(
 	struct xfs_inode	*pip = args->pip;
 	struct xfs_inode	*ip;
 	unsigned int		flags;
+	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
 	int			error;
 
 	error = libxfs_iget(tp->t_mountp, tp, ino, 0, &ip);
@@ -84,7 +85,6 @@ libxfs_icreate(
 	set_nlink(VFS_I(ip), args->nlink);
 	VFS_I(ip)->i_uid = args->uid;
 	ip->i_projid = args->prid;
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
 
 	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
 		if (!(args->flags & XFS_ICREATE_ARGS_FORCE_GID))
@@ -102,10 +102,12 @@ libxfs_icreate(
 	if (xfs_has_v3inodes(ip->i_mount)) {
 		VFS_I(ip)->i_version = 1;
 		ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
-		ip->i_crtime = VFS_I(ip)->i_mtime;
 		ip->i_cowextsize = 0;
+		times |= XFS_ICHGTIME_CREATE;
 	}
 
+	xfs_trans_ichgtime(tp, ip, times);
+
 	flags = XFS_ILOG_CORE;
 	switch (args->mode & S_IFMT) {
 	case S_IFIFO:

