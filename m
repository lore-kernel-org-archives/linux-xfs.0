Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.189.121.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794393058;
	b=oi47Qt/nLaqtUpdGGfDPiuWwpGNd2girGK1QPqmXlEC9M0HI9/KKUGvw3OjwLAqszSga
	 K3AB0sKzZGnx6k4POQi+vlS7SdD0KyxKbmSTmMHYSfHoBlTjzSt8PLkTLl3zG+87/yl3w
	 YjXroYNZLIFc1GVqWhQTDoCaU7XtGPGhntp4V7dfeaZSOFxg63A4bYLsRTOqBAgDLJCSN
	 Y8HNLfQh13RIWY1ZP8lfszJHsx/j8mpVtswJQzA5l9TEvmySiGAuUPhvtVj8GRpnzfy0S
	 ezCZvWw23vfObKUrmx6cC9BZ2SylOj9UoFjOO+qA8KOXHpeb397KStLBHMVbUjxU5pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794393058;
	h=DMARC-Filter:From:DKIM-Signature:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/I4bFa+psfJpgNv44k5w5uIx+LTkP2to/gMQAwFYuG4=;
	b=3Txca47+a9GP1EjEDvWxvdJwYCbSkzDEYdKQv2h/lfpty5MxebSoTaNIQUCoi2gIsQfH
	 vPYVGPgU6ym7YVbEaxucZa4oeNkBDJ243Cf+KGbgUZjGMIoI2qa7ntdV8SM5BRd9AkzOv
	 jlHsNJFR62o6Une/pJfR20bX23AVr4eCU8B2/vmr0IsRXmivRTlmDryqgIjRHirpRnQPV
	 tOgUjR/3hHBmiSwwZONRwC0miUKYNfe8aLuDeR5nzPdKmhqCLlMW7PcULZe0JGaHJg/aH
	 jU/DczUMcnIIo3wuKaDYynaVaj/C4s3vyaiu28/qbElyvszk01+fAm6lSlO2J28Yc2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=itx.no;
	spf=pass smtp.mailfrom=itx.no;
	dkim=pass header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=f2kxejuW;
	arc=none smtp.remote-ip=91.189.121.228
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B82606A31C;
	Wed, 11 Nov 2026 10:30:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20B82606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=f2kxejuW
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1794393055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/I4bFa+psfJpgNv44k5w5uIx+LTkP2to/gMQAwFYuG4=;
	b=f2kxejuWurzx8W+S9X0vlmUlL3qc+jXhEl3+40grVTS3dJR99sdMbnVX8Yx24hdEUbARDk
	/7cZYlzuXF7S6fhrEl+UdqLhN7al7Q0RHbP4BeEOYzhZESPWQk1nRrxXR4DPZQWW+/2MwH
	1N05ChU7VLyP/9ti9tvm5hm2RYTaSkA=
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	sparclinux@vger.kernel.org,
	Stian Halseth <stian@itx.no>,
	Jan Engelhardt <jengelh@inai.de>,
	Dave Chinner <dgc@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v3] xfs: fix unaligned access to rmapbt high keys in scrub
Date: Wed, 11 Nov 2026 11:30:47 +0100
Message-ID: <20261111103047.604541-1-stian@itx.no>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The high keys in a rmapbt node block aren't naturally aligned.
xchk_rmapbt_check_unwritten_in_keyflags() reads rm_offset through
union xfs_btree_key and the union is 8-byte aligned.

The compiler may use an 8-byte load, and on sparc64 each high key
takes an unaligned access trap:

  Kernel unaligned access at TPC[105a54d8] xchk_rmapbt_check_unwritten_in_keyflags+0xb8/0x160 [xfs]

Read the keys through the packed struct xfs_rmap_key instead. This
tells the compiler they may be unaligned. Decode rm_offset with
be64_to_cpu() and drop the byte-swapped flag.

Fixes: 38384569a2a8 ("xfs: detect unwritten bit set in rmapbt node block keys")
Reported-by: Jan Engelhardt <jengelh@inai.de>
Closes: https://github.com/sparclinux/issues/issues/115
Suggested-by: Dave Chinner <dgc@kernel.org>
Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Stian Halseth <stian@itx.no>
---
Tested on sparc64 (T4, 7.3.4) by scrubbing the rmapbt of a loop-mounted
image: alignment faults per scrub went from about 4000 to 0.

v3: separate key and rkey variables plus a comment (Dave), shorter
changelog.
v2: https://lore.kernel.org/all/20261110223927.558557-1-stian@itx.no/
v1: https://lore.kernel.org/all/20261109134853.1659991-1-stian@itx.no/

 fs/xfs/scrub/rmap.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 68e2847c962bb..7609c03cdc8ab 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -149,8 +149,6 @@ xchk_rmapbt_check_unwritten_in_keyflags(
 	struct xfs_scrub	*sc = bs->sc;
 	struct xfs_btree_cur	*cur = bs->cur;
 	struct xfs_btree_block	*keyblock;
-	union xfs_btree_key	*lkey, *hkey;
-	__be64			badflag = cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN);
 	unsigned int		level;
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_PREEN)
@@ -159,6 +157,14 @@ xchk_rmapbt_check_unwritten_in_keyflags(
 	for (level = 1; level < cur->bc_nlevels; level++) {
 		struct xfs_buf	*bp;
 		unsigned int	ptr;
+		/*
+		 * The on-disk high keys in an rmap node block are not
+		 * naturally aligned, so decode them through the packed
+		 * struct xfs_rmap_key to make the compiler treat them as
+		 * unaligned.
+		 */
+		union xfs_btree_key	*key;
+		const struct xfs_rmap_key *rkey;
 
 		/* Only check the first time we've seen this node block. */
 		if (cur->bc_levels[level].ptr > 1)
@@ -166,15 +172,16 @@ xchk_rmapbt_check_unwritten_in_keyflags(
 
 		keyblock = xfs_btree_get_block(cur, level, &bp);
 		for (ptr = 1; ptr <= be16_to_cpu(keyblock->bb_numrecs); ptr++) {
-			lkey = xfs_btree_key_addr(cur, ptr, keyblock);
-
-			if (lkey->rmap.rm_offset & badflag) {
+			key = xfs_btree_key_addr(cur, ptr, keyblock);
+			rkey = &key->rmap;
+			if (be64_to_cpu(rkey->rm_offset) & XFS_RMAP_OFF_UNWRITTEN) {
 				xchk_btree_set_preen(sc, cur, level);
 				break;
 			}
 
-			hkey = xfs_btree_high_key_addr(cur, ptr, keyblock);
-			if (hkey->rmap.rm_offset & badflag) {
+			key = xfs_btree_high_key_addr(cur, ptr, keyblock);
+			rkey = &key->rmap;
+			if (be64_to_cpu(rkey->rm_offset) & XFS_RMAP_OFF_UNWRITTEN) {
 				xchk_btree_set_preen(sc, cur, level);
 				break;
 			}
-- 
2.43.0

