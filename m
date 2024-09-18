Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0231BA88E
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726670214; cv=none; b=Dw9lhQK+giESoR5RVF3/y3B5QCZTJ8wwkC1dH842JRwS6RpSoCBpt1O24sM/+0WAwfWSlUPzQaW1Hp3FmjuSJCrWeJbXB6GoskTuENP2Sy2+UzI6NTkS/wfBwfiexTlvgFFGAMb5MmqnJwN5J3dr+bKJw+kM0H7dJmdIRiBaRIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726670214; c=relaxed/simple;
	bh=T/WZQkz4C6SDaATM/ukeylnaenvPX01KHFEegQn5anU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTCRULfBShTXTxwo0U3A70QJiRkYwcYbKfZrZ93TJRmNbEbX1wu6MN/R7w0ofN4h8VbBpmF19sA2Xw2aq5cqm9On1wtZrBNKNfyzstCJQJ+3Zw2xTlbWaZrEtv8bxf/F1ax9yLuuVooUkkk9Fagrqu4/NWKNgMU66CpN82MAhok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=a6gWoj+L; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="a6gWoj+L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=HY7JRMoGcX8glmU53tdtu189/qttNj0l6o13hQl7quM=; b=a6gWoj+LPmPPId19h329GRtmKk
	CTK3B9ggPxA2kVsW9R2eQsBancL6CzFl7pBLAy+sLUKJ/JQATGAHEEKAx4S+VwvNEecWf7RFLSus8
	Mwv9hAuOcsWjCrSRFvV9uCc7QPSGKiJAZNbYNf6dyaq4oyU9MVRog/XfuumnI/WCtjMlEE3OUXRBR
	SO/AnXS3QI6ZCeksb9fRQmKUhEHlA7ppRLfeEUrQRtBImSuITwMF9IQOT9LuWKjUgpi0yPy8+WMlK
	RyHv8XE4PNaXJ9NQ9pSPN4weNuMHk8UCkhKFh/u0h3dVK/QXdvP+c9wE4PHsVh9EBOZ9+0eP6xjLJ
	NWoXAIKA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1sqvnQ-00B7VF-RD; Wed, 18 Sep 2024 14:36:45 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH v2 4/6] debian: Add Build-Depends on pkg with systemd.pc
Date: Wed, 18 Sep 2024 16:36:16 +0200
Message-ID: <20240918143640.29981-5-bage@debian.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240918143640.29981-1-bage@debian.org>
References: <20240918143640.29981-1-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

The detection for the systemd unit installation searches for systemd.pc.
This file was moved after the bookworm release, so we depend on two
alternative packages.

Fixes: 45cc055588 ("debian: enable xfs_scrub_all systemd timer services by default")
Signed-off-by: Bastian Germann <bage@debian.org>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 369d11a4..3f05d4e3 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
-Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev
+Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev, systemd-dev | systemd (<< 253-2~)
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
-- 
2.45.2

