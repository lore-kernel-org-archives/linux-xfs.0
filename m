Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4A81A6815
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802171; cv=none; b=IipRJSGODMQSkJCpaV99LrFgNaUa8PF1tISp66IxRToVsBBNnquS9Q8NPEuUysGy/J3ZtQX1qWk8Bb09LDz16OOA3N8/HCZFUay46/ePFLuJAIatDhE2tm3tomvE94aQG54UoALcpSlyuB3nJdjWUFcxgyd+b5cX4pd+J87eTZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802171; c=relaxed/simple;
	bh=hIIiEg9uJympwvpQkH0PTyYlReJGGODaHKNyB8jdxJ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aUinnKYA6kDimUYhFkH5cb1JJAliaFlTOjhzpd53chWCxPzOdqnGkaCK5H+xPPpKzjHi6cny1hAluPTB2aCUl3tcFo0tGCfJWUsWeVUHk9VLrR1ovzH5FkAuZX31SbWcKRb51RGrBMbDyqz21T4FhZtVCY5tnh6/oNgMm5kLWIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGEbvzO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGEbvzO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4011AC19421;
	Fri, 10 Apr 2026 06:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775802171;
	bh=hIIiEg9uJympwvpQkH0PTyYlReJGGODaHKNyB8jdxJ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oGEbvzO+uFk2B9fH+4A2VkzAOOn7cqk4sUh3Q9pzJuFwaIxgMYjTGjWrpN3TnHMG7
	 tN4IVPXaQFRU+HlL1AkPOGzFpW4H4IltSpkbR+VepJtL0THT9LpPYA+IH7aSfy1iiD
	 EvjXqksxW6ciGaL/7+ycDBYWrnZhsXFnsUStQ3eu9fgDLFx0XowByl4lGBLqiO5B8h
	 jGac6hywNWUJI2WqxcuP4TZl94+Tl6p+seheaPWibGhM+vxoo2itBR8dlaQMBsalfP
	 s242d6DKNARo20bGWL6vozhh0ZwsT0z7ql/FJDzHxq+7yrl4w+lUHk/sssM++Aw0Ah
	 yTjsPpRo57kXA==
Date: Thu, 09 Apr 2026 23:22:50 -0700
Subject: [PATCH 21/21] xfs_scrub: raise media verification IO limits
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385420.2090237.2889950460652860895.stgit@frogsfrogsfrogs>
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

To avoid starving other threads of disk IO resources, the read-verify
pool limits the size of verification IOs to limit bandwidth consumption,
and it is willing to over-verify some amount of unwritten media to
reduce the number of verification IO requests sent to the device.

However, these limits were set in 2018 when areal densities were lower
and disk bandwidth was more limited.  Increase them now to reduce scan
time on the author's system by 10% in foreground and 50% in background
mode.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/read_verify.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 01a3a8859c5fa8..7dd588c1482af5 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -10,6 +10,7 @@
 #include "libfrog/workqueue.h"
 #include "libfrog/paths.h"
 #include "libfrog/bitmap.h"
+#include "libfrog/convert.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "counter.h"
@@ -28,23 +29,36 @@
  */
 
 /* Perform all verification IO in 32M chunks. */
-#define RVP_IO_MAX_SIZE		(33554432)
+#define RVP_IO_MAX_SIZE			MEGABYTES(32)
 
 /*
- * If we're running in the background then we perform IO in 128k chunks
+ * If we're running in the background then we perform IO in 256k chunks
  * to reduce the load on the IO subsystem.
  */
-#define RVP_BACKGROUND_IO_MAX_SIZE	(131072)
+#define RVP_BG_IO_MAX_SIZE		KILOBYTES(256)
 
 /* What's the real maximum IO size? */
 static inline unsigned int
 rvp_io_max_size(void)
 {
-	return bg_mode > 0 ? RVP_BACKGROUND_IO_MAX_SIZE : RVP_IO_MAX_SIZE;
+	return bg_mode > 0 ? RVP_BG_IO_MAX_SIZE : RVP_IO_MAX_SIZE;
 }
 
-/* Tolerate 64k holes in adjacent read verify requests. */
-#define RVP_IO_BATCH_LOCALITY	(65536)
+/* Tolerate 2M holes in adjacent read verify requests. */
+#define RVP_IO_BATCH_LOCALITY		MEGABYTES(2)
+
+/*
+ * Tolerate 256k holes in adjacent read verify requests when running in the
+ * background.
+ */
+#define RVP_BG_IO_BATCH_LOCALITY	KILOBYTES(256)
+
+/* How many holes are we willing to verify to reduce IO count? */
+static inline unsigned int
+rvp_io_batch_locality(void)
+{
+	return bg_mode > 0 ? RVP_BG_IO_BATCH_LOCALITY : RVP_IO_BATCH_LOCALITY;
+}
 
 struct read_verify {
 	uint64_t		io_start;	/* bytes */
@@ -500,6 +514,7 @@ try_read_verify_schedule_io(
 {
 	uint64_t			req_end;
 	uint64_t			rv_end;
+	const unsigned int		locality = rvp_io_batch_locality();
 
 	assert(rvp->readbuf);
 
@@ -525,9 +540,9 @@ try_read_verify_schedule_io(
 	 * we can combine them.
 	 */
 	if (rs->rvp == rvp && rs->io_length > 0 &&
-	    ((start >= rs->io_start && start <= rv_end + RVP_IO_BATCH_LOCALITY) ||
+	    ((start >= rs->io_start && start <= rv_end + locality) ||
 	     (rs->io_start >= start &&
-	      rs->io_start <= req_end + RVP_IO_BATCH_LOCALITY))) {
+	      rs->io_start <= req_end + locality))) {
 		rs->io_start = min(rs->io_start, start);
 		rs->io_length = max(req_end, rv_end) - rs->io_start;
 

