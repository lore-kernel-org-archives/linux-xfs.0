Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CE93D9695;
	Tue,  2 Jun 2026 10:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395037; cv=none; b=CR5Ef6ic+n7eDzr8CWE+Hamz82NiSQBO7eFemJoAchfQ+4vjGcWQzZQbFupwZStx2WDjw/L5rhbJp5O8X8bYPeYJEeyWqS3ZVLJ1dN7L/XwzOtqrsyzqPvIU2TNSt78vG/hbpYhl333zHoewFPukyyFxWP6VM7A1rSVg+NPO/LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395037; c=relaxed/simple;
	bh=YYSwTQpvvqiN+ClwMHMKH84kTVWiiSstmufcfKS+DaQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TPXlQc3cUYK9+8Bglb8pweLILe8iJemVFKSLw3svFzLocm8hgVWb6KU7dop+Np7QjeHLKzCnxItc6aukQbWxAXmLB2+lhjOlgGBmsV5Ss7AlfkLL6y0rgC3l2UOfA7KuiJZVNsS6cqJha0Ejyr1aVNZjmniWBJpfdx7q1wgA96g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OnrvYZ8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OnrvYZ8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67D81F00899;
	Tue,  2 Jun 2026 10:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395036;
	bh=XXqlEVPtjTumz77I7tYirzGL781sufCUro38/y5OW94=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OnrvYZ8d/uudw7IFCwY3+2vEoGJ6Xtsg+t6/CG6GZXH5Cu/a+UI4VZkLuLsPmmhZP
	 6o5H9c7TCjOLYfvJWyQ7hEbbRYWhw70BBhhbJBxs/ExyIWJJncxDblUbaMvr9CROs1
	 Q01KG/rktCCnGP4xLk9oyJmDMD/FzT6LnNGo4+3qUsfjVwdjmm5MoxFZWMFEp43MyO
	 rlhpI4KBhN99dHrUw9gwyCUO1vVnm9WmD+Y6lVT2Ywt2rozkoHb0kksHIyBNZrYRJz
	 jNM/tTxqaM7tEKooZLW4L4jKyDdvZTR2ZlGT9eWCl4b8VZrFS2uLTuPzv9ns5h4Bko
	 VhkPjNUBZqM9g==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 02 Jun 2026 12:10:10 +0200
Subject: [PATCH RFC 4/8] xfs: port to fs_bdev_file_open_by_path()
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-work-super-bdev_holder_global-v1-4-bb0fd82f3861@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1913; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YYSwTQpvvqiN+ClwMHMKH84kTVWiiSstmufcfKS+DaQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJreEwOvyid52jcmyz7OHVMQca/xYJfXfm1zK+KXT6R
 2bNEu2SjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkwmTAyLPDiey56bvmxsIsP
 RdS936y5+zyoeu3X1308nyyEdyZ9F2P4n5X2ceN6vpucR3JWXQmQ8lxn/toiWGMVx4I7C7qP8Cb
 P5wUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Route opens through fs_bdev_file_open_by_path() so each external device
is registered against mp->m_super, and convert the matching releases.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/xfs/xfs_buf.c   |  2 +-
 fs/xfs/xfs_super.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 580d40a5ee57..3d3b29edb156 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1601,7 +1601,7 @@ xfs_free_buftarg(
 	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
 	/* the main block device is closed by kill_block_super */
 	if (btp->bt_bdev != btp->bt_mount->m_super->s_bdev)
-		bdev_fput(btp->bt_file);
+		fs_bdev_file_release(btp->bt_file, btp->bt_mount->m_super);
 	kfree(btp);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f8de44443e81..304667210695 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -400,8 +400,8 @@ xfs_blkdev_get(
 	blk_mode_t		mode;
 
 	mode = sb_open_mode(mp->m_super->s_flags);
-	*bdev_filep = bdev_file_open_by_path(name, mode,
-			mp->m_super, &fs_holder_ops);
+	*bdev_filep = fs_bdev_file_open_by_path(name, mode,
+			mp->m_super, mp->m_super);
 	if (IS_ERR(*bdev_filep)) {
 		error = PTR_ERR(*bdev_filep);
 		*bdev_filep = NULL;
@@ -526,7 +526,7 @@ xfs_open_devices(
 		mp->m_logdev_targp = mp->m_ddev_targp;
 		/* Handle won't be used, drop it */
 		if (logdev_file)
-			bdev_fput(logdev_file);
+			fs_bdev_file_release(logdev_file, mp->m_super);
 	}
 
 	return 0;
@@ -538,10 +538,10 @@ xfs_open_devices(
 	xfs_free_buftarg(mp->m_ddev_targp);
  out_close_rtdev:
 	 if (rtdev_file)
-		bdev_fput(rtdev_file);
+		fs_bdev_file_release(rtdev_file, mp->m_super);
  out_close_logdev:
 	if (logdev_file)
-		bdev_fput(logdev_file);
+		fs_bdev_file_release(logdev_file, mp->m_super);
 	return error;
 }
 

-- 
2.47.3

