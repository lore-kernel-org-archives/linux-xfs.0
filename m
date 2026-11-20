Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190044;
	b=ga3e2K7NThvVlb9YM3+AdLtmCATm5ym/rFrXqIYhK+IbkNAkOtsyM+qrZaXypCSk7+Bu
	 1l5Gci/gzfwuEeKWsHVjUA19MScL3kg9kdIkE1Jq+XQfxv7x4pMFnEl1Oihb1oaUsA1fF
	 7en5Yndv5lX5gXqpbHMnTtIgaZTgygBnaXhUh1hH8vpubT9ok0QbruAqHBdnBXP8ZNGY2
	 YLbNdy1Ad4n5SQzPANvRD4Br4qOklX6WfC1AYxSJM4unXkIJ1EDn02QcfIlvtH+xndJ0O
	 2GPijPiXAjvqj95CUotSUEwHKa6kc4kK4/BIA3rixKN9F5f4Y9j22+TPhE8GZ+GgxXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=d64oy+cTLXmeYoVqPxnHx95FYIWBNAnJoC4BVDuan+U=;
	b=jVJ+bbDTLO8HVM3bNojVOJf903aRQj0ZSwisn7yKXhcTQHfVbeJrKX2jQM/mQHgYSg3x
	 xhqH8hFa/nN2Upkajde8b9WwuqpXQX0y0HAreNt+xRCRRReIwYKRKpRuW7YDnuGiy1syS
	 xfQX9FlF+JdfMXGmo1zowo5vYK3nSQVh8LfsHYnfCJDRABgCjti1eJ1OAnUxaRAr5CLDZ
	 1M+ms4us0BxulTbCq4byra5aTabC8E3tuUffAnpRGE7X6Z77+T3C8kox8QyAXqmcJdm9w
	 hzD39SVHA65Yo66k0usBdZI0QDhTNb/HbPGcFomVSx4/1hB1PGtPe2LRpBFR4Rr+HZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z67BRIpI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7118A60A2600;
	Fri, 20 Nov 2026 15:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z67BRIpI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A581F000E1;
	Fri, 20 Nov 2026 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190044;
	bh=d64oy+cTLXmeYoVqPxnHx95FYIWBNAnJoC4BVDuan+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z67BRIpIOVAM0LHS7fHGKmS5m2/l5JJqzXdbkyXd2XkWDGuFUOGdpxWlyWA2FNVTa
	 x/LAqJqHMSru5710+GExPrz4v17uGZMGuLODrcL3MRYowsVCgeEgq3rpRKeTwCiTBJ
	 O7eOdE2ccLiZhUMBCJF2xBZORxMn5bQygFv3fMMBikRRl6EukeA6nAc/NJ8O+pV80L
	 InwrJhbpK4urgQVLC8emFR6Dl1xoY0ToXZZuxT2DZqlMPikif2IMmSS95Y5oZ4V/Mb
	 JcKF4vx82iI4k3uH9CVWzXOozq/wMR2yeLaYM3J5/lQWDIbvcRNqxkmVzqZBWv09+k
	 kAVD1evrBv31A==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "fsdevel" <linux-fsdevel@vger.kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-f2fs" <linux-f2fs-devel@lists.sourceforge.net>,
	"linux-xfs" <linux-xfs@vger.kernel.org>,
	dsterba@suse.com,
	"Eric Biggers" <ebiggers@kernel.org>,
	"Christian Brauner" <brauner@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	tytso@mit.edu,
	chao@kernel.org,
	jaegeuk@kernel.org,
	viro@zeniv.linux.org.uk
Subject: [PATCH v3 4/7] iomap: use fsverity_is_building() to check for fsverity IO
Date: Fri, 20 Nov 2026 16:50:26 +0100
Message-ID: <20261120155032.187246-5-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155032.187246-1-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently, inode gained new I_VERITY_BUILDING flag. This flag indicates
that inode is undergoing fsverity metadata construction. Previously, it
was indicated by stale iomap flag on the IO, now we can check the inode
instead. As fsverity inodes are read-only, the only write IO happening
during I_VERITY_BUILDING is fsverity metadata.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6d843b168d5f..0a176741e7b0 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1930,7 +1930,7 @@ static bool iomap_writeback_handle_eof(struct folio *folio,
 	struct inode *inode = wpc->inode;
 	u64 isize = i_size_read(inode);
 
-	if (wpc->iomap.flags & IOMAP_F_FSVERITY) {
+	if (fsverity_is_building(inode)) {
 		WARN_ON_ONCE(folio_pos(folio) < isize);
 		return true;
 	}
-- 
2.54.0

