Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1458CAD21
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295127; cv=none; b=q5t9aEm2nOV9oTOjKwQ8b+vnDtuvdo5lJQgJfOqYLy0IAbgIzjyso5SRDKNgE8Ox9l1h5HE6GHGzFpL6O+YiDH33LJLQkFv3UB9HkDSwe7nukxSP2cHMtqgCEwNzso8em0owvKAq9f6jMEtjH4w125/oB7tfW+5mNIbqFzh/juk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295127; c=relaxed/simple;
	bh=mXLCqqYMR8Etv2B/ClcJ5CA0MBbNgpoCEoSCy4aeHmU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MSJQ/O0DNtTGaKK5isrzhyjxe9JKiMzP1TuJpUFvgmC3JCbR7C66oPUM3aeoF0nHrzLrveHhAtJWpm0JLN24UgugN5xkXX4HYqdXnY7i2FUt+f+m0GBGOhAch+JDPUpwNxNd+rhvnQj8Fu75od/LI4cXAPyRqInRaAYxDpq32bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8T+pU/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8T+pU/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B73C433F1;
	Wed, 13 Mar 2024 01:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295126;
	bh=mXLCqqYMR8Etv2B/ClcJ5CA0MBbNgpoCEoSCy4aeHmU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K8T+pU/1O+h9MTtnOUCYMLOaiyyj8SP3RMQ4eJxThTRCcxSXuiyPBoHRQvMM2Ykc8
	 5zwnbgTEAqZio+ZbjQmx2F+pTn/8PiWt2Ku50jgMfwW2d1dxrzWoiIlYxjpiWbljcT
	 yPU2f1WyNHjiF8FGekZhRgAp6BtvO/gyqI43aypGNpht0kHcfex8Wvip2gmSTbcLXB
	 VuvGR28B3+AnaSLdhMd7BkSONH5X5TlTXii/5u/BtjcFjfSz103kT7q4n/8oaj1IQK
	 RqACNwDdhDzb1SP7hDa11QHli0rJKNs5UTXeVf1/y/0YMhkoTy+0HDdAkvDk+KWt/E
	 IcIWFwGb39ReQ==
Date: Tue, 12 Mar 2024 18:58:46 -0700
Subject: [PATCH 22/67] xfs: update dir3 leaf block metadata after swap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Zhang Tianci <zhangtianci.1997@bytedance.com>,
 Dave Chinner <david@fromorbit.com>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431511.2061787.11942265269678902193.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
---
 libxfs/xfs_da_btree.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index a068a0164363..3903486d19d2 100644
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

