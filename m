Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290085;
	b=aZaFNkgGS2JIn6hTZ+nTG25xAs7ub0NjLFfbb3i8SkhjAZr/TaVOsyA141QlEsBEbD+y
	 aF2UiGNWXebHFpcWlseLaCJtgSLYADbAWBOia9gv+aZ+SptA4B4HH5vHme1BqLSs9baxF
	 R2kTKMO90SPwejySfpabO7WWflMKFUfYt7gsSOSPdphMpRL+ixaG57teCcA1lTS8l0Mej
	 Lz/MIqDlgWRRJl90mPFOW9V9KD/Jv5l3Zgvf5kaTPTfXQVaKI9yYI/9tjtUnSGmNYZoYd
	 E5Gv5mQjFAuXj9f79+DGTfW7UbqsZwGmFKBBKyFK6ORMJOcxZvVClEVVj6CRT+Q1ZWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290085;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Ld8tK5M3ket5fFNNR85Z6vJpytIJnb6SUdsH7qSK2pc=;
	b=cdc/KNx29U/eUiZi6lR30extl69TtmKkYS0o5SCGaa7TN0N4tjc6gTB0Jr5qNCq4oXkG
	 7MUx8YVheiJ9PWtBkz0IiXtIq+MFW+43sTyeU0OYiWwTuDLriUIAvcfKWLdK1Gln790KH
	 RZmIJ8OkGWHgN1B3ViizUF2saAtH9ABJ4zmPYLs8WgiKhhNy7v7HXLRNKblbs/vCq7vh3
	 Jd7zwN1ysqWWHOrJz4kMh9wGLj9NgQeo/PqWOymb4YhlhKl8CmpDgr4Gzz/3gpwvuwrN9
	 exHm7kvuP+25hhMuySTHXI7ut2FPrHWfyijyhiAjcdmYsw/s09kP4z6viz+Myjj6SBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FlJul7Vs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBB8606A31D;
	Thu, 29 Oct 2026 16:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FlJul7Vs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BEC1F01826;
	Thu, 29 Oct 2026 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290084;
	bh=Ld8tK5M3ket5fFNNR85Z6vJpytIJnb6SUdsH7qSK2pc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FlJul7Vsdpn3n5A2HEqFsf/yVzUNEuowhdfB/IkGNzGZzl9akfrpY/E1BY9MANWoC
	 6NTg+QQB7hEf317fcdHpECmonUmtIf/Kk/6tbiSridFhxUmx+ykizzqv843eY8TuCy
	 sfA/OHVqFal6LvPuk/flXur/QzCN8rAW7qyT/m5ruF2p1Rgaw/x4C0ADkhauzDccDS
	 UaSS9p8/N2zr27gWAz9/BurwyH6xuA9eyamYTNN+giQXuZWHs7A7p86RQYUsJY9kGG
	 wAgrrs6byWUpu73Yiqf659jW89OaTl9O2n3fdlLAc6Q+dSDPCHkD7ZRWlQwVoRUuhu
	 G59QTXC4RR7gQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:01 +0100
Subject: [PATCH v2 10/34] exfat: use the generic emergency read-only state
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-10-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3494; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+iq+q4dT/MCyRISfgOR900E8oovb/RAJIKa4lXXMNr4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zteXPaXoqaoVKrP4YPZcRucr4T3c76ftE0485Kb+z
 fBoifKkjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlc3Mnwv5rhTJ3850P/t7a+
 Lnq0NK15yae5L6PLle12WXsHpjzXYWRkaAmuLxDMuysxn7XGalb80QfX38+02/h9zzLVMr/E1Sz
 GLAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Set SB_STATE_EMERGENCY_RO instead of a private bit when an error makes
the filesystem read-only. exfat_emergency_state() keeps telling a
shutdown (EIO) and the emergency state (EROFS) apart so none of its
callers change. The VFS refuses the remount to read-write now so exfat
doesn't have to, and /proc/mounts shows the filesystem read-only again.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exfat/exfat_fs.h | 13 ++-----------
 fs/exfat/misc.c     |  6 ++----
 fs/exfat/super.c    |  7 +------
 3 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index c0e712d9083a..ac138f111988 100644
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
index 56dcb93ce69e..03c5c2b9a65e 100644
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
index feeda41a8074..67b34cfce247 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -100,7 +100,7 @@ static int exfat_set_vol_flags(struct super_block *sb, unsigned short new_flags)
 	 * if this volume has been mounted with read-only,
 	 * or an error left it read-only (it stays dirty then)
 	 */
-	if (sb_rdonly(sb) || exfat_emergency_ro(sb))
+	if (sb_rdonly(sb) || sb_emergency_ro(sb))
 		return 0;
 
 	p_boot->vol_flags = cpu_to_le16(new_flags);
@@ -789,11 +789,6 @@ static int exfat_reconfigure(struct fs_context *fc)
 
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

