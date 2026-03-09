Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F419B3EDAC1;
	Mon,  9 Mar 2026 19:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084268; cv=none; b=bDHF0e3ve5WMNW/1OMbVPzbCIZwzwR58vr/lx3jY+Lq0IlNFwZq8MOZdC9EujYBm4SanGVJCDo6tnH+JptOJNwEI/jBWwAEQPYD7aodRCczT6wdqQsmlqofzGU3bxtSa7w/+diCW2ivtAcP4zJWFF1PkTEwdKofgA2QfozdMOEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084268; c=relaxed/simple;
	bh=DJSVKyGg+4R0k6WRAuNIeBNAD9pdSqrckhsLvnGW8L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ye/0S/H4Y2g4Mo7gzYlrY2/Fyk1uF1qJdpk5jyBclL7UKybjdwu/oaFkp0m5n6xUQbIQquz7ZFxQ5q+w6t5RPHl3TqPtfZEa5a/gGYFDHgNrIp5NZionJieS5KzgQWbwY7TyrxkHLrRCHssRIu1NusedTh8J+A1nVRpQBpGWpow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Grn19QkK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Grn19QkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED76C2BCB0;
	Mon,  9 Mar 2026 19:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084267;
	bh=DJSVKyGg+4R0k6WRAuNIeBNAD9pdSqrckhsLvnGW8L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Grn19QkKj5XpSF3fVfFe9jhpynhhJbkH1HpjjsPMvNtLiRgaHBWl7hYjbE8y+UKHa
	 Gpxb8xC3TMlgOCWiYVCuZ1srjv2xRWkDQ7yodZPEumxG+Qj+wnSBxlM1zwoQhlLaWO
	 F6Da5wljSesnhgjWj0io2Sl1Te96tnH+a5Tx9/snzo1DO0YWICtuFp5nO6M/lKJWpa
	 cc6YTLg8NVTQ5ML50KHeDOEJatNiMWizF8B9qqKCb7t//TwL+ypU5A2wRJ/zYob3A+
	 KUbdgxrFrBEEwDyF41ZyGJM5pdGjM357a4JlszzJbrj/86JPKDKQJYHJDY8HC5PemN
	 3H89ld61kv1cg==
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
Subject: [PATCH v4 03/25] fsverity: generate and store zero-block hash
Date: Mon,  9 Mar 2026 20:23:18 +0100
Message-ID: <20260309192355.176980-4-aalbersh@kernel.org>
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

