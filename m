Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE76D3C09F8
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871373; cv=none; b=RCcuTdVNRBp2I2YMWIk4MH9wt8hpwn8HO+mw9pLeuAzdK5WOVE14oW8eytrnW7/vkbgsuv38Cmbqq9zbj+f79I/8O2jt8E0Dh7O4E0xbjycqrsyKVVInoV1lFnyqBka0kVswmFpi9DLqz1oS4Obh5JCVvKAxthKr9mFXecXIERo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871373; c=relaxed/simple;
	bh=mAY9A+VnPXG/QhIUNz2V6Gf+KW9U3+qKu5N0T7BBhvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1n1IKxLEfnueYV1pQ/42W+stJ+jdxj2x4IiPsyM+g7CfZJBe+4htUjaf+Idl1HTl/hn5afqocPyl69U18gBuJ9AMibaXiUal0PWjcWjBnC4eiLg+7BznmlxRjxrFT6Poc/06VTpIwbpdD9QvaAkyqAuDCnXdT+pxkRky2ynSVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=joMA02sg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="joMA02sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19C41F000FF;
	Tue, 13 Oct 2026 06:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871372;
	bh=DcRard5r825Rfxok2vYWrkS4UG0zoJA0yW56d3l5Ry0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=joMA02sgMlIXwfBMHgWelLBLAA20UquvzDokaSr35lbSwDbVDuSZTOVWXW1i38qhM
	 j10aQpyIFO4ZmP2YcpJfIJVXWhP3Rl2iH2BAyC6mrf5Zv3KnLSYIQqCp8k4UuPzNU+
	 +ZSw8k/7BTLQr1AOhUD9TK4nYi50vAiV3dWo7nUYmI4WlSNjG97/IGVuE2LFK5RznH
	 qvNXDTcdlO6MrkELyLyWfn4LkUJL7fCEp5wuphZmZKRovtGs+MZK1U8Hq72IlwBLT7
	 jG3Wmz/1DootQhYnX5Zo5lGs2CMawf8VmJ6eIxwwaYNo39/dGWesBx6mDgKoMPbqMw
	 TRB9c9W53ob9g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 35/48] xfs: validate the inode item format header during recovery
Date: Tue, 13 Oct 2026 17:01:25 +1100
Message-ID: <20261013060204.3138690-36-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The inode item format header describes how many regions the item has and where
the inode lives on disk. Recovery trusted these values, guarding only a few of
them with asserts in the commit handler while walking the regions and reading
the inode buffer.

Validate the format header as the item is decoded, so the rest of recovery can
trust the region count and buffer location it describes. The header is
self-consistent with the fields it logs, and the buffer location is fixed by the
inode number, so both are checked here. Deriving the location uses xfs_imap()
with XFS_IMAP_NO_LOOKUP so recovery never issues an inode btree lookup.

The host format conversion is split into its own helper so validation always
runs against a host format header.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_inode_item_recover.c | 123 ++++++++++++++++++++++++++++++--
 1 file changed, 116 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 48acb0aa3b6c..8de41ed0bc2f 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -21,6 +21,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 #include "xfs_icache.h"
