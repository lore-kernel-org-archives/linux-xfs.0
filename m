Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D5D3115BD
	for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 14:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762870312; cv=none; b=VWfgkIEJp3cbTOgrnu7e6XUbWXFslli5musViP8R8aVugong4HXm+LjG7EtiYhAYHJJ9u0oB0wbNI2I2h432yGLsJ+dgokDoK344922z9lVsi3M8PqVF2F3gM55ivloVstYc4c8Y6+vzh+sixC/SD3KWuK0HwP+A8BXlLZWa3R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762870312; c=relaxed/simple;
	bh=MH0KXhVR5TpPR5MgKC1TlWC9btmC8oLjnMtM5L7/gnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OyJ0cuxW8S+MPbeGGHV+p7FYitrXy5YitwA4+rA8fC+lmuOKQsPPh+ivWt1z3GZP0LT95lc7KOt6qonKOVBedNmGnfnbsRR6hAlrcNDbiK0XxO0jj1jCpi/OFzoLr9L8fpTsuWLyc5N2zB5ZTYbExtPAomR8G5qPVffcxMEo/T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SCM6RPd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SCM6RPd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810F6C19422;
	Tue, 11 Nov 2025 14:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762870311;
	bh=MH0KXhVR5TpPR5MgKC1TlWC9btmC8oLjnMtM5L7/gnQ=;
	h=From:To:Cc:Subject:Date:From;
	b=SCM6RPd7PyPXnjzRRZCv+on8Sa3L3W7raQ7Q5kr9lJGlia7hQmmUEj6nLNArTjrZV
	 sAnZ0e5mUqkltrUZRwEAmcVqCfuVa5Vq8CGdgFhZkxCUwUm2VjDXTYzL2qcA1M0E69
	 B+U5ZH2mnfUqDcb+ZMiN6o2MomntCx9SVZyEReF9aQp+SRzPgQwYB7yS9UVafAOrN9
	 zD3+UbIMXVhgasXUvq/ZSbeKkvPnF0hIEU6UDc8Oy8RbJowfJ3KYOI3Nfh5E7+OuUO
	 N5H++c6VkptPjlQvxG75vR+AsY4rfO6Ho0I5E3uDf20RxctF8yetfJVuOluB0yk5/t
	 iqE6M6mOZuhJA==
From: cem@kernel.org
To: aalbersh@kernel.org
Cc: david@fromorbit.com,
	hubjin657@outlook.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] metadump: catch used extent array overflow
Date: Tue, 11 Nov 2025 15:10:57 +0100
Message-ID: <20251111141139.638844-1-cem@kernel.org>
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

Fix this by extending the used counter to xfs_extnum_t (uint64_t)
and checking for the overflow possibility.

Reported-by: "hubert ." <hubjin657@outlook.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 db/metadump.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 24eb99da1723..430120ec8888 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2395,21 +2395,25 @@ process_btinode(
 
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
+	xfs_extnum_t		used = nex * sizeof(struct xfs_bmbt_rec);
 
-	if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
-		if (metadump.show_warnings)
-			print_warning("bad number of extents %llu in inode %lld",
-				(unsigned long long)nex,
-				(long long)metadump.cur_ino);
-		return 1;
-	}
+	/* Catch used extent array overflows */
+	if (used < nex)
+	       goto out_warn;
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
@@ -2421,6 +2425,12 @@ process_exinode(
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

