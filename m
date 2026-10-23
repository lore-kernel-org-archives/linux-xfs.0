Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792759502;
	b=ew21pH7aYkOlJ1yImQJFOG13x0JsMA+lycY67MSUNCDfUGD+peCkHQo1CMOxynBI9CZu
	 fVUjvWdIgglrdKODN1cmV70sFxrpiL1q8dW7zHuoVVTzWf+9FMviJZM3hrtKRM+X5r/aK
	 b6MFiHLKKygUw8ezWrm9JvKwMye9o92tjLGnFQDA2p1Oe7Xi+pG8qnBYSxNpAvDDxAEt3
	 48Ar36kuFp7XbU1vbc+Yq/ShZk6xs1wRot+3Q6FHH/lhcWOxHd1YMIQBbhrWLGo2oKyzh
	 Y11rgMgjb8XF+kcrgcRdzrprVvorlyjpFwSTh//J3BHjQMoSAAF+TJGhkc4JQaDAnkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759502;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=rgdAURmlMgVTnL/fFQWHyNoovvjMeOUAESXzVFTzmXg=;
	b=5HkEZUk4BiyY574ZD8FNp/IPh0i4vADxoYZP9A4XwwS/Mu+vNe5BeCSPDsLGqfPTJQce
	 5UhgROT+UAgpM5LyKC1+F6TnJroyokvRnjAqfCnPCUuYo9eh8PekOuFK3/xNy+2vz3XtS
	 EJQBsX/TcqELEgrrmxNaph/r+SqxmBtR7DJ7gqdIw6ntEQNpl5xRmLoJo/zA65EnP8v0H
	 +ReP0vvU73Kjozw3/Xcsz3Y+hIevK3yFwFAoCtv9GLmhfHjEy85Y5+8kzGVfEtyjgRuBO
	 dDLSRciWrNfelDMcfJeV4KPaE2GI77XVQk0viqhIrfcV8TmoGLWsw2b2JEnHdzE6jFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NzJZDvRh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9921F606A31A;
	Fri, 23 Oct 2026 12:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NzJZDvRh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D0A1F031E1;
	Fri, 23 Oct 2026 12:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792759502;
	bh=rgdAURmlMgVTnL/fFQWHyNoovvjMeOUAESXzVFTzmXg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NzJZDvRhW++FYtXdKKWPF53butaI0sT8gd8vRr/FNZsnMriJJwgCoTxpRKEeZBSzh
	 qec871Xz377IDpLG3uDPN+AnEpyqEMxkFfbrcFRnvPyeuldmahqoppMG4D+go2WeSt
	 AIredcXrv+K5Bshr20/XEhukZ4dNPB+m9BExfxPR59cZtV2qsDqaWQALiJLqbtmeyA
	 nhxyuYb7pOYTwbq2wk4+ksh3ZjGT3Qp0DPQv466YRdJPhpiTvo/6CBVwRbzT2RQYu6
	 eNIF5vmJN922ITZsz8xsUUVOkM454G9CW3x3j8U/wvt31i6dbIqGMe2WA9s0idbuOn
	 yb+2kXSp2TnRg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 23 Oct 2026 14:44:23 +0200
Subject: [PATCH 2/2] xfs: unhash a removed name in ascii-ci mode instead of
 invalidating it
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
Message-Id: <20261023-work-dcache-casefold-v1-2-1b0bd5c73a69@kernel.org>
References: <20261023-work-dcache-casefold-v1-0-1b0bd5c73a69@kernel.org>
In-Reply-To: <20261023-work-dcache-casefold-v1-0-1b0bd5c73a69@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-xfs@vger.kernel.org, Gabriel Krisman Bertazi <krisman@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755; i=brauner@kernel.org;
 h=from:subject:message-id; bh=f6kUNy44BjhD0KISho48b0YJIAWFq4F28VN5497hSx0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTdDjsmtez1EymBm2u2dTw8zvbPwWTtG0GJO1PdJWcG5
 +sryvBO6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIigwjw3T/z58Sn1fu8eje
 7Lp8zbGYq5ufmXy4kqN3dpK8x1TLS2cZ/vudvjs1cPU1y4+bJ/XEzFzb4+0UJXyu+wy/edXznCp
 5CS4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

xfs_vn_unlink() uses d_invalidate() on the dentry of a removed name on a
case-insensitive filesystem, so that d_delete() doesn't leave a negative
dentry behind. The next create() would otherwise reuse with the wrong
spelling. But as the comment already states all it wants is the unhash.

But d_invalidate() is the wrong primitive for that. It's for a name that
went stale. It walks the subtree, prunes it and detaches every mount it
finds, under namespace_sem, and here that runs from inside the
filesystem's own directory operation. There is nothing below a file or
an empty directory to prune, and vfs_unlink() and vfs_rmdir() detach the
mounts a few lines later as for every other filesystem.

The previous patch moved ext4, f2fs and tmpfs over to d_delete()
unhashing the dentry for them. ascii-ci doesn't set S_CASEFOLD, so the
VFS can't tell these directories apart, and the feature is deprecated
anyway. So just d_drop() the dentry. d_delete() finds it unhashed and
turns it negative without hashing it, exactly as before.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/xfs/xfs_iops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d307ec97fac8..bed8372e4bcb 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -416,10 +416,10 @@ xfs_vn_unlink(
 	/*
 	 * With unlink, the VFS makes the dentry "negative": no inode,
 	 * but still hashed. This is incompatible with case-insensitive
-	 * mode, so invalidate (unhash) the dentry in CI-mode.
+	 * mode, so unhash the dentry in CI-mode.
 	 */
 	if (xfs_has_asciici(XFS_M(dir->i_sb)))
-		d_invalidate(dentry);
+		d_drop(dentry);
 	return 0;
 }
 

-- 
2.53.0

