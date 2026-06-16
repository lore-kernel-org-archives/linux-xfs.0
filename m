Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A45E43DA51;
	Tue, 16 Jun 2026 14:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618939; cv=none; b=LqD082AH5J0EfT5Zkf+J1YGNxk9ig+z63ZfQULfcSwvYDibaMvi30Fk7q/aV5Y47XUETko2EArXle7TwHjsjOfn05o9zdP2Ospd+kXUiqqcwniBa4K/BvdoqYd7ree6TMsjo2O+mvedFGN+BntCr9dqRYOGscTnyIjYeqtI5TYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618939; c=relaxed/simple;
	bh=qvtFS8Lr84dJBr8irgZxZ3qqnPvYlFg8UNVTahpR3ds=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ijlcyW0ShyBTwrEZaZWzfsGoUvgv/0r1VD+CvhK9noBQIAC9XjS3KuXDIRS/peuRxmH8UhTzAuwyl50ORr54mzhbYM9EABZcodyPDNBW0tkYuYCBXcc95RuMcDqourqj3SVR+16pj7vHdQltmCh+SnNtEV7cLWNT8Wvqwx3g1o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VJ3UaXsz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJ3UaXsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E1D1F00AC4;
	Tue, 16 Jun 2026 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618938;
	bh=jyk+CgoW+m5rVgz4pEmy12TufZuRoXjKBOU5hRik7pA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VJ3UaXszlXPVuZuam+qBXCCDrxZIpxk9S1AdD9ftU8NvHmNH6lPc2+/u4iD9DOhZa
	 1imF35uPSagyWC5SC5hai+K845p0dZgl3IKZEb/O4DIgbCzG9AdNvCJpDkBmTNEOnA
	 Xwy2jP3kp3vAjRd5DxFGY9mljC2uWTexjPthT/Kq/VXgk0LsLWpq9uDSsrzbHcUVel
	 Y4EWfZhXPD39NyxWX8C7JiNKtqz3QVIqHpIpUYph/+xc3PCCsIC+TOZPIfXhVqHaKn
	 RHiR7tvHaVOQ3fskl/lOXLnk82Z9r/Tlcf17ElvpPtPvOVOWphNmLonUUEHjXkV3Dk
	 xm4jU5jZHO4yg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:22 +0200
Subject: [PATCH RFC v2 06/18] ocfs2: don't reset s_dev on dismount
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-6-7df6b864028e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1104; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qvtFS8Lr84dJBr8irgZxZ3qqnPvYlFg8UNVTahpR3ds=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtzLYJveuCfB9VyszzyjZfN+vvJYfU5V6e3TP8/Kp
 q/T/17p01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARy1uMDAfVqjjX5ORN+/2s
 eamGMff/tzMUytcJzfNlsLv1/bNviCfD/1J++VB/gTWG7efSHxSYm8QFBh7Sl86Rez83e1GuT6Y
 LDwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ocfs2_dismount_volume() has reset sb->s_dev to zero since the original
merge in ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster
Filesystem") as part of scrubbing the super_block. Nothing reads the
field afterwards: all ocfs2-internal uses are mount-time log and trace
prints, and dev_t-keyed superblock lookups skip a dying superblock
anyway - s_root is gone before ->put_super runs and super_lock()
refuses SB_DYING superblocks.

The upcoming device-to-superblock table registers every superblock
under its s_dev. Drop the reset instead of leaving a superblock around
whose s_dev contradicts its registration.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 4870e680c4e5..df9ebff25dab 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1882,7 +1882,6 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_delete_osb(osb);
 	kfree(osb);
-	sb->s_dev = 0;
 	sb->s_fs_info = NULL;
 }
 

-- 
2.47.3

