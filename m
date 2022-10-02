Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DF6C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiJBSa2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiJBSa1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:30:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BE725598
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F28D60F06
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BD3C433D6;
        Sun,  2 Oct 2022 18:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735425;
        bh=c8zMJbLImf1MooFLi1ZbxoeWZ85TcgNIeKamLqTzJFM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G6PniZGk6NQ3zCPJu5dBkrBWv/nA+49hw5Mct0DYjvFvlvvblAynp3NLNHrbk6reV
         SFc+t8y+sB2EEgoiJbq//uPGZL8XXIQUeSkao4sjvsGsngHJnGrivqS1vmaOEFZ53P
         I5agwL7H9K1cy2ulruvPJHZrOqoz4G6ycdSxYEBDHFY/B8tVEoGsuInRNmSQDQQDZ0
         uh3nUm7LA25YSJM1FsniXUOz/BltOltq1gXGy2Vj9BgJe7APqauTbiEuiZ//wXe+I4
         +q3BPWfTAZGz5rx1ksLVr47Pyl3fIxRcZ+aj8Cn5Ptx5CqcUenljVa891Xmi+IIwbe
         tzh2zbbaRQJyw==
Subject: [PATCH 2/2] xfs: make rtbitmap ILOCKing consistent when scanning the
 rt bitmap file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:02 -0700
Message-ID: <166473480263.1083697.13141104857984829878.stgit@magnolia>
In-Reply-To: <166473480232.1083697.18352887736798889545.stgit@magnolia>
References: <166473480232.1083697.18352887736798889545.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs_rtalloc_query_range scans the realtime bitmap file in order of
increasing file offset, so this caller can take ILOCK_SHARED on the rt
bitmap inode instead of ILOCK_EXCL.  This isn't going to yield any
practical benefits at mount time, but we'd like to make the locking
usage consistent around xfs_rtalloc_query_all calls.  Make all the
places we do this use the same xfs_ilock lockflags for consistency.

Fixes: 4c934c7dd60c ("xfs: report realtime space information via the rtbitmap")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c   |    4 ++--
 fs/xfs/xfs_rtalloc.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index d8337274c74d..88a88506ffff 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -524,7 +524,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 	struct xfs_mount		*mp = tp->t_mountp;
 	int				error;
 
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED);
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 
 	/*
 	 * Set up query parameters to return free rtextents covering the range
@@ -551,7 +551,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 	if (error)
 		goto err;
 err:
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b0846204c436..16534e9873f6 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1311,10 +1311,10 @@ xfs_rtalloc_reinit_frextents(
 	uint64_t		val = 0;
 	int			error;
 
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	error = xfs_rtalloc_query_all(mp, NULL, xfs_rtalloc_count_frextent,
 			&val);
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	if (error)
 		return error;
 

