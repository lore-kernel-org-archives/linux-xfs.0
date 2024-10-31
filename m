Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E9A19CC1D
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417029; cv=none; b=toPEHA86YiJkUL/xMar65m0MTVPWmqLPXmgGrUDmhQodXfjmhMzZEe2rYwvx08m+NrSNzvwe5G0lVZh5Iq8PsMsbwRqsAm1VJmWBR9OOHjh7uGKVOpMOFH8XMcvHcTLWN2WbbdKVt186M2ionfgWFy4sVpW+t050LmO+8MoZtgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417029; c=relaxed/simple;
	bh=idrqojhoP60nDOAyoYJpaUDyEzoQaF0oO5p8QFUOKeI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K7KEfa5ZeV02kZ33QYK641YeMiOUwSM6Yw6i1DiON5qbIKXAVy1pIGFd1r34nVMXLAOkgi1eOfcf2uqEzlf48DDZ8DjY3e7K56qgZ62EkT2obw6YMbzT+SRcpNsupxiBr2n03gNr5X1tdZcq9xxifXO+i6usvfcZwk/XPPpMNxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLujU/hT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLujU/hT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A8CC4CEC3;
	Thu, 31 Oct 2024 23:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730417028;
	bh=idrqojhoP60nDOAyoYJpaUDyEzoQaF0oO5p8QFUOKeI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PLujU/hT3KdWOiKdrAlbF9/1xjS0mR8EtSuYU+7wS5Zsvlp8zIdp0cUTk2jPAJnKg
	 2oyTYT1Ooerob3H7XAYtFAaqEuWVGQcJlfl/agXWXeYYcyatyOc50N8j1yE118x/HC
	 Pl4cM06KsJcm/lyeA6e/xtrHsD+TaypazQ6hoNagCW30McP2unb58YlH9ai0o63+7T
	 zD3sucRstM/Xoj/TZrcv2tjcUAMOzzCnc8hgjEEm1wqB0+SX5QstzkNwB9JJRIpBrG
	 xgyF4acvpyv/1aYMqDRFOkxsAOLd5I1IpE0oVb8lYBubJJ1qJWqunbltw66SFuK1jL
	 8ufwpCfCQHHow==
Date: Thu, 31 Oct 2024 16:23:48 -0700
Subject: [PATCH 1/6] xfs_repair: checking rt free space metadata must happen
 during phase 4
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173041568118.964620.7418836022913791251.stgit@frogsfrogsfrogs>
In-Reply-To: <173041568097.964620.17809679042644398581.stgit@frogsfrogsfrogs>
References: <173041568097.964620.17809679042644398581.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Back in the really old days, xfs_repair would generate the new free
space information for the realtime section during phase 5, and write the
contents to the rtbitmap and summary files during phase 6.  This was ok
because the incore information isn't used until phase 6.

Then I changed the behavior to check the generated information against
what was on disk and complain about the discrepancies.  Unfortunately,
there was a subtle flaw here -- for a non -n run, we'll have regenerated
the AG metadata before we actually check the rt free space information.
If the AG btree regeneration should clobber one of the old rtbitmap or
summary blocks, this will be reported as a corruption even though
nothing's wrong.

Move check_rtmetadata to the end of phase 4 so that this doesn't happen.

Cc: <linux-xfs@vger.kernel.org> # v5.19.0
Fixes: f2e388616d7491 ("xfs_repair: check free rt extent count")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase4.c     |    7 +++++++
 repair/phase5.c     |    6 ------
 repair/xfs_repair.c |    3 ---
 3 files changed, 7 insertions(+), 9 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index 5e5d8c3c7d9b96..071f20ed736e4b 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -401,4 +401,11 @@ phase4(xfs_mount_t *mp)
 	 */
 	quotino_check(mp);
 	quota_sb_check(mp);
+
+	/* Check the rt metadata before we rebuild */
+	if (mp->m_sb.sb_rblocks)  {
+		do_log(
+		_("        - generate realtime summary info and bitmap...\n"));
+		check_rtmetadata(mp);
+	}
 }
diff --git a/repair/phase5.c b/repair/phase5.c
index d18ec095b0524b..9207da7172c05b 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -694,12 +694,6 @@ phase5(xfs_mount_t *mp)
 	free(sb_ifree_ag);
 	free(sb_fdblocks_ag);
 
-	if (mp->m_sb.sb_rblocks)  {
-		do_log(
-		_("        - generate realtime summary info and bitmap...\n"));
-		check_rtmetadata(mp);
-	}
-
 	do_log(_("        - reset superblock...\n"));
 
 	/*
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index e325d61f10367e..3ade85bbcbb7fd 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1318,9 +1318,6 @@ main(int argc, char **argv)
 
 	if (no_modify) {
 		printf(_("No modify flag set, skipping phase 5\n"));
-
-		if (mp->m_sb.sb_rblocks > 0)
-			check_rtmetadata(mp);
 	} else {
 		phase5(mp);
 	}

