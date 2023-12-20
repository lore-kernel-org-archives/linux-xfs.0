Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDA34776B
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eA0WgQQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B793C433C7;
	Wed, 20 Dec 2023 17:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092536;
	bh=9HE6ULMmYz25icKSnr8wET4b0nqzbRpWYcUbOGYim9U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eA0WgQQjtdwBDG4usK27lJAXFC3XT6zYI6zSdcMHG4SAc4HEz2vvvGDDfQWBJQpY7
	 CWxWELlGFfak5L3oNhfnUElFXSCgzbXlTYVgZC0tm7eO5q5LODguvqPIcGYALpTR6k
	 g0qN8pvPxkE6cMfjVHrYndg7HF9PIEHrpxubtQTt2Rk6vhJRs6ABoaRVd7C0ybskRn
	 nCGRP5q0yH4xuMo5kIQDpbgC2mkzPKvRrH5f1KCe+nrJSquHenJxB3khEz5RqxWXFo
	 8anwlj7RGRa+JSOJQ6xUNf982VR7XD2OKWeiidU2ACHJQ3Gl9MCjLgftq1cjIUj1Fp
	 hy+LsNWjgAiCQ==
Date: Wed, 20 Dec 2023 09:15:35 -0800
Subject: [PATCH 1/3] xfs_scrub: handle spurious wakeups in scan_fs_tree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170309219456.1608293.8633973779348446973.stgit@frogsfrogsfrogs>
In-Reply-To: <170309219443.1608293.8210327879201043663.stgit@frogsfrogsfrogs>
References: <170309219443.1608293.8210327879201043663.stgit@frogsfrogsfrogs>
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

Coverity reminded me that the pthread_cond_wait can wake up and return
without the predicate variable (sft.nr_dirs > 0) actually changing.
Therefore, one has to retest the condition after each wakeup.

Coverity-id: 1554280
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index 577eb6dc..3c1825a7 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -263,7 +263,7 @@ scan_fs_tree(
 	 * about to tear everything down.
 	 */
 	pthread_mutex_lock(&sft.lock);
-	if (sft.nr_dirs)
+	while (sft.nr_dirs > 0)
 		pthread_cond_wait(&sft.wakeup, &sft.lock);
 	assert(sft.nr_dirs == 0);
 	pthread_mutex_unlock(&sft.lock);

