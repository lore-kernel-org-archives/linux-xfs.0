Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D821FC129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MTVj0SeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522D9C433C7;
	Sun, 31 Dec 2023 22:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062202;
	bh=rc19ZligsqDIJgYpNJdRPmEId6g1f2+XiUi89y8clNc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MTVj0SeGo6dkWRvt2lC5Eez7B6LLmXGVh+fgD/SCqKBJCbahHYVCfKBVYOQGeQcfF
	 XgOCCcBvLwluyXxuYAUr74gIFvCVg6bhafH7LtLs3Dd7iWO2YFGUb5jvn4Y+8IvXZZ
	 n2n4IjyCDCPovgwE63AeVrHIYUmm657vZpygXEYSNvvfce+D+cEiDea/KMJn9I1mlR
	 7/wU4iU1wQpiz2SAt2w0pIa7XokPSZiv6wN9xDEqqDR/mp1PNJOxdUGIthevo3dbZY
	 CKWU6PmhH185j2mTgbAhiE5pOq2xbXvEFjJDC5Br/8+6IILWK40GZi+M5If7fzXqJX
	 j0UdYPNr1f6Tg==
Date: Sun, 31 Dec 2023 14:36:41 -0800
Subject: [PATCH 1/7] xfs_scrub: flush stdout after printing to it
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404998660.1797322.4141893748731169587.stgit@frogsfrogsfrogs>
In-Reply-To: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
References: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
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

Make sure we flush stdout after printf'ing to it, especially before we
start any operation that could take a while to complete.  Most of scrub
already does this, but we missed a couple of spots.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index a1b67544391..752180d646b 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -535,6 +535,7 @@ _("%s: repairs made: %llu.\n"),
 		fprintf(stdout,
 _("%s: optimizations made: %llu.\n"),
 				ctx->mntpoint, ctx->preens);
+	fflush(stdout);
 }
 
 static void
@@ -620,6 +621,7 @@ main(
 	int			error;
 
 	fprintf(stdout, "EXPERIMENTAL xfs_scrub program in use! Use at your own risk!\n");
+	fflush(stdout);
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");

