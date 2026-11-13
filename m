Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571346;
	b=1BhcoVbOrwZh/fzzWojWa5B41r0EpIfk7BCQkjy9hXT5pNAQWtfo3/AmgpyyTXWtGwGJ
	 rhb6lqGebZ0zvHELopZTev6OITUpN+ATUG486srcm7q5Fu6Hybo+Nm9TwURqxb5VDI+HM
	 8fzxdoQWiwbflUfhNFp36bXMwzXt2KUaSMVLZ+BPuJHQlhwXlApXIn2WqGeDJuGZGUS7k
	 gHWvj409XnHJSO9q2SNc4Z24dBzgShI3WlSWNi6Wom0H/asmx+6L1SudLB+Dwmrgs/MnA
	 kLUmnLQ7YbUJTa5PBHAQjFpUbcemL3XOF7qlC4XNQa4J+8orhY/1sarFqjHPzWe8m4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571346;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Ys3YMXl5oMlmXRh6V3Opwtt0DjuOynQe0v2BdPk6TCg=;
	b=5SiZw4wEj0/jMo4f0Rjx8wvsC6AKGpbWBWBef3blcWzz+3XItcUvMaUcPP+AUyoT5Vo/
	 4rAMAvsCgRO5XfCnMBYV2dNjPN6e8tXacSB7Blo72pM9uYo91Ga+DxTQ2z7CoVVvaxzKY
	 7gnvCBOb3Ik5MVwMZSRZYll992DMhGxx3u1v5Eb+9uw7b/HO5zzfg0+Iksho6da8t9wru
	 inmaHJ5MhRGnzd9g/BFfzeDwYPAtqrEAj8VzT8SDndrF6X85eZb/zh854tNsonXAaT2sA
	 l7nb3F+so0jC9g8lrILeekBAWANOOZ/PKwDp7ey5g87PVJ5B8Cthxu+XGHs0GuHFP2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Eop4DJ+y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A2A606A890;
	Fri, 13 Nov 2026 12:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Eop4DJ+y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950221F000C6;
	Fri, 13 Nov 2026 12:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571345;
	bh=Ys3YMXl5oMlmXRh6V3Opwtt0DjuOynQe0v2BdPk6TCg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Eop4DJ+yxDliZwyInAuNW8c3JHZf+X5C54FWRtqZtQrZ8ZzgrkakpbSmsnVcEyCFJ
	 uBy2Rr1UZrQWWl4dcr/zHxb3DnQoqEjV//kydM+Z4LWDLA6xrXgz1cvLWobpAqMJoD
	 s6EFw/9Gp9VX/gBBLbwRC0Lh5DJaKGw6dDShXcH+2rqCc78FILZNz5SPyMJ/8rt02Z
	 /Uc6drxqxlb/0B/1hTazmRyYdQPnOshcKXZMTAaXSaJeDakqkIVGljHsPYkwixDDIf
	 SE6uZqlFv8y+n9E/MMjBpudPTsEDkGmMS5LyyNOQolZRvDHUiUhKhYi3kFb1AIR8r5
	 NBVdDdqDKYOPA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:27 +0100
Subject: [PATCH v3 31/33] ext4: allow remounting read-only in the emergency
 state
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-31-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Jan Kara <jack@suse.cz>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2358; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fD+vdKPUstldI8+nFemEF3fb/4i0Xe3BUPEtvaff8Ps=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+73PxbtLyE9xTqkEb1nnpvBAb46ZBnddePYs722qt
 HuqemBRRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwES21TH84W+KMud47KIe7zf5
 5L17f8sPWkjIMB2Y+z3mHDv3ubbTDIwMTVmCIRs8JETqL4azM9raN+mvlAlnzbtd/pHjEOOfA4H
 sAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

__ext4_remount() refuses any change of the read-only state with EROFS
while ext4_emergency_state() is set, i.e. after a shutdown or an error.
Neither sets SB_RDONLY anymore, so a remount to read-only fails and the
filesystem stays read-write. Emergency remount (sysrq u) asks with
SB_FORCE and reconfigure_super() WARNs, a panic with panic_on_warn:

  forced remount of a ext4 fs returned -30

Becoming read-only doesn't need to write anything. So allow it and skip
everything in that branch that would touch the disk: sync_filesystem(),
dquot_suspend(), the s_state update, ext4_mark_recovery_complete() and
the superblock commit without a journal. Going read-write is still
refused.

Note that ext4_emergency_state() only exists since v6.15. Older stable
trees need ext4_forced_shutdown() instead.

Fixes: 95257987a638 ("ext4: drop EXT4_MF_FS_ABORTED flag")
Fixes: d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem errors")
Cc: stable@vger.kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/super.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9cae52471dee9..ae5ba6823c01c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6761,11 +6761,16 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 
 	if ((bool)(fc->sb_flags & SB_RDONLY) != sb_rdonly(sb)) {
 		if (ext4_emergency_state(sb)) {
-			err = -EROFS;
-			goto restore_opts;
-		}
-
-		if (fc->sb_flags & SB_RDONLY) {
+			/*
+			 * Going read-only must work for emergency remount
+			 * (sysrq u) but nothing may be written, just flip it.
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
@@ -6876,7 +6881,8 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
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

