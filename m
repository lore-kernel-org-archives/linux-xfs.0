Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE29A416CF5;
	Wed, 10 Jun 2026 14:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781103172; cv=none; b=PqtZySgfpSbLDdsxxGxXChf2JW+BH+Tk9uCEF+L86qCXhllVPoZ+YjxjvO+wUX8Sv03V4aT0MSLLrfLLo+YVEKbbE94lIOgK+WNJnbc+AH0f9DDvSQT1lryDxbCkhiSOPCz8F+2iisNnQVFIl25qh1cydQnDuDDwWNT/Lux8ox0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781103172; c=relaxed/simple;
	bh=gQpffhN18a3dNhAOPTKowDKI5ahwzUAslhtF2SnniEs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RkkVbvoz62KetQc8qqvm5BfpKMPPd6iTR2bk3bJfP9SVqFeRrXikhSEkhDvf0Fad3yT1Vw5bGK7V128O/fVRLKsJC5hT+cURAN9I2p0kzQiOHN9D1JWGwuvIY+wWy/Yq/fIjUjz2bhMZOyWdNCjpo1w2l5E8TM0eOeCmPNl7Ues=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGen+BIn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGen+BIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71031F00893;
	Wed, 10 Jun 2026 14:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781103170;
	bh=N8HFNwnAOWiY70Ez1bBckn5e6FbBAMQd4DDmazpSqro=;
	h=From:To:Cc:Subject:Date;
	b=PGen+BIn+l0cemxFoU6y9Fl2Ac0UbSRY2Y04GZudfAZZ/evOY3QemOZt1DFAyxwmX
	 bqAYUhRP2jDsqg0wfF+myP3qKqsRu6YA5hLIrm3/ptqzRzKs1yuUoJRkpQS7I78cHJ
	 wedYUQM/MXN+UU/R01jkkhgbn0/Ow8RmdKNjxsbvarYnKgYgkzuyZH4D/yt8Zb4EjH
	 Tkx2haVZ1Rp3rDkXV7HCY20O5M5aU5ReCZsg8SprOUOs9sRzr/6FxPMA1ReT/0e5QB
	 MAVVbc1aEee9CRmTQG/W5s6nAMRfyq4vGP8bFYbpFx2mjWT5Bv/lHXSs27fsyMe26i
	 jPRD7sFGpvA7g==
From: cem@kernel.org
To: brauner@vger.kernel.org
Cc: linux-block@vger.kernel.devel,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] iomap: enforce DIO alignment check in iomap
Date: Wed, 10 Jun 2026 16:52:11 +0200
Message-ID: <20260610145218.141369-1-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

The DIO alignment check has been lifted from iomap layer to rely on the
block layer to enforce proper alignment when issuing direct IO
operations. This though, depending on the IO size and buffer address
passed to the IO operation may lead to user-visible behavior change.

This has been caught initially by LTP test diotest4 running on
PPC architecture, where the test fails because a read() operation
with a supposedly misaligned buffer succeeds instead of an expected
-EINVAL.
This has no direct relationship with PPC, but seems to do with the
IO size crossing page borders or not.

The test allocates a 4k buffer, and then increments the buffer pointer
by a single byte to enforce a misaligned address. It then issues a 4k
read() using such buffer. The read is supposed to return an -EINVAL but
it ends up succeeding.

The allocated buffer is at least a single page, so the read() size being
smaller will end up most of the time within the very same page initially
allocated which seems to suffice the block layer to accept the IO.

On x86 though, the same 4k read will end up crossing page boundaries
causing a bio_split which ends up properly checking the address and
rejecting it due to misalignment.
The test itself is buggy (which seems by design) because it ends up
attempting to read 4096 bytes into a 4095, but I believe the test
expected the address to be rejected prior to any write attempt.

The problematic behavior is reproducible on x86 by reducing the IO size
to something < PAGE_SIZE, so the misaligned read()s will also be accepted
by the block layer.

Fixing this is just a matter of enforcing daddr and memory
alignment back into iomap.

This behavior is reproducible in ext4 and xfs due to both relying on
iomap layer, btrfs does not present this behavior change as it does its
own DIO alignment checking.

Fixes: 7eac33186957 ("iomap: simplify direct io validity check")
Cc: Keith Busch <kbusch@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---

While I didn't spot any memory/disk corruption looking into this, it
changes the user behavior that dictates buffer addresses must be
properly aligned when issuing direct IO operations so I thought making
iomap check again for the buffer address alignment is reasonable.

 fs/iomap/direct-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 95254aa1b654..0064984e64e5 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -400,6 +400,9 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	if ((pos | length) & (alignment - 1))
 		return -EINVAL;
 
+	if (iov_iter_alignment(dio->submit.iter) & (alignment - 1))
+		return -EINVAL;
+
 	if (dio->flags & IOMAP_DIO_WRITE) {
 		bool need_completion_work = true;
 
-- 
2.54.0

