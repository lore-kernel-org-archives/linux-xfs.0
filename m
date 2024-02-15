Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE52712BF3D
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998988; cv=none; b=BhaAzNPAGv3WmX/K16GR2mtr9VKxkib4ZZXWp/Y74q+A5gZzX+uQIfjyRVAkDoO/SKObqPC8UBMPsKMi/amuauoBiX1PdDWJMMXPdgqpGN0jAzAcs95KtCPjODeiEvlc6+bXoV9qP9uoF2mthBdhvGxmv8e8PQnNyCubIF4poGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998988; c=relaxed/simple;
	bh=RBb03EdagAhI/bHRj44FCDnhVADWmsEHQUtoLfdQNSw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qI0uRubwpaRTGBaS/WqRdkKJSpqZsVAowH4DnUgfJReq0mcnbyqS+w31PKg5OI/BEacuJYKsgUnrWzknRFTgc0KrHmKDZr5jEfaGiaM5WcM3ZMHMdFlny430YcUazEOdCHLqqezX7H+4G7rVwqkvCANwQ5C6cI5hjNqWSkGcumY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5VHn3kq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5VHn3kq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F42BC433F1
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998988;
	bh=RBb03EdagAhI/bHRj44FCDnhVADWmsEHQUtoLfdQNSw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=f5VHn3kqgnmdPSumS2DRgO1+JybWzT7TFO3xpds99ku8PwAbtNReJhZCn77pc0Th3
	 G3EVGWiC35fJwy8LnkCGHeEmWHgxg705E8tXNbjSVp6KMFA/G1QVIh58sadKh+dAm8
	 EaG2gjO1cXIKCsbkC2Axq79zz4Z/+LZFubvlROh6jZ+T8azbhT2/7ft+YQ99DhKAEu
	 0lQwLif6Qg5gBWUczhf/Gh17VpTG1hyf0RLNemLejqUHiYs6ADRiNdRZKE5xA8zLVM
	 0klrPC5e1OGWryouIBV5kDGbaxWURK+APiGtOoPTfbOnbLNV3oc1ksbXqV0G6J5isW
	 9MlKACLC3BTEA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 31/35] xfs: invert the realtime summary cache
Date: Thu, 15 Feb 2024 13:08:43 +0100
Message-ID: <20240215120907.1542854-32-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Omar Sandoval <osandov@fb.com>

Source kernel commit: e23aaf450de733044a74bc95528f728478b61c2a

In commit 355e3532132b ("xfs: cache minimum realtime summary level"), I
added a cache of the minimum level of the realtime summary that has any
free extents. However, it turns out that the _maximum_ level is more
useful for upcoming optimizations, and basically equivalent for the
existing usage. So, let's change the meaning of the cache to be the
maximum level + 1, or 0 if there are no free extents.

For example, if the cache contains:

{0, 4}

then there are no free extents starting in realtime bitmap block 0, and
there are no free extents larger than or equal to 2^4 blocks starting in
realtime bitmap block 1. The cache is a loose upper bound, so there may
or may not be free extents smaller than 2^4 blocks in realtime bitmap
block 1.

Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index f5d7e14ab..8f313339e 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -493,10 +493,10 @@ xfs_rtmodify_summary_int(
 		xfs_suminfo_t	val = xfs_suminfo_add(args, infoword, delta);
 
 		if (mp->m_rsum_cache) {
-			if (val == 0 && log == mp->m_rsum_cache[bbno])
-				mp->m_rsum_cache[bbno]++;
-			if (val != 0 && log < mp->m_rsum_cache[bbno])
+			if (val == 0 && log + 1 == mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
+			if (val != 0 && log >= mp->m_rsum_cache[bbno])
+				mp->m_rsum_cache[bbno] = log + 1;
 		}
 		xfs_trans_log_rtsummary(args, infoword);
 		if (sum)
-- 
2.43.0

