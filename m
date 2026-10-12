Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3180E4825A3;
	Mon, 12 Oct 2026 10:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800588; cv=none; b=Y/O4tkjo//NlpcQMbXccT4Jr9AV6ljIO0Sjc754p8Yb+2kEiwl6f93bkyuZpLzPHk6eK0qL4xjV756oanXMCxY2OravKmD2V2ycuH1nu7NzUvY6onX5F6/B4pTNiLG+KAaQWQLuQ5anFqy4DJyTpstcAOalNKCwMX+aEQwFoWx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800588; c=relaxed/simple;
	bh=8dLh+oFKUbI05L/t8FK723NCEbEfylva9pCvJMhC6wQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nat2jL6ly79ifKs09t2aWMW2J4tP6CgO8iAD403ltry6B+shpYU+qG4d+TzRVOEK66GoJqjuG41LFq79BTOMAGJp7jnuWfYHh6ZL58sm6yfny+ge9LiA4UNb6/XR/XQZ5jpDGK2AYOtr4GnP4hU/XRmZh/YON8jrrHe+ekF9rrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQYyGwH8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQYyGwH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549F81F008A0;
	Mon, 12 Oct 2026 10:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800577;
	bh=y74f7RyBGE3iCijFAAgGCqjvXbXzYJ797Iv6mglulE4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BQYyGwH8EukrBjtvNRhIWUxLuANqdRfW6nc34iq97bxty6ODBo9/lTP4bumkjWVEj
	 j0wL/A19T6ENs+Gbohe9ePjCN1rX5k2MRCnXqPdIH3NMBa7uKR6uVTl3JFJnNN4VbP
	 CMALyHEDSDHWaDwprwOiHUdMD7eoG3VpVD/kOE1NVA4+J3brtEE52y/1VHI8VsR4I9
	 IOL4EMmWPbwVcs/1n3cOoHBbNAd2P2qCvqMp8X19+YxCItbDt1YHuoNW9btsqfprnK
	 7aQqb43tzwdogCF6bzgjgt4lTb+ziL0UrKVJM5cNLjJFc25r6z5ZNpHAUCVdYVhfLQ
	 c1CMwY4RvY5Iw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:21:10 +0200
Subject: [PATCH RFC 25/28] ext4: allow remounting read-only in the
 emergency state
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-25-60743a3dc326@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3939; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8dLh+oFKUbI05L/t8FK723NCEbEfylva9pCvJMhC6wQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TJF09lWQbexY13en8/PbO7fS7o+aYKiwPeqR1+9u
 hS436y61VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRrvUM/1R3xryfZP5drN/v
 X/THnALLPY2nlna+SYyaH2oRfql/ojzD/8zy1S1cSrelI0TeLl29Te/tzZmfbT8dknwrNuXDpoW
 bD7MDAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

__ext4_remount() refuses any change of the read-only state with -EROFS
while ext4_emergency_state() is set, i.e. after FS_IOC_SHUTDOWN, after
an error with errors=remount-ro or after an error that forces the
filesystem read-only like ext4_abort(). None of them sets SB_RDONLY
anymore. So a plain remount to read-only fails and the filesystem stays
read-write.

And emergency remount (sysrq u) asks every read-write superblock on a
block device to go read-only with SB_FORCE. ext4 refuses that too and
reconfigure_super() warns before it sets SB_RDONLY anyway:

  EXT4-fs (vda): Remounting filesystem read-only
  sysrq: Emergency Remount R/O
  forced remount of a ext4 fs returned -30
  WARNING: fs/super.c:1133 at reconfigure_super+0x498/0xb20, CPU#3: kworker/3:1/50
   do_emergency_remount_callback+0xc4/0x100
   __iterate_supers+0x33d/0x410
   do_emergency_remount+0x20/0x40

With panic_on_warn that's a panic from sysrq u.

Nothing may be written in the emergency state but becoming read-only
doesn't need to write anything. So allow going read-only and skip
everything in that branch that would touch the disk. That's
sync_filesystem(), which fails with the emergency errno anyway,
dquot_suspend(), the s_state update and ext4_mark_recovery_complete().
Note that after a shutdown with FS_SHUTDOWN_FLAGS_DEFAULT the journal is
still live and the latter would really write. Also skip the superblock
commit a remount does for a filesystem without a journal, like
ext4_put_super() does in that state. Going read-write is still refused
with -EROFS and option-only remounts work as before. Quotas stay on
until umount.

That's the rule the filesystems converted earlier in this series follow
as well. In the emergency state going read-write fails and going
read-only works, writing at most what was dirtied before the error.

Reproducer (the sb_rdonly selftest after this patch covers the mount(2)
path):

  truncate -s 64M img; mkfs.ext4 -q img
  mount -o loop,errors=remount-ro img /mnt
  xfs_io -x -c shutdown /mnt     # or any ext4 error, e.g.
                                 # echo x > /sys/fs/ext4/loop0/trigger_fs_error
  mount -o remount,ro /mnt       # EROFS, stays read-write
  echo u > /proc/sysrq-trigger   # WARNING: forced remount of a ext4 fs returned -30

Fixes: 95257987a638 ("ext4: drop EXT4_MF_FS_ABORTED flag")
Fixes: d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem errors")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/super.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d636b89090a2..643c304460ec 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6711,11 +6711,18 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 
 	if ((bool)(fc->sb_flags & SB_RDONLY) != sb_rdonly(sb)) {
 		if (ext4_emergency_state(sb)) {
-			err = -EROFS;
-			goto restore_opts;
-		}
-
-		if (fc->sb_flags & SB_RDONLY) {
+			/*
+			 * Nothing may be written in the emergency state. Going
+			 * read-write stays refused, but going read-only must
+			 * not fail or emergency remount (sysrq u) WARNs. So
+			 * just become read-only without touching the disk.
+			 */
+			if (!(fc->sb_flags & SB_RDONLY)) {
+				err = -EROFS;
+				goto restore_opts;
+			}
+			sb->s_flags |= SB_RDONLY;
+		} else if (fc->sb_flags & SB_RDONLY) {
 			err = sync_filesystem(sb);
 			if (err < 0)
 				goto restore_opts;
@@ -6826,7 +6833,8 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 			goto restore_opts;
 	}
 
-	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY)) {
+	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY) &&
+	    !ext4_emergency_state(sb)) {
 		err = ext4_commit_super(sb);
 		if (err)
 			goto restore_opts;

-- 
2.53.0

