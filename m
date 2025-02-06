Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693082417C7
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882372; cv=none; b=VZ6WJsQdaL8NDhLQGLtPptP3OiWSYk7+/Ew9vDp+eOMvqvIuQ+jAlwVzbNIfVCC+CsXtg13tEMuxjK7ZYyJkJNU7wd8ojSuYWbdWspqG1NSQpDY3IZUBgym8yLBcnsZcALLXAkWAs9avLC9T7CVMczA9otgopgArGLpmU3Dzixw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882372; c=relaxed/simple;
	bh=dje40eFFgL4+4xPRooriCOleqXM3u5TOupZ7XmQmxpw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dDt4q1Kg+RwZ/uwgFJG3319FUbefyIv4pVoszKooyRA5niBLv+UjXqDjX1syxCUHA7V2z42IllQ9HiPKai3rzHlENznCh18IYCcBx1M4fURR8gns0duBfPEeUymPxRBV/Gcm0jn6XOtRl2jvgI671+/fpBfEZRBw40wuQjcZzVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SGCO+IX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGCO+IX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA8FC4CEDD;
	Thu,  6 Feb 2025 22:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882372;
	bh=dje40eFFgL4+4xPRooriCOleqXM3u5TOupZ7XmQmxpw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SGCO+IX9YgUR0hK/1bpifAV/FHSktM7WDoD5uwMaBcFkoCZPtaE7hNmKYXUW5GK14
	 pI+wVRaEcoxXqGqHKVlweja4jSfF0dWprohMJNBhT5yl2zs2JWYETvHPRocBS/RSKi
	 ejTmSeP8LSp6IP28PVkTAeNuNxmTK6XxD/Rb8E8wSaGEZLSrQ1bDsDF4Z/Sjmo5tei
	 yZY8N3n8o8tMec56Jl1/kuXjJFZA/Y7XQ9JMpPCtzBDrfOGQOckuK9UspdXZI5m/sb
	 VHAVq1zfrJ7fnBSR61semI80gaoaITCfAgE/8AUcWgEc/JY3RS+lqWj2XtHRuLiEyS
	 xbtanpMStgXKQ==
Date: Thu, 06 Feb 2025 14:52:51 -0800
Subject: [PATCH 12/27] xfs_spaceman: report health status of the realtime rmap
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088279.2741033.5703668513120399965.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add reporting of the rt rmap btree health to spaceman.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 spaceman/health.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/spaceman/health.c b/spaceman/health.c
index 0d2767df424f27..5774d609a28de3 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -42,6 +42,11 @@ static bool has_reflink(const struct xfs_fsop_geom *g)
 	return g->flags & XFS_FSOP_GEOM_FLAGS_REFLINK;
 }
 
+static bool has_rtrmapbt(const struct xfs_fsop_geom *g)
+{
+	return g->rtblocks > 0 && (g->flags & XFS_FSOP_GEOM_FLAGS_RMAPBT);
+}
+
 struct flag_map {
 	unsigned int		mask;
 	bool			(*has_fn)(const struct xfs_fsop_geom *g);
@@ -146,6 +151,11 @@ static const struct flag_map rtgroup_flags[] = {
 		.mask = XFS_RTGROUP_GEOM_SICK_SUMMARY,
 		.descr = "realtime summary",
 	},
+	{
+		.mask = XFS_RTGROUP_GEOM_SICK_RMAPBT,
+		.descr = "realtime reverse mappings btree",
+		.has_fn = has_rtrmapbt,
+	},
 	{0},
 };
 

