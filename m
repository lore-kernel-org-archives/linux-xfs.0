Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7A62931F5;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791423571; cv=none; b=qNrS6KLTvHicYwYB3ryC4vCyDBtY7bgdrXG3lDvpw2NdaIecTDQc06UiqzpZaFgkhLedh0j5ERJja/BScwGyA7CktvNxzEGBA0ps0PS1Tlep0WoplOUXOZkcfDMxQJYxyTbYnPqiAtt+rHboUIJY1XAIv69KlzN+YwV5bj+ItGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791423571; c=relaxed/simple;
	bh=0GXQGuAcREKXfgh4lINceA7vez8LtOZqhWpDymD9sRs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Wlp0yKj9Qvg8y05jgHT9sX4hyZlK0qcWWvSDtSRtRm/ZACU7rKx2D9VSaB/L2mgkLjxUEZe5Ovv0XviKGTfs0NUt0BTsN7Db/nabriQX7/Xdoc2ZJLg1lWojzbKfj3Yls8L193MB53vj0ZGHnHUYyfIfb9BfneYnv0amPLYctbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7byY9HY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7byY9HY"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3BA5FC2BCF7;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791423571;
	bh=0GXQGuAcREKXfgh4lINceA7vez8LtOZqhWpDymD9sRs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=H7byY9HYhY1s4rotvzy0egXeBw5NafNkBed1/nxjbmBNrWqGl5Us+aZYHH1jwygAs
	 0IlPQ1smFVcGOJhjzcSGVlstW3+oW4pefVvJFJqUSM9cvkKYWcntcxOY67U4psvd++
	 q7H5ayyaCadGcZq6K/XhsqId3ky0nSBaK4mPT6QiA9N3AAwSChI6FoHum70mpGy3o3
	 C6BW1JSPkauDuBsa+LQ4R3x7q7VVx0PDEgjCDeZnwJpCIJ4PWv0+wM2PAzu5wIN06f
	 BdO1YinfOLIctw3JSTcx1iCG+QIevZUjENsgOUmx08OZYiTEsTR25mhFOWtvGpQTGp
	 BefXr5nHNPRqg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FB2CA600C;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 08 Oct 2026 10:39:31 +0900
Subject: [PATCH 2/8] xfs: refuse a direct allocation whose block
 reservation would wrap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-xfs-nfsd-map-blocks-v1-2-560026cdccb6@samsung.com>
References: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
In-Reply-To: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
To: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, 
 Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Christian Brauner <brauner@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791423569; l=2365;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=TgcEzJiRm0kG/kpwtVJnUxNYpa17XFqyuVHzFMTWefc=;
 b=nXT2lMRKwomwin0Noo+Pg4rGnzfPT+T2Y7oHvm/DoqBqcmWCQJn3sAJBobXBULzhKPCsWc7IC
 1ljV0rHj6NLB5PZosP/0MaKg0Mk7evQ8dmue6dIXOkxL9K26h5rEITz
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

From: Daejun Park <daejun7.park@samsung.com>

xfs_iomap_write_direct() maps one extent, but it reserves blocks for the
whole count it is given, in an unsigned int. A count of about 2^32
blocks or more wraps the reservation. If it wraps to a few blocks, the
allocation uses more blocks than the transaction reserved, and
xfs_trans_mod_sb() shuts the filesystem down. If it wraps to nearly 2^32
blocks, the allocation fails with -ENOSPC.

Direct I/O, DAX and buffered writes with an extent size hint never ask
for that much, as xfs_direct_write_iomap_begin() limits them to
1024 pages to keep the count below 32 bits. xfs_fs_map_blocks() has no
such limit: it asks for everything from the start of a hole to the end
of the range of a pNFS layout, which a client chooses, and an RW
LAYOUTGET at offset 0 of an empty file for 16 TiB does it.

Fail such a count with -ENOSPC before anything is reserved, also on a
filesystem with that much free space, as the transaction cannot take
it. A count that fits is reserved in full, as before, so a hole longer
than the free space still fails before it is allocated.

With pynfs as the client and a 32 GiB XFS, an RW LAYOUTGET at offset 0
of an empty file for 16 TiB shut the filesystem down: "Corruption of
in-memory data (0x8) detected at xfs_trans_mod_sb". With this patch it
gets NFS4ERR_NOSPC and nothing is allocated, as with 100 GiB, and one
for 16 GiB, which fits, is still granted, in three extents.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/xfs/xfs_iomap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7c6238fed6..1917e49166 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -287,6 +287,13 @@ xfs_iomap_write_direct(
 
 	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
 					   xfs_get_extsz_hint(ip));
+	/*
+	 * The transaction takes the block reservation as an unsigned int.
+	 * Refuse a count that does not fit rather than reserve too little;
+	 * only a pNFS layout for a huge range asks for that much.
+	 */
+	if (resaligned > UINT_MAX - XFS_DIOSTRAT_SPACE_RES(mp, 0))
+		return -ENOSPC;
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
 		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 		rblocks = resaligned;

-- 
2.43.0


