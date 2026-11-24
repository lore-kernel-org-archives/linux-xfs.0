Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795560592;
	b=SEIs4ZnXahdxtzxNz+cLyiPmiZarwIgFuHXI8MUhdMZc1HpJyBYmWUBRzuSxT2nJI9kf
	 W1T2Tn98HQ+xx5gDSzk+dNh9d1KJxtfMBkcTBlP3P03J0pfzsp81MjlIZmqkUjGLRiDZL
	 f773RWS35MaI6o6JXL7XwJuaMUTdK/iv6ukA2ueqVi55eA4lOvRZDAsKn8RdHD2vtGe26
	 YjIAMAZY3wR1j8JhJxKwQ+jQjMCoG9zrTUOAMvc9MvMvYt+e0OCUQKbL+f5K6rdWx3wnr
	 9/MUXvgLjJ2jJKb/43s/SPHGp1wxK35oFcrpqE4G4u/ppbvBO9Cl/gMVKBOsmhw6yZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560592;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=EphYM5YX2ywO0IH8QDdpTxin5RnMZrccGvDw7pxP6I8=;
	b=TUg/MOgI0BhEUnspqxrNe69T2JU5Kjf5HPvhXe6+n6SASkBhHAzgGHGf758Ey3S6FRt3
	 8YzQ6LAQbCuC34PIFGDgokWkkrulfbmOb2ZIwbcJ/2zHJIRECDWqediMsw/JowDRa4vJ1
	 oawg1D9w15Wm4AuFSxOZeOAhtP85VWnfTxe4C5DZ6mzmThQuxX7+0ubzhIH5kd6neP2vY
	 GeDcYoiVKyddqTGRNcRnHfuDQ70ygqewBgtCvFuH/XdNo70OoPbriebbyIl8xqdHXpv7i
	 MUFvQ4NZpllUNDTpukxhj+T33oh7iqIXrRZTMl+p5NLEHbwlZSTwJRrwBG0tr4TyGqg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kg8Aq6cH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A1C606A321;
	Tue, 24 Nov 2026 22:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kg8Aq6cH
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795560592;
	b=2GQ3e+7lY8QBnup6yeSII1gWQ4EBEOdl9IeWI87sk0EAkApUFrUZDt8mkWW0sOtHpXSK
	 9h/YrRTcFvQuWtXp5k+4KLYZGcsa5UIvCwhWffLG5bgsOQU8YYdHZtF/4lwH9iBp1aVvu
	 E5yHPTV42Q4aMNiJdOYw57ITB3YknqJI0gCM4XMrI9/BjYi1aa7COfxS8vyKSG0A5+KNw
	 qNIk3oLHR/SglC3h6AsAefuadDWf9K8Ogjv6GLVTYt4HLfXx2PoBGHeBFPNGWhyaM+9fz
	 F/2DPCayIMWKzsNOx8BJTFu39FkoDl8fjf2j25Q7RPm22QI1RO3ty8Fu1WfaNf/gX9Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795560592;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=EphYM5YX2ywO0IH8QDdpTxin5RnMZrccGvDw7pxP6I8=;
	b=E3Lw9NXqo3uhtKwMJX5svoXRYjR15fyHmwtYw43xogE/xunDjVag7AoZA1i4po/g0172
	 znkELaj/Sn1G9452OhWXb89TouVrc8tvnvnvyzu0KqLFnSxjg96wwkzSaXN0Obp1ksvhM
	 TxYGij3Iw7MmuxMlzLX5eO6fBg8g92ZBZWsvgEpE0d/sBvSdtaWSy8qLSMtumcovMQEJr
	 RkOXpsp9pLRlIwNtq4IkswTM2hil2hMkGQw/SVSc3xZh4IAg3X6oDJTGZr9J3zVa4hrji
	 bXTj5RIwj9O18Ybz7JSgdA2ghi3gQHIFUbIJzpsp3/yIzh5bLk0RkHTfr0Q9xjPYgzw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 630801F000D8;
	Tue, 24 Nov 2026 22:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795560592;
	bh=EphYM5YX2ywO0IH8QDdpTxin5RnMZrccGvDw7pxP6I8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Kg8Aq6cHHw2pmPe06y1i1rnG1VDFu7wE0RTeBAsibf/NFzN0cnABt0YgYUGYoK9m+
	 dPRli9hLXT5+P6GU7IYG5Nx4fdmYB/grR8jMxWdBHru7GNqXAa1DHYIBERvwPSNGdN
	 OEpSBAyNbKXFX6jn7Ll5aNKs+tuBj4uRJHHP4hC8twOXb+Rx71q+girYPeO9lDc6Ui
	 z0gCTSpN8n4WoZk86Ui/K2Uptki7WTiaY6y24GOSQQkwspQqp61c/k7QLXiTedpHq3
	 Dw7AQkKk8f7a1aG7qOLPI0IkxWEBFNFgts64UWMoWUUKc0W/dzntUSW3IYujeLzOoo
	 z5qStQkBQdAvw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E7B5C4CC18;
	Tue, 24 Nov 2026 22:49:37 +0000 (UTC)
