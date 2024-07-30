Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9278827
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301109; cv=none; b=VrR/w/HJhQY3SuXBxJIpkWoeoKa9MlbbSnSOof3hWfjVVxGfKUOFEGHbVPJckP0vgMh1PPsslHxwsPxmD9y72JPrWRRJ/YmjVTACPSiY9wEBYpCWfnSi0rrVY3M2S9SC5f2nPkgafZMW/TmFAyLBrsOT8t4g1/l7dMliqM5c07A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301109; c=relaxed/simple;
	bh=GSyavmyX2XNSiHI1tGIWMVA05lK6P80YpV0+90ICCUk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iWfArkyJ99KH+BRihdkOj8oIh0QNG+NZpKDHMHyOF+8RrtPeelcvo7xJFyNlfEiHwCV8bqTXzNebNLluurAt6t4/fKW0/cRVgiyC0vema9Q4wcppz0MryAjXMbuk4wW26ri+AHGniGwJi1WvFn4NwLQhP9mHesA/X0DYWTJ6cXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=koLVTYRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="koLVTYRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F799C4AF0F;
	Tue, 30 Jul 2024 00:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301108;
	bh=GSyavmyX2XNSiHI1tGIWMVA05lK6P80YpV0+90ICCUk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=koLVTYRTAgPaDJ9bnTPByi8o/HrtorVNjA0mU3QxLeZ7PgrEy+IVclFMro9nEg/P+
	 izKm1USImILP3TorSHLve/BdzDK6aX/u9sPAa+1J5ypeCOkMOfty25clpfop0ECf0D
	 VX9WT9lyNxGCncMnte1Rw9UKcDn9b56aV1gBo3PYg2A9z8A+6lEQwrTqahrwoRSGo2
	 4FvP53kJ0mY+L7ooSd0vdbpVR25dzeeDycMeO3pLUmoobYyiW6Q75S6JgmNk555h5H
	 XiyFpD+JFfACYN+YWZGj9puTRyQx5LOmcvXjveZrLdZVJcV5cm8inzX4i+/2NB8uWi
	 i8Ed0FgaXHgcw==
Date: Mon, 29 Jul 2024 17:58:28 -0700
Subject: [PATCH 3/5] xfs_scrub: log when a repair was unnecessary
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229845586.1345742.18261199623012055361.stgit@frogsfrogsfrogs>
In-Reply-To: <172229845539.1345742.12185001279081616156.stgit@frogsfrogsfrogs>
References: <172229845539.1345742.12185001279081616156.stgit@frogsfrogsfrogs>
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

If the kernel tells us that a filesystem object didn't need repairs, we
should log that with a message specific to that outcome.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/repair.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/scrub/repair.c b/scrub/repair.c
index 54bd09575..50f168d24 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -167,6 +167,10 @@ _("Repair unsuccessful; offline repair required."));
  _("Seems correct but cross-referencing failed; will keep checking."));
 			return CHECK_RETRY;
 		}
+	} else if (meta.sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
+		if (verbose)
+			str_info(ctx, descr_render(&dsc),
+					_("No modification needed."));
 	} else {
 		/* Clean operation, no corruption detected. */
 		if (is_corrupt(&oldm))

