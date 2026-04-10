Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6C834752D
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801890; cv=none; b=IcpAJD3pLACXOsraUa2gE2Rs/mAiPmRe2tsINALN9mlk596obwjWvi3AzTdR3c6a9zQfadYdwEYQU6GAg1q+geFwFDYsf0Y/1DDIzxmw/qu3rVgVOEQj3hz/d/EfPFYpYr17XorL3LIfunKSssuA2hWuw/bemfBd1qiY2LaIj1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801890; c=relaxed/simple;
	bh=ul2P4uwREAEaSkUMrSOjoA8Wlc68OlAyu07r3jjHiw4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fvwuwyKk8JoXxTluQcEe7Z2Z5xQf94u6Pjtt3g+FKenI71Bt7trpvW3+MG3j5qWfmUvpAmuIBX2l4afbAqfuzb3vvY0/mNZi133RvmR629wy9bagf1TBbYfiiajguUB+jbN0puPhOZ2j5VSOu6M4vWx8xNWq/UC+Wai/6TC4AnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KHeXMdPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KHeXMdPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294E3C19421;
	Fri, 10 Apr 2026 06:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801890;
	bh=ul2P4uwREAEaSkUMrSOjoA8Wlc68OlAyu07r3jjHiw4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KHeXMdPjs8zg1C+AX7SS1oDRLM+pEbdrQuE8HPSadrBcV32+cFd4HFXo9WMDwYBCC
	 eAlhR9TGk5VNx0sPcCUsZoNJE7SuYGsPiTI0zOJaIl4pYXlUVMmNACGcAg+fJQhXA/
	 nK0YZXRU7FHRAuuNRPvp5BBng41dAZZoyS1o6f5WseSQGZsXNE1ZG8RCI32zolIi4P
	 sInc4cVV8vk5n63/HMATho1QkEAvoF1j1UtPJwmYlgdxszpCxvLEEVazdzDw3uTqH7
	 abXogFG86uh0HmIkuHUO1nZySI/cUpRB3+tku7hSoB2TllWJzma0AZ6IREmTnhfztr
	 JNpFb7tn1x3yA==
Date: Thu, 09 Apr 2026 23:18:09 -0700
Subject: [PATCH 03/21] libfrog: lift *BYTES helpers to convert.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385086.2090237.2179698269233909604.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
References: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move these byte unit conversion macros to convert.h and amend the macros
to cast to unsigned long long to avoid shifting issues.  Now we can use
these same macros throughout the codebase instead of opencoding shifts
and possibly suffering from integer shifting problems.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/convert.h         |    7 +++++++
 db/bmap_inflate.c         |    2 +-
 libfrog/convert.c         |    7 -------
 mdrestore/xfs_mdrestore.c |    5 +++--
 mkfs/xfs_mkfs.c           |    5 +++--
 repair/agbtree.c          |    3 ++-
 repair/bmap_repair.c      |    3 ++-
 repair/xfs_repair.c       |    5 +++--
 scrub/common.c            |   17 +++++++++--------
 scrub/phase8.c            |    3 ++-
 10 files changed, 32 insertions(+), 25 deletions(-)


diff --git a/libfrog/convert.h b/libfrog/convert.h
index 3e5fbe055986a4..223d3e73c9422b 100644
--- a/libfrog/convert.h
+++ b/libfrog/convert.h
@@ -22,4 +22,11 @@ extern uid_t	uid_from_string(char *user);
 extern gid_t	gid_from_string(char *group);
 extern prid_t	prid_from_string(char *project);
 
+#define EXABYTES(x)	((unsigned long long)(x) << 60)
+#define PETABYTES(x)	((unsigned long long)(x) << 50)
+#define TERABYTES(x)	((unsigned long long)(x) << 40)
+#define GIGABYTES(x)	((unsigned long long)(x) << 30)
+#define MEGABYTES(x)	((unsigned long long)(x) << 20)
+#define KILOBYTES(x)	((unsigned long long)(x) << 10)
+
 #endif	/* __LIBFROG_CONVERT_H__ */
diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
index 1de6d3439ab3d3..cc7c197e788d7f 100644
--- a/db/bmap_inflate.c
+++ b/db/bmap_inflate.c
@@ -437,7 +437,7 @@ bmapinflate_f(
 	struct xfs_trans	*tp;
 	char			*p;
 	unsigned long long	nextents = 0;
-	unsigned long long	dirty_bytes = 60U << 20; /* 60MiB */
+	unsigned long long	dirty_bytes = MEGABYTES(60);
 	unsigned long long	dirty_blocks;
 	unsigned int		resblks;
 	bool			estimate = false;
diff --git a/libfrog/convert.c b/libfrog/convert.c
index 0ceeb389682ae1..65b9e47459e234 100644
--- a/libfrog/convert.c
+++ b/libfrog/convert.c
@@ -173,13 +173,6 @@ cvt_u16(
 	return i;
 }
 
-#define EXABYTES(x)	((long long)(x) << 60)
-#define PETABYTES(x)	((long long)(x) << 50)
-#define TERABYTES(x)	((long long)(x) << 40)
-#define GIGABYTES(x)	((long long)(x) << 30)
-#define MEGABYTES(x)	((long long)(x) << 20)
-#define KILOBYTES(x)	((long long)(x) << 10)
-
 long long
 cvtnum(
 	size_t		blksize,
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 8858026c87dc97..ce7f596a6184fe 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -8,6 +8,7 @@
 #include "xfs_metadump.h"
 #include <libfrog/platform.h>
 #include "libfrog/div64.h"
+#include "libfrog/convert.h"
 
 union mdrestore_headers {
 	__be32				magic;
@@ -92,10 +93,10 @@ final_print_progress(
 	if (!mdrestore.show_progress)
 		goto done;
 
-	if (bytes_read <= (*cursor << 20))
+	if (bytes_read <= MEGABYTES(*cursor))
 		goto done;
 
-	print_progress("%lld MB read", howmany_64(bytes_read, 1U << 20));
+	print_progress("%lld MB read", howmany_64(bytes_read, MEGABYTES(1)));
 
 done:
 	if (mdrestore.progress_since_warning)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e0f0bb28e12159..dd8a48c3633ef0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -15,6 +15,7 @@
 #include "libfrog/dahashselftest.h"
 #include "libfrog/fsproperties.h"
 #include "libfrog/zones.h"
+#include "libfrog/convert.h"
 #include "proto.h"
 #include <ini.h>
 
@@ -558,7 +559,7 @@ static struct opt_params iopts = {
 		  .conflicts = { { NULL, LAST_CONFLICT } },
 		  .convert = true,
 		  .minval = 1,
-		  .maxval = 1ULL << 30, /* 1GiB */
+		  .maxval = GIGABYTES(1),
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 	},
@@ -1576,7 +1577,7 @@ discard_blocks(int fd, uint64_t nsectors, int quiet)
 {
 	uint64_t	offset = 0;
 	/* Discard the device 2G at a time */
-	const uint64_t	step = 2ULL << 30;
+	const uint64_t	step = GIGABYTES(2);
 	const uint64_t	count = BBTOB(nsectors);
 
 	/*
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 983b645e1a35a3..fe28e5e94c575e 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -6,6 +6,7 @@
 #include <libxfs.h>
 #include "err_protos.h"
 #include "libfrog/bitmap.h"
+#include "libfrog/convert.h"
 #include "slab.h"
 #include "rmap.h"
 #include "incore.h"
@@ -23,7 +24,7 @@ init_rebuild(
 	memset(btr, 0, sizeof(struct bt_rebuild));
 
 	bulkload_init_ag(&btr->newbt, sc, oinfo, NULLFSBLOCK);
-	btr->bload.max_dirty = XFS_B_TO_FSBT(sc->mp, 256U << 10); /* 256K */
+	btr->bload.max_dirty = XFS_B_TO_FSBT(sc->mp, KILOBYTES(256));
 	bulkload_estimate_ag_slack(sc, &btr->bload, est_agfreeblocks);
 }
 
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 5d1f639be81ff4..192f189de05217 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -15,6 +15,7 @@
 #include "bulkload.h"
 #include "bmap_repair.h"
 #include "libfrog/util.h"
+#include "libfrog/convert.h"
 
 /*
  * Inode Fork Block Mapping (BMBT) Repair
@@ -499,7 +500,7 @@ xrep_bmap_btree_load(
 	rb->bmap_bload.get_records = xrep_bmap_get_records;
 	rb->bmap_bload.claim_block = xrep_bmap_claim_block;
 	rb->bmap_bload.iroot_size = xrep_bmap_iroot_size;
-	rb->bmap_bload.max_dirty = XFS_B_TO_FSBT(sc->mp, 256U << 10); /* 256K */
+	rb->bmap_bload.max_dirty = XFS_B_TO_FSBT(sc->mp, KILOBYTES(256));
 
 	/*
 	 * Always make the btree as small as possible, since we might need the
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 7bf75c09b94542..6b97a806384096 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -28,6 +28,7 @@
 #include "quotacheck.h"
 #include "rcbag_btree.h"
 #include "rt.h"
+#include "libfrog/convert.h"
 
 /*
  * option tables for getsubopt calls
@@ -1321,8 +1322,8 @@ main(int argc, char **argv)
 		}
 
 		max_mem -= mem_used;
-		if (max_mem >= (1 << 30))
-			max_mem = 1 << 30;
+		if (max_mem >= GIGABYTES(1))
+			max_mem = GIGABYTES(1);
 		libxfs_bhash_size = max_mem / (HASH_CACHE_RATIO *
 				(igeo->inode_cluster_size >> 10));
 		if (libxfs_bhash_size < 512)
diff --git a/scrub/common.c b/scrub/common.c
index a567d2a3c2f14e..34d91525928305 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -11,6 +11,7 @@
 #include "libfrog/paths.h"
 #include "libfrog/getparents.h"
 #include "libfrog/handle_priv.h"
+#include "libfrog/convert.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "progress.h"
@@ -218,18 +219,18 @@ auto_space_units(
 {
 	if (debug > 1)
 		goto no_prefix;
-	if (bytes > (1ULL << 40)) {
+	if (bytes > TERABYTES(1)) {
 		*units = "TiB";
-		return (double)bytes / (1ULL << 40);
-	} else if (bytes > (1ULL << 30)) {
+		return (double)bytes / TERABYTES(1);
+	} else if (bytes > GIGABYTES(1)) {
 		*units = "GiB";
-		return (double)bytes / (1ULL << 30);
-	} else if (bytes > (1ULL << 20)) {
+		return (double)bytes / GIGABYTES(1);
+	} else if (bytes > MEGABYTES(1)) {
 		*units = "MiB";
-		return (double)bytes / (1ULL << 20);
-	} else if (bytes > (1ULL << 10)) {
+		return (double)bytes / MEGABYTES(1);
+	} else if (bytes > KILOBYTES(1)) {
 		*units = "KiB";
-		return (double)bytes / (1ULL << 10);
+		return (double)bytes / KILOBYTES(1);
 	}
 
 no_prefix:
diff --git a/scrub/phase8.c b/scrub/phase8.c
index e8c72d8eb851af..0967832da890e3 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -12,6 +12,7 @@
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
 #include "libfrog/histogram.h"
+#include "libfrog/convert.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "progress.h"
@@ -51,7 +52,7 @@ fstrim_ok(
  * call so that we can implement decent progress reporting and CPU resource
  * control.  Pick a prime number of gigabytes for interest.
  */
-#define FSTRIM_MAX_BYTES	(11ULL << 30)
+#define FSTRIM_MAX_BYTES	GIGABYTES(11)
 
 /* Trim a certain range of the filesystem. */
 static int

