Received: from proxima.stupidest.org (proxima.stupidest.org [35.163.12.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC6B3C1998
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.163.12.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788112175; cv=none; b=gbCaObDnBvWwsoS3wjWdKBm/aQrELcBq5vpMYWQq84kOfkFxhF0hzosr3RZUr9ani2CR/S5Tt27c+8cRiX6jOIMrjjjSLUOziI6RlV1QlYDgobL7ppiheriUe/QVAQTTJUlpMuuVCxosMndyDJkoHzNbhe5xCRQzWdH0qBMbtuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788112175; c=relaxed/simple;
	bh=F4Ji/NGtIaiwYdoQp61lwEs8YByiiI8MCGtWe5PlXa8=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject; b=oXt/yfHmlvRlHe56VJd9OQXqJivLW3XTAIKORzyC/Mx1+KFTgtjJu6/Tle/sOFPNSvFaN7e7mEmAvtwQTf1ZXtONV0773keYB/95LRIIlLIslBteScSHO6qQ4pV3OXOvIFNOMO8ez1OLvE8Szm3+5yjhQqPT8y7DSrvi0CGQqlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org; spf=pass smtp.mailfrom=f00f.org; dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b=Nfoy9rqy; arc=none smtp.client-ip=35.163.12.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=f00f.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b="Nfoy9rqy"
Received: from aether.stupidest.org (unknown [10.0.1.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by proxima.stupidest.org (Postfix) with ESMTPS id 4hY04S4C99z6lm
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=f00f.org; s=m2016a;
	t=1788112168; bh=HWC7iDKRwhbwakxR4KsTSdd6T4CGURfX43kgQR6bKuw=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject;
	b=Nfoy9rqyIl5YDN64x8zqrITDemIy6TgprVJvRRgiru5incMdQT/BWZ/0e+k44rk6h
	 uUUc5zwOqVrtvLY5UZlVh50ZFF8et+U6RSwVzC/PC/A2o0fSJv6lcWcrv4wCKg6lmx
	 NuL5y7nUFPhFoC8WOOqEz4FfOiY1LvgETMnkeL5wLQ2+lvEMXAF+CVC5yFydA5jE98
	 FZEO5A6AJTM5lPQBKSsyS9/8iw+1K7D8UOjmgq94NKbEHk8+VSCcPZ6DTR+SSMFqQs
	 ZSffyu3NFT39QnleN2OMgFVBIqKqjAbpM+DHNm3ak1Qj8WhZ+YstFNEp6Pv3IRF37v
	 TtBS6wwP/NtFg==
Received: from stupidest.org (unknown [172.31.255.110])
	by aether.stupidest.org (Postfix) with SMTP id 4hY04R0wDFz9KVLH
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 10:49:27 -0700 (PDT)
Received: by stupidest.org (sSMTP sendmail emulation); Sun, 30 Aug 2026 10:49:27 -0700
To: linux-xfs@vger.kernel.org
Message-ID: <19b14aff5aa38738f92c7fef2babefb7f773655b.1788110147.git.cw@f00f.org>
In-Reply-To: <cover.1788110147.git.cw@f00f.org>
References: <cover.1788110147.git.cw@f00f.org>
From: Chris Wedgwood <cw@f00f.org>
Date: Thu, 20 Aug 2026 22:42:15 -0700
Subject: [PATCH 3/9] libxfs: record a failed buffer write when it fails
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

libxfs_flush_mount() decides whether metadata reached the disk by
looking at XFS_BUFTARG_LOST_WRITE and XFS_BUFTARG_CORRUPT_WRITE, and its
comment says a buffer that cannot be written sets them.  It does not.
The flags are only set from libxfs_buf_prepare_mru(), that is, when a
still-dirty buffer is later released to the free list.  A write that
fails during a cache flush leaves the buffer dirty and errored in the
cache, and cache_flush() discards what libxfs_bflush() returns, so
nothing records the failure and libxfs_flush_mount() returns success.

No existing caller can tell: mkfs.xfs and xfs_repair both detect a
failing write through their own error paths first, so today this is a
latent contract violation rather than a visible bug.

It stops being latent with log replay.  Replay flushes the metadata it
has applied and then retires the log, and the flush result is what says
the retirement is safe.  Believing a flush that did not happen destroys
the only remaining copy of that metadata.

Set the flags where the failure is detected.  Both failure exits, the
I/O error and the write verifier, go through one helper so the promise
holds however the write failed.  The stale-buffer exit is left alone: it
reports a caller bug rather than lost data, and has always done so.

Measured with an LD_PRELOAD shim that fails pwrite() after a chosen
number of calls, replaying a log whose recovery needs 558 writes.
Failing from write 181, which lands in the flush after replay:

  before: no error reported, log retired, reads CLEAN afterwards
  after:  "Failed to flush replayed metadata to disk", log left DIRTY

Sweeping the failure point across the whole run shows no case where a
write fails and xfs_repair still reports success.
---
 libxfs/rdwr.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7ec6e774..5b1c1bbc 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -832,6 +832,26 @@ __write_buf(int fd, void *buf, int len, off_t offset, int flags)
 	return 0;
 }
 
+/*
+ * Record that a buffer's dirty contents did not reach the disk.
+ *
+ * libxfs_flush_mount() decides whether metadata is durable from these flags
+ * rather than from what libxfs_bwrite() returns, because cache_flush()
+ * discards the return value.  Every failure exit that leaves dirty data
+ * unwritten therefore has to come through here, or the caller is told the
+ * flush succeeded.  xfs_repair -R retires the log on the strength of that
+ * answer.
+ */
+static int
+libxfs_bwrite_failed(
+	struct xfs_buf		*bp)
+{
+	if (bp->b_error == -EFSCORRUPTED)
+		bp->b_target->flags |= XFS_BUFTARG_CORRUPT_WRITE;
+	bp->b_target->flags |= XFS_BUFTARG_LOST_WRITE;
+	return bp->b_error;
+}
+
 int
 libxfs_bwrite(
 	struct xfs_buf	*bp)
@@ -867,7 +887,7 @@ libxfs_bwrite(
 				__func__, bp->b_ops->name,
 				(unsigned long long)xfs_buf_daddr(bp),
 				bp->b_length);
-			return bp->b_error;
+			return libxfs_bwrite_failed(bp);
 		}
 	}
 
@@ -899,6 +919,8 @@ libxfs_bwrite(
 			__func__, bp->b_ops ? bp->b_ops->name : "(unknown)",
 			(unsigned long long)xfs_buf_daddr(bp),
 			bp->b_length, -bp->b_error);
+
+		libxfs_bwrite_failed(bp);
 	} else {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
-- 
2.47.3

