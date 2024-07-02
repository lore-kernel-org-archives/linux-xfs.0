Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2108479
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881844; cv=none; b=PH2nqgTn8m7hLRVd3jHET0ry3afrWERYe1EmQXgeNANG082HFJReh1ZuhiE/yswUqACMxJumlGmDJqPyXRnhylWkO638l5OUHZrI77pC6xxdr5DNJxyDEWB1LTV4+kkEnTjNa+2AhrMk7Wh47Xmgjt2f9mC3bGprSor55JVNYWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881844; c=relaxed/simple;
	bh=eAHHtJtidsdXzK6CgHAr8tiHlw8gS5EbEzlyeawA+iw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQNl/Ulm3e/o1DJm65mNs7PjSwYTd2KYc1D8dj7G3Mu0eCi2v+6YTa22s4jsjbUxzsL7EQjoqzcrFkIucoM3pAOYpAXeV28c9xA09Ql8oO+ENA7Ovh6gptndzskyHGxNV3fk3FFWpSpSVAoa5EkfNSWnfPUev9nI0C0uIrr8PXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LIXtG3rA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LIXtG3rA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DD7C116B1;
	Tue,  2 Jul 2024 00:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881844;
	bh=eAHHtJtidsdXzK6CgHAr8tiHlw8gS5EbEzlyeawA+iw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LIXtG3rA0T5FBMaJvZ8ChIB+tnBiO/2QeJ0w6WCGXyXASPptcIreQOGfOyKDecoz/
	 u1KyfEBV6tcjQS3oNrOR2fNYtfBedA6m/+EEfEeJbWHCmhMFOg8GqseGotdPRYhDA8
	 THlDxg3T4myPTysm7uRahdqKkUb97c5fehVdy1A08nXlaNbzGh7+ZIApo8QBP05Ull
	 X6op10cboULn3eMq6b1OB9PrgqkVDiet4OsXl+g7f7/9yWWaA3Vs9itxvFqglkWFnr
	 z4b3KOxYsQy+3gb76njeqt7Wm4Z6oX6FoiEFkEUzyc1WFLOOEVeUxdyQra+gqjY/KN
	 0dETGlYW4La+w==
Date: Mon, 01 Jul 2024 17:57:23 -0700
Subject: [PATCH 3/3] mkfs/repair: pin inodes that would otherwise overflow
 link count
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117270.2006964.11531106267384216498.stgit@frogsfrogsfrogs>
In-Reply-To: <171988117219.2006964.1550137506522221205.stgit@frogsfrogsfrogs>
References: <171988117219.2006964.1550137506522221205.stgit@frogsfrogsfrogs>
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

Update userspace utilities not to allow integer overflows of inode link
counts to result in a file that is referenced by parent directories but
has zero link count.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/util.c       |    3 ++-
 repair/incore_ino.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index dc54e3ee66db..74eea0fcbe07 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -252,7 +252,8 @@ libxfs_bumplink(
 
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	inc_nlink(inode);
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		inc_nlink(inode);
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 0dd7a2f060fb..b0b41a2cc5c5 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -108,7 +108,8 @@ void add_inode_ref(struct ino_tree_node *irec, int ino_offset)
 		nlink_grow_16_to_32(irec);
 		/*FALLTHRU*/
 	case sizeof(uint32_t):
-		irec->ino_un.ex_data->counted_nlinks.un32[ino_offset]++;
+		if (irec->ino_un.ex_data->counted_nlinks.un32[ino_offset] != XFS_NLINK_PINNED)
+			irec->ino_un.ex_data->counted_nlinks.un32[ino_offset]++;
 		break;
 	default:
 		ASSERT(0);

