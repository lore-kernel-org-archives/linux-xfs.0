Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E38AC13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMg3xVPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308FBC433C7;
	Sun, 31 Dec 2023 22:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062265;
	bh=vEDzYIYaVJ1RVgE50Hp+PZPEW8vfdPsjk+Zjz9Dds9o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aMg3xVPPH/Xj7MQdH2dUL0OS8xHA321HxsC9IZ6xW8TaacTpIzasZrIVQOk4Pxwwz
	 ASdwe6ugvg95YyC3ePaSZLhGpWdNESGrZmWwwU4oA2u7eG3Wx04hqIjSU/+j68JUH7
	 oSZpy0UAUHdfneNjdQql8cwBYm5YpebHYGmwormh98AKq9Opq7h5WFIEKFFndEP6/4
	 +pAYR+ACTjb23e13MbAuRrA8eaAXqGVFeJMp7mLgs6WLc3JwsdAXZQ5E2Y9Wkj2E4k
	 gN8FYtk9aPWN1NW7dsyCQYHVRU1Vg1xxk+ZGvCpUljbMD7LIVDdMvhbglegrtF3CtM
	 O/5b9mtkEfywg==
Date: Sun, 31 Dec 2023 14:37:44 -0800
Subject: [PATCH 5/7] xfs_scrub: log when a repair was unnecessary
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404998713.1797322.10083768087196595064.stgit@frogsfrogsfrogs>
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

If the kernel tells us that a filesystem object didn't need repairs, we
should log that with a message specific to that outcome.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/scrub/repair.c b/scrub/repair.c
index 54bd09575c0..50f168d24fe 100644
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

