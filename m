Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253E0C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 14:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379742AbiDTOyp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 10:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379785AbiDTOyo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 10:54:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2657D1CFD1;
        Wed, 20 Apr 2022 07:51:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D98C6B81CCE;
        Wed, 20 Apr 2022 14:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3CFC385B9;
        Wed, 20 Apr 2022 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650466315;
        bh=qOLqASAAmDN5cEOgcDDI3KTUICj0PQWUsTgT6fy3/bc=;
        h=From:To:Cc:Subject:Date:From;
        b=mDIWJl+Fpj1aPs+KWPvCPolrJJIlMS3Z6DZGPbdW1DsiNj5Wr/6hJWixbUe8/cbvP
         U/7WJWoDSkslrSIx5xjlsiL9/r08J7IzGCSxfmj+BaSG0fuZGszPcXAbp0BU/JE802
         +0fWll0tE8MR8ieFhK+oP2tx7pVKiDK6r86el+YUrCEipV60vu2QL7uU10o+yfuiq+
         otX5dZEq6sRcajQGqDzL+11tgKlzLdR+lCLuJd9Rt+UlTUXJ9tUShLJ0M9z+dpFXnv
         hM7JWkrM4RTvTzKUJjXeeZBsSj/jnkn04xiw/uD3effC5A4ydtdj5cAAN+cyDHQdo9
         MRLwVmfpNv1hQ==
From:   Sasha Levin <sashal@kernel.org>
To:     stable-commits@vger.kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Patch "xfs: return errors in xfs_fs_sync_fs" has been added to the 5.15-stable tree
Date:   Wed, 20 Apr 2022 10:51:53 -0400
Message-Id: <20220420145153.518715-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a note to let you know that I've just added the patch titled

    xfs: return errors in xfs_fs_sync_fs

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-return-errors-in-xfs_fs_sync_fs.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 1325aa6868b83e6ae24efc43f0897f0faf50389d
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Sun Jan 30 08:53:17 2022 -0800

    xfs: return errors in xfs_fs_sync_fs
    
    [ Upstream commit 2d86293c70750e4331e9616aded33ab6b47c299d ]
    
    Now that the VFS will do something with the return values from
    ->sync_fs, make ours pass on error codes.
    
    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    Reviewed-by: Jan Kara <jack@suse.cz>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Acked-by: Christian Brauner <brauner@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c4e0cd1c1c8c..170fee98c45c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -729,6 +729,7 @@ xfs_fs_sync_fs(
 	int			wait)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
+	int			error;
 
 	trace_xfs_fs_sync_fs(mp, __return_address);
 
@@ -738,7 +739,10 @@ xfs_fs_sync_fs(
 	if (!wait)
 		return 0;
 
-	xfs_log_force(mp, XFS_LOG_SYNC);
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
+	if (error)
+		return error;
+
 	if (laptop_mode) {
 		/*
 		 * The disk must be active because we're syncing.