+#include "xfs_ialloc.h"
+#include "xfs_ag.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
@@ -343,29 +345,136 @@ xlog_recover_inode_validate_region(
  * format. A header already in host format is left in place.
  */
 static int
-xlog_recover_inode_validate_item(
-	struct xlog			*log,
+xlog_recover_inode_convert_format(
 	struct xlog_recover_item	*item)
 {
-	struct xfs_inode_log_format	*in_f;
+	struct xfs_inode_log_format	*ilfp;
 	int				error;
 
 	if (item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format))
 		return 0;
 
-	in_f = kmalloc_obj(struct xfs_inode_log_format, GFP_KERNEL | __GFP_NOFAIL);
-	error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
+	ilfp = kmalloc_obj(struct xfs_inode_log_format, GFP_KERNEL | __GFP_NOFAIL);
+	error = xfs_inode_item_format_convert(&item->ri_buf[0], ilfp);
 	if (error) {
-		kfree(in_f);
+		kfree(ilfp);
 		return error;
 	}
 
 	kvfree(item->ri_buf[0].iov_base);
-	item->ri_buf[0].iov_base = in_f;
+	item->ri_buf[0].iov_base = ilfp;
 	item->ri_buf[0].iov_len = sizeof(struct xfs_inode_log_format);
 	return 0;
 }
 
+/*
+ * The buffer location logged in the format header is fixed by the inode number,
+ * so derive it and check the header matches. The inode cluster geometry is not
+ * always resolvable by arithmetic, and a btree lookup cannot be run this early
+ * in recovery, so an unresolvable geometry only checks the buffer length.
+ */
+static int
+xlog_recover_inode_check_location(
+	struct xlog			*log,
+	struct xfs_inode_log_format	*ilfp)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_perag		*pag;
+	struct xfs_imap			imap;
+	xfs_daddr_t			blkno;
+	int				len;
+	int				error;
+
+	len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
+	if (ilfp->ilf_len != len) {
+		xfs_warn(mp,
+			"INODE: inode 0x%llx buffer length 0x%x does not match expected 0x%x recovered.",
+			ilfp->ilf_ino, ilfp->ilf_len, len);
+		return -EFSCORRUPTED;
+	}
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ilfp->ilf_ino));
+	error = xfs_imap(pag, NULL, ilfp->ilf_ino, &imap, XFS_IMAP_NO_LOOKUP);
+	xfs_perag_put(pag);
+	if (error == -EAGAIN)
+		return 0;
+	if (error)
+		return error;
+
+	blkno = XFS_AGB_TO_DADDR(mp, XFS_INO_TO_AGNO(mp, ilfp->ilf_ino),
+			imap.im_agbno);
+	if (ilfp->ilf_blkno != blkno) {
+		xfs_warn(mp,
+			"INODE: inode 0x%llx buffer block 0x%llx does not match expected 0x%llx recovered.",
+			ilfp->ilf_ino, ilfp->ilf_blkno, blkno);
+		return -EFSCORRUPTED;
+	}
+	if (ilfp->ilf_boffset != imap.im_boffset) {
+		xfs_warn(mp,
+			"INODE: inode 0x%llx buffer offset 0x%x does not match expected 0x%x recovered.",
+			ilfp->ilf_ino, ilfp->ilf_boffset, imap.im_boffset);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/*
+ * Validate the format header once it is in host format. The item size records
+ * how many regions the item should have, the set of logged fields fixes what
+ * that count must be, and the inode number fixes the buffer location, so all of
+ * these are checked against the header here.
+ */
+static int
+xlog_recover_inode_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_inode_log_format	*ilfp;
+	unsigned int			nregions;
+	int				error;
+
+	error = xlog_recover_inode_convert_format(item);
+	if (error)
+		return error;
+	ilfp = item->ri_buf[0].iov_base;
+
+	if (!xfs_verify_ino(log->l_mp, ilfp->ilf_ino)) {
+		xfs_warn(log->l_mp, "INODE: bad inode number 0x%llx recovered.",
+				ilfp->ilf_ino);
+		return -EFSCORRUPTED;
+	}
+
+	if (!(ilfp->ilf_fields & XFS_ILOG_CORE)) {
+		xfs_warn(log->l_mp,
+			"INODE: inode 0x%llx has no core logged, fields 0x%x recovered.",
+			ilfp->ilf_ino, ilfp->ilf_fields);
+		return -EFSCORRUPTED;
+	}
+
+	if (ilfp->ilf_size != item->ri_total) {
+		xfs_warn(log->l_mp,
+			"INODE: inode 0x%llx item size %u does not match region count %u recovered.",
+			ilfp->ilf_ino, ilfp->ilf_size, item->ri_total);
+		return -EFSCORRUPTED;
+	}
+
+	nregions = 2;
+	if (ilfp->ilf_fields & XFS_ILOG_DFORK)
+		nregions++;
+	if (ilfp->ilf_fields & XFS_ILOG_AFORK)
+		nregions++;
+	if (ilfp->ilf_size != nregions) {
+		xfs_warn(log->l_mp,
+			"INODE: inode 0x%llx item size %u does not match region count %u the fields 0x%x define.",
+			ilfp->ilf_ino, ilfp->ilf_size, nregions,
+			ilfp->ilf_fields);
+		return -EFSCORRUPTED;
+	}
+
+	return xlog_recover_inode_check_location(log, ilfp);
+}
+
 STATIC int
 xlog_recover_inode_commit_pass2(
 	struct xlog			*log,
-- 
2.55.0

