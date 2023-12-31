Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8072FC8D5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJv5PoHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F88C433C7;
	Sun, 31 Dec 2023 21:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057040;
	bh=VwDoZWVxmsNkIfWCtaIOwD+icYC3QVcUpwdWhXo3dE0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mJv5PoHh8bugT9NnXmIBPhQg+yCCLeAwWki6OnZfpgg+a1m77gCCPN6F2x+gWaUR/
	 BVe2qL48FbJbp1QJXlmohXhDBL0Vf4C4wYcPE/PBGEN2ofLMB8jeiVzyBl1I6hN3W1
	 6cp+2ru0Zl6g7621UO0naNpmlc4yp++F1wTZ4aB4iH4drgB+QYK5p+1J+alVMZL0sD
	 AWncl9hKVeq6fbsoBYpizrbCj8novA+Nb57iYO3MCsOtIXDPEfg0PxcqwjHx6VBS4O
	 TjFfDrJ/Il21lY+hY/WeQX97MLF79yoT7s3uatf5hwzGH9vTWPqKFegV9nLmehN62N
	 RvVmF7Sh6R6Xg==
Date: Sun, 31 Dec 2023 13:10:39 -0800
Subject: [PATCH 17/32] xfs: advertise metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845139.1760491.11721978835439036400.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Advertise the existence of the metadata directory feature; this will be
used by scrub to decide if it needs to scan the metadir too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    1 +
 fs/xfs/libxfs/xfs_sb.c |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 77fbca573e164..2e31fc2240e4b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -239,6 +239,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_METADIR	(1U << 29) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1U << 30) /* parent pointers */
 
 /* atomic file extent swap available to userspace */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 28f65753c0c5a..7a20b9b4bccb3 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1298,6 +1298,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	if (xfs_atomic_swap_supported(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP;
+	if (xfs_has_metadir(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 

