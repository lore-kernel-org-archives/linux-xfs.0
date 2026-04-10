Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7BD344D88
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801827; cv=none; b=jhOxQeXjAFz1fo9FNxc+2VpOC1CVCptexSvt4NJjk8JCYT8WyVqjcknSvDPPL3sgQZRwpoJnClgHoMKo5IVOmfXS3HnH4jIVMGBnGefZDmHXCLrPqeFpksWGFG4CSW4nubDNQpLZI1Pk7BAUfq7Keov5J7nCWUt26q2RVQOVy7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801827; c=relaxed/simple;
	bh=iyBWmjpM9CVRxZL+/9IGx4/oTLeFwTWenUkVIUkUBQ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nnMImbGFcN3tUr/NvP2h1JvgT9CUDnA9dmB07cBjXkSI0DwUm15sWIBSSvTmMp6+FEaG+hWf85FQpmBfOJA8WiUu3n6gLwzGx4Mp6SrickFiHhG7JsNWOsiCaJ13msFbJdooQRKYOwi0dEijrpecEd4dZtC5yIuaRPj7t2rdlLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXXxpYBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXXxpYBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5891C19421;
	Fri, 10 Apr 2026 06:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801827;
	bh=iyBWmjpM9CVRxZL+/9IGx4/oTLeFwTWenUkVIUkUBQ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kXXxpYBzpUVVdX/XjPiCKAmZoZtb14KWCaSdzJDHZQkchNsl8foihTZbSFvQQflYR
	 Wt5CrczDw87sRVKrB/iL1vczXptcvuFWcIbL4DsnXhLhtOt49GBunGv7ev8q5R4RKL
	 M+8v6+3GNiVSDFbyqLmnybu3oZotIv4vn5NirgG3DdIow0Epjnw8JE8/nrLQKomIfj
	 824hn0JUDiOalh9iR8bvJuPpEx/uV2109yWZFaAnF8pIkOixSv1UPmXSNYdmmeGikg
	 G4VIiyorsTaAOvO68woVE6Y0RYcity7P4BMB/6HippVM5zMT3aFL016oe+Yb41Dqlm
	 fT0ZDoVJ31LKA==
Date: Thu, 09 Apr 2026 23:17:07 -0700
Subject: [PATCH 25/26] debian/control: listify the build dependencies
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384689.2089237.17070709693375221624.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
References: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 debian/control |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/debian/control b/debian/control
index 6473c10be7f7d6..d50960fba205bb 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,19 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
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
 

