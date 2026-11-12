Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445364;
	b=FrTAaYkHekyO/84k2v8h5mn6jCgTw8Jl/IxEGPiD59pc4C2j4Hy6t1V8jrgDN4Tl8bHy
	 SagcfctiaOn8rrClaMho2t29MNcjkWMc6c0ODHxv+8+71aWKu4BIgKI46AMZjsgPpnP7A
	 QXNUBf02YNH9FXERTysUmG2YoFshVKqpl7mB8AAB77D7vMEx4Xqsc4e2nZsIdPaw88Eyr
	 30Qy+TEVOhRhBw5fZ0tE/BvU45hR6FI8ywwJ14jUvtOjY7hphpNodoaJoMoH97NIyKnXa
	 lHPCi0BPtEN0gj5hJf0RoFjfHdz7ZcJ/FyIJrlk+hKvsQpbjrqM6ocS5y922mExgS6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445364;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LJJzs8LGVQUSqDxulSRDR8TeR0Bfq965MNEelHPa2N0=;
	b=R9woqugiEIFCR892blr/JQeqvjePpgpDSVKzpBBvbFVeIizTQoiQh3BBpe15CKIfD6X6
	 3QaICK2/wgJpcWMrsviqXSYWWq3vMgRTzY7lASDiNV+NpdVwd2r0Cs2i5mT5lZbAc5mhV
	 qxekdXsQYvTfTFDFFFEip9lxIN+WOvzXZmErW01bVL4sxmJbKM5NQoxR3KWC1LmuHf6iT
	 80ZYzoYCj5QGjEJ3CwTeqGQASrAgtSDijNNiKLDugYejk/xUKt/ZZPmVEeIoS3IiqJZXE
	 2TWDLNw0p1P1C5lGZAkrv9YoF9K9G8aE8cYQ+h6+6HQYZf6Yh5pj+iyu8c2P69hOIEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PpoJVx1o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A017760A5BC3;
	Thu, 12 Nov 2026 01:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PpoJVx1o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAADF1F00A05;
	Thu, 12 Nov 2026 01:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445364;
	bh=LJJzs8LGVQUSqDxulSRDR8TeR0Bfq965MNEelHPa2N0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=PpoJVx1oqapyCpnR39rkAoicXwoaR/MzEZBFyHRCFR9sSBhwvr39xf8yOzTMK8cvn
	 HREd5+8ZnI7jnzFBNfzoYYu4aLWAcDPHrQo0IhlIkfqK9zLI9V5/KUDZUcoSkovSxM
	 rc54Jnduov3OLp0uBk+U3JiDdKmm9jFE0etmIwcKNixnukzZfMUbua1NUk425LFr/n
	 7UoJLmrvfZEmkiGDJdMk1cxEHPYqPd/JOahuemwBusRSZxEAI7TLFmU/HCSMweq1xE
	 Uo1dNiBIrapXys3lMmBeA45w/z6F1LP+dHSFWwXKmu52dgATxA+TnliJDcj/9kK3kc
	 2PxRF2NdvMfTw==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v8 07/15] xfs: test for reflink after the dio write checks
Date: Wed, 11 Nov 2026 20:02:36 -0500
Message-ID: <20261112010229.51029-8-mason@kernel.org>
In-Reply-To: <20261112010229.51029-1-mason@kernel.org>
References: <20261112010229.51029-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A direct write that is not block aligned can expose stale disk contents
on XFS if it races with the first clone of the file.

xfs_file_dio_write_unaligned() falls back to buffered I/O if the file is
reflinked, and tests for that right after it takes the iolock. But
xfs_file_write_checks() runs after the test and can drop the iolock, for
example if S_NOSEC is not set. A clone can run in that gap:

    direct write                        clone
    ============                        =====
    takes the iolock shared
    sees that the file is not reflinked
    drops the iolock
                                        shares the blocks
    takes the iolock exclusive
    writes a part of a new COW block
    maps the whole block into the file
      /* the rest was never written */

The fix used here is to move the test after xfs_file_write_checks().

Fixes: ed1128c2d0c8 ("xfs: reduce exclusive locking on unaligned dio")
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

Notes:
    v7->v8:
    - No change.
    
    v6->v7:
    - No change.

 fs/xfs/xfs_file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8ee88910b487..d888470d092a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -877,9 +877,15 @@ xfs_file_dio_write_unaligned(
 	if (ret)
 		return ret;
 
+	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
+	if (ret)
+		goto out_unlock;
+
 	/*
 	 * We can't properly handle unaligned direct I/O to reflink files yet,
-	 * as we can't unshare a partial block.
+	 * as we can't unshare a partial block.  xfs_file_write_checks() can
+	 * drop the iolock and take it again, and the file can be reflinked in
+	 * between, so test for that only now.
 	 */
 	if (xfs_is_cow_inode(ip)) {
 		trace_xfs_reflink_bounce_dio_write(iocb, from);
@@ -887,10 +893,6 @@ xfs_file_dio_write_unaligned(
 		goto out_unlock;
 	}
 
-	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
-	if (ret)
-		goto out_unlock;
-
 	/*
 	 * If we are doing exclusive unaligned I/O, this must be the only I/O
 	 * in-flight.  Otherwise we risk data corruption due to unwritten extent
-- 
2.55.0

