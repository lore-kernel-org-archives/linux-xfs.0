Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0D02170B2
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 23:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731021947; cv=none; b=EmFEg37rorC7xh+mBsYHWijR9pngB38teED3I+gw3oGx2cAqEtbYnAQVc/6lA/FuybmKj56HXZnCB3CeENaUWXjcNco9RH5N6e+nYIZgYFzNwu84R1PbEdGsJzVLqjbtCrPYvrsPo7Z/ItaTZ6siF47xo9tY1TduAMDC7jw3HMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731021947; c=relaxed/simple;
	bh=JWv0NNeQsiKEbj7Zf9R9sGmOI9bDLv5yQp5Gvavx/98=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RMuZ6Mf7tNSCrttmrt/yP8IzBhaEqBll409KqWlyzWRKYSPX4GcNILsPQHewIKU+dO4HOAVKPLrJjEv6uBWiTLsx3eMZhg51yLC/DJfIqpypbUI/cdRsQTGIYpBTKQ4Fbdz/JOc6O7/ru+i0l68FygR4iQClGMMchDZ2noS7Hbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=coJDt+8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="coJDt+8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E96C4CECC;
	Thu,  7 Nov 2024 23:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731021946;
	bh=JWv0NNeQsiKEbj7Zf9R9sGmOI9bDLv5yQp5Gvavx/98=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=coJDt+8Gkoyy8Z6drO/tqNJb41fjiKvUUVifG9olSFp8PG3F95R9CV4oksqRphv4T
	 b0GmXHhQnOlM3WKrUb5ZH18Tv1jKxZBh/JFRILoezv1fEzA9IwpaE4xPVCUfEy6dr8
	 lpqRsLhv4vj8ofejfWopeEwjdzHYr6ofyYWHXdAklSPN7Qhivpts04wnA5S/MQB3/M
	 BPOUoxeAM7qtOCarW/IkurC3EPvbzx6jqIHMi1XzMGz+18bAbznSr4/SKDWLEJHND+
	 9CzWXQFj5s8JcGXBNEkb5ZzlqP0rSzw5NPFALXvddKIFFQUCrbryWeUTP85aqAeYA1
	 99+y5e4jiMR1A==
Date: Thu, 07 Nov 2024 15:25:46 -0800
Subject: [PATCH 2/3] design: document the actual ondisk superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173102187499.4143835.3167579348779056213.stgit@frogsfrogsfrogs>
In-Reply-To: <173102187468.4143835.2187727613598371946.stgit@frogsfrogsfrogs>
References: <173102187468.4143835.2187727613598371946.stgit@frogsfrogsfrogs>
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

