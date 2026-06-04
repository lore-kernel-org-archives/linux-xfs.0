Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134153D47B1
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553310; cv=none; b=t4VS0+rXO9v1XGQyvZJwBh+0bhJlYoFK66F3e6UvUg7rIX7VcP/e/UaogfAaQyxIPWDRUwHGUN/5+l8xfxmd2KZfuCT2Wz6wZqhVucN39d+ScrHGuookiJOLcx7V3ALKyIq0BYq5EitSXbZxSjBDU6QxKReknexvOJ9TSwwkrG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553310; c=relaxed/simple;
	bh=58YK8kXYbJ/tkGthi4bNVall0MDpgdgYDZB1KgPeH7w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dATyFlZsqAZcUaYMfQ9yhoji+091Sc71vVaqDG5yZslW1npY6o5oKdihNBEmsRA/G+3MtVZdMgMzbGLN7dDChBpLIlQxw6lMqGhnsq/VY8BSlqbTe2o7u30RLM8HHUHfYKkoqmEdsXS/9OdLqvBhs3TfWnu4cNLKFi+HwvKfFQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMlzc5Fh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMlzc5Fh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DEE551F00893;
	Thu,  4 Jun 2026 06:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553310;
	bh=V8amVcWw4aiiqqCvEzJxf3tH59clNFhzaJ/20Di7Bf0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YMlzc5FhkQ19mwSZUEV4brgnRATK65LePdH9aUQ57FLDTcL8853vQdjM1CYvqjRJc
	 UYcFM2RJBfBamxB1ivE9BAiTvYW7sQTiMD2f0PUJQ9n7vzRyxyhmvEQhmye4L3VvK+
	 d2scNUKjfJDqOSnI1Prrq7hMlsWepqJM6qT6FEiy0pXWSsaLE2XH/a6Ns9Gycc9y/P
	 x+O9qm5qi0hp59mIvQFmzLIUDHX48rQ761NaE2AWolOL5udoo1sMOi9oBRgLaxMkAO
	 J87WI7mVMFLOWQ4SVsFrIeiNZgt62sv5eLVrMQu2GTse/zYIgkuBY0tljWGe1Iac3t
	 /6Us2pPTr3y7w==
Date: Wed, 03 Jun 2026 23:08:29 -0700
Subject: [PATCH 16/21] xfs_scrub: don't continue with phase1 if autofsck=none
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303402.2608728.10846299600136218647.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If xfs_scrub was started with -o autofsck and the filesystem's autofsck
property says not to run xfs_scrub, we should exit phase 1 early so that
the rest of the validation checks don't need to run.  Codex points out
that the current code can fail pointlessly in this manner.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 9451b5ee0d0d2d ("xfs_scrub: allow sysadmin to control background scrubs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase1.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index f4d50d016c2ebd..9e60a4d948f2db 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -342,6 +342,8 @@ _("Not an XFS filesystem."));
 	 */
 	if (ctx->mode == SCRUB_MODE_NONE)
 		mode_from_autofsck(ctx);
+	if (ctx->mode == SCRUB_MODE_NONE)
+		return 0;
 
 	/* Do we have kernel-assisted metadata scrubbing? */
 	if (!can_scrub_fs_metadata(ctx) || !can_scrub_inode(ctx) ||

