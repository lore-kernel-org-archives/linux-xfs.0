Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCD13F0779;
	Mon,  9 Mar 2026 19:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084316; cv=none; b=rgxV1GxA5G/BafXPti5bF8uyPsp3Vh7Ktj2LYMNjNlhMtG3cth3MzsDGZ35JmvaXUNSGgiM6V//v89xIFezPALlgKCDGi6A30l1z78cXNY6pMo6Bygqr+Ze5IJZkX7Wt35sUmf31sNAxTBregobPaaOYktu07P1xyq+waNE0cPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084316; c=relaxed/simple;
	bh=D9tHpN0ySusK2IVoNRiWuE+mAax1BIOLz+bYiO+CmLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUY55JoAYXnOLiwrF05WhNkIWaggjJxjEz/eHtfBHZuN9UZBsrvTN5ch05TJvJp/pGsxWTjIejBvhsAYW1ocw8MLHq9cN7xkOw6rJ4Jd6r+kxwuZgv2ZZfxSr1pHSAomT8XXHeK4BRz+2CoQtE33k96WSpdgm6jfpGcIPVrvJEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S21fjmjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S21fjmjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5DFC4AF0B;
	Mon,  9 Mar 2026 19:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084316;
	bh=D9tHpN0ySusK2IVoNRiWuE+mAax1BIOLz+bYiO+CmLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S21fjmjFS3Xx7pW6BayG8nmDlH0044D+RAld8FzyLjxUo9pOJZlt/FrQHBNL35JM3
	 2LGULKp57+k0yr4rsirwDrHmUJ8s6QRvlFgyAoLMamzQzduO5qteXkAdkpaczMatqo
	 txlRrTOYi+/rDtjGe8xE5J5VqwvabWbKBaPBODXruUFcYt0zo7rV/u1PZqceyQT8lv
	 8NBVZSRT7iJN0oyx7+Hn6IcAvWyoGDLuiMheXJ9L9uOCZc2OGF/HJQchgYkia9yFdm
	 oIg0JWn5aMMzTa3G9VmVgUd9aCWuja4+HafVQbC3ZAKL2H+fFfKYHP/xIvCfsDr7jQ
	 hEdZXJI5bpeYA==
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
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v4 21/25] xfs: advertise fs-verity being available on filesystem
Date: Mon,  9 Mar 2026 20:23:36 +0100
Message-ID: <20260309192355.176980-22-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260309192355.176980-1-aalbersh@kernel.org>
References: <20260309192355.176980-1-aalbersh@kernel.org>
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
index 4401a5f16344..29de33fbd074 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1587,6 +1587,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_verity(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_VERITY;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.51.2

