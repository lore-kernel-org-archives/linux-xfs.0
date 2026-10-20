Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465729;
	b=j4C7HNKptnccYWLtnOE1MLCTZr6LoRWiFWEMChIy/IfXwzVTL+e3OGjn4EfxRd2zpI8Z
	 wep+lH/JJuCF2S6stiZVYpFCrPHVx/9LltBk7F3jr+ydwWNJsNF0ZPMjaoB9b+tVVJ7Zh
	 cHzmeyOIxsoBkpADRFbi+oYbtKmTx5ZbmBnbJGi0ZR+bGKd6PUIhSZFzr+fTC/okWVzyB
	 L15r3AqdXvcafx1xy15FCGvNLCw8C0wtw/7gx0SnXx9TFve+u45GhcAbAcv2sTWsF/X44
	 oOwzaqa5RNGlmakIgZmSxjvvk7NuZ2TbTCNbNNl18nfmt+Vjnl6rAnKgaXu/rTofQEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465729;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bxrnAoVqDNpnv/2vOx/ustH7FAUo4eaHKrH/eCYifQ0=;
	b=s1SDskN4wOrvFXH5Lh/lbqQp8+CXa47Wpc3oOl4EqLTol96bjfiABlmaHSM0UkxhHn9/
	 9ibEVrzk7WUq9uCOzGxiH2aX8Q3I/vKedIymEtCdi4G+pOpRf80VL4ix2JXWu9IWQMSKw
	 HUANKowYOWgv66leCrW33Mq9bVayFwqQfoceneOFfr8stshbPwH7hG1Xdnjh4MTY/bIXU
	 dO65P+mRh0YQQBVCuCsu3I1KfMyZWAzAszmfw+vt0RTUUs9A3IE02n3Eof97X1y3xBUf0
	 HZ800r4FddhegVAONAejnvbRMYMrUCcmIhNr1zkqGXQCBmleeX96gBUKX1QaQMEiAgw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DQR21ohz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C975660A2603;
	Tue, 20 Oct 2026 03:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DQR21ohz
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465728;
	b=V1Cd+LVMibkb7Y3SxYttvUCuPm30AYjTz4OUVyO5ZRFxlcI4B+iTYomyr4fKdlowkJa/
	 U6jDOeawgB2HFF5REnwdXWhPBmuPzje1DPzTe0929sg/0Gb3o5+nIFlz7W0dBLmXS7iMr
	 pRj0jid1ut0vI8FwUIQ5uMatx1pMuORLjmd8RLJmQOxMAB5GKy2m7HRPhULnmF6te7YBk
	 HVk5Y+Hvt26qpTBVO2pdomIW6vifAqv5jFrMXsyjdqf2JQP2yRQLbskrvxb4U9GHf02pF
	 l6YuzlhsIskzOFLmqhS05dTbBeyLhXt3ikyqjIb7SCCDOswc5usOo9AfESFetljRLOw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465728;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bxrnAoVqDNpnv/2vOx/ustH7FAUo4eaHKrH/eCYifQ0=;
	b=L83MkQY8ToC6W79vt+o3BhnMJXv0R01VEwGG0skmoqz00tNtjV5Kn5EhxmoRFLar+pBz
	 vwU8q52zw9M6QxSF+l24fBZ5pRTTyZZ+i574D811V4F20FEF/qagL+kAJnliLaU98RLzt
	 qFOrvkBoM4DqlKtyWU0xH1gOxPj/Zf0uSxFEHgcYFtYCVB5+GwlxprLFDbUqQ5gxCfzqO
	 DXgj7VxLGDzabibR00RV/mf1uWWfSFVA7QZh8HeDMih7tUmOVNLG/A/ru+2W9FFkO1v5q
	 DAjPdvqYzfTxsVjLbPDQybu8jqLz2kiLXbtaPdulvMG+xMPGejzsd/Y1Lb8VOy8+Kbg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B72521F000D1;
	Tue, 20 Oct 2026 03:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465728;
	bh=bxrnAoVqDNpnv/2vOx/ustH7FAUo4eaHKrH/eCYifQ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=DQR21ohzIOc2FhspfE/iKMBmRgcXN2ttIOm0jKRaFo8pvft2GypkEUB+DX6d0RF8W
	 VUrqBGmAFwG8a52PG6DSAoXa3hvf3DLa9vLd0JWfLyefmlBk8nF+klAsCkmwWN671C
	 RZcep1Y+bunnc1aWdlJ1QXRG+HdUNPCnGgcZCi+dbIJ0r4rSt4ek3aYnKyz1L+BFMF
	 9CgA8Evwb5OPqtusjDIMi70uNIbrz5O/E0tUBNAgttcwqXObdNhJnaM4aNFtjpatFm
	 w8hsUhyU6L37S3CqHevqP7SxC+0G41BIDboScFo2hbIDkjvnMTuZniNNsW+46Ij3GZ
	 CyNDrN601shkw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F2A6440975;
	Tue, 20 Oct 2026 03:08:44 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 20 Oct 2026 12:08:48 +0900
