Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A645C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37FD9610D1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhINCnR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237098AbhINCnR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:43:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68BD9610D1;
        Tue, 14 Sep 2021 02:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587320;
        bh=87rFHsW5ysEHoN9qLTfflJIMTUC4ESrfLPfJjo/5NZk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FmmvBKzoFYpcSjKOrg0xOhTw0DAmcWK2M0u+L5ISRehtiK41JTUgYmEf8HVZ0R+/V
         wdzCF0pBjGgSs8n/HscUJOQc75mQt+lt761FmRZxihA4yvoARY2QFwZ/vbN1Pgm+V1
         vw8QTcu4/RFtHofd/Be09CD8EkoWIio/EY1h2DKVy7kuKBFlP26yT/1RdgXk4dSZDH
         X0ctmUxj6ikuRmalDunNr+hx9UKbGMdTZ7DOK2Poo1lat413/zySZDfU7u50uFlxCX
         ZlbxgVLdU4RZisEg/BaPcHlsvyBoSXjsqsT0vcoqmrG0q5BjdzRFQPWM+cGqO8SBwh
         5w3kLwdOr+FTA==
Subject: [PATCH 22/43] xfs: rework attr2 feature and mount options
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:42:00 -0700
Message-ID: <163158732017.1604118.6704125945588625133.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
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

