Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290119;
	b=JaSVmMdGicPXiS8UIGxSHXttsw6SHz2CaV7j1Egtt3GM4KgLPqTi67P5053Y55Qv/DN/
	 5FnvNqJ9phyBBRWXmyUpSoeBwqBNkG6JP1K10MIrc90/VWwLYaJT4PE8I/JMtJ6Nzi9Ak
	 DFZNXfqk5sE07dvHPDAOKBbbekKwMP+XzRB5GQN9hCEtlEMKvmY2/6QXp19pnL8s0kSFM
	 iciKPTVytRusYIldgPhlULMnAIuQucNMdq7MxSLdncSF3jul/xG4MYIwgK+w6cLeStIjg
	 5OoDT884zXCMIJn0e2x/8VDKF3p77pVOXxHB42w1OqG9nKRNKC79eLSgNpHtCg5eY6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290119;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=7XvTTpFZt9IMT9USt02re6nPlZ9qEzjzsuBpluPCOxY=;
	b=f+iW15Dt54uG2dNx16kBxoHBMJtr5EP/4EeEs4IEV5LeZzEr2ozR+s06QuDkNpMwJJ8K
	 Zy+752VudBBvDZVideS8HNVTxlk3w1yvwUQQ0rsyKZX5qw5icV9SHdPFS7OEwnesl4scR
	 dTfKPHS2qILaJZGIkbF0jtIxK4NpMOomg+VRxZgc7qQFSoeUFmzV0oKSrVVPRMarukfsU
	 mSVjd/d1CsnPt+By3CdFvt17SWnGXhRXmUEHlRFQNWO+/lq+ByplCutmyBrtF8nQ3R+gI
	 uvgPEmAeWaJgMSp2n7isHUfa90qnH4apVPe//nDUwLjKEuQQ8KO09AhJhCfs0L0/7/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAFwik9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD27606A32F;
	Thu, 29 Oct 2026 16:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAFwik9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB041F01826;
	Thu, 29 Oct 2026 16:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290118;
	bh=7XvTTpFZt9IMT9USt02re6nPlZ9qEzjzsuBpluPCOxY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aAFwik9VuZcv9cOuQB4WvplLb4N45Sj4rB+A1RcNnCrrDjONPmoHeIedf2y9yT9VG
	 qtkLBpQkdIZiHj769OXRC+QI8Zo321gIRuC49FWxR/zIhXP3DiU4x2g+eEK146bVch
	 La8YEglPN3VDHQig6NnKb6xlma2X5owpJHCuHT6s8O5XUySyuU/QCfQ6YGuVcznmS3
	 xhfHjA2RQnC+IvfZVwg5elkUrToD05Fn6mKCt0hLQYpSkhNDuDkuRMGMIMgvBLfiNk
	 fiPH6BCXg3Xi99c30lR4xSqy5U+L14ODlDD8U8w2sujvCBBs07HjXY7vTGhQgBnDAN
	 jN0amNk4ORZKg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:09 +0100
Subject: [PATCH v2 18/34] ntfs: use the generic emergency read-only state
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2864; i=brauner@kernel.org;
 h=from:subject:message-id; bh=g4LPA35YUVZ1l1HsNIGt3EKaYIEnRcvZG0SSYdvGjoM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztdni+Vr7ZvmNvdw4acNl8V2Mom6yQr5OerFf9skx
 xAeEaLSUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMBElHkaGp9bdU5b9f5/NZpkT
 I2foGrOWY1aqnJfxVtYFfUzZ0d++MTKc9rHcp3Vmh5gE58zm86fezptUI1Vr80H56/nznibOmca
 8AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Set SB_STATE_EMERGENCY_RO instead of the NV_EmergencyRO volume flag when
an error makes the volume read-only. ntfs_emergency_state() keeps
telling a shutdown (EIO) and the emergency state (EROFS) apart so all of
its callers stay as they are. /proc/mounts shows the volume read-only
again.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ntfs/super.c  | 12 ++++--------
 fs/ntfs/volume.h |  7 ++-----
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 7e3a291f4758..7bc79b776639 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -441,16 +441,12 @@ void ntfs_handle_error(struct super_block *sb)
 			sb->s_flags |= SB_RDONLY;
 		} else {
 			/*
-			 * Don't set SB_RDONLY: that needs sb->s_umount and a
-			 * proper remount, and setting it while the volume is
-			 * frozen makes thaw_super() leave the s_writers rwsems
-			 * locked. NV_EmergencyRO makes the volume refuse
-			 * modifications instead and NV_Errors keeps it from
-			 * being remounted read-write. The error work marks
-			 * the volume dirty on disk.
+			 * SB_RDONLY needs s_umount, see sb_set_emergency_ro().
+			 * NV_Errors keeps the volume from being remounted
+			 * read-write and the error work marks it dirty.
 			 */
 			NVolSetErrors(vol);
-			if (test_and_set_bit(NV_EmergencyRO, &vol->flags))
+			if (!sb_set_emergency_ro(sb))
 				return;
 			queue_work(ntfs_wq, &vol->error_work);
 		}
diff --git a/fs/ntfs/volume.h b/fs/ntfs/volume.h
index 1ce81b260b15..911a27983e13 100644
--- a/fs/ntfs/volume.h
+++ b/fs/ntfs/volume.h
@@ -16,6 +16,7 @@
 #include <linux/uidgid.h>
 #include <linux/workqueue.h>
 #include <linux/errseq.h>
+#include <linux/fs.h>
 
 #include "layout.h"
 
@@ -200,8 +201,6 @@ struct ntfs_volume {
  * NV_NativeSymlinkRel		Translate absolute Windows reparse targets (native_symlink=rel).
  * NV_MftBootstrap		Mount is still assembling $MFT's own runlist.
  * NV_StreamsWindows		Interpret the final path component as file:stream.
- * NV_EmergencyRO		An error made the volume read-only until it is
- *				unmounted (errors=remount-ro).
  */
 enum {
 	NV_Errors,
@@ -224,7 +223,6 @@ enum {
 	NV_SymlinkNative,
 	NV_MftBootstrap,
 	NV_StreamsWindows,
-	NV_EmergencyRO,
 };
 
 /*
@@ -266,14 +264,13 @@ DEFINE_NVOL_BIT_OPS(NativeSymlinkRel)
 DEFINE_NVOL_BIT_OPS(SymlinkNative)
 DEFINE_NVOL_BIT_OPS(MftBootstrap)
 DEFINE_NVOL_BIT_OPS(StreamsWindows)
-DEFINE_NVOL_BIT_OPS(EmergencyRO)
 
 /* -EIO after a shutdown, -EROFS after an error with errors=remount-ro */
 static inline int ntfs_emergency_state(struct ntfs_volume *vol)
 {
 	if (unlikely(NVolShutdown(vol)))
 		return -EIO;
-	if (unlikely(NVolEmergencyRO(vol)))
+	if (unlikely(sb_emergency_ro(vol->sb)))
 		return -EROFS;
 	return 0;
 }

-- 
2.53.0

