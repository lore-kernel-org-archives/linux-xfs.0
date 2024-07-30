Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA134A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299011; cv=none; b=uQagCd5ctMUzJF3FAbhr89poYSKyCBz+gCXfan27CK8zU1ZzIUYCjh9MdPvmTUlFbiWxsnLy3Xh+2AIOkK9WuCxc7mRXqRRHYAmk5sXHk0biDzNoAuYQw8LYmt7j6QXB5tfIN3DE6Ies//dc9cYm69DArfAtzVCVF9OQ+1/xH8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299011; c=relaxed/simple;
	bh=2pah8iC+B2JVjym72IboOwC3wLceJ9ssSge7fNZyWR0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rFyCjGhK/IE7NNGjjth2Lno2duz0hw1iBtjX+/1OJOkZQkeuCe0lX03B2gQ0zd1MPkTOWlpfGaJ4vOATX7KIzsiJ8FFof4lGz72thE8ZhlFf0kvJV5UXZ3+j2EW3A3sLa1K2krfjf59ppAg7+iyIzc04N1OUodq2zzubYZOOG20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUcOg6eD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUcOg6eD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39109C32786;
	Tue, 30 Jul 2024 00:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299011;
	bh=2pah8iC+B2JVjym72IboOwC3wLceJ9ssSge7fNZyWR0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mUcOg6eDOLdPFcvhxwRmzDTcWdDb2zPGTeT/38xqSl2LwuK8jdXUvE+wuEi3kKqdf
	 JOrDb2xUUrcLNX6Uc4Jjb++xtLLGDZSRNSV00OjYKj2wg0I0Up0wpiYIeu49MQ6r9V
	 0zGFz4Qwx538IdMmuQTPWv7w8phlEQRX427M4okAmlRB4NPSn6dWssKeh36BQxxtxo
	 8GxqfFYXw34tyfDT5H+y/hMWdScyGNKk5/wEbxFX06SA9pAob9qSs27FVKgToijWZS
	 P2AsqxDoTLfJzuYAHNSwXTIgXJSRwNmTUlMdu8YS/Jw+j5EU+nGp/1wwt9zuABXYJw
	 Ol+k/cKuX6TGA==
Date: Mon, 29 Jul 2024 17:23:30 -0700
Subject: [PATCH 4/5] xfs_repair: don't leak the rootdir inode when orphanage
 already exists
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229841934.1338302.16119487560444301949.stgit@frogsfrogsfrogs>
In-Reply-To: <172229841874.1338302.4791739002907908995.stgit@frogsfrogsfrogs>
References: <172229841874.1338302.4791739002907908995.stgit@frogsfrogsfrogs>
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

If repair calls mk_orphanage and the /lost+found directory already
exists, we need to irele the root directory before exiting the function.

Fixes: 6c39a3cbda32 ("Don't trash lost+found in phase 4 Merge of master-melb:xfs-cmds:29144a by kenmcd.")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase6.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index ae8935a26..e6103f768 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -919,8 +919,10 @@ mk_orphanage(xfs_mount_t *mp)
 	xname.len = strlen(ORPHANAGE);
 	xname.type = XFS_DIR3_FT_DIR;
 
-	if (libxfs_dir_lookup(NULL, pip, &xname, &ino, NULL) == 0)
-		return ino;
+	/* If the lookup of /lost+found succeeds, return the inumber. */
+	error = -libxfs_dir_lookup(NULL, pip, &xname, &ino, NULL);
+	if (error == 0)
+		goto out_pip;
 
 	/*
 	 * could not be found, create it
@@ -1012,6 +1014,7 @@ mk_orphanage(xfs_mount_t *mp)
 			ORPHANAGE, error);
 	}
 	libxfs_irele(ip);
+out_pip:
 	libxfs_irele(pip);
 
 	return(ino);

