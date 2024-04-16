Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8834C7E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230482; cv=none; b=oyfprT2ls6ArXpZsbsvDkTX/NkWMeL7/V1Xc4R1u3mwCoytGupK0PncVb/YsyUb+okCloRi7EsWd0Fk03DMm1M29/bOyomsHbK2HqRDSBORXpJTxfgxwd2qDtE1wtTx6oZe2EQ/5Kor+Ia38Yy5I1M/MASc/2kIdyIVHaTndtRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230482; c=relaxed/simple;
	bh=ivC6YbDRY4r+UqZOusiNv8XtVL0yLoMjOlm0LOkO2TU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GGKI4T8k0R4qRe695ul8vu75DbPSY0M7N9aRVqFhGSRj6GMQOvcMglB3rod/j84njLoFxM9ULZSz7Il/V0+UKXvO1eQnw71L24qh2IFdedMi9FpDD1S49FepLbfPPLmKkd2kkJCuSZ+3MLoRlaRWoo/Kqn2/6F+Mm5qOC6DUxg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lYS0zrUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lYS0zrUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F320C113CC;
	Tue, 16 Apr 2024 01:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230481;
	bh=ivC6YbDRY4r+UqZOusiNv8XtVL0yLoMjOlm0LOkO2TU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lYS0zrUc8JFOg1N0x8ViH9/tCm9L3OM4x/aQT8nblp3KAK+cPcxD0qWb98adk0LAn
	 woDalaybVSLE+Z9hVjZO++f3dJhnU/43ZKMS6RtkC+XirTg0ORa4Osaiy0RKxlaCi8
	 dxX6fRQJxbAklR4My42PKFGeIX2BuIB0nIKzYH/uaGV2tGXRKQwcBAhgdujKUTRIsE
	 NOjCZj9qx/sisnEK1H8gDtKpWPzXiBTBSE1i7pbZEEjV4FIEX5C8AqkiO2/KmzCDLP
	 PZR6pxFZXxsi0ooERzU1vmSQ8SAhzLUmeoCR8iYANWuFGj4ES2kT8Gmq0fvtkhn+5+
	 vvA/f8s8ZeqjA==
Date: Mon, 15 Apr 2024 18:21:21 -0700
Subject: [PATCH 1/5] xfs: remove XFS_DA_OP_REMOVE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323026604.250975.7157977870422035545.stgit@frogsfrogsfrogs>
In-Reply-To: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
References: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
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

Nobody checks this flag, so get rid of it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.h     |    1 -
 fs/xfs/libxfs/xfs_da_btree.h |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index e4f55008552b4..670ab2a613fc6 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -590,7 +590,6 @@ xfs_attr_init_add_state(struct xfs_da_args *args)
 static inline enum xfs_delattr_state
 xfs_attr_init_remove_state(struct xfs_da_args *args)
 {
-	args->op_flags |= XFS_DA_OP_REMOVE;
 	if (xfs_attr_is_shortform(args->dp))
 		return XFS_DAS_SF_REMOVE;
 	if (xfs_attr_is_leaf(args->dp))
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 7a004786ee0a2..76e764080d994 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -91,9 +91,8 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
 #define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
-#define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation */
-#define XFS_DA_OP_RECOVERY	(1u << 7) /* Log recovery operation */
-#define XFS_DA_OP_LOGGED	(1u << 8) /* Use intent items to track op */
+#define XFS_DA_OP_RECOVERY	(1u << 6) /* Log recovery operation */
+#define XFS_DA_OP_LOGGED	(1u << 7) /* Use intent items to track op */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -102,7 +101,6 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
 	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
-	{ XFS_DA_OP_REMOVE,	"REMOVE" }, \
 	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
 	{ XFS_DA_OP_LOGGED,	"LOGGED" }
 

