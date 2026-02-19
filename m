Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0577C8E6
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544689; cv=none; b=INaN1WAxZi8QTTbetjkHU0teqKMw2wP5wrDBpGTFjvpOGSCrMK298g7Nntow7qW11P/92NC54O+aH97cm/uAV1p47vn+yEtxKfiRRW9hapfdbYztpqFs+w4iXd66NQv5jymzdBJijLA73ooccMTErQdvMXxzPiuxC14QiHImzvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544689; c=relaxed/simple;
	bh=Hqt01NUlnOeofrg5LLVPqxp+eRJ8jl8gak9KKzyCiw4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jsbzvC90OUeveV8YcpE7L4buMl5mob81cXePaQOnSEJ75Do4TaWNJYHAGABe5XBAY6OPQdVbovLHe5p2T71w0f8Ciw+teAy6Vbj/nPu8NT+OvLPBFIiu0qLIGgp7Vygkjs4Njkxs7T9IGhogf8tT2tqRlu3G+1bE4DYRRtstUfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7iGbXYw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7iGbXYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22D3C4CEF7;
	Thu, 19 Feb 2026 23:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544688;
	bh=Hqt01NUlnOeofrg5LLVPqxp+eRJ8jl8gak9KKzyCiw4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R7iGbXYwJzvmxgU0SacscizkZ47a2gr3TeImP+n8ElcO7BOeE0Ex7Yj50uH18CVx1
	 ye08Jdz4cA+owo50zatWxKfi5oM5ci2o7lvFlx9audBC1Pobh1TgW4L7hnQXNQ7dlV
	 ZLJF/q8KnGV2upfuJIW0FyskzgGq96pc1nZNkOuGdNlxm4n8GjM7TlkLSwjKfmQ+R0
	 qAaAFRjiWwZF+TuvcGlOGRjsWXyuvJm/IKtRBn28cQxY724/4hmiW9sc5mXDTZFJXQ
	 mWgK8G45bluC982q9KEtA6/NkS0Fepb2mOFgO8zc7lWRdNLTsV0W8dh6DlxFpUMErN
	 cJq+OEusSipmQ==
Date: Thu, 19 Feb 2026 15:44:48 -0800
Subject: [PATCH 05/12] xfs: add a XLOG_CYCLE_DATA_SIZE constant
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177154456818.1285810.8462510393642140537.stgit@frogsfrogsfrogs>
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

Source kernel commit: 74d975ed6c9f8ba44179502a8ad5a839b38e8630

The XLOG_HEADER_CYCLE_SIZE / BBSIZE expression is used a lot
in the log code, give it a symbolic name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_log_format.h   |    5 +++--
 libxlog/xfs_log_recover.c |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 6c50cb2ece1972..91a841ea5bb36d 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -31,6 +31,7 @@ typedef uint32_t xlog_tid_t;
 #define XLOG_BIG_RECORD_BSIZE	(32*1024)	/* 32k buffers */
 #define XLOG_MAX_RECORD_BSIZE	(256*1024)
 #define XLOG_HEADER_CYCLE_SIZE	(32*1024)	/* cycle data in header */
+#define XLOG_CYCLE_DATA_SIZE	(XLOG_HEADER_CYCLE_SIZE / BBSIZE)
 #define XLOG_MIN_RECORD_BSHIFT	14		/* 16384 == 1 << 14 */
 #define XLOG_BIG_RECORD_BSHIFT	15		/* 32k == 1 << 15 */
 #define XLOG_MAX_RECORD_BSHIFT	18		/* 256k == 1 << 18 */
@@ -135,7 +136,7 @@ typedef struct xlog_rec_header {
 	__le32	  h_crc;	/* crc of log record                    :  4 */
 	__be32	  h_prev_block; /* block number to previous LR		:  4 */
 	__be32	  h_num_logops;	/* number of log operations in this LR	:  4 */
-	__be32	  h_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE];
+	__be32	  h_cycle_data[XLOG_CYCLE_DATA_SIZE];
 
 	/* fields added by the Linux port: */
 	__be32    h_fmt;        /* format of log record                 :  4 */
@@ -172,7 +173,7 @@ typedef struct xlog_rec_header {
 
 typedef struct xlog_rec_ext_header {
 	__be32	  xh_cycle;	/* write cycle of log			: 4 */
-	__be32	  xh_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE]; /*	: 256 */
+	__be32	  xh_cycle_data[XLOG_CYCLE_DATA_SIZE];		/*	: 256 */
 } xlog_rec_ext_header_t;
 
 /*
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 3e7bbf08af1f40..6ab8b8b0635c7b 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1338,7 +1338,7 @@ xlog_unpack_data(
 		return error;
 
 	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
-		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
+		  i < XLOG_CYCLE_DATA_SIZE; i++) {
 		*(__be32 *)dp = *(__be32 *)&rhead->h_cycle_data[i];
 		dp += BBSIZE;
 	}
@@ -1346,8 +1346,8 @@ xlog_unpack_data(
 	if (xfs_has_logv2(log->l_mp)) {
 		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
 		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
-			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
+			j = i / XLOG_CYCLE_DATA_SIZE;
+			k = i % XLOG_CYCLE_DATA_SIZE;
 			*(__be32 *)dp = xhdr[j].hic_xheader.xh_cycle_data[k];
 			dp += BBSIZE;
 		}

