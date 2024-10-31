Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818E519CC1D
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416935; cv=none; b=CWdwf45lfIRmpzYOW6AKi5hPhBFzYvQgtLa3DGNuFZA9xhmqrHVzl3kUFf7NO4PeIPGWWBKEiYMnD+t/a2V6DJ9y1lVt0I4WpChF7LkByJ+aEw1C+x/JuKakSxXGSj1LqZYa7AE+RSX5Lqk6EdWAF7EHex7bCkV6vEXs9aYHMb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416935; c=relaxed/simple;
	bh=vIqqv8xPHLWGmfp++KAEwo9r4kkTq9Ask+tvd3NMO70=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r7wqxj5q53/d84D20jv3otVb9llaHZ4R20KMYPFzPK6D1RWI4Zzp0Y63BNtz8iStZmY4XplBTlGlPxblr9kH4xGY1oXmMOQA1MQm3tXERPZE1hv3PfVi3C4VdoQwTdm6vKzTb/s1qMqv8dfoL7GrvCKdL9goorPYeb3wGWOXohg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9J1Abgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9J1Abgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B8CC4CEC3;
	Thu, 31 Oct 2024 23:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416935;
	bh=vIqqv8xPHLWGmfp++KAEwo9r4kkTq9Ask+tvd3NMO70=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L9J1AbgtkIqW5L4jWpqRKjvubZkbPQFdBJyXJCRoWL1f/zWN0P4EWxJtjIzVxm5Ob
	 pB+pS6NzzdiB43kEHsMnKKVSRqDxg1Ljz5lX9gyELjn9quukJNKQaGXM8jFD9G4mSK
	 fxWhq+hK+wV13a0/N/0kzs8NQ+MtvbE4LV3EJG+VrBiER5/bxGSF9OXVLT252PncwT
	 QBaLI0bV8fCIX+bai4B2NYa5TcSV48OV8RkbTfv6lumoige2PUihUUgq+Jas/oELFg
	 45s0Am3Z3GBgAAGwzFrpnLiFmKurC//UESSrJhTXXwcyHUhiix5Lh+FYB7KmO+2zct
	 wrZaWRV/Cd3ew==
Date: Thu, 31 Oct 2024 16:22:14 -0700
Subject: [PATCH 4/8] xfs_db: access realtime file blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041567399.964205.1770258006718318777.stgit@frogsfrogsfrogs>
In-Reply-To: <173041567330.964205.623580785256778088.stgit@frogsfrogsfrogs>
References: <173041567330.964205.623580785256778088.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the ability to point the io cursor at the realtime
device, let's make it so that the "dblock" command can walk the contents
of realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/block.c |   17 +++++++++++++++--
 db/block.h |   20 ++++++++++++++++++++
 db/faddr.c |    5 ++++-
 3 files changed, 39 insertions(+), 3 deletions(-)


diff --git a/db/block.c b/db/block.c
index 6ad9f038c6da67..87118a4751ef94 100644
--- a/db/block.c
+++ b/db/block.c
@@ -196,6 +196,13 @@ dblock_help(void)
 ));
 }
 
+static inline bool
+is_rtfile(
+	struct xfs_dinode	*dip)
+{
+	return dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME);
+}
+
 static int
 dblock_f(
 	int		argc,
@@ -235,8 +242,14 @@ dblock_f(
 	ASSERT(typtab[type].typnm == type);
 	if (nex > 1)
 		make_bbmap(&bbmap, nex, bmp);
-	set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
-		nb * blkbb, DB_RING_ADD, nex > 1 ? &bbmap : NULL);
+	if (is_rtfile(iocur_top->data))
+		set_rt_cur(&typtab[type], xfs_rtb_to_daddr(mp, dfsbno),
+				nb * blkbb, DB_RING_ADD,
+				nex > 1 ? &bbmap : NULL);
+	else
+		set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
+				nb * blkbb, DB_RING_ADD,
+				nex > 1 ? &bbmap : NULL);
 	free(bmp);
 	return 0;
 }
diff --git a/db/block.h b/db/block.h
index 7c4e8cb2acb051..55843a6b521393 100644
--- a/db/block.h
+++ b/db/block.h
@@ -3,8 +3,28 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+#ifndef __XFS_DB_BLOCK_H
+#define __XFS_DB_BLOCK_H
 
 struct field;
 
 extern void	block_init(void);
 extern void	print_block(const struct field *fields, int argc, char **argv);
+
+static inline xfs_daddr_t
+xfs_rtb_to_daddr(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtb)
+{
+	return rtb << mp->m_blkbb_log;
+}
+
+static inline xfs_rtblock_t
+xfs_daddr_to_rtb(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		daddr)
+{
+	return daddr >> mp->m_blkbb_log;
+}
+
+#endif /* __XFS_DB_BLOCK_H */
diff --git a/db/faddr.c b/db/faddr.c
index ec4aae68bb5a81..e2f9587da0a67c 100644
--- a/db/faddr.c
+++ b/db/faddr.c
@@ -15,6 +15,7 @@
 #include "bmap.h"
 #include "output.h"
 #include "init.h"
+#include "block.h"
 
 void
 fa_agblock(
@@ -323,7 +324,9 @@ fa_drtbno(
 		dbprintf(_("null block number, cannot set new addr\n"));
 		return;
 	}
-	/* need set_cur to understand rt subvolume */
+
+	set_rt_cur(&typtab[next], xfs_rtb_to_daddr(mp, bno), blkbb,
+			DB_RING_ADD, NULL);
 }
 
 /*ARGSUSED*/

