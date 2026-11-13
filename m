Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571302;
	b=xOpHLI0LVr/Dxoo0YG8b6nFsSLMYSWmdDFJikuD1wnZJIA8hTPjJTtcKmum6+bCtvpOg
	 Ug1YS7n7srmlod1xvT7FdBgBIR4GwkmjO5+Xk4TO8K972cqKJF3cqwHlOXpNG1AQtTnAA
	 84raZ12mNWeZ4SYe7iy1pGDUUCukZYWMadgNspKeES9yE1khzmku4aKWTb5TgJTsH3JLF
	 1wJYoUPpRzADETfUHBeqsmpPDIIp9OCmzSys5lJb0AxIx9+u9yR3/D0dCGwbaStUMraMk
	 vv80P0tr8fb3I/x205xoYi1M00p0yGYKfsE1JVKIBtMYKYLeYZ//Iop1YFdAhH9SZUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571302;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=J7gadPQUzR3XBSmIK0cp3E2gwMCGpvAcu+l4Mgbphw4=;
	b=D+OvsuAm74Z6vUFsrOA4KYhANXbURPXCM5DE02j+xP4QZLChC87/v62MfpzidM/HiSzW
	 6AWeLK3wvX+duskUncgufcaexR/35R+j/nUPhH83uQ/cFI12JhWGgRhX3EBhtRC6gRWSq
	 TQi2jHu4r0fF0eDY/SLSXNc/dPIvecdPn0qmsPFDCbcoZLTAHIW3rMM2Wdz1OhKlQzMZs
	 65d8T2lE9BPKfB6HJATYkKXS371uXaFRkW7OhQOeY+ELa4viQwwOrQfAiDlVd8L7DTSMM
	 f3OyZIJjeeX2NXQoRWwX7PHl5aE7OrPalY+cF5i8fL14hxv5Td3idNVqKW3S4P4jkUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JBumoDPl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A9B606A8E4;
	Fri, 13 Nov 2026 12:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JBumoDPl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D191F000C4;
	Fri, 13 Nov 2026 12:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571301;
	bh=J7gadPQUzR3XBSmIK0cp3E2gwMCGpvAcu+l4Mgbphw4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JBumoDPlxQXXObG+ENpLQRg+t+pJCQJKdzOvzMvcSQDv2bqSEBwDjrp3w1ZJICxEW
	 B0guxIMp38vWFiJoKU7w63N+lTPzPQ2LkjFcT/QDyAAOI1O8kdAnuPRHrl3e3XuVCB
	 TSCr/0rlxJ5nsfX1kLTjNzzFjhDibzZaNloTL/oHrBBCwZYGzHDLviiPSTFD8XRChY
	 LcMmvS1DCAEFQIuJqxgaxVcaUHhhRZW9kBi2CQrHZD8rpXN2eItKeDApeZaNQZo+We
	 C2mGZ3sNNTlqHzUyc8xwf/zv5h4xzePYJAxJHtqB8Um42kkmVDme5JAozP/FP2acNh
	 zuOP4bYJCUSVg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:17 +0100
Subject: [PATCH v3 21/33] ocfs2: keep the current mount options on remount
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-21-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1851; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MPSPYKPscgP2L/4Ifq6qWngN+LUYlTiiBsWETuYkkwI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+71pS1J+tnkA9wxmpgChycfyqj1zb0/6KFzw6bjE7
 hnCRaV7OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYybSLDf6eO6XvTK9W4zDY0
 sax5OT9H8csGnotPN5zN+rl+52WB/umMDK+4XvFKdtoqFeWvSzSvyZnu/6SE8yzjS4vTtccNdYs
 ncwMA
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

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/super.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0af2245ae3036..67283244426e0 100644
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

