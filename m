Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7A1153BCF
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803981; cv=none; b=mbYX17fKk6hjPa23LmRHIIDNrcdYfknFh75cd6x2zas93QYqmjtXjDtJpCCkZ0F8k5Jn0E0TDo8AClRUGHd/CX8IcdkiP4Zha4mNAiWYnlTRS9obXuour6+cvoA48jgkfJfIBn5EiHqWcYk2GDvbauWxPN7ySQEEP+bfB+S8Ndg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803981; c=relaxed/simple;
	bh=I3uPu+NnvYpcA54lCXV2p/3UdGR/BbZN2wGNEdvNzzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7337OehbtfolmX2VDSYMLtxIZEYqmaa5CCC5evAwgLO0zAAQnLMPyzv94RnPp27kuwLUYLk6Irgd2QVxV+aG8CV1raxmZkcW4f8YqgYkWukF6IDpVSkaGjYbittg304Yg3UGo0lmhN5LB4xIbXhq2EL45i86GwNjn341I3ZUi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMc+2aGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMc+2aGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB00C113CC;
	Mon, 22 Apr 2024 16:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803981;
	bh=I3uPu+NnvYpcA54lCXV2p/3UdGR/BbZN2wGNEdvNzzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMc+2aGHW/1f4zmSQazD17yTDf1aTQz98RZF//twvFzYFjvraHKBYIvcCv9gFDNY9
	 jL3JyIl7gCfe0DaY0g+9aj8s4hiUK1aXpjTXaDqiCiY1jNoWUJsd/IUFH/TBVnzUSu
	 qA1HIEfVQFNa9Zg4cwfw61qQuLfrWQUQ/H2APsg+stCHyCs0RaG9OQu1bJb+/vDzFM
	 s/v8h+AREPlNgaXQ2QKLpE5l19EdTHjkrZbszdit8Sg4alw0bNQhA/IYJuiAfmccpk
	 SkgpMjP6Uq65adIGtSEZqUmFwlvETnQXYg0YU4qJADNEGOeO50o7Ug2TF9mORtNjVo
	 IVasbFF3SjuTg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 22/67] xfs: update dir3 leaf block metadata after swap
Date: Mon, 22 Apr 2024 18:25:44 +0200
Message-ID: <20240422163832.858420-24-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

Source kernel commit: 5759aa4f956034b289b0ae2c99daddfc775442e1

xfs_da3_swap_lastblock() copy the last block content to the dead block,
but do not update the metadata in it. We need update some metadata
for some kinds of type block, such as dir3 leafn block records its
blkno, we shall update it to the dead block blkno. Otherwise,
before write the xfs_buf to disk, the verify_write() will fail in
blk_hdr->blkno != xfs_buf->b_bn, then xfs will be shutdown.

We will get this warning:

XFS (dm-0): Metadata corruption detected at xfs_dir3_leaf_verify+0xa8/0xe0 [xfs], xfs_dir3_leafn block 0x178
XFS (dm-0): Unmount and run xfs_repair
XFS (dm-0): First 128 bytes of corrupted metadata buffer:
00000000e80f1917: 00 80 00 0b 00 80 00 07 3d ff 00 00 00 00 00 00  ........=.......
000000009604c005: 00 00 00 00 00 00 01 a0 00 00 00 00 00 00 00 00  ................
000000006b6fb2bf: e4 44 e3 97 b5 64 44 41 8b 84 60 0e 50 43 d9 bf  .D...dDA..`.PC..
00000000678978a2: 00 00 00 00 00 00 00 83 01 73 00 93 00 00 00 00  .........s......
00000000b28b247c: 99 29 1d 38 00 00 00 00 99 29 1d 40 00 00 00 00  .).8.....).@....
000000002b2a662c: 99 29 1d 48 00 00 00 00 99 49 11 00 00 00 00 00  .).H.....I......
00000000ea2ffbb8: 99 49 11 08 00 00 45 25 99 49 11 10 00 00 48 fe  .I....E%.I....H.
0000000069e86440: 99 49 11 18 00 00 4c 6b 99 49 11 20 00 00 4d 97  .I....Lk.I. ..M.
XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 1423 of file fs/xfs/xfs_buf.c.  Return address = 00000000c0ff63c1
XFS (dm-0): Corruption of in-memory data detected.  Shutting down filesystem
XFS (dm-0): Please umount the filesystem and rectify the problem(s)

>From the log above, we know xfs_buf->b_no is 0x178, but the block's hdr record
its blkno is 0x1a0.

Fixes: 24df33b45ecf ("xfs: add CRC checking to dir2 leaf blocks")
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_da_btree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index a068a0164..3903486d1 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2312,10 +2312,17 @@ xfs_da3_swap_lastblock(
 		return error;
 	/*
 	 * Copy the last block into the dead buffer and log it.
+	 * On CRC-enabled file systems, also update the stamped in blkno.
 	 */
 	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
+	if (xfs_has_crc(mp)) {
+		struct xfs_da3_blkinfo *da3 = dead_buf->b_addr;
+
+		da3->blkno = cpu_to_be64(xfs_buf_daddr(dead_buf));
+	}
 	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	dead_info = dead_buf->b_addr;
+
 	/*
 	 * Get values from the moved block.
 	 */
-- 
2.44.0

