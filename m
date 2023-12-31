Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B4BC14F
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9BgRlUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82CEC433C8;
	Sun, 31 Dec 2023 22:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062515;
	bh=at5XH/D9HBsNLQIsAWvBBgk1yrb6E/PRH61VbJhy02Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z9BgRlUSuwGZj20+dIvtU9kNW14nvDC5pkH8PUgU4m1x3/QdrpxGtQM+KbX5kCukI
	 b4TZ4ptxzeKFYN8k+6zmqoHkWpd6h0J2biIjPAF9Suryo7jICBDpu67DIQ55iKyPzp
	 +rXIapcY2KUKoDj61XSE9ZAD0Muzjj94oYWYb/FCUDwiYSt0sgurUgnET+ypXpKr8d
	 nr0vti5Wo3eQqH9J2IpCC6IWV44JtWYIuhdWFzF7WK8wDhGlWYDyWQuCQ1PuCDppRx
	 +g8jq2S62sqrZo3ozhfn2ZiSt1jI9AIZ/bdNUIymo+Phy2Q0MRB94C4XwL4DT8oPs5
	 ILUAsNVSZ14ng==
Date: Sun, 31 Dec 2023 14:41:55 -0800
Subject: [PATCH 6/9] xfs_scrub: clean up repair_item_difficulty a little
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999526.1797790.2646087585739839329.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
References: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
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

Document the flags handling in repair_item_difficulty.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 5f13f3c7a5f..d4521f50c68 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -340,6 +340,15 @@ repair_item_mustfix(
 	}
 }
 
+/*
+ * These scrub item states correspond to metadata that is inconsistent in some
+ * way and must be repaired.  If too many metadata objects share these states,
+ * this can make repairs difficult.
+ */
+#define HARDREPAIR_STATES	(SCRUB_ITEM_CORRUPT | \
+				 SCRUB_ITEM_XCORRUPT | \
+				 SCRUB_ITEM_XFAIL)
+
 /* Determine if primary or secondary metadata are inconsistent. */
 unsigned int
 repair_item_difficulty(
@@ -349,9 +358,10 @@ repair_item_difficulty(
 	unsigned int		ret = 0;
 
 	foreach_scrub_type(scrub_type) {
-		if (!(sri->sri_state[scrub_type] & (XFS_SCRUB_OFLAG_CORRUPT |
-						    XFS_SCRUB_OFLAG_XCORRUPT |
-						    XFS_SCRUB_OFLAG_XFAIL)))
+		unsigned int	state;
+
+		state = sri->sri_state[scrub_type] & HARDREPAIR_STATES;
+		if (!state)
 			continue;
 
 		switch (scrub_type) {

