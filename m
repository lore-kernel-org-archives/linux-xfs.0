Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144E2371CFF;
	Fri, 25 Sep 2026 04:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309620; cv=none; b=M0J1GQVxn70EZ08AHNmHG/0XHXUQB5BGWANDmzBeInC7ZtYqDDNNgBrEWqnvIurxH/BYEt/fYbHj91j3zoIZIPkSO4zgIKKAnDvOuel1WoaZpYFLSuKQQbn4kToGJmtS1GBVa0ZvXzwzIVwUPMqajBBpA3mGB9mYJrJz8Nk4a4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309620; c=relaxed/simple;
	bh=2hR6Uuaw9sCHP9NFQ4JtAB112ufKsDzbrO+VmWYClBg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QdT9M17lJNyzucD4dAAvCziOhq41OvOaNCAessto4mn7vpDgqC2QqZUgegjWVOHYEOn4MGFkclUdsQaKbzdVikZrFK0u/LimB3SoAO96HWkyy6kzylDF6HTz3xERPZo/lCnOgQtNZadGMlAglKfsNdvQYZp0z9MLWK81xS0S35c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gkd1VP+9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gkd1VP+9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 99F561F000FF;
	Fri, 25 Sep 2026 04:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309618;
	bh=HRfHxjeQoLoryi0a4RZo288MfTf4W3DJJp36JcTu3gQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Gkd1VP+9FPeIkWZ5MwmrrMkw1jMKydGc5CoVT/ZfC9LFo4DUqmiVcnhBeqia4ef7p
	 f9K5kX2tG38txBZPUfpFPXnTCrk6DQDte8yAHkMqcN+7C5Xw+tnjdxNTn/byuy/7rO
	 NQcaadX+bkPKCDJb09a+snUAl4Eis3itzKBuQGcUUXKUpM1My3FnAbf52xW2HD4g8R
	 jyrzuk8oU+5392U7l28Yn0W32et7MBHyzj9FcsRWufso7BsakXYCkJ/n8lBA04hZ02
	 +8u6XDbWd31EcPlYjHcDttbXEXCtSkswK6aI0YPPUzKGt6r6JVhdA9olRL6UxKIJ1+
	 Pf8sxTBHh06ow==
Date: Thu, 24 Sep 2026 21:13:38 -0700
Subject: [PATCH 12/12] xfs: check fork type against dabtree block magic number
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179030932303.3344850.1246558346723808401.stgit@frogsfrogsfrogs>
In-Reply-To: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that we fail to flag dabtree blocks that should never be
associated with the file fork -- data forks can't point to xattr leaves,
and attr forks can't point to dirent blocks.  Add the missing checks.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dabtree.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 72cd880a5745e7..639228601cc6bc 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -410,6 +410,10 @@ xchk_da_btree_block(
 				XFS_BLFT_ATTR_LEAF_BUF);
 		blk->magic = XFS_ATTR_LEAF_MAGIC;
 		blk->hashval = xfs_attr_leaf_lasthash(blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_ATTR_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;
@@ -419,6 +423,10 @@ xchk_da_btree_block(
 				XFS_BLFT_DIR_LEAFN_BUF);
 		blk->magic = XFS_DIR2_LEAFN_MAGIC;
 		blk->hashval = xfs_dir2_leaf_lasthash(ip, blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_DATA_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;
@@ -428,6 +436,10 @@ xchk_da_btree_block(
 				XFS_BLFT_DIR_LEAF1_BUF);
 		blk->magic = XFS_DIR2_LEAF1_MAGIC;
 		blk->hashval = xfs_dir2_leaf_lasthash(ip, blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_DATA_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;

