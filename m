Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842A11442E8
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801639; cv=none; b=lgUwDmVkGDRN/T8M6/CK+vKdhY+uHMY1RLtT69f3ZZfd1UISD3iPvKgfa20kfWmlH4JAgFCBPLFfvuaawQTFkztQiscWm+rJiRzjZh7TcnU7LZco0j1gp1T64BZ3J1Gc5fJlyWnbh/AMzIk96wUbcDcNGMbN0GWl2j9WlwKpS6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801639; c=relaxed/simple;
	bh=k8BIaszvzBeThgIpXZEsAHPgfHSrwQUEiW9NppNp5RE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GzWsVR4wjLJhAtuMW+di8mf5XkQgV/g5TjKTE5hyzion6vzeYMFuM7tj0oh0WvoBXthlfPyuT2Iab7AqNDpMV20dleviA6DSTZ4igfJy4bLoMvPRoWAhoSjIhsd+8HGI/sS/2fbN4lQlbDeRvhf9CCGzxmO4cE2n6GdX1BMGDyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fc5zu9en; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fc5zu9en"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF1DC55DE1;
	Tue, 27 Aug 2024 23:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724801639;
	bh=k8BIaszvzBeThgIpXZEsAHPgfHSrwQUEiW9NppNp5RE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fc5zu9enMG4yIda9OK1oDi0NfiCMITeistw8zlWXzqsxSXR9hPo5zw5ZmxVx6g69e
	 SH2gcYUv33oamBmdNeZvmEYlP4H/OlIYf8hHqFYPi8mZ7ZAP9g724iCVpMAGheAlVz
	 14nHvmnk6NeYiNHGwNctmwe6Zfo0rdTBOAbeAhGVNKh7/Vt+iVLbgUCC0PTXPat5rW
	 krn7qymyrSdO9+bSc6oTqI7vmTBdVugkcS8zUZSxR1kVVAZJtWVkgeS3ELwYQAz5g3
	 RhqcXIuUWSzl7abjHDw5YJ5XjlRw2jT6RtazIBsX/OU9NPVJcxsnzhEaBVDdkJoS6k
	 RBqflbvaqgA7Q==
Date: Tue, 27 Aug 2024 16:33:58 -0700
Subject: [PATCH 01/10] xfs: fix C++ compilation errors in xfs_fs.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: kernel@mattwhitlock.name, sam@gentoo.org, linux-xfs@vger.kernel.org,
 hch@lst.de
Message-ID: <172480131521.2291268.17945339760767205637.stgit@frogsfrogsfrogs>
In-Reply-To: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
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

Reported-by: kernel@mattwhitlock.name
Reported-by: sam@gentoo.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219203
Fixes: 233f4e12bbb2c ("xfs: add parent pointer ioctls")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c85c8077fac39..6a63634547ca9 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -930,13 +930,13 @@ static inline struct xfs_getparents_rec *
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

