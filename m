Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290122;
	b=rAAskQoTP8xhLQAqgzpBp5G+HFAazN/ljCEBt/btL4y1eUmQSYfH1i/xJMCy+m1/I5sj
	 ruSX29Kth2sTl31v9QndvTeBze5i7oGcKDi+A4oVb31JvHql5ktqt0qKWt6HP5gCyPyaL
	 ry393xB9D4kb0GlB0tFSdI2PWDlM58Xc8Ty30Ax4YBOSeZlCK/mPVT9/lA9VdsLJoBWkp
	 J/1j5KLIfWd7W/MOBfa+8EIypliuiJlhkF9/dWUfumPCwMLOolwhdF2qaBWFPcWme0YtJ
	 7ByPP/NrEBUpiBRCMss4EPJouFW2Zvcfm8bFoDXNqi4e8zUMKnAu1ycepb+BgdF0PvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290122;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=/BWnxppliWOmynaxs29fGFYt24wOTlqSg4Z+oJtQIpE=;
	b=k7wKyKyC/ZG/A+Mjg5Ge3p8Du9nP8hUfApq7VZiQn/625pYHSKod83oOL3Fus1t7W4uv
	 1g0EzMBusvAIUxP4AXhegPh3vrwb4BqbZulJGmhH8hkBWNj74EPFWZl6UlsJfOBWB/h+d
	 U9PSepVMBROq+BqDLFOkqdXQrYxRJ9LJ3Ui85k+BYHFDmR1BH49/5ZTfNusxlNCucHyO0
	 oEUAGM4LqDwUghk2pRnB9/JJGqwTVwGmTYEg91h9/Nm1EswyS5fzY2qvTQA4oIEtm+r5I
	 Kic9szYa5TPbzLrOk+1/6F8oB71V+i0HdCMxwxPGjYKiy/qbYNLURFCOvF3nBZKtv6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T4FHlTua;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4EE606A31C;
	Thu, 29 Oct 2026 16:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T4FHlTua
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5271F01824;
	Thu, 29 Oct 2026 16:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290122;
	bh=/BWnxppliWOmynaxs29fGFYt24wOTlqSg4Z+oJtQIpE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T4FHlTuaqRfJAzhzCJ1btbf9e9sQyfvqdPREw/hMRAZdwLVUfHioRc2GTMQk7m/Av
	 2o8qceLJnuQ2Yniqjw/EI832tf2PwdxCwRlaxHl16mcmqJZO4D6F6+vJvM2CccQq7S
	 d8IbekTfL7lPE3H8b7JebgeIIlsg3LMhu4lP5zsXw1KzJmDjPCMqNHAe3cqFv0NnYI
	 y8vSgEvao271qfeUB+qAukuKn9h2OT+A+b4YvvRN1s3kwce9Xm0dE9Taa/eLsXMr+B
	 RULIjQrSOsznLFzL+PV2X0/RQEIiZXkdAy/pbh/jXxpbd4uSL9f/ixbr+wf9ftMbCu
	 SIkpazprBoNQQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:10 +0100
Subject: [PATCH v2 19/34] ocfs2: keep the current mount options on remount
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-19-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1795; i=brauner@kernel.org;
 h=from:subject:message-id; bh=eukLrrIxQyicjG2U7lt02AzXtZXtBti4CMni+Zukyzg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztfv235vgZqSUfy7nl9S1Zb3vNWKDwVoPmOSTdg12
 eA617SFHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPxYGRk+L9wWf2hvo7qmqqP
 2+Zo8Fumh+e/Y//8tNqO69baothaA4b/VbffPt52dXHp0bKpmSd+bP3lIOr3Iuey5iGbpa+27no
 rxQAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ocfs2_init_fs_context() doesn't inherit the current mount options for a
reconfigure. But ocfs2_check_set_options() insists on exactly one
heartbeat mode and ocfs2_reconfigure() refuses to change the data mode.
So every remount without heartbeat= fails with EINVAL, including
emergency remount (sysrq u) which passes no options at all, and that
WARNs for every ocfs2 mounted read-write. A remount that does pass
heartbeat= silently resets every option it doesn't repeat, e.g. noacl,
errors=, barrier= and preferred_slot=.

So start a reconfigure from the current options like exfat and gfs2 do.
Asking for a different data or heartbeat mode still fails with EINVAL.

The next patch stops ocfs2 from setting SB_RDONLY after errors. An
errored ocfs2 then stays read-write and emergency remount would run into
this as well.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/super.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0af2245ae303..67283244426e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1222,6 +1222,19 @@ static int ocfs2_init_fs_context(struct fs_context *fc)
 	mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
 	mopt->dir_resv_level = -1;
 
+	/*
+	 * Start from the current options so a remount only changes what it
+	 * specifies, emergency remount passes none at all.
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

