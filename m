Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB97C2AE8D
	for <linux-xfs@vger.kernel.org>; Sun, 15 Mar 2026 00:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773532847; cv=none; b=DwnPINCK93Cvkh1rkVD77wQVTtUmRKJAh58I3bv5pOifEccurwhAkTSeeNgzUcUIBqILV2GC3PiQUAlA9YQnJmUm27G+aZKZBgsv9/DB5p4yP8Pz523oTrpOoEn718UDxLcWxmKwOhE6Qp0RQLNxbYf+QSpL25AUAuA4xNgRlBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773532847; c=relaxed/simple;
	bh=FC+dWaUa3Z0Qq6gT0/KHY6E3w+FJw3/VkV/EDHb5JeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKwl4dz2O0uwYI8U2JDdF8IuFZK/4+LoTdzC/zTwPsa4Spg0ZG92DxpBdr3ECZRN7vk+oKaIub0zUu4TrZKB6GsIcRjBN49NlCYsoEiPzvv6h0riZUY8U7eTPPf+qGfWaMPID3rccp+yfQM1XheOGT4AxFWxq33jOmI4FgxqvNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cC7FIzPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cC7FIzPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23129C19424;
	Sun, 15 Mar 2026 00:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773532847;
	bh=FC+dWaUa3Z0Qq6gT0/KHY6E3w+FJw3/VkV/EDHb5JeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cC7FIzPZfwUjmlP3HTpJRpN9dZvusx7RSnQjsqrFWz5I6nxO+dBLMcvKsmoAuB9El
	 vEksE2JH3Yizw6W3nTOFG07kyeV5gTFjYorWX9Hr8039hGX8t+WflX38aISOM/qDbk
	 cgigkDPicneUZfyYTWRtdh+ldjLtVIL6XPIUs5kxVxNsQPBJOfsSOHVy45PAXB5PTo
	 TKXdEVfIwkylfOzXWuOjRU82aMnZqoOUvQm7Jj8I9CtDTHvjMB5Z1KVGskLAwPXA0g
	 gGpgYTeG0xZ3WfejNSjs5p4q048/5+iK8M2wfcP2cp/o+QNEcjIy8/mng7I9QPOLpG
	 TiLGAzltGwn1Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH 1/3] xfs: improve xfs_select_zone_nowait()
Date: Sun, 15 Mar 2026 08:55:06 +0900
Message-ID: <20260314235508.183984-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260314235508.183984-1-dlemoal@kernel.org>
References: <20260314235508.183984-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the check for the return value of the call to
xfs_select_open_zone_mru() inside the if that controls the call to this
function, so that we do not uselessly test again the value of oz when
pack_tight is false.

While at it, also fix a comment typo.

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_alloc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 7d712d5a5ce0..a05418ac6a95 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -675,10 +675,11 @@ xfs_select_zone_nowait(
 	if (oz)
 		goto out_unlock;
 
-	if (pack_tight)
+	if (pack_tight) {
 		oz = xfs_select_open_zone_mru(zi, write_hint);
-	if (oz)
-		goto out_unlock;
+		if (oz)
+			goto out_unlock;
+	}
 
 	/*
 	 * See if we can open a new zone and use that so that data for different
@@ -689,7 +690,7 @@ xfs_select_zone_nowait(
 		goto out_unlock;
 
 	/*
-	 * Try to find an zone that is an ok match to colocate data with.
+	 * Try to find a zone that is an ok match to colocate data with.
 	 */
 	oz = xfs_select_open_zone_lru(zi, write_hint, XFS_ZONE_ALLOC_OK);
 	if (oz)
-- 
2.53.0

