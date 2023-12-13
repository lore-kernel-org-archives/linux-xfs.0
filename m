Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4298183A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rAG1U7CU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86ACCC433C7;
	Wed, 13 Dec 2023 22:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702508121;
	bh=LAKS8DJIeRpII3Vu92j1dd/hzPjtO2ngRIkAWO5YPT0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rAG1U7CULavEMTQN28YvpVf8ka1v7jjtsd2VWej1lhJg6bbiXOa/IWjaf6wqpBJyu
	 yQCJcYUR4+LY5kwSMxPPJ+cpMMOG2R1oeQNa5IvMtI2IMfqQ5peyES8am2cfhm1qwN
	 /3dhgeHuJZRPJrOX+1yy4265rfs+IOH57DIxAeA/B8dVLm8ESeohYW24IkcZB0JNpw
	 4ncsw0pjaSz1rMcu97aAIZUAM5LuMXP4mKbDrUY+wV58lZ3j3NXx70a7MPTjwNI1jG
	 mJQy+eoozuiwHRWrAsQcAhDFNjCpM6eTwN9Z5iUeJQInX3VN9ChPMUKESX5hKkLfMt
	 qc7GNVdSyRPgw==
Date: Wed, 13 Dec 2023 14:55:21 -0800
Subject: [PATCH 8/9] xfs: abort directory parent scrub scans if we encounter a
 zapped directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783597.1399182.2820436440554114825.stgit@frogsfrogsfrogs>
In-Reply-To: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
References: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
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

In a previous patch, we added some code to perform sufficient repairs
to an ondisk inode record such that the inode cache would be willing to
load the inode.  If the broken inode was a shortform directory, it will
reset the directory to something plausible, which is to say an empty
subdirectory of the root.  The telltale signs that something is
seriously wrong is the broken link count.

Such directories look clean, but they shouldn't participate in a
filesystem scan to find or confirm a directory parent pointer.  Create a
predicate that identifies such directories and abort the scrub.

Found by fuzzing xfs/1554 with multithreaded xfs_scrub enabled and
u3.bmx[0].startblock = zeroes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c |    1 +
 fs/xfs/scrub/common.h |    2 ++
 fs/xfs/scrub/dir.c    |   26 ++++++++++++++++++++++++++
 fs/xfs/scrub/parent.c |   17 +++++++++++++++++
 4 files changed, 46 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index f0207e71e5dc..81f2b96bb5a7 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -25,6 +25,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index c69cacb0b696..ec5755266259 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -198,6 +198,8 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 			       XFS_SCRUB_OFLAG_XCORRUPT);
 }
 
+bool xchk_dir_looks_zapped(struct xfs_inode *dp);
+
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 /* Decide if a repair is required. */
 static inline bool xchk_needs_repair(const struct xfs_scrub_metadata *sm)
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index b366fab699ac..d86ab51af928 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -798,3 +798,29 @@ xchk_directory(
 	xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_DIR_ZAPPED);
 	return 0;
 }
+
+/*
+ * Decide if this directory has been zapped to satisfy the inode and ifork
+ * verifiers.  Checking and repairing should be postponed until the directory
+ * is fixed.
+ */
+bool
+xchk_dir_looks_zapped(
+	struct xfs_inode	*dp)
+{
+	/* Repair zapped this dir's data fork a short time ago */
+	if (xfs_ifork_zapped(dp, XFS_DATA_FORK))
+		return true;
+
+	/*
+	 * If the dinode repair found a bad data fork, it will reset the fork
+	 * to extents format with zero records and wait for the bmapbtd
+	 * scrubber to reconstruct the block mappings.  Directories always
+	 * contain some content, so this is a clear sign of a zapped directory.
+	 * The state checked by xfs_ifork_zapped is not persisted, so this is
+	 * the secondary strategy if repairs are interrupted by a crash or an
+	 * unmount.
+	 */
+	return dp->i_df.if_format == XFS_DINODE_FMT_EXTENTS &&
+	       dp->i_df.if_nextents == 0;
+}
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index e6155d86f791..7db873672146 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -156,6 +156,16 @@ xchk_parent_validate(
 		goto out_rele;
 	}
 
+	/*
+	 * We cannot yet validate this parent pointer if the directory looks as
+	 * though it has been zapped by the inode record repair code.
+	 */
+	if (xchk_dir_looks_zapped(dp)) {
+		error = -EBUSY;
+		xchk_set_incomplete(sc);
+		goto out_unlock;
+	}
+
 	/* Look for a directory entry in the parent pointing to the child. */
 	error = xchk_dir_walk(sc, dp, xchk_parent_actor, &spc);
 	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
@@ -217,6 +227,13 @@ xchk_parent(
 		 */
 		error = xchk_parent_validate(sc, parent_ino);
 	} while (error == -EAGAIN);
+	if (error == -EBUSY) {
+		/*
+		 * We could not scan a directory, so we marked the check
+		 * incomplete.  No further error return is necessary.
+		 */
+		return 0;
+	}
 
 	return error;
 }

