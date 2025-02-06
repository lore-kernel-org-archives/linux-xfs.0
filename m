Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30222417C2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882560; cv=none; b=PLbEETfpoDE7GXyniu5Izm7ND4xJ4DFYdZWYXOytRymD2QWMSE7Ff/k6upAWAA76duJmmhZqlgzchm8wubJODpo5jmCWGP2lBJhBhh1a9jc1MfKj1dFsQIXt/NIkCyL/86NEEv1ANC240YlM13wLFXZ61YmlAUty2SXLFG8es4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882560; c=relaxed/simple;
	bh=JQpTnQQ1o3qvsJwOG8Dd6fzx2wR/t3VHQMW0Cqxi33o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aYAFfevGtIFnulNoFdgyhyN+v9KrDQgBCKofXkObWLYA20TVZNtl2ZTj1YcC1i1mPjNEycrY6IHijZaH7voAjLpmDaGFlOsA7Iqzk7fJcNeLR4Ef6U6io6gXfN/7k8BzmtZjfWbBisBYsbid2qKqw4ZmPCJav6cyBtdDVeJL/Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwmC3qkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwmC3qkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DDEC4CEDF;
	Thu,  6 Feb 2025 22:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882559;
	bh=JQpTnQQ1o3qvsJwOG8Dd6fzx2wR/t3VHQMW0Cqxi33o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AwmC3qktp7yufBElr2S5tZK8alazC4/sAfaMWmfpxhKs3AHt50ewcZ1ZLuwylqEDt
	 8guZgnsLRcBDJWp1C9HAgGVYt+3itTDaAhGV2CS04z3CiVWidoifhzozKLuzkcH0TT
	 i/dxP0tKXYI7CGqfW6IVx4itSkZz4kJdhMuTppSacZw7BoJ6Xpo9bDEmhZeUrFmSfV
	 y4GweIfKB0ohvH3xc2BXcGfDkqSdAthUsZLFDDOiafj31CMlzX8h2h8axIZ5U1VlxQ
	 xa9ct4+L0dw+L7DfN5CeZGYia3OrUtHXXD9zTXUVVfCqgG7sNUKbGT4+OHhrTN8JAd
	 hKKQE2abNCwYw==
Date: Thu, 06 Feb 2025 14:55:59 -0800
Subject: [PATCH 24/27] xfs_repair: reserve per-AG space while rebuilding rt
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088464.2741033.2066305894736213498.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Realtime metadata btrees can consume quite a bit of space on a full
filesystem.  Since the metadata are just regular files, we need to
make the per-AG reservations to avoid overfilling any of the AGs while
rebuilding metadata.  This avoids the situation where a filesystem comes
straight from repair and immediately trips over not having enough space
in an AG.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/libxfs.h |    1 +
 repair/phase6.c  |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)


diff --git a/include/libxfs.h b/include/libxfs.h
index 79f8e1ff03d3f5..82b34b9d81c3a7 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -101,6 +101,7 @@ struct iomap;
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_ag_resv.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/repair/phase6.c b/repair/phase6.c
index 2ddfd0526767e0..30ea19fda9fd87 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3540,10 +3540,41 @@ reset_quota_metadir_inodes(
 	libxfs_irele(dp);
 }
 
+static int
+reserve_ag_blocks(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag = NULL;
+	int			error = 0;
+	int			err2;
+
+	mp->m_finobt_nores = false;
+
+	while ((pag = xfs_perag_next(mp, pag))) {
+		err2 = -libxfs_ag_resv_init(pag, NULL);
+		if (err2 && !error)
+			error = err2;
+	}
+
+	return error;
+}
+
+static void
+unreserve_ag_blocks(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag = NULL;
+
+	while ((pag = xfs_perag_next(mp, pag)))
+		libxfs_ag_resv_free(pag);
+}
+
 void
 phase6(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
+	bool			reserve_perag;
+	int			error;
 	int			i;
 
 	parent_ptr_init(mp);
@@ -3588,6 +3619,17 @@ phase6(xfs_mount_t *mp)
 		do_warn(_("would reinitialize metadata root directory\n"));
 	}
 
+	reserve_perag = xfs_has_realtime(mp) && !no_modify;
+	if (reserve_perag) {
+		error = reserve_ag_blocks(mp);
+		if (error) {
+			if (error != ENOSPC)
+				do_warn(
+	_("could not reserve per-AG space to rebuild realtime metadata"));
+			reserve_perag = false;
+		}
+	}
+
 	if (xfs_has_rtgroups(mp))
 		reset_rt_metadir_inodes(mp);
 	else
@@ -3596,6 +3638,9 @@ phase6(xfs_mount_t *mp)
 	if (xfs_has_metadir(mp) && xfs_has_quota(mp) && !no_modify)
 		reset_quota_metadir_inodes(mp);
 
+	if (reserve_perag)
+		unreserve_ag_blocks(mp);
+
 	mark_standalone_inodes(mp);
 
 	do_log(_("        - traversing filesystem ...\n"));

