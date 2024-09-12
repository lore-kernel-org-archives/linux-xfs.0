Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EFF18C921
	for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2024 07:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126723; cv=none; b=Ywv0hiNj5rU/TGjGpqQzmxJfWNImGMl0rw2IfNTxxYqCmb49+V3a2zanWmEa++HazHGqWwnDjsFpSTpFvXD/fein4GGEwYgfWTCMX64/48Cgu8z06UbiDvy1xkn2OTOD2tdMEd7zlc4mcf7ecXhKY0THJ2fC+ikDiYi18BV3y2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126723; c=relaxed/simple;
	bh=GLbNOCupdSU9sHOR6lH8t9NHJx2JAXZEJG3q4/vmK20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMEXWHfC9kcQTQfjDfQt1bCtUR12+lsoOCvA2QzKM8b5ai9z/LKx/ELHIB5ATuW4mm+LUe6O2vmcUPFXuNB74ih1NzqZBP/PpkSLFGWy2ir8C2ioAy9C8obALXcZuHYhKViEic1VlDIQz0RnVBZxPqTkr28cRjjGx7wzqlrqgG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=JeuIl5cu; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="JeuIl5cu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=gcYNM3C51Cypgj7C9yVrzJZMfQVJ75AGr/d/Pl0KV3o=; b=JeuIl5cuZLU//Ql4S0c/YnDu5q
	2RGCuspltE1b1OMYQIy0pC+FENV2dvv+X2sp3/byxDsJOiF4+D2BTCnVGSYDcrV4bq651UcG8V1D+
	IhuZV6BUFoHmEhmEQtCVMO7LYe+gAR68NgdzpJRv+4sRD6fDcdd+hM5Ud5PKClJ6I0uFmLV8fyoYW
	six8KOaakMARS/scolpToHgJxmKIcfIRPHEFxrJ6LxmwluyItb7xYwubf9aaIxPHSOpsx4fRfgddH
	Vpsd0YGevf15ggUI06YpxZhxBCy1E3P4JvN/RzWoInkVKanVqWW/YSqpvDaLP+R3GU/aBEXgI+G9F
	txten/Zg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1soe8W-005cqi-Ec; Thu, 12 Sep 2024 07:21:03 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH 1/6] debian: Update debhelper-compat level
Date: Thu, 12 Sep 2024 09:20:48 +0200
Message-ID: <20240912072059.913-2-bage@debian.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240912072059.913-1-bage@debian.org>
References: <20240912072059.913-1-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

debhelper-compat-upgrade-checklist.7 discourages using level 11.
Update to compat level 12, which is supported back to buster.

Signed-off-by: Bastian Germann <bage@debian.org>
---
 debian/compat  | 2 +-
 debian/control | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/debian/compat b/debian/compat
index b4de3947..48082f72 100644
--- a/debian/compat
+++ b/debian/compat
@@ -1 +1 @@
-11
+12
diff --git a/debian/control b/debian/control
index 31773e53..369d11a4 100644
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
 
-- 
2.45.2

