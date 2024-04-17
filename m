Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A96C262A3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388719; cv=none; b=n3ZnSAlRR2aZf1l4DBQ8B0+Et/xCAJMjMIxwcsuBjk9nHkSAYinOKN48eAQPEsZ2uWjVqLIJ1Q95wByhzIzKFr1QBcOa9ZKlZbG3DuQQUErPdOwiD8t/KPrsrvMa6W/2s44dgAFWZ0GQAzfj0wl7LVEgrHhrJ5ZjECqYvfQkDu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388719; c=relaxed/simple;
	bh=1HOu4mJol0Bc9rZPWQHkrn+Qdxf53MtZyAdwiDqPCZE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O/Qu7s9cQGM0uv430OdRNqI8DKDCVAW84FuC9KqU7NysU0tLX+PqjzIP+KDCikLXma9Qho4QIxLkE8DUvmsk17Q5llKOyTjJElZNk1Xzjtk+1mFNh434qN9tbVUT/qhHGQv6AuC8zzREeslc/vFJiGviqyE0vV8Aehtrzs9TnSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JEswqRtL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JEswqRtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A2BC072AA;
	Wed, 17 Apr 2024 21:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388718;
	bh=1HOu4mJol0Bc9rZPWQHkrn+Qdxf53MtZyAdwiDqPCZE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JEswqRtL8NwJK+RtTrXXqrFsMbHDCsTO9YOgQqPHxgcwd1q5ijlbjw2/xfyC6O+sq
	 h6fnfpgvUyz0N9Qm1FmpxvBVrYAGRzcYNw5AYJNEq761IJgrPVQCmKF+huXt3zRE8F
	 Qk5pMtteQdLr/zwMz3kB6qEusNi0Z3HKoegrXibDEgKlEa7SXdlSsuDsLhj/zg0jiy
	 +GPW3W/FCqepGkEKh57/EAaeP1AF8oznO6Rtfz9ycz586O5rmj6I5vwVDD1o1OBfJS
	 X6nPVFyJWcqFUaca5spjbSrWdPrqSvIR/p1IZqnDHWCSjU9nyWjRbjPMNj3+LSgrez
	 MhVnROL3/K09A==
Date: Wed, 17 Apr 2024 14:18:38 -0700
Subject: [PATCH 2/2] libxfs: fix incorrect porting to 6.7
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338841109.1852814.13493721733893449217.stgit@frogsfrogsfrogs>
In-Reply-To: <171338841078.1852814.8154538108927404452.stgit@frogsfrogsfrogs>
References: <171338841078.1852814.8154538108927404452.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/check.c            |    1 -
 include/libxfs.h      |    4 ++++
 libxfs/Makefile       |    1 +
 libxfs/xfs_rtbitmap.c |    2 +-
 libxfs/xfs_rtbitmap.h |    3 ---
 repair/rt.c           |    1 -
 6 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/db/check.c b/db/check.c
index 9d5576c33..a47a5d9cb 100644
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
index 9cec394ca..aeec2bc76 100644
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
index 010ee68e2..6f688c0ad 100644
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
index 8f313339e..fb0834990 100644
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
index db2f8c924..c0637057d 100644
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
index abe58b569..9f3bc8d53 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -13,7 +13,6 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "rt.h"
-#include "xfs_rtbitmap.h"
 
 #define xfs_highbit64 libxfs_highbit64	/* for XFS_RTBLOCKLOG macro */
 

