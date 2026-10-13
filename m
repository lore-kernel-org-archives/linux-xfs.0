Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D7130ACE6
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871368; cv=none; b=QXrOf8uWk0m6bQgQmxIC55ALpSDhwfTW9MquJkvho2ERvtZu7zXD9scnF1/oApjomnfMGsgJ2KBOca2227cryLLs4D5pHA4PM3xrykwQpGBP+TdiYk/6TB37G5mKCAbraGgceGwnOgsw6nZ6dikU4pPfjtteoOxXjAJ1JAxYz/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871368; c=relaxed/simple;
	bh=QXvjSgkBEqbdwiDzKO7JyJ2sjYAbMKKklMpRU7Xxp+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoLOIiHM2M8bPUu8Mj2R/qPiFh8F1ZfH2L01Ngzt8ljivNGZ2S/BfN8HPxokN8kAWiBZ2ZmmNmg3RS+o6YBWxWu/ipwSGEZQw9D+qOoTfqLnPHvdNPZM6O7soAEKU67L/w9Zzt9fg9/Jnw+/txTkVavqgokdIzaz7IB8DBQWHBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oe8ZKEVc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oe8ZKEVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66E31F00893;
	Tue, 13 Oct 2026 06:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871367;
	bh=CbCpt3QDhyK5J2oj/T3N6PznE9xwJwgs8/6uXAghNr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oe8ZKEVcow0KDnJWJvAoc08zIv+LvyYuVMP1Uq6Xr9WuJuka+43PVIhuWYIMI49lx
	 3fGKDt/lc1TF6DThwZBW+tMNGmuJyR0ztwLOGgUnqhNMWjqHIrid1ZDA+4PKLib73J
	 J+46HdZyxIZ3CcniEuV3c+cgSVR8BulB+ELBadYeFVc9rpD8+sCHk/rpjjIfsBW4lC
	 +0Y0Y6DZn6xkLGlZJi+UAKR3/MsXmOfMyyB2JGmeq5pgXWbKTo59BjjSiD16G46p4e
	 fQbe7whqmyAm/2hDdjB0hWSfugSzeUKE9oQosCZ7DleVS7DTShjoi7ftvRsKT57Uxr
	 GEBEwE4cGYV/A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 31/48] xfs: validate attr done items during recovery
Date: Tue, 13 Oct 2026 17:01:21 +1100
Message-ID: <20261013060204.3138690-32-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An attr done item is a single fixed size region, but recovery only checked its
length in the commit handler and never checked its padding.

Validate the region length and require the padding to be zero as the item is
decoded. The commit handler can then trust the item, so the length check is
removed from it.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_attr_item.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index a53ee2b0c54a..a6e36b2aa7b3 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -1167,14 +1167,35 @@ xlog_recover_attrd_commit_pass2(
 	struct xfs_attrd_log_format	*attrd_formatp;
 
 	attrd_formatp = item->ri_buf[0].iov_base;
-	if (item->ri_buf[0].iov_len != sizeof(struct xfs_attrd_log_format)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	xlog_recover_release_intent(log, XFS_LI_ATTRI,
+				    attrd_formatp->alfd_alf_id);
+	return 0;
+}
+
+/* The attrd is a single fixed size region. */
+static int
+xlog_recover_attrd_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_attrd_log_format	*attrd_formatp =
+		item->ri_buf[region_index].iov_base;
+
+	if (item->ri_buf[region_index].iov_len !=
+			sizeof(struct xfs_attrd_log_format)) {
+		xfs_warn(log->l_mp, "ATTRD: bad item region length %zu recovered.",
+				item->ri_buf[region_index].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	/* The padding is always written as zero. */
+	if (attrd_formatp->__pad != 0) {
+		xfs_warn(log->l_mp, "ATTRD: bad padding 0x%x recovered.",
+				attrd_formatp->__pad);
 		return -EFSCORRUPTED;
 	}
 
-	xlog_recover_release_intent(log, XFS_LI_ATTRI,
-				    attrd_formatp->alfd_alf_id);
 	return 0;
 }
 
@@ -1203,5 +1224,8 @@ static const struct xfs_item_ops xfs_attrd_item_ops = {
 
 const struct xlog_recover_item_ops xlog_attrd_item_ops = {
 	.item_type	= XFS_LI_ATTRD,
+	.min_hdr_len	= sizeof(struct xfs_attrd_log_format),
+	.validate_nregions = xlog_recover_single_region,
+	.validate_region = xlog_recover_attrd_validate_region,
 	.commit_pass2	= xlog_recover_attrd_commit_pass2,
 };
-- 
2.55.0

