Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC96188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992376; cv=none; b=uNoRvPxrDIOLd4cbCQWnMzS2HhCgIGTpgfWNrtVv10ZPhw4wYpqyC+oVZ/ztj929YhKATqKsPNeHXxp3OffXBjBRMKVLiqsThS4D6AkWTgQHpOVRYIiVBZS5UooSJ6zN/ik8vqD9AnsMqHcskdpGVhZBhLhMLrCM5cVs/pfo8VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992376; c=relaxed/simple;
	bh=MAXN88n4DMTn1aHwrlxaf67GCDsL31mKQ37UoFHtCLs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SXIAI+ZborRaz8w19gqVWEwjskZuVxgLgz7pwyIVN8TwWX48kxGbWIfqSsbisOvFkUS2q5fXjo/uzlqqwmnXZmPrr7t42DzKP2CaEMc6QhBqHAp9wIUqlX0MbA8iA79+0QPrQ3ol+UwXNfvNZjkSGNu3C5lhU7tFjxHLykHbRys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWIbM5Ve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWIbM5Ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBE8C4CED3;
	Mon, 23 Dec 2024 22:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992375;
	bh=MAXN88n4DMTn1aHwrlxaf67GCDsL31mKQ37UoFHtCLs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CWIbM5VejgKrBJbAzROdPk9vaIa1nVsMk6Dang6jCCUmg/ofBM9cTKQrVxPgg9/47
	 VUVE50uSkCWOWd3JuTf1AAZAj97ry3B/QsXzKpPqb1otLrZUVB2U0AfpbMxLs5zRn6
	 RjqFkD69F1yMuY9yX8EdhYGrLScyzFt38fInCjVQrb/fTm/t6fjOCy8tafxENKKNwr
	 n6arVrn45npJoeDdPJIgvnhc0bQxkdquF34unyUqASHj2VhR+jrStnjE5U1lsxZzNr
	 eyPOsMJWixVNUZ4rYM8Qg4jSDSKko4L6s4I2TLcPl0KW6yjErX8nJtafTb2klbPD+Z
	 GYmHuFrm55QYg==
Date: Mon, 23 Dec 2024 14:19:35 -0800
Subject: [PATCH 30/51] xfs_db: metadump metadir rt bitmap and summary files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944263.2297565.11753153507899715984.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Don't skip dumping the data fork for regular files that are marked as
metadata inodes.  This catches rtbitmap and summary inodes on rtgroup
enabled file systems where their inode numbers aren't recorded in the
superblock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/metadump.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/db/metadump.c b/db/metadump.c
index 144ebfbfe2a90e..8eb4b8eb69e45c 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2072,7 +2072,11 @@ process_bmbt_reclist(
 	xfs_agblock_t		agbno;
 	int			rval = 1;
 
-	if (btype == TYP_DATA)
+	/*
+	 * Ignore regular file data except for metadata inodes, where it is by
+	 * definition metadata.
+	 */
+	if (btype == TYP_DATA && !is_metadata_ino(dip))
 		return 1;
 
 	convert_extent(&rp[numrecs - 1], &o, &s, &c, &f);

