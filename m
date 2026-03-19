Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A943630A9;
	Thu, 19 Mar 2026 17:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939768; cv=none; b=cmvDmivI5ObSajaB7Sn+A8I9UvmCAHshR2UXy5fN0fLtbrJft7yya8mQcwnmTdDdndB6QgpoA9dWBrk3K8jVjbxlSaZ/XG9bMvwD4E9aMu+pTyUNnjjKTKLsLlxCs7ZTbLJBZNtZ7rEWhMKB/X4ViQwv58dEQZaPk9yOuLtLDbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939768; c=relaxed/simple;
	bh=DJSVKyGg+4R0k6WRAuNIeBNAD9pdSqrckhsLvnGW8L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoVrw1DFWl8U8qSjSmbainakKHupik72nSxZ9d4Lluhhex3okerH55GswrBd76ZCm6qHUyQ/9+OpyMSr0iNfGZEl19v4bDAi4bN5rfcXpdnN+cDPAFHNb3+o318RvJ4t4DDuTl2c00gkjdmWLuJR4lLSgiQp6r2eJrLGSwKNrQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iu62A25X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iu62A25X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEA8C2BCAF;
	Thu, 19 Mar 2026 17:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939768;
	bh=DJSVKyGg+4R0k6WRAuNIeBNAD9pdSqrckhsLvnGW8L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iu62A25XmdgGDJwUm3pyv7XhtJSzMaYt3ZE/zOnD4ewJhbp1jpwQlhTVQmckexfEx
	 bgwV+bmU9har0cROHRgHod18toS7Gq/hZCzuPck1xjKdPt4DYvLAUx42g4DbvffEQg
	 4N6b+EvVdIBdG+xrYebiteWCjayTLcaV2P57KwS3xqXx0pzYuGHXP3lfm18VSa42Dg
	 3MA241YVB3HK5KvEYsOIP+jv+hGRYcDNEw3oSVdq0IcixgCppIJOX+NqraXQAPxBzS
	 5kioHeXvChxNLAiLUjaL6UuG1IOZdblCBp2BrcmyMHMWk9EkcXzd4pNSRrEH9NZD++
	 IjhkNjYVg7wIw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v5 03/25] fsverity: generate and store zero-block hash
Date: Thu, 19 Mar 2026 18:01:50 +0100
Message-ID: <20260319170231.1455553-4-aalbersh@kernel.org>
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

Compute the hash of one filesystem block's worth of zeros. A filesystem
implementation can decide to elide merkle tree blocks containing only
this hash and synthesize the contents at read time.

Let's pretend that there's a file containing six data blocks and whose
merkle tree looks roughly like this:

root
 +--leaf0
 |   +--data0
 |   +--data1
 |   `--data2
 `--leaf1
     +--data3
     +--data4
     `--data5

If data[0-2] are sparse holes, then leaf0 will contain a repeating
sequence of @zero_digest.  Therefore, leaf0 need not be written to disk
because its contents can be synthesized.

A subsequent xfs patch will use this to reduce the size of the merkle
tree when dealing with sparse gold master disk images and the like.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/verity/fsverity_private.h | 3 +++
 fs/verity/open.c             | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index 6e6854c19078..35636c1e2c41 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -53,6 +53,9 @@ struct merkle_tree_params {
 	u64 tree_size;			/* Merkle tree size in bytes */
 	unsigned long tree_pages;	/* Merkle tree size in pages */
 
+	/* the hash of a merkle block-sized buffer of zeroes */
+	u8 zero_digest[FS_VERITY_MAX_DIGEST_SIZE];
+
 	/*
 	 * Starting block index for each tree level, ordered from leaf level (0)
 	 * to root level ('num_levels - 1')
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 0483db672526..94407a37aa08 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -153,6 +153,9 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
 		goto out_err;
 	}
 
+	fsverity_hash_block(params, page_address(ZERO_PAGE(0)),
+			    params->zero_digest);
+
 	params->tree_size = offset << log_blocksize;
 	params->tree_pages = PAGE_ALIGN(params->tree_size) >> PAGE_SHIFT;
 	return 0;
-- 
2.51.2

