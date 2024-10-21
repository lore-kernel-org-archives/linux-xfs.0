Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA6239FD6;
	Mon, 21 Oct 2024 10:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506953; cv=none; b=kayl2bRkaK+PbNzjzbsVx3gyZpvDYc0xTnK3WiXlSeDnQq8V31KwBBa7vOalt70jRwqLOw1FJvW3nBOUDmbtt9vkYFJEJr3md3Q9QRmBwH7zVpbNZWNhmtNbpFft4l1MiQgHyNIxOjIqD8Qd99bDJ9j8crAzbhSCEPB9Nq4KxC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506953; c=relaxed/simple;
	bh=RWJavJGla8AvWDtsyMaRLimHOGoNe+xtluh3vry3Hh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jR8I2YE1f7IJRsMA8XW5Gc+jvq11MCjnmRjnTKwG1gDep8Dy2EyvPkolmNCDYxHZALseQToDmJsNFqhVERu/Y489l2y3g0bLij+dCoF+Vpt8vg8oPQkBNjzH+kA7dbWUWU2x/0qTpRBr+tfr750YBRvie7vyUANNv7Ywrxu9O50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjXiijyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjXiijyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08FBC4CEC3;
	Mon, 21 Oct 2024 10:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506953;
	bh=RWJavJGla8AvWDtsyMaRLimHOGoNe+xtluh3vry3Hh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjXiijyH/9huxGO20b7JtFMSrjnuH+dwfGpGwCDsHWHafz+mLjCPlCmUE3zwh968N
	 9NlVWyBtdxkGAujDVGh8okqIj4mmR0xCN0NZzh6fUNBSKajhiKrjmLiGiiJ9NRJ5Ea
	 SHE4uKuh4TannH62AM3xtxM7iim8Z66G5Wa0hTxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	Wengang Wang <wen.gang.wang@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 040/124] xfs: make sure sb_fdblocks is non-negative
Date: Mon, 21 Oct 2024 12:24:04 +0200
Message-ID: <20241021102258.279125173@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wengang Wang <wen.gang.wang@oracle.com>

commit 58f880711f2ba53fd5e959875aff5b3bf6d5c32e upstream.

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
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_sb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1031,11 +1031,12 @@ xfs_log_sb(
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


