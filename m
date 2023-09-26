Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C14E7F14B
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 01:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbjI0BxJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 21:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234803AbjI0BvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 21:51:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B589A5F3
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:36:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D86C433C8;
        Tue, 26 Sep 2023 23:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771396;
        bh=1n5+88c2nV3LdU5ORkCT5OiIJAIgmPmdSV0ZTiG3YgQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=SI4vUEW8V8kStUyudRGnog8oRXrQmQwEc9cIKw6rJbJq1I9JU07UFxf4RkYLOv/Zy
         CtWflLeKRYFxqYT+WDQz+XA7051qwFUnY89vYmLsH4lYIYGVoiw4cjTXU8DbFWz90j
         kzVz97gJMJP5+04TVdpRvGGmnqbW5AgynZCuZsbnKH/07T/F/P4CgmpXh6+x+CgEPn
         Tu8KWHPE4cm510BSXwyXA9IIqsxPlcIm+1W6drS95weaRHZu+zhZSO3MMwwMPcRY7r
         45j3L5jPApfGPdENVSRij5X0hOzGLqZCx+uz6u6hbfBMb1LVGcSh572xfq1l8rh3xV
         +EitHzzboB/Wg==
Date:   Tue, 26 Sep 2023 16:36:36 -0700
Subject: [PATCH 6/7] xfs: skip the rmapbt search on an empty attr fork unless
 we know it was zapped
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577060450.3315095.13451800619956869403.stgit@frogsfrogsfrogs>
In-Reply-To: <169577060353.3315095.13977747715399477216.stgit@frogsfrogsfrogs>
References: <169577060353.3315095.13977747715399477216.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The attribute fork scrubber can optionally scan the reverse mapping
records of the filesystem to determine if the fork is missing mappings
that it should have.  However, this is a very expensive operation, so we
only want to do this if we suspect that the fork is missing records.
For attribute forks the criteria for suspicion is that the attr fork is
in EXTENTS format and has zero extents.

However, there are several ways that a file can end up in this state
through regular filesystem usage.  For example, an LSM can set a
s_security hook but then decide not to set an ACL; or an attr set can
create the attr fork but then the actual set operation fails with
ENOSPC; or we can delete all the attrs on a file whose data fork is in
btree format, in which case we do not delete the attr fork.  We don't
want to run the expensive check for any case that can be arrived at
through regular operations.

However.

When online inode repair decides to zap an attribute fork, it cannot
determine if it is zapping ACL information.  As a precaution it removes
all the discretionary access control permissions and sets the user and
group ids to zero.  Check these three additional conditions to decide if
we want to scan the rmap records.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 76aa40fef84ad..c9c343b10196c 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -662,16 +662,46 @@ xchk_bmap_want_check_rmaps(
 	 * The inode repair code zaps broken inode forks by resetting them back
 	 * to EXTENTS format and zero extent records.  If we encounter a fork
 	 * in this state along with evidence that the fork isn't supposed to be
-	 * empty, we need to scan the reverse mappings to decide if we're going
-	 * to rebuild the fork.  Data forks with nonzero file size are scanned.
-	 * xattr forks are never empty of content, so they are always scanned.
+	 * empty, we might want scan the reverse mappings to decide if we're
+	 * going to rebuild the fork.
 	 */
 	ifp = xfs_ifork_ptr(sc->ip, info->whichfork);
 	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS && ifp->if_nextents == 0) {
-		if (info->whichfork == XFS_DATA_FORK &&
-		    i_size_read(VFS_I(sc->ip)) == 0)
-			return false;
-
+		switch (info->whichfork) {
+		case XFS_DATA_FORK:
+			/*
+			 * Data forks with zero file size are presumed not to
+			 * have any written data blocks.  Skip the scan.
+			 */
+			if (i_size_read(VFS_I(sc->ip)) == 0)
+				return false;
+			break;
+		case XFS_ATTR_FORK:
+			/*
+			 * Files can have an attr fork in EXTENTS format with
+			 * zero records for several reasons:
+			 *
+			 * a) an attr set created a fork but ran out of space
+			 * b) attr replace deleted an old attr but failed
+			 *    during the set step
+			 * c) the data fork was in btree format when all attrs
+			 *    were deleted, so the fork was left in place
+			 * d) the inode repair code zapped the fork
+			 *
+			 * Only in case (d) do we want to scan the rmapbt to
+			 * see if we need to rebuild the attr fork.  The fork
+			 * zap code clears all DAC permission bits and zeroes
+			 * the uid and gid, so avoid the scan if any of those
+			 * three conditions are not met.
+			 */
+			if ((VFS_I(sc->ip)->i_mode & 0777) != 0)
+				return false;
+			if (!uid_eq(VFS_I(sc->ip)->i_uid, GLOBAL_ROOT_UID))
+				return false;
+			if (!gid_eq(VFS_I(sc->ip)->i_gid, GLOBAL_ROOT_GID))
+				return false;
+			break;
+		}
 		return true;
 	}
 

