Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B117F9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fLQgbpPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB08C433C8;
	Mon,  1 Jan 2024 00:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068456;
	bh=tCWY6uiQzDZt8viT1RTGgwe+wpBRknJZBLx4jVMUZBA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fLQgbpPsxnD2c7YE1nglslRMK1rRhOHuTe9SNlIfK5KTPwwAfHAwW9aX1f6aMgtiV
	 lj6z3xRupH/fRAytRBFz5jD6+xjDjjoif/Ac/tioo1tdFnHwKVpZNg+fr9O1W+kd8c
	 kx27Nrqxt9ma8NsHiLhv/FhUaRSAbAg3yrs1mZnbVCvSfznhdPKXF3ZlHbR7/4JVRx
	 Ja+UaGY8Dkf7qV07enEEvXN59dbfFviljasLoMKHR1JJK7dd6/mu+kDDAStjMHvSIB
	 fD6p1N9G0rcgELbi1qKE/Sw+3Ma3GWU2Uqb3pok9zuJ5nNuYMlPJ2zYGlQHBPCU+m8
	 rMfvC8Dlx2hnQ==
Date: Sun, 31 Dec 2023 16:20:56 +9900
Subject: [PATCH 40/47] xfs_repair: always check realtime file mappings against
 incore info
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015846.1815505.10054977018632373762.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Curiously, the xfs_repair code that processes data fork mappings of
realtime files doesn't actually compare the mappings against the incore
state map during the !check_dups phase (aka phase 3).  As a result, we
lose the opportunity to clear damaged realtime data forks before we get
to crosslinked file checking in phase 4, which results in ondisk
metadata errors calling do_error, which aborts repair.

Split the process_rt_rec_state code into two functions: one to check the
mapping, and another to update the incore state.  The first one can be
called to help us decide if we're going to zap the fork, and the second
one updates the incore state if we decide to keep the fork.  We already
do this for regular data files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 80 insertions(+), 8 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index e08b23a9454..a6713a7bc6b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -219,7 +219,7 @@ _("data fork in rt ino %" PRIu64 " claims dup rt extent,"
 	return 0;
 }
 
-static int
+static void
 process_rt_rec_state(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
@@ -263,11 +263,78 @@ _("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d
 			set_rtbmap(ext, zap_metadata ? XR_E_METADATA :
 						       XR_E_INUSE);
 			break;
+		case XR_E_BAD_STATE:
+			do_error(
+_("bad state in rt extent map %" PRIu64 "\n"),
+				ext);
 		case XR_E_METADATA:
+		case XR_E_FS_MAP:
+		case XR_E_INO:
+		case XR_E_INUSE_FS:
+			break;
+		case XR_E_INUSE:
+		case XR_E_MULT:
+			set_rtbmap(ext, XR_E_MULT);
+			break;
+		case XR_E_FREE1:
+		default:
 			do_error(
+_("illegal state %d in rt extent %" PRIu64 "\n"),
+				state, ext);
+		}
+		b += mp->m_sb.sb_rextsize;
+	} while (b < irec->br_startblock + irec->br_blockcount);
+}
+
+/*
+ * Checks the realtime file's data mapping against in-core extent info, and
+ * complains if there are discrepancies.  Returns 0 if good, 1 if bad.
+ */
+static int
+check_rt_rec_state(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_bmbt_irec	*irec)
+{
+	xfs_fsblock_t		b = irec->br_startblock;
+	xfs_rtblock_t		ext;
+	int			state;
+
+	do {
+		ext = (xfs_rtblock_t)b / mp->m_sb.sb_rextsize;
+		state = get_rtbmap(ext);
+
+		if ((b % mp->m_sb.sb_rextsize) != 0) {
+			/*
+			 * We are midway through a partially written extent.
+			 * If we don't find the state that gets set in the
+			 * other clause of this loop body, then we have a
+			 * partially *mapped* rt extent and should complain.
+			 */
+			if (state != XR_E_INUSE && state != XR_E_FREE) {
+				do_warn(
+_("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d at rt block %"PRIu64"\n"),
+					ino, ext, state, b);
+				return 1;
+			}
+
+			b = roundup(b, mp->m_sb.sb_rextsize);
+			continue;
+		}
+
+		/*
+		 * This is the start of an rt extent.  Complain if there are
+		 * conflicting states.  We'll set the state elsewhere.
+		 */
+		switch (state)  {
+		case XR_E_FREE:
+		case XR_E_UNKNOWN:
+			break;
+		case XR_E_METADATA:
+			do_warn(
 _("data fork in rt inode %" PRIu64 " found metadata file block %" PRIu64 " in rt bmap\n"),
 				ino, ext);
-			break;
+			return 1;
 		case XR_E_BAD_STATE:
 			do_error(
 _("bad state in rt extent map %" PRIu64 "\n"),
@@ -275,12 +342,12 @@ _("bad state in rt extent map %" PRIu64 "\n"),
 		case XR_E_FS_MAP:
 		case XR_E_INO:
 		case XR_E_INUSE_FS:
-			do_error(
+			do_warn(
 _("data fork in rt inode %" PRIu64 " found rt metadata extent %" PRIu64 " in rt bmap\n"),
 				ino, ext);
+			return 1;
 		case XR_E_INUSE:
 		case XR_E_MULT:
-			set_rtbmap(ext, XR_E_MULT);
 			do_warn(
 _("data fork in rt inode %" PRIu64 " claims used rt extent %" PRIu64 "\n"),
 				ino, b);
@@ -341,13 +408,18 @@ _("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
 		return 1;
 	}
 
-	if (check_dups)
-		bad = process_rt_rec_dups(mp, ino, irec);
-	else
-		bad = process_rt_rec_state(mp, ino, zap_metadata, irec);
+	bad = check_rt_rec_state(mp, ino, irec);
 	if (bad)
 		return bad;
 
+	if (check_dups) {
+		bad = process_rt_rec_dups(mp, ino, irec);
+		if (bad)
+			return bad;
+	} else {
+		process_rt_rec_state(mp, ino, zap_metadata, irec);
+	}
+
 	/*
 	 * bump up the block counter
 	 */

