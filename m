Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7EB49B1FF;
	Mon, 12 Oct 2026 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818468; cv=none; b=gfsl89ft5owvMgfhaPXlwkUNJXGFk+PogMmo6a99d6/0Jc8ViNiBZ56NtxAJllVCDr0dtn4tUbiHVxVHtQmpfmCNepFBja/0i6GIbtgMEaqm6i00AFfkS2pgO6RTbgaEPCfnXVfmqdOmuQvVWTn5O/3pxB9SwgBlwBut3Mrc0t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818468; c=relaxed/simple;
	bh=sHujBVnl8LruPkMduLImqHfZXqz+ciTJpYwMZFBrnLo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JwkJiyO4dhtqw7SGAMkYk7Qb1dzxcGKDFUxF5bx7LMte1vGLQ7cSYookVbrnn8G58y9qr7FnvMAjwHAFWllHQ7O9wys4Sp0IOjSU9piIUDOkqrLq/Zae8Xt5q6Wv3/F5+Cy0DCvhEIF+iN7KUdltAV90xWaRhHJCroAhyNaZM04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+STmhY9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+STmhY9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 72D741F0089B;
	Mon, 12 Oct 2026 15:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818467;
	bh=XzALPZZFNI+jW+uLfo8a5c/+ldvofRhwFnAFkbeL8As=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=W+STmhY9EKP5nB3etSM4i3ZBHIbs3WA9TDK8XZB8su467O0UEaNQ7iezHz5cYlzQQ
	 wi/x8qU+7gua6Gt+sa4tzOgIyeHhFqTZ0F0s5NjTWe/ttvxMcCdhVnE/a61E1HHlGw
	 CCAsVXLy80fgBUdaczS+bBKZOnQgx1Q3sIVz0SSruMC2E1A6D7DP0og6ncaWXAQJy/
	 tIABHFk6gDHFS38beav0/s4jSEZ1pip7ZYLMYfDYtj23hX5wBUkbm4gPhLz0DE5ceW
	 Cp1k0x3mpnrmvzmavrEHKBmywBxhLoPCog9jrx90rthh+iTUsUWjKO8B16iJ6saJHp
	 dBoh1ne4Okr+A==
Date: Mon, 12 Oct 2026 08:21:07 -0700
Subject: [PATCH 03/13] xfs: abort directory tree repair whenever dl->aborted
 is set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179181839311.1417179.5916672636359547451.stgit@frogsfrogsfrogs>
In-Reply-To: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observed that if the live update hooks for the directory tree
repair code ever fail, they'll set dl->aborted, but then the main repair
code path won't check it to exit early.  This can cause incorrect
repairs, so let's check for hook errors and abort the repair.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dirtree_repair.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index 717ebbe4f91916..1de4d9f1b61657 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -575,6 +575,8 @@ xrep_dirtree_delete_path(
 
 	if (!error && dl->stale)
 		error = -ESTALE;
+	if (!error && dl->aborted)
+		error = -EIO;
 	return error;
 }
 
@@ -720,6 +722,11 @@ xrep_dirtree_adopt(
 		error = -ESTALE;
 		goto out_trans;
 	}
+	if (dl->aborted) {
+		mutex_unlock(&dl->lock);
+		error = -EIO;
+		goto out_trans;
+	}
 	error = xrep_dirtree_create_adoption_path(dl);
 	mutex_unlock(&dl->lock);
 	if (error)
@@ -780,6 +787,8 @@ xrep_dirtree_move_to_orphanage(
 
 	if (!error && dl->stale)
 		error = -ESTALE;
+	if (!error && dl->aborted)
+		error = -EIO;
 	return error;
 }
 

