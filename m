Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02DF364C1
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mwo1SkTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650D5C433C7;
	Fri, 24 Nov 2023 23:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869943;
	bh=tp9zLje03hLdFAEtIO0o5d9N65AlQC8ufIgHwN0P17c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mwo1SkTIuXbR5Kiri4J+tMfiQqJX8YCFDwBXnJ4tRWzDRmNb7mwkE9ZCSkifGA3fT
	 T8M4/1sIh+1GuLDtNCojhYVJvVY1+D1wVVM3fzx3DbL7bT7HGk05qr/wPXyT0vf1re
	 uYr0FQzstIshtbZ1ua0GLnzxXbcSp5z8c42w9j3hwVPr1DipaAjMGc2fGC2WCYYuyz
	 eJQGcrtfEfuNmAe0olCA2m7GVNdLJ1zQxJHUHm9CXPYZ2MdoK/LdEE6pbiUTLLed7J
	 THlc6kKLi042bLLzLQNzutijZTbp4fBYq+g+9opIgvM+9huTvNJxnEsv/xdfKlBX3b
	 9xhMA0oVE2xxw==
Date: Fri, 24 Nov 2023 15:52:23 -0800
Subject: [PATCH 5/7] xfs: abort directory parent scrub scans if we encounter a
 zapped directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086927520.2771142.16263878151202910889.stgit@frogsfrogsfrogs>
In-Reply-To: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
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

In the previous patch, we added some code to perform sufficient repairs
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
---
 fs/xfs/scrub/common.c |    1 +
 fs/xfs/scrub/common.h |    2 ++
 fs/xfs/scrub/dir.c    |   21 +++++++++++++++++++++
 fs/xfs/scrub/parent.c |   17 +++++++++++++++++
 4 files changed, 41 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 9b7d7010495b9..67ed4c55a27e3 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -26,6 +26,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 895918565df26..506b808b9fbb3 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -192,6 +192,8 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 			       XFS_SCRUB_OFLAG_XCORRUPT);
 }
 
+bool xchk_dir_looks_zapped(struct xfs_inode *dp);
+
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 /* Decide if a repair is required. */
 static inline bool xchk_needs_repair(const struct xfs_scrub_metadata *sm)
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 0b491784b7594..acae43d20f387 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -788,3 +788,24 @@ xchk_directory(
 		error = 0;
 	return error;
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
+	/*
+	 * If the dinode repair found a bad data fork, it will reset the fork
+	 * to extents format with zero records and wait for the bmapbtd
+	 * scrubber to reconstruct the block mappings.  Directories always
+	 * contain some content, so this is a clear sign of a zapped directory.
+	 */
+	if (dp->i_df.if_format == XFS_DINODE_FMT_EXTENTS)
+		return dp->i_df.if_nextents == 0;
+
+	return false;
+}
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index e6155d86f7916..7db8736721461 100644
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

