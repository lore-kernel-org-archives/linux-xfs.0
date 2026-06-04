Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1431A1A23B1
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553187; cv=none; b=KFSNy+7DRAUHQV8EyM6wjK80uHCq/DeS9ZA5fW+sFuPhuROu1DEQoFfBqA85YnYnGMcTfY+bbXHksTw9Od3q+dOVsbNGM09c3dl5Jf+yTyFGEfglkTZIvqiLcx40eOqNny+rNm/ZkVaDxA9FkMPMPPukfzGPgF9lmrEVKdpfO64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553187; c=relaxed/simple;
	bh=HwWLjl8ndVWACvhGqo8PP1ip4daTeiQhPRHVpMdi/Zs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pU1a659LkHai2mRosnAtEyEdqK1aPRYPZuMDrTAEu0F3zrRna2UtmWFSnvUhAzjJTGagLo/llPHLuDV/7I7zsM/zRGS5zTIvbzxNS2zq3C0stBZTyjK+rBOdYlWlxmiI91xS/W8ZMY31OcG9zfZnDGm2AiGFWjGCecqqG1FYjt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHr5iq+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHr5iq+H"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD0E01F00898;
	Thu,  4 Jun 2026 06:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553185;
	bh=Vk7hfiJRJV9+pyb7idz807R1hXMZhmxq9f130w/Xhho=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=FHr5iq+HGsaAqNsS7DdIGU5vLqDY61S5DMU914XbCMb6nF+ckBuiali8rlsu1lmva
	 3StjAnRKDvx5QW7lWjgQJXv93R/RGyWbh78jzSA4/u+Eq9uFXAuRJGzz4tUgT3NWBs
	 jEJFMP9scsyHE7U++wtGl+7vYRd3AeGZ9FEabkOZvhgbIMA9ymGATEG3fRkUW7Ek66
	 UFqmnP//6KsS7QHxALg7Z3JDnl17pxIA4o1cZHYJCxMP3694CxQ01Vy9vr6nmIRZ7v
	 lNJNf8dheNQ2+2HE/74P63B6BEdSGe5Fk1qYR52Fupnyw4K6r/LpfJhO5cGL8VjkHW
	 It/xGgNuhCZdw==
Date: Wed, 03 Jun 2026 23:06:25 -0700
Subject: [PATCH 08/21] xfs_scrub: widen scrub and repair dependency mask
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303256.2608728.4779400218969576550.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex observes:

"Since `XFS_SCRUB_TYPE_NR` is now 33 (`XFS_SCRUB_TYPE_RTREFCBT` is 32),
any scheduled scrub item drives this loop to `j == 32`, where `1U << j`
shifts a 32-bit unsigned value by its width. That is undefined behavior
(and will trip UBSan or allow miscompilation of dependency scheduling);
the dependency mask and shift need to use a type wide enough for all
scrub types, e.g.  `1ULL`/`uint64_t`."

The presence of a shift overflow is correct, since there are now 33
scrub type codes.  However, the local loop variable isn't the only
problem here -- scrub_deps and repair_deps are masks, and they aren't
wide enough.  As a result, there's a lurking logic bomb because RTREFCBT
will never get selected.

Fortunately this is benign because no scrub/repair type depends on
RTREFCBT, which is why we haven't seen any complaints.  But let's
eliminate an avenue for us to forget to fix the problem.  Widen the
masks and the local variable to fix the problem.

Cc: <linux-xfs@vger.kernel.org> # v6.14.0
Fixes: b71fbe4c3da263 ("xfs: scrub the realtime refcount btree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/scrub_private.h |    2 +-
 scrub/repair.c        |    8 ++++----
 scrub/scrub.c         |    8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index c5e0a7c08be056..629ef4405225eb 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -118,6 +118,6 @@ scrub_item_schedule_retry(struct scrub_item *sri, unsigned int scrub_type)
 bool scrub_item_call_kernel_again(struct scrub_item *sri, uint8_t work_mask,
 		const struct scrub_item *old);
 bool scrub_item_schedule_work(struct scrub_item *sri, uint8_t state_flags,
-		const unsigned int *schedule_deps);
+		const uint64_t *schedule_deps);
 
 #endif /* XFS_SCRUB_SCRUB_PRIVATE_H_ */
diff --git a/scrub/repair.c b/scrub/repair.c
index c3a8b3179600a6..5d821655877b80 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -28,8 +28,8 @@
  * the filesystem if the btree root pointers in the AG headers are wrong.
  * Dependencies cannot cross scrub groups.
  */
-#define DEP(x) (1U << (x))
-static const unsigned int repair_deps[XFS_SCRUB_TYPE_NR] = {
+#define DEP(x) (1ULL << (x))
+static const uint64_t repair_deps[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_BMBTD]		= DEP(XFS_SCRUB_TYPE_INODE),
 	[XFS_SCRUB_TYPE_BMBTA]		= DEP(XFS_SCRUB_TYPE_INODE),
 	[XFS_SCRUB_TYPE_BMBTC]		= DEP(XFS_SCRUB_TYPE_INODE),
@@ -250,7 +250,7 @@ repair_item_dependencies_ok(
 	const struct scrub_item	*sri,
 	unsigned int		scrub_type)
 {
-	unsigned int		dep_mask = repair_deps[scrub_type];
+	uint64_t		dep_mask = repair_deps[scrub_type];
 	unsigned int		b;
 
 	for (b = 0; dep_mask && b < XFS_SCRUB_TYPE_NR; b++, dep_mask >>= 1) {
@@ -434,7 +434,7 @@ repair_item_boost_priorities(
 	unsigned int			scrub_type;
 
 	foreach_scrub_type(scrub_type) {
-		unsigned int		dep_mask = repair_deps[scrub_type];
+		uint64_t		dep_mask = repair_deps[scrub_type];
 		unsigned int		b;
 
 		if (repair_item_count_needsrepair(sri) == 0 || !dep_mask)
diff --git a/scrub/scrub.c b/scrub/scrub.c
index de687af687d32d..12ed87f07d9f6c 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -28,8 +28,8 @@
  * Bitmap showing the correctness dependencies between scrub types for scrubs.
  * Dependencies cannot cross scrub groups.
  */
-#define DEP(x) (1U << (x))
-static const unsigned int scrub_deps[XFS_SCRUB_TYPE_NR] = {
+#define DEP(x) (1ULL << (x))
+static const uint64_t scrub_deps[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_AGF]		= DEP(XFS_SCRUB_TYPE_SB),
 	[XFS_SCRUB_TYPE_AGFL]		= DEP(XFS_SCRUB_TYPE_SB) |
 					  DEP(XFS_SCRUB_TYPE_AGF),
@@ -472,7 +472,7 @@ bool
 scrub_item_schedule_work(
 	struct scrub_item	*sri,
 	uint8_t			state_flags,
-	const unsigned int	*schedule_deps)
+	const uint64_t		*schedule_deps)
 {
 	unsigned int		scrub_type;
 	unsigned int		nr = 0;
@@ -486,7 +486,7 @@ scrub_item_schedule_work(
 			continue;
 
 		foreach_scrub_type(j) {
-			if (schedule_deps[scrub_type] & (1U << j))
+			if (schedule_deps[scrub_type] & (1ULL << j))
 				sri->sri_state[j] |= SCRUB_ITEM_BARRIER;
 		}
 

