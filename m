Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19BB9475
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831208; cv=none; b=S5Q7RraGQ5D2OkRfRLHh9A5VI4mPHGc6WOCISYVMrLKdm7SECkNhBp9QNaLDeR/ZXxHXf/1Zid6DONeNjCIRx6ZvEsBo7Y5KI+uQW/gZRFSRzSYPaF5gl7eYfaHA9pP6ByKdvPl5Xg7laaIqJFNsy3XyIddTUL7ByoDOxiauhrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831208; c=relaxed/simple;
	bh=NGSmbwDkqOHUcsHj1NZUmLcMMQEUtCpLySjsiZkT6/U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WfBMdgG6G0cQKPngS3jzxJMX/blzVq406TGFeNWfYj92yW5toyBXAAK0eUy9ToUjwDKpxAAl8/SMCRQW7CTJK/wvX4l6QZVuyplwR+yQDXMwgCDRmDm4+sqcKHLtUp7HWOvUIkCsh+0jds8kOVssmCOkoHchip1jbj+kojMchx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nncIMk4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nncIMk4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D41C4CEC6;
	Wed,  2 Oct 2024 01:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831207;
	bh=NGSmbwDkqOHUcsHj1NZUmLcMMQEUtCpLySjsiZkT6/U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nncIMk4bXkvH5THAfcRiZj1B26m99Mr8wJn1ITPhSYlIF3awwBFdQHlaXOCmXOEN/
	 YP0IBigkY5IDoj1Try0zNVGPhWddxoRTs6zDttIh+8GGVKKQwrwCe2t0xNlxzHB7zw
	 w5p3hNwmDKHLg6w6IYOGIOXaE1+Jhb6Npa9JLapowai1cxdBWGiN4eVGxr736l9DXW
	 DrxS4YEjniOZ1YSBRDUTIaEvLI9DLiqGDyyyaFc+BXZ5OJMgRI+oqc+Ub/c4bM+1q3
	 10nNcT6nM3rwYJRRTNYExB9ktmjCiXHgTAEujzkGdJBxl8CQm721Kd9toKJ12VJGdb
	 pYrQpUusnmH2g==
Date: Tue, 01 Oct 2024 18:06:46 -0700
Subject: [PATCH 4/6] debian: Add Build-Depends on pkg with systemd.pc
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Message-ID: <172783101030.4034333.7499449227211509026.stgit@frogsfrogsfrogs>
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

The detection for the systemd unit installation searches for systemd.pc.
This file was moved after the bookworm release, so we depend on two
alternative packages.

Fixes: 45cc055588 ("debian: enable xfs_scrub_all systemd timer services by default")
Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/control |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/debian/control b/debian/control
index 369d11a4e..3f05d4e37 100644
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
 

