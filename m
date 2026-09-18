Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D12C4E781F;
	Fri, 18 Sep 2026 11:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730194; cv=none; b=f/x9dgcjrMM3TVz85/diluAoDiDOUkZN89NjiICfoiRxHDs6nDHs4h9LwuC5y+vvqEQDzHXmS1Yah4inz1jPBDnIkE7l5a1gAFN9bJ9H0kwUaePcTKdIkmgyNjMUMQze5eOP3ocNNldtqB+7swnzZKJLlXkpcNHQRmQGsHEvK7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730194; c=relaxed/simple;
	bh=XdXLbSHqZebfFL9O6p0DcFHcgDb9KEkwzYHwlFCKUaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S72qDsVADY9iSuMK6AvjnMbd+hrongjoVXWogSe1ZW3DYnqziPc/JI80P8UeCjOjqNdmhFP3yl9T1bJWnAwiMYVT2Qen64PVQYe69wY82nx/4QdwuCQx02lGUyqDG2BrDWko2hsPaQ4nz4+0S+0lxYYJTQoWILdnamEtnrmIM+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYoLo4xX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYoLo4xX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70641F0089A;
	Fri, 18 Sep 2026 11:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730192;
	bh=QInnqDD5jc6bE+5gjiyUNdUgRM86g68YjtdsLs+67xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYoLo4xXL0dFO5TV/w+9MtKO/jM00UvuAtonC+y8fulwk/A0sXs+SiD5TxzGJbj82
	 EHeqsGHn7iMQzodHqrMn1Bjx/FKhhqz6jmB280VyU4KYfOqKFHPP+N3AY/3EXVAopK
	 Y0y68llGa1hSYX+BxEoSi6Ip7R6OUF2Jo7DlwsllhVHDbaCtxJZ773AIWagimivWzr
	 L3klC9VwuiIHuHpAmsu/LkebiPkVbhQ9nnaFd/x7V5X3v1HsBnKPetxS+l/2K8joKy
	 U4QBG2rwF58t/RAN7syXtPPFjc1ekLVVR61RoPVoGUuoaIjbv+qcq8HyBvQS4GdVHM
	 EXz+53WdQDcNA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v16 13/21] xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in __xfs_bunmapi()
Date: Fri, 18 Sep 2026 13:15:25 +0200
Message-ID: <20260918111539.1003439-14-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260918111539.1003439-1-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The __xfs_bunmapi() is used to remove all extents past EOF. Add
XFS_BMAPI_UNWRITTEN to remove only unwritten extents, while leaving
written ones in place. This will be used in following patch to clean up
unwritten extents on fsverity inodes.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 +++++-
 fs/xfs/libxfs/xfs_bmap.h | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cc48f6e20e80..7ba76017ae56 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5280,6 +5280,10 @@ __xfs_bunmapi(
 		if (del.br_startoff + del.br_blockcount > end + 1)
 			del.br_blockcount = end + 1 - del.br_startoff;
 
+		if ((flags & XFS_BMAPI_UNWRITTEN) &&
+				del.br_state != XFS_EXT_UNWRITTEN)
+			goto skip;
+
 		if (!isrt || (flags & XFS_BMAPI_REMAP))
 			goto delete;
 
@@ -5414,7 +5418,7 @@ __xfs_bunmapi(
 			if (error)
 				goto error0;
 		}
-
+skip:
 		end = del.br_startoff - 1;
 nodelete:
 		/*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index d5f2729305fa..0f36431d9936 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -90,6 +90,9 @@ struct xfs_bmalloca {
 /* Try to align allocations to the extent size hint */
 #define XFS_BMAPI_EXTSZALIGN	(1u << 11)
 
+/* Process unwritten extents only. Used for unmapping */
+#define XFS_BMAPI_UNWRITTEN	(1u << 12)
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -102,7 +105,8 @@ struct xfs_bmalloca {
 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
 	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
 	{ XFS_BMAPI_NORMAP,	"NORMAP" },\
-	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }
+	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }, \
+	{ XFS_BMAPI_UNWRITTEN,	"UNWRITTEN" }
 
 
 static inline int xfs_bmapi_aflag(int w)
-- 
2.54.0

