Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4748C22257E
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 16:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760373191; cv=none; b=LSVGsxqubVvqkCaGQnwVad9yZcv1UwwGjYrQDqRiyfhwDeO5/g5CkI+DPq0zrY+gX6Tvn9F2GXmyuRDa5MJbDdq5WkCGuUNdd8ZJDBLf1rDXB1UPxCobbin52kSSE5uzxG1YYUXLylYPwynGkEncAmkwADf2QsZGDQfRHiV/RDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760373191; c=relaxed/simple;
	bh=vTsdgGBAemS17YM2RxtMpAsij1lU8pzkjpNcMnFtO/s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bv0QwY7RieiS/Wkuzzmh6DKbh0qGvd3IVwv4Htat1flj2sKMH0GRv218J0PEK1uHPedgMpJWGzWIMyqIqnubLDDbibLZhSgSX5qk7GlsK10kfsggiVmb1XcKMin82prTh1AqlWVPWcZ9AY8kDCMpKXPG04RUi45F2b4eqRwxmfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=My25X3Yv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="My25X3Yv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE517C4CEE7;
	Mon, 13 Oct 2025 16:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760373190;
	bh=vTsdgGBAemS17YM2RxtMpAsij1lU8pzkjpNcMnFtO/s=;
	h=Date:From:To:Cc:Subject:From;
	b=My25X3Yvk/609iFH4rZMc0dl9QoQjboGPaLcKA3d1cD9A4Q/dU07zJOvjIx4GOdRJ
	 4jYYxKWj7DY3qqj7qtJy1RlsgreDye2N7qLczu+XKPfDAFUYRzWG/JLYzFnjDQ3n4z
	 MRw42s87J1FF/chKpqVFOQPBIgPa2SCNuYeTOJaZPAMgb+2K0Hs4EbsycW2Ru9MN6R
	 Odq3JR8vePOpg6LWA+T6XCklZ74q95C61gCpMt8vM/N4sKmHEqe8SOwqJKCt4NaC4N
	 ya1+D7EjAYv3JUXOphwAXt0pNrerG36nOQOK+8xddqtW3BTZTqOsJ9glWdZlixcHgN
	 MNL9PEUVfgNCA==
Date: Mon, 13 Oct 2025 09:33:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: don't set bt_nr_sectors to a negative number
Message-ID: <20251013163310.GM6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

xfs_daddr_t is a signed type, which means that xfs_buf_map_verify is
using a signed comparison.  This causes problems if bt_nr_sectors is
never overridden (e.g. in the case of an xfbtree for rmap btree repairs)
because even daddr 0 can't pass the verifier test in that case.

Define an explicit max constant and set the initial bt_nr_sectors to a
positive value.

Found by xfs/422.

Cc: <stable@vger.kernel.org> # v6.18-rc1
Fixes: 42852fe57c6d2a ("xfs: track the number of blocks in each buftarg")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.h |    1 +
 fs/xfs/xfs_buf.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8fa7bdf59c9110..e25cd2a160f31c 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -22,6 +22,7 @@ extern struct kmem_cache *xfs_buf_cache;
  */
 struct xfs_buf;
 
+#define XFS_BUF_DADDR_MAX	((xfs_daddr_t) S64_MAX)
 #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
 
 #define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 773d959965dc29..47edf3041631bb 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1751,7 +1751,7 @@ xfs_init_buftarg(
 	const char			*descr)
 {
 	/* The maximum size of the buftarg is only known once the sb is read. */
-	btp->bt_nr_sectors = (xfs_daddr_t)-1;
+	btp->bt_nr_sectors = XFS_BUF_DADDR_MAX;
 
 	/* Set up device logical sector size mask */
 	btp->bt_logical_sectorsize = logical_sectorsize;
