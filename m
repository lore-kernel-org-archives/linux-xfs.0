Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EC9C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZGuNRVZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB420C433C7;
	Sun, 31 Dec 2023 22:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062280;
	bh=mVNEmLus2Ne6xo/nJuTou9mR3FFoUZmAPRpZvA3u5jY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZGuNRVZuo/guDZuGDgaM/IY8BKhAw43mvRelzYlp0oW1BTXuACN6B7G0T8z9qMBB3
	 N5az6wMNXoSs3WGzZuLGnDSbSJVb0+/F2r2lGNOaKB67zN8Jrfit2Qaipx9cgT6iVI
	 spg/aWBWs+qDZ+KBaBTDYsVpA6JwdpZ4bc60H2GpjSyx/5fzqodqTXgvUskT9uxt62
	 gQDZnYp8fJhjiqur1GgcYbQgRt2wHpJqO+emHQfLLZsULBK7ndVzR+IsTHjOTltU01
	 VaVMjCRAHqYbSevzqNjaOqJITprYMDGmYzyiuszVD09BTQVZMvn56HYN79uECXzIvP
	 mVCKB/VREd4Rg==
Date: Sun, 31 Dec 2023 14:38:00 -0800
Subject: [PATCH 6/7] xfs_scrub: require primary superblock repairs to complete
 before proceeding
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404998726.1797322.10938356067740131087.stgit@frogsfrogsfrogs>
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

Phase 2 of the xfs_scrub program calls the kernel to check the primary
superblock before scanning the rest of the filesystem.  Though doing so
is a no-op now (since the primary super must pass all checks as a
prerequisite for mounting), the goal of this code is to enable future
kernel code to intercept an xfs_scrub run before it actually does
anything.  If this some day involves fixing the primary superblock, it
seems reasonable to require that /all/ repairs complete successfully
before moving on to the rest of the filesystem.

Unfortunately, that's not what xfs_scrub does now -- primary super
repairs that fail are theoretically deferred to phase 4!  So make this
mandatory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 80c77b2876f..2d49c604eae 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -174,7 +174,8 @@ phase2_func(
 	ret = scrub_primary_super(ctx, &alist);
 	if (ret)
 		goto out_wq;
-	ret = action_list_process_or_defer(ctx, 0, &alist);
+	ret = action_list_process(ctx, -1, &alist,
+			XRM_FINAL_WARNING | XRM_NOPROGRESS);
 	if (ret)
 		goto out_wq;
 

