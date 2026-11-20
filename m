Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190335;
	b=M7fDfsWe/FnOjygRPo17oRTXANYJAE6/i61EKTLIWntOvatFkwIz88ClvRKRz6qfVAyq
	 x3QcMoZJHnRgInCqjhJqxwCAkgjG0Y81lvma/seGjdAW9yiC2lhBBycSTY8BiG19r4zjm
	 z3tDHtLunboHJHw7FY/y2ijB9etPHXRSFzAudJ8d0eB8MbZrYML5Wd1jwAp4myO8daEVA
	 d0LkR+s5sy6+UhJcv0QIldrclIhs+nE7lhwSiTEpZUDcs5LPIOtCoRLTuktY4WJX9B4rW
	 Bftcf/DQpvSvCPjz3FmHyVWoCawsb5ta2VURTQAW1a0V48yx69LLc+mpxVQVaov05/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qsuuKsHBlRYoQ/QhL3r9lDZ6r8D1XoBntvdHiaGBJTY=;
	b=X27576zoVzfBf1RDtGAZBtNlmA+p9dS0kiYOXSrF0zT2bdvZgKR59kiq2GCqkR6kpKbV
	 wBXMaa/kw2FPUepvlAX5y+GL5eHFJOe/164Qu2NdloMO4lQXyE+3i1Qrd59rd45e71qsb
	 jhwhqklgdMbJ0MDMw7h/avETyqL2Vy/OLi0Kr0cGc1Lep3jJjqlcja30T1a7JAYgOpCls
	 4uiMbSZPBejt3ISAQHzHIyf7snDaenynTLw+0rxqsn6YqC7YvJi2zyzY2vXs/4UnfXbqR
	 cx1nDK8mq1pOqX/e/bnFzxyhSa2TVOgliQIlHsuyHYjLWnlFQ0K/Ymp8pfFmcDgw5Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wg27zlpd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2268F606A33A;
	Fri, 20 Nov 2026 15:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wg27zlpd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFCD1F000EB;
	Fri, 20 Nov 2026 15:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190334;
	bh=qsuuKsHBlRYoQ/QhL3r9lDZ6r8D1XoBntvdHiaGBJTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wg27zlpdDoy8Drw8zifnvXt0qEBjBVw4W4eLy/10BZe0ZYPVVzs+gVTjJhXlId3kg
	 AGiWSBhsKg8dOE/F5O32MGk7UGASERlIxcmgZ/Mp47i1O1uoh7GhV04UIqSHLvDgax
	 Rt0JAtXuJSWNeLUaVS6NSaG9sVZ2TK7jn6dfhHwqU8XNPO0peqLo5kpXTfpFm6eMsX
	 eCCUcIvnaXA1t8jtaP0auO55IVrsN3s47zn1rupqKgVO4+rVh9EZnz+nwbVFRrr7VT
	 eXInwa1VYeKXxbaj1gg3q/KEoRzl6aYIgZvjQeLa+M4Js7AV2vx9pQijY3Z/2wZBJp
	 giXBNVzV9863w==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v19 13/15] xfs: check and repair the verity inode flag state
Date: Fri, 20 Nov 2026 16:57:47 +0100
Message-ID: <20261120155752.192025-14-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155752.192025-1-aalbersh@kernel.org>
References: <20261120155752.192025-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

If an inode has the incore verity iflag set, make sure that we can
actually activate fsverity on that inode.  If activation fails due to
a fsverity metadata validation error, clear the flag and delete
fs-verity metadata. The usage model for fsverity requires that any
program that cares about verity state is required to call statx/getflags
to check that the flag is set after opening the file, so clearing the
flag will not compromise that model.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/scrub/common.c       | 53 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h       |  2 ++
 fs/xfs/scrub/inode.c        | 22 +++++++++++++++
 fs/xfs/scrub/inode_repair.c | 49 ++++++++++++++++++++++++++++++++++
 4 files changed, 126 insertions(+)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index cbfe5e6f779d..fb0ae227df54 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -45,6 +45,8 @@
 #include "scrub/health.h"
 #include "scrub/tempfile.h"
 
