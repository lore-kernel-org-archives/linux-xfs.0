Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681AF2222CB;
	Wed,  5 Nov 2025 00:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762301521; cv=none; b=U+A0C5gOAUxCMv/3ON1gtsgV+lVjX0ACn086Lxc//POs5zfEpOE8X5uMMKl3OETXohV6U2210Zb3llMa0D8yTCwPjANEbcRzFVRMQ4mHDswpjwO5WBtdZpsxDVkUkscEy0rVRL7llYaPqzHxBfKpKe6RHNXBTEffhwcwdZd3QhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762301521; c=relaxed/simple;
	bh=ogp/Edro7JS3yLYMD6nY9wbm+7/v/eEGchm3BKxcCFc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dv3YlR2t/yKfirdkI/zrBb/gZp2XGUd4lfhXU1YzCbQL2MXJTWq6P8acuzayD6VRruSpeevHkYjq60KrgSasxhBXqSYyQQeCKA8TX6UJWE1jOB+OeFDOjSFj2qndfSs2f1dCPbbP/h16OqORHN955Ds0PfCiAq7dgj7NdkUfw4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o6nazgHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o6nazgHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F84C116B1;
	Wed,  5 Nov 2025 00:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762301521;
	bh=ogp/Edro7JS3yLYMD6nY9wbm+7/v/eEGchm3BKxcCFc=;
	h=Date:From:To:Cc:Subject:From;
	b=o6nazgHdvqlBjoPpBaiQ2BpfYx0qdo+KEfzjeWd6kER3UkU1LQEBOHr2wLwSz2iLj
	 QMgmq03XebCqYO/dEUmlzEOQ+myEQSxfFNC5D38pLP9s4FG1QC//D0GM4du2RL9LG4
	 0nhRosKrRJwfrGg2uffvefJrOU/V4sEJyh5gxazxL3wEPYgjF+ehcMghTBHcLmV8lZ
	 xKuj8/2DG5msXEs8PyiHYUkXOJfkzUUWZ+JBdYvIPB8QU5W6wR4M9Zt7mHGD+ww/wS
	 amlYUKCJsakzYzTRo7zsRBnCuE/JMg/dxPMSjbGBS1PqsF4DP14UXKNYyMmJgKiuM7
	 rNgfFZvklrUww==
Date: Tue, 4 Nov 2025 16:12:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zorro Lang <zlang@redhat.com>,
	fstests@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/2] xfs: fix delalloc write failures in software-provided
 atomic writes
Message-ID: <20251105001200.GV196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

With the 20 Oct 2025 release of fstests, generic/521 fails for me on
regular (aka non-block-atomic-writes) storage:

QA output created by 521
dowrite: write: Input/output error
LOG DUMP (8553 total operations):
1(  1 mod 256): SKIPPED (no operation)
2(  2 mod 256): WRITE    0x7e000 thru 0x8dfff	(0x10000 bytes) HOLE
3(  3 mod 256): READ     0x69000 thru 0x79fff	(0x11000 bytes)
4(  4 mod 256): FALLOC   0x53c38 thru 0x5e853	(0xac1b bytes) INTERIOR
5(  5 mod 256): COPY 0x55000 thru 0x59fff	(0x5000 bytes) to 0x25000 thru 0x29fff
6(  6 mod 256): WRITE    0x74000 thru 0x88fff	(0x15000 bytes)
7(  7 mod 256): ZERO     0xedb1 thru 0x11693	(0x28e3 bytes)

with a warning in dmesg from iomap about XFS trying to give it a
delalloc mapping for a directio write.  Fix the software atomic write
iomap_begin code to convert the reservation into a written mapping.
This doesn't fix the data corruption problems reported by generic/760,
but it's a start.

Cc: <stable@vger.kernel.org> # v6.16
Fixes: bd1d2c21d5d249 ("xfs: add xfs_atomic_write_cow_iomap_begin()")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
v2: adjust label names for consistency, add rvb
---
 fs/xfs/xfs_iomap.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d3f6e3e42a1191..788bfdce608a7d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1130,7 +1130,7 @@ xfs_atomic_write_cow_iomap_begin(
 		return -EAGAIN;
 
 	trace_xfs_iomap_atomic_write_cow(ip, offset, length);
-
+retry:
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	if (!ip->i_cowfp) {
@@ -1141,6 +1141,8 @@ xfs_atomic_write_cow_iomap_begin(
 	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
 		cmap.br_startoff = end_fsb;
 	if (cmap.br_startoff <= offset_fsb) {
+		if (isnullstartblock(cmap.br_startblock))
+			goto convert_delay;
 		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
 		goto found;
 	}
@@ -1169,8 +1171,10 @@ xfs_atomic_write_cow_iomap_begin(
 	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
 		cmap.br_startoff = end_fsb;
 	if (cmap.br_startoff <= offset_fsb) {
-		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
 		xfs_trans_cancel(tp);
+		if (isnullstartblock(cmap.br_startblock))
+			goto convert_delay;
+		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
 		goto found;
 	}
 
@@ -1210,6 +1214,19 @@ xfs_atomic_write_cow_iomap_begin(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
 
+convert_delay:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	error = xfs_bmapi_convert_delalloc(ip, XFS_COW_FORK, offset, iomap,
+			NULL);
+	if (error)
+		return error;
+
+	/*
+	 * Try the lookup again, because the delalloc conversion might have
+	 * turned the COW mapping into unwritten, but we need it to be in
+	 * written state.
+	 */
+	goto retry;
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
