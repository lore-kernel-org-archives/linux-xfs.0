Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4786637708
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 04:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706588844; cv=none; b=VYVFh62ZWfbUeAuI0olX5CctMH0j4XClPnYp7yjikNdDbQsyd7TfYXLSiY7F5ti9TjS7SgXaAbcg3GS5Fpeu2mdoLs7k9UFZe8VVsnTECWFW1WtH3vd2dy39/JLd7blP/vueueGDW387ppEWuElD+lNSYAqBv3ftza/SWn8T00Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706588844; c=relaxed/simple;
	bh=d6cZ9MaKVNd9nSbak3Q+2mW5wQGPTe54Fr5G+Y60B2E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uXNCibqRa44xztAoBEdv0YCIg/Zs4aSsHDW9gPLYulfUlV3XSsw5R1OJdsSkqoqgBX/mT1q1YoXiPToXVeebdpDozl5LSX2dAmTD5IFVTQxAVLl4JqzEQNeUycTR+RYDpKCYomS2E2ZgaEVTDDz3RwpFUMZxKwCS1ZinYqIziFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hJ5/oJb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJ5/oJb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4D0C433C7;
	Tue, 30 Jan 2024 04:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706588843;
	bh=d6cZ9MaKVNd9nSbak3Q+2mW5wQGPTe54Fr5G+Y60B2E=;
	h=Date:From:To:Cc:Subject:From;
	b=hJ5/oJb1q4bpM3KNWfbw2a5Xyobkqqsc1BeBf/nbRoMbBrovidzo3xzD90JF+dp6W
	 Xpd9RP4eQjW6Ir3mlW5lSI+PLfJGdDOEcOxePM0zazVPJAFWpaSXLGOutgeC4QuAx7
	 djhuSWMpoSrHlSrHnxGJ7Mv+LoPiCSApjIX9qfY8jqhe/N0mMlMJp5XZjEiAJKHxR+
	 EBc9v0eZPKzxadtKwhnCVSZxiJbWyo8LH+QTz96VoUEMGHrhI3lE/K6aMPp/IyCi8/
	 SQ0D0oru+mbDHwy6OV25POxNh8ld6W45TlHLCU+xBcf4/nlISABCfiZBpUVmMcirlC
	 ZPLjJfHIskQMg==
Date: Mon, 29 Jan 2024 20:27:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>,
	Chandan Babu R <chandanrlinux@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: remove conditional building of rt geometry validator
 functions
Message-ID: <20240130042723.GH1371843@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

I mistakenly turned off CONFIG_XFS_RT in the Kconfig file for arm64
variant of the djwong-wtf git branch.  Unfortunately, it took me a good
hour to figure out that RT wasn't built because this is what got printed
to dmesg:

XFS (sda2): realtime geometry sanity check failed
XFS (sda2): Metadata corruption detected at xfs_sb_read_verify+0x170/0x190 [xfs], xfs_sb block 0x0

Whereas I would have expected:

XFS (sda2): Not built with CONFIG_XFS_RT
XFS (sda2): RT mount failed

The root cause of these problems is the conditional compilation of the
new functions xfs_validate_rtextents and xfs_compute_rextslog that I
introduced in the two commits listed below.  The !RT versions of these
functions return false and 0, respectively, which causes primary
superblock validation to fail, which explains the first message.

Move the two functions to other parts of libxfs that are not
conditionally defined by CONFIG_XFS_RT and remove the broken stubs so
that validation works again.

Fixes: e14293803f4e ("xfs: don't allow overly small or large realtime volumes")
Fixes: a6a38f309afc ("xfs: make rextslog computation consistent with mkfs")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   14 --------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   16 ----------------
 fs/xfs/libxfs/xfs_sb.c       |   14 ++++++++++++++
 fs/xfs/libxfs/xfs_sb.h       |    2 ++
 fs/xfs/libxfs/xfs_types.h    |   12 ++++++++++++
 fs/xfs/scrub/rtbitmap.c      |    1 +
 fs/xfs/scrub/rtsummary.c     |    1 +
 7 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 31100120b2c58..e31663cb7b434 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1118,20 +1118,6 @@ xfs_rtbitmap_blockcount(
 	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
 }
 
-/*
- * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
- * use of rt volumes with more than 2^32 extents.
- */
-uint8_t
-xfs_compute_rextslog(
-	xfs_rtbxlen_t		rtextents)
-{
-	if (!rtextents)
-		return 0;
-	return xfs_highbit64(rtextents);
-}
-
 /*
  * Compute the number of rtbitmap words needed to populate every block of a
  * bitmap that is large enough to track the given number of rt extents.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 274dc7dae1faf..152a66750af55 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -351,20 +351,6 @@ xfs_rtfree_extent(
 int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 		xfs_filblks_t rtlen);
 
-uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
-
-/* Do we support an rt volume having this number of rtextents? */
-static inline bool
-xfs_validate_rtextents(
-	xfs_rtbxlen_t		rtextents)
-{
-	/* No runt rt volumes */
-	if (rtextents == 0)
-		return false;
-
-	return true;
-}
-
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
@@ -383,8 +369,6 @@ unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 # define xfs_rtsummary_read_buf(a,b)			(-ENOSYS)
 # define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
-# define xfs_compute_rextslog(rtx)			(0)
-# define xfs_validate_rtextents(rtx)			(false)
 static inline xfs_filblks_t
 xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 {
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 4a9e8588f4c98..5bb6e2bd6deee 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1377,3 +1377,17 @@ xfs_validate_stripe_geometry(
 	}
 	return true;
 }
+
+/*
+ * Compute the maximum level number of the realtime summary file, as defined by
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
+ */
+uint8_t
+xfs_compute_rextslog(
+	xfs_rtbxlen_t		rtextents)
+{
+	if (!rtextents)
+		return 0;
+	return xfs_highbit64(rtextents);
+}
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 19134b23c10be..2e8e8d63d4eb2 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -38,4 +38,6 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
 		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
 
+uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
+
 #endif	/* __XFS_SB_H__ */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 20b5375f2d9c9..62e02d5380ad3 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -251,4 +251,16 @@ bool xfs_verify_fileoff(struct xfs_mount *mp, xfs_fileoff_t off);
 bool xfs_verify_fileext(struct xfs_mount *mp, xfs_fileoff_t off,
 		xfs_fileoff_t len);
 
+/* Do we support an rt volume having this number of rtextents? */
+static inline bool
+xfs_validate_rtextents(
+	xfs_rtbxlen_t		rtextents)
+{
+	/* No runt rt volumes */
+	if (rtextents == 0)
+		return false;
+
+	return true;
+}
+
 #endif	/* __XFS_TYPES_H__ */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 441ca99776527..46583517377ff 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -15,6 +15,7 @@
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_bit.h"
+#include "xfs_sb.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index fabd0ed9dfa67..b1ff4f33324a7 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -16,6 +16,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_bit.h"
 #include "xfs_bmap.h"
+#include "xfs_sb.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