+#include <linux/fsverity.h>
+
 /* Common code for the metadata scrubbers. */
 
 /*
@@ -1765,3 +1767,54 @@ xchk_inode_count_blocks(
 	return xfs_bmap_count_blocks(sc->tp, sc->ip, whichfork, nextents,
 			count);
 }
+
+/*
+ * If this inode has S_VERITY set on it, read the verity info. If the reading
+ * fails with anything other than ENOMEM, the file is corrupt, which we can
+ * detect later with fsverity_active.
+ *
+ * Callers must hold the IOLOCK and must not hold the ILOCK of sc->ip because
+ * activation reads inode data.
+ */
+int
+xchk_inode_setup_verity(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (!fsverity_active(VFS_I(sc->ip)))
+		return 0;
+
+	error = fsverity_ensure_verity_info(VFS_I(sc->ip));
+	switch (error) {
+	case 0:
+		/* fsverity is active */
+		break;
+	case -ENODATA:
+	case -EMSGSIZE:
+	case -EFSCORRUPTED:
+	case -ERANGE:
+	case -EBADMSG:
+		/*
+		 * The nonzero errno codes above are the error codes that can
+		 * be returned from fsverity on metadata validation errors.
+		 */
+		return 0;
+	default:
+		/* runtime errors */
+		return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Is this a verity file that failed to activate?  Callers must have tried to
+ * activate fsverity via xchk_inode_setup_verity.
+ */
+bool
+xchk_inode_verity_broken(
+	struct xfs_inode	*ip)
+{
+	return fsverity_active(VFS_I(ip)) && !fsverity_get_info(VFS_I(ip));
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 181028f0c655..b59d4792a805 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -261,6 +261,8 @@ int xchk_inode_is_allocated(struct xfs_scrub *sc, xfs_agino_t agino,
 		bool *inuse);
 int xchk_inode_count_blocks(struct xfs_scrub *sc, int whichfork,
 		xfs_extnum_t *nextents, xfs_filblks_t *count);
+int xchk_inode_setup_verity(struct xfs_scrub *sc);
+bool xchk_inode_verity_broken(struct xfs_inode *ip);
 
 bool xchk_inode_is_dirtree_root(const struct xfs_inode *ip);
 bool xchk_inode_is_sb_rooted(const struct xfs_inode *ip);
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index bb8d2bc008e0..931c677d7ac8 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -33,9 +33,28 @@ xchk_prepare_iscrub(
 	struct xfs_scrub	*sc)
 {
 	int			error;
+	struct xfs_inode	*ip = sc->ip;
 
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
+	error = xchk_inode_setup_verity(sc);
+	if (error)
+		return error;
+
+	/*
+	 * If we're going to repair a file whose fsverity descriptor cannot be
+	 * activated, drop the stale Merkle tree folios. Once the
+	 * post-EOF Merkle extents are freed during repair, those uptodate
+	 * folios would otherwise sit over a hole and could be exposed as file
+	 * data by a later extending write or truncate.
+	 *
+	 * The lock would be unlocked by global scrub machinery.
+	 */
+	if (xchk_could_repair(sc) && xchk_inode_verity_broken(ip)) {
+		xchk_ilock(sc, XFS_MMAPLOCK_EXCL);
+		truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
+	}
+
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
@@ -833,6 +852,9 @@ xchk_inode(
 	if (S_ISREG(VFS_I(sc->ip)->i_mode))
 		xchk_inode_check_reflink_iflag(sc, I_INO(sc->ip));
 
+	if (xchk_inode_verity_broken(sc->ip))
+		xchk_ino_set_corrupt(sc, sc->sm->sm_ino);
+
 	xchk_inode_check_unlinked(sc);
 
 	xchk_inode_xref(sc, I_INO(sc->ip), &di);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a9ccf763c059..ddf3c3dce2f9 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -577,6 +577,8 @@ xrep_dinode_flags(
 		dip->di_nrext64_pad = 0;
 	else if (dip->di_version >= 3)
 		dip->di_v3_pad = 0;
+	if (!xfs_has_verity(mp) || !S_ISREG(mode))
+		flags2 &= ~XFS_DIFLAG2_VERITY;
 
 	if (flags2 & XFS_DIFLAG2_METADATA) {
 		xfs_failaddr_t	fa;
@@ -1659,6 +1661,10 @@ xrep_dinode_core(
 	if (iget_error)
 		return iget_error;
 
+	error = xchk_inode_setup_verity(sc);
+	if (error)
+		return error;
+
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
@@ -2198,6 +2204,40 @@ xrep_inode_reset_dquots(
 # define xrep_inode_reset_dquots(sc)		(0)
 #endif
 
+/*
+ * If this file is a fsverity file, xchk_prepare_iscrub or xrep_dinode_core
+ * should have activated it.  If it's still not active, then there's something
+ * wrong with the verity descriptor, so turn verity off and free the orphaned
+ * Merkle tree that XFS keeps in extents beyond EOF.
+ */
+STATIC int
+xrep_inode_verity(
+	struct xfs_scrub	*sc)
+{
+	struct inode		*inode = VFS_I(sc->ip);
+	struct xfs_mount	*mp = sc->mp;
+	int			error;
+
+	if (!xchk_inode_verity_broken(sc->ip))
+		return 0;
+
+	/*
+	 * The fsverity descriptor cannot be activated, so disable verity and
+	 * free the Merkle tree, which XFS stores in beyond EOF. The stale
+	 * Merkle tree page cache was already dropped during scrub setup.
+	 */
+	error = xfs_bunmapi_range(&sc->tp, sc->ip, 0,
+			XFS_B_TO_FSB(mp, XFS_ISIZE(sc->ip)), XFS_MAX_FILEOFF);
+	if (error)
+		return error;
+
+	sc->ip->i_diflags2 &= ~XFS_DIFLAG2_VERITY;
+	inode_set_flags(inode, 0, S_VERITY);
+
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	return 0;
+}
+
 /* Repair an inode's fields. */
 int
 xrep_inode(
@@ -2247,6 +2287,15 @@ xrep_inode(
 			return error;
 	}
 
+	/*
+	 * Disable fsverity if it cannot be activated.  Activation failure
+	 * prohibits the file from being opened, so there cannot be another
+	 * program with an open fd to what it thinks is a verity file.
+	 */
+	error = xrep_inode_verity(sc);
+	if (error)
+		return error;
+
 	/* Reconnect incore unlinked list */
 	error = xrep_inode_unlinked(sc);
 	if (error)
-- 
2.54.0

