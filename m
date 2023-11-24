Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDB53C482
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwHJO9Ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A27BC433C7;
	Fri, 24 Nov 2023 23:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700870162;
	bh=Vj74v1rdOPZWX6SytJ61ukQyZ18q0V5YO/YqyFl/1+4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rwHJO9PsaKB9KfgyC8NrMQ8nVFDygz+w5mzMY+8ERkEdFF3pWWgMdMx91wSOCusJr
	 5RlCTapAyZsozcIAbqi52Yix+dXEZ2esFY4tEkn1MRc1hbQuvnUZL8L65GAuUIZK8r
	 WMsMMIuTkkXgn2h0gxvJuM1EAyIz8bXrW2Cyh0/0CRc5BvG4mXOSXfJAsGGSaSXcry
	 YU14TiYfI7lXqvMWX4vW4wjNUxptBY6Yz1m5DDOX44QdNmb7a02nd+elbd/AYNJI0K
	 DPXrOqe4I5Pel2fzrWQdSDYxeCCoUx81kZQ8BiFDKJzIRH5ZQCClFSa+jqCUaTaF5p
	 DyVFIpZXnrd0A==
Date: Fri, 24 Nov 2023 15:56:02 -0800
Subject: [PATCH 1/5] xfs: check the ondisk space mapping behind a dquot
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086928807.2771741.8935602637361502223.stgit@frogsfrogsfrogs>
In-Reply-To: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
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

Each xfs_dquot object caches the file offset and daddr of the ondisk
block that backs the dquot.  Make sure these cached values are the same
as the bmapi data, and that the block state is written.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quota.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 5671c81534335..59350cd7a325b 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -6,6 +6,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_bit.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
@@ -75,6 +76,47 @@ struct xchk_quota_info {
 	xfs_dqid_t		last_id;
 };
 
+/* There's a written block backing this dquot, right? */
+STATIC int
+xchk_quota_item_bmap(
+	struct xfs_scrub	*sc,
+	struct xfs_dquot	*dq,
+	xfs_fileoff_t		offset)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_mount	*mp = sc->mp;
+	int			nmaps = 1;
+	int			error;
+
+	if (!xfs_verify_fileoff(mp, offset)) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		return 0;
+	}
+
+	if (dq->q_fileoffset != offset) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		return 0;
+	}
+
+	error = xfs_bmapi_read(sc->ip, offset, 1, &irec, &nmaps, 0);
+	if (error)
+		return error;
+
+	if (nmaps != 1) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		return 0;
+	}
+
+	if (!xfs_verify_fsbno(mp, irec.br_startblock))
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+	if (XFS_FSB_TO_DADDR(mp, irec.br_startblock) != dq->q_blkno)
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+	if (!xfs_bmap_is_written_extent(&irec))
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+
+	return 0;
+}
+
 /* Scrub the fields in an individual quota item. */
 STATIC int
 xchk_quota_item(
@@ -93,6 +135,17 @@ xchk_quota_item(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
+	/*
+	 * We want to validate the bmap record for the storage backing this
+	 * dquot, so we need to lock the dquot and the quota file.  For quota
+	 * operations, the locking order is first the ILOCK and then the dquot.
+	 * However, dqiterate gave us a locked dquot, so drop the dquot lock to
+	 * get the ILOCK.
+	 */
+	xfs_dqunlock(dq);
+	xchk_ilock(sc, XFS_ILOCK_SHARED);
+	xfs_dqlock(dq);
+
 	/*
 	 * Except for the root dquot, the actual dquot we got must either have
 	 * the same or higher id as we saw before.
@@ -103,6 +156,11 @@ xchk_quota_item(
 
 	sqi->last_id = dq->q_id;
 
+	error = xchk_quota_item_bmap(sc, dq, offset);
+	xchk_iunlock(sc, XFS_ILOCK_SHARED);
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, offset, &error))
+		return error;
+
 	/*
 	 * Warn if the hard limits are larger than the fs.
 	 * Administrators can do this, though in production this seems

