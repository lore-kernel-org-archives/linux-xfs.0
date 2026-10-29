Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793240581;
	b=YOOZ1LO0EdnvlC/i8FavxrfDdrKxbtfQuti2jztnLExtasRVwWXP93JZS+DwJAULqFMT
	 zfHcBcwJ1W+qhX+AqRdLA9FSD98guYkvc4kOIdYAny02mBkXKnzq5k4WtJDsb6wvrfn1V
	 sr9AzgJEziTXraLTHDHHyu+r/Gj4Ms63TnbaA94uygaclIOYjz+NVHLkbED/6L96dzogj
	 Kk3Iai/+IfoxTbd2tMnRU7HVWiF/dk6yxG2D3cdaYZYPWb2Nk5W5CdpMRrqhdjM8Gjccw
	 Ed6hoFMRLdus9sEclyiLQu+l11VGj3qmq8ChUXMUi8atmC9aMGbmZl+4HtYMgxzRaRg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240581;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=iB/5vspO3sp8JRzyk7tb/1N/Hks7Oqawak5tEov9F3I=;
	b=ztslT6w+xFCqsb6NyjxQx3pEI09csfy5lDHJxnAL78aBjHTql1q/z9VO4on43Pc+oyBm
	 gjBKjn2NGV7no+fOfqsVEOXE5Sqs3khlF7dSxD43Vo3OdF24Ob3+Csj50W0Vx/vS2FEeC
	 fIJkpjQ+v912lEaeZgJ5XHLYl/BaELuL7lItuKTDVUPrFnJRFo/KBRcfR5EtZ/h06aV+o
	 UbsVOYpVJWDGXKXSDAd7S1xEAGyar12zLEyNiqcNBRlS7AtSetUPGbt3vmnboEf1nsGWh
	 ONCErT9/E1/BN+nJnytlZuvXLDvCwxZULu9MSxQ+suvLPt8pCIwWbR5nvixQxOUFsCA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A657IAng;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD96606A334;
	Thu, 29 Oct 2026 02:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A657IAng
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793240581;
	b=KUe4ScWmEfV2zfEvQUyYWds5jwR/KBI6urE0ZE/kkHahEKtqZLPzaWu1OX9I5JDSQuiJ
	 Vypnt8l/W2E9zmajP9ZCpw7OS2p3HqdMCLpXolNjXJP6jEBsURZT3ypEj9gyzdtiwOqhh
	 7G6uFEEv5QE/NELb03MVa0nV1twBgi3Vz/0FkfPmfahuTQvmEeSbUZpKjH04L7ijangTn
	 VmPa/AFFmvIBt7UbXsX5VfM/7marJkgg8Dgsa/vCDZSkLLHOB7pl5D44hXywRCqIm75Qf
	 J5q1hFXvfc8zCfsmdrF5Z+Zz9VoW8iEefMZDh8bO8zLcn2H4eFLvn8Rh3ZC6kJbhVcA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793240581;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=iB/5vspO3sp8JRzyk7tb/1N/Hks7Oqawak5tEov9F3I=;
	b=3t51+9q8i2ZwMIZrGmoxen97knggIB9sQ1mzPh88FFbApMLlr82OIbDOrM584+UU5xIH
	 EDh5rEcPihAe1Qhd44l63pc86BJAHyZqcz7cTWxWdv/61548TTVEolypN0HJoySlvETA/
	 Q6LdisXMm5XOdRlX4pXgOOmT3zgbPHrWfKlWnjpIPl+cys2SFd+WctpjquYpInotSnRHP
	 B7Oc2FD5ScDU029YHxvzu2SSLzTFVXZgflDtupciaIBrvK8XiAn7hQ9wpXzxhLRMAOp67
	 Wyhzhr3EvIkmYHTwXjqIO34oycQIm/Yg/Vx1EnmXreFEL6QQ0PnWw0V8drjX3GdgeMw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 86B1B1F031E0;
	Thu, 29 Oct 2026 02:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793240581;
	bh=iB/5vspO3sp8JRzyk7tb/1N/Hks7Oqawak5tEov9F3I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=A657IAng0B+s8L/dY1cD+hzuFSTavToo/Jpc83l5PoC0vD6IsJ3KUcMTeM9gIALc4
	 +DpNZLXdHhJW3K1bVpDLQNZSjNhbPJnSqzHwG6H3kpJDUAWJEX98oKjS3OxRBy/HpR
	 J3FblUaOwM43nbOscbOgUEmC5zscQ1IC9rFJ3H769IZihUT9PFbEacUm2ob1pjJF5s
	 KS/bk0tsvdIvt3yerRsGX2pjRp5lGbEhuOf+8G5/1RENBal5N4UyuAyugO6cX4Vkw+
	 Dbe5D4qnX4422oJkcGUqCvVGmlIT2VsZwFeqzzBWIrihfPv1iFIUkPtcVD5yvcBEOA
	 ODiG3rlAfGLqQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EF92F4569A;
	Thu, 29 Oct 2026 02:22:58 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 29 Oct 2026 11:23:03 +0900
Subject: [PATCH v5 6/9] xfs: clamp the pNFS layout range to the maximum
 file size
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
Message-Id: <20261029-xfs-pnfs-batch-v5-6-ef8d2eafb7fa@samsung.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793240577; l=1638;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=h3kDaDnSxaNkNdPO5+D/zdTOiMO3KGReZaK/sxBg6HU=;
 b=uOl7x45gv53m81qbrJ0oDxFz+LsIxylNyceMlMW2fSZU24CH2e2/QD56YN0rj0bXAC6/XhULZ
 4Aql/hKSOmpDc28/tm+s5lHCoek6y0M5hB7iP/S19PzBKm8hPQyWx2F
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_map_blocks() lets two bad layout ranges through. An offset of
2^63 or more is negative and passes "offset > limit". A length above
the limit, such as NFS4_UINT64_MAX, wraps "offset > limit - length"
and stays unclamped. With NFS4_UINT64_MAX, a read layout is built from
an uninitialized mapping.

Reject a negative offset and one at the limit, and clamp the length.
This needs "xfs: cap the block count of xfs_iomap_write_direct() at one
extent".

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
Tested with pynfs: a READ LAYOUTGET for NFS4_UINT64_MAX bytes at
offset 0 and one for 4 KiB at 2^63 got NFS4ERR_IO before, and get
NFS4ERR_INVAL after. The first fails when nfsd asks again at 2^63,
after the last extent.
---
 fs/xfs/xfs_pnfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 19eb18e129..7153e7a1e1 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -176,10 +176,9 @@ xfs_fs_map_blocks(
 	if (!write)
 		limit = max(limit, round_up(i_size_read(inode),
 				     inode->i_sb->s_blocksize));
-	if (offset > limit)
+	if (offset < 0 || offset >= limit)
 		goto out_unlock;
-	if (offset > limit - length)
-		length = limit - offset;
+	length = min_t(u64, length, limit - offset);
 
 	error = filemap_write_and_wait(inode->i_mapping);
 	if (error)

-- 
2.43.0


