Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C797464
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301234; cv=none; b=cKRlJqcmeYtOD+wum/j4BamK1oIaES6sjojCsJ9iRZiYMoPQ6WsPuHSu3wrZC1JHYLdHzMGOGZkfTvrgxujkrFob8REJBbNRTi2wTWK1LkKwd2EW4EjcTB8rmVLfi5timMA/a6WsnRcaASB/FEwIqx/6pPWdMBZFBCs03pZjxQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301234; c=relaxed/simple;
	bh=8Ao5pP1V5GELqylfpEcbsYeEhkn5J0IK+EvXZLZrfFI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GneK/1ZUhuzSVKbP+BWI/MKlhK3fq78WH+hKE1jSHaLGM7gSRcmGEMV5Fz1lWF/aZ7AkBTYS5AAvwmGvDS1U6THB/rpc+UeEnOG8PpKTmEv6fDYW2nwPW+QfsonzBL503H53EAk5OXbLVrK1Meidvglx77axneWcx0CznD4RY8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ea02mIjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ea02mIjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47ABC32786;
	Tue, 30 Jul 2024 01:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301233;
	bh=8Ao5pP1V5GELqylfpEcbsYeEhkn5J0IK+EvXZLZrfFI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ea02mIjfNSqsZ3CdR9aX6BDgS1V5iqDMqg9aG91FJBH1gHdJsUEU7RPPZPpd9bQlL
	 rPaMuGpA1VDV/go8z3fCwJzuPtKGumBAOnE/RT7LGZNyt7IkxidZoSocQ6nbFGt03f
	 iH6aOriVP+yW4GF+smmCSTabpew2cIZ0Ojh5evqSoInox1voDM0SjBhx+kjGb/UcVR
	 2BpP8lSq/KsJrPnBV/bwtAQGkTD8znL81epA0+7AWuyiw3PBxBai1zr4kdTUQQCo87
	 HR7Fh0wlGzVPTtpYVpNJvw4bnQl+R0PcQ/Rm4jt9I9FsDTOB8QNL2scbk+LTl0UKGT
	 rk1zjgxJfflWw==
Date: Mon, 29 Jul 2024 18:00:33 -0700
Subject: [PATCH 6/8] xfs_scrub: any inconsistency in metadata should trigger
 difficulty warnings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846019.1345965.4713357950081199892.stgit@frogsfrogsfrogs>
In-Reply-To: <172229845921.1345965.6707043699978988202.stgit@frogsfrogsfrogs>
References: <172229845921.1345965.6707043699978988202.stgit@frogsfrogsfrogs>
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

Any inconsistency in the space metadata can be a sign that repairs will
be difficult, so set off the warning if there were cross referencing
problems too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 33a803110..30817d268 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -319,7 +319,9 @@ action_list_difficulty(
 	unsigned int			ret = 0;
 
 	list_for_each_entry_safe(aitem, n, &alist->list, list) {
-		if (!(aitem->flags & XFS_SCRUB_OFLAG_CORRUPT))
+		if (!(aitem->flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				      XFS_SCRUB_OFLAG_XCORRUPT |
+				      XFS_SCRUB_OFLAG_XFAIL)))
 			continue;
 
 		switch (aitem->type) {

