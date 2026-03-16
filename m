Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9C82BE053
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 11:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773661563; cv=none; b=d+SLXrqWrSeXpYaOPNzZDeysQkSkyiHNMVq5C09GYmO5mEPfidl+lwIIUkTyTeRds65/7t10jMa+C0Qq889WPfr4NdI3E668JodTZ+NcRnzWR2Y22dpjyrNXrkBLUOpDQAmAtVCIJU3vzmPGWdz9Gc56G6Cvc7kaNlXABHZ6ab8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773661563; c=relaxed/simple;
	bh=fogjJLx+uBgb07akE3Yib2+es3qvOCwpogLfNY5+tTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWcoE0s0CwYWPoLzHuDn1LUHf821aAeqzQktHxoRVwEU8m4m/kX/l0q6sFfj5FZPsmUBVoPS5BaBy01ZUzaEPAqmlEJKvGPT0l7ptoGyM8EwkKCzgjmd9ACVHzt7he6QQBNzIQEe7Bkm3zijAyyHRackj1L6U2T9QLJAp7EeIog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I58ivuZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I58ivuZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BB2C19421;
	Mon, 16 Mar 2026 11:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773661563;
	bh=fogjJLx+uBgb07akE3Yib2+es3qvOCwpogLfNY5+tTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I58ivuZIy8kZT71BNzR74Hp5/98LHTC3T5VyVBjWiCeSDqttOE51gOYVtGehzwI8l
	 w1d63xO39AxtdgRlTqTvt921XsHWzxSGWZhbFnqDamFKvFhLEV/NernjZxagJXeoHs
	 pXbkbZI5JouAamhS9psG0bxFzDcy4l7cT3M3iHkXFuzTmH5F3Srm/uRMhZ82XaahJw
	 tCk+I7l3idg3L48r6nxbssutnZK6RZ24k0cTQpwXPL5RUOJtS+ALaztENeRYsNO27E
	 YuhJB9Rn4M6sXEbNNHCoXTOyzdlAaH65ti5lS5UtBakl5MsL6R+/aHnwizxNWbozSI
	 IQMVxS1qR+g+A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v2 2/4] xfs: fix a comment typo in xfs_select_zone_nowait()
Date: Mon, 16 Mar 2026 20:40:18 +0900
Message-ID: <20260316114020.753228-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316114020.753228-1-dlemoal@kernel.org>
References: <20260316114020.753228-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a typo in the comment describing the second call to
xfs_select_open_zone_lru() in xfs_select_zone_nowait().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 8435ccb018dc..a05418ac6a95 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -690,7 +690,7 @@ xfs_select_zone_nowait(
 		goto out_unlock;
 
 	/*
-	 * Try to find an zone that is an ok match to colocate data with.
+	 * Try to find a zone that is an ok match to colocate data with.
 	 */
 	oz = xfs_select_open_zone_lru(zi, write_hint, XFS_ZONE_ALLOC_OK);
 	if (oz)
-- 
2.53.0

