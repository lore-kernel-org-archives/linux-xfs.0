Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E3B7464
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301893; cv=none; b=Nn/xoiTCLPR74iZsm/n+3WSXvjdUeroGO35lqSGzdUBH3jMDT0sT+Ppv2F9HLGzy7PVFK2Ku+SVQOk3DahEPMdMx8eUmYW+TOzNoOvAvmnPFo6bZ9LedCmnUHMZwxwbPEB6mPPLAJiRxDQRqG3UTsblAtS6ECOlG23Vx+a6UDTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301893; c=relaxed/simple;
	bh=Ls8ijMA85RcTAZwcin62yBzXdgnN53XFCPm7JhjuQjg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jJwL/TMIlZV3O2F4UA7gxMFfwxq4W11YdpkafZmjMxhocWsqYweOIldXVu5dS/hbQiNFg9o7FWrJRNCEiX3m7+VNaHxmPrtSRZXsbrW06BABGFFHsoygzR9ZVzyKXfbLhhXdA+Ir/nVFlSxIdqs1Zce/ZoJGws78dFp6rWqHAa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hqA3r+v9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hqA3r+v9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DC9C32786;
	Tue, 30 Jul 2024 01:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301892;
	bh=Ls8ijMA85RcTAZwcin62yBzXdgnN53XFCPm7JhjuQjg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hqA3r+v9WBDmqfC4fkIl5iToceR6Ga/YFY94v05ZgSXnp8WROtQDVOVXDstksidpG
	 OmzMTwAc9k1kD2+6xPO9SLlGvcaGfrxqCBM2eva93ZKoEDY8I4LNhaerGHi87iJ5AA
	 19DCdkjyLFVtcXuHMp7w2WMc0aHlONIWNVqzr6PjGK2fsFR8G+ZaWD5l1nHDua58TK
	 vOodK11IrqcrzAeuWwvtXdkkjfVAd09stPxOcG6S7J4BbmV/9Cfcj0YV5Nrl6tc+QS
	 GCZTxjy8H5HMFaBYdpQP2cLbx0SyvBFs7ZXq1iCUyI9+RvGa0uxrNotru+lQqFb2yZ
	 lMZ4MBtPNeJnA==
Date: Mon, 29 Jul 2024 18:11:32 -0700
Subject: [PATCH 2/7] libfrog: print wider columns for free space histogram
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848477.1349623.14638070922660076685.stgit@frogsfrogsfrogs>
In-Reply-To: <172229848439.1349623.8570132525895775451.stgit@frogsfrogsfrogs>
References: <172229848439.1349623.8570132525895775451.stgit@frogsfrogsfrogs>
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
index c2f344a88..7cee6b350 100644
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

