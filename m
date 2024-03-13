Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F14AD21
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294596; cv=none; b=h+AB1JnbX2OJwZ7o9TvIc+MmH4d0KwavFAcfrEgcrtzdfVrie0sAkNkegmZ8EZCGepyIpBcgd8qD79zdcQYH/1U6nm1U5VB2YscsNj5cF5hGVIJWhga5hBAf2HlDuMV2I4D1LJDiH8Ng3DgIGle7YHoLfnDIkDgVbWPfKtmskys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294596; c=relaxed/simple;
	bh=s6woYzCUTsCENEvtxyEbY3QEDoMGAvwyUx94Sob+u7E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DmTSTFSolD8w+8TSOuGF0BgiSRRwRW2BemVz4i8ZUF/6Z/DBYvaFbVY86ZwnTfcupX7lX/Er7FPJeElHK9VEgJFnfOgg0h45VktkGBYQLqTQxLCers6aWfXE9CoMc3imdKH6k5FPuwjw/0nhP9/h+XzyYQsTu0ELAwOe5hcp4Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4G5+4GO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4G5+4GO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB260C433C7;
	Wed, 13 Mar 2024 01:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294595;
	bh=s6woYzCUTsCENEvtxyEbY3QEDoMGAvwyUx94Sob+u7E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h4G5+4GOjbwRoQ/++oDVKTXpvIfpjVoURJQiNNERVsEtNnuF8gNHjAbPIjOFIkQKX
	 gQT6k5mzKd8MAeSXPBSvIY/9AIbvRlMWIkWBAo8/DjflslME6/oIwHyZSBJdKrlyQh
	 zPIITbd24bvr5JPD0FlmilV6sti/Nf5qXLTJQJrMqoBs9h+7eFswbqKppEGZdYDs8z
	 xS1PHQOVxIx20MTSTytNoMuuzfj+U6+BjEQdcAqJbK+P/CnQ+/a4+ATej6vD9V5Qla
	 5dAuK3mCAmb5DRz7W54dlRjx8diig6SVZiuSbv7g2khJNmLnSTVlk9paio+RCqWFCe
	 IZ9E4vRY9Y3aw==
Date: Tue, 12 Mar 2024 18:49:55 -0700
Subject: [PATCH 01/13] libxfs: fix incorrect porting to 6.7
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029430572.2061422.5338863572852946572.stgit@frogsfrogsfrogs>
In-Reply-To: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
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

Userspace libxfs is supposed to match the kernel libxfs except for the
preprocessor include directives.  Fix a few discrepancies that came up
for whatever reason.

To fix the build errors resulting from CONFIG_XFS_RT not being defined,
add it to libxfs.h and alter the Makefile to track xfs_rtbitmap.h.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c            |    1 -
 include/libxfs.h      |    4 ++++
 libxfs/Makefile       |    1 +
 libxfs/xfs_rtbitmap.c |    2 +-
 libxfs/xfs_rtbitmap.h |    3 ---
 repair/rt.c           |    1 -
 6 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/db/check.c b/db/check.c
index 9d5576c333b2..a47a5d9cb5b4 100644
--- a/db/check.c
+++ b/db/check.c
@@ -20,7 +20,6 @@
 #include "init.h"
 #include "malloc.h"
 #include "dir2.h"
-#include "xfs_rtbitmap.h"
 
 typedef enum {
 	IS_USER_QUOTA, IS_PROJECT_QUOTA, IS_GROUP_QUOTA,
diff --git a/include/libxfs.h b/include/libxfs.h
index 9cec394ca407..aeec2bc76126 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -7,6 +7,9 @@
 #ifndef __LIBXFS_H__
 #define __LIBXFS_H__
 
+/* For userspace XFS_RT is always defined */
+#define CONFIG_XFS_RT
+
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"
 #include "xfs.h"
@@ -80,6 +83,7 @@ struct iomap;
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
+#include "xfs_rtbitmap.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 010ee68e2292..6f688c0ad25a 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -50,6 +50,7 @@ HFILES = \
 	xfs_refcount_btree.h \
 	xfs_rmap.h \
 	xfs_rmap_btree.h \
+	xfs_rtbitmap.h \
 	xfs_sb.h \
 	xfs_shared.h \
 	xfs_trans_resv.h \
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 8f313339e97f..fb083499070c 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -931,7 +931,7 @@ xfs_rtcheck_alloc_range(
  */
 int
 xfs_rtfree_extent(
-	xfs_trans_t		*tp,	/* transaction pointer */
+	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_rtxnum_t		start,	/* starting rtext number to free */
 	xfs_rtxlen_t		len)	/* length of extent freed */
 {
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index db2f8c924b05..c0637057d69c 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -6,9 +6,6 @@
 #ifndef __XFS_RTBITMAP_H__
 #define	__XFS_RTBITMAP_H__
 
-/* For userspace XFS_RT is always defined */
-#define CONFIG_XFS_RT
-
 struct xfs_rtalloc_args {
 	struct xfs_mount	*mp;
 	struct xfs_trans	*tp;
diff --git a/repair/rt.c b/repair/rt.c
index abe58b569c0c..9f3bc8d53ec6 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -13,7 +13,6 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "rt.h"
-#include "xfs_rtbitmap.h"
 
 #define xfs_highbit64 libxfs_highbit64	/* for XFS_RTBLOCKLOG macro */
 

