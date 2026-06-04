Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFD03D1ABE
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553326; cv=none; b=OLOQsyUd5kxKUdRhy++xuXs2oga6DE0vEzqR+XnnuQEKM6+8yBBIi+X6dhxNElEHS1lfjlP2Oz1SkJwyHq0pmsEKFFjHMd6NuuLAwGy37HI8zLQbqDAsycagO2KNvIgsa7hyTqBb9Fc978L6vrKVLYWafbs8CEKsRmo1LzShC08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553326; c=relaxed/simple;
	bh=YDRq/O0VOTvIW+V4bQCyVvL9j2qLmpx5T343mdg2MIY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aLLEdtt1dMLqvY94fbKBxsjnh3UE6gUHqQtq/E0/bxCfQSF+sR5/5LjGyWGiMQVcpDnjuv/SAETv/yVV2bV/xbU8r3jp14pAF2J/cxuOUS96snOhj78i3OGpICMBd/dyrfLTxhemXuL8GZEJ0DZYNYy621zZkAJ6PKk94SRsspo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eTIOq3OA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eTIOq3OA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6BA631F00893;
	Thu,  4 Jun 2026 06:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553325;
	bh=yxlQNYxMfNARyHMrB+g9JIayDAbgtz+xpVUDoVi/wfE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=eTIOq3OAlW9sR59jOPvXgqv/9txfzgKIo+mO8aywkXo3Xj+gP8oAEHPlOwVAlS9MC
	 2ar15cG3jkVX5lA3LSzVOmZfN++Hiu71gc8nIKWAGDhl/0R0pSfWDuv5jQe/tta4od
	 E3sT4etnItwOirPpLJ2lGEPRcBYZmC5P2slzajmPwOMKvbmOTtTpN0qcR4Gqr+9AdQ
	 KsbjY/8LQi+LZkGmDtpGZiy5QZJs6XIN2QdGVqWwNIobBlkekLvsh7LEMc2OFnjVf1
	 9IfHzbMvgYdy65NnlyJlluvd+n9vhrXG6ECGt9SBJ8253OfDZufZWDkYyEBDH8HtDK
	 zT/gwXPklwhqA==
Date: Wed, 03 Jun 2026 23:08:45 -0700
Subject: [PATCH 17/21] xfs_scrub: don't crash trying to complain about clean
 health
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303420.2608728.4807386578991249703.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out that the str_info call in report_to_kernel can crash
because of the null argument.  This whole callsite is fubar because
the third argument is supposed to be a format string, and it's supposed
to print the mountpoint too.  Fix all this.

Cc: <linux-xfs@vger.kernel.org> # v6.9.0
Fixes: 2025aa7a29e60c ("xfs_scrub: upload clean bills of health")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 9e60a4d948f2db..34a2b3aec030eb 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -74,7 +74,8 @@ report_to_kernel(
 	 */
 	if (repair_item_count_needsrepair(&sri) != 0 &&
 	    !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
-		str_info(ctx, _("Couldn't upload clean bill of health."), NULL);
+		str_info(ctx, ctx->mntpoint,
+_("Couldn't upload clean bill of health."));
 	}
 
 	return 0;

