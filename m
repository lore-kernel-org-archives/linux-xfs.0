Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571263;
	b=DpDMOiBEw38o1tKHYW5/dObSI5v7gtYDEgMFlZ6glHRkEb+1rNKC+YiaffPInr+Ps5ac
	 NzA7Lx8LLNP8kUej2t6y54VJ8KmKOVugEfrxHW6ME8M7maI/vm3zXo8SgraOt4KKiuWd7
	 Qshn4aK7FOcFyyZf25l30gKq65RQ06/c76rih5mqI3GU8bo2/y9fBwyna0l+nouLCO+1b
	 LgL1MOkzXq/sqqlZyHOy/mIpbsZ70UMrsq3eqNbAHEji58XKUS/d6kMCWs6rTj/Bp3ioo
	 wSxg97FT/vjCBg7GWLBsjG1nP2uImz7PxOtmGzgt/oOrMO4jVEr/IkpffuodJoFhE4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571263;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=yyeMtFRiFUm1GgKqiaueiDO/IS6fCBvaYPtU/LMu/xo=;
	b=oaO4XjCjaGV2PM3/7E9gYzWnAHCD7EwNM8rbrIRsY0tPqzLzd9Xud6iN73v7TnWGyJxS
	 RLui/RFSJjIZfzVAmpGEIU73pZDaAyFvmK3maMiYYo6GFVh3xVCtbKoGosG1stMY2fCk+
	 m8lEEoWTU3WXQI9s/TNAVdNosjFR/xBWh6FY33Yu2SL4rYPNl0/2APcJEcTU3VA3kMsVO
	 qVbrng7FWkz9hXV1IyzbLnvdVl+s97ccEsHEimH/YXTOUPmpk5xFwdNf8s0Fo55GkmXze
	 T2Llbpf13KNxDXMOfny+MGBJUOtSiqBhveVUd9L44QhKleTKWIIaRKHHPMma85IpgZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kF4AFKYZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1CE606A33F;
	Fri, 13 Nov 2026 12:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kF4AFKYZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E831F000C9;
	Fri, 13 Nov 2026 12:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571262;
	bh=yyeMtFRiFUm1GgKqiaueiDO/IS6fCBvaYPtU/LMu/xo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kF4AFKYZ6LTt4D1pyInaN9B6u0OE4jPZDqqgqRlu5SSxnCxqtEaOUJ+9FGVs79LN5
	 LWwJvImEvXw1/hVRnIhQVs1XAl5oyAi3sjHQ7m8vSgf4vYHiAE49qa+Nbo40Uj0vJE
	 c78CtHjAIAiUZeQG+LB5Ults4fwbM5XtpnTiSDELaN3V3HHjcJk82wrBi3krguYfik
	 z4bJ7/0CyTVnxO8T12tpwrsl5fKdKGqCSpLZW5fFVOUPeGb8NokGmStMRW9vLj/Rm9
	 8NKMUYABnEbHP8iXKEEYMPGAgFZTpyLPomrT9t3P93S0KMDFLQGtBq91Z0lJWC7HzM
	 W/YQ2P1zAnNjA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:08 +0100
Subject: [PATCH v3 12/33] exfat: use the generic emergency read-only state
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-12-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4142; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ZSlUpRfgik1TuXvBBVvkw3QqcpPSPBH3FavShZHmWoU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+71iovftKZ2+13Pn17z7+Zx1wqsG5o2hLvcmBz1cE
 LI1qXm3Q0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEIpwYGS5VN1rdk4s1mHHD
 MPH6rux/+n18sxXNQg3KDSfbV2k98mX4724wyXxD8okWRkeenetC72+76+Ps+jDH+si3g273dZh
 vMAEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Set SB_STATE_EMERGENCY_RO instead of a private bit when an error makes
the filesystem read-only. exfat_emergency_state() keeps telling a
shutdown (EIO) and the emergency state (EROFS) apart so none of its
callers change. The VFS refuses the remount to read-write now so exfat
doesn't have to, and /proc/mounts shows the filesystem read-only again.

