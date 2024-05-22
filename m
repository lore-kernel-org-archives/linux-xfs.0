Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CEE5221
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 06:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716357753; cv=none; b=ArPp+soi3cf0CHmSu6D0CypO6jXQoDdyYx5QkoqHeyt8i75vfAZqS2OIyS+AWaao/dD2+geZ16UdsUmYDAQxgmxk0Ii+W+y5/QLzmjh7eGt6+0uydE/6hkCd0+lEOpe0N8vXPa8go43oB7C0mCoLpaJs2N+dYnXshmZEk3TXS/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716357753; c=relaxed/simple;
	bh=Z/4l+7M/FKbkMknz6DHB4UNWMnwpKh3UbqiktjL6Zfk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g7kZSR1VklMg3gCW2kOIIsGIV3UEmqXr2KpB6LcnDUAekA5Oc+BHKLyZ0JbmUuGNAZUwQ5eCWGIQ56S6R6LoPoXaz0AJu90FwQBsq1N62DhiIlH6Sjf6l/2A4aE0E53XqKWLUuJBwSC5OygPqf6rqB5VrnCYII6FWVfzVVMTo0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeNgZvzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeNgZvzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300A7C2BD11;
	Wed, 22 May 2024 06:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716357753;
	bh=Z/4l+7M/FKbkMknz6DHB4UNWMnwpKh3UbqiktjL6Zfk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PeNgZvzy3xxO28heAICAq8o/05MiEjODyOfQTVSrI9Jcg6sB1+UtQh7AduYECdTln
	 R7DfYD7RtVd/ss9tej4TVx3E45BMeUx2Euoe/Sbd757SYASILgvCiqHkbRPW9euuyn
	 4F+TrGMlaSd0I8PpKz/CrZf3wYEd9iTQPfr2lZrLy6ifI90B/2Wyw0wcg+4mCM1Iv3
	 sGbJdAB4tpMVhmjH7a2Q6uIBCz5UA986ba+LaMt8maFDFYi2wPHeOOSw0vc6e66p/L
	 KWcELSdexzN83gxOj61V8JKcZzhfCsL7fWICUW5M/6DTv9pUVJmT6M73v+7ogYx381
	 8dUQdRrJ9PDxg==
Date: Tue, 21 May 2024 23:02:32 -0700
Subject: [PATCH 4/4] xfs: don't open-code u64_to_user_ptr
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171635763440.2619960.14439661076356669914.stgit@frogsfrogsfrogs>
In-Reply-To: <171635763360.2619960.2969937208358016010.stgit@frogsfrogsfrogs>
References: <171635763360.2619960.2969937208358016010.stgit@frogsfrogsfrogs>
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

Don't open-code what the kernel already provides.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/scrub.c |    2 +-
 fs/xfs/xfs_handle.c  |    7 +------
 2 files changed, 2 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index c013f0ba4f36..4cbcf7a86dbe 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -856,7 +856,7 @@ xfs_ioc_scrubv_metadata(
 	if (vec_bytes > PAGE_SIZE)
 		return -ENOMEM;
 
-	uvectors = (void __user *)(uintptr_t)head.svh_vectors;
+	uvectors = u64_to_user_ptr(head.svh_vectors);
 	vectors = memdup_user(uvectors, vec_bytes);
 	if (IS_ERR(vectors))
 		return PTR_ERR(vectors);
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index c8785ed59543..a3f16e9b6fe5 100644
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
 

