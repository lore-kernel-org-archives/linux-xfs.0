Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E265D329E40
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544705; cv=none; b=jUp/1gC2O9830ibfOFu3xd7rmO6dziwPUhRyyjxWEgAPciFt4ofPbG/itdqnYLbxi7yFsj7PX6Z5BNW1u/fRiQlNUVRt/boeVIntRVHTphxWBG9lH+lftBFbKMB84luW5SoQu0R6TonXb080kEP9BK4U3WqvHOVI7mmOZnVssSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544705; c=relaxed/simple;
	bh=1M0+q4SP9sFplwkXtVhLjDpYMaHrlfeoNeQfviKqfjY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pkutvrSsDPs3BDTUUnc1N0Eeer4w78lpz72MuFQhPxV+DCqtMX6RCG9xQo0aDz45BO5tTbY96gQqzCXPZK7lThRHl7rZNeJVFM+0AGIWmAt5Exh3YUDy6iqhlh9L9eb8PFje3hUL56S0pBPS+wBfronLcDCY4UoVuyEEOgNBQnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CDycHuQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CDycHuQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFE3C4CEF7;
	Thu, 19 Feb 2026 23:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544704;
	bh=1M0+q4SP9sFplwkXtVhLjDpYMaHrlfeoNeQfviKqfjY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CDycHuQFNIqHoHCCcUl9+HJMOhIXyjkG5akT9kHCIeZKXwUpMY0oarW9frBIAWR6i
	 rtiDR8Tz/Ssh5vJqZcEDKG4/qXUy85kCnJ3VuzWLeuYtgOBJokCc9qhw/qEFnZECSJ
	 5SlJlvJUaSxCNs9kbU9+UqSNiPITFt3g2ra2Tv7bhcs0z2NlXnXhEQZPYKvLR+sSRg
	 ABh0X8uwgNLkfcNQVHXPwDH7qvggsTb9zXV8b0OZl+iZFDb/YUUD8xcXY/zJDsG3rh
	 uQOQx8HA9KHi+xm2/x2HzzjBiEiKr4otSJpBWu6Bz5oDXjEJpu80b3jQRjJgrn/dK8
	 omCv8zFyND1uw==
Date: Thu, 19 Feb 2026 15:45:04 -0800
Subject: [PATCH 06/12] xfs: remove xlog_in_core_2_t
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177154456837.1285810.1825229967595111728.stgit@frogsfrogsfrogs>
In-Reply-To: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: fe985b910e03fd91193f399a1aca9d1ea22c2557

xlog_in_core_2_t is a really odd type, not only is it grossly
misnamed because it actually is an on-disk structure, but it also
reprents the actual on-disk structure in a rather odd way.

A v1 or small v2 log header look like:

+-----------------------+
|      xlog_record      |
+-----------------------+

while larger v2 log headers look like:

+-----------------------+
|      xlog_record      |
+-----------------------+
|  xlog_rec_ext_header  |
+-------------------+---+
|         .....         |
+-----------------------+
|  xlog_rec_ext_header  |
+-----------------------+

