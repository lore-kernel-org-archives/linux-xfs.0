Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5207931D730
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 15:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087879; cv=none; b=W/dARIW+tPmaHehpZUyQhPziFvF57xXGgDDhGgd2LA/b1f4KYau5vfe0DfDGrqD4+/RW4/ccZT/upT6ctGjUh03/SiUdqNLizdXkziqQumaFaAzKgi/VwzUjkQ0vnN0DPPCexwHc1QsmifOts3QqMWp9/suE+Rz0lCDbdjkCX34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087879; c=relaxed/simple;
	bh=LOLys5Ka3hEg28sDjQxR9THHbnEFqtHtb2zHRU7L/hQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lukZnwCtJVRMz2Aw9eBHwOftW0ROBjkKgpnoh1YjNifUCcI+P1sLmKzyA6BOLGnTHQ7wZ25cg4TgG32lVf5T5QbgFtnhX1IGNQop+j5Mlol/1A9FCmGNEqUClZ04VgUJYGtWoCDq0n4hOBIRTbZnALn89R7Yu6eDb6JUX2B0vTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlGMZW/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlGMZW/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AE2C4CEF1;
	Fri,  5 Sep 2025 15:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757087878;
	bh=LOLys5Ka3hEg28sDjQxR9THHbnEFqtHtb2zHRU7L/hQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QlGMZW/+UjXOFC3o1UQ0nqMH7fGXfPbJNAhtuziRjztztATD+myJ5xFxRFxAhxMhp
	 w1aQoCKjQSzQ+KLMm4heg/4myX5p+0iXlhPTMG0u7S1RoCCTgBM6XP7uO6hywAGzsn
	 SvTZZD9DaW3NuLNAk3RJNbP+mC/7lEhyIehTcH6gJ/EbXEfEmj1cWqz1bFpsUgnPQG
	 4v9HMzpAC3ytOsFZQV9FFHKYKtBICdyWlqpT3MczC9DWv+4rDAMzYAYIMPPjJNiVrW
	 8ZEzIO5vbFpjjXZoSiwV3HYz8qFhMweE+kQqtRPHDrAxKAHJT9HssUtF5h6D7gACec
	 d7KNYkDaNb9Tw==
Date: Fri, 05 Sep 2025 08:57:58 -0700
Subject: [PATCH 1/4] xfs: disable deprecated features by default in Kconfig
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <175708765505.3402932.2730397448607822213.stgit@frogsfrogsfrogs>
In-Reply-To: <175708765462.3402932.11803651576398863761.stgit@frogsfrogsfrogs>
References: <175708765462.3402932.11803651576398863761.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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
 

