Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB238C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjBPUmh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBPUmh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:42:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BF6CC0D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:42:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2013FB82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64D9C433D2;
        Thu, 16 Feb 2023 20:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580153;
        bh=M7xG7Fyk+gJBf/px5MS/SIU2e1OFfD59hvrsPHl3Czg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=etJjFq9059qeja8XnJD28s1jZxKfBnih4+f3rdhCnn9H3kKVd9ynJ7jGtQPBahAAs
         1xlbUAJ9p/Zf3ITNv1lq8lYDIlYzuqxuX0d9eHoASgE9X43uMJYzSQ2/Gz8SVl2Bne
         uOQTRK+SgxyXJYVPkMnHzkCivFWgis4oeK2Eeu153wAsVEb43w1sbaYNG4aVPf+4qH
         Bu6COl7XT7D/p7ziZwOcH2RrXsJ1F+rITr0L8Tx9UistC5WVlb5vmMCIWp6zlg1QC1
         RYdkShVGoD9kN7VB9yniAUTgomgOP7/n+zICEdLv1q7PfQ7YN7nTTAreLOA37dMKAZ
         nN/AOd5l7x+hQ==
Date:   Thu, 16 Feb 2023 12:42:33 -0800
Subject: [PATCH 03/23] xfs: xfs_iget in the directory scrubber needs to use
 UNTRUSTED
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873880.3474338.6857782103435282379.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 4b80ac64450f, we tried to strengthen the directory scrubber by
using the iget call to detect directory entries that point to
unallocated inodes.  Unfortunately, that commit neglected to pass
XFS_IGET_UNTRUSTED to xfs_iget, so we don't check the inode btree first.
If the inode number points to something that isn't even an inode
cluster, iget will throw corruption errors and return -EFSCORRUPTED,
which means that we fail to mark the directory corrupt.

Fixes: 4b80ac64450f ("xfs: scrub should mark a directory corrupt if any entries cannot be iget'd")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 677b21c3c865..ec0c73e0eb0c 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -59,19 +59,15 @@ xchk_dir_check_ftype(
 	}
 
 	/*
-	 * Grab the inode pointed to by the dirent.  We release the
-	 * inode before we cancel the scrub transaction.  Since we're
-	 * don't know a priori that releasing the inode won't trigger
-	 * eofblocks cleanup (which allocates what would be a nested
-	 * transaction), we can't use DONTCACHE here because DONTCACHE
-	 * inodes can trigger immediate inactive cleanup of the inode.
+	 * Grab the inode pointed to by the dirent.  Use UNTRUSTED here to
+	 * check the allocation status of the inode in the inode btrees.
 	 *
 	 * If _iget returns -EINVAL or -ENOENT then the child inode number is
 	 * garbage and the directory is corrupt.  If the _iget returns
 	 * -EFSCORRUPTED or -EFSBADCRC then the child is corrupt which is a
 	 *  cross referencing error.  Any other error is an operational error.
 	 */
-	error = xfs_iget(mp, sdc->sc->tp, inum, 0, 0, &ip);
+	error = xchk_iget(sdc->sc, inum, &ip);
 	if (error == -EINVAL || error == -ENOENT) {
 		error = -EFSCORRUPTED;
 		xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, 0, &error);

