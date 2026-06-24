Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D082F87B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782325027; cv=none; b=mXF6Lqb9RWTZTMZGQRzafzdgNDCfZkoSMiiFOdY3uKgqlBF+sk5U2tiBekUI5PrhSkckPSNN8qoq7AbXc5Ntlr08gDvgPNa83vk40N+f+S/clPgryb6lH6OJkK9pzSibxay1qST4J+GfELop2WXZVHJHc8Uos0Jhhpaoddf2bOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782325027; c=relaxed/simple;
	bh=WsmaV2EwDP8FxT+4IqfALnsw87bYGnj68vsKvovWnrY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rTdS+DU4l/NvSJzmL6HjMW9bF8aXm4K2iEyQo8LIgo48awlYZhwev0Q5GJduLywcz9M4wv/ZSVUBVgN0kvQU6JcYnyUUJZFCo9tMVtLhLOrRlQwku9rnILvONPa0OrERFev0quSICl1xTLhd6gAv+hGX1mzk6oK4XjKVvx1UdUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6izEW6y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6izEW6y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D3F4F1F000E9;
	Wed, 24 Jun 2026 18:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782325026;
	bh=6V+dkZb6ogKoPvjK+mH6LcQnmvM2leyMbQ4RZ9lks2o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=S6izEW6y921KDK15DCUEJG9gWTjueLvhlYqrVir5uZ5QPijcrXQFHEqYAglyFdWiK
	 Ksfuqh3gxplOnIw4KU72KoPS4MawW3/3XOFhn4O9V4FGiMHEVj4y16X055bpXzB16f
	 cJf3KQZEo/n80xoHuAfiXEK/1Uq7ssY90JqRJrti/dSiS4CD6QYDU0LFJbv5VIaan/
	 VfT3KLw/e3/MClKjN1zsqkcV9e/wlu2SJvL5mJZlKVqWNIe7FUhEX+LkKYSfQaoETM
	 n4mQ06n0kW4EZvmHFgjZ+7HzihOR8eTrFO1kSmJ/ZTupQ8+pae7RiBVYYIvjOjN4Xt
	 7Pv/ZVkAlJwqg==
Date: Wed, 24 Jun 2026 11:17:06 -0700
Subject: [PATCH 10/11] xfs_scrub: don't leak the autofsck fsproperty handle
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178232484623.915780.13550947290089406895.stgit@frogsfrogsfrogs>
In-Reply-To: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex notices that we leak the fsproperty handle if the filesystem
doesn't actually have the property set.  Fix that by moving the free
call; it can handle a totally nulled out structure.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 9451b5ee0d0d2d ("xfs_scrub: allow sysadmin to control background scrubs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase1.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 6ac59264b50bb7..620a12393b3658 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -178,8 +178,6 @@ mode_from_autofsck(
 		break;
 	}
 
-	fsprops_free_handle(&fph);
-
 summarize:
 	switch (ctx->mode) {
 	case SCRUB_MODE_NONE:
@@ -200,6 +198,7 @@ mode_from_autofsck(
 		break;
 	}
 
+	fsprops_free_handle(&fph);
 	return;
 no_property:
 	/*

