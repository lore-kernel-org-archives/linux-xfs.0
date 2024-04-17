Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE576482C8
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389251; cv=none; b=tN64xl0l5utCS0MICoafZAnpk865r+Uhp+0HHRNkSI+M/ibJnoo9rG+G6uP0wtmAtofWNFuJi0fahLLwnGTFaHDQSwYJ0PWcU7D1Z5MfxBn7Bo7A3oPXePDGqsVSDXJyIz3d4bupdH4C5etlvc/DJVNTiPBbLjiIm2Vc00F93Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389251; c=relaxed/simple;
	bh=KRqEhh7U4KwZnL8Ea+IHqMsy/TX5cnexR8qk7YDaOr0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GTPrD1iWyJV5iSYjbWTXyB5DPGFlY/iQpTErBDN4ThTdLFnPQhoSQCS8E1uE7js/2gZ0y7Abzpi5w2Jp020c5qiBk500tGtlEZPgWKvxIh/5mqzquTyf9YTA8fEmNIOTVTxb2yaxYS947/BXeZYfPHl22FxVPPyFyEmMVQqf9wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qZERNWYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qZERNWYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476ADC116B1;
	Wed, 17 Apr 2024 21:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389251;
	bh=KRqEhh7U4KwZnL8Ea+IHqMsy/TX5cnexR8qk7YDaOr0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qZERNWYVfzH4QUtSy/omZQVFFe14ZnFxCqdKy+lPjsZDCTKRrf6mN8NE9WiFU+0N2
	 kCexlCUhyleyXV4Iui7N6R+hEnGfIcC3XhCKSgKBodUbrvz+cp4Ja8kBgUJDQ8y7Ns
	 d9jsO25e5VU7cA8umqAsJY/ix5OFHjkLaZTxESPXOK2HQFJYa8BkFLYc+z/RnnSb2Q
	 ufk2jeplT0CtQTgCexq2fHhFHL1B6uuWMz0xNZ194XQ77abgAx0TZfmZq0SW56Olyh
	 lMgTuiIZh6WIdYi3vssZEuLvEKt3nX/ZD8KnKzPovilxegBvEoJ1mNB0cBOBmwlObR
	 e3q7nBAZSF7Zw==
Date: Wed, 17 Apr 2024 14:27:30 -0700
Subject: [PATCH 22/67] xfs: update dir3 leaf block metadata after swap
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Zhang Tianci <zhangtianci.1997@bytedance.com>,
 Dave Chinner <david@fromorbit.com>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338842670.1853449.16909784251134215987.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_da_btree.c |    7 +++++++
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

