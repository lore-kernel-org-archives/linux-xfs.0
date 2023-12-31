Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEB7BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rmnGlmpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297B2C433C7;
	Sun, 31 Dec 2023 21:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057212;
	bh=5Lfh0rBh3vvkrU87NkP0I+s1QzPbWlWH3zDE5ew+wVI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rmnGlmpxxhkMddfTay062eFtrqb7Yscj65qLOlrvRvx20A2q+8G32ztbWyuXvv7fE
	 OF7W5kaEuPrBnoI1bJO5NVYKmOVKjjgxBe1O+pWsoWzas06WHX/TyegqIzFhm+TGI3
	 mhuC1VN4f+rmT7jUhmtjCLAMQegyQFdCf6K73WvzEMutJttQ29XXcnkFi/Otk953kG
	 UFhLZEoJPLyiSdB/UXog2q/7oC3OO9CmOcrdngD6huVfmi7QuyPJfV+Hjp4A04F0O2
	 ZFCZucQAp74gD66oge1B+Vaxca4GyXRs9OqxpZTQmkuqo5gSZ+e8a9eJvAmBmR+Vl4
	 MnlcnL8TmP7pQ==
Date: Sun, 31 Dec 2023 13:13:31 -0800
Subject: [PATCH 28/32] xfs: move repair temporary files to the metadata
 directory tree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845315.1760491.16432444288388530962.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Due to resource acquisition rules, we have to create the ondisk
temporary files used to stage a filesystem repair before we can acquire
a reference to the inode that we actually want to repair.  Therefore,
we do not know at tempfile creation time whether the tempfile will
belong to the regular directory tree or the metadata directory tree.

This distinction becomes important when the swapext code tries to figure
out the quota accounting of the two files whose mappings are being
swapped.  The swapext code assumes that accounting updates are required
for a file if dqattach attaches dquots.  Metadir files are never
accounted in quota, which means that swapext must not update the quota
accounting when swapping in a repaired directory/xattr/rtbitmap structure.

Prior to the swapext call, therefore, both files must be marked as
METADIR for dqattach so that dqattach will ignore them.  Add support for
a repair tempfile to be switched to the metadir tree and switched back
before being released so that ifree will just free the file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c   |    5 ++
 fs/xfs/scrub/tempfile.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h |    3 +
 3 files changed, 105 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 5a6681c6647c3..c6501101c925b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -38,6 +38,7 @@
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/health.h"
+#include "scrub/tempfile.h"
 
 /* Common code for the metadata scrubbers. */
 
@@ -1093,6 +1094,10 @@ xchk_setup_inode_contents(
 	if (error)
 		return error;
 
+	error = xrep_tempfile_adjust_directory_tree(sc);
+	if (error)
+		return error;
+
 	/* Lock the inode so the VFS cannot touch this file. */
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 583bbd5a02bc9..1dd7c4c5cff0f 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -22,6 +22,7 @@
 #include "xfs_swapext.h"
 #include "xfs_defer.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_imeta.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -173,6 +174,101 @@ xrep_tempfile_create(
 	return error;
 }
 
+/*
+ * Temporary files have to be created before we even know which inode we're
+ * going to scrub, so we assume that they will be part of the regular directory
+ * tree.  If it turns out that we're actually scrubbing a file from the
+ * metadata directory tree, we have to subtract the temp file from the root
+ * dquots and detach the dquots.
+ */
+int
+xrep_tempfile_adjust_directory_tree(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (!sc->tempip)
+		return 0;
+
+	ASSERT(sc->tp == NULL);
+	ASSERT(!xfs_is_metadir_inode(sc->tempip));
+
+	if (!sc->ip || !xfs_is_metadir_inode(sc->ip))
+		return 0;
+
+	xfs_ilock(sc->tempip, XFS_IOLOCK_EXCL);
+	sc->temp_ilock_flags |= XFS_IOLOCK_EXCL;
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		goto out_iolock;
+
+	xrep_tempfile_ilock(sc);
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+
+	/* Metadir files are not accounted in quota, so drop icount */
+	xfs_trans_mod_dquot_byino(sc->tp, sc->tempip, XFS_TRANS_DQ_ICOUNT, -1L);
+	xfs_imeta_set_iflag(sc->tp, sc->tempip);
+
+	error = xrep_trans_commit(sc);
+	if (error)
+		goto out_ilock;
+
+	xfs_qm_dqdetach(sc->tempip);
+out_ilock:
+	xrep_tempfile_iunlock(sc);
+out_iolock:
+	xrep_tempfile_iounlock(sc);
+	return error;
+}
+
+/*
+ * Remove this temporary file from the metadata directory tree so that it can
+ * be inactivated the normal way.
+ */
+STATIC int
+xrep_tempfile_remove_metadir(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (!sc->tempip || !xfs_is_metadir_inode(sc->tempip))
+		return 0;
+
+	ASSERT(sc->tp == NULL);
+
+	xfs_ilock(sc->tempip, XFS_IOLOCK_EXCL);
+	sc->temp_ilock_flags |= XFS_IOLOCK_EXCL;
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		goto out_iolock;
+
+	xrep_tempfile_ilock(sc);
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+
+	xfs_imeta_clear_iflag(sc->tp, sc->tempip);
+
+	/* Non-metadir files are accounted in quota, so bump bcount/icount */
+	error = xfs_qm_dqattach_locked(sc->tempip, false);
+	if (error)
+		goto out_cancel;
+
+	xfs_trans_mod_dquot_byino(sc->tp, sc->tempip, XFS_TRANS_DQ_ICOUNT, 1L);
+	xfs_trans_mod_dquot_byino(sc->tp, sc->tempip, XFS_TRANS_DQ_BCOUNT,
+			sc->tempip->i_nblocks);
+	error = xrep_trans_commit(sc);
+	goto out_ilock;
+
+out_cancel:
+	xchk_trans_cancel(sc);
+out_ilock:
+	xrep_tempfile_iunlock(sc);
+out_iolock:
+	xrep_tempfile_iounlock(sc);
+	return error;
+}
+
 /* Take IOLOCK_EXCL on the temporary file, maybe. */
 bool
 xrep_tempfile_iolock_nowait(
@@ -281,6 +377,7 @@ xrep_tempfile_rele(
 		sc->temp_ilock_flags = 0;
 	}
 
+	xrep_tempfile_remove_metadir(sc);
 	xchk_irele(sc, sc->tempip);
 	sc->tempip = NULL;
 }
diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
index e51399f595fe9..71c1b54599c30 100644
--- a/fs/xfs/scrub/tempfile.h
+++ b/fs/xfs/scrub/tempfile.h
@@ -10,6 +10,8 @@
 int xrep_tempfile_create(struct xfs_scrub *sc, uint16_t mode);
 void xrep_tempfile_rele(struct xfs_scrub *sc);
 
+int xrep_tempfile_adjust_directory_tree(struct xfs_scrub *sc);
+
 bool xrep_tempfile_iolock_nowait(struct xfs_scrub *sc);
 int xrep_tempfile_iolock_polled(struct xfs_scrub *sc);
 void xrep_tempfile_iounlock(struct xfs_scrub *sc);
@@ -42,6 +44,7 @@ static inline void xrep_tempfile_iolock_both(struct xfs_scrub *sc)
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 }
 # define xrep_is_tempfile(ip)		(false)
+# define xrep_tempfile_adjust_directory_tree(sc)	(0)
 # define xrep_tempfile_rele(sc)
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 

