Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793240582;
	b=CjYkCrKC10D+NgutMm3yuZHEEtH5xZX8mptyYEtQngXNKzRMlR/De6D0RE712oSwuSrw
	 muVpFKpshnvoV6p5x9gUzEWvX0zb9Rxn0sQCX6g/Uj26t2EQmDYUC89gCkCp1XuOQ6Knx
	 LIACoWnytELBnFEfyBLiEsIO8tXM2LoY8eKSt9dH1GqXCl69q5mm9uMO7rmYSIITaxQ2h
	 4h5jSeIdBWi+PHD+Y6XJ8p3+7G7isZGbr2SEtT7MLpxTpFCKpyTR35LVZuJ24FcsjrImu
	 zYBcIrTZMAFymPCAqwDoPwp8z/37TyV4a81TubqOZekoga+IXjjgZM+WyqHbFwjiZYQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240582;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=nPWe1MZcaauB5DmJIKhgVpdHqQn55nVwVELsf5Xb/eU=;
	b=zpxdq7awhDy2yenurJTu3LIOVtKrsF12NdxY7EwnIsCUSctf+vjW/2w9T0NZPTbZK9gP
	 zM6t5d6mKx49BuqNhf8jF0HXewa2LmgkDezQlkQqZjqXTNBEQWQgE/up3xiGiFuZR3L+Q
	 V/BGq4HvLZ0BRWbeJyZgOaOPNzEzsb60nxmhfgl26uq4DvCE+WrbqCnUprvJ+afO28v9T
	 D0yrT04Q0u8ocIz8a371P/gx4JmsX6vq5zmr9vmMgbjL45doTQDciNMZ9vT8vrHN/yYWg
	 LOjmRakhBy13NE22Lxv7fAQuylkzKuFBKP2MYSNuu7SJ/fGV3futWt+R+cxHQCTGaEg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fL4GmXUV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6916F60A260D;
	Thu, 29 Oct 2026 02:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fL4GmXUV
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793240582;
	b=Hlya09S4L1rd/0rI/Ex8pQe0KD6SvUqXu692sI1orMnE2LqLBie3G9rbeH/IZn6hYJbf
	 EX42Utfrmpmf5tUI0REYy7ni5uvi5DDO/oGELUqBac2NboTOqUMwS2X1/SSv36WOU4Om3
	 EJHIfcEuK5+vnw3zcVsXMnFdv/gJ7PRf/v5epFu8C6A2Qlj/Ji/p2Qv/91XyfgymswDhQ
	 +j/ubpZ5AV3eB4irGUfnj0soesrHup/L8lKmS53yNEhlOVcvkl0xux2YUL7jOse8jWq9j
	 de5wciZkiRLUGXwZsugehJ4zJEUiJwg0X7ACsvYM/9xOf/Xld+d6vNoLrTc4ib/MDeQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793240582;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=nPWe1MZcaauB5DmJIKhgVpdHqQn55nVwVELsf5Xb/eU=;
	b=RXY6I/4XrrFVhStnZInPkiI2VKee0Of4yiXPAH3RyGLvb3X+5FlnHnhblljjCOfwjF0a
	 TDR0ENaJ4OsX+4NELfJUu1D60f0sLABzJilm7gEnzM5bWD4VFMJMbHH61KC5O7sso8dpQ
	 rMdfF99sKMz3p0IiOflZcIlbksogsBMFJ5o52Vu7KrhW5s3ROdWnAXh3aR6nBFCGaLNjn
	 2FLzCaZ9/Si0LgfY8ZcOJ46fnlDvnh2OoffdX9DVWy6xJGWpMysWWhXPrWygwPUm3xWsO
	 E7mz1/kk69uAFNJ2mTSlOl7UnrRnVH27UoZsd20DL0YxYK7ZaZ2NlPsYUTgG6UF0j9w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 840A71F031EC;
	Thu, 29 Oct 2026 02:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793240582;
	bh=nPWe1MZcaauB5DmJIKhgVpdHqQn55nVwVELsf5Xb/eU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fL4GmXUV/4iyJd98Q81POsTFHLuiO+4bRJizuNwhCxeTUs2QhRkBi8TRb85e5R4uL
	 1XdKvNWpzdS4uX29b6XgLfeM9QUm7xKIJ7oEhDeXSkq58P9zi2+PM5aQ0Rbjj4C4q1
	 Ojb7E0q+Upy7AKD+8jGPdWUKBhf7+hshZNB7/U8Q2uENpcRspHp3jwKJn2nLX14Zh6
	 oN2JfWWjYOcFLltwgxHas6VBvTKtEUP5getTyEGNemrEQ3K9B2p23nV7uleRSgPruM
	 0J3YkefadkDv5WnQ7X8we1taEGfj3r3vGAC/Od5bWo957E7mKwKC7gGW2uRVByzzDx
	 F1hiz9HLrJOmw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E537145696;
	Thu, 29 Oct 2026 02:22:58 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 29 Oct 2026 11:23:02 +0900
Subject: [PATCH v5 5/9] xfs: cap the block count of
 xfs_iomap_write_direct() at one extent
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261029-xfs-pnfs-batch-v5-5-ef8d2eafb7fa@samsung.com>
References: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
In-Reply-To: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>, 
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793240577; l=1933;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=aeK9qMxGbPp1LcY6+3H1RkPMvPFHl7/38YF8dOmhwok=;
 b=kdvSoV3L5wg8zEipmWBoyAxFBf8dEDZ4H8D8OmXcBcSIkrBvMTp2gToF6073Uql6WTfjIBFQ6
 VvOrfnOc7KpD+9ftyAjEM7M3y1RtSqOC0O5sq8bE5knVl54Hd7Ut8/Y
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_iomap_write_direct() reserves blocks for the whole count in an
unsigned int. For a pNFS layout the client chooses that count, and an
RW LAYOUTGET for 16 TiB wraps the reservation and shuts XFS down.

xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks here, so cap
the count at that. nfsd asks again for the rest. The other callers get
the same mapping as before.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20261008154017.GO2705364@frogsfrogsfrogs
Suggested-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20261015060932.GD14035@lst.de
Suggested-by: Pankaj Raghav <p.raghav@samsung.com>
Link: https://lore.kernel.org/r/atoImJxtg70XcIjS@quentin
Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Tested with pynfs on a 32 GiB XFS: the 16 TiB RW LAYOUTGET shut XFS
down before, and gets NFS4ERR_NOSPC after with XFS still running.
Like one for 100 GiB, which allocated nothing before, it now leaves
about 24 GiB allocated past EOF.
---
 fs/xfs/xfs_iomap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 99d48081c5..c3465204b8 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -285,6 +285,14 @@ xfs_iomap_write_direct(
 
 	ASSERT(count_fsb > 0);
 
+	/*
+	 * xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks in one
+	 * mapping, so don't reserve blocks for more. A pNFS layout range
+	 * comes from a client, and its block count may not even fit the
+	 * 32-bit reservation. The caller maps the rest with a later call.
+	 */
+	count_fsb = min_t(xfs_filblks_t, count_fsb, XFS_MAX_BMBT_EXTLEN);
+
 	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
 					   xfs_get_extsz_hint(ip));
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {

-- 
2.43.0


