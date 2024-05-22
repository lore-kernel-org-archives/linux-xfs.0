Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5749A5234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346314; cv=none; b=GEeAXczVTPMjaBofTxo7EiMgPdZuhNKPAcQm4h8OaTf5weS7SnRGcIKdLzTV6BU9AF4b98mTfzmVD+iAl3XKOx+CBkr3Epit/HEOpA6KtWkk/03UOfJ79yS1mDNWRVEhk1ukQ2Tk33Cd+X0r57aQJ9OGMJfKPxfo51sunCYFRQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346314; c=relaxed/simple;
	bh=r4FgXhvRrKHRXqEcioCbJ3sbsvKl/vuMM8RGnKwkWQA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T9P7tYf+tL1fdOP/RD/9waUVmjQ6iI7VAtetD+ETZWoWxxg0nfGkXePb8PUmiy99Wx7r9tD7omGgQyWhx6P6/G3n5N+hpzJ9zOfuuJMB/bIXKO/g5P9I9k9EnSjnyzIV2pYfqkRXD24HL1+bJfEIKtbvi5YS2iZ6RLcQMo/Rl9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4UV6KSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4UV6KSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F320C2BD11;
	Wed, 22 May 2024 02:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346314;
	bh=r4FgXhvRrKHRXqEcioCbJ3sbsvKl/vuMM8RGnKwkWQA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K4UV6KSRL2VUq7LdZBJ4Cq1k6hL8S2yksu5m2XbvveZgXZHP+7gLNFqJjWFrRaiGc
	 fGbozVsn7s4yEvhgkM3T7sgTppeaKGFTG3PbEgHiz8pzsu9qGw1v91/rfi93KsL0c8
	 Vc8guAlfP3Xd+IptLNZTQUDtvQpd8BCIf1f8qjsDmJwYTjq/wkvQ7Fbh6x/1QK7Ytg
	 PISvEcjmZEfZfIaybyc4V2/S48D4jy6EFklRlNu1ldx2A+feC1VyaQnrvllVG9G5VD
	 6jRiQOIwRp4+5FSlGv7h8m+oRvthpeQD0BdnZmMhl0Z2vfmYLQB0dn7PgqbeVi3w82
	 +zKiK3OUFJgUQ==
Date: Tue, 21 May 2024 19:51:53 -0700
Subject: [PATCH 012/111] xfs: report the health of quota counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531891.2478931.16390764710597367421.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3d8f1426977f1bf10f867bcd26df6518ae6c2b2c

Report the health of quota counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_health.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 636007386..711e0fc7e 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -195,6 +195,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
+#define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 6296993ff..5626e53b3 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -41,6 +41,7 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_UQUOTA	(1 << 1)  /* user quota */
 #define XFS_SICK_FS_GQUOTA	(1 << 2)  /* group quota */
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
+#define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -77,7 +78,8 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
 				 XFS_SICK_FS_UQUOTA | \
 				 XFS_SICK_FS_GQUOTA | \
-				 XFS_SICK_FS_PQUOTA)
+				 XFS_SICK_FS_PQUOTA | \
+				 XFS_SICK_FS_QUOTACHECK)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)

