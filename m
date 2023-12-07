Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AB61841
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NlJEhTxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C49C433C8;
	Thu,  7 Dec 2023 02:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701917028;
	bh=C68CE6Hf0CM/1Y50RLJttQBtMKjL6zU/AdYQqzCG7X8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NlJEhTxchhzw7HKx+KCib/7mHwc73YnBRNehliYEkqzQoFaCs8CPsBNmkHZmLQ9pW
	 5axxO4GeCIYT6YhNGbGDALxUY1/xQdkT0B0pXYAr3+H8FtI8Qlt95yHKlDKpGpS06P
	 duzTFFbhJ3qkORR047MEeCDd18mG/X2zg10qStGRtwP5t7qm+99lL+g/tV/+zFQMqJ
	 dGL0EvOHKx26c4LnfYvuSNl49jsIIv2kwXDKGyiu7ZYp2eWakM2wbmSc70bHmsRync
	 VyKlMx5wjdoqDUFiN5uzoG8MBt1gLltMb50RCKZ4erYN2ENWu+ksr6RovOEcpayYQZ
	 NHZbQDDFEDi6g==
Date: Wed, 06 Dec 2023 18:43:47 -0800
Subject: [PATCH 8/9] xfs: skip the rmapbt search on an empty attr fork unless
 we know it was zapped
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191666238.1182270.18118442139749127193.stgit@frogsfrogsfrogs>
In-Reply-To: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
index 0ff1f631a9594..a632885825b27 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -664,16 +664,46 @@ xchk_bmap_want_check_rmaps(
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
 