I.e., the ext headers are a variable sized array at the end of the
header.  So instead of declaring a union of xlog_rec_header,
xlog_rec_ext_header and padding to BBSIZE, add the proper padding to
struct struct xlog_rec_header and struct xlog_rec_ext_header, and
add a variable sized array of the latter to the former.  This also
exposes the somewhat unusual scope of the log checksums, which is
made explicitly now by adding proper padding and macro designating
the actual payload length.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_log_format.h   |   31 +++++++++++++++----------------
 libxfs/xfs_ondisk.h       |    6 ++++--
 libxlog/xfs_log_recover.c |   34 ++++++++++++++++++++--------------
 3 files changed, 39 insertions(+), 32 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 91a841ea5bb36d..4cb69bd285ca13 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -126,6 +126,16 @@ struct xlog_op_header {
 #define XLOG_FMT XLOG_FMT_LINUX_LE
 #endif
 
+struct xlog_rec_ext_header {
+	__be32		xh_cycle;	/* write cycle of log */
+	__be32		xh_cycle_data[XLOG_CYCLE_DATA_SIZE];
+	__u8		xh_reserved[252];
+};
+
+/* actual ext header payload size for checksumming */
+#define XLOG_REC_EXT_SIZE \
+	offsetofend(struct xlog_rec_ext_header, xh_cycle_data)
+
 typedef struct xlog_rec_header {
 	__be32	  h_magicno;	/* log record (LR) identifier		:  4 */
 	__be32	  h_cycle;	/* write cycle of log			:  4 */
@@ -161,30 +171,19 @@ typedef struct xlog_rec_header {
 	 * (little-endian) architectures.
 	 */
 	__u32	  h_pad0;
+
+	__u8	  h_reserved[184];
+	struct xlog_rec_ext_header h_ext[];
 } xlog_rec_header_t;
 
 #ifdef __i386__
 #define XLOG_REC_SIZE		offsetofend(struct xlog_rec_header, h_size)
-#define XLOG_REC_SIZE_OTHER	sizeof(struct xlog_rec_header)
+#define XLOG_REC_SIZE_OTHER	offsetofend(struct xlog_rec_header, h_pad0)
 #else
-#define XLOG_REC_SIZE		sizeof(struct xlog_rec_header)
+#define XLOG_REC_SIZE		offsetofend(struct xlog_rec_header, h_pad0)
 #define XLOG_REC_SIZE_OTHER	offsetofend(struct xlog_rec_header, h_size)
 #endif /* __i386__ */
 
-typedef struct xlog_rec_ext_header {
-	__be32	  xh_cycle;	/* write cycle of log			: 4 */
-	__be32	  xh_cycle_data[XLOG_CYCLE_DATA_SIZE];		/*	: 256 */
-} xlog_rec_ext_header_t;
-
-/*
- * Quite misnamed, because this union lays out the actual on-disk log buffer.
- */
-typedef union xlog_in_core2 {
-	xlog_rec_header_t	hic_header;
-	xlog_rec_ext_header_t	hic_xheader;
-	char			hic_sector[XLOG_HEADER_SIZE];
-} xlog_in_core_2_t;
-
 /* not an on-disk structure, but needed by log recovery in userspace */
 struct xfs_log_iovec {
 	void		*i_addr;	/* beginning address of region */
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 7bfa3242e2c536..2e9715cc1641df 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -174,9 +174,11 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rud_log_format,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_phys_extent,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_header,		328);
-	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_ext_header,	260);
+	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_header,		512);
+	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_ext_header,	512);
 
+	XFS_CHECK_OFFSET(struct xlog_rec_header, h_reserved,		328);
+	XFS_CHECK_OFFSET(struct xlog_rec_ext_header, xh_reserved,	260);
 	XFS_CHECK_OFFSET(struct xfs_bui_log_format, bui_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_cui_log_format, cui_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_rui_log_format, rui_extents,	16);
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 6ab8b8b0635c7b..843b8e9c47a455 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1324,35 +1324,41 @@ xlog_unpack_data_crc(
 	return 0;
 }
 
+/*
+ * Cycles over XLOG_CYCLE_DATA_SIZE overflow into the extended header that was
+ * added for v2 logs.  Addressing for the cycles array there is off by one,
+ * because the first batch of cycles is in the original header.
+ */
+static inline __be32 *xlog_cycle_data(struct xlog_rec_header *rhead, unsigned i)
+{
+	if (i >= XLOG_CYCLE_DATA_SIZE) {
+		unsigned	j = i / XLOG_CYCLE_DATA_SIZE;
+		unsigned	k = i % XLOG_CYCLE_DATA_SIZE;
+
+		return &rhead->h_ext[j - 1].xh_cycle_data[k];
+	}
+
+	return &rhead->h_cycle_data[i];
+}
+
 STATIC int
 xlog_unpack_data(
 	struct xlog_rec_header	*rhead,
 	char			*dp,
 	struct xlog		*log)
 {
-	int			i, j, k;
+	int			i;
 	int			error;
 
 	error = xlog_unpack_data_crc(rhead, dp, log);
 	if (error)
 		return error;
 
-	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
-		  i < XLOG_CYCLE_DATA_SIZE; i++) {
-		*(__be32 *)dp = *(__be32 *)&rhead->h_cycle_data[i];
+	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
+		*(__be32 *)dp = *xlog_cycle_data(rhead, i);
 		dp += BBSIZE;
 	}
 
-	if (xfs_has_logv2(log->l_mp)) {
-		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
-		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
-			j = i / XLOG_CYCLE_DATA_SIZE;
-			k = i % XLOG_CYCLE_DATA_SIZE;
-			*(__be32 *)dp = xhdr[j].hic_xheader.xh_cycle_data[k];
-			dp += BBSIZE;
-		}
-	}
-
 	return 0;
 }
 

