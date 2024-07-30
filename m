Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F021B524C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301375; cv=none; b=KuRM/juo4kgN/PHGsREbhVZGPWiI8dZwrkPRhriPvAv7NA7V9k3lr30JssX6sGNblJp2ndGI7IJWqYN2u7NHZCUvuhiX7LTT7SqbFzjgSSmI17vCJAFjAOh9qbN4/n1IaNiqZYVnvg1d4+vrp5FLzHbxgtmXzHn26754HSZudVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301375; c=relaxed/simple;
	bh=ifGXxlMfs6EQjfJ5uhCjZM6Q5NZmlxKRZQZ8+pyMMBM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T0+i0tt2Y40Ch0qmSSN8JP4E5Tiznp4cDxwP6ImU7Q6S0Rn6WpEWIXwCBJ+BQXvMiLJK/0j50U2Vu4UbDi+if2dFcgPU5KNAuMZklM7rX7u4/65TJQ5NfYutjc0qidmxm5f+mP3V1xxI7mjS1xVdon57OOyzqW6eOCLzwVgAEEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBMoWOn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBMoWOn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C251CC32786;
	Tue, 30 Jul 2024 01:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301374;
	bh=ifGXxlMfs6EQjfJ5uhCjZM6Q5NZmlxKRZQZ8+pyMMBM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OBMoWOn1vE0cdmVRPvYXVoUnEIpK0abyv+cirJ9qJulYeYSbk+l+vHRUmHvOeJDRP
	 FOQJ+9P7mfkY0A/aaj624je/fYhdWvea6STgf1jg2M7Wa8aI4hP9VQ9IIFgf7DihN3
	 9LrVLixXFU+LLCbk4Kr3EzemHKKT7PB1N/GB8ZIDv3qWu8ts5jYtr0e9f9y+ZgV3o3
	 18Q0zupvu/iVHhT+ID1OYCyObtZBxucHF03y+J8Wl2ueYlPzoyUz1STRTWO9yJ0rm/
	 /k6pozM/4sLnuKCPPyE11OXDNzG3hqKscTjcopA3y9vU4LLcMdLYr5nSjAMJgCnAJl
	 XdaQT8rQylvUw==
Date: Mon, 29 Jul 2024 18:02:54 -0700
Subject: [PATCH 7/9] xfs_scrub: check dependencies of a scrub type before
 repairing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846453.1348067.6834490806744998099.stgit@frogsfrogsfrogs>
In-Reply-To: <172229846343.1348067.12285575950038094861.stgit@frogsfrogsfrogs>
References: <172229846343.1348067.12285575950038094861.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/repair.c |   32 ++++++++++++++++++++++++++++++++
 scrub/scrub.h  |    5 +++++
 2 files changed, 37 insertions(+)


diff --git a/scrub/repair.c b/scrub/repair.c
index d4521f50c..9b4b5d016 100644
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
index f22a95262..3ae0bfd29 100644
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

