Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62ACEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbiLaCE4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiLaCEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:04:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6690810B64
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:04:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0466661C19
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68029C433D2;
        Sat, 31 Dec 2022 02:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452293;
        bh=dJ+x5WB/TPMO/qyO3qHsGTAoMXBKAMjyN4dQmcFYlE0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aU8VaZEKHGPhNYCzIn+LjeR/BTQysE2XWcEuRErgYLq/AfWa9cxYKlZBIdi331Gdb
         midhf7SoV+0SOEP4rcD2EXjrxSx1XKnwxQIf4FuVrUTthIbTep5yF9WTNwcjYiMri1
         eXE+PITG5yMezdVPtDxd5N4A2hzjPyR27EMbylqGl2Bj1HmjINDqfBbWjfQ2GSeIix
         rMepPjChSoIkkv6rd+e4kwvHOQbDB84QpS7AHXecSJ11VpzYcX5X/ObAt8XRzA2CVX
         0vUfTLrtplP4sK5IhZsRdh3doUr8ViD8rnBswvO+dhjb6zBBv5jv2G7/E5dp/gfccD
         R2ZMsgZK3B+EQ==
Subject: [PATCH 07/26] libxfs: implement access timestamp updates in ichgtime
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:14 -0800
Message-ID: <167243875408.723621.3329159476206704247.stgit@magnolia>
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

Implement access time updates in ichgtime so that we can use the common
ichgtime function when setting up inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_shared.h      |    1 +
 libxfs/xfs_trans_inode.c |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 5127fa88531..acf527eb0e1 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -137,6 +137,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
 #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
 #define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+#define	XFS_ICHGTIME_ACCESS	0x8	/* last access timestamp */
 
 /* Computed inode geometry for the filesystem. */
 struct xfs_ino_geometry {
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 276d57cf737..6fc7a65d517 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -66,6 +66,8 @@ xfs_trans_ichgtime(
 		inode->i_mtime = tv;
 	if (flags & XFS_ICHGTIME_CHG)
 		inode->i_ctime = tv;
+	if (flags & XFS_ICHGTIME_ACCESS)
+		inode->i_atime = tv;
 	if (flags & XFS_ICHGTIME_CREATE)
 		ip->i_crtime = tv;
 }

