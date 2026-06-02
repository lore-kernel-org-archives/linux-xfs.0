Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0DB3DE453;
	Tue,  2 Jun 2026 10:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395052; cv=none; b=LyoeI9qVRlJtlUlNgGCL7fR5bzUjhmSjxjW7mN12lF9DeTW4vuxc8s11w/ZG76BIOr+PNYn43V0vbyCEMMn9htlLstM5R0nnHu/J6dG20fZp6B7Gk4toHEw+K74WJx587FaCVgHqxglhLPpQUIhxvWfwGEVro23L1NlkQLvTSm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395052; c=relaxed/simple;
	bh=R23GnSj4U5c2eVlp7JGCCBg/KF5c+QIHjrFm4diCqAg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KFX6sFk7tJVOJH457T0DcdTM4VlKtdDXXy+qGKDiZGzqrFqYk29ZJOgq6eX5sTGoH/8ndqTg5OJXzbcIryYB92V6b5fnN6uCOA+reCMpy7vfmKGHwjJBzXJ7nRGJSUEGpEBDlb94UPHf5WRnb7l8I1it+iOPGCRWKeDJQqYG/eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKNi+CFk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKNi+CFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83D01F0089B;
	Tue,  2 Jun 2026 10:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395051;
	bh=xLOTdT8r5c8v5N1ZxNPQflZse6scSqS6hKPK2aBGU3s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mKNi+CFkSwIzUT3XyErbW7NUlsQGaqz8SaV5mqOF5zpDbz/Z2aM0kkT5r/xonBqSS
	 vIFBYSRF+Y8Qd3Y6kSLOMq50Pny91d27GC/z9QyA+IJiPhCrRbZTVnGXRcDUVZ3Fci
	 g/R73rSa92eMq4puOjqbtYwgQAq7fvtIK8/LASaNsHS50nl3qVNyqz/HvQ5ro3+msv
	 fET0bfi0cVeWzh85VyG67UF1iASgo8srRq+Gid4B29ynv3MA+95OhVeC1VvC9f0QAk
	 /2TbB1DSzJrILBmkHgNiC4DL3kp8cR7aSg2Bs/ifoereNRYuW6WCHfDvwXCB1CYHaI
	 2Uc9x28TrzuRw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 02 Jun 2026 12:10:14 +0200
Subject: [PATCH RFC 8/8] super: make fs_holder_ops private
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-work-super-bdev_holder_global-v1-8-bb0fd82f3861@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=764; i=brauner@kernel.org;
 h=from:subject:message-id; bh=R23GnSj4U5c2eVlp7JGCCBg/KF5c+QIHjrFm4diCqAg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJreGY//RPxrQiwUNbMteaBZSkHhQ+tUBJbYLZtUb7N
 /9tbhXXdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyExYThn+0q8UN3BJ6GPdTU
 uvE8205tyuMZvh/sl79WLi21dk76FcPwvyRUiS+vibv687R6c4v1F9+JxWQGFKy13a/tYX3sksg
 tFgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

There's no need to expose it anymore.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index cea743f699e4..983c2fbf5202 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1643,13 +1643,12 @@ static int fs_bdev_thaw(struct block_device *bdev)
 	return error;
 }
 
-const struct blk_holder_ops fs_holder_ops = {
+static const struct blk_holder_ops fs_holder_ops = {
 	.mark_dead		= fs_bdev_mark_dead,
 	.sync			= fs_bdev_sync,
 	.freeze			= fs_bdev_freeze,
 	.thaw			= fs_bdev_thaw,
 };
-EXPORT_SYMBOL_GPL(fs_holder_ops);
 
 static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
 {

-- 
2.47.3

