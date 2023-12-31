Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D46C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1ZWwO8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023C9C433C8;
	Sun, 31 Dec 2023 22:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062218;
	bh=01jAn6gWaaHqTr6yKIZBTZVcOjRFQ0DyFQzbAt4W6RM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f1ZWwO8N8fs0fePcDpMbsdDKMCwqPVnKUxtcMd2e3z9Ds7YDxFf5/eYucSDHsN84k
	 kQGCpFsaC2miv73OKaoQWNUjN2aEctyYCV8o8nVjiNpcqp9NEZhtd6Yck89KEmbBjr
	 JFaavBI5Bmvc7x2nitg3CydYEur3H1anjdYY+PULZd5K2ssOTcPjl5klgIwdonNTZQ
	 iTAAkUQmg46ly2/ZN9msHOfh7wCOYRvgckEIFDEQ4PzaM7LUK7mU9REMJNOMcc+i2v
	 mYWGg2RGYH49UIt6/cqwODJYl2GHe27XeLba6RDwB2OwWkWWXwCSyOQGRb3f8+mz6r
	 UeVmxhU3wDp1w==
Date: Sun, 31 Dec 2023 14:36:57 -0800
Subject: [PATCH 2/7] xfs_scrub: don't report media errors for space with
 unknowable owner
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404998673.1797322.18151501437365003721.stgit@frogsfrogsfrogs>
In-Reply-To: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
References: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
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

On filesystems that don't have the reverse mapping feature enabled, the
GETFSMAP call cannot tell us much about the owner of a space extent --
we're limited to static fs metadata, free space, or "unknown".  In this
case, nothing is corrupt, so str_corrupt is not an appropriate logging
function.  Relax this to str_info so that the user sees a notice that
media errors have been found so that the user knows something bad
happened even if the directory tree walker cannot find the file owning
the space where the media error was found.

Filesystems with rmap enabled are never supposed to return OWN_UNKNOWN
from a GETFSMAP report, so continue to report that as a corruption.
This fixes a regression in xfs/556.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase6.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 33c3c8bde3c..99a32bc7962 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -397,7 +397,18 @@ report_ioerr_fsmap(
 		snprintf(buf, DESCR_BUFSZ, _("disk offset %"PRIu64),
 				(uint64_t)map->fmr_physical + err_off);
 		type = decode_special_owner(map->fmr_owner);
-		str_corrupt(ctx, buf, _("media error in %s."), type);
+		/*
+		 * On filesystems that don't store reverse mappings, the
+		 * GETFSMAP call returns OWNER_UNKNOWN for allocated space.
+		 * We'll have to let the directory tree walker find the file
+		 * that lost data.
+		 */
+		if (!(ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT) &&
+		    map->fmr_owner == XFS_FMR_OWN_UNKNOWN) {
+			str_info(ctx, buf, _("media error detected."));
+		} else {
+			str_corrupt(ctx, buf, _("media error in %s."), type);
+		}
 	}
 
 	/* Report extent maps */

