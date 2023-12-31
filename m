Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13E2C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kks39uyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90145C433C8;
	Sun, 31 Dec 2023 22:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063062;
	bh=9DqU0TzlF4xA2pBasJvx2fMh76RjMPZLUYlD/mWgwv0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kks39uyvl5TXA0v2RNH5yIN3188lsdeC/aO3GgAhYCyLbRpgRLjAnR4MyEGoLucbS
	 oOjpGzgUJxs07W9YPCP5DOa81wHVPet5dzeBgDhLpwiNOQDPNXPIdrcnG3IaWoNAdk
	 lL+j0Wr4Vz/dzrTfHCYk+XnrNjYeZH7ANReKDEodWFMDNMNMO1Y0ZmuYbCtJfslWuH
	 1qClTaJLgQG4CvqLAYVTVbgBxjlwF2/tCDIzQuc5mT4CIXHefuu9ifmg+mYoyqnuWt
	 0GIFAGsOIVJin1iSDMFE9kwYb8REJ1yopISDPHX87H6EMXZpnujzfXoXAhA9sjUGCf
	 yxCxqLqenypuw==
Date: Sun, 31 Dec 2023 14:51:02 -0800
Subject: [PATCH 2/7] libfrog: print wider columns for free space histogram
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001483.1798998.18365076913627783986.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001452.1798998.1713163893791596567.stgit@frogsfrogsfrogs>
References: <170405001452.1798998.1713163893791596567.stgit@frogsfrogsfrogs>
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
index 553ba3d7c6e..5053d5eafc2 100644
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

