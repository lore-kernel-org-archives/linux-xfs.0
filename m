Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0463209
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609875; cv=none; b=QIv14c3MqkFMkWJEnI/pa39VLdjN8Yp1T/+LtN9BUnZdHNTUU2CLHvJeu+/KnNsou7+rFMQ2oKDVpUKrGtyZEuuvhlP9iIjOW/ZoNAQuPTEgwz4kO4nNZsYknTpeGb+A0EEJvkYfFSxd5rW9cYZsM3UdvBa+g4ijbj+eizn8zKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609875; c=relaxed/simple;
	bh=9r16Wkgpxmnh52bp4NyjvArv+7J3/X3msdSXeE/4SME=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tpopmfN3kee1AxvINVtvucn/z3IeXTluF3ZKJ7A3bYM2Ry0mwH3kHFKNNJgk2rAEAaJapIb9o/RzMQtqFIfvB7bBv2ejB692eXywiG0bpsZCsJhS6PrXXD7hSQt+vjKDaZXd7vtfAicoTmN6IfeRf4IF+znEJ1gzkOwQD5QDlQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSy+9y76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSy+9y76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD383C4CEC5;
	Fri, 11 Oct 2024 01:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609874;
	bh=9r16Wkgpxmnh52bp4NyjvArv+7J3/X3msdSXeE/4SME=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mSy+9y76kDP0JOAnfgp1Lo6cmkfNBlwjllr6nW5zrVstp3TXcmltHzAB06gNaooF3
	 mwrIsFKpTq7zBahzNF0HwbpXp+vxvog13eQsCnTzhiHuiQA/zRTZNRUS+D23n8YjLL
	 3M9+HtHMi8RNmm8ANnNW1snxj6HiOM21KHEjIWUWKRmcB6zoLvpJnoC4EnYvwIKsq1
	 b9XNT25ESHzwlAVv2lxcfVbwaG/1sUGVgcF43jujUmFfODYzV4OaxaLOxHd0auNblW
	 Fz4FLBiwBU083AYJTnO3jd1c1SN0zVBeR5NXFZyeVBnmy6zVAiWfLjGGGz5AQdcGUa
	 lxUflTioG88JQ==
Date: Thu, 10 Oct 2024 18:24:34 -0700
Subject: [PATCH 2/2] xfs_repair: remove calls to xfs_rtb_round{up,down}_rtx
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654913.4184510.2431581462692155722.stgit@frogsfrogsfrogs>
In-Reply-To: <172860654880.4184510.591452825012506934.stgit@frogsfrogsfrogs>
References: <172860654880.4184510.591452825012506934.stgit@frogsfrogsfrogs>
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

The kernel will remove xfs_rtb_roundup_rtx soon, so open code the single
caller using the mod value that we already computed.

The kernel will remove xfs_rtb_rounddown_rtx soon, so remove the call
because the xfs_rtb_to_rtx call below it already does the rounding for
us.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 1d2d4ffa6d0e53..e59d358e8439a2 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -197,7 +197,7 @@ process_rt_rec_dups(
 	xfs_rtblock_t		b;
 	xfs_rtxnum_t		ext;
 
-	for (b = xfs_rtb_rounddown_rtx(mp, irec->br_startblock);
+	for (b = irec->br_startblock;
 	     b < irec->br_startblock + irec->br_blockcount;
 	     b += mp->m_sb.sb_rextsize) {
 		ext = xfs_rtb_to_rtx(mp, b);
@@ -245,7 +245,7 @@ process_rt_rec_state(
 				do_error(
 _("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d at rt block %"PRIu64"\n"),
 					ino, ext, state, b);
-			b = xfs_rtb_roundup_rtx(mp, b);
+			b += mp->m_sb.sb_rextsize - mod;
 			continue;
 		}
 

