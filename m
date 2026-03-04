Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B77B3D6CC6
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 18:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772650497; cv=none; b=DFE8nqah9E2NEH2dAGvUwN+I/cXKzj/iWkFojh27tQVHZW5/sOaVeayxOhqBOIsRp1K8HOltCLgioJQOHMIvr1tU4oT26Znk/buIXUdfne1mtLSkeRWG8mu+Sc28pK6Ab1C0XMbOYL9JzMa1pNIfxix5bHrFun/SGk1VaCSXu5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772650497; c=relaxed/simple;
	bh=++gxd7dmejwKlKYABXQtQmn6FpevK61JrCDTHIDtLmo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D5V+PVhsFfW6f7WmUT56a4DLhfERUzJT/I+jkXi4QkQY6pzflz9/hwd7bcqgOtJWuJHMDRMJj9CQGkEO7dtpZgqY8gJDuaW1ljMkNtrtVzSS7+GwPp2n2pmKYIY8bGvoQp50nvSiYCrBhHajEaBTSdW6FSgSMeoaTakHSUsZ6H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LbpB4RiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LbpB4RiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00474C4CEF7;
	Wed,  4 Mar 2026 18:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772650496;
	bh=++gxd7dmejwKlKYABXQtQmn6FpevK61JrCDTHIDtLmo=;
	h=From:To:Cc:Subject:Date:From;
	b=LbpB4RiM+qzDaTWTeJXhUwqxa7HYp/cDZfXATONTnFpwk5Oz9PL80FXmiQ653iJeh
	 T5Uwb7LJ3l01G+jkIHEPTOX2Ds6ch+KXINpJRKYsCT7wJy11UfsDqUvZIS3neEUjtr
	 vNyT9ShymH9q1RPTNslD1mfzuqfe+s+nNf95I5vPaH8uGst3/n6HuL2bZz7WLg0GV6
	 X9Qyt11TKFPf4pB+d1jvnRWjvaPtfsz/EcmgLMARjCVG6un34JemRe2SSYQQDuIVnM
	 RexuPg0qFY5TJMh2CwFGLuT5OwDq+g3W7MYJ7nyGtF/zqAezYfAJUUOrewZW7aE9Vb
	 jndEy7b52ID4Q==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org
Subject: [PATCH] xfs: fix returned valued from xfs_defer_can_append
Date: Wed,  4 Mar 2026 19:54:27 +0100
Message-ID: <20260304185441.449664-1-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

xfs_defer_can_append returns a bool, it shouldn't be returning
a NULL.

Found by code inspection.

Fixes: 4dffb2cbb483 ("xfs: allow pausing of pending deferred work items")
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 472c261163ed..c6909716b041 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -809,7 +809,7 @@ xfs_defer_can_append(
 
 	/* Paused items cannot absorb more work */
 	if (dfp->dfp_flags & XFS_DEFER_PAUSED)
-		return NULL;
+		return false;
 
 	/* Already full? */
 	if (ops->max_items && dfp->dfp_count >= ops->max_items)
-- 
2.53.0

