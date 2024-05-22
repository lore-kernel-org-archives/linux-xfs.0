Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535DB4C89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347097; cv=none; b=pJiLt3zgB9/5jmuiC9ZeqRhIe4HyKWpTHZ2XPFoQq1Su5h3LiKdXNmIxDO4HIr7qIY5ARm2RU1g8SOB1/WLJ5BuHQf5Gscnsr8wgK9DZlh7c25PW3KZrP1DAyEIdUbT50O3QB4Q8TDSAE+Zu8658d88DViSaENqVpJVgDwvljt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347097; c=relaxed/simple;
	bh=/XydQVo7ATlWnWnE8RWDKVLEzustVT+D3PNwcpmZ0nk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qr+VNBPrTzPLyBkdz0U9dIQribxTga2qqVMM/3ZVPFr3q3uFSBHqLiIveam1jeG/bIMVX0xXoiQoT6jtpulaZb9f7enWZULk0njA7V1u5VwBWgrYic4sISwJsuHmDQiyeYnveNm+j0iPqAtuqgl/9PXIe+R7WFU0mNIdYq60vkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkXCv3MF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkXCv3MF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C20C2BD11;
	Wed, 22 May 2024 03:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347097;
	bh=/XydQVo7ATlWnWnE8RWDKVLEzustVT+D3PNwcpmZ0nk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hkXCv3MFtiwawYzxow/S6T8y3eo1KbEWFhUhggNHrb96QKQEQE4TQ3I0pPJqWcZ/J
	 k8eTUajc0YkBeA+cTDWFNR4ctgV2DpWfQYSXlHpfeuwYxZqWIdtJp4VYCyITKhecq1
	 Th1emj5lXRmLe47N9LRHh24N/5S6jkN76XjK94HMuv7vJxUDCzrR8VtDxPg4jmuRqh
	 T+6oMNC1bKC1uT7ImDiKCyZYKsgKoAlNyvXcw31A6OQBT9OHMtFvHynda+AP57glXQ
	 FAqw/3VnzvEOkpFkYS0wqyxwEdh66WNkCDNUYbjCAPfCPyU+OQC6OIeUhiCOQvm/V8
	 aezMBJP9iz4Bw==
Date: Tue, 21 May 2024 20:04:56 -0700
Subject: [PATCH 062/111] xfs: make staging file forks explicit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532628.2478931.17124610217916498335.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 42e357c806c8c0ffb9c5c2faa4ad034bfe950d77

Don't open-code "-1" for whichfork when we're creating a staging btree
for a repair; let's define an actual symbol to make grepping and
understanding easier.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap_btree.c |    2 +-
 libxfs/xfs_types.h      |    8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index dedc33dc5..6b377d129 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -613,7 +613,7 @@ xfs_bmbt_stage_cursor(
 	cur = xfs_bmbt_init_common(mp, NULL, ip, XFS_DATA_FORK);
 
 	/* Don't let anyone think we're attached to the real fork yet. */
-	cur->bc_ino.whichfork = -1;
+	cur->bc_ino.whichfork = XFS_STAGING_FORK;
 	xfs_btree_stage_ifakeroot(cur, ifake);
 	return cur;
 }
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 62e02d538..a1004fb3c 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -80,11 +80,13 @@ typedef void *		xfs_failaddr_t;
 /*
  * Inode fork identifiers.
  */
-#define	XFS_DATA_FORK	0
-#define	XFS_ATTR_FORK	1
-#define	XFS_COW_FORK	2
+#define XFS_STAGING_FORK	(-1)	/* fake fork for staging a btree */
+#define	XFS_DATA_FORK		(0)
+#define	XFS_ATTR_FORK		(1)
+#define	XFS_COW_FORK		(2)
 
 #define XFS_WHICHFORK_STRINGS \
+	{ XFS_STAGING_FORK, 	"staging" }, \
 	{ XFS_DATA_FORK, 	"data" }, \
 	{ XFS_ATTR_FORK,	"attr" }, \
 	{ XFS_COW_FORK,		"cow" }

