Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2EB4A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299074; cv=none; b=jqHf762Fc8W+t+HabX+R3Ib5gaLiRKIUhKtaVNYFjNSZyLEN085x0Gk8jwZCaa6llUxhW0HKMgmf1hVWDedN7nmIjGrGgZTQ0ue5SEgqKDYlR2me5URh1eTF9W0Ps/ZoYkmTZnBEUe7jNyPrN0MPQiF5cm1n4/7gV0b/bWR2quY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299074; c=relaxed/simple;
	bh=8ezvH9Rp8EvFgP31Tx9/sAUwekDRHUXYad0++gA73Dw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sojnkkR5ZHGi+IuRBNVQBYAqJ9I+EiJ77VIkliPyeH/E/sRbntvpzkJjt4Bw6sfjF4lKrX4wk8e5dDne8OZiD7ST+0f4yWiEhfXobkr0Q7qcpZ04o1ATGf/zpGd73VI4oIzChbjAnS6on6A16KI7igI1LEEGu2xaX29sRgV1IM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qnMc9TJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qnMc9TJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71DBC32786;
	Tue, 30 Jul 2024 00:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299074;
	bh=8ezvH9Rp8EvFgP31Tx9/sAUwekDRHUXYad0++gA73Dw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qnMc9TJuJqOz2Kub6V8S402t3OowxEcesquULebBJ3aZ9X7l8sEhciPzmQsTvRtH/
	 90nneEnUhxGu6gXUPokVDLe2GLxdIy99QJKyaZHJdyST1q8gYJEtJ03I1KGbb+6/2t
	 3zv6xLd+ApTwN1HvZX3UcAO1QH1tpaBLYBXhi1V2WgqaIXs8aCZoCuOqolotPcy/S2
	 FgnDUDMEGgIpxS2fm3JIw44eAJ2tBvPgQS09Wqqug/HazYqa5K/r4P/KecX7QwL1wN
	 aZso6DzN5ZV2GROZFazUULPGPyAwx8w370DaZXf35nYBVSIrTu3p0MblThP5Utyxam
	 dNRIsIvUVlThw==
Date: Mon, 29 Jul 2024 17:24:33 -0700
Subject: [PATCH 003/115] xfs: introduce new file range exchange ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842484.1338752.14571927597810604078.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 9a64d9b3109d01cca0b83c1d36538b7a37c5284e

Introduce a new ioctl to handle exchanging ranges of bytes
between files.  The goal here is to perform the exchange atomically with
respect to applications -- either they see the file contents before the
exchange or they see that A-B is now B-A, even if the kernel crashes.

My original goal with all this code was to make it so that online repair
can build a replacement directory or xattr structure in a temporary file
and commit the repair by atomically exchanging all the data blocks
between the two files.  However, I needed a way to test this mechanism
thoroughly, so I've been evolving an ioctl interface since then.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index ca1b17d01..8a1e30cf4 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -772,6 +772,46 @@ struct xfs_scrub_metadata {
 #  define XFS_XATTR_LIST_MAX 65536
 #endif
 
+/*
+ * Exchange part of file1 with part of the file that this ioctl that is being
+ * called against (which we'll call file2).  Filesystems must be able to
+ * restart and complete the operation even after the system goes down.
+ */
+struct xfs_exchange_range {
+	__s32		file1_fd;
+	__u32		pad;		/* must be zeroes */
+	__u64		file1_offset;	/* file1 offset, bytes */
+	__u64		file2_offset;	/* file2 offset, bytes */
+	__u64		length;		/* bytes to exchange */
+
+	__u64		flags;		/* see XFS_EXCHANGE_RANGE_* below */
+};
+
+/*
+ * Exchange file data all the way to the ends of both files, and then exchange
+ * the file sizes.  This flag can be used to replace a file's contents with a
+ * different amount of data.  length will be ignored.
+ */
+#define XFS_EXCHANGE_RANGE_TO_EOF	(1ULL << 0)
+
+/* Flush all changes in file data and file metadata to disk before returning. */
+#define XFS_EXCHANGE_RANGE_DSYNC	(1ULL << 1)
+
+/* Dry run; do all the parameter verification but do not change anything. */
+#define XFS_EXCHANGE_RANGE_DRY_RUN	(1ULL << 2)
+
+/*
+ * Exchange only the parts of the two files where the file allocation units
+ * mapped to file1's range have been written to.  This can accelerate
+ * scatter-gather atomic writes with a temp file if all writes are aligned to
+ * the file allocation unit.
+ */
+#define XFS_EXCHANGE_RANGE_FILE1_WRITTEN (1ULL << 3)
+
+#define XFS_EXCHANGE_RANGE_ALL_FLAGS	(XFS_EXCHANGE_RANGE_TO_EOF | \
+					 XFS_EXCHANGE_RANGE_DSYNC | \
+					 XFS_EXCHANGE_RANGE_DRY_RUN | \
+					 XFS_EXCHANGE_RANGE_FILE1_WRITTEN)
 
 /*
  * ioctl commands that are used by Linux filesystems
@@ -843,6 +883,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
+#define XFS_IOC_EXCHANGE_RANGE	     _IOWR('X', 129, struct xfs_exchange_range)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 

