Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3538F49
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666744; cv=none; b=ZP/gCH3FfdED41lh1IfH6gOjv3/q3jhUYWZl4VBwJlX00mqENaThsJFsLA74f8J5TIVzxtDR8FboXOnDGR0CB+WsjryPRP5fvlUBsXnM6xEKyaC/lGZit+ydWJzMDGEiBxZA49rGQSANmvUN24IpOjWrAAEZoh8T7nlD+7rZgBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666744; c=relaxed/simple;
	bh=61zVf+O+FWTlDTD4BnwkBIqOTKOP+GgThDyFoNiZ2Lg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t+S0te1BE1Q1LSDw86LXk+VC9dXCggz4BTOtcUB/EW0SfEih5sCOvNwjph+36bPUWhR+HO1OO9yPGKuR4mkP+i1lIkNKWeMO4d1fGYBHTvRTg8Kt3nTds4a6mRiAexvRcS3vn3Mon80MkCN0yS9YyJ3MDc6ZA0+CBKTk5M4H5Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lB4AP9w9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lB4AP9w9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B65C4CECF;
	Wed, 27 Nov 2024 00:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666744;
	bh=61zVf+O+FWTlDTD4BnwkBIqOTKOP+GgThDyFoNiZ2Lg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lB4AP9w9gNHPcHlI7+yWq9jH9u0UV6m9Fx92kRc+Zq6UPZ/euXn9ejGxz8tymRAdp
	 HjbvYdn+SgWIFEXgNeu6LVhPSOxj0S+mESUEg3qPrjHldjXjEpCYJUK1buGARWYPqo
	 D5RmPe9B7IO8KGgxz9o14KPFQUTgM3dZfvkpBCXB/nNeLbIGb0WLT9+GMbjd1CpAOM
	 gv0o5ZIiUrNKD0uVFCZbVllp2/Dr0c3/xMcKXOI0gcdQlePAZms40gKPH2foePAoIw
	 hziXokGjiBG6+3VfWJ3pJi4QEK6amM4I4SExAp++J/QYTTZNul1WV13umvconTSEae
	 8hYTkYggTgVug==
Date: Tue, 26 Nov 2024 16:19:03 -0800
Subject: [PATCH 04/10] design: document the actual ondisk superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173266662270.996198.11685949385888873946.stgit@frogsfrogsfrogs>
In-Reply-To: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
References: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

struct xfs_dsb is the ondisk superblock, not struct xfs_sb.  Replace the
struct definition with the one for the the ondisk superblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../XFS_Filesystem_Structure/superblock.asciidoc   |  117 ++++++++++----------
 1 file changed, 58 insertions(+), 59 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/superblock.asciidoc b/design/XFS_Filesystem_Structure/superblock.asciidoc
index 16c31116ffafd4..79e8c30dc93e79 100644
--- a/design/XFS_Filesystem_Structure/superblock.asciidoc
+++ b/design/XFS_Filesystem_Structure/superblock.asciidoc
@@ -11,68 +11,67 @@ field follows.
 
 [source, c]
 ----
