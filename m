Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500EDC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4uVeRpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24963C433C7;
	Sun, 31 Dec 2023 23:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064751;
	bh=qIpNOiY5JJAWnd0KnHurt3zrgz3OjRPZmNvKbcAIho0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b4uVeRpczrcrWXxzgJQw6nzSig9zf8QtV8Gk0/BovVfx6s/TFnFTsC/MM50wMFbEo
	 rydmTW+Vlb50VEtgyk4LdHit6twT0ZKZVg3k2ncz/GQkaBF1hfwkE/jgPa+7W50L7B
	 3MRGn4nT9d8sNKFXgfsuameE5GOzWuEQCf/sZelLagz3XhDX5aDdewx7+pygi7TfC+
	 tTrSMQqPHmztSeE301cIwR0IaAKCZV+eF81bCFzyRJAnhu2USmowRft3jS9hc+FbYZ
	 eNRKv1lZr+U8gk9WJnG9u3oCAr9qo/ilFL7WkvuAH8XK874XEy76qczDA67TvXLimt
	 8Us7uCxu3bDCA==
Date: Sun, 31 Dec 2023 15:19:10 -0800
Subject: [PATCH 4/6] xfs_scrub: fix erroring out of check_inode_names
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007486.1805996.10460613956850458046.stgit@frogsfrogsfrogs>
In-Reply-To: <170405007429.1805996.15935827855068032438.stgit@frogsfrogsfrogs>
References: <170405007429.1805996.15935827855068032438.stgit@frogsfrogsfrogs>
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

The early exit logic in this function is a bit suboptimal -- we don't
need to close the @fd if we haven't even opened it, and since all errors
are fatal, we don't need to bump the progress counter.  The logic in
this function is about to get more involved due to the addition of the
directory tree structure checker, so clean up these warts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase5.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 0df8c46e9f5..b3719627755 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -279,7 +279,7 @@ check_inode_names(
 	if (bstat->bs_xflags & FS_XFLAG_HASATTR) {
 		error = check_xattr_names(ctx, &dsc, handle, bstat);
 		if (error)
-			goto out;
+			goto err;
 	}
 
 	/*
@@ -295,16 +295,16 @@ check_inode_names(
 			if (error == ESTALE)
 				return ESTALE;
 			str_errno(ctx, descr_render(&dsc));
-			goto out;
+			goto err;
 		}
 
 		error = check_dirent_names(ctx, &dsc, &fd, bstat);
 		if (error)
-			goto out;
+			goto err_fd;
 	}
 
-out:
 	progress_add(1);
+err_fd:
 	if (fd >= 0) {
 		err2 = close(fd);
 		if (err2)
@@ -312,7 +312,7 @@ check_inode_names(
 		if (!error && err2)
 			error = err2;
 	}
-
+err:
 	if (error)
 		*aborted = true;
 	if (!error && *aborted)

