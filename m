Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E559C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RyO/wh0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F661C433C7;
	Sun, 31 Dec 2023 22:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062953;
	bh=wRGLf2dxL4EG0pyxBCmep/T8ot6o68RlT5IIMRrX2VI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RyO/wh0MWpgP0ehdiY0Uryzkmq0hZldx1UOkshhjUX4u1zLkRJzVsBKCH8ZPhlo0y
	 caQwfru73DJVaeduiGQEbrn6JpEwkz5N0/hBlxFNxL6s9PLFEGqESzy2TXWvofi2J4
	 ZAMmUcYtdcnLi0i0sQ+5d3vrb/5BZGuD6vYYGNcml6iNXcWUC9u7MwwjqIKAY5UMcV
	 JV3Umu32e1HxRN2tb/T4UmpZBGcNAUN9K75GmP3Pxck1UMJvduCbG0lfXUvP377MpM
	 BkSze0Wh2wkjVIrz2HhGW360u6o6RXxxdPnrxgIo+G27NlP+BuMfMnc2AOODv/+UHB
	 jH3inQVRs4eoQ==
Date: Sun, 31 Dec 2023 14:49:12 -0800
Subject: [PATCH 3/8] xfs_scrub: collapse trim_filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001089.1798752.7539616554424103381.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
References: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
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
index 07726b5b869..e577260a93d 100644
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
 

