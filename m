Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6A63EF650;
	Thu, 19 Mar 2026 17:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939815; cv=none; b=ehkjcrlMOLvMDzIwtqO2OKMFMRgCRvLcHb3FpKWDqyO6NCVOFOoNzvQbt/xGg8lIqLC2ZN3yJOzEqlnjN/PpEsnV/jRixcxJYe/GpnPONe/rClnaz3sv0G/I7MLsDV0LJ/TYa4lYKwYKUfqoS3rpbDs27epsB7MaZwNtsZmA7ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939815; c=relaxed/simple;
	bh=PTaJI0Gbjq9+G0KZ4tkbjCUIjBA+rKVjiDT0yYApVJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrAPfcFbaVzSaqSsDZ4D4vgXmlr0fs4BNPt3cyp7NSxA+RHzpZr7xUkRc1RaNdupNOEGDJf0prHG7A0IgdTGZuc9uCkDxxevHXM97MFEo1DwpPGy6K9jgxtopXo0qfuDcPay1MBs8RgGao0EQe2YMIcKv4Yk0og3NL8rrlvevvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0HleRTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0HleRTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267ADC19425;
	Thu, 19 Mar 2026 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939815;
	bh=PTaJI0Gbjq9+G0KZ4tkbjCUIjBA+rKVjiDT0yYApVJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0HleRTBn7rC+rjRl70KFrFM721Fm8x/DIMOJz44iVWo3ifNKXN8T/RkAQcrDCNJ/
	 OaKvOg4k8Jw35ejiexlYImuRDkckQ2XhLUroOgE3xoXwxGuEBmFpvKKtBI5Ruac8gE
	 HBfKDLb7RmrIfzmcsyQqrLknIprzam4az4SWMH+IpDCGjWnZAIVVmV2xNZGNbQAZy4
	 RcGN6srybJfDgTYwQMs6eYZfoMzVfIEnyeEKcXSzDDwyy8XaEW0pNerHaEMNLHVlN/
	 NJElNTqcmnwJ5xLsOO8SPeTgHoom/C5QPIjuDXYSrXeR+xTT7OoA+UTZJ1N9R2beak
	 x8qhzsaT46j3A==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v5 21/25] xfs: advertise fs-verity being available on filesystem
Date: Thu, 19 Mar 2026 18:02:08 +0100
Message-ID: <20260319170231.1455553-22-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Advertise that this filesystem supports fsverity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d165de607d17..ebf17a0b0722 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
+#define XFS_FSOP_GEOM_FLAGS_VERITY	(1 << 28) /* fs-verity */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a15510ebd2f1..222bbe5559df 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1590,6 +1590,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_verity(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_VERITY;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.51.2

