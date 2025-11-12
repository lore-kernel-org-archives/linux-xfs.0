Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2525623BCEE
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762960784; cv=none; b=ZTs6rPcSwb72+JIotwgH5026PH4aav+IHuvXbxJXKBwAy2SruUfuqgub1NS/D9UGCS3HUhO0N96xxCmDtDjlD6x0y1Vlru9/UF5R+MPKUR8pTuwke9U5zQgDStLRs3Ym/aXG45/iWBJwDPhgbZT9O+gHW6WHOCtQNniGqmDe6ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762960784; c=relaxed/simple;
	bh=k7LHs+SdwhJUQmSYVYaDCEwafJBHZD/+g7iRBtz3niU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDjEo61inn7WNyQGCFKktN55o0sUxjZ6Q3FQmTro11h0GeBWgrBgYwsa3McqkfhxHA6unKdxpd7hT5OYlOXKCCZfFoUxuCrBLI/Uaz06rjY+Y1tBtvMi2HVE3gAdxwbYawjHETman87ByAxk0iwSCLYHzzxyX+O9HpPzIsceEzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=gd6oNV8i; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="gd6oNV8i"
Received: from localhost.intra.ispras.ru (unknown [10.10.3.121])
	by mail.ispras.ru (Postfix) with ESMTP id 08C214078519;
	Wed, 12 Nov 2025 15:19:33 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 08C214078519
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1762960773;
	bh=NiVv1SfamD1zzYdlLtGaR59XsqdNZWh89lzTwPMydk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gd6oNV8iOdKaNLdb7QX6YD5JcfRw2G3NVA8nNlR+NJtV/ijhUpql5y+FuqBIhPJY2
	 HmmSnlpf2ZccEO9ssU9zdgaWFfJwEuww1UsoBb4xKvLcbbcnjQL2NiYLH4j+uSTglt
	 8nDRIXhjdM7nseWQJnHKFvSkEpoCf8cVmwjYgb9w=
From: Alexander Monakov <amonakov@ispras.ru>
To: "Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs_db rdump: remove sole_path logic
Date: Wed, 12 Nov 2025 18:19:31 +0300
Message-ID: <20251112151932.12141-2-amonakov@ispras.ru>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251112151932.12141-1-amonakov@ispras.ru>
References: <20251112151932.12141-1-amonakov@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eliminate special handling of the case where rdump'ing one directory
does not create the corresponding directory in the destination, but
instead modifies the destination's attributes and creates children
alongside the pre-existing children.

This can be a trap for the unwary (the effect on attributes can be
particularly surprising and non-trivial to undo), and, in general, fewer
special cases in such a low-level tool should be desirable.

Signed-off-by: Alexander Monakov <amonakov@ispras.ru>
---
 db/rdump.c        | 19 ++-----------------
 man/man8/xfs_db.8 |  8 +-------
 2 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/db/rdump.c b/db/rdump.c
index 9ff83355..73295dbe 100644
--- a/db/rdump.c
+++ b/db/rdump.c
@@ -852,7 +852,6 @@ rdump_file(
 static int
 rdump_path(
 	struct xfs_mount	*mp,
-	bool			sole_path,
 	const char		*path,
 	const struct destdir	*destdir)
 {
@@ -890,20 +889,6 @@ rdump_path(
 			dbprintf(_("%s: %s\n"), path, strerror(ret));
 			return 1;
 		}
-
-		if (sole_path) {
-			struct xfs_dinode	*dip = iocur_top->data;
-
-			/*
-			 * If this is the only path to copy out and it's a dir,
-			 * then we can copy the children directly into the
-			 * target.
-			 */
-			if (S_ISDIR(be16_to_cpu(dip->di_mode))) {
-				pbuf->len = 0;
-				pbuf->path[0] = 0;
-			}
-		}
 	} else {
 		set_cur_inode(mp->m_sb.sb_rootino);
 	}
@@ -980,7 +965,7 @@ rdump_f(
 	if (optind == argc - 1) {
 		/* no dirs given, just do the whole fs */
 		push_cur();
-		ret = rdump_path(mp, false, "", &destdir);
+		ret = rdump_path(mp, "", &destdir);
 		pop_cur();
 		if (ret)
 			exitcode = 1;
@@ -996,7 +981,7 @@ rdump_f(
 		argv[i][len] = 0;
 
 		push_cur();
-		ret = rdump_path(mp, argc == optind + 2, argv[i], &destdir);
+		ret = rdump_path(mp, argv[i], &destdir);
 		pop_cur();
 
 		if (ret) {
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 1e85aebb..920b2b3e 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1147,13 +1147,7 @@ the filesystem as possible.
 If zero
 .B paths
 are specified, the entire filesystem is dumped.
-If only one
-.B path
-is specified and it is a directory, the children of that directory will be
-copied directly to the destination.
-If multiple
-.B paths
-are specified, each file is copied into the directory as a new child.
+Otherwise, each entry is copied into the destination as a new child.
 
 If possible, sparse holes, xfs file attributes, and extended attributes will be
 preserved.
-- 
2.51.0

