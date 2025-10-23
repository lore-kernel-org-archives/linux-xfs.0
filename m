Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A45A95E
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178622; cv=none; b=s1bf39RQNr5LqY24LmOzM/hp02kL6gtFmgHHj8n50npTzVM2OASW+v2u7sn3M+vQFvXmAvcnDnVs1jv1GUj/8rd3Lp6cwcNcjWH18GA4IG3S00IBqUV7qC/d53Vswo2+eS2NVirAYP9nPe9cw50KUlAim3kh1/+oXsVNWe+oAzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178622; c=relaxed/simple;
	bh=PLUYovWJf7cU5PTmPM3oaxp+NpzcjpVZpeJLj13kgTc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jHuUEtZ0Dyt7iqDNQxbtU+xDEmU67zsX3eeeCWdtOmOSv9PVP/H7F8i/alN11HbXUvUoyB29mQiXOVrQ2OyRr0Vwlp9unfkFBBx9D1AApCZo9uISdo6xE+4TokKBDhWP2jtyHE4dphXH6T8CK+JN/n9G9FS6kaP3H8Y7j22LP+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S0RHviFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0RHviFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640CEC4CEE7;
	Thu, 23 Oct 2025 00:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178622;
	bh=PLUYovWJf7cU5PTmPM3oaxp+NpzcjpVZpeJLj13kgTc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S0RHviFDPXDWiEvEX8vpC/ov/OWIIWTPmw2HvZuWkwwb643U/4z3hLF3hKXHaX6RR
	 q/akyIahhmwZ9UykqX6PDQL8G9ExIy/mB/MBgphapY7GtwQW0JHX+gS+U90IUVUKuf
	 bX3eVX9cPfubz6Fycpu32SVn1UB0hQ2kXmBp6B6djBcgN01C3o5RnFTynwiYG2BA+4
	 dzJAszqqYkGt/gn2RS7ozUHagRBzlIJRIoBZCYHQOUAiLkIgswDLJDhG0tXNzq8DZd
	 BpR2bwWgtAN0jiTfco8xX+AyDj6vDLHWtsUvoynlyEZ8IQBiNW99V8jSEFl2OC98F4
	 Sr/2AZFPNnq8Q==
Date: Wed, 22 Oct 2025 17:17:01 -0700
Subject: [PATCH 18/19] debian/control: listify the build dependencies
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748596.1029045.15303702592303348445.stgit@frogsfrogsfrogs>
In-Reply-To: <176117748158.1029045.18328755324893036160.stgit@frogsfrogsfrogs>
References: <176117748158.1029045.18328755324893036160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This will make it less gross to add more build deps later.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 debian/control |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/debian/control b/debian/control
index 31ea1e988f66be..01bdefd60f661f 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,19 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
-Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libicu-dev, pkg-config, liburcu-dev, systemd-dev | systemd (<< 253-2~)
+Build-Depends: debhelper (>= 12),
+ gettext,
+ libblkid-dev (>= 2.17),
+ libdevmapper-dev,
+ libedit-dev,
+ libicu-dev,
+ libinih-dev (>= 53),
+ libtool,
+ liburcu-dev,
+ linux-libc-dev,
+ pkg-config,
+ systemd-dev | systemd (<< 253-2~),
+ uuid-dev
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 

