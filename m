Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60113535B7
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 15:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716303743; cv=none; b=or/+f9x9AYQOXHlWcB3R+O5Egckvv6MXg2+jNvXSfFXMkFrfKaN30CaY7CsQoVOOuQDyXyiD4SH0LJEuHOyA1zk+WfQoVh36BCF1A3Nqg4xjao4Y9WrrnD0HiA5K1KnV3/nev141DDqahBIHYvPHHxcBlVRbF8r+FgmeUPavZ4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716303743; c=relaxed/simple;
	bh=RO6v1TjkZpwccipgGfp6sPWAr/dcTEa30YFeMQOmd/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HJqm4tznbT5ZMfYTds5DHRTFD8SU8QzCc9kSqExXCD+wIHTnNXmBTVgL3Arh0yMVl4im35DntnKJEjVGAw0iOLboBKQrktnLzbhrULVLYf7uutltc3Vz4rCkZLe9ioJajjl36u8LPNcg+tGdkURTYf5PnOZVWaftUUUc6T0H7b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9qRBhcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9qRBhcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF212C2BD11;
	Tue, 21 May 2024 15:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716303743;
	bh=RO6v1TjkZpwccipgGfp6sPWAr/dcTEa30YFeMQOmd/Y=;
	h=Date:From:To:Cc:Subject:From;
	b=e9qRBhcZwcfHvLT51VgYWdVBr8m+wn5o4FgdkKDpW7pX4DLSwrI5LQu0kg6RlY2Qn
	 efZ6wQ3qNcMRRxUprY2BjMYX4VZrb3SR2yuO70XpyrN0wCSzBnvoboJ1OaC5L74S49
	 UhdWagVJQGTVIwi+4ZFiKtzgZ2X8XBH7HlmE+pbJtme+DncG7pmavN0f9jSOk5enw2
	 IUPJUE11i5iqnbRsyrOgcW+YWr2mIbCTdi6hEWASoalGGKILIIsI7BYRoecTjtJ4UX
	 NPsNzfZTWFqVGQe1VIpPaGebl2UKRg0/8kf+3TVzcqOvsNAkyBPj4UuIkQErLtMSKi
	 muDpg9d3UeK3Q==
Date: Tue, 21 May 2024 08:02:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: don't open-code u64_to_user_ptr
Message-ID: <20240521150222.GO25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Don't open-code what the kernel already provides.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c |    2 +-
 fs/xfs/xfs_handle.c  |    7 +------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0004f71099b40..6a2c16a41ffee 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -947,7 +947,7 @@ xfs_ioc_scrubv_metadata(
 	if (vec_bytes > PAGE_SIZE)
 		return -ENOMEM;
 
-	uvectors = (void __user *)(uintptr_t)head.svh_vectors;
+	uvectors = u64_to_user_ptr(head.svh_vectors);
 	vectors = memdup_user(uvectors, vec_bytes);
 	if (IS_ERR(vectors))
 		return PTR_ERR(vectors);
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index c8785ed595434..a3f16e9b6fe5b 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -773,11 +773,6 @@ xfs_getparents_expand_lastrec(
 	trace_xfs_getparents_expand_lastrec(gpx->ip, gp, &gpx->context, gpr);
 }
 
-static inline void __user *u64_to_uptr(u64 val)
-{
-	return (void __user *)(uintptr_t)val;
-}
-
 /* Retrieve the parent pointers for a given inode. */
 STATIC int
 xfs_getparents(
@@ -862,7 +857,7 @@ xfs_getparents(
 	ASSERT(gpx->context.firstu <= gpx->gph.gph_request.gp_bufsize);
 
 	/* Copy the records to userspace. */
-	if (copy_to_user(u64_to_uptr(gpx->gph.gph_request.gp_buffer),
+	if (copy_to_user(u64_to_user_ptr(gpx->gph.gph_request.gp_buffer),
 				gpx->krecords, gpx->context.firstu))
 		error = -EFAULT;
 
