Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1781368
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UchAHKFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E776C433C7;
	Mon,  1 Jan 2024 00:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069317;
	bh=eI1X+qniVSLExGvXANux1ABoMbjRILFc8Y01ygbsodw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UchAHKFU6WVHELMIVCrwL5ICq6vSSwwjUWOYBFQWpFjLaolBHqwYSaKg5uThFK37w
	 tGEwGyI1axhUF806ExX8gSFmayRaCGlhZSJienVRiB3yRO0maPPaHlCp/u5/rBBooN
	 nDV1IzAMPvcjSEUliTRa/yUiMF/Ce82vh3KTDFzuV2UCHSe/MKvZWATSBA9a8nftnt
	 DQn+Hkax74HhpGKxhifaM+JRGLLhq4alHDPrYxTY6q6qVEM8DY4F4R/D5hvM22TXTQ
	 wtsXXcGK4FhEf8ru6Ok3IYdR4ITewiB9TKqyNbZzEP+xrJE0kMIiW16Y1wBm//069l
	 h7lG9AUudBljA==
Date: Sun, 31 Dec 2023 16:35:16 +9900
Subject: [PATCH 35/42] xfs_repair: reject unwritten shared extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017593.1817107.2563916821111792576.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

We don't allow sharing of unwritten extents, which means that repair
should reject an unwritten extent if someone else has already claimed
the space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index ad4263f9aa8..f0c0ba4da4e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -277,7 +277,8 @@ _("bad state in rt extent map %" PRIu64 "\n"),
 			break;
 		case XR_E_INUSE:
 		case XR_E_MULT:
-			if (xfs_has_rtreflink(mp))
+			if (xfs_has_rtreflink(mp) &&
+			    irec->br_state == XFS_EXT_NORM)
 				break;
 			set_rtbmap(ext, XR_E_MULT);
 			break;
@@ -353,8 +354,14 @@ _("data fork in rt inode %" PRIu64 " found rt metadata extent %" PRIu64 " in rt
 			return 1;
 		case XR_E_INUSE:
 		case XR_E_MULT:
-			if (xfs_has_rtreflink(mp))
-				break;
+			if (xfs_has_rtreflink(mp)) {
+				if (irec->br_state == XFS_EXT_NORM)
+					break;
+				do_warn(
+_("data fork in rt inode %" PRIu64 " claims shared unwritten rt extent %" PRIu64 "\n"),
+					ino, b);
+				return 1;
+			}
 			do_warn(
 _("data fork in rt inode %" PRIu64 " claims used rt extent %" PRIu64 "\n"),
 				ino, b);
@@ -671,8 +678,14 @@ _("%s fork in inode %" PRIu64 " claims metadata block %" PRIu64 "\n"),
 			case XR_E_INUSE:
 			case XR_E_MULT:
 				if (type == XR_INO_DATA &&
-				    xfs_has_reflink(mp))
-					break;
+				    xfs_has_reflink(mp)) {
+					if (irec.br_state == XFS_EXT_NORM)
+						break;
+					do_warn(
+_("%s fork in %s inode %" PRIu64 " claims shared unwritten block %" PRIu64 "\n"),
+						forkname, ftype, ino, b);
+					goto done;
+				}
 				do_warn(
 _("%s fork in %s inode %" PRIu64 " claims used block %" PRIu64 "\n"),
 					forkname, ftype, ino, b);

