Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DAAC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbiL3Wq3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbiL3Wq2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:46:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708B232F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:46:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27F76B81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45A6C433EF;
        Fri, 30 Dec 2022 22:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440384;
        bh=M7xG7Fyk+gJBf/px5MS/SIU2e1OFfD59hvrsPHl3Czg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GooyLBobJqjlSckJawdBNb2o6v0xExUx0vysv6VaUJMPkUkMLirk3pyDd/3eNwaTq
         45nE11kZtENetLdLla42K0S/masvw3qADSwNkupHad6mds/m8gW36yD088W6Gaaztt
         lZmakQV1Q6qCyE9aDrKYgfGHVlAggwYTSEhlSqcf4fiAh5CdUb4XpidmjDBYp1Qxzd
         nJvZp5b2FuURy2x9fzgeV3yl/ETZakuOHMpYiRuW4J936WF4G5HdAdJPWTXOrq/OCo
         KvwlilCTobVMb55LNoCqnX2ApmXQzBHGgSCUxK5OvGWxL3qEewjHns2Xy4UeJca/6f
         /w9y5r7FT4Cow==
Subject: [PATCH 2/3] xfs: xfs_iget in the directory scrubber needs to use
 UNTRUSTED
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:39 -0800
Message-ID: <167243829923.686639.14682426697521660335.stgit@magnolia>
In-Reply-To: <167243829892.686639.6418703789098326027.stgit@magnolia>
References: <167243829892.686639.6418703789098326027.stgit@magnolia>
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

