Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5777F44236A;
	Thu, 15 Oct 2026 04:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792037282; cv=none; b=Wv2VnMSYoh/aNFB6xJOEaVddhCv38acUwKOVwSe6T3+nWJdqgywjUWNFRgAlsqF+kSVV25KVQrAv9vDYBXaSfYTBUrSfUbQZ2VvKuVmHIKSbqz0ptGaEXfsAsN/mqtRjzMKgFqjh8VoJK1dW97HbxwEDlvykjb4C/+PIQSt8i6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792037282; c=relaxed/simple;
	bh=5jUzyXystoapM5osuDxpBBRGYmQ56igP/uHZfzLDK7I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KHCKH6lHNF3Otg8gzR+9qTIewQ++j9t/L3zQRqIR2AaIfxRnE3qoOAEF8km57leF0o04KAzXRp9YUCZIKhuXeo9dr3Cw6WV8JodCqkDl8a9o5AzyI/l+B4fjGO7+MA4vHZsj/FMcSE3ig31YTg+eGs1AnZ41ksiasvR4YWYX1+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sKQ+xbs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sKQ+xbs3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1692DC32786;
	Thu, 15 Oct 2026 04:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792037282;
	bh=5jUzyXystoapM5osuDxpBBRGYmQ56igP/uHZfzLDK7I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sKQ+xbs3LzAtdtAkvRVvQS036IeRNFCjOyOHVTRD6rNTmE2XoJ4DunLciLbs5tiC2
	 C6gRw5q4kPLip2Qmb4WvkNlv+GqDasYfm2VscPYb6398Q8Xw508hwbD76aa83vFXbZ
	 gR4C0znn/+AIGDBL3+DTZMotMP73xQDwgcj1B9jt5BLvPPNgI53Lbe/goLI0wzzPjz
	 8Jyei82WDOF+OeGXSA8OOXqKpwACRafelCFCZvnR8zH6PjWEGjn3kRdTZ23ydhTcg/
	 gaG60FGPARbBkI3bNWZqtTZBPK4QH4+VRzCCd67Xo7FpoDspgRuHd2YUMYP1ka0CGE
	 cuV0YMCJg7OcA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024F7CC6B1C;
	Thu, 15 Oct 2026 04:08:02 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 15 Oct 2026 13:08:04 +0900
Subject: [PATCH v3 5/9] xfs: refuse a direct allocation whose block
 reservation would wrap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-xfs-pnfs-batch-v3-5-54fc7b2e467d@samsung.com>
References: <20261015-xfs-pnfs-batch-v3-0-54fc7b2e467d@samsung.com>
In-Reply-To: <20261015-xfs-pnfs-batch-v3-0-54fc7b2e467d@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792037279; l=2377;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=btUTqeEJKiqxOQ/dnZ/pyDycHq0h2fbnVhzHcqIm/9c=;
 b=i0WqcOr1jzAjfQofxrOxkcNUZYsnCcOOlAFtp5abo9Yo5wQHB7ekDrhLIXlNih3JGI9cc/mdT
 S4DWG8oVW7nDtABSh5Mvq0oVkAkMBdGdBiQGKqqclaJKj9aWRVGJeUh
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
filesystem with that much free space, as the transaction cannot take it.
A count that fits is reserved in full, as before, so a request for more
blocks than are free still fails before anything is allocated.

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
index 99d48081c5..92b9973425 100644
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


