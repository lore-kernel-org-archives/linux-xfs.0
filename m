Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8750F17A2FC
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291748; cv=none; b=ofL7R++qo/Y7/2ytfGxFMlypiZ+s1BylscojylCYt2+F0MnRjLTLHU/pHzg5nqi94RED8sSkd4n76lWmstTZub9dYqP7wSDDX+8CcvxxNl/IFujFL2s+KFuAk7plj0pVtKaUrl8e1Ua+f1g/AX/4ekF5vwbXKwJix2EzAyTDpEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291748; c=relaxed/simple;
	bh=2dE2YuVgQK72DY6DVbv/0Iga+0ko0sKqqaj61UXPqdg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HxBR5OI4kT+ioOHLB8Ume19zlnvhIDTOtidyEwF21macEWaKl9YAujUQWq7mew9j3ZPQUV2KrngqMtlMfU2O4hOLLzGbU2J2qaGib9hqX+ZgB83WkHKTaI1u16Zj+CtZS2aGsSPlQbB3oFJdHLi3IbrNjQxBtfNM+Forn5rnBiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEpryjOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEpryjOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F3AC4CEF7;
	Mon, 23 Mar 2026 18:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291748;
	bh=2dE2YuVgQK72DY6DVbv/0Iga+0ko0sKqqaj61UXPqdg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NEpryjOPUiuWfaRVQkP1ENgNmAiz4dqRt7Rvd0GmlPR76ZTdGx1I/rrChMmm5FvFc
	 DfkPwTUjCgxsAffpNVWUDflS0T0sZ1oHRJaEh/UsZCKjp1TNXR5Mmifra4FavhL57k
	 ix7gBf4kZACJRbRa1YH8pszgnYJE4viG7bcj0QOa3wd9K32xkOcmedI4/FHL1KUFxb
	 k4OyDVf80qm7goXzcK8CQaknrQBzozkj2lsxXUk9Gi4kcYW16Qmpt+i4G4VO2+fgw3
	 LU0aCgrZ+Is9bV+b1pkc2yZr5VKanQ7rsbdUxkTMQFO2+ZEbFJee1SP7qNcT1bU2ml
	 ZMQytl0PlwNiw==
Date: Mon, 23 Mar 2026 11:49:07 -0700
Subject: [PATCH 30/40] xfs: give the defer_relog stat a xs_ prefix
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, dlemoal@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429121292.2266274.4442724939738182078.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: edf6078212c366459d3c70833290579b200128b1

Make this counter naming consistent with all the others.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 5bd3cbe4cfa1a3..c0d3aa401cbab5 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -558,7 +558,7 @@ xfs_defer_relog(
 			continue;
 
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
-		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
+		XFS_STATS_INC((*tpp)->t_mountp, xs_defer_relog);
 
 		xfs_defer_relog_intent(*tpp, dfp);
 	}

