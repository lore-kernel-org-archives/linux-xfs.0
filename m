Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743451368
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLlWPFk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC598C433C7;
	Mon,  1 Jan 2024 00:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069474;
	bh=ZNxv2CSYubuLNIYsl7/i9xfp9phA7MzfBm/s86nAaBU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JLlWPFk0AVKrVGk741b9cuHoOuTUWJa14ejj7oARVEvVCD/oBSyj22LgzGgVxpha2
	 FNUYkgdhdrEFUbgJZpFArerIOy//ykc4vdIAGccXHKCfGtlfjTaT+JkEh4f3DYR1D5
	 p5Igzw3Cx2r5/rYv0g/YNVlqYTTrvEBOYlHVQWWjmApgAxSI5OWeRi5rBwfPHwe1GJ
	 bcdJv+U1mSFJ2Ds3HDcaSTzjDLRqB/tV0oMxUiqcBJIc+srZhwJDiF35RHGbPw2beX
	 YxLSXp/aiSEIH5zjPQe/P79Gc/ru10OKREHRSaM7tgwCOWcAPc0FUw/jerD7SiFoO7
	 lDfjO9rzWxzAA==
Date: Sun, 31 Dec 2023 16:37:53 +9900
Subject: [PATCH 3/3] mkfs: enable reflink with realtime extent sizes > 1
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405018052.1818169.15071829414225680751.stgit@frogsfrogsfrogs>
In-Reply-To: <170405018010.1818169.15531409874864543325.stgit@frogsfrogsfrogs>
References: <170405018010.1818169.15531409874864543325.stgit@frogsfrogsfrogs>
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

Allow creation of filesystems with reflink enabled and realtime extent
size larger than 1 block.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c   |    7 -------
 mkfs/xfs_mkfs.c |   37 -------------------------------------
 2 files changed, 44 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 2e0d3b1ce94..0f626784902 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -300,13 +300,6 @@ rtmount_init(
 	if (mp->m_sb.sb_rblocks == 0)
 		return 0;
 
-	if (xfs_has_reflink(mp) && mp->m_sb.sb_rextsize > 1) {
-		fprintf(stderr,
-	_("%s: Reflink not compatible with realtime extent size > 1. Please try a newer xfsprogs.\n"),
-				progname);
-		return -1;
-	}
-
 	if (mp->m_rtdev_targp->bt_bdev == 0 && !xfs_is_debugger(mp)) {
 		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
 			progname);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 83ab4a6c316..f2961c4d134 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2467,24 +2467,6 @@ _("parent pointers not supported on v4 filesystems\n"));
 	}
 
 	if (cli->xi->rt.name) {
-		if (cli->rtextsize && cli->sb_feat.reflink) {
-			if (cli_opt_set(&mopts, M_REFLINK)) {
-				fprintf(stderr,
-_("reflink not supported on realtime devices with rt extent size specified\n"));
-				usage();
-			}
-			cli->sb_feat.reflink = false;
-		}
-		if (cli->blocksize < XFS_MIN_RTEXTSIZE && cli->sb_feat.reflink) {
-			if (cli_opt_set(&mopts, M_REFLINK)) {
-				fprintf(stderr,
-_("reflink not supported on realtime devices with blocksize %d < %d\n"),
-						cli->blocksize,
-						XFS_MIN_RTEXTSIZE);
-				usage();
-			}
-			cli->sb_feat.reflink = false;
-		}
 		if (!cli->sb_feat.rtgroups && cli->sb_feat.reflink) {
 			if (cli_opt_set(&mopts, M_REFLINK) &&
 			    cli_opt_set(&ropts, R_RTGROUPS)) {
@@ -2664,19 +2646,6 @@ validate_rtextsize(
 			usage();
 		}
 		cfg->rtextblocks = (xfs_extlen_t)(rtextbytes >> cfg->blocklog);
-	} else if (cli->sb_feat.reflink && cli->xi->rt.name) {
-		/*
-		 * reflink doesn't support rt extent size > 1FSB yet, so set
-		 * an extent size of 1FSB.  Make sure we still satisfy the
-		 * minimum rt extent size.
-		 */
-		if (cfg->blocksize < XFS_MIN_RTEXTSIZE) {
-			fprintf(stderr,
-		_("reflink not supported on rt volume with blocksize %d\n"),
-				cfg->blocksize);
-			usage();
-		}
-		cfg->rtextblocks = 1;
 	} else {
 		/*
 		 * If realtime extsize has not been specified by the user,
@@ -2708,12 +2677,6 @@ validate_rtextsize(
 		}
 	}
 	ASSERT(cfg->rtextblocks);
-
-	if (cli->sb_feat.reflink && cfg->rtblocks > 0 && cfg->rtextblocks > 1) {
-		fprintf(stderr,
-_("reflink not supported on realtime with extent sizes > 1\n"));
-		usage();
-	}
 }
 
 /* Validate the incoming extsize hint. */

