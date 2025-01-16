Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CD5198A0D
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063607; cv=none; b=BzAiZFPl97F+gYgSO5pc0YB6symqcDm70gxzIINAbm7cuEOphLSc6hTBhxBfTA5OwvEAJElgkNwDDl8XwlWuvIVCeDWjYdDNhWbP90ZJya/cw2wPc1n+2HfroKYKmdC+n+8Z6xxOsdXyo5ZQW11Xb57JGEsZhLMLq9VRXe7wSvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063607; c=relaxed/simple;
	bh=Nc0wLvhUAW6K2K1O1XAU2PmRPIopkK3RTegodvlnFfs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G8WIAsAEpFHVPtdjwX+fglNzRTbMnSyKGPJ2k/SPQOv9+z/1LFXKM5yd0tmRmuB6f5Y7bg6M1HBmvNn7ZnTvham1JtikpuamExy3Sr9+XhnvIDHbwRunTH2JohgCYyyppde7ojlxbiqlfKl+ePNcUjkvKIbEVPkBqYyhdWUfCmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k8N3YXEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k8N3YXEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7585C4CEDD;
	Thu, 16 Jan 2025 21:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063605;
	bh=Nc0wLvhUAW6K2K1O1XAU2PmRPIopkK3RTegodvlnFfs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k8N3YXEeMrgIgvXBbqMNET0GWtGi1wHPZI/EAZHqvCYevIf3Lm3fQZC/vC71kPoxC
	 sFFtVkHXZJ5IbLFiHAjMCd3WiiA1S2zIvNhC31Gf4uifTvd3Jaf/c148QQ0FuUk8hi
	 zRG4GenD2D1NhjABi3nfgBqmBma9qOwxvZ2id1uCTATXzPzeRifEe4bYMN50Y+9yoy
	 cTaqIWoUme8VUIFYGkj58dRgP/CZvLah0Ts0gkifR9uwNkvR1uptgOQFKyBKPlrg5E
	 5UNIefGncL+OQDpakOE8YG9zVcRiDktiBBjFELWhaFwKWaI6CKUMU7ui7hB4WLppz4
	 w3q8oRfywL+og==
Date: Thu, 16 Jan 2025 13:40:05 -0800
Subject: [PATCH 6/8] m4: fix statx override selection if /usr/include doesn't
 define it
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173706332296.1823674.4865518424967775302.stgit@frogsfrogsfrogs>
In-Reply-To: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
References: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the system headers (aka the ones in /usr/include) do not define
struct statx at all, we need to use our internal override.  The m4 code
doesn't handle this admittedly corner case, but let's fix it for anyone
trying to build new xfsprogs on a decade-old distribution.

Fixes: 409477af604f46 ("xfs_io: add support for atomic write statx fields")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 m4/package_libcdev.m4 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 6db1177350b643..4ef7e8f67a3ba6 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -112,7 +112,7 @@ AC_DEFUN([AC_NEED_INTERNAL_STATX],
           need_internal_statx=yes,
           [#include <linux/stat.h>]
         )
-      ],,
+      ],need_internal_statx=yes,
       [#include <linux/stat.h>]
     )
     AC_SUBST(need_internal_statx)

