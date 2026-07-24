Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4DB19C54E;
	Fri, 24 Jul 2026 06:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874156; cv=none; b=R7Fw3MghfqBY/VuOfK+AstU38snJwNBz3+ULrAZB5gYFQqhMb0VMJMvQpDcKJ8B8d8zFe5/d4t3WaGWxMF3eAJqpS2w7DkmcsxrJ6q1KJuHnNW1/XQevgmcBkn5ItB2btQZzwEPUlhpVBb9gDK2NP7Xy9WLc0XVC7jBoVAGGg/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874156; c=relaxed/simple;
	bh=tGC5cRSIsyRHn8+jKqTN4F42dUJZdBC29bWy9x2+0iI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lWONiRoDteprgAw+8UCcG1siwA6NQB2HH0kREBzRolLLwJvAQQtUr1zNS3goAgb9LYd8wAMAVivAL3dEMvh6ahDXWy+5yabeNZiMfnEcAYA+zU4tztGp5bggOHDFMu/rKfFGjB88QClnRjgX5MObCrDaSm1i2djcExUxk7KtXlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XHQT3IyF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XHQT3IyF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9CA471F000E9;
	Fri, 24 Jul 2026 06:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784874154;
	bh=p1+wteF+c4ZopMU60oYBehXgn2h5PoFO83KfATfmHcE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=XHQT3IyFNZx6XhS0Zxz9KT6/z94cHbBh2rs1IRvdg6q9Jbjal02NjhzKG2Y+whRn5
	 grrc3KB48puW3FaN4rXvtCsqtFATEgdy8x0daF8DrKDc6hilogdRd5yoWPjZcrMHOu
	 eqypqiTQC7tMyjAHntZ076hMD70Iaq+n18f5+pzn79qrSN1EaXr8cGUNmUFfPzaMeT
	 CK2gEznKb3s3AzH7p5n67PTMqHHCiK6E/KKLhw5WCGwttx2g+jTv3X6TJWtI7k3S54
	 8T+tfbS6IWCsg0IuzgD6jSjx37d+jCG3e6i7vPtzIdGLJ8dDpgk+U+XZH7eXzLuc0g
	 0b//VKGzayhLw==
Date: Thu, 23 Jul 2026 23:22:34 -0700
Subject: [PATCH 6/6] xfs: avoid UAF on sc->tempip in xrep_tempfile_create
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178487405504.3442778.13576241949059106185.stgit@frogsfrogsfrogs>
In-Reply-To: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs>
References: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed a potential UAF if the tempfile creation code fails after
it set sc->tempip.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 84c14ee39dd388 ("xfs: create temporary files and directories for online repair")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/tempfile.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index e0c630f888cf6e..98820003b9298f 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -174,6 +174,7 @@ xrep_tempfile_create(
 		xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(sc->tempip);
 		xchk_irele(sc, sc->tempip);
+		sc->tempip = NULL;
 	}
 out_release_dquots:
 	xfs_qm_dqrele(udqp);

