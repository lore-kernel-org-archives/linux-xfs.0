Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871084;
	b=a7HYhu08lbVtpr+HkgULNn7nekRt3FmhfHPXmKLJLU5tMlY+kgzy/zoXChBT2Nfh3Vl2
	 AF2Wu51502GHTg21KI8+a/lWlY81UdzTBjmIB8ao6iaqGQxQogxu7nKrFaxfn02EmNRUf
	 V4RUnhAk6QkbWdS2v8XXlwAiGh9smK4v4RjAy2ETuzNhJzo8gMa3Bx0HpPx/jmVWJeFQN
	 8YS+G4brtKZpZ3SgKzDenldgOayEnHEMpC1vubQSCMIy+48S+1BcLff6QqmHAIsvBZXl/
	 ka3TvBi+O+Mq0jd8kcdLYvZkxr4YXZ46IbuMBpk2JmtQLkzshLykMXsL0jxWyKvtkmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DtpxvUu0oEjAZTXw+mX9jXx75NfLmd0ss0jnkSPauUo=;
	b=lvCEJp5o/4oEl3cypKBaw6wlZfmZDzN/VKW/2NLvK7AZp8VnNBCI4EwmdZeu6nbrFwLL
	 MWXhaTJkPcsQxigAp2pbTEcBzqfXRZmxy3g7dGscMflI0NMWhIvH986g0qGW598Ai4hmq
	 U+4mm3qpow208aLhjUSSiPcle1QiJPXdNGOdGtctfYir5tvnkYU+FIZORkYkAIxjuQZqX
	 WrBlVyX3UAlqf05qvLXn5V7E2ur9yURKOxYYr0QrcSu7ZEYj1bodXcC4pG/q/mujNmCdB
	 hOFyfkj8xMLXQaRP/6FNfhECHWqr5AC2+qEGUHhTzZS6dsJ0QJiyz609iA/3kbZVkuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="N+Ad/kLx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8319C606A336
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N+Ad/kLx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FD41F000C9;
	Mon, 16 Nov 2026 23:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871084;
	bh=DtpxvUu0oEjAZTXw+mX9jXx75NfLmd0ss0jnkSPauUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+Ad/kLxRbL2yUVik/9f+UjDqKcGdlpz5uGMhHP+QOnxVePGu84NqF2r64lZJ4RZR
	 KF9CO3kka4y3FPikuaUM3+ji8s17vrEdw27w+u6RT1sddfXrUH1w2uEY5MknoM+Lj7
	 eD7COcUNTAnFDsTyPeNAkgfVPy5EB7dYxhIs9V+J8ebdP11kkLaNZBNzMS3bAK5RuK
	 a7mfXOpEpT5B76Xjc55A+bYWwX90nOTzmfVP5E9G8ONK5ZPmXfBT4hgrr9/rPDS7VP
	 DXDHZPBErk/NDpOhpyRcra0JQG5LGG9WpuK21FYrrRENMa/AdKEVnhjRlgYONRVc6F
	 kXoLKoCT+W2mg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 39/59] xfs: validate mapping exchange done items during recovery
Date: Tue, 17 Nov 2026 10:14:56 +1100
Message-ID: <20261116231707.3625263-40-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A mapping exchange done item is a single fixed size region, but recovery only
checked its length in the commit handler and never checked its padding.

Validate the region length and require the padding to be zero as the item is
decoded. The commit handler can then trust the item, so the length check is
removed from it.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_exchmaps_item.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index 973df8ded795..02e57aee1fa3 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -629,17 +629,41 @@ xlog_recover_xmd_commit_pass2(
 	struct xfs_xmd_log_format	*xmd_formatp;
 
 	xmd_formatp = item->ri_buf[0].iov_base;
-	if (item->ri_buf[0].iov_len != sizeof(struct xfs_xmd_log_format)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-				 -EFSCORRUPTED, log->l_mp);
+	xlog_recover_release_intent(log, XFS_LI_XMI, xmd_formatp->xmd_xmi_id);
+	return 0;
+}
+
+/* The xmd is a single fixed size region. */
+static int
+xlog_recover_xmd_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_xmd_log_format	*xmd_formatp =
+		item->ri_buf[region_index].iov_base;
+
+	if (item->ri_buf[region_index].iov_len !=
+			sizeof(struct xfs_xmd_log_format)) {
+		xfs_warn(log->l_mp, "XMD: bad item region length %zu recovered.",
+				item->ri_buf[region_index].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	/* The padding is always written as zero. */
+	if (xmd_formatp->__pad != 0) {
+		xfs_warn(log->l_mp, "XMD: bad padding 0x%x recovered.",
+				xmd_formatp->__pad);
 		return -EFSCORRUPTED;
 	}
 
-	xlog_recover_release_intent(log, XFS_LI_XMI, xmd_formatp->xmd_xmi_id);
 	return 0;
 }
 
 const struct xlog_recover_item_ops xlog_xmd_item_ops = {
 	.item_type		= XFS_LI_XMD,
+	.min_hdr_len		= sizeof(struct xfs_xmd_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_xmd_validate_region,
 	.commit_pass2		= xlog_recover_xmd_commit_pass2,
 };
-- 
2.55.0

