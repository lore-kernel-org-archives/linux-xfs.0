Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F05194080
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720043247; cv=none; b=Dyr5bBvRgk5147S4dGdzxo874TDMTjOHwwYf6j2E7R1OvcJ4XrtyNO/TwqcOMkCsFSJMtz0AusLES8IENW152q37whPNBWaNkO6yK4wQu/WAZBjboWZZqved5pQUaAolgbBCHp6GkIq4w14Jzmeh3+geMAt+/boLTd8PuR52JmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720043247; c=relaxed/simple;
	bh=lc7E4W/2M/On50I5LuUkRqpnp7J5m3TU0WIIZ6qOOAI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fK8coSM7Z0fRWAqB3ojrZ/WEBg3qAyKRoosNzex+11i6b4XWw6KfTlXpimmD6dcvy41j5LuoxkIxQXVr12HriYlaMaQxXYr7tCD+YwXtH8fT2N/1YusPYfY+ocU2vkFzpYKqg0NTYQJFrYzgcovWOshAKhuCNoqLjs1BT/tAVqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvP26/9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvP26/9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E88C2BD10;
	Wed,  3 Jul 2024 21:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720043246;
	bh=lc7E4W/2M/On50I5LuUkRqpnp7J5m3TU0WIIZ6qOOAI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fvP26/9wx48qDNz32cXZ39DZUPFynK4Yq2/wFqdMWRtwaRsLiS8iXsR49l+H3MK43
	 4Z/RHaMCw+bw5WwmOOFgVC0weGdb2cZw2FDYGAGaVrdQVTYKfsbW5E/TnuY8M56a3/
	 RUNJGqyTMiapzrhNFT4f6ib8PKzr7ziAj4Z9CmEMelBXboBkZ5dh5tB64MI9TRx0XJ
	 KbM9/SmUmDkX+35RQ4YuDmPZpJk/MFexPV5K/oMHAeDpE9cugPF2Gk8/UiapZTfIa+
	 6sIjWyNIVQQyOoNx7riQnJDDPVD4MMcjwQQYyAV8LsmwpfCD3GP/mp+1qYce0H2oEV
	 3mCIPQ/diJKsw==
Date: Wed, 03 Jul 2024 14:47:26 -0700
Subject: [PATCH 2/7] libfrog: print wider columns for free space histogram
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172004320040.3392477.15232270817738691609.stgit@frogsfrogsfrogs>
In-Reply-To: <172004320006.3392477.3715065852637381644.stgit@frogsfrogsfrogs>
References: <172004320006.3392477.3715065852637381644.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/histogram.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)


diff --git a/libfrog/histogram.c b/libfrog/histogram.c
index c2f344a88eb6..7cee6b350046 100644
--- a/libfrog/histogram.c
+++ b/libfrog/histogram.c
@@ -110,10 +110,30 @@ hist_print(
 {
 	unsigned int			obs_w = strlen(hstr->observations);
 	unsigned int			sum_w = strlen(hstr->sum);
+	unsigned int			from_w = 7, to_w = 7;
 	unsigned int			i;
 
-	printf("%7s %7s %*s %*s %6s\n",
-			_("from"), _("to"),
+	for (i = 0; i < hs->nr_buckets; i++) {
+		char buf[256];
+
+		if (hs->buckets[i].nr_obs == 0)
+			continue;
+
+		snprintf(buf, sizeof(buf) - 1, "%lld", hs->buckets[i].low);
+		from_w = max(from_w, strlen(buf));
+
+		snprintf(buf, sizeof(buf) - 1, "%lld", hs->buckets[i].high);
+		to_w = max(to_w, strlen(buf));
+
+		snprintf(buf, sizeof(buf) - 1, "%lld", hs->buckets[i].nr_obs);
+		obs_w = max(obs_w, strlen(buf));
+
+		snprintf(buf, sizeof(buf) - 1, "%lld", hs->buckets[i].sum);
+		sum_w = max(sum_w, strlen(buf));
+	}
+
+	printf("%*s %*s %*s %*s %6s\n",
+			from_w, _("from"), to_w, _("to"),
 			obs_w, hstr->observations,
 			sum_w, hstr->sum,
 			_("pct"));
@@ -122,8 +142,9 @@ hist_print(
 		if (hs->buckets[i].nr_obs == 0)
 			continue;
 
-		printf("%7lld %7lld %*lld %*lld %6.2f\n",
-				hs->buckets[i].low, hs->buckets[i].high,
+		printf("%*lld %*lld %*lld %*lld %6.2f\n",
+				from_w, hs->buckets[i].low,
+				to_w, hs->buckets[i].high,
 				obs_w, hs->buckets[i].nr_obs,
 				sum_w, hs->buckets[i].sum,
 				hs->buckets[i].sum * 100.0 / hs->tot_sum);

