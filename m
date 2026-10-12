Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB3E471D0C;
	Mon, 12 Oct 2026 10:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800554; cv=none; b=e+Azc3sWuqKGHk2Y6epRIWqzBE58FjKrwlwzsjxJDl3ZA4H2nMGrAt9dCIo31B1HuNwI8pIRAxGhSSFTiZEgPPvMNOTM2XOUcpgLfdMJkoEE6Xcv12ecHP2o8kIxeNGeoqIib2VOPtN2G5HbU1F3+PIy4572BdDXjnJU94FZvR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800554; c=relaxed/simple;
	bh=9u7klthKdsCoYlVinjiBI3Ze+o4aPIRiJ0KJ0j4j6nw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PwLXtfbKXpR/qB7Cclum7++GlteTUGaaVcMVvfVUKWkz5l7dbrt3XlErJbYccipbakCM4UYJqubHoYq0MwowHRkQqyhIRAu++JLfbncg8g8WtOPmtwkdd1pPd79w4sy1kTPz5ZyU/Sw5o9HKU+ce+/ncd0b8JaiZa63VeUE46eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ci8MRYyH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ci8MRYyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B474D1F0089F;
	Mon, 12 Oct 2026 10:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800536;
	bh=RIH/N6j+KOC00sVVsAdpEKeQdTGTedvdRMVdVt4vl/w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ci8MRYyH3GjInYEB6/omwxCTuwkI5hWbFDZqbi+4xbVMsBb2o+HSLorUoyf9VOJJG
	 8UXMWxo03la4d9+JzYEefcX+lDjR4HTHoK6cgcWxeWiKX9ofaXldOVj8Uh8MlTEYBO
	 4/u1kR8BxOKB4ntPmC3Z7r38xOQlN5LF6kNiUzekNFvSTpzvmuXWTBy5PPW4KYlQWf
	 FRZRfhvjZgSHVC0hmkZtMhSzLcRbemk/GyCbgZV340j0Rz7Z1FyZZN5J0pdEN3/Xj9
	 WKUUFe7VcmdJ81+bDTPtzTi+IVXVX0YeasV82GLIix+wcplP/4o3R6kblKhczUJj/O
	 IaukkdOEjbNYQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:21:00 +0200
Subject: [PATCH RFC 15/28] ocfs2: keep options that can't change on remount
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-15-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
To: Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
 gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
 linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3024; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9u7klthKdsCoYlVinjiBI3Ze+o4aPIRiJ0KJ0j4j6nw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TJ5idnl51m+k2unGrn9CzSYY6q4fvW7g+rl0q7W3
 qk7Dof+6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIIV5Ghoux3au+/v41t1rr
 NMOK5P/nk2zXaVy9PCfycup2A9Z4fm1Ghpn5Iowndwr+PtXTlj+3cYPc7rayJoafK0+UicTyS8s
 tZQcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ocfs2_check_set_options() insists on exactly one heartbeat mode and
ocfs2_reconfigure() refuses to change the data mode. But
ocfs2_init_fs_context() doesn't inherit the current mount options for a
reconfigure. So every remount that doesn't pass heartbeat= fails with
-EINVAL and on a data=writeback mount so does every remount that doesn't
pass data=writeback. That includes emergency remount (sysrq u) which
passes no options at all. So it WARNs in reconfigure_super() for every
ocfs2 that is mounted read-write:

  (kworker/3:1,54,3):ocfs2_check_set_options:1243 ERROR: Invalid heartbeat mount options
  forced remount of a ocfs2 fs returned -22
  WARNING: fs/super.c:1133 at reconfigure_super+0x498/0xb20, CPU#3: kworker/3:1/54

A remount that does pass heartbeat= has the opposite problem. Every
option it doesn't repeat is reset to its default. So noacl turns into
acl, errors=panic and errors=continue turn into errors=remount-ro, and
barrier=1, nouser_xattr, coherency=buffered, intr, atime_quantum= and
preferred_slot= are dropped. localflocks is always dropped because the
parser ignores it on remount and inode64 is dropped unless it's passed
again.

So start a reconfigure from the current options instead, like exfat and
gfs2_init_fs_context() do. Then a remount only changes what it
specifies. That's the mount option flags, the atime quantum, the
preferred slot and whether a userspace cluster stack is used. Asking for
a different data mode still fails with -EINVAL. Asking for a different
heartbeat mode does too but now as "Invalid heartbeat mount options"
because the current mode is already set.

The next patch stops ocfs2 from setting SB_RDONLY after errors. An
errored ocfs2 then stays read-write as far as the VFS is concerned and
emergency remount would run into this for it as well.

Reproducer: mount any ocfs2, also with data=writeback, then

  echo u > /proc/sysrq-trigger    # "forced remount of a ocfs2 fs returned -22"

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/super.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c62e389d4dd6..26041371a666 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1213,6 +1213,20 @@ static int ocfs2_init_fs_context(struct fs_context *fc)
 	mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
 	mopt->dir_resv_level = -1;
 
+	/*
+	 * Start out with the current options so that a remount only changes
+	 * what it specifies. Emergency remount (sysrq u) passes no options at
+	 * all, and the heartbeat and data mode can't change.
+	 */
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
+		struct ocfs2_super *osb = OCFS2_SB(fc->root->d_sb);
+
+		mopt->mount_opt = osb->s_mount_opt;
+		mopt->atime_quantum = osb->s_atime_quantum;
+		mopt->slot = osb->preferred_slot;
+		mopt->user_stack = ocfs2_userspace_stack(osb);
+	}
+
 	fc->fs_private = mopt;
 	fc->ops = &ocfs2_context_ops;
 

-- 
2.53.0