From: Ernest Borowski via B4 Relay <devnull+ernest.borowski.git.proton.me@kernel.org>
Date: Tue, 24 Nov 2026 23:49:35 +0100
Subject: [PATCH v2 01/11] iomap: punch out a run of clean blocks in one
 call
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
Message-Id: <20261124-b4-ntfs-delalloc-fixes-v2-1-f394c800ec03@proton.me>
References: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me>
In-Reply-To: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me>
To: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
 Baolin Liu <liubaolin12138@163.com>
Cc: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 "Darrick J. Wong" <djwong@kernel.org>, ntfs@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Zhan Xusheng <zhanxusheng1024@gmail.com>, 
 stable@vger.kernel.org, Ernest Borowski <ernest.borowski.git@proton.me>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2172;
 i=ernest.borowski.git@proton.me; s=default; h=from:subject:message-id;
 bh=QlRHNgKKZw1I17ErZyU+XJVQumdcF0YH4l4Xvps8Y4o=;
 b=owGbwMvMwCVWzJ65uCpJ5D/jabUkhmw2kXrbcEuZj8WTn5SXF3TU3fhumjPpeBfHAf7Fsy/Mr
 p6W6XWho5SFQYyLQVZMkaXj/40Qn5Bvn5bFafXBzGFlAhnCwMUpABPpncrwP3WTxrEsYwPOb+9W
 t005uONeCXPV+6b5s13tZjkaFUrMeM7I0Ls75ffh+7mzPCR1N+UreArvq7b/Fs/FluHCdu117tM
 aXgA=
X-Developer-Key: i=ernest.borowski.git@proton.me; a=openpgp;
 fpr=88FFD8544C54F6F2A65E2A8E730769A37A6214FF
X-Endpoint-Received: by B4 Relay for ernest.borowski.git@proton.me/default
 with auth_id=1589
X-Original-From: Ernest Borowski <ernest.borowski.git@proton.me>
Reply-To: ernest.borowski.git@proton.me
Content-Transfer-Encoding: 7bit

From: Ernest Borowski <ernest.borowski.git@proton.me>

iomap_write_delalloc_ifs_punch() calls ->punch() once for every clean
block of a dirty folio.  A file system that reserves delayed allocation
space in units larger than a block can release a unit only when one call
covers it whole.  ntfs reserves whole clusters and uses 512 byte blocks,
so with 1 KiB clusters a buffered write into a hole that fails after
zeroing the first cluster of a 4 KiB folio leaves the other three
clusters of that folio reserved, and writeback later allocates them.

Pass each run of contiguous clean blocks to ->punch() in one call.  XFS
and ext4 punch any range they are given, so for them this only means
fewer calls.

"ntfs: punch out the delalloc reservation of a failed buffered write"
later in this series needs this, so it goes to stable with it.

Cc: stable@vger.kernel.org
Signed-off-by: Ernest Borowski <ernest.borowski.git@proton.me>
---
 fs/iomap/buffered-io.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6d843b168d..2eb8070e34 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1364,6 +1364,9 @@ static void iomap_write_delalloc_ifs_punch(struct inode *inode,
 	 * blocks within a folio which are marked uptodate
 	 * but not dirty. In that case it is necessary to punch
 	 * out such blocks to avoid leaking any delalloc blocks.
+	 * Pass each run of clean blocks in one call: a file system
+	 * that reserves space in units larger than a block can only
+	 * release a unit that it sees whole.
 	 */
 	ifs = folio->private;
 	if (!ifs)
@@ -1374,9 +1377,12 @@ static void iomap_write_delalloc_ifs_punch(struct inode *inode,
 	last_blk = offset_in_folio(folio, last_byte) >> blkbits;
 	while ((first_blk = ifs_next_clean_block(folio, first_blk, last_blk))
 		       <= last_blk) {
+		unsigned int next_blk = ifs_next_dirty_block(folio,
+				first_blk + 1, last_blk);
+
 		punch(inode, folio_pos(folio) + (first_blk << blkbits),
-				1 << blkbits, iomap);
-		first_blk++;
+				(loff_t)(next_blk - first_blk) << blkbits, iomap);
+		first_blk = next_blk;
 	}
 }
 

-- 
2.56.1


