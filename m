Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602B6FBF0
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609859; cv=none; b=Jm8QdP4KzDrW18c9VZcfBzcMpY3KCxxVw/fnTnwmHVK2Ue3OiXxABhnN4XAfh3DgM0FdhPCyQv8qP8GxzRbptZPJXNMwJ9kJrNooejEeFVwRWbpqWAvV8xftUVryE4DHoQc+aoY1/b+8TFxii84K3mgeAwmCcVC8SXW30FrJ+r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609859; c=relaxed/simple;
	bh=tyK3U5oSCZMQIXwd6OCZCZnVz9ACqxKbgA9cFRbQw0s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=spoWUp37vSrSpoymbaog4FEA3LedDujDFs4JPDsbMz3GOydpqQDilxGi+OdctoB0Sm/crpRcJMnQKBZ9/icElaqGLYI8k31q0978uGbkD5XhJE+LDUoJ9QsLH8HT4pVn+hyc1AvaqM8TyiGMXrsVSGoZNUbAOVkIkZqJvFGgA5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h1FQeeBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h1FQeeBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B291C4CEC5;
	Fri, 11 Oct 2024 01:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609859;
	bh=tyK3U5oSCZMQIXwd6OCZCZnVz9ACqxKbgA9cFRbQw0s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h1FQeeBsFS5BArt49pouppcsxJAxlP5E2XNsiVoalsYA7Txqb1zdWAf9uZbJNEGkX
	 tkJZ5lXdKVeMAm5ZqVhcq+ynVA+jkjdibxtLGfSUdhUob8Y3ERHzp+fXoOj5OfU0Nt
	 DAo61KQ9yL+mcrs93BUkqHoaKdAn3otzpEpJCFr0ssRmcGDm1RY/Aua1PBPyoiRQAk
	 W8+DqiCGXs4PEBb6JXd2t+yIoZ386wuCMTaM29rTorodNfhjoegqNeG7gsXUhCLq+J
	 eiGTFxlY8yxe4hQ6nT8+56dorkazuKpWRoaC/WEXvN+SjZQibbyBanhqwFLzUkhBIt
	 3msNFz9Br+SWw==
Date: Thu, 10 Oct 2024 18:24:18 -0700
Subject: [PATCH 1/2] libfrog: add memchr_inv
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654897.4184510.847299719986927364.stgit@frogsfrogsfrogs>
In-Reply-To: <172860654880.4184510.591452825012506934.stgit@frogsfrogsfrogs>
References: <172860654880.4184510.591452825012506934.stgit@frogsfrogsfrogs>
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

Add this kernel function so we can use it in userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/util.c |   14 ++++++++++++++
 libfrog/util.h |    4 ++++
 2 files changed, 18 insertions(+)


diff --git a/libfrog/util.c b/libfrog/util.c
index 8fb10cf82f5ca4..46047571a5531f 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -22,3 +22,17 @@ log2_roundup(unsigned int i)
 	}
 	return rval;
 }
+
+void *
+memchr_inv(const void *start, int c, size_t bytes)
+{
+	const unsigned char	*p = start;
+
+	while (bytes > 0) {
+		if (*p != (unsigned char)c)
+			return (void *)p;
+		bytes--;
+	}
+
+	return NULL;
+}
diff --git a/libfrog/util.h b/libfrog/util.h
index 5df95e69cd11da..8b4ee7c1333b6b 100644
--- a/libfrog/util.h
+++ b/libfrog/util.h
@@ -6,6 +6,8 @@
 #ifndef __LIBFROG_UTIL_H__
 #define __LIBFROG_UTIL_H__
 
+#include <sys/types.h>
+
 unsigned int	log2_roundup(unsigned int i);
 
 #define min_t(type,x,y) \
@@ -13,4 +15,6 @@ unsigned int	log2_roundup(unsigned int i);
 #define max_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
 
+void *memchr_inv(const void *start, int c, size_t bytes);
+
 #endif /* __LIBFROG_UTIL_H__ */

