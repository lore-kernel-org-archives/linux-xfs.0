Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBFE8627C
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929232; cv=none; b=H2Rpoow0cCJ7qp+xrFKjIYL4xFUJm3VRUHcW+Mv0dG/MdNiM/DS8C4+0F95g6zBeAqD+BrrgD5wtJcTK0a2Xz7MhtNrkEE/qtGa+t6XAloEbYirRtjEinwEwCechEjD/JRGVLKzBmJzF58temA4cfBbsolWTyQWXqrtWI3jLdIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929232; c=relaxed/simple;
	bh=baQ4rwMQAB20XOyKNeQIJ9d1TO4QRGd4i/h7JF2QsKo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CsLNvRhlt9nW/tsQT61EWbWOBU/yXwIr3DXTLAioizIsvK4QV0TRHsqptY5dxNpOrCr4J75ChQE3ckpZST6qFKV4BA/r5Z+W7g2YYx+juvzzgBUFyev+69ybjAACkF4RbxUBFrfZJyUPF5W6oOX0aFSPwM4Ilnlto2sIPYHJVGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3gg3LAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3gg3LAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CABC116B1;
	Wed, 24 Apr 2024 03:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929232;
	bh=baQ4rwMQAB20XOyKNeQIJ9d1TO4QRGd4i/h7JF2QsKo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V3gg3LAaF5YE/XKLZEvT0h1MBIvVQ2HDjYY9lircsN3KG47kkyeSBuWB7on25c7BN
	 I8O1Z9SpEbLP7dzqNtfH0kYBVrKbm4FXtrlJiCI4AJesfc/UeDyH7J5/woNU1P/hxS
	 Pu1yd3HSCmUeLv6JN0fIrCFVSKHl+rjPbigb7LAj8R4Cvlp+e2u4vo/Q/a/6kCtiil
	 ajDohKbSH8LVZqc3PKGud/pJZ16Co6Glq+On6xQZpR2J95DkbEldkzLEVKakL7kiUl
	 5rxsh1BTdtYXHTatmBo7BpglLTdMoOuSyDMjimh7TKeIAIuNWmW6R/pMCJkhrvDM8L
	 CTZgelJVbrJJw==
Date: Tue, 23 Apr 2024 20:27:12 -0700
Subject: [PATCH 3/4] xfs: report directory tree corruption in the health
 information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392785305.1906995.688537266404392380.stgit@frogsfrogsfrogs>
In-Reply-To: <171392785243.1906995.3930834516122962087.stgit@frogsfrogsfrogs>
References: <171392785243.1906995.3930834516122962087.stgit@frogsfrogsfrogs>
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
index 85f2a7e20ac0..7ae1912cdbfc 100644
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
index 3c64b5f9bd68..b0edb4288e59 100644
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
index 9020a6bef7f1..b712a8bd34f5 100644
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
index b39f959146bc..10f116d093a2 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -470,6 +470,7 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_BMBTA_ZAPPED,	XFS_BS_SICK_BMBTA },
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
+	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
 	{ 0, 0 },
 };
 

