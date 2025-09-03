Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AB830F527
	for <linux-xfs@vger.kernel.org>; Wed,  3 Sep 2025 14:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756911593; cv=none; b=a4UWlF/iq5/cpJZoi10ab0NQOwxCF3JpcdwIs4IXURwPW54bYNDvfQ1dKaEx2zKxxpLqMoPS/4e7CWrRU8i5mtsrzUXdhl/YzoOiTumP+Mof2ZHroSuHhjM1PlEwjrJoR7Lt5FiL4uvdMSHwGnOIrRzUGelLTbvTqU4BeuC7E9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756911593; c=relaxed/simple;
	bh=U+JJ1P2Q2ifkOXWN/uDQcgQ+fpqKvBZUGzyZ+J7M100=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fQmQjmCDe2u/PSHhP5mKi8BKOI/fNCpdcc7BsJnj6Jdqn/El1sFKDy5SdhfXGulS95nphjoDHeRcaKO250vtb+Ff5UakB19NqdwwVuvlCxefbo9L43+zp605k77hJx2Nyk8bcS+nzg5/qHDSTmyhaVjnzz+b6DkMJexFpCO3Yyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kxa4b6Od; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kxa4b6Od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64996C4CEE7;
	Wed,  3 Sep 2025 14:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756911593;
	bh=U+JJ1P2Q2ifkOXWN/uDQcgQ+fpqKvBZUGzyZ+J7M100=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kxa4b6OdPFEQ06WoNPv0atZWRDZgU+lRZbn7WOxLjde+GJhIgDxJxTcN0oQYnrEbs
	 GKEO1dVMuMLSiPDVo+/4mmUejt+qAy6rjHDbMkiTD/po/sfiO6SbmOxpoU91lvKNK1
	 NbtTd2et2k+bEpL+4EcdTVYTI3ZyStVTD6fOnOc+l56CSJggrC4ugqU8rYk2cKP2P4
	 3/kUKjT2VH2TU9UWhOkZRPZM6ETycHakFqFkKWr8SEdEb8rCaAB0s/OsUs+ZXgLTUd
	 Eoao3j2wXcehkZfDU5BGQi+j6t5h1Y5z6PVPuBclrVQEQNugSNKp/zIwWQzOqWIWR+
	 4YYmJkLnucXFw==
Date: Wed, 03 Sep 2025 07:59:52 -0700
Subject: [PATCH 1/4] xfs: disable deprecated features by default in Kconfig
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <175691147647.1206750.9321056429845916872.stgit@frogsfrogsfrogs>
In-Reply-To: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
References: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We promised to turn off these old features by default in September 2025.
Do so now.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 Documentation/admin-guide/xfs.rst |    5 ++---
 fs/xfs/Kconfig                    |    8 ++++----
 2 files changed, 6 insertions(+), 7 deletions(-)


diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index a18328a5fb93be..693b09ca62922f 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -253,9 +253,8 @@ latest version and try again.
 
 The deprecation will take place in two parts.  Support for mounting V4
 filesystems can now be disabled at kernel build time via Kconfig option.
-The option will default to yes until September 2025, at which time it
-will be changed to default to no.  In September 2030, support will be
-removed from the codebase entirely.
+These options were changed to default to no in September 2025.  In
+September 2030, support will be removed from the codebase entirely.
 
 Note: Distributors may choose to withdraw V4 format support earlier than
 the dates listed above.
diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 065953475cf5eb..ecebd3ebab1342 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -25,7 +25,7 @@ config XFS_FS
 config XFS_SUPPORT_V4
 	bool "Support deprecated V4 (crc=0) format"
 	depends on XFS_FS
-	default y
+	default n
 	help
 	  The V4 filesystem format lacks certain features that are supported
 	  by the V5 format, such as metadata checksumming, strengthened
@@ -40,7 +40,7 @@ config XFS_SUPPORT_V4
 	  filesystem is a V4 filesystem.  If no such string is found, please
 	  upgrade xfsprogs to the latest version and try again.
 
-	  This option will become default N in September 2025.  Support for the
+	  This option became default N in September 2025.  Support for the
 	  V4 format will be removed entirely in September 2030.  Distributors
 	  can say N here to withdraw support earlier.
 
@@ -50,7 +50,7 @@ config XFS_SUPPORT_V4
 config XFS_SUPPORT_ASCII_CI
 	bool "Support deprecated case-insensitive ascii (ascii-ci=1) format"
 	depends on XFS_FS
-	default y
+	default n
 	help
 	  The ASCII case insensitivity filesystem feature only works correctly
 	  on systems that have been coerced into using ISO 8859-1, and it does
@@ -67,7 +67,7 @@ config XFS_SUPPORT_ASCII_CI
 	  filesystem is a case-insensitive filesystem.  If no such string is
 	  found, please upgrade xfsprogs to the latest version and try again.
 
-	  This option will become default N in September 2025.  Support for the
+	  This option became default N in September 2025.  Support for the
 	  feature will be removed entirely in September 2030.  Distributors
 	  can say N here to withdraw support earlier.
 

