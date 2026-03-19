Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2421F16B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895861; cv=none; b=sv7cJMgD/Bil1P9Y8UQcHRLVMSfiL0+1feTvFKrlqH7r8Yh/NKXGC6a8SifcBH/F3B/7XFg/I2AcZbVbmz58WZRzXaWGaZk6JEIu383M6W+3nMmVqVpYmGWuFvaPvGNFgzGDXL9Tvb0k+tOK0UIuPNA5qmzwIb4iZAlBx6/s3vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895861; c=relaxed/simple;
	bh=C/Ym+l/Ia5/Twt7qH8zkIddfiPBu0AHL0gIbGbxije0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bAoFm+SnPKOQJHpkEglmHcvuOhvnvl3ucJ2/6223ELq/YCw+tIikXyut30+37Cc8cWh40vV6k+f8kv2fC5wZMqY/guv9Lnz+EMjfF5RLzN08mbbOfpKy+hSQ+8eVIWytnTp02Ie2PfGnb5EPlfxR7s800AA4QexmjKvQcNUb7/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ThIT0rqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ThIT0rqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3580C19425;
	Thu, 19 Mar 2026 04:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895861;
	bh=C/Ym+l/Ia5/Twt7qH8zkIddfiPBu0AHL0gIbGbxije0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ThIT0rqnKU42dSLrrWLY8HLso3RlraYbImsIzZXKT0Cort8a1CaJ6nAyXzv6+IcHw
	 KRN8JMPErVTv7I653z4iMYLSW+/5H6uuEyUHT7NihblD3wbuS9GEEKxc+slR8i4q+U
	 m70uTcZ9OP0m4kaBt0PH1g+2FU6N1c+YlKqHo3E0MYWHm3cyirPbBhrzvD7AqNS3Wh
	 3nsMOdfqJla5NFQ/eJTLbIY7Ao/MXdh+nqZh7DXj958l2lU6w88AJNieBEd3Y/fG4C
	 +2G+PNb1JAc5pfl/zI1UMMfQoL3Nwy/+ATl+RBGL18sflLMAYDi+ExLUqCFo2No5NP
	 nXTE4DG+nl9Mw==
Date: Wed, 18 Mar 2026 21:51:00 -0700
Subject: [PATCH 21/22] xfs_scrub: raise media verification IO limits
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177389507326.3681140.15280052926187020484.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
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
---
 scrub/read_verify.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 6789f5f668b46c..01f9134799384f 100644
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
@@ -488,6 +502,7 @@ try_read_verify_schedule_io(
 {
 	uint64_t			req_end;
 	uint64_t			rv_end;
+	const unsigned int		locality = rvp_io_batch_locality();
 
 	assert(rvp->readbuf);
 
@@ -513,9 +528,9 @@ try_read_verify_schedule_io(
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
 

