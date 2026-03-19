Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E004317D
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895517; cv=none; b=sbenpAzxrGPXsRiBqq9lSpoeff5TbSR29GgRQSMQIK622GDzlg5GNsN0mxy1cIcF8mfBfGN9JJ6YNykPuAne6LnXfRExMiZV4GzS2WWEPz9Gc0gpFYtLa/LzOrBTQPu+tVD6Wnyrm82rXaf6rrFA8oq0d17/O5cao85dhSoZ8u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895517; c=relaxed/simple;
	bh=iyBWmjpM9CVRxZL+/9IGx4/oTLeFwTWenUkVIUkUBQ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z7+vKyjyzq7+A8AwaMZIBRKuNRiRPA5Q1z9/AO/wtcUy9+kz9qP8u2IWLDOg3jssHwKHEaikshJLq+9Fo/5drkOla82hlDhJVTLZVgUpCu3D8OS0cNQy4djoFAEmyLLFytHzHgdGvFS69B1oW9YylLAuwksR+VuV+q8MtXIkpfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cyygscxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cyygscxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955EEC19425;
	Thu, 19 Mar 2026 04:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895516;
	bh=iyBWmjpM9CVRxZL+/9IGx4/oTLeFwTWenUkVIUkUBQ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cyygscxvVqCBMscTM72bXoEv5BHqAHSM1EPRZ5WFVYqcDQ/TTKeyMJILuXkr0MoED
	 rHC8rqM7AkGGlgtyTmHqcVkGbzVah/TgUuU1UUUj1xyqhkUYe52kU2UEJCjOATsXfE
	 meBovza358KxUozZOs8faY8LqQhDe/x3ytslPa0mVKYRGZx0Wv4LBcHRl4KAia1Pe/
	 j+k67wVTxP/uMDPDjMB3hANJUckYoe73rv87pU/JaumCKuXLdPyWw8DHAGSprvOT+5
	 LcWtGBcodHCs4/yAoXzvEbO3t/wq7RUIO9LCXIwqa3dULX1/C1YL8dPirDvgOsqUVF
	 4jbrXinmzQGOQ==
Date: Wed, 18 Mar 2026 21:45:16 -0700
Subject: [PATCH 25/26] debian/control: listify the build dependencies
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389506606.3680139.10499527435228267095.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
References: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
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
 

