Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832DD8F40
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2024 05:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BG/tWptW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D274C433F1;
	Tue,  9 Jan 2024 05:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704779479;
	bh=vzZLVao2Csr5/Lm0R5xlLq484oqn1GLR6lfbCup5OgM=;
	h=Date:From:To:Cc:Subject:From;
	b=BG/tWptWz3uDO70YHRLAE5gncrwROR1H83we0RKQLKo4aXyB5AjXw7B3xktYAgD0q
	 e5odoYqRxPm0uyvFWbGEvSfdDjqqxVI6LNx5k7uRweB6ljHSNCxJIfgwCWXVsAI8hZ
	 FuHKE2UhnNUhsOcaS6DlZn0dMD4RZkrk4IdpTgmXmCgeU5dXKiMZTtlmT0XPzg7YzZ
	 KgtGNWoCHmNSMPjKkwtxKNb24KdTSUm+eYicV3NpdBh/OqZ/Y4U1H5Ju8wkw0ggxFi
	 crGkQ52kUYZCfmMcfRvFpsGJ8KeCMYDhYXh+9r+wP0K+c0rdUrLKKD/fUxraf4RrXk
	 b+AI1hYi9GOuw==
Date: Mon, 8 Jan 2024 21:51:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libxfs: fix krealloc to allow freeing data
Message-ID: <20240109055118.GC722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

A recent refactoring to xfs_idata_realloc in the kernel made it depend
on krealloc returning NULL if the new size is zero.  The xfsprogs
wrapper instead aborts, so we need to make it follow the kernel
behavior.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/kmem.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index 42d813088d6a..c264be018bdc 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -98,6 +98,16 @@ kmem_zalloc(size_t size, int flags)
 void *
 krealloc(void *ptr, size_t new_size, int flags)
 {
+	/*
+	 * If @new_size is zero, Linux krealloc will free the memory and return
+	 * NULL, so force that behavior here.  The return value of realloc with
+	 * a zero size is implementation dependent, so we cannot use that.
+	 */
+	if (!new_size) {
+		free(ptr);
+		return NULL;
+	}
+
 	ptr = realloc(ptr, new_size);
 	if (ptr == NULL) {
 		fprintf(stderr, _("%s: realloc failed (%d bytes): %s\n"),
