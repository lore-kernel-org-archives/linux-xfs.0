Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A025466D
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998962; cv=none; b=AngD/mmzsINQUiGQYwrWJmDnyGPny4UuOUb87762tFsouH/Lta9lHggruiX4T87/12FneseEJ6AB5Att+SA5FF4eF2KbhaXmwX8exNk/+P8F0kSUo70W8knmD8bak1jnGSQNOvXaCjyk6YF4MIBt5oazb6dVghw8KFXYwd2WYoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998962; c=relaxed/simple;
	bh=mMi/G9zn+6Fz5fX/wG8ZRULif4pWOPN+5mqky3tt3KY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfTrr2bMayUWxWZYSJuzaBaAciImyYp2K7GUNjGW6H2pjXnoR2qv0QsebOc53I+fCoKO/K2fniHnKbJXBmXYz2670ZmtA8nLaRFzZnOYJFwAePLkSAXAlmypwTWsUSRcEGMqkkxSJIWMSCjgLj34bnqnnnx5GYUnzr6PQn4za1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXpcaKCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXpcaKCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF445C43394
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998962;
	bh=mMi/G9zn+6Fz5fX/wG8ZRULif4pWOPN+5mqky3tt3KY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eXpcaKCBcjb7w3Tm5FlzqPoc5Uk3lctkyky69dkA6UsF+wTPMgvYiy/YcHU+FDA2q
	 Zamr8UzCdxlthjrzru4gAYhEZXhbxryReSZ8JyMxPTb4LeRN8F1k67bmOrblXOHPF5
	 kMX8+8RMxMW35jBpPkPHmO4Vgk78ST5pZe6uQ+m7boLciUsKebPLZsP10uA1gFvXGd
	 KbcZiOHNHxvAjxl65uwXzDFGhqbU/PTKR5XhamxTgbme881o1B2PkeJIK5vSYhlDW5
	 TYI3bWaf0zUiGUysso9qUIHlSNbPyrs33RsXLLhLR1gQLKisSIWHmngVV/z33ClWd2
	 OZHWPB1TP5++g==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 07/35] xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
Date: Thu, 15 Feb 2024 13:08:19 +0100
Message-ID: <20240215120907.1542854-8-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: f29c3e745dc253bf9d9d06ddc36af1a534ba1dd0

XFS uses xfs_rtblock_t for many different uses, which makes it much more
difficult to perform a unit analysis on the codebase.  One of these
(ab)uses is when we need to store the length of a free space extent as
stored in the realtime bitmap.  Because there can be up to 2^64 realtime
extents in a filesystem, we need a new type that is larger than
xfs_rtxlen_t for callers that are querying the bitmap directly.  This
means scrub and growfs.

Create this type as "xfs_rtbxlen_t" and use it to store 64-bit rtx
lengths.  'b' stands for 'bitmap' or 'big'; reader's choice.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_format.h   | 2 +-
 libxfs/xfs_rtbitmap.h | 2 +-
 libxfs/xfs_types.h    | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 371dc0723..20acb8573 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -98,7 +98,7 @@ typedef struct xfs_sb {
 	uint32_t	sb_blocksize;	/* logical block size, bytes */
 	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks */
 	xfs_rfsblock_t	sb_rblocks;	/* number of realtime blocks */
-	xfs_rtblock_t	sb_rextents;	/* number of realtime extents */
+	xfs_rtbxlen_t	sb_rextents;	/* number of realtime extents */
 	uuid_t		sb_uuid;	/* user-visible file system unique id */
 	xfs_fsblock_t	sb_logstart;	/* starting block of log if internal */
 	xfs_ino_t	sb_rootino;	/* root inode number */
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index e2ea6d31c..b0a81fb8d 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -13,7 +13,7 @@
  */
 struct xfs_rtalloc_rec {
 	xfs_rtblock_t		ar_startext;
-	xfs_rtblock_t		ar_extcount;
+	xfs_rtbxlen_t		ar_extcount;
 };
 
 typedef int (*xfs_rtalloc_query_range_fn)(
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 713cb7031..9af98a975 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -32,6 +32,7 @@ typedef uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
 typedef uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
 typedef uint64_t	xfs_fileoff_t;	/* block number in a file */
 typedef uint64_t	xfs_filblks_t;	/* number of blocks in a file */
+typedef uint64_t	xfs_rtbxlen_t;	/* rtbitmap extent length in rtextents */
 
 typedef int64_t		xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
 
-- 
2.43.0

