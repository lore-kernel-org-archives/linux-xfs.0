Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898F735675E;
	Mon, 28 Sep 2026 06:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576260; cv=none; b=mAxa8cf7FHLxLqANj1p1XnMA32DU9ruNvEIl/6uMll5OI7Zze0t6D8I4gC4Y/Y9RQsIB+DVgM+bDwltIh2CmDsi/ig7kSD25LTfc9OJO0bZhByvdPk38aYT4LsnOfGEyg8kJ8AD/rX7fsc9zWdPaYxiXSUWNIcGveswrCGlAx8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576260; c=relaxed/simple;
	bh=Yld0itxFuKEsxKURPO0IoJj3JyuYYVx3rCM9kMao1e8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ufrXGSHLh/qKe50QwfagvF2LmnyZyu+ByyUjE06ycboBQH5yuk7x4SBekq14LRup1fMb+bweoJ3YzXeJmVjiCg5PK8Q47cILgWVhWWwkaDsynLNQFSAmbCnKOL/vFhqqQ8uI82aYcQw/uMBBBWZXF+bWsVjeeu8UeTnOLjeCAEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DRK/nWP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DRK/nWP3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 207021F000FF;
	Mon, 28 Sep 2026 06:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576259;
	bh=JV8OaQD7zKWaGDmOvbebk7SXwLSWaKvu0M9r9MqBqso=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DRK/nWP3qCDwc4pd9lLOvsuOKy+uNw5XjyffgwG4PWwW8BpjpECgfwChee47Ok4bx
	 Bh8wEmDTbpBGnMJN5P/x+SLtn04U4XGP3M06NvJKA8JHfp3vdQy6PnX5HdYbvTFB48
	 6E2MyLb1LH7Rc/j9TuFQK+EP7/NRyMCeApjU5YjnaDKll80Iksx1RdY6NMrWWUgF22
	 5kshlZ5aJCPtyMke4gZSERpBvwDTPTJC34M7hNQbPMbSzNtFHrjOeDa3cSciA0xGsd
	 To64dGR3fUlYkoXS6RF8gHXDhioG8gdGVY939syPEHkDJQSS0vn1J2a3QUQrtBdTMv
	 taxBcEyu2uSHw==
Date: Sun, 27 Sep 2026 23:17:38 -0700
Subject: [PATCH 07/12] xfs: allow softlimit with no hardlimit in quota scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179057612745.479634.15770032430010226973.stgit@frogsfrogsfrogs>
In-Reply-To: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that the sysadmin can set a user's soft limit to a
nonzero value and the hard limit to zero, so those aren't corruptions.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: c2fc338c87a31f ("xfs: scrub quota information")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/quota.c        |    8 ++++----
 fs/xfs/scrub/quota_repair.c |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 222812fe202c21..7a1704b0c9d802 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -182,21 +182,21 @@ xchk_quota_item(
 	 * suspect, which is why we flag it for review.
 	 *
 	 * Complain about corruption if the soft limit is greater than
-	 * the hard limit.
+	 * the hard limit and there's a hard limit set.
 	 */
 	if (dq->q_blk.hardlimit > mp->m_sb.sb_dblocks)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_blk.softlimit > dq->q_blk.hardlimit)
+	if (dq->q_blk.hardlimit && dq->q_blk.softlimit > dq->q_blk.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (dq->q_ino.hardlimit > M_IGEO(mp)->maxicount)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_ino.softlimit > dq->q_ino.hardlimit)
+	if (dq->q_ino.hardlimit && dq->q_ino.softlimit > dq->q_ino.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (dq->q_rtb.hardlimit > mp->m_sb.sb_rblocks)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_rtb.softlimit > dq->q_rtb.hardlimit)
+	if (dq->q_rtb.hardlimit && dq->q_rtb.softlimit > dq->q_rtb.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/* Check the resource counts. */
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index dbbeb858c13c4c..0afce258d5d2e6 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -193,17 +193,17 @@ xrep_quota_item(
 		goto out_unlock_dquot;
 
 	/* Check the limits. */
-	if (dq->q_blk.softlimit > dq->q_blk.hardlimit) {
+	if (dq->q_blk.hardlimit && dq->q_blk.softlimit > dq->q_blk.hardlimit) {
 		dq->q_blk.softlimit = dq->q_blk.hardlimit;
 		dirty = true;
 	}
 
-	if (dq->q_ino.softlimit > dq->q_ino.hardlimit) {
+	if (dq->q_ino.hardlimit && dq->q_ino.softlimit > dq->q_ino.hardlimit) {
 		dq->q_ino.softlimit = dq->q_ino.hardlimit;
 		dirty = true;
 	}
 
-	if (dq->q_rtb.softlimit > dq->q_rtb.hardlimit) {
+	if (dq->q_rtb.hardlimit && dq->q_rtb.softlimit > dq->q_rtb.hardlimit) {
 		dq->q_rtb.softlimit = dq->q_rtb.hardlimit;
 		dirty = true;
 	}

