Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0EA5227
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231670; cv=none; b=heJodT2EQ805VLQIEe9U+mJdWFwGrbfq1wuyvUaiISyL49Io8nMUuK82xhpM3ppubu0oeuJey2UT93L6hGBwoN0t4UXUC7FtOHYLtmiA+iqoQsAHNYqjSKYEDVjqSGQzCEfPheiUyJhIe+pX9sTjOdBPPpAISNWUAVAjtCGaeiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231670; c=relaxed/simple;
	bh=/OzjEzbId1a+fRkfwH8DNRvByIoCpFyD8eOye3/ayOw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ndx3bxx7UuXIWtxSgAaa9NZ+nQakJBspE3non9T7WJdz8Y/pryNHf6Q3P0xxnpC8KtHiAQYf4d7Cl+AJP9GsJa4bcGN0OPdl+oyT9zJsbLbIwQkCB5abZ/tn4j73zaoPsat7V55gLiIpocmNGZ9iooKIOh7nRiZdyagltzaKm68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTY06g72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTY06g72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B48C113CC;
	Tue, 16 Apr 2024 01:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231670;
	bh=/OzjEzbId1a+fRkfwH8DNRvByIoCpFyD8eOye3/ayOw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UTY06g72ML5C6ZawDcR+feYPjcgRDioZGUiEauCbZB/vF28paj/MuZF+3TvFW1Cjw
	 Wtgw8ZZkc/DnkLw+8DmRO6dMbqyC5nNLbsOxvhe9FG4wc9+4IN73uxVvW5QWXjMWP9
	 9VOxZOWTC0wWAucvVxeIA2ebJNvmdaMHu5W8bxuBMoYY849Kzt6xmoYG7FvQym9CAa
	 8JBfDkTw8XLFWZpLjgSsuGEVMNL7a6Tpt/e6/xz4LPE2Oyk40tPPpUTDgn6DqTQka+
	 jKNgROIyE+jq3KuPvcnOcoUtd4wdqn0T/Pivmm6ue4AIOEeocDHYqelWic6bCCwrpH
	 nTghSYgchg47Q==
Date: Mon, 15 Apr 2024 18:41:09 -0700
Subject: [PATCH 3/4] xfs: report directory tree corruption in the health
 information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323029864.253678.12452428355250543031.stgit@frogsfrogsfrogs>
In-Reply-To: <171323029803.253678.14863175875387657276.stgit@frogsfrogsfrogs>
References: <171323029803.253678.14863175875387657276.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Report directories that are the source of corruption in the directory
tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h     |    1 +
 fs/xfs/libxfs/xfs_health.h |    4 +++-
 fs/xfs/scrub/health.c      |    1 +
 fs/xfs/xfs_health.c        |    1 +
 4 files changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 9a2697f1524c7..cc2ee5e0183d1 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -411,6 +411,7 @@ struct xfs_bulkstat {
 #define XFS_BS_SICK_XATTR	(1 << 5)  /* extended attributes */
 #define XFS_BS_SICK_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
+#define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
 
 /*
  * Project quota id helpers (previously projid was 16bit only
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 3c64b5f9bd681..b0edb4288e592 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -95,6 +95,7 @@ struct xfs_da_args;
 
 /* Don't propagate sick status to ag health summary during inactivation */
 #define XFS_SICK_INO_FORGET	(1 << 12)
+#define XFS_SICK_INO_DIRTREE	(1 << 13)  /* directory tree structure */
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -125,7 +126,8 @@ struct xfs_da_args;
 				 XFS_SICK_INO_DIR | \
 				 XFS_SICK_INO_XATTR | \
 				 XFS_SICK_INO_SYMLINK | \
-				 XFS_SICK_INO_PARENT)
+				 XFS_SICK_INO_PARENT | \
+				 XFS_SICK_INO_DIRTREE)
 
 #define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
 				 XFS_SICK_INO_BMBTA_ZAPPED | \
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 9020a6bef7f14..b712a8bd34f54 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -108,6 +108,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_FSCOUNTERS]	= { XHG_FS,  XFS_SICK_FS_COUNTERS },
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= { XHG_FS,  XFS_SICK_FS_QUOTACHECK },
 	[XFS_SCRUB_TYPE_NLINKS]		= { XHG_FS,  XFS_SICK_FS_NLINKS },
+	[XFS_SCRUB_TYPE_DIRTREE]	= { XHG_INO, XFS_SICK_INO_DIRTREE },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index b39f959146bc1..10f116d093a22 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -470,6 +470,7 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_BMBTA_ZAPPED,	XFS_BS_SICK_BMBTA },
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
+	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
 	{ 0, 0 },
 };
 

