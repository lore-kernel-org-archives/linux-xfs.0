Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E37471402;
	Tue,  1 Sep 2026 12:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264931; cv=none; b=HCo7BKP8/BVgqcdno7i32IzFoL1K/mviKvy+hhfr2N/g4O0x13OsKrzR0ZkbHSpVqkaFIgLD1aw8VvzgEggeIubu7R+rxAye8ICbBfw1ClrRNu6XBUWnge06Z7FzbeGerKIiA/k8/qxmOsUNWfZuPonIKkQ5sU7pGbZOHyrdL3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264931; c=relaxed/simple;
	bh=5bHolM29zDvjjqo5UaFosWippp5mvEMmlFDQrosc+5E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cX5rCxBhA1Qu3ZpB/i+wPUf7jlU1RTp0PylqxTZYAecEFM5Ieq1G4skchXQEzxYzdfoE33Dm9ogd11venzmgSucVGxDDFK5SuxVJS+tiBNQSHELEL4YVk79yPnrWvEjhwfkWtHuzxUgQ1BLlcpSXfOleDUUuYwdtrxMSHR2eKaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTGGTV1w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTGGTV1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01621F00ADF;
	Tue,  1 Sep 2026 12:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264930;
	bh=sS15gffs+R8N87pRIEu1s4Rg1sna1ujxjNmhlewV4j0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GTGGTV1w/Vq+X29/MHFHJH7lSJ+F5AtTKB5GiF3Fiec7oSSvWgoSFjfp5Q46jfRXa
	 k1dTA8oHRMrfdys2RBQIoVrwmBFeu/bJj2YyFpD0oybvHGcVc8QjJYYZ36yiBbXRqm
	 ybWNER+PDSiwqDqLxiExACbHH7IgL0BBRrQ5xtX/Sqoywva2I7+s17HOil+yJQ70x/
	 WoITZSrSEHEHesb4hgRoHMFe6iRArTcihyAQIn8qQRcKsDV7IjB1FnhFn8RCXSjfzj
	 8xYDIwWzNzw8ab7+vDF4tVNRS3twQ81HTmYI2tBjMADYCIB0VtfI4B45fY6xm7qsXV
	 XKnv5aJ4bZZZA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:34 +0200
Subject: [PATCH 09/27] fs: port inode_owner_or_capable() to const mnt_idmap
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-9-54ccd48e100b@kernel.org>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Seth Forshee <sforshee@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, linux-security-module@vger.kernel.org, 
 Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, 
 Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 linux-unionfs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, 
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=2666; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5bHolM29zDvjjqo5UaFosWippp5mvEMmlFDQrosc+5E=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7j2mKSLReCu+21HGoLtqibVFC/x/mGvv3rNvGmVb
 Fcvr8z36yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiI6SOGf+aHpPec7Fy1OktX
 9sSJpNZbH9SeZIcLRbSrHYzx+BB0mJWRYWL9xlXVU2Ol3O6pRF2q4J514I2Oo5mI9+5ZZpPe79T
 0ZgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Convert to const struct mnt_idmap.

A mount's idmapping is immutable. The only thing that is allowed to be
modified afterwards is the reference count and that is hidden behind
mnt_idmap_get() and mnt_idmap_put(). Everything else only ever reads
from the idmapping. This is the same model that struct cred uses and the
idmapping is also rather sensitive.

So make the idmap argument const wherever we can. The conversion is done
from the bottom up so callers can continue to pass a non-const pointer
to a const parameter until the conversion is finished.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/ioctl.c   | 2 +-
 fs/ext4/ioctl.c    | 2 +-
 fs/inode.c         | 2 +-
 include/linux/fs.h | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 72bc9d4f7708..b34c6a8247e4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3886,7 +3886,7 @@ static long btrfs_ioctl_quota_rescan_wait(struct btrfs_fs_info *fs_info)
 }
 
 static long _btrfs_ioctl_set_received_subvol(struct file *file,
-					    struct mnt_idmap *idmap,
+					    const struct mnt_idmap *idmap,
 					    struct btrfs_ioctl_received_subvol_args *sa)
 {
 	struct inode *inode = file_inode(file);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c8387e6a2c6e..6de77da4203c 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -373,7 +373,7 @@ void ext4_reset_inode_seed(struct inode *inode)
  *
  */
 static long swap_inode_boot_loader(struct super_block *sb,
-				struct mnt_idmap *idmap,
+				const struct mnt_idmap *idmap,
 				struct inode *inode)
 {
 	handle_t *handle;
diff --git a/fs/inode.c b/fs/inode.c
index 72a8bbe38d62..4313e9735c5c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2746,7 +2746,7 @@ EXPORT_SYMBOL(inode_init_owner);
  * On non-idmapped mounts or if permission checking is to be performed on the
  * raw inode simply pass @nop_mnt_idmap.
  */
-bool inode_owner_or_capable(struct mnt_idmap *idmap,
+bool inode_owner_or_capable(const struct mnt_idmap *idmap,
 			    const struct inode *inode)
 {
 	vfsuid_t vfsuid;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7c82d7aaa775..e2babddf755d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1755,7 +1755,7 @@ static inline bool file_write_not_started(const struct file *file)
 	return sb_write_not_started(file_inode(file)->i_sb);
 }
 
-bool inode_owner_or_capable(struct mnt_idmap *idmap,
+bool inode_owner_or_capable(const struct mnt_idmap *idmap,
 			    const struct inode *inode);
 
 /*

-- 
2.53.0

