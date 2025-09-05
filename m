Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B53831D750
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 15:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087926; cv=none; b=b9zudVFGQMJwMZbdx03cUrINuclSpmGlb798uHa58GAfRE1uNm+72fCKnVofm+JK94QFSSqdRuPJFMwImV9/MmX9WvfeoIE4XpixYhT5g6LalAgTilcVjRDYuCCYkhinvUCqFJo2Wwo5ydyoV3M4FnU/SClr7jaZiLeya5zPA38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087926; c=relaxed/simple;
	bh=JMm+96Oo2GuyPG6kRXlwWZndkonbQMdAoZyG5TPuBnE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fdj64eoIODd9YoYWTjh8z3jz/MA3N2nug4ZhuXBJxiPBDJ0mJTg7wnXITExXDZXm+8c7PjIceJuggk+DzrUARQX/JJi2NUFW/7+R40rynS+nnslSlZPlNZPg8nkFq9IAI9xZz1E3Boi8tJN2gRPjN4gvluGoLvzChEZqAI/0Ry0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MRpscEuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MRpscEuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9014C4CEF1;
	Fri,  5 Sep 2025 15:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757087925;
	bh=JMm+96Oo2GuyPG6kRXlwWZndkonbQMdAoZyG5TPuBnE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MRpscEuh48uRJzk+xs4cON/ijRSWOSlryHrf6TdVHDsupid+qgWBr730q7OUDxSn6
	 JDjhksHpu0VX/kaHijxpUs8j/rh+/sKPaGTp3Etvj7m8tKe89YaMSIlgsd/5juA6fn
	 zxEpp/bswr+Zs20RiOgNfxYQfqFA/EOLhvsJvJB+bOptKz1sgaRpRq2wCqnnYD0URI
	 r3+ST0H8I9QxzOvCq+qEeewHKeB8yJe0P78zl2OR+EoU2B9P1xSkbbw8rqAjdcMcDZ
	 0iISRcHRvWyHucb8CffTaYc6wHyK4sNyyZ1Sj2kg0m5qSx3Q991foZVVHumkbluREw
	 wzkZy9+1DILhQ==
Date: Fri, 05 Sep 2025 08:58:45 -0700
Subject: [PATCH 4/4] xfs: enable online fsck by default in Kconfig
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <175708765570.3402932.7845496331843344570.stgit@frogsfrogsfrogs>
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

Online fsck has been a part of upstream for over a year now without any
serious problems.  Turn it on by default in time for the 2025 LTS
kernel, and get rid of the "say N if unsure" messages for the default Y
options.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/Kconfig |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index ecebd3ebab1342..8930d5254e1da6 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -137,7 +137,7 @@ config XFS_BTREE_IN_MEM
 
 config XFS_ONLINE_SCRUB
 	bool "XFS online metadata check support"
-	default n
+	default y
 	depends on XFS_FS
 	depends on TMPFS && SHMEM
 	select XFS_LIVE_HOOKS
@@ -150,12 +150,8 @@ config XFS_ONLINE_SCRUB
 	  advantage here is to look for problems proactively so that
 	  they can be dealt with in a controlled manner.
 
-	  This feature is considered EXPERIMENTAL.  Use with caution!
-
 	  See the xfs_scrub man page in section 8 for additional information.
 
-	  If unsure, say N.
-
 config XFS_ONLINE_SCRUB_STATS
 	bool "XFS online metadata check usage data collection"
 	default y
@@ -171,11 +167,9 @@ config XFS_ONLINE_SCRUB_STATS
 
 	  Usage data are collected in /sys/kernel/debug/xfs/scrub.
 
-	  If unsure, say N.
-
 config XFS_ONLINE_REPAIR
 	bool "XFS online metadata repair support"
-	default n
+	default y
 	depends on XFS_FS && XFS_ONLINE_SCRUB
 	select XFS_BTREE_IN_MEM
 	help
@@ -186,12 +180,8 @@ config XFS_ONLINE_REPAIR
 	  formatted with secondary metadata, such as reverse mappings and inode
 	  parent pointers.
 
-	  This feature is considered EXPERIMENTAL.  Use with caution!
-
 	  See the xfs_scrub man page in section 8 for additional information.
 
-	  If unsure, say N.
-
 config XFS_WARN
 	bool "XFS Verbose Warnings"
 	depends on XFS_FS && !XFS_DEBUG

