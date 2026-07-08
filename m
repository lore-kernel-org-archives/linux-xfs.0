Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DB31F03DE;
	Wed,  8 Jul 2026 05:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783487052; cv=none; b=ui3+1CBXPvKe9FvYS5nooO2N3/HnujY2BSpau6QbSHWUixHYrCMePfBnN1UEQRIb1Yu1ZdJ9DLkq/2UjinjsNNgmU9JG8EOjkmQnG0aogxEIOwjtJotUE6yHSbc3N5XUNNuifoRdm+Nrg+cO/GqtjZYUfFpT/4YGZ/AkDPszgYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783487052; c=relaxed/simple;
	bh=9A+j52buKom8wscb3LJmeaWCnRVLIdP/ScNfpF7e+8M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d5/x/LVqYCiwnIv5n8YqCYQLkju/9/FuzoHmUE4L0b0GNbyAtwRUrce15wHMMExUae/isC753YZPgMUU9LWf6tzOtbnWypCmTVVI/dNHSpgCOGh7AWC4Qfr/6lmiKInZ+1+Rs2unRBbDOLnBJ1xyjGoMylZ1KcsvZS5yBeAtDpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iXJmASWP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iXJmASWP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6480E1F00A3A;
	Wed,  8 Jul 2026 05:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783487051;
	bh=SlLSsRQfJL5UIG16SoumnFnA/gGViGaM9Ev74e/o61A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=iXJmASWPOUdG/0FNWnED4unXLaQzGKFemqr1qht4bIQ05lcbvyAvlCB/7oQLTgGy/
	 tUFaS9O6iL9m42cB4XkjPsjyJ3II/fU6bKihcNzpBU1SlNwMF6qr+K+n8Hy6gHjRrA
	 tV88PIrW7+9KBJ8BtGdOYzwzweMFlOBUXjM7owSda8ef+H0xH23ZTXU6X7/9Zr0kmj
	 vHm/thwemtG3m4gxxDMsCVmJieInCbCgF2M3MJ8xIpZWMHDUAAcqKQwBwsl2DWU0TN
	 9+hAWan/v+uKpikJNaFSwh3hz436kOEGFKbv5uMMh1naXeOgaqQ6UzOsurwdUMP+Q/
	 s4gnHEXNImzNg==
Date: Tue, 07 Jul 2026 22:04:11 -0700
Subject: [PATCH 4/6] xfs: use the rt version of the cow staging checker
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178346726172.1271589.16407045175223390003.stgit@frogsfrogsfrogs>
In-Reply-To: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM also noticed that xchk_rtrmapbt_xref ought to be using the rtdev
version of the "is this a cow extent?" helper function, not the datadev
one.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 91683bb3f264c0 ("xfs: cross-reference checks with the rt refcount btree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rtrmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 043be93c714884..b3b2cf17ba2c08 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -209,7 +209,7 @@ xchk_rtrmapbt_xref(
 			xfs_rgbno_to_rtb(sc->sr.rtg, irec->rm_startblock),
 			irec->rm_blockcount);
 	if (irec->rm_owner == XFS_RMAP_OWN_COW)
-		xchk_xref_is_cow_staging(sc, irec->rm_startblock,
+		xchk_xref_is_rt_cow_staging(sc, irec->rm_startblock,
 				irec->rm_blockcount);
 	else
 		xchk_rtrmapbt_xref_rtrefc(sc, irec);

