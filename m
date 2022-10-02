Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24814C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiJBSfO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiJBSfM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:35:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BA321266
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3040260F06
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891BCC433C1;
        Sun,  2 Oct 2022 18:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735710;
        bh=+Q7dKVv863KDCCdfj2c+NvBznXSAoFfB9xyWNURRSuM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cNmz1Jj8Rc8QnpNbNN4+ftn9d9Yo3VPS4MvhQD2y8Rb3aR7+M+i/q0AaZIGVtGrs8
         ra6RpwR4hX+nPcV9RDLrmuBA7cdaXHU6n4nBKnj4pJKaQwpfV4H41h/S57sCs1kz9G
         cFyX1BCvsI56s551ldTZZFoutP5miaOPYkMDKsbzwyL7i+vGINmeMe+cDhfyojwElm
         ZYQq95eC1rBQzAuoLtT8l4FG2p8X+0YA5r3cNpKOkRCwOeiYN+klJLUWU3+6xA8C8v
         cONHUZvwdrkp+y9UMVK4duNGov3r1NsaZda8rfpifrimW4iHvcGEA/l2CQZ5pWYI0L
         qxYg04Fr1PIcA==
Subject: [PATCH 2/3] xfs: xfs_iget in the directory scrubber needs to use
 UNTRUSTED
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:32 -0700
Message-ID: <166473483292.1084804.13624298577813120607.stgit@magnolia>
In-Reply-To: <166473483259.1084804.16578148649615408100.stgit@magnolia>
References: <166473483259.1084804.16578148649615408100.stgit@magnolia>
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
index 43a1cbf2ac67..61cd1330de42 100644
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

