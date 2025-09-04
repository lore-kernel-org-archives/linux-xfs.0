Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A0E3D3B3
	for <linux-xfs@vger.kernel.org>; Thu,  4 Sep 2025 02:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756953817; cv=none; b=iYNDv2Rirw/mTH7mMg2sTEDogQ7r/VmSppA2EJZx9MIGk6dwR27/6mMIO4Kw5UyeU6tA2yWC2PgOIo+/ZUaQXvLqqJzzEik5ePgVipXPmEWg0/0WD/zTD00Rpcug/fmM26D9R1v0OnJmD9jj6thpvefaBEE4lA7lut1n/DTwWtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756953817; c=relaxed/simple;
	bh=a683GvsHMyhyc+F4Yd6+FL5fGrxU47IMLGuzUm2X+7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MnHlnAasaFORsRppRhFhuHQuqksJqPY1MPlthT/8exWIqJKKdROD914x6zP0mUrCu+DWkLOkPkjyBRnMTX/s/qUSKrOL5NSipn4gq86OjDUjGflcUekbqMupKGcIifzVTidVx+QIqLf1qnUOlDa246zf43o5HuxGy0zQVl0hzZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJHklVNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJHklVNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29558C4CEE7;
	Thu,  4 Sep 2025 02:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756953817;
	bh=a683GvsHMyhyc+F4Yd6+FL5fGrxU47IMLGuzUm2X+7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QJHklVNeBL8BPOtztvoZl8g+EfJF1jFepSSvRtSo8dhprCG9H4YU/mQWmp9ONLXoY
	 p3HpwZSrCI/SfgDgc/gr9fFyy7nFt1IQqDBEJ+o8Xeyh39frbDmnAsd4Mr+4IS8tGG
	 /kHUufXfAghe1kpdnpGHxyZK0VfE0U4ebrQJ/e3kyrV2ZZtJAzW8i1LdYQa26VHuiG
	 nJ3mLM1TOjhCluf3DTG/+wvg2m9gV+p5nYQHOhraMlAbzel1bHCknQUUzcKtIy4MQa
	 7TPI6jjSiWhiGoJl1wEUA+VQH4kyi21Q0TX1NioCiW+Q7dF5mjaLjzBqj9HdKkv5mE
	 spuRZ0eqW+f2Q==
Date: Wed, 3 Sep 2025 19:43:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, vbabka@suse.cz
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v1.1 4/4] xfs: enable online fsck by default in Kconfig
Message-ID: <20250904024336.GL8096@frogsfrogsfrogs>
References: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
 <175691147712.1206750.10415065465026735526.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175691147712.1206750.10415065465026735526.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Online fsck has been a part of upstream for over a year now without any
serious problems.  Turn it on by default in time for the 2025 LTS
kernel, and get rid of the "say N if unsure" messages for the default Y
options.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
v1.1: remove the "if unsure" statements
---
 fs/xfs/Kconfig |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index bd8c073ad251ed..7b341c9de36302 100644
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
