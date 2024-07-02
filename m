Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617E87F9
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882206; cv=none; b=fx/0/jZGr2BQXl+wsmiVNs9GU929drdw25k/+nY4r8W1YzAPQk9xoKP48Vjs5JVNWHEvoXLd04B/A5eG3n7OesRFPHEDLw6ujcmPOj27WlabcHLCcbDSRHE3zcLOd8PdIZ/x5TixbR+V17wlw/CsZUjtIrcl+ClrEQ0AZM58KHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882206; c=relaxed/simple;
	bh=BJaBuP9/+7y7BRf6uecBYx5BGvmWVdNByK7uptCqtL4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=st+YUj5DoyLJnvdH3OgFTt/Z0He9c3RVBuxm0K3MpLTdNncwguX/kKyqBe0LxgShgVNW6wSzP/7kPz6cp9SpLHIbO0q3xRO5qwTlWZpeLWY56cXjq6Vy1RirC4kwfY8XJbMflgletJlqhCqGm3v1tLWm4Z/IDT10fJiZRBin7KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YNKTyetf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YNKTyetf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20DEC116B1;
	Tue,  2 Jul 2024 01:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882204;
	bh=BJaBuP9/+7y7BRf6uecBYx5BGvmWVdNByK7uptCqtL4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YNKTyetffTA5xtzOIZZbDfN/8Lf76wL1Y/AnKE/40eKM03o0Lz2xdpv5w2ERb8ia6
	 PFHZQXKo5KFsjMoypYjRX4Voi0XSxJYRfy/ECF2m7UapijHg17qREnjLcehip9tQ3z
	 LMbxs579VxmzoVGX+kaV8/6Uwv+91PQCF7n4Oy6N6+X7ldCACyml36i5+d5RUah85l
	 FHvxIjps+e3uglsjTMHTSUs7QNPvc7gKmImOqkP1OhmGKcTmTORVBpz+QibkBNY3zY
	 ypE5AoQqTg1h5OJRgbAcdZHJr3vvtKpvQ5zuJQqKHoN/Scyv3WyCg+cQvSVC+WFYbu
	 PQ6TH31QInFYg==
Date: Mon, 01 Jul 2024 18:03:23 -0700
Subject: [PATCH 2/7] libfrog: print wider columns for free space histogram
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118610.2007921.16808669892190727395.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
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

The values reported here can reach very large values, so compute the
column width dynamically.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/histogram.c |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)


diff --git a/libfrog/histogram.c b/libfrog/histogram.c
index 553ba3d7c6e8..5053d5eafc26 100644
--- a/libfrog/histogram.c
+++ b/libfrog/histogram.c
@@ -108,17 +108,41 @@ void
 hist_print(
 	const struct histogram	*hs)
 {
+	unsigned int		from_w, to_w, extents_w, blocks_w;
 	unsigned int		i;
 
-	printf("%7s %7s %7s %7s %6s\n",
-		_("from"), _("to"), _("extents"), _("blocks"), _("pct"));
+	from_w = to_w = extents_w = blocks_w = 7;
+	for (i = 0; i < hs->nr_buckets; i++) {
+		char buf[256];
+
+		if (!hs->buckets[i].count)
+			continue;
+
+		snprintf(buf, sizeof(buf) - 1, "%lld", hs->buckets[i].low);
+		from_w = max(from_w, strlen(buf));
+
+		snprintf(buf, sizeof(buf) - 1, "%lld", hs->buckets[i].high);
+		to_w = max(to_w, strlen(buf));
+
+		snprintf(buf, sizeof(buf) - 1, "%lld", hs->buckets[i].count);
+		extents_w = max(extents_w, strlen(buf));
+
+		snprintf(buf, sizeof(buf) - 1, "%lld", hs->buckets[i].blocks);
+		blocks_w = max(blocks_w, strlen(buf));
+	}
+
+	printf("%*s %*s %*s %*s %6s\n",
+		from_w, _("from"), to_w, _("to"), extents_w, _("extents"),
+		blocks_w, _("blocks"), _("pct"));
 	for (i = 0; i < hs->nr_buckets; i++) {
 		if (hs->buckets[i].count == 0)
 			continue;
 
-		printf("%7lld %7lld %7lld %7lld %6.2f\n",
-				hs->buckets[i].low, hs->buckets[i].high,
-				hs->buckets[i].count, hs->buckets[i].blocks,
+		printf("%*lld %*lld %*lld %*lld %6.2f\n",
+				from_w, hs->buckets[i].low,
+				to_w, hs->buckets[i].high,
+				extents_w, hs->buckets[i].count,
+				blocks_w, hs->buckets[i].blocks,
 				hs->buckets[i].blocks * 100.0 / hs->totblocks);
 	}
 }

