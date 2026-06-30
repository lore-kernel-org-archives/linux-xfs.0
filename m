Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27FF86334
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781376; cv=none; b=dR9zQdRm46qNsjn9U7fYFBxwXpvjBOfk+TVM5SSNVn4McAEbBNRL3rb8YiyyaXcmYOw/sfpegFvom9Fwt4ko8eVureyU3ebK5fSPaAemcjYKngkwIIVKa/enX/CvCyy7RXV+SOWbVj0t+dPdgspzb7dtq7Czib2NzX4Ympb6S5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781376; c=relaxed/simple;
	bh=+GNX1cWDG5nUvbGALTd9Ekt7222wuVTCKg0mWFtotCE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DFuxhD3Z8nIJ7O1KQn0k20zNdpgF49ijTZowHTpPABJ7Uhu3ldrPCoKlibkCxoALjYtdDD3JG0mqqkJVWZ6yrnlnTqVLlAWuWY8f04e26G5U89P9bOnT2yPml6Drfc92RRgzH4QI2aE5zzPnME+uIo3oeETTZ2v9CDkOaB+rLYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ICM8ii+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ICM8ii+A"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 854171F000E9;
	Tue, 30 Jun 2026 01:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781375;
	bh=KvVI3rkQ0Nn2KOZnLclyoP9B3t2MAM9z+GVSQuRrTlU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ICM8ii+AZqYl+ajSLlyM1W9Emyprg38I3fNGu2eH1G1b+z46KQIWfXb1vPL/GnGV5
	 ZN8ap1FPkO8/koNUBYUi0oIwjvvb97/nitPu7MKanX9MvQBegMZQvGHkb4fH/y9Zzg
	 f5bcQHJUWcd3PITSHtBQYJObDYr+E/zbZugaXCZZb7KhD/eiNcJnrcQDdfbq6uOtAb
	 mFOgX67c82qH6cg+iVYrjc7nTQnhPzggwqTtY+FFOhtHC4OHp/ljch+ZwvhduaB/X2
	 va9LqZesiYRzW+PqPacktvX5ksnQP0dRB0vxd4zywcewuHCO01OCVXaoenO6YUl/p5
	 yREI7lx4TwN9A==
Date: Mon, 29 Jun 2026 18:02:55 -0700
Subject: [PATCH 1/6] mkfs: don't redefine DIRT for protofiles
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278129825.858323.6960589915672224202.stgit@frogsfrogsfrogs>
In-Reply-To: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex noticed that the mkfs Makefile redefines DIRT to point only to the
xfs_protofile script.  This overrides the more expansive definition in
buildrules; we should use LDIRT instead.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 6aace700b7b82d ("mkfs: add a utility to generate protofiles")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/Makefile b/mkfs/Makefile
index fb1473324cde7c..16793bdb1e03e3 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -25,7 +25,7 @@ LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
-DIRT = $(XFS_PROTOFILE)
+LDIRT = $(XFS_PROTOFILE)
 
 default: depend $(LTCOMMAND) $(CFGFILES) $(XFS_PROTOFILE)
 

