Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871069;
	b=JJc6Cy7YkKEpAHgDXT2viJSAL3DUdNhERXwc41bBXE66bE2MZL7wCa81khMbz9qmL+P7
	 6RXuKPz6WUXzEfxfB8Rhu9swktOAwFL1fBD7Gr62z8CKHyz9gOnDiVKt8CMlrHMows2Si
	 kakoxZ/KEHh4H21uDO2rMtEPnshrY3QNv4/yPXZ3UzMot1yeEWytxGU4ZsFdV/+hQjDvd
	 3Zxf67Wq1ZjVgDcE8EL1RAA+RxhK4CXoXlUQBAtgkxJC1kGA+qnlXFK1XnLkdr2P40+Lm
	 wQUXrzYgDEfXWWgIBGdtE6yNmuZ0cD3Pon+pN/5Ai77O3zwVuZ0AC8ZhvAhcqhkwNpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=wnkxZoY6O5jHyfzmiVhdSkpPgEtCRxhx0Z0ClHU1zY0=;
	b=Jh18LAXXBzVSav6dR/FBV0aiBoHqxrc35O7S3JPM+xkiN+VXlxOfFfUhX6B/VoOanqHG
	 lsxQg8tGEl9ZOo/NrxUlJjbLr9rQI2NhqF+YZQRreur2Mp8znUZ5rmntNXi/Nd+KyIxHA
	 yaVU2SbW047CVyQEGzltUZKasgjj7sB7io3HqiToteQgnZMJY+cOB3xMU2nkiUSHBbiNT
	 ZzW+EMOFhkBgSASl6RvcJktNX+z/oxHVKw+MJdMdTERoc7eWHlIy0gKHx7wAncwb6VFLO
	 XzPKJGHi0ya7vD0mTu8npobKNPaR67O8ymotxoksOhZ+HNQ8+VIQLzMDlGmSGN0Il1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zasb21zz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF68B606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zasb21zz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5531F000C4;
	Mon, 16 Nov 2026 23:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871068;
	bh=wnkxZoY6O5jHyfzmiVhdSkpPgEtCRxhx0Z0ClHU1zY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zasb21zzaEC6IaDRG4+xvFVSsQaalhDeFWO8UttPB6Dz5T8G/tzRzBKvgaXqguONh
	 lwiyPKdTjngr6qgfVbDlfj2SNi4K+T+JYeYv5LErGoVYWxxTJYsv8SnobQiyb3Xd72
	 Rrn9c5Uj1j4w4HotWniTbwDfdJaUY0LQpGcQAzpVsAEOQfbUgsfCMPYsG7bYj+hScU
	 8v88m45gR5Fpgp6YDBYcs3ITpO93JvaFFRmj2iM9MOsJjpxWa6Q3eD63N2PNj3MIKd
	 FPULiOaSkBidZZLaDcrmEtgfJWHLsVhIaBDjP08HHzQ5OjdfMo+3ngvxMI/Uak/Td/
	 VYJY9PT2lJuug==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 27/59] xfs: dump the corrupt region when log item validation fails
Date: Tue, 17 Nov 2026 10:14:44 +1100
Message-ID: <20261116231707.3625263-28-dgc@kernel.org>
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

Log item validation reports failures with a type specific warning, but that
warning does not include the region contents. The existing recovery code
dumped the offending buffer via XFS_CORRUPTION_ERROR for diagnostics, and that
is being removed as per-type validation replaces it.

Emit XFS_CORRUPTION_ERROR from the region completion path when validation
fails, so the type specific warning is accompanied by a hex dump of the
relevant buffer. A per-region failure dumps that region; a whole-item failure
dumps the format header. This is added before the per-type validation so those
patches can drop their own corruption dumps.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 374de5d21da6..927062a53dd4 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2360,7 +2360,8 @@ xlog_recover_complete_region(
 	struct xlog_recover	*trans)
 {
 	struct xlog_recover_item *item = trans->r_cur_item;
-	int			error;
+	int			region_to_dump = 0;
+	int			error = 0;
 
 	/*
 	 * The format header (region 0) must be at least the minimum size for
@@ -2373,19 +2374,29 @@ xlog_recover_complete_region(
 	"log item type 0x%x header too short (%zu < %u)",
 			item->ri_ops->item_type, item->ri_buf[0].iov_len,
 			item->ri_ops->min_hdr_len);
-		return -EFSCORRUPTED;
+		error = -EFSCORRUPTED;
+		goto out_error;
 	}
 
 	if (item->ri_ops->validate_region) {
 		error = item->ri_ops->validate_region(log, item,
 						      item->ri_cnt - 1);
-		if (error)
-			return error;
+		if (error) {
+			/* dump the bad region rather than the log format header */
+			region_to_dump = item->ri_cnt - 1;
+			goto out_error;
+		}
 	}
 
 	if (item->ri_cnt == item->ri_total)
-		return xlog_recover_complete_item(log, trans);
-	return 0;
+		error = xlog_recover_complete_item(log, trans);
+
+out_error:
+	if (error == -EFSCORRUPTED)
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				item->ri_buf[region_to_dump].iov_base,
+				item->ri_buf[region_to_dump].iov_len);
+	return error;
 }
 
 STATIC int
-- 
2.55.0

