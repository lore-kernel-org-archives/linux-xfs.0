Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F631A682E
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498437; cv=none; b=qzAkUX3bJK3LDK4zSmH6pzyFG+w5/zG9W3B7WJXgsE5G18kiQx8dBP1s0Y7jo2SYdPwJn62l0IzJnvhwgFCX/5Zj32M+GpCRtte0FU3DarRMu/+yGRhLvQ4ThE8Qlmd9+7I6/hEx1rn8oiyqZiM6r31+JK7BZ3qK7iEE4BxArDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498437; c=relaxed/simple;
	bh=YnJwrgDAFeR9RUXD0YEAvEOTGK0SRmh+mVDBoh17esc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CESZm0WC5lWPsZewozI+DNld0zbW3MDDTq7Bh2wxmGNvPSR+v+cuLH8G7nCFJ3mztqanOGPjOFAXGPVVvF5+pufqWvKVl0XXYkOOPAgd4zRcBlX2xGmJbwIu4xTVjf2Dzp86lOS/EPlhbxfoDx3WjZyzZrbAhhUEAzLeV+Y5ELg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tVfJzUSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tVfJzUSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2EBC19423;
	Tue,  3 Mar 2026 00:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498437;
	bh=YnJwrgDAFeR9RUXD0YEAvEOTGK0SRmh+mVDBoh17esc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tVfJzUSl9M5MhWjlG9/qy1vaA71gdVGNEH1G6+GWZU6mM6golAHWAQoHY3DFom9IL
	 sd+XG7vzUa5EHSIvbrSZvgfyO7QBf6kDkTvUvR/z7Ll6/7LwkHI1YagfkrPRv3+e7p
	 iXU5XVkgaJUq9sLA65171GF/r6oa6k3TQsDxXv/JWZOeeATseYTSU07ChUnwaa668P
	 J14ZlOkqWkmFWBcH02B85ZlnEawvM4hxs0X0obsXJ8B1IyM4Fn8rh2ck35Zg4z0nZH
	 45zE64Y8cX6IC1MmE6Ez2NNN6+0JnKkP+V6iNAJkyxGDrDVWDu9jdZ+fNpMjKFMsCe
	 cyNjPZVR+bEyw==
Date: Mon, 02 Mar 2026 16:40:36 -0800
Subject: [PATCH 26/26] debian/control: listify the build dependencies
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783766.482027.4988973426565666068.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
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
index 66b0a47a36ee24..7837019804e93a 100644
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
 