The VFS also refuses to freeze the superblock in that state. So
FS_IOC_SHUTDOWN with EXFAT_GOING_DOWN_DEFAULT or _FULLSYNC shuts down
without the freeze after an error, there's nothing left to sync anyway.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exfat/exfat_fs.h | 13 ++-----------
 fs/exfat/misc.c     |  6 ++----
 fs/exfat/super.c    | 12 ++++++------
 3 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index c0e712d9083a0..ac138f1119886 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -123,7 +123,6 @@ enum {
 
 /* Superblock flags */
 #define EXFAT_FLAGS_SHUTDOWN	1
-#define EXFAT_FLAGS_EMERGENCY_RO	2	/* read-only after an error */
 
 struct exfat_dentry_namebuf {
 	char *lfn;
@@ -376,20 +375,12 @@ static inline int exfat_forced_shutdown(struct super_block *sb)
 	return test_bit(EXFAT_FLAGS_SHUTDOWN, &EXFAT_SB(sb)->s_exfat_flags);
 }
 
-static inline int exfat_emergency_ro(struct super_block *sb)
-{
-	return test_bit(EXFAT_FLAGS_EMERGENCY_RO, &EXFAT_SB(sb)->s_exfat_flags);
-}
-
-/*
- * Modifications are refused after a forced shutdown (-EIO) and after an error
- * with errors=remount-ro (-EROFS).
- */
+/* -EIO after a forced shutdown, -EROFS after an error with errors=remount-ro */
 static inline int exfat_emergency_state(struct super_block *sb)
 {
 	if (unlikely(exfat_forced_shutdown(sb)))
 		return -EIO;
-	if (unlikely(exfat_emergency_ro(sb)))
+	if (unlikely(sb_emergency_ro(sb)))
 		return -EROFS;
 	return 0;
 }
diff --git a/fs/exfat/misc.c b/fs/exfat/misc.c
index 56dcb93ce69e0..03c5c2b9a65ec 100644
--- a/fs/exfat/misc.c
+++ b/fs/exfat/misc.c
@@ -25,8 +25,7 @@
  */
 void __exfat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 {
-	struct exfat_sb_info *sbi = EXFAT_SB(sb);
-	struct exfat_mount_options *opts = &sbi->options;
+	struct exfat_mount_options *opts = &EXFAT_SB(sb)->options;
 	va_list args;
 	struct va_format vaf;
 
@@ -49,8 +48,7 @@ void __exfat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 		 */
 		if (!(sb->s_flags & SB_BORN))
 			sb->s_flags |= SB_RDONLY;
-		else if (test_and_set_bit(EXFAT_FLAGS_EMERGENCY_RO,
-					  &sbi->s_exfat_flags))
+		else if (!sb_set_emergency_ro(sb))
 			return;
 		exfat_err(sb, "Filesystem has been set read-only");
 	}
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index feeda41a80741..e3587ed270245 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -100,7 +100,7 @@ static int exfat_set_vol_flags(struct super_block *sb, unsigned short new_flags)
 	 * if this volume has been mounted with read-only,
 	 * or an error left it read-only (it stays dirty then)
 	 */
-	if (sb_rdonly(sb) || exfat_emergency_ro(sb))
+	if (sb_rdonly_any(sb))
 		return 0;
 
 	p_boot->vol_flags = cpu_to_le16(new_flags);
@@ -176,6 +176,11 @@ int exfat_force_shutdown(struct super_block *sb, u32 flags)
 	if (exfat_forced_shutdown(sb))
 		return 0;
 
+	/* After an error there is nothing to sync and freezing fails. */
+	if ((flags == EXFAT_GOING_DOWN_DEFAULT ||
+	     flags == EXFAT_GOING_DOWN_FULLSYNC) && sb_emergency_ro(sb))
+		flags = EXFAT_GOING_DOWN_NOSYNC;
+
 	switch (flags) {
 	case EXFAT_GOING_DOWN_DEFAULT:
 	case EXFAT_GOING_DOWN_FULLSYNC:
@@ -789,11 +794,6 @@ static int exfat_reconfigure(struct fs_context *fc)
 
 	fc->sb_flags |= SB_NODIRATIME;
 
-	/* After an error the filesystem stays read-only until unmount. */
-	if ((fc->sb_flags_mask & SB_RDONLY) && !(fc->sb_flags & SB_RDONLY) &&
-	    sb_rdonly(sb) && exfat_emergency_ro(sb))
-		return -EROFS;
-
 	sync_filesystem(sb);
 
 	if ((fc->sb_flags & (SB_FORCE | SB_RDONLY)) == SB_RDONLY &&

-- 
2.53.0

