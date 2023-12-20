Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BD44776B
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rloz+D1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F50C433C7;
	Wed, 20 Dec 2023 17:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092551;
	bh=LQML0uCgwvxkfpNg7HmPf0kgc9Sy1HRjWFKvs8m4ZgQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Rloz+D1+rrEhy/3EAANSUwcBTnWdnLXOY6xT/Q0TYNEOMjTJKA3w18pK5gAAo75Vs
	 l+ZlMhFtgVeCGkxxKDXdVOAXFqyTaVDn/40EUF0oe8MCxu2Tnwnw7+3tN8nfn/1zr4
	 pLHMPETsx+vjo+1PD2/6o1JvV71ZMn+CzxtCY4gy6ihOU91QxRHfAgE5gkGXokmeVk
	 0eiJ2BXTLbXLN0ZlptM0awsTEmnL1MoQAKeMD3u+4B5klTlSfmwFY7YrPfJnfWyO0G
	 hOCu59XG5NLaQiOlbUMXv9zW4nzx702mog0IzUNdEZnYPDCDbZux2dAdQr/Cn4ssxy
	 rc7DyEyo+2nyg==
Date: Wed, 20 Dec 2023 09:15:51 -0800
Subject: [PATCH 2/3] xfs_scrub: don't retry unsupported optimizations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <170309219469.1608293.1771127784149300190.stgit@frogsfrogsfrogs>
In-Reply-To: <170309219443.1608293.8210327879201043663.stgit@frogsfrogsfrogs>
References: <170309219443.1608293.8210327879201043663.stgit@frogsfrogsfrogs>
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

If the kernel says it doesn't support optimizing a data structure, we
should mark it done and move on.  This is much better than requeuing the
repair, in which case it will likely keep failing.  Eventually these
requeued repairs end up in the single-threaded last resort at the end of
phase 4, which makes things /very/ slow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/scrub.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index e83d0d9c..1a450687 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -668,6 +668,15 @@ _("Filesystem is shut down, aborting."));
 		return CHECK_ABORT;
 	case ENOTTY:
 	case EOPNOTSUPP:
+		/*
+		 * If the kernel cannot perform the optimization that we
+		 * requested; or we forced a repair but the kernel doesn't know
+		 * how to perform the repair, don't requeue the request.  Mark
+		 * it done and move on.
+		 */
+		if (is_unoptimized(&oldm) ||
+		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+			return CHECK_DONE;
 		/*
 		 * If we're in no-complain mode, requeue the check for
 		 * later.  It's possible that an error in another
@@ -678,13 +687,6 @@ _("Filesystem is shut down, aborting."));
 		 */
 		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
 			return CHECK_RETRY;
-		/*
-		 * If we forced repairs or this is a preen, don't
-		 * error out if the kernel doesn't know how to fix.
-		 */
-		if (is_unoptimized(&oldm) ||
-		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
-			return CHECK_DONE;
 		fallthrough;
 	case EINVAL:
 		/* Kernel doesn't know how to repair this? */

