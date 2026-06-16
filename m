Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A30F466B5D;
	Tue, 16 Jun 2026 14:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618973; cv=none; b=KJhJ1XDZT1M/8qFZuoptebf17eEXXfxDIUr4MwbyDv0iPJuX1+ve2g0vqcl9rs4aJiwmUZdSkmlaC8vZANZ+9xdV6UE6krffHYZS38yHcE05ECwdmXZxDQd21zXWXZMsyFKlQkHLclxSN3IID+2/9pjH6Yf7r8yvbzLTqqsxO5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618973; c=relaxed/simple;
	bh=jAB6+pYQJ7UoWlRzj4R8GAy+N4Bl1gstiAnoaWWXXLY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lmZeNDb8Ypf6Fb4ahQJl2X2pZBW/4LXlkvgaod5Ee5YsJeLN0kwXBltU4+SRafv27q9i+UNJ2bTzcM1bwp+j2MH6M58pQNzBjYdYpjyi/26DyIudF1s4k2FovPCT4BT2+5/36RC831cQT5XdT0oeC9O+vWECVZDCgd4hpIcVuK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HnW1KWUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HnW1KWUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53EA1F00A3A;
	Tue, 16 Jun 2026 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618972;
	bh=ngVpVtPEsS0y60zyrn8nL8QUtzCpNBin4fW6U/edl+Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HnW1KWUQf0mwZMULdxGCVEyINvIM0n/EAbjzjk4r5vKicJTa9a6wgsxMfUd15cDwG
	 SUCvkBe0zx8qLEbgnBl9K3btqqf4NSVP1WugHxcCA+RDPDzo12493NIXcLj12RM4IL
	 58eikrgSTDZDOnAI3nTCugyzKEfF/ACaScFxEIxrdHScbplSAqcsjGwsSSZowaLYgz
	 w9m5atHtpdJkRx/0QCB9LyZLm32p4hYE1gGEoyA3FqVfuPSPxwDCWk+by+ZC/bFE72
	 u9kHGy0X62QjHPh50icDEjTdjjtXAl5blmedM6vcmo2Q9tJm27t7+n3j7SIuyXLwq8
	 EFUXUa3cm8lrQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:31 +0200
Subject: [PATCH RFC v2 15/18] f2fs: open via dedicated fs bdev helpers
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-15-7df6b864028e@kernel.org>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
 linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1647; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jAB6+pYQJ7UoWlRzj4R8GAy+N4Bl1gstiAnoaWWXXLY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtw/9H/bl3zWyMWvI16JSJumC+3sXzHNe/f9jxvvP
 rliY3jmcUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEVHYxMqzb4HmUZU3hwdUL
 kl5sNFaqF/iaGszn2G625JG3YIDY9sMMf8U/pp5oietV/l4odl3eqvBSv9Pv3SyK39WWerSx8KQ
 6sQEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Route the extra device opens of a multi-device f2fs through
fs_bdev_file_open_by_path() so each device is registered against the
superblock, and convert the matching release in destroy_device_list()
to fs_bdev_file_release(). The first device aliases the main bdev file
opened by setup_bdev_super() and is already registered through it.

f2fs opened its extra devices without holder ops, so a freeze, sync, or
removal of one of them was never propagated to the superblock.
Registering them wires those events up: every device now freezes,
thaws, syncs, and shuts down the filesystem like the main device does.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/f2fs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ccf806b676f5..49349262564f 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1970,7 +1970,7 @@ static void destroy_device_list(struct f2fs_sb_info *sbi)
 
 	for (i = 0; i < sbi->s_ndevs; i++) {
 		if (i > 0)
-			bdev_fput(FDEV(i).bdev_file);
+			fs_bdev_file_release(FDEV(i).bdev_file, sbi->sb);
 #ifdef CONFIG_BLK_DEV_ZONED
 		kvfree(FDEV(i).blkz_seq);
 #endif
@@ -4840,8 +4840,8 @@ static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
 				FDEV(i).end_blk = FDEV(i).start_blk +
 						SEGS_TO_BLKS(sbi,
 						FDEV(i).total_segments) - 1;
-				FDEV(i).bdev_file = bdev_file_open_by_path(
-					FDEV(i).path, mode, sbi->sb, NULL);
+				FDEV(i).bdev_file = fs_bdev_file_open_by_path(
+					FDEV(i).path, mode, sbi->sb, sbi->sb);
 			}
 		}
 		if (IS_ERR(FDEV(i).bdev_file))

-- 
2.47.3

