Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAB92DB7B8;
	Mon, 12 Oct 2026 05:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784671; cv=none; b=EsCUT4N7mIL2oraulg7WAi9wagW2GPm3MaiVieLDtO/AlWSPABz0Hrcq3hPa/bUQbt4hHeKrqKtMmTsqB1hSnR3KBPTkiEmafPX6I+/45QmpHSn45GEdRbH8vzuwZ5950kfdRDMvfTStGFYLNV36L6LFnO9GBJXgx7u1g11E0t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784671; c=relaxed/simple;
	bh=Ywba/+NYXsj6Rq95/AoGlcSikhrh6Lv1p0+Ktwx/bKk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VXz8tkzAGO1hXS7I6gmPiVFIL1EIWhctQxN1Ww+Qq16KE3qz5GXXPgR9mBY/8dYX+qt6tgiUfRq23wGHWKCqt6H76PXL2WmvddMbwA4U7dsQQQYJ2be5b4wDS6/mQLEZg/7qFDgn4UpPqAjaH8kYKioQSXp9g8a1DxxvbHvntAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2L61eN7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2L61eN7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 938F81F0089C;
	Mon, 12 Oct 2026 05:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784669;
	bh=8sIyqryzMcBplguXm2faeHnu8EYghx+QHiDeuPNqYLc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=P2L61eN76mh4Zlxz/bnzTm5sWjbFLTu7EY/Fd5e7jzdDTrvDeGXrmT2uPYOTvS/Nt
	 V6EimtPCmdtgQGcwAcsQpJXPXw9yE6154S+7etla5MvN6FhPveX/UGCF/FXkEWyRx5
	 AB7zVnFSSY0kHpbbu1McikjTilx4SJyOkXmwVeE3ccYDeYs1uLjiI9OxV/lI2WxWPJ
	 azUFc/I7HwzsF5tALZfxXX14NLKSmTtBdVMZv1hJzySCiNQHgSU2WVUo8/aMc2bS8z
	 XM7QLFPgo6KF9c1smA4h84C0AytFqMpAOxawT5kXW9eUIM8l6k4EFRurtJ0ccOnynu
	 Si6RgQbrizbaQ==
Date: Sun, 11 Oct 2026 22:57:49 -0700
Subject: [PATCH 08/12] xfs: don't clear COWEXTSIZE on directories on reflink
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065367.1058326.6266297742144507394.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_dinode_flags clears the COWEXTSIZE flag
unnecessarily on directories on reflink filesystems.  Directories just
pass the hint along to new children, so it's valid to leave the flag
set.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/inode_repair.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 89cbf599795b2f..4b719ad64ace8c 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -565,6 +565,8 @@ xrep_dinode_flags(
 	 */
 	if (xfs_has_reflink(mp) && S_ISREG(mode))
 		flags2 |= XFS_DIFLAG2_REFLINK;
+	else if (xfs_has_reflink(mp) && S_ISDIR(mode))
+		flags2 &= ~XFS_DIFLAG2_REFLINK;
 	else
 		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
 	if (!xfs_has_bigtime(mp))

