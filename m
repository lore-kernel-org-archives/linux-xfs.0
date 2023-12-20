Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF6F47A41
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t+Hmeje1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4914EC433C7;
	Wed, 20 Dec 2023 17:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092411;
	bh=sJXEju8aigjR6ohOg151at344XBxte+Xo4yIzl/IIig=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t+Hmeje1LWjgPDBMtgPr4hDdSLgs7YzufCM+flvSD5XT0kkBwgmMlhXe80M0PtdHM
	 eDGYRDgc2necN0rdQFY859ZqJ3dZd1uekmFiuuBm9FVdb+jtY4i+sKcEpOuUHoWmD0
	 aDdXbiZBcmTwiX21wk24Y/bLQi2m6uOyuj28CgOHwsNkqQmjX15LExf1sQxFmhXQbK
	 PAwyqtNmVHbaGypyBM/LhY2jY1AuqNjWD8JIHfY7iUIVZZgJKezKWJNQmI38lqr9Iu
	 nuka39IALyN1zukOwPpgAFhVQKBvKeh3d0Qo1MgMbqLddAu5mzAJn7mwX8kUIIT32D
	 vxc9YZdQ/Rc7g==
Date: Wed, 20 Dec 2023 09:13:30 -0800
Subject: [PATCH 3/6] xfs_mdrestore: emit newlines for fatal errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <170309218756.1607943.10236507657991449697.stgit@frogsfrogsfrogs>
In-Reply-To: <170309218716.1607943.7868749567386210342.stgit@frogsfrogsfrogs>
References: <170309218716.1607943.7868749567386210342.stgit@frogsfrogsfrogs>
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

Spit out a newline after a fatal error message.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>
---
 mdrestore/xfs_mdrestore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 5dfc4234..3190e07e 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -275,10 +275,10 @@ read_header_v2(
 		fatal("error reading from metadump file\n");
 
 	if (h->v2.xmh_incompat_flags != 0)
-		fatal("Metadump header has unknown incompat flags set");
+		fatal("Metadump header has unknown incompat flags set\n");
 
 	if (h->v2.xmh_reserved != 0)
-		fatal("Metadump header's reserved field has a non-zero value");
+		fatal("Metadump header's reserved field has a non-zero value\n");
 
 	want_external_log = !!(be32_to_cpu(h->v2.xmh_incompat_flags) &
 			XFS_MD2_COMPAT_EXTERNALLOG);

