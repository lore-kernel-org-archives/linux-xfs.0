Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.189.121.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794350388;
	b=S/HMx8gYm/qYHeATEpk/vO9RgSmbr/SgJOxC/s3Ru+jgl9/OXE5FK19rS/qoC2gb4Fc6
	 fheUbMyU3/fU/tHzqD8/+8xMsYN5lfJW8OK26tsLH2Rf7vdsqu63vSaK2rZUezkNS+gzS
	 7a0prZF/6xEnaqINy4RcMK4y1Ry690DTsPIzOlxO1CXTgjNwKyudhXGyYx2N6I/s1wO+B
	 vIVL+Qx1z2EYTkm1XfweNrLOHz9iEJu25/Hpt82GBulpZm42VWWBNQOseMFnd8Uc4zYL7
	 RgF/8V9WmhStdZ84ldEMY2OAbcQCfeDM3iluWCIyR4JPEs1egzRPy1XUqZoq4Zl5shg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794350388;
	h=DMARC-Filter:From:DKIM-Signature:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding;
	bh=abytDKbRvkocR2z10vArTxNaa1BYMBdrXV+srDgYG3U=;
	b=xxgqUy45rmJbJtwf07oHitbOdviyD2Ei3InWG5F9reeu6DSA1A1Yk0skUogbOIT2H+iz
	 yfdrC6TkwqNXK7361bFMJnj6LqA+Jegqya+7jzQje4XYLTpTU3uNE3bC4ovdZtOsxF3g2
	 UeQgztc9fIuVLi5OI7FlG4wGMXYTtOjoWUX7T86h8d9jZXbmm2QAeXEcpLfcH5LP4fEdr
	 yXyfbmSRF0oBQpUZ+I99EmlJamm1sSbc6a2LPCD/66ReNH5DPWpSJsBkmKlPzfzsCBjcf
	 k1CV+knjqC+HF72pqa89GRRwcmnsMNMq191XT/yR1y8dutukguFi9nRN2jasZ5KlKRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=itx.no;
	spf=pass smtp.mailfrom=itx.no;
	dkim=pass header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=Na8Vxn+D;
	arc=none smtp.remote-ip=91.189.121.228
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F89606A31C;
	Tue, 10 Nov 2026 22:39:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4F89606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=Na8Vxn+D
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1794350379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=abytDKbRvkocR2z10vArTxNaa1BYMBdrXV+srDgYG3U=;
	b=Na8Vxn+D3OoyQkmLuPcA6U4R+h2EVu2LExgF+hagCflCEukX7Jb59HHQbgJBxTjAB55r1c
	FU0FVxiP64lkAM2lKKwo8apu7aFiziNvMWIqIBsIq2doEbce0KIbdYrdszgKY+gvqACf9m
	Nity4J9fqrJuIuR2070BQKuMe7BQZAo=
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>,
	sparclinux@vger.kernel.org,
	Stian Halseth <stian@itx.no>,
	Jan Engelhardt <jengelh@inai.de>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: fix unaligned access to rmapbt high keys in scrub
Date: Tue, 10 Nov 2026 23:39:27 +0100
Message-ID: <20261110223927.558557-1-stian@itx.no>
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

An rmapbt node stores each key as a low/high pair of packed 20-byte
struct xfs_rmap_key, so every high key is only 4-byte aligned.
xchk_rmapbt_check_unwritten_in_keyflags() reads rm_offset through
union xfs_btree_key, which is 8-byte aligned, so the compiler may use
an 8-byte load. On sparc64 every high key it checks then takes an
unaligned access trap:

  Kernel unaligned access at TPC[105a54d8] xchk_rmapbt_check_unwritten_in_keyflags+0xb8/0x160 [xfs]

Read both keys through struct xfs_rmap_key and convert rm_offset with
be64_to_cpu(), like the other rmapbt key accessors, instead of
comparing against a byte-swapped flag.

Fixes: 38384569a2a8 ("xfs: detect unwritten bit set in rmapbt node block keys")
Reported-by: Jan Engelhardt <jengelh@inai.de>
Closes: https://github.com/sparclinux/issues/issues/115
Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Stian Halseth <stian@itx.no>
---
Tested on sparc64 (T4, 7.3.3) by scrubbing the rmapbt of a loop-mounted
image: alignment faults per scrub went from about 4000 to 0.

v2: read both keys through struct xfs_rmap_key with be64_to_cpu() and drop
the byte-swapped badflag (Dave). be64_to_cpu() on the union alone still
traps, as it is a no-op on big-endian.
v1: https://lore.kernel.org/all/20261109134853.1659991-1-stian@itx.no/

 fs/xfs/scrub/rmap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 68e2847c962bb..29609c5967fe3 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -149,8 +149,7 @@ xchk_rmapbt_check_unwritten_in_keyflags(
 	struct xfs_scrub	*sc = bs->sc;
 	struct xfs_btree_cur	*cur = bs->cur;
 	struct xfs_btree_block	*keyblock;
-	union xfs_btree_key	*lkey, *hkey;
-	__be64			badflag = cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN);
+	const struct xfs_rmap_key *lkey, *hkey;
 	unsigned int		level;
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_PREEN)
@@ -166,15 +165,15 @@ xchk_rmapbt_check_unwritten_in_keyflags(
 
 		keyblock = xfs_btree_get_block(cur, level, &bp);
 		for (ptr = 1; ptr <= be16_to_cpu(keyblock->bb_numrecs); ptr++) {
-			lkey = xfs_btree_key_addr(cur, ptr, keyblock);
+			lkey = &xfs_btree_key_addr(cur, ptr, keyblock)->rmap;
 
-			if (lkey->rmap.rm_offset & badflag) {
+			if (be64_to_cpu(lkey->rm_offset) & XFS_RMAP_OFF_UNWRITTEN) {
 				xchk_btree_set_preen(sc, cur, level);
 				break;
 			}
 
-			hkey = xfs_btree_high_key_addr(cur, ptr, keyblock);
-			if (hkey->rmap.rm_offset & badflag) {
+			hkey = &xfs_btree_high_key_addr(cur, ptr, keyblock)->rmap;
+			if (be64_to_cpu(hkey->rm_offset) & XFS_RMAP_OFF_UNWRITTEN) {
 				xchk_btree_set_preen(sc, cur, level);
 				break;
 			}
-- 
2.43.0

