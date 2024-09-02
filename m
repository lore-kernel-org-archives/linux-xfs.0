Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569991C62C8
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301967; cv=none; b=pWTNyzAsMstAyMw+9VzyVa4umgV3c/IQGUfs1Ye3kr+N0sa3E2bdUPJyLHmDAXwnBrWOYPi9UVo0mNj+6WkoMdjcxtL7rtu4YF37ONLqZlLN4187GqnTK09b5AHC8+A+0yqDqsQ+Cz/8NTiYo8eAcnmA657lWg429po0Ln3nu6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301967; c=relaxed/simple;
	bh=mOysTuo09h7rA9cVz+NftFQZNNwSPVsXe3mCS+4bFU4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QI0qkrM/UpXIWB64ik/dJ+k41FRMYKG3uEDV/Venh2NQbrVijdZw7/feH133zcI4Xc7z/n2UdPwWtSBJWx/5GpCZees4booIUxTDtG+CiWz44ZHEacTeDecrCBOYFmG129nbl5HnjLbOu9QQr/e527S1xbuC89Qrg6b6TcepF5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3FyYVKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3FyYVKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7482C4AF09;
	Mon,  2 Sep 2024 18:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301966;
	bh=mOysTuo09h7rA9cVz+NftFQZNNwSPVsXe3mCS+4bFU4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o3FyYVKaNQm/efNhDivIL65KGKPsBZSGTxhJmw2QiKSzUrSyLKt3NRmO4SqCS/Y/g
	 esf2juOALF1bsIdgkNatj6JqsukVBg8ZnPjfPlzZBNMcU9xlQA/SPpqLl+zIuZWFmS
	 3BH33NInDDZ+RLptqlZEp9Gr1lzWNLSfDvul15F3sct9aioWpZRDK1ULrjanORYgZy
	 keL9r9Je/tXW5CGoIevWu/+5NGWkUvL6qmKUF/XZs8a4o2l70CWlRRVrUob59NWGJR
	 C5jza2X+FrhFojCPJWLXPIkE41MIBEIjLhZ2iWVvrC6weplofS4ZHywooxM2sVF+cH
	 Fw/jTSpwfxWIA==
Date: Mon, 02 Sep 2024 11:32:46 -0700
Subject: [PATCH 1/3] xfs: fix C++ compilation errors in xfs_fs.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: kernel@mattwhitlock.name, sam@gentoo.org, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172530107611.3326571.13323604540410354264.stgit@frogsfrogsfrogs>
In-Reply-To: <172530107589.3326571.1610526525006344754.stgit@frogsfrogsfrogs>
References: <172530107589.3326571.1610526525006344754.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Several people reported C++ compilation errors due to things that C
compilers allow but C++ compilers do not.  Fix both of these problems,
and hope there aren't more of these brown paper bags in 2 months when we
finally get these fixes through the process into a released xfsprogs.

NOTE: I am submitting this bugfix over the objections of a former
maintainer, who insists that we should remove this function from the
published userspace ABI instead of fixing the C++ compilation errors.
No deprecation period, no discussion, just a hard drop of an already
provided and correct C function, which would be in contravention of
Linus' rules.  IOWs, removing ABI that have already shipped in a
released kernel requires a careful deprecation period, so I will let
that maintainer run that process.

Reported-by: kernel@mattwhitlock.name
Reported-by: sam@gentoo.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219203
Fixes: 233f4e12bbb2c ("xfs: add parent pointer ioctls")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c85c8077fac3..860284064c5a 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -8,6 +8,7 @@
 
 /*
  * SGI's XFS filesystem's major stuff (constants, structures)
+ * NOTE: This file must be compile-able with C++ compilers.
  */
 
 /*
@@ -930,13 +931,13 @@ static inline struct xfs_getparents_rec *
 xfs_getparents_next_rec(struct xfs_getparents *gp,
 			struct xfs_getparents_rec *gpr)
 {
-	void *next = ((void *)gpr + gpr->gpr_reclen);
+	void *next = ((char *)gpr + gpr->gpr_reclen);
 	void *end = (void *)(uintptr_t)(gp->gp_buffer + gp->gp_bufsize);
 
 	if (next >= end)
 		return NULL;
 
-	return next;
+	return (struct xfs_getparents_rec *)next;
 }
 
 /* Iterate through this file handle's directory parent pointers. */

