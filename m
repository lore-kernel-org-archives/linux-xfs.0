Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1CB63D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300780; cv=none; b=i+SkD/u8GFXJeGbdRQOEDgIdk7ElhgE17evfQtuRdqIaIZDb96rAQvY4Q04QecQCl8b1TOR6Br04FsHDGgjF3o/h+KLZDJJHxqsrNNSsn4+OAvZOcDScadudpP2o2179Ehv44jee3+eCvOcEL0u4TSxMy7hncIfHd1n+J1jnvlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300780; c=relaxed/simple;
	bh=YB6LGPg4laErKm6ba8BGrHDa+oP290ymgPN08DXflNw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fHFgolD1FVtZQ5W5sxtGDNfG8n8dqtCyhsJEn2sBlaIx8K+lyKDW6jz0/GklLh9+jeclJGTImkVvsmNipbXbjq4Yi8WGurVAk8pIe2EuRM93GDYzOymkIC7rjbviOYyDH1vr9iXDnqQVDixwiQKZKiw1YDIQHbPkYQWNzkwnExM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOJUeI04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOJUeI04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030C4C32786;
	Tue, 30 Jul 2024 00:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300780;
	bh=YB6LGPg4laErKm6ba8BGrHDa+oP290ymgPN08DXflNw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lOJUeI048hJBtWpoewFecTC+3yBrjABhpeBfa+8P7FUBD1fpyHfPcCLfOdxIyrEQ7
	 rAADQ/tHWu+oAo6LAkPVTjAEVdtVBaLQVx/0CK7eYXnjenWSu08hA2egjeL/nmZk3b
	 ApKyQbDwO7r1Ll+MM8HXGJ9IZUekyNoMdTNSAMhNLUI8TUVAew+z9B8tQbc46VJ+ET
	 YMwZds7Xo4xxrKSqdqPuJhY8guEq9ITe03+GzUV+wpZjcJmcfpEGfusudlRG/A5NRU
	 Y9GzkYf0YbRz8rF1puGJlQbp3VWXtAw1pig/65hwGrqVrkPv74ps2fE1MD+npqpEDZ
	 zSvPCTFNYi94g==
Date: Mon, 29 Jul 2024 17:52:59 -0700
Subject: [PATCH 112/115] xfs: make sure sb_fdblocks is non-negative
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Wengang Wang <wen.gang.wang@oracle.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229844017.1338752.2042405284909950974.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Wengang Wang <wen.gang.wang@oracle.com>

Source kernel commit: 58f880711f2ba53fd5e959875aff5b3bf6d5c32e

A user with a completely full filesystem experienced an unexpected
shutdown when the filesystem tried to write the superblock during
runtime.
kernel shows the following dmesg:

[    8.176281] XFS (dm-4): Metadata corruption detected at xfs_sb_write_verify+0x60/0x120 [xfs], xfs_sb block 0x0
[    8.177417] XFS (dm-4): Unmount and run xfs_repair
[    8.178016] XFS (dm-4): First 128 bytes of corrupted metadata buffer:
[    8.178703] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 01 90 00 00  XFSB............
[    8.179487] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    8.180312] 00000020: cf 12 dc 89 ca 26 45 29 92 e6 e3 8d 3b b8 a2 c3  .....&E)....;...
[    8.181150] 00000030: 00 00 00 00 01 00 00 06 00 00 00 00 00 00 00 80  ................
[    8.182003] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[    8.182004] 00000050: 00 00 00 01 00 64 00 00 00 00 00 04 00 00 00 00  .....d..........
[    8.182004] 00000060: 00 00 64 00 b4 a5 02 00 02 00 00 08 00 00 00 00  ..d.............
[    8.182005] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 17 00 00 19  ................
[    8.182008] XFS (dm-4): Corruption of in-memory data detected.  Shutting down filesystem
[    8.182010] XFS (dm-4): Please unmount the filesystem and rectify the problem(s)

When xfs_log_sb writes super block to disk, b_fdblocks is fetched from
m_fdblocks without any lock. As m_fdblocks can experience a positive ->
negative -> positive changing when the FS reaches fullness (see
xfs_mod_fdblocks). So there is a chance that sb_fdblocks is negative, and
because sb_fdblocks is type of unsigned long long, it reads super big.
And sb_fdblocks being bigger than sb_dblocks is a problem during log
recovery, xfs_validate_sb_write() complains.

Fix:
As sb_fdblocks will be re-calculated during mount when lazysbcount is
enabled, We just need to make xfs_validate_sb_write() happy -- make sure
sb_fdblocks is not nenative. This patch also takes care of other percpu
counters in xfs_log_sb.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/libxfs_priv.h |    2 +-
 libxfs/xfs_sb.c      |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 64bc10e10..5d1aa23c7 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -210,7 +210,7 @@ static inline bool WARN_ON(bool expr) {
 #define WARN_ON_ONCE(e)			WARN_ON(e)
 #define percpu_counter_read(x)		(*x)
 #define percpu_counter_read_positive(x)	((*x) > 0 ? (*x) : 0)
-#define percpu_counter_sum(x)		(*x)
+#define percpu_counter_sum_positive(x)	((*x) > 0 ? (*x) : 0)
 
 /*
  * get_random_u32 is used for di_gen inode allocation, it must be zero for
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index f45ffd994..bedb36a06 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1035,11 +1035,12 @@ xfs_log_sb(
 	 * and hence we don't need have to update it here.
 	 */
 	if (xfs_has_lazysbcount(mp)) {
-		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
+		mp->m_sb.sb_icount = percpu_counter_sum_positive(&mp->m_icount);
 		mp->m_sb.sb_ifree = min_t(uint64_t,
-				percpu_counter_sum(&mp->m_ifree),
+				percpu_counter_sum_positive(&mp->m_ifree),
 				mp->m_sb.sb_icount);
-		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+		mp->m_sb.sb_fdblocks =
+				percpu_counter_sum_positive(&mp->m_fdblocks);
 	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);

