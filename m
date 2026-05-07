Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4AC351C34
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 22:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778191919; cv=none; b=Te3DXcsUVD5eayHKhjjylNBsznIk37FwG10+iVtJvNEaRlloqZtMcrEDAx9+7TIZ0OoIk9El3iIWYnTkraIGBNLyYITVfHbfNkb/DN+FygsCT9mMvmn0O7xsouTxNMbb6kEiTJVuuHhGd5l0uCiGluXsiX9t7+JtIYQid4y6hq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778191919; c=relaxed/simple;
	bh=fRu1loDryhgOKzsp4jU85Sbsgw5hcF8NCwu9iXVsrp8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IicnjqJRs0Tu62cJf7xuQBFn4siom3zJvoQCrkGysPlzoI7p9WllLGmmMdgC/F7WFO7axxV+GNbg8se+11NQY/bPYJUMrRcjSvlM2s69wph+aSMksDD8xsv4kpm8cWjWglam3SvNVpC6VtN6zRduQxfElOWQQ0KM49s/JYpYNm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXl7x5pl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXl7x5pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7076BC2BCB2;
	Thu,  7 May 2026 22:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778191919;
	bh=fRu1loDryhgOKzsp4jU85Sbsgw5hcF8NCwu9iXVsrp8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jXl7x5plKJoZWU+uL1zVc5zsvksnF0QY4kx4ekTeT07lCcylCVvnTtIn5/tX8MSWg
	 DERcWRWs9g6kNTvw4lZCyAzdk+aKXF2vohpGe9py6ZcYAy0LkiszMSHRq6vGLgUx8R
	 bRx3kYEvMX4AOXa1H0kV+AT4BcOZoSyzpjeSbY5QdmFq8susNFzGWF+BNrta93VzrJ
	 3ZSyMx1u49tmPoU3OcQXdKe91ZnG1ZwgU7t1wwcJm502gySU8hMEx7591Igum53IW2
	 7dHtX62f/PiUjjkRGtRBydgbuxJnx2nDkxy0YXFBL2iOdwFkhztZtzRo9NgHfj6dm7
	 iGyMtu44lZBOw==
Date: Thu, 07 May 2026 15:11:58 -0700
Subject: [PATCH 3/3] xfs_scrub: remove dead code
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177819182695.3486034.12265585124906674650.stgit@frogsfrogsfrogs>
In-Reply-To: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
References: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Nothing uses @mask anymore, so remove it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/unicrash.c |    7 -------
 1 file changed, 7 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 87c0a8f0542fbb..1a845d3e84572a 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -499,7 +499,6 @@ name_entry_examine(
 {
 	UCharIterator		uiter;
 	UChar32			uchr;
-	uint8_t			mask = 0;
 	unsigned int		ret = 0;
 	/* Don't allow the first codepoint to be a variation */
 	UBool			was_variation = true;
@@ -524,12 +523,6 @@ name_entry_examine(
 			ret |= UNICRASH_CONTROL_CHAR;
 
 		switch (u_charDirection(uchr)) {
-		case U_LEFT_TO_RIGHT:
-			mask |= 0x01;
-			break;
-		case U_RIGHT_TO_LEFT:
-			mask |= 0x02;
-			break;
 		case U_RIGHT_TO_LEFT_OVERRIDE:
 			ret |= UNICRASH_BIDI_OVERRIDE;
 			break;

