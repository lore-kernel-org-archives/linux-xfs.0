Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD2EC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HX97UcpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDAEC433C8;
	Sun, 31 Dec 2023 22:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062531;
	bh=ZboCjy4sx/Qd+c78g9jqWIeeEajYNyKKNrM6M/IR0U4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HX97UcpOrrJV6pPp7XcTmSjl4woGfT7yTnlv0RumSZahIEzjOFsQH4+sT6yKh1Ymb
	 TIFCHSpv3si0b8UchoNkeAo2VQHNjzpbiPv+d8zJqJ0gqYyrbHqemwmIfzDwp05sY0
	 gQU8cVgcTRJdxr1WmkX+DWCV39FGdGl112lhGTeFiA9qq+f9eyTFojvd1xHT1Y1Whl
	 Les6qBDt1+ndlq7X7gKatGWt2d9rvtr/MmkWw2Qi1PQ+b0Tig6dhBRZK1ZYACDhdXk
	 dN1g3uKQtmxmgQAeUNCn5MEJlLEDlrRY9tw90ha4AyhR8aEx1iOOWcyErDi72ekRwj
	 OTB4qzsDhBYJg==
Date: Sun, 31 Dec 2023 14:42:10 -0800
Subject: [PATCH 7/9] xfs_scrub: check dependencies of a scrub type before
 repairing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999539.1797790.7472502131864497541.stgit@frogsfrogsfrogs>
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

Now that we have a map of a scrub type to its dependent scrub types, use
this information to avoid trying to fix higher level metadata before the
lower levels have passed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |   32 ++++++++++++++++++++++++++++++++
 scrub/scrub.h  |    5 +++++
 2 files changed, 37 insertions(+)


diff --git a/scrub/repair.c b/scrub/repair.c
index d4521f50c68..9b4b5d01626 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -497,6 +497,29 @@ action_list_process(
 	return ret;
 }
 
+/* Decide if the dependent scrub types of the given scrub type are ok. */
+static bool
+repair_item_dependencies_ok(
+	const struct scrub_item	*sri,
+	unsigned int		scrub_type)
+{
+	unsigned int		dep_mask = repair_deps[scrub_type];
+	unsigned int		b;
+
+	for (b = 0; dep_mask && b < XFS_SCRUB_TYPE_NR; b++, dep_mask >>= 1) {
+		if (!(dep_mask & 1))
+			continue;
+		/*
+		 * If this lower level object also needs repair, we can't fix
+		 * the higher level item.
+		 */
+		if (sri->sri_state[b] & SCRUB_ITEM_NEEDSREPAIR)
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * For a given filesystem object, perform all repairs of a given class
  * (corrupt, xcorrupt, xfail, preen) if the repair item says it's needed.
@@ -536,6 +559,15 @@ repair_item_class(
 		if (!(sri->sri_state[scrub_type] & repair_mask))
 			continue;
 
+		/*
+		 * Don't try to repair higher level items if their lower-level
+		 * dependencies haven't been verified, unless this is our last
+		 * chance to fix things without complaint.
+		 */
+		if (!(flags & XRM_FINAL_WARNING) &&
+		    !repair_item_dependencies_ok(sri, scrub_type))
+			continue;
+
 		fix = xfs_repair_metadata(ctx, xfdp, scrub_type, sri, flags);
 		switch (fix) {
 		case CHECK_DONE:
diff --git a/scrub/scrub.h b/scrub/scrub.h
index f22a952629e..3ae0bfd2952 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -43,6 +43,11 @@ enum check_outcome {
 #define SCRUB_ITEM_REPAIR_XREF	(SCRUB_ITEM_XFAIL | \
 				 SCRUB_ITEM_XCORRUPT)
 
+/* Mask of bits signalling that a piece of metadata requires attention. */
+#define SCRUB_ITEM_NEEDSREPAIR	(SCRUB_ITEM_CORRUPT | \
+				 SCRUB_ITEM_XFAIL | \
+				 SCRUB_ITEM_XCORRUPT)
+
 struct scrub_item {
 	/*
 	 * Information we need to call the scrub and repair ioctls.  Per-AG

