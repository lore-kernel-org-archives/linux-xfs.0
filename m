Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C618428504F
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428101; cv=none; b=I/Ki0wssxjqHIyEXUJECogdEQNehKWo+FY00tVylBrG049ZLut2yvD/OKPxF0vzTR6ZDv4JFrF9CT2SsiybZT1elu9C3/11uwp8fkF+EgLDKkrQa30Q5H4OgbFzp/qRx+Xo8Ncq5nWW/OZX5XQUBLjPeK2NcOdN+ZcrWmEZ+sP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428101; c=relaxed/simple;
	bh=Iy7IMX0Z96HOdy67UZ2wQJHL0lzk8k2I1jt7hXjqEwI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jEqbGVtDzirjs3nzyeJMJ1M8NkglR9/jhFrNxsBxmjkqO0NAIqFuioFyU3pkTYOjxAVVy1t7KMZ45NAPQc++Qln3DWVHEuE+GtQI+ZcdC4i6j3bVffKFa60Gzhr6mEs2E/OR8KRhMbvFgdAlJWWWWWTbSHaGXCKMJXTKUW/5AZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9lNPz02; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9lNPz02"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5EAD51F000E9;
	Thu, 25 Jun 2026 22:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782428100;
	bh=qM6joVlgZ6NKfhuZXjZCvORXIsT8BRZUQ66EL7GIh+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=A9lNPz02J9vT0HTuu0uDakdfvuNzk8tEa3LRbkXbfosZPVaFXi8I1paDJCUhwa8Ap
	 /qVO0qMZq7xr63w0UXD6z3zn5by71xSFFPRcB1jGa/s3RXOa876aYtzojOsEyZMZIU
	 KWZgDDXdkIkgWHFCeC/RPQSdENjXAeNiXAXFYekKA/rQ34MMQxBdBwg5Wgef5Tw4Ky
	 T/5sqpooPv9gxr4QqciFrR+CeRlPlIKd1qK3/JHqQ9Ly2VPaEysqmfpqiv7G1RdehI
	 jpXi+Kh71sbRxA1Qfm/RmftUZAei4vw37JIuLqkcrr5RRDJQy2xJSnATD4aNIp3FLb
	 VGGlQY0LJpNJQ==
Date: Thu, 25 Jun 2026 15:54:59 -0700
Subject: [PATCH 3/8] xfs_scrub: actually handle NEEDSCHECK scrub items in
 phase 4
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178242801359.1981574.13932376274441544851.stgit@frogsfrogsfrogs>
In-Reply-To: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

While reading the code in repair.c while triaging another Codex
complaint, I remembered that phases 2 and 3 react to an un-scannable
metadata object by dumping them on the repair list for phase 4 with the
"NEEDSCHECK" flag set.  However, repair_item() doesn't actually process
those NEEDSCHECK items, which means that we could silently fail to
complete a full scan.

There are two ways that repair_item() gets called -- one is the action
list processing in phase 4; and the other is repair_item_completely,
which is called directly from phases 2, 5, and 7.  Action list items
never have NEEDSCHECK set because repair_item_to_action_item promotes
them into "corruptions" to force a check; and the repair_item_completely
callers only ever pass in actual corruptions.

Therefore, we should amend repair_item() to process NEEDSCHECK action
items so as not to leave a logic bomb for future authors.  We should
also set sri_inconsistent so that any errors that are found during the
NEEDSCHECK scans result in a revalidation after the repair.

However, there's a real bug in repair_item_to_action_item.  If @sri says
there's at least one NEEDSCHECK item but no corruption elsewhere, then
we exit early instead of queuing an action list item.  This apparently
doesn't happen much in the online fsck QA suite becuase phases 2 and 3
aggressively try to clear NEEDSCHECK items and only deferring scans to
phase 4 if they cannot make any forward progress.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 83ffb5b454b172 ("xfs_scrub: start tracking scrub state in scrub_item")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/repair.h |   14 ++++++++++++++
 scrub/repair.c |   16 +++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)


diff --git a/scrub/repair.h b/scrub/repair.h
index ec4aa381a82d36..af3a9d7186242a 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -96,6 +96,20 @@ repair_item_count_needsrepair(
 	return nr;
 }
 
+static inline unsigned int
+repair_item_count_needswork(
+	const struct scrub_item	*sri)
+{
+	unsigned int		scrub_type;
+	unsigned int		nr = 0;
+
+	foreach_scrub_type(scrub_type)
+		if (sri->sri_state[scrub_type] & (SCRUB_ITEM_REPAIR_ANY |
+						  SCRUB_ITEM_NEEDSCHECK))
+			nr++;
+	return nr;
+}
+
 static inline int
 repair_item_completely(
 	struct scrub_ctx	*ctx,
diff --git a/scrub/repair.c b/scrub/repair.c
index fdefc2131aa453..c118938fe21303 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -260,10 +260,11 @@ repair_item_dependencies_ok(
 		if (!(dep_mask & 1))
 			continue;
 		/*
-		 * If this lower level object also needs repair, we can't fix
-		 * the higher level item.
+		 * If this lower level object also needs repair or hasn't been
+		 * scanned yet, we can't fix the higher level item.
 		 */
-		if (sri->sri_state[b] & SCRUB_ITEM_NEEDSREPAIR)
+		if (sri->sri_state[b] & (SCRUB_ITEM_NEEDSREPAIR |
+					 SCRUB_ITEM_NEEDSCHECK))
 			return false;
 	}
 
@@ -855,7 +856,11 @@ repair_item(
 	if (ret)
 		return ret;
 
-	return repair_item_class(ctx, sri, -1, SCRUB_ITEM_PREEN, flags);
+	ret = repair_item_class(ctx, sri, -1, SCRUB_ITEM_PREEN, flags);
+	if (ret)
+		return ret;
+
+	return repair_item_class(ctx, sri, -1, SCRUB_ITEM_NEEDSCHECK, flags);
 }
 
 /* Create an action item around a scrub item that needs repairs. */
@@ -868,7 +873,7 @@ repair_item_to_action_item(
 	struct action_item	*aitem;
 	unsigned int		scrub_type;
 
-	if (repair_item_count_needsrepair(sri) == 0)
+	if (repair_item_count_needswork(sri) == 0)
 		return 0;
 
 	aitem = malloc(sizeof(struct action_item));
@@ -893,6 +898,7 @@ repair_item_to_action_item(
 		if (state[scrub_type] & SCRUB_ITEM_NEEDSCHECK) {
 			state[scrub_type] &= ~SCRUB_ITEM_NEEDSCHECK;
 			state[scrub_type] |= SCRUB_ITEM_CORRUPT;
+			aitem->sri.sri_inconsistent = true;
 		}
 	}
 

