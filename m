Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E955C2417C2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882498; cv=none; b=oJA83QuYDNQ3kDnF+I3JmFe6wemmBvri0HTBz4YWjbIIiec54j8zHFKyGWNdT7Zzj7s6OCbok/JFd83nimzSmnn/i+dzXlJnImx/zAZ26+tnJPSurT0ictsPGfr2cnlD9IovwPVdMiJtuGsyfJKogRlVWPmbqF6ZRUu3nyPdq+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882498; c=relaxed/simple;
	bh=T4IRVvUEz1rZ0YAIgzMnpO03ZTyzG8EqjiuTsbgobbI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=thDwQOaZiyKR5Xd65ItBzudKbKf+lsf+ptCLQrFe4hOT0RgrN3ZjAdtHQRridNehmxmoZhfDARGJMtf/5SfyQ3QwrRwlhUmtMIvdUp4l1OVn3L+2/3KNByVcPjUoUDyGxHFxVlfnCyuzEk3FyRjBtD739cyv9Ao8w8WPHDX/yV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcYP03iB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcYP03iB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6147AC4CEDF;
	Thu,  6 Feb 2025 22:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882497;
	bh=T4IRVvUEz1rZ0YAIgzMnpO03ZTyzG8EqjiuTsbgobbI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jcYP03iBRvY0iy4SNkjMk3Bt4W0LUutag+GF3KQi0kksRSJKztd77sB4V6SjvxIx0
	 +K/hIAc40sUWwnMjKVeHcbH6QBAHIdDCZeP8A32lPGj1rnjN7xvt0JywvXQZls3ICV
	 3k1YLFxo0wSv8qB4RnTXRkfobppGcXhdqrl3MTcsPDcNjgE8ZdV73Epwwqldt+m8EL
	 F9Scrw3nxQdKUq2cf98G/1rMayJHNKpW/5/BvQeizvJrBUU9VAYgFxUuA1gc20OQCu
	 6+zhz34EoGPnmG6zURbkz55v7jV+WifHHl/x6xs9Hrlknnpm1jnrXpdqoKpuBjhizy
	 mGT6CD4xGgB1g==
Date: Thu, 06 Feb 2025 14:54:56 -0800
Subject: [PATCH 20/27] xfs_repair: always check realtime file mappings against
 incore info
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088402.2741033.16711596957542694304.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dinode.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 84 insertions(+), 11 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 58691b196bc4cb..3995584a364771 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -253,7 +253,7 @@ _("data fork in rt ino %" PRIu64 " claims dup rt extent,"
 	return 0;
 }
 
-static int
+static void
 process_rt_rec_state(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
@@ -297,11 +297,78 @@ _("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d
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
@@ -309,12 +376,12 @@ _("bad state in rt extent map %" PRIu64 "\n"),
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
@@ -376,20 +443,26 @@ _("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
 	}
 
 	pthread_mutex_lock(&rt_lock);
-	if (check_dups)
-		bad = process_rt_rec_dups(mp, ino, irec);
-	else
-		bad = process_rt_rec_state(mp, ino, zap_metadata, irec);
-	pthread_mutex_unlock(&rt_lock);
+	bad = check_rt_rec_state(mp, ino, irec);
 	if (bad)
-		return bad;
+		goto out_unlock;
+
+	if (check_dups) {
+		bad = process_rt_rec_dups(mp, ino, irec);
+		if (bad)
+			goto out_unlock;
+	} else {
+		process_rt_rec_state(mp, ino, zap_metadata, irec);
+	}
 
 	/*
 	 * bump up the block counter
 	 */
 	*tot += irec->br_blockcount;
 
-	return 0;
+out_unlock:
+	pthread_mutex_unlock(&rt_lock);
+	return bad;
 }
 
 /*