-struct xfs_sb
-{
-	__uint32_t		sb_magicnum;
-	__uint32_t		sb_blocksize;
-	xfs_rfsblock_t		sb_dblocks;
-	xfs_rfsblock_t		sb_rblocks;
-	xfs_rtblock_t		sb_rextents;
-	uuid_t			sb_uuid;
-	xfs_fsblock_t		sb_logstart;
-	xfs_ino_t		sb_rootino;
-	xfs_ino_t		sb_rbmino;
-	xfs_ino_t		sb_rsumino;
-	xfs_agblock_t		sb_rextsize;
-	xfs_agblock_t		sb_agblocks;
-	xfs_agnumber_t		sb_agcount;
-	xfs_extlen_t		sb_rbmblocks;
-	xfs_extlen_t		sb_logblocks;
-	__uint16_t		sb_versionnum;
-	__uint16_t		sb_sectsize;
-	__uint16_t		sb_inodesize;
-	__uint16_t		sb_inopblock;
-	char			sb_fname[12];
-	__uint8_t		sb_blocklog;
-	__uint8_t		sb_sectlog;
-	__uint8_t		sb_inodelog;
-	__uint8_t		sb_inopblog;
-	__uint8_t		sb_agblklog;
-	__uint8_t		sb_rextslog;
-	__uint8_t		sb_inprogress;
-	__uint8_t		sb_imax_pct;
-	__uint64_t		sb_icount;
-	__uint64_t		sb_ifree;
-	__uint64_t		sb_fdblocks;
-	__uint64_t		sb_frextents;
-	xfs_ino_t		sb_uquotino;
-	xfs_ino_t		sb_gquotino;
-	__uint16_t		sb_qflags;
-	__uint8_t		sb_flags;
-	__uint8_t		sb_shared_vn;
-	xfs_extlen_t		sb_inoalignmt;
-	__uint32_t		sb_unit;
-	__uint32_t		sb_width;
-	__uint8_t		sb_dirblklog;
-	__uint8_t		sb_logsectlog;
-	__uint16_t		sb_logsectsize;
-	__uint32_t		sb_logsunit;
-	__uint32_t		sb_features2;
-	__uint32_t		sb_bad_features2;
+struct xfs_dsb {
+	__be32		sb_magicnum;
+	__be32		sb_blocksize;
+	__be64		sb_dblocks;
+	__be64		sb_rblocks;
+	__be64		sb_rextents;
+	uuid_t		sb_uuid;
+	__be64		sb_logstart;
+	__be64		sb_rootino;
+	__be64		sb_rbmino;
+	__be64		sb_rsumino;
+	__be32		sb_rextsize;
+	__be32		sb_agblocks;
+	__be32		sb_agcount;
+	__be32		sb_rbmblocks;
+	__be32		sb_logblocks;
+	__be16		sb_versionnum;
+	__be16		sb_sectsize;
+	__be16		sb_inodesize;
+	__be16		sb_inopblock;
+	char		sb_fname[XFSLABEL_MAX];
+	__u8		sb_blocklog;
+	__u8		sb_sectlog;
+	__u8		sb_inodelog;
+	__u8		sb_inopblog;
+	__u8		sb_agblklog;
+	__u8		sb_rextslog;
+	__u8		sb_inprogress;
+	__u8		sb_imax_pct;
+	__be64		sb_icount;
+	__be64		sb_ifree;
+	__be64		sb_fdblocks;
+	__be64		sb_frextents;
+	__be64		sb_uquotino;
+	__be64		sb_gquotino;
+	__be16		sb_qflags;
+	__u8		sb_flags;
+	__u8		sb_shared_vn;
+	__be32		sb_inoalignmt;
+	__be32		sb_unit;
+	__be32		sb_width;
+	__u8		sb_dirblklog;
+	__u8		sb_logsectlog;
+	__be16		sb_logsectsize;
+	__be32		sb_logsunit;
+	__be32		sb_features2;
+	__be32		sb_bad_features2;
 
 	/* version 5 superblock fields start here */
-	__uint32_t		sb_features_compat;
-	__uint32_t		sb_features_ro_compat;
-	__uint32_t		sb_features_incompat;
-	__uint32_t		sb_features_log_incompat;
+	__be32		sb_features_compat;
+	__be32		sb_features_ro_compat;
+	__be32		sb_features_incompat;
+	__be32		sb_features_log_incompat;
+	__le32		sb_crc;
+	__be32		sb_spino_align;
+	__be64		sb_pquotino;
+	__be64		sb_lsn;
+	uuid_t		sb_meta_uuid;
+	__be64		sb_rrmapino;
 
-	__uint32_t		sb_crc;
-	xfs_extlen_t		sb_spino_align;
-
-	xfs_ino_t		sb_pquotino;
-	xfs_lsn_t		sb_lsn;
-	uuid_t			sb_meta_uuid;
-	xfs_ino_t		sb_rrmapino;
+	/* must be padded to 64 bit alignment */
 };
 ----
 *sb_magicnum*::

