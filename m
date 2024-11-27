Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121841862
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666825; cv=none; b=n7tyNZI8zrGN1L5oQc5jkbsgqHBmrFRY/rjpiZCIy7e8V6TT13CPqk01J6otyZ+puGYKG1LTwepsM2Yw9wuRbffxDCcVy7G1LC002wfKPjVdEz6Naw9u1p0WvaynRhQcQQIFhAMYZ8sSo2WDOBRtQfYEpXOlc1f7MyLL6wXFFfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666825; c=relaxed/simple;
	bh=OaGV+TH6pLtA5ze+4nl505cPKWUguc+lYrdHGo+0rUM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sfx2kBTReUCy6K71jcIF7EK/1LiAAmNxPIVOCPG57OIRVLH+Du+nZ1GB4pU1Cl9s7KTtsH/Y9ehsnULJxt/QpVjkXDvjP65MrfbcGVNG/w+Us3SsitN1lSODAZS2342+FZRR9kQlo3zpkrk4v4xKCrNZM4mEYP8COgwHul+PhOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOLWUCAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOLWUCAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D45C4CECF;
	Wed, 27 Nov 2024 00:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666823;
	bh=OaGV+TH6pLtA5ze+4nl505cPKWUguc+lYrdHGo+0rUM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SOLWUCAL/6htrWNVkjnrRyP5xC0YcgmmX4gHDHKh3xvGkdW3dJ+YstFx5MegimS5e
	 CeBWu58qy5NIlR+wiwtuMZxs8tLlRK4g7BE0JyWg8MDVIj9BggiESsIDXzV309IDp+
	 acdZpYfbAHBJ98axnfRtqdk2yv6NXMOJnF0OKY44lqG4mhHHu9p+bAms3EiOwXPA9A
	 ZWisRkUh3ZvwPNsm5iK5irhoGHgCowK1rpiWCctcPDlAvbID0/qVhcLDkProrCCWxV
	 VoiiYQKJ2UWCTjBlpyo6uNSw4MapUpFDjOjUJn+boZUDrHUza6+NsYXhwjZiEE0Rh8
	 d5qBzOcXjnE8A==
Date: Tue, 26 Nov 2024 16:20:23 -0800
Subject: [PATCH 09/10] design: update metadump v2 format to reflect rt dumps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173266662344.996198.10859077130378156318.stgit@frogsfrogsfrogs>
In-Reply-To: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
References: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the metadump v2 format documentation to add realtime device
dumps.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 design/XFS_Filesystem_Structure/metadump.asciidoc |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


diff --git a/design/XFS_Filesystem_Structure/metadump.asciidoc b/design/XFS_Filesystem_Structure/metadump.asciidoc
index a32d6423ea6e75..226622c0d2f20e 100644
--- a/design/XFS_Filesystem_Structure/metadump.asciidoc
+++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
@@ -119,7 +119,16 @@ Dump contains external log contents.
 |=====
 
 *xmh_incompat_flags*::
-Must be zero.
+A combination of the following flags:
+
+.Metadump v2 incompat flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_MD2_INCOMPAT_RTDEVICE+	|
+Dump contains realtime device contents.
+
+|=====
 
 *xmh_reserved*::
 Must be zero.
@@ -143,6 +152,7 @@ Bits 55-56 determine the device from which the metadata dump data was extracted.
 | Value		| Description
 | 0		| Data device
 | 1		| External log
+| 2		| Realtime device
 |=====
 
 The lower 54 bits determine the device address from which the dump data was

