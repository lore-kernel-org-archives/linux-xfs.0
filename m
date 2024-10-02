Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8626539A
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831160; cv=none; b=dXWCsq3kjkdXcFvuEK6s1gkaK9Wj4S3QI6fsuy7bFB2JfnDZjyDa1rHm1tBZjnFrxpMAT70N4L13hKtFE4NLPG30CUQFZPfg+Hmam/WcxK32ZpXtNhnNP1R9U4p2s/YWdle0PgeYqBBl13KP2agpR7JurRCOVqkX1c4mLcjZRVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831160; c=relaxed/simple;
	bh=Y3MpRjIxtNAHNwWF+EVBoyJW5CXDH7mr8qzOONf98iw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k8cJezalUbpvj4xazXLjXxpIbl8BojQ7OYLgZ2w8r5F2OxSth20u8r7S262Xp04gmct+HUP8JuvKPB4RSW4QrYE9UNiqFyERpmjZ7JJ2bpRVzaenGIwl40RgE/1Ybd0f4/pU5R0h5oLBZcCJnCxKPijbbyH0/+OqzMJfBxO+O1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cMUKaGW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cMUKaGW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E77C4CEC6;
	Wed,  2 Oct 2024 01:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831160;
	bh=Y3MpRjIxtNAHNwWF+EVBoyJW5CXDH7mr8qzOONf98iw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cMUKaGW4nVJPA/vplqUC2aI/HGKagKi1baYXGFMB74D9xaZNTX9Uv3y2J71OeiCEx
	 ZRY720+m6qBsCZqUxsraPVh14bnv8AUFqeeP0XkMPy3rksR9840XjcVnBuhfyjTGQK
	 MBBgJPz8mfrU6HTmaZ6X5iswsKOb3T1wZRYU7bmKsyKN2+NoGFNd+WsSZ1WLBQdnyR
	 F5GeilmMmwu04Ic5rXStCwaFXgjRRzP6qF6KJU70oHidwTnsliSGOG7ycFLBiAM9qs
	 FssweNgTmCjOMgLt7mYdpUC+MDclspKYOigc1GCQwK3X5JTdOX4GOQEsfGoP5ROVHr
	 pyhcoWQnPFHTA==
Date: Tue, 01 Oct 2024 18:05:59 -0700
Subject: [PATCH 1/6] debian: Update debhelper-compat level
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Message-ID: <172783100985.4034333.10098962525264479766.stgit@frogsfrogsfrogs>
In-Reply-To: <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
References: <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Bastian Germann <bage@debian.org>

debhelper-compat-upgrade-checklist.7 discourages using level 11.
Update to compat level 12, which is supported back to buster.

Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/compat  |    2 +-
 debian/control |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/debian/compat b/debian/compat
index b4de39476..48082f72f 100644
--- a/debian/compat
+++ b/debian/compat
@@ -1 +1 @@
-11
+12
diff --git a/debian/control b/debian/control
index 31773e53a..369d11a4e 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
-Build-Depends: libinih-dev (>= 53), uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev
+Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 

