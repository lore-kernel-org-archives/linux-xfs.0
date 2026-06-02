Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34273D6CAD;
	Tue,  2 Jun 2026 10:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395044; cv=none; b=bd8jESMQhGx/a83R5ZzTVeFx3jqCtrE4W2+v7xg1M+hQfeRQZ8N0pOk5ts090sf3P53qZW0l+EHwrpRRnI4IgcbhNKbfwMPeSnW2rf5qghl2s7WO64gszlk1Sm1SEhRYNdPsMDu0SBb3GvLxy5S33/7pY1AOvVJskq8U2G/0Zyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395044; c=relaxed/simple;
	bh=tRD6D2ZvC10l0Swb1mE77uQnFpNR5auwAZCGdQLKj3I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MRWY+3runejx66UiUUmoUCYj7zLNRY3bBmxZx6ZIITAaxiO5jEyqZq64kIMHV1MWKmr1xnAoMtH51sopkiQgXWmYWu6hxVC/TjlD/bmXayVtlLbTHwptIMRsafvgF61FjreyCuJZt1fvRmE3ikKohrn0Sy6E7iQCk0sVFw812A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IcYRFZ7I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IcYRFZ7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416B61F00899;
	Tue,  2 Jun 2026 10:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395043;
	bh=Rcl0Ij+Ta68yATaT5Q/U3eCvCYbsFeYyob8MpA9JEIY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IcYRFZ7IwF5i2OaH89y2up0aV6PvzsJqfvYMhN8Rb430whUhhGzKxCyO61VhDckN8
	 mdwK5pkZmT3BPZZ2F6YPiiuM867ZBfa6ef0HaJHGqB3X/ozsJJWexF5h8jHXFKML1k
	 oqoumaaaw6e1Hel59xTSQu+iyE3jZQ1A9Q/8NejBaZSDfHP/ifSkh2au0Fjza5xpWa
	 IrW4Vcsz7CnMp80iPim5gTBwbJSF+Z7YZbEOlJszNf7x+wdCisnmSxsc9W66E+6TYr
	 Wa5VA/7TNUf7EzQoU7ZT1PRntyOyrkVstP0XLHkDaECwCp7k0kvPAGxNgmF/kA2UOe
	 BMZza+NotpqGw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 02 Jun 2026 12:10:12 +0200
Subject: [PATCH RFC 6/8] ext4: open via dedicated fs bdev helpers
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-work-super-bdev_holder_global-v1-6-bb0fd82f3861@kernel.org>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1960; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tRD6D2ZvC10l0Swb1mE77uQnFpNR5auwAZCGdQLKj3I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJreHQvVlsv1mBf/ON//MTCj44HOu5eIo74EO/d/ONo
 LLZxpF+HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPpEGNkuLdt+8Ldt/37WQ7P
 +LFH8YH+sRW3n1wvXqvCWFi/48R+y0ZGhoVLNebPSzimfdyP4ci2z7+/z1hav17yfvESwfglBdm
 TYrgA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Route opens through fs_bdev_file_open_by_path() so each external device
is registered against the correct superblock, and convert the matching
releases.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3124..8108d999008e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5793,7 +5793,7 @@ failed_mount8: __maybe_unused
 	brelse(sbi->s_sbh);
 	if (sbi->s_journal_bdev_file) {
 		invalidate_bdev(file_bdev(sbi->s_journal_bdev_file));
-		bdev_fput(sbi->s_journal_bdev_file);
+		fs_bdev_file_release(sbi->s_journal_bdev_file, sb);
 	}
 out_fail:
 	invalidate_bdev(sb->s_bdev);
@@ -5972,9 +5972,9 @@ static struct file *ext4_get_journal_blkdev(struct super_block *sb,
 	struct ext4_super_block *es;
 	int errno;
 
-	bdev_file = bdev_file_open_by_dev(j_dev,
+	bdev_file = fs_bdev_file_open_by_dev(j_dev,
 		BLK_OPEN_READ | BLK_OPEN_WRITE | BLK_OPEN_RESTRICT_WRITES,
-		sb, &fs_holder_ops);
+		sb, sb);
 	if (IS_ERR(bdev_file)) {
 		ext4_msg(sb, KERN_ERR,
 			 "failed to open journal device unknown-block(%u,%u) %ld",
@@ -6034,7 +6034,7 @@ static struct file *ext4_get_journal_blkdev(struct super_block *sb,
 out_bh:
 	brelse(bh);
 out_bdev:
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, sb);
 	return ERR_PTR(errno);
 }
 
@@ -6073,7 +6073,7 @@ static journal_t *ext4_open_dev_journal(struct super_block *sb,
 out_journal:
 	ext4_journal_destroy(EXT4_SB(sb), journal);
 out_bdev:
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, sb);
 	return ERR_PTR(errno);
 }
 
@@ -7492,7 +7492,7 @@ static void ext4_kill_sb(struct super_block *sb)
 	kill_block_super(sb);
 
 	if (bdev_file)
-		bdev_fput(bdev_file);
+		fs_bdev_file_release(bdev_file, sb);
 }
 
 static struct file_system_type ext4_fs_type = {

-- 
2.47.3