Subject: [PATCH v4 5/9] xfs: limit the count of a pNFS write allocation to
 one extent
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
Message-Id: <20261020-xfs-pnfs-batch-v4-5-9230fa2ca4a4@samsung.com>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
In-Reply-To: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465723; l=3759;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=bIokulr9YmNCvihfXF2HXvVG1KbQ9zOS6h+CiqM7w0k=;
 b=s78AkhLG828fo4VOvL4QMljwxBhouOcu4IvrIPAXWM8XOXbyFNICpXUArUQ5R66nAJBzVK4d7
 MrBZqyH+1opBWW70VuqFGwmUwmbPQ0/r+OulyNAhKXyH2UddRBqRaOd
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_map_blocks() asks xfs_iomap_write_direct() to allocate from the
start of a hole to the end of the range of a LAYOUTGET, which a client
chooses, or to the end of the hole if the range ends before EOF.
xfs_iomap_write_direct() reserves blocks for that whole count, in an
unsigned int, but xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN
blocks in one mapping. A count of about 2^32 blocks or more wraps the
reservation. If it wraps to a few blocks, the allocation uses more
blocks than the transaction reserved, and xfs_trans_mod_sb() shuts the
filesystem down. With 4 KiB blocks, an RW LAYOUTGET at offset 0 of an
empty file for 16 TiB does it.

Direct I/O, DAX and buffered writes with an extent size hint never ask
for that much, as xfs_direct_write_iomap_begin() limits them to 1024
pages to keep the count below 32 bits. Limit a pNFS allocation to
XFS_MAX_BMBT_EXTLEN blocks, as xfs_alloc_file_space() limits each of
its reservations for the same reason. This shrinks the reservation; the
mapping that xfs_bmapi_write() returns stays the same. nfsd asks again
for the rest of the range since commit cc6c40e09d7b ("NFSD/blocklayout:
Support multiple extents per LAYOUTGET"), while the reply has room for
another extent; before that, the layout ends with the extent and the
client asks again.

An RW LAYOUTGET for more than the free space used to fail with
NFS4ERR_NOSPC before anything was allocated, as the first call that
allocates tried to reserve blocks for all of it. Where nfsd maps one
extent per LAYOUTGET, it now gets the first extent. Where nfsd asks
again, it allocates one extent after the other: if the reply fills up
first (at most 92 extents with 4 KiB pages), the client gets those
extents, and if fewer than XFS_MAX_BMBT_EXTLEN blocks are free first,
nfsd fails the LAYOUTGET. The blocks it allocated stay past EOF, as
the inode is marked preallocated; xfs_alloc_file_space() likewise
keeps what it allocated when it runs out of space.

With pynfs as the client and a 32 GiB XFS, an RW LAYOUTGET at offset 0
of an empty file for 16 TiB shut the filesystem down: "Corruption of
in-memory data (0x8) detected at xfs_trans_mod_sb". With this patch it
gets NFS4ERR_NOSPC, also with XFS_DEBUG, XFS keeps running, and less
than 8 GiB of the filesystem, one extent's worth, is left free. One
for 100 GiB ends the same way, where it got NFS4ERR_NOSPC with nothing
allocated before. One for 16 GiB, which fits, is granted the same
three extents as before.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20261008154017.GO2705364@frogsfrogsfrogs
Suggested-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20261015060932.GD14035@lst.de
Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/xfs/xfs_pnfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 19eb18e129..401a790299 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -224,6 +224,14 @@ xfs_fs_map_blocks(
 		else if (nimaps && imap.br_startblock == HOLESTARTBLOCK)
 			end_fsb = min(end_fsb, imap.br_startoff +
 					       imap.br_blockcount);
+		/*
+		 * xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks
+		 * in one mapping, so don't reserve blocks for more. The
+		 * range comes from a client, and its block count may not
+		 * even fit the 32-bit reservation. The rest of the range
+		 * is mapped by a later call.
+		 */
+		end_fsb = min(end_fsb, offset_fsb + XFS_MAX_BMBT_EXTLEN);
 		xfs_iunlock(ip, lock_flags);
 
 		error = xfs_iomap_write_direct(ip, offset_fsb,

-- 
2.43.0


