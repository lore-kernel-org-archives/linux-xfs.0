Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A410526290
	for <linux-xfs@vger.kernel.org>; Thu, 13 Nov 2025 13:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763042250; cv=none; b=LeOOFwqpEYiHrdUUQefCZcT9CfHE656e+rpNDJhswwlQKf1O5JBLF/dagzxWVdtYbC8NAmEmSX4/7Wt1hqeOWc6uQt79/gE0YdGguhMpJtrllF0qZqk/QVQ72lSBr495VNKyY0Fi1onmZ8Hi0rnoshbx8fIjkOqcdZh+NjAcUZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763042250; c=relaxed/simple;
	bh=43qHrNmATliwaZnAVtgRvVYmbnqF8Dta+YkMidx3Vjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o4ZHchKGtu9Xl0INq0WfMTRtfLxlZkm8RGhDlcvpTTkr+eqHzeLRmSzBOQdDGy0qjBJsah5kxfTUS0XuDJqMTS7wM5O2jYEgvDejuShIQ/B39ruuA4NF1H6xMiyhutvrzv/nb7jLFMiCP/CQ0u3wM1I0xpaI+wJOm2gx3JfLqLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKes/G5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKes/G5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DB3C4CEFB;
	Thu, 13 Nov 2025 13:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763042250;
	bh=43qHrNmATliwaZnAVtgRvVYmbnqF8Dta+YkMidx3Vjw=;
	h=From:To:Cc:Subject:Date:From;
	b=GKes/G5Ea8QwAAX8Pz0toBh8nJw9Sl716ygVby2d1Rq0TP5kjj9H1YqHLRD2B/HFP
	 fjeIjfqodBkEE43wOWHZtcbd8wX0ZjCekLIgRIINmD14TLGg6AiHE+xA3YhaiJscHu
	 uTFMcJ6A0a9ZLZ+V5bmHBhlY4Munfv7nQWPmCrjn4FdLNnVoHc4MuUEbHHZB8q+Jw0
	 C5M4f+uReSejhC/XrAzuq8SwS3aCVvM1rAuMn5Po6BSQR/GluQJmcCl/WgTtX906GJ
	 Lj0uZDNNw9QJvhzzuR7Bb93aOtJFrZTjPzPajqvRoTJaZmHCz8gdxoN0ZNf50o40Ma
	 HZlZOvCM9dYcQ==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: [PATCH v2] metadump: catch used extent array overflow
Date: Thu, 13 Nov 2025 14:57:11 +0100
Message-ID: <20251113135724.757709-1-cem@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

An user reported a SIGSEGV when attempting to create a metadump image of
a filesystem.
The reason is because we fail to catch a possible overflow in the
used extents array in process_exinode() which may happen if the extent
count is corrupted.
This leads process_bmbt_reclist() to attempt to index into the array
using the bogus extent count with:

convert_extent(&rp[numrecs - 1], &o, &s, &c, &f);

Fix this by extending the used counter to uint64_t and
checking for the overflow possibility.

Reported-by: "hubert ." <hubjin657@outlook.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Changelog:
	v2:
	 - use uint64_t instead of xfs_extnum_t
	 - use check_mul_overflow() for overflow check

 db/metadump.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 24eb99da1723..39639a0d51b0 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2395,21 +2395,24 @@ process_btinode(
 
 static int
 process_exinode(
-	struct xfs_dinode 	*dip,
+	struct xfs_dinode	*dip,
 	int			whichfork)
 {
 	xfs_extnum_t		max_nex = xfs_iext_max_nextents(
 			xfs_dinode_has_large_extent_counts(dip), whichfork);
 	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
-	int			used = nex * sizeof(struct xfs_bmbt_rec);
+	uint64_t		used;
 
-	if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
-		if (metadump.show_warnings)
-			print_warning("bad number of extents %llu in inode %lld",
-				(unsigned long long)nex,
-				(long long)metadump.cur_ino);
-		return 1;
-	}
+	if (check_mul_overflow(nex, sizeof(struct xfs_bmbt_rec), &used))
+		goto out_warn;
+
+	/* Invalid number of extents */
+	if (nex > max_nex)
+		goto out_warn;
+
+	/* Extent array should fit into the inode fork */
+	if (used > XFS_DFORK_SIZE(dip, mp, whichfork))
+		goto out_warn;
 
 	/* Zero unused data fork past used extents */
 	if (metadump.zero_stale_data &&
@@ -2421,6 +2424,12 @@ process_exinode(
 	return process_bmbt_reclist(dip, whichfork,
 			(struct xfs_bmbt_rec *)XFS_DFORK_PTR(dip, whichfork),
 			nex);
+
+out_warn:
+	if (metadump.show_warnings)
+		print_warning("bad number of extents %llu in inode %lld",
+			(unsigned long long)nex, (long long)metadump.cur_ino);
+	return 1;
 }
 
 static int
-- 
2.51.0

