Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D63477E52;
	Mon, 12 Oct 2026 10:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800600; cv=none; b=GOXWP5247OPAilN2Axsc8TTyMH+KAdEmnEpBNrHjiS/jrGvjBNCbaYwSIJESJ/PHD+G/0TYf/Q+0/Sis3YJT2NplLiNlhsuJEvNMj8ZI+l8dJ1SwHtqAcuJY7Ezltz9FQWulx5EP7yuSjvW+ohe+TQgrD0Z8ARmINp2N6vG2vNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800600; c=relaxed/simple;
	bh=QzFraWHZpoT4h8C8LHTA5EJhwAApStYvY3me9tAahCA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EYN7wfGarjHeTyiUJZlLzCmplPaf7JvGNthaw9zILJEVfD3inSIZ3MFGPQXqO6B6v6Bt6dE8SxTMZqKjoljb34HieGeCH3jt26a57INtM+sHrc/IILgn1EYSnbszpmW1RCALNmZ+2Jui27zz8jMvMlbcEZ39uvABq27noamRBlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIIZPpeG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIIZPpeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22CF1F0089D;
	Mon, 12 Oct 2026 10:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800585;
	bh=6yH62i9Em6RqO23OG0inlKQbBYJLqzO3MkLiuVDd3RA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JIIZPpeGGEGDY+/E9704JPCYSkdZblOgIMzzqZlzZTAXlVg31bV7HtyVue0NN1UcQ
	 BhIIFQ0pxD1QJqVVOkOOHWr42+dulNAyll4gyaveJDajX5MfFvRx7bqAB3hTCakyx/
	 mFWhzB8ySKodKhEx2n0lRoScqAKYHfK6/rgZt1F/IuQxQrkB0b16bNOxaNZpdZK0B7
	 6/e5WI5cfUprESsz7Xu8hmGKJbGYN3+5NSwByQQb1SYLI2RgPDG7hRh5DOPp89XzaR
	 M3Kq+jFG7i23DBd25ClUFL9Xg77nBfPQwtu0vH4pLHaW9MZtiFUkeh2WWSDqSyWWkF
	 e2mjaC+9C1v0A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:21:12 +0200
Subject: [PATCH RFC 27/28] xfs: allow remounting read-only after a shutdown
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-27-60743a3dc326@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3363; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QzFraWHZpoT4h8C8LHTA5EJhwAApStYvY3me9tAahCA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TLl4eqtqvdvrG/o1T+wSH3bmhcpvGaW096ctNgxd
 e512TfPpTtKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAm8jeO4X/wVKPT/5+uerN+
 zsTT55NZCu3cVji9jS0PaLZ7+M5eklmQ4b8Lw5dNH6vkRW0eOki13rr0df/zdUYH+AzY/59tvbB
 552duAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

A shut down xfs can't be remounted read-only. xfs_remount_ro() starts
with sync_filesystem() and xfs_fs_sync_fs() fails with -EIO because the
log can't be forced anymore. So "mount -o remount,ro" fails with EIO and
the filesystem stays read-write. And emergency remount (sysrq u) asks
every read-write superblock on a block device to go read-only with
SB_FORCE. xfs refuses that too and reconfigure_super() warns before it
sets SB_RDONLY anyway:

  sysrq: Emergency Remount R/O
  forced remount of a xfs fs returned -5
  WARNING: fs/super.c:1133 at reconfigure_super+0x498/0xb20, CPU#0: kworker/0:1/11

With panic_on_warn that's a panic from sysrq u. ext4 had the same
problem in its emergency state.

Nothing can be written after a shutdown but going read-only doesn't need
to write anything. So ignore the errors from flushing the filesystem and
from freeing the COW staging extents and post-EOF preallocations once
xfs is shut down. That includes a shutdown the flush causes itself
because the log can't be written. xfs_blockgc_free_space() skips every
inode after a shutdown anyway. The rest of xfs_remount_ro() copes with a
shutdown just like unmount does. It stops the background workers and
xfs_log_clean() leaves a shut down log alone.

And refuse going back to read-write with -EIO after a shutdown. So far
xfs_remount_rw() didn't check for that at all and went on to clear the
read-only state and restart the background workers.

Reproducer (the sb_rdonly selftest after this patch covers the mount(2)
path):

  truncate -s 512M img; mkfs.xfs -q img; mount -o loop img /mnt
  xfs_io -x -c shutdown /mnt
  mount -o remount,ro /mnt       # EIO, stays read-write
  echo u > /proc/sysrq-trigger   # WARNING: forced remount of a xfs fs returned -5

Fixes: b97cca3ba909 ("xfs: only bother with sync_filesystem during readonly remount")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/xfs/xfs_super.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b24db75eaedc..6d82fd069918 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2041,6 +2041,10 @@ xfs_remount_rw(
 	struct xfs_sb		*sbp = &mp->m_sb;
 	int error;
 
+	/* Nothing can be written anymore after a shutdown. */
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp &&
 	    xfs_readonly_buftarg(mp->m_logdev_targp)) {
 		xfs_warn(mp,
@@ -2115,9 +2119,14 @@ xfs_remount_ro(
 	};
 	int			error;
 
-	/* Flush all the dirty data to disk. */
+	/*
+	 * Flush all the dirty data to disk. After a shutdown, including one
+	 * that the flush itself caused, that fails. But going read-only still
+	 * has to work, emergency remount (sysrq u) relies on that. The rest
+	 * copes with a shutdown like unmount does.
+	 */
 	error = sync_filesystem(mp->m_super);
-	if (error)
+	if (error && !xfs_is_shutdown(mp))
 		return error;
 
 	/*
@@ -2133,7 +2142,7 @@ xfs_remount_ro(
 	 * cached inode, so this requires a synchronous cache scan.
 	 */
 	error = xfs_blockgc_free_space(mp, &icw);
-	if (error) {
+	if (error && !xfs_is_shutdown(mp)) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
 	}

-- 
2.53.0

