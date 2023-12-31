Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D850DC8C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahMlfH6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614C9C433C7;
	Sun, 31 Dec 2023 23:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063672;
	bh=4f55EqqzWGv5Y08S+nrqbhIga2qx1/l4/Hj4snWMYXc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ahMlfH6Pu/9/y6I4J+fprePn/VTmUWBlvKRwLLYsjJNpV2Jde9kt58G1Ux80e12Gh
	 P0xEGQ5deET4od21zSeff9FXUksyCzEbFJ3yREn86yNt8OWk8GVGHYu1BZmGdOOuuV
	 qKJyoos/uzgMBDkqDWSecGzBqrUCuj1A/owMzxFmLrO9imAPohk2HDboJ/vuhAb3lG
	 EAEQEVKYJ/vUIlTUEc0xG4+QBHQ91MUMBYd9C52rUfI5VqJRjPEIi9LgicLi/khUMD
	 xgy95DKJ85gtnE16EQydUczTEbC7AODPaMtVfFmNcbETagx793M9npaggzGi4Efnw2
	 /0a7esHp7BovQ==
Date: Sun, 31 Dec 2023 15:01:11 -0800
Subject: [PATCH 1/4] xfs_repair: check free space requirements before allowing
 upgrades
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Chandan Babu R <chandan.babu@oracle.com>,
 Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Message-ID: <170405004063.1801995.14257598961382309460.stgit@frogsfrogsfrogs>
In-Reply-To: <170405004048.1801995.14994710798555736563.stgit@frogsfrogsfrogs>
References: <170405004048.1801995.14994710798555736563.stgit@frogsfrogsfrogs>
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

Currently, the V5 feature upgrades permitted by xfs_repair do not affect
filesystem space usage, so we haven't needed to verify the geometry.

However, this will change once we start to allow the sysadmin to add new
metadata indexes to existing filesystems.  Add all the infrastructure we
need to ensure that there's enough space for metadata space reservations
and per-AG reservations the next time the filesystem will be mounted.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
[david: Recompute transaction reservation values; Exit with error if upgrade fails]
Signed-off-by: Dave Chinner <david@fromorbit.com>
[djwong: Refuse to upgrade if any part of the fs has < 10% free]
---
 include/libxfs.h |    1 
 repair/phase2.c  |  134 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 135 insertions(+)


diff --git a/include/libxfs.h b/include/libxfs.h
index 9e8596bedf9..77ecfda4bc7 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -86,6 +86,7 @@ struct iomap;
 #include "xfs_btree_staging.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_ag_resv.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/repair/phase2.c b/repair/phase2.c
index 06374817964..36eb0c21de5 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -221,6 +221,137 @@ install_new_state(
 	libxfs_trans_init(mp);
 }
 
+#define GIGABYTES(count, blog)     ((uint64_t)(count) << (30 - (blog)))
+static inline bool
+check_free_space(
+	struct xfs_mount	*mp,
+	unsigned long long	avail,
+	unsigned long long	total)
+{
+	/* Ok if there's more than 10% free. */
+	if (avail >= total / 10)
+		return true;
+
+	/* Not ok if there's less than 5% free. */
+	if (avail < total / 5)
+		return false;
+
+	/* Let it slide if there's at least 10GB free. */
+	return avail > GIGABYTES(10, mp->m_sb.sb_blocklog);
+}
+
+static void
+check_fs_free_space(
+	struct xfs_mount		*mp,
+	const struct check_state	*old,
+	struct xfs_sb			*new_sb)
+{
+	struct xfs_perag		*pag;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	/* Make sure we have enough space for per-AG reservations. */
+	for_each_perag(mp, agno, pag) {
+		struct xfs_trans	*tp;
+		struct xfs_agf		*agf;
+		struct xfs_buf		*agi_bp, *agf_bp;
+		unsigned int		avail, agblocks;
+
+		/* Put back the old super so that we can read AG headers. */
+		restore_old_state(mp, old);
+
+		/*
+		 * Create a dummy transaction so that we can load the AGI and
+		 * AGF buffers in memory with the old fs geometry and pin them
+		 * there while we try to make a per-AG reservation with the new
+		 * geometry.
+		 */
+		error = -libxfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			do_error(
+	_("Cannot reserve resources for upgrade check, err=%d.\n"),
+					error);
+
+		error = -libxfs_ialloc_read_agi(pag, tp, &agi_bp);
+		if (error)
+			do_error(
+	_("Cannot read AGI %u for upgrade check, err=%d.\n"),
+					pag->pag_agno, error);
+
+		error = -libxfs_alloc_read_agf(pag, tp, 0, &agf_bp);
+		if (error)
+			do_error(
+	_("Cannot read AGF %u for upgrade check, err=%d.\n"),
+					pag->pag_agno, error);
+		agf = agf_bp->b_addr;
+		agblocks = be32_to_cpu(agf->agf_length);
+
+		/*
+		 * Install the new superblock and try to make a per-AG space
+		 * reservation with the new geometry.  We pinned the AG header
+		 * buffers to the transaction, so we shouldn't hit any
+		 * corruption errors on account of the new geometry.
+		 */
+		install_new_state(mp, new_sb);
+
+		error = -libxfs_ag_resv_init(pag, tp);
+		if (error == ENOSPC) {
+			printf(
+	_("Not enough free space would remain in AG %u for metadata.\n"),
+					pag->pag_agno);
+			exit(1);
+		}
+		if (error)
+			do_error(
+	_("Error %d while checking AG %u space reservation.\n"),
+					error, pag->pag_agno);
+
+		/*
+		 * Would the post-upgrade filesystem have enough free space in
+		 * this AG after making per-AG reservations?
+		 */
+		avail = pag->pagf_freeblks + pag->pagf_flcount;
+		avail -= pag->pag_meta_resv.ar_reserved;
+		avail -= pag->pag_rmapbt_resv.ar_asked;
+
+		if (!check_free_space(mp, avail, agblocks)) {
+			printf(
+	_("AG %u will be low on space after upgrade.\n"),
+					pag->pag_agno);
+			exit(1);
+		}
+		libxfs_trans_cancel(tp);
+	}
+
+	/*
+	 * Would the post-upgrade filesystem have enough free space on the data
+	 * device after making per-AG reservations?
+	 */
+	if (!check_free_space(mp, mp->m_sb.sb_fdblocks, mp->m_sb.sb_dblocks)) {
+		printf(_("Filesystem will be low on space after upgrade.\n"));
+		exit(1);
+	}
+
+	/*
+	 * Release the per-AG reservations and mark the per-AG structure as
+	 * uninitialized so that we don't trip over stale cached counters
+	 * after the upgrade/
+	 */
+	for_each_perag(mp, agno, pag) {
+		libxfs_ag_resv_free(pag);
+		clear_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
+		clear_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
+	}
+}
+
+static bool
+need_check_fs_free_space(
+	struct xfs_mount		*mp,
+	const struct check_state	*old)
+{
+	return false;
+}
+
 /*
  * Make sure we can actually upgrade this (v5) filesystem without running afoul
  * of root inode or log size requirements that would prevent us from mounting
@@ -263,6 +394,9 @@ install_new_geometry(
 		exit(1);
 	}
 
+	if (need_check_fs_free_space(mp, &old))
+		check_fs_free_space(mp, &old, new_sb);
+
 	/*
 	 * Restore the old state to get everything back to a clean state,
 	 * upgrade the featureset one more time, and recompute the btree max

