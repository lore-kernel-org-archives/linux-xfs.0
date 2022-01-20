Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F288C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357733AbiATATk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357751AbiATATc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:19:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FF2C06161C
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:19:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A8B9B81B2B
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9634C004E1;
        Thu, 20 Jan 2022 00:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637969;
        bh=87rFHsW5ysEHoN9qLTfflJIMTUC4ESrfLPfJjo/5NZk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KjPRdC5sFXQ7kEx2mlXPrSd2hB8JSiCTd8aFLJLQYXytdVUR22wuVbLQkvorNqSfP
         UfNafSW6MX1gMNwKjZbhTw/NCdkpUWyVOcqOW/p5sNwSRpupds2KDgk35VDZ9BOzYe
         9zhG2KiYXbFsXDQubqLip3TPY7DFYIeFguidkm0G8/aRe3H7tOGPEGeIUgcaFlBBod
         4uwGhf+djTnlYFqsYzICYdU/+eXR0VozcL+QCE7te2Wzl+EJF1cJj8nGJpUt0jXMfv
         hR5gcitcdnTtTYOwr2qj3Uisuz0/JbCE3vRZCT9TeN4VAUYHhszpvLRqu64F3S1VVT
         YuXWeA4b3LmJQ==
Subject: [PATCH 23/45] xfs: rework attr2 feature and mount options
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:19:29 -0800
Message-ID: <164263796937.860211.6061946474123174917.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: e23b55d537c9be60ae918fa6c3be0d699986f346

The attr2 feature is somewhat unique in that it has both a superblock
feature bit to enable it and mount options to enable and disable it.

Back when it was first introduced in 2005, attr2 was disabled unless
either the attr2 superblock feature bit was set, or the attr2 mount
option was set. If the superblock feature bit was not set but the
mount option was set, then when the first attr2 format inode fork
was created, it would set the superblock feature bit. This is as it
should be - the superblock feature bit indicated the presence of the
attr2 on disk format.

The noattr2 mount option, however, did not affect the superblock
feature bit. If noattr2 was specified, the on-disk superblock
feature bit was ignored and the code always just created attr1
format inode forks.  If neither of the attr2 or noattr2 mounts
option were specified, then the behaviour was determined by the
superblock feature bit.

This was all pretty sane.

Fast foward 3 years, and we are dealing with fallout from the
botched sb_features2 addition and having to deal with feature
mismatches between the sb_features2 and sb_bad_features2 fields. The
attr2 feature bit was one of these flags. The reconciliation was
done well after mount option parsing and, unfortunately, the feature
reconciliation had a bug where it ignored the noattr2 mount option.

For reasons lost to the mists of time, it was decided that resolving
this issue in commit 7c12f296500e ("[XFS] Fix up noattr2 so that it
will properly update the versionnum and features2 fields.") required
noattr2 to clear the superblock attr2 feature bit.  This greatly
complicated the attr2 behaviour and broke rules about feature bits
needing to be set when those specific features are present in the
filesystem.

By complicated, I mean that it introduced problems due to feature
bit interactions with log recovery. All of the superblock feature
bit checks are done prior to log recovery, but if we crash after
removing a feature bit, then on the next mount we see the feature
bit in the unrecovered superblock, only to have it go away after the
log has been replayed.  This means our mount time feature processing
could be all wrong.

Hence you can mount with noattr2, crash shortly afterwards, and
mount again without attr2 or noattr2 and still have attr2 enabled
because the second mount sees attr2 still enabled in the superblock
before recovery runs and removes the feature bit. It's just a mess.

Further, this is all legacy code as the v5 format requires attr2 to
be enabled at all times and it cannot be disabled.  i.e. the noattr2
mount option returns an error when used on v5 format filesystems.

To straighten this all out, this patch reverts the attr2/noattr2
mount option behaviour back to the original behaviour. There is no
reason for disabling attr2 these days, so we will only do this when
the noattr2 mount option is set. This will not remove the superblock
feature bit. The superblock bit will provide the default behaviour
and only track whether attr2 is present on disk or not. The attr2
mount option will enable the creation of attr2 format inode forks,
and if the superblock feature bit is not set it will be added when
the first attr2 inode fork is created.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h |    7 -------
 1 file changed, 7 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 5d8a1291..ac739e6a 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -398,13 +398,6 @@ static inline void xfs_sb_version_addattr2(struct xfs_sb *sbp)
 	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
 }
 
-static inline void xfs_sb_version_removeattr2(struct xfs_sb *sbp)
-{
-	sbp->sb_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
-	if (!sbp->sb_features2)
-		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
-}
-
 static inline bool xfs_sb_version_hasprojid32bit(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||

