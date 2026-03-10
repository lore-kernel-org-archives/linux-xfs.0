Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8149E1547C0
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114577; cv=none; b=koEU6MwRJzPxgTy4n1H9hioeVIa8RHOjX2ysaKZ15MbmCHz3vIT/BS03wW5fg6U5/D3Uvy5bWosjYkSuBOmY+ePatlqA5SyYavljFfG+JdB46sSc7ATgcEwy+dq405viLj6UcVfaIDLQddte2Z42UmEKTu+mr1WDmHGosF4TAD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114577; c=relaxed/simple;
	bh=4CjUqy25/f9eu0Yc2dU4tmFlXgTYqay+43I2sX2go8k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OYyhE5yEl9modVz66Scq+jlsJm/gVnvQj/4TrTt4fWakfFq7YBTJzpMcNMJDMl7FlhCsXAAA0DvcaLbjvaS6sLPSp20f3EzetVJMxbFDyzOndOrolPU/oGJrPAPF9haSU8bT5Pk8jylMtBBMn7sNQk/qSo/qJU6mY4lhVWHX79o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWy1Urlf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWy1Urlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5E4C19423;
	Tue, 10 Mar 2026 03:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114577;
	bh=4CjUqy25/f9eu0Yc2dU4tmFlXgTYqay+43I2sX2go8k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OWy1UrlfRhZVFr1y3V2d5rzKStvKkjsvRI1MRL9lfP3Atv1lCpaZ5v1vSloKPtlWg
	 Y8109TPhZyB1HEVZS1/6vMp6QaWaX/9TcwsENqgUMAyX0ZlBnD9uZMqVZpwPloZRja
	 kI6qTk0vTGVMLzyuVjj6B8HPOv/BFH6VdHZgn6HSPGWWmHzHfsDbzAhWJ+wjkfacGU
	 9fbgAPlg3pOUdj3B6wxYLpb0l9W1Ll2yJ686X/ZJagyIl9Aj+g9vz5oVGau9KqqrD7
	 M37HoTl235FOHg5Oj83ogfIlzaVF9H2r5xaOKDINabyxzV28u5lP64Gl1G86Ak/yEI
	 r6aXIsupTRTkg==
Date: Mon, 09 Mar 2026 20:49:36 -0700
Subject: [PATCH 27/28] debian/control: listify the build dependencies
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177311401948.1183235.9806339034108921343.stgit@frogsfrogsfrogs>
In-Reply-To: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
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
 

