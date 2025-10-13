Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7962E7BCB;
	Mon, 13 Oct 2025 08:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760345332; cv=none; b=Me96ufvr7769lGmy/g9CTKYCqIWvkilU7eBpb4mge7u4AU70vhcJLKG42DsS1JXTId6SMN6jwLD62SedqsWVM74WgKlvwesKvQSIubT7m3HPaeSk7cr4IK7GLXNzRySnKnLeqBeaq70069bY5x8w5YCuNATUiCBpQoyw3YrpZ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760345332; c=relaxed/simple;
	bh=YJIu6cspiwXLIdmdn+frs0d2h9M2EjmqJZTPSX90lAY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lR4yaCRIsWsGQsANAJbgPziLFqI9OISYauYbRaSi26kmDNTtwrMh6DNHL9/yTVHoMdbzWbayrHpGwk7PfbUTePI3dwak5iZLfRrYJsk87ajsHKq/c/x0en7EBms/O322i66mLlNESkUZtAf9TDjNA4RWhczA2wTENnzvRb7KPPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975A4C4CEE7;
	Mon, 13 Oct 2025 08:48:49 +0000 (UTC)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] xfs: XFS_ONLINE_SCRUB_STATS should depend on DEBUG_FS
Date: Mon, 13 Oct 2025 10:48:46 +0200
Message-ID: <69104b397a62ea3149c932bd3a9ed6fc7e4e91a0.1760345180.git.geert@linux-m68k.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, XFS_ONLINE_SCRUB_STATS selects DEBUG_FS.  However, DEBUG_FS
is meant for debugging, and people may want to disable it on production
systems.  Since commit 0ff51a1fd786f47b ("xfs: enable online fsck by
default in Kconfig")), XFS_ONLINE_SCRUB_STATS is enabled by default,
forcing DEBUG_FS enabled too.

Fix this by replacing the selection of DEBUG_FS by a dependency on
DEBUG_FS, which is what most other options controlling the gathering and
exposing of statistics do.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/xfs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 8930d5254e1da61d..402cf7aad5ca93ab 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -156,7 +156,7 @@ config XFS_ONLINE_SCRUB_STATS
 	bool "XFS online metadata check usage data collection"
 	default y
 	depends on XFS_ONLINE_SCRUB
-	select DEBUG_FS
+	depends on DEBUG_FS
 	help
 	  If you say Y here, the kernel will gather usage data about
 	  the online metadata check subsystem.  This includes the number
-- 
2.43.0

