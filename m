Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BACBEEB3;
	Tue, 25 Aug 2026 05:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636112; cv=none; b=JsOOMakfXxVgEsBGUV4I4sxcW8h2wHDtXHFsnnBRg5u1uSU39cw9b5pwrtP6W2S78f72+MLw8a851jqtJVpMxXrOJM/w+XcQwYjOnZifpzQA1Ze7DNEYVuU5ZkezV+xim8KmGzz7F8WjhXiE+AZrfX/hFzZmMd6OmuLYtKLdVLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636112; c=relaxed/simple;
	bh=9uph0AMssO7SaZ46k89LJhkIn0fXPoVzm9Bsei/VEfw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dkaoB2DU6/RIfcDmRpwY2bRIK0n+XVeorA00VBmjnJoGKYrDIsEgepKFoFQ2cLKK+0cEfSA/NAuCoDM2BsrfhcHvXrKPPlksJdEeKt7DDS706/ir2VNC3VjtnE/KI2E42kQKN244ymUYEjff96lqunoR64rI2AB/VCgYcyHzZ4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gr7U2yns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gr7U2yns"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 03D1A1F00A3A;
	Tue, 25 Aug 2026 05:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636111;
	bh=RH8ckPcvjlkONTwrWJjTYdWxzwSCQCPxPmeCdkZAapM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Gr7U2ynszDqPSxvFewN+jsb9xNeOrIMy9n14c0DBhLiGdsZNsjECvhM0HbUVE6Glq
	 iE8CjY0OnjtWhOdeD7G4zBM0gLkB3NYAWdWcKBzN6ZL5ZzUdaYIktNUooCQdIrFu9M
	 F643ZToxcmYEzQH71rdW6pwYAIx0q8TM6eJB2wX0yLs/DgAMhVEVxe3wUscSJz6OWO
	 lvwsN7c61JG2t+cSG+6x1i0W0QHo0Sw9zfC9o+IQ1/iVFsqZULGhPqwvktizWBEfzO
	 IT8OAdwOhpFytbGahbQXoqStk+u6CnvKDsvRlRmNnZp6nptvp9IyUiu9D5l4YDzQ+K
	 kalg3bI4CMeQg==
Date: Mon, 24 Aug 2026 22:35:10 -0700
Subject: [PATCH 3/6] xfs: log the tempip after we convert it to extents format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178760940742.944084.4404098260047036388.stgit@frogsfrogsfrogs>
In-Reply-To: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that xrep_symlink_swap_prep converts sc->tempip to an
extents format file prior to the atomic swap, but incorrectly logs
sc->ip immediately afterwards.  Fix that, and the other problem that
we're supposed to tell xfs_trans_log_inode what to log and don't.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 2651923d8d8db0 ("xfs: online repair of symbolic links")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/symlink_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index 91c86ea0e0f155..18196136423336 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -291,7 +291,7 @@ xrep_symlink_swap_prep(
 		if (error)
 			return error;
 
-		xfs_trans_log_inode(sc->tp, sc->ip, 0);
+		xfs_trans_log_inode(sc->tp, sc->tempip, logflags);
 
 		error = xfs_defer_finish(&sc->tp);
 		if (error)

