Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630563;
	b=lzYVj5OS94QT1jgf7bq8bZOqCkrRCxWcR+ZvVdM+phjFnceiCoAwiusqdWlp5VO8OGI1
	 PouKMsrInnuHeBuQlqda8u688noJJhuF/ndBbUuUj8mNaSsCDejS+HGKgQC1DujC7/ud1
	 OIVhG3W5kedDSKh0cj5pIxPslFqEsdTXE6khamg7sgmSmAlPDiz41erNltqJDaNF22nAt
	 upjFU0ntmUSA4P/Ylj1Y9aik5kxsS2UC8dpEtdrqv8WVArlNP5nk0s1TawGPBpAusi9ee
	 7pPw/zAz4m6CoHy/TE2YJup87IcBG2OxpZA6tgb3Scgkm6tSuznP19TTy+VfJ6KfWGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=JvWOEUAl+wqbIrRtEd5PCRNmNVUhCPmiVP2hbrv3nBs=;
	b=ZuZsamPN7cmLGIw4d0EGf1H2ucP8Q32LtHEncpU57Z3bU18XuNw8P8HohsKKcLOF1YLv
	 rJKdhA5fjn6k7Kirnd1CK0LzABh8DfkdTOMbjcK4uXhQceMQup8rtHRAjdNJ9ZNuuyfH6
	 bSj1RWnTov/87LQ4YKJctUKgXiQ/4N8UrJ3T+AAGQsS8oHEZEh5zB2SD64zCeGgUkbBvi
	 VaLRNq+jKG4CwHXB/bhjGowxJtrO9BdaZIGp+X1z63oJ6j3jsCuhm/OGEE6Ihp7FTD4YZ
	 XCSnDdEIDTChLHo69kdvfLkcIpaZBgyg9OXhblWRnnHCQAHRU6mtljakkZxhyuewDNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ajKGUUy0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2100B606F217;
	Mon,  2 Nov 2026 14:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ajKGUUy0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29C51F00A16;
	Mon,  2 Nov 2026 14:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630562;
	bh=JvWOEUAl+wqbIrRtEd5PCRNmNVUhCPmiVP2hbrv3nBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajKGUUy0MlyPmslEdZu/7VLJghl97ISj4lL/6zbY9SqBoPUPu5LBXg1YfdWmRPsut
	 6goEMC7R1xWgSmgonFqDOCGfsw7rDqRlIIkxFr3j0aWSwZZacVNUpiVGycpzx/snyB
	 gr9vsgIVST6UM5Ygi03Sbs0iidYJcY1IclHlZUqer/s6Lkx+KWMQtIOtbEGO7Ya9Ue
	 sGahyjSFER2+cOa0EUGjQmj1y+kylPopRFmIcggURW0ZpHXQ4qNlf8D+hHfTeEXMBY
	 TEHnRAkZYx7dtpzFi4LSYuPo3kmQ+MfwREGlSGYDCRUZ3DNtNp0FmzbBE8GqXOv0S2
	 EFlhy/9LyG4pw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v18 13/15] xfs: check and repair the verity inode flag state
Date: Mon,  2 Nov 2026 15:41:43 +0100
Message-ID: <20261102144147.2393369-14-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102144147.2393369-1-aalbersh@kernel.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
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
a fsverity metadata validation error, clear the flag.  The usage model
for fsverity requires that any program that cares about verity state is
required to call statx/getflags to check that the flag is set after
opening the file, so clearing the flag will not compromise that model.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c       | 53 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h       |  2 ++
 fs/xfs/scrub/inode.c        |  7 +++++
 fs/xfs/scrub/inode_repair.c | 36 +++++++++++++++++++++++++
 4 files changed, 98 insertions(+)

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
index bb8d2bc008e0..1d21758e0df0 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -36,6 +36,10 @@ xchk_prepare_iscrub(
 
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
+	error = xchk_inode_setup_verity(sc);
+	if (error)
+		return error;
+
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
@@ -833,6 +837,9 @@ xchk_inode(
 	if (S_ISREG(VFS_I(sc->ip)->i_mode))
 		xchk_inode_check_reflink_iflag(sc, I_INO(sc->ip));
 
+	if (xchk_inode_verity_broken(sc->ip))
+		xchk_ino_set_corrupt(sc, sc->sm->sm_ino);
+
 	xchk_inode_check_unlinked(sc);
 
 	xchk_inode_xref(sc, I_INO(sc->ip), &di);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a9ccf763c059..e84eaa8178dc 100644
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
@@ -2198,6 +2204,27 @@ xrep_inode_reset_dquots(
 # define xrep_inode_reset_dquots(sc)		(0)
 #endif
 
+/*
+ * If this file is a fsverity file, xchk_prepare_iscrub or xrep_dinode_core
+ * should have activated it.  If it's still not active, then there's something
+ * wrong with the verity descriptor and we should turn it off.
+ */
+STATIC int
+xrep_inode_verity(
+	struct xfs_scrub	*sc)
+{
+	struct inode		*inode = VFS_I(sc->ip);
+
+	if (xchk_inode_verity_broken(sc->ip)) {
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_VERITY;
+		inode_set_flags(inode, 0, S_VERITY);
+
+		xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	}
+
+	return 0;
+}
+
 /* Repair an inode's fields. */
 int
 xrep_inode(
@@ -2247,6 +2274,15 @@ xrep_inode(
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

