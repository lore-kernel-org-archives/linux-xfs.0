Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3D879CC
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882094; cv=none; b=WItpp27TmMt+TtvKUvwLiCWSViRqIY2TuXzyRcHknxVEsVPVR6w0gooRsVBkt5K/r+5VFcnEEH5XZqzf7ZOdz01nB/X6pfuW/iX8abPH+xVLGZ55rRIDQ5khti3eZcxrqZflWH++jKFptzAtZuhpxqalRUNdvLnYy5MusqZsdV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882094; c=relaxed/simple;
	bh=h8ZknGA35SG77MkKDlgnS5XBTHsnmWttLMnpEx5Xiq0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+4/+IjBNvmCrlf3Znmv+8UK33211AIIdPD/ZBcme1m+5KekhW4m+iW5OOQdgGuEjwROtsGjxgyn8ymWNDr8O4btiofUmKyV1fFseGaLU/i5Yn4xoQqB6kpzLVxwHDMqWTKIxtJ9YLypRHSP9ardMzXVVzUqlq5pLwA3Biwr9k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b1+a1jag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b1+a1jag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E9BC116B1;
	Tue,  2 Jul 2024 01:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882094;
	bh=h8ZknGA35SG77MkKDlgnS5XBTHsnmWttLMnpEx5Xiq0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b1+a1jagoJ0Uro82Q4lrcKqmlh7UBUophq3mvhRZyAzBd7tGYkQrlyMTT2wQBHGz/
	 OYzCJ6L9/MhA+tsBpZH7Yk9H27mCBw/TDQ3MYUFYSLx6jCSV9BQM8YTkWrB3T+pnUF
	 au8cWc8FDMpXUiM3STiSBhzHrkZ9bNXEGuwd/DFWH4w8pSnOCjOn4avDFMLTyZfSx/
	 k2vqzbaOSIETYZh1xlsNlJOVRsRSSfKE8a4DOJN0xSCAVz0w/jpYItyMyYnQtlPkJR
	 MAxOEbDguEnZbes3CrhgbYcJJ++AoqSyAlOW6F8Sv5yvMu549nxPhAK+mM26ykxX4I
	 zJNiCHHbAO6rg==
Date: Mon, 01 Jul 2024 18:01:33 -0700
Subject: [PATCH 3/8] xfs_scrub: collapse trim_filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118175.2007602.6970743462017002792.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
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

Collapse this two-line helper into the main function since it's trivial.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 07726b5b8691..e577260a93dd 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -21,15 +21,6 @@
 
 /* Phase 8: Trim filesystem. */
 
-/* Trim the unused areas of the filesystem if the caller asked us to. */
-static void
-trim_filesystem(
-	struct scrub_ctx	*ctx)
-{
-	fstrim(ctx);
-	progress_add(1);
-}
-
 /* Trim the filesystem, if desired. */
 int
 phase8_func(
@@ -47,7 +38,8 @@ phase8_func(
 		return 0;
 
 maybe_trim:
-	trim_filesystem(ctx);
+	fstrim(ctx);
+	progress_add(1);
 	return 0;
 }
 

