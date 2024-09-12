Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA28146A6F
	for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2024 07:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126713; cv=none; b=q9UqnnA3ODtlFiO/jZOUpqi8w4OV6SQH8hU8VG3dfHR43cRi+EE30dAwqaPoxJnQpFudoa7m7vehYU3zXaRw6TvSb5/ToU2+yt6p2fbuGQdSdK9wY6ljBmlcsGN4h5cwX2T4lxfTBN0anvK4QUWwctYWvklxAvhCp0aXUcBBoyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126713; c=relaxed/simple;
	bh=shLuShbGH6AVyDVWwgvH2wf9wM8sktJp22m8GARk3NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrJk+RrG7GuxHj29U0TcHximDPWlCZZFurvmkSUUmr2iWCq+w07rWLT+Ihhmh5ehQK+6B1IFjg/HyXHO4rrb29i7VLJVa6iid+KgeJtLZs8JDatHUe5d3PZTAMxrPkrjjcKzARUmoWf9qLcsF3cetmfZQdgrqK7UWsC8TKXI3Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=eiMCWX9D; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="eiMCWX9D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ZtGUFZhluE3W+4u8Vhr1uhtKccBmELzd/T9yYcBhA3I=; b=eiMCWX9DI1dxx2rkh5JbYmf/jk
	HmstnfNgGmV94hXYSEuIgJ8Ymg5QwQiGq8gKfqUvUqJgs6ZZGcHYl8PoRHekasUGiaTwNsxntGlWb
	kLoAVM8F7ezvU/o/Aws96QMmcpjocs31gyqC8ljYeV3N0bMnOMp7R8F2hKTbzwAEPy6Tp3qj5m7/9
	qpyFjq/9ifIlkWw+lFTQKA+BXYILMHOHwz6ikfPdJHXwDSOhMKHc45C7Pad61on4kq4OcxDsUh51A
	UyKW+1S9jOVWvWSzFwsEtxrw+H4owv9pxoc7BmXOZNNwaA5HfgrAjh2XcIfaLeA9Jm8Q00MOxR9T+
	D3sMIlkQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1soe8X-005cqi-Jl; Thu, 12 Sep 2024 07:21:05 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH 4/6] debian: Add Build-Depends: systemd-dev
Date: Thu, 12 Sep 2024 09:20:51 +0200
Message-ID: <20240912072059.913-5-bage@debian.org>
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

Signed-off-by: Bastian Germann <bage@debian.org>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 369d11a4..c3c6b263 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
-Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev
+Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev, systemd-dev
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
-- 
2.45.2

