Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA3D1BA867
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726670214; cv=none; b=e7NmAvwoBiWNk2enZ5ArCJuwL2dPR7mzE4hbJejIBlasxPKvtrLOni1X4GfhtdvNWPzxtzdPJGFc1nz/1XZs3mOBgZ9zV4Qv7z4kXlG72VyTUkjl/9TeRWK63JzFsQECL7EgPFjj34xqzKXx6bwuL/VHO1R4cl7lGjV8VvVndeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726670214; c=relaxed/simple;
	bh=p+sTY5i3Muo+sYfakUJa4Fzu7LAH3ldS7izQz0n68JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8ZOKkWlBaCs565I32YJGNGb16VytS5i6EpgqiDtaO6Z30LD7zeEq0J3XgKzIWA7evFgaM7HkhlbAiC3lfHLrua5w8Ex2GPwQYrhu7ny4nuudUGCtLJ+f6ki/WP52tAjqRXEKKfitYUwaXB31bCEFDbMN3QGUYKelMQDY9aJzNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=mH43gaE+; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="mH43gaE+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=nC0SGV/TB+yx4AYF/itFzZwBDTAj6+XR0Mt1eh6Vd4Q=; b=mH43gaE+4o6S0hRSMsgLP1HmdZ
	2MGIxpvUkRiqes6TPc/c2tiz642lB75ey9Ol1vySk29VK8CKKMMJjfOyzJA99OZZ42NlPd+cgU6C6
	WqJeN2eWme2iG+7aPfqX/yCgRfC8wUDRRidW4akVSv/tEcKi4VqP3X5nE+X/9dxIVFJuk1CyGhQS1
	K9HrMJHfg08R92iLqZbvi3TpyrWq3+euotG2lXJ15hb2HiP5MFOvIr6EoESGlzGldTZdVvdR4NdeP
	JWuQ6Bn+4lCMb098xlEBdR1q5g3qevAvjQRfFzNhHCm4YBBksdjlONuhnmGh0qkJ85C8iK9tQ344V
	OlTCH79Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1sqvnQ-00B7VF-0a; Wed, 18 Sep 2024 14:36:44 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 1/6] debian: Update debhelper-compat level
Date: Wed, 18 Sep 2024 16:36:13 +0200
Message-ID: <20240918143640.29981-2-bage@debian.org>
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

debhelper-compat-upgrade-checklist.7 discourages using level 11.
Update to compat level 12, which is supported back to buster.

Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

