Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1CB180A80;
	Wed, 19 Feb 2025 00:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926205; cv=none; b=T/fp1HmBFrQXwF3L8sQALzJdQVmmNCkb92EpuoDODnKFxItUINZynMBMh0bwNRaZFrEh2UYGkEOt+JC9k2fm6Ll0N5YKPcBLXv8JAa7b302Rfd8SC6XL0d4Ng9sZxopAqnj6fZpiTuICwzdnfgs2NLPUh22wdk0NTT8FFb8qqls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926205; c=relaxed/simple;
	bh=1gZot46ERbQd78/irKGOKdgoQtlhQZQdfk1dh7VJHeI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lpWUVK1ylJncqGJ54q7B0m7MHOWZ84CcpPMx+4P+hDpMFQbYVpvZTE5eLyqHHOvW/qYnCkntFveCnFXRKg9tiWf9a5s5Evm9pY5v9SqQTIRhltpxMxy0nDj2BDBVMNXfj7XXLSqI+gDNt+hPde6n7gynlLjsACu7GPGftRn4V5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=POfdrRQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="POfdrRQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550E8C4CEE2;
	Wed, 19 Feb 2025 00:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926204;
	bh=1gZot46ERbQd78/irKGOKdgoQtlhQZQdfk1dh7VJHeI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=POfdrRQXo+2nx4I823dr5rDDiXSKw3zjMeD5zRZDiQ7Qyo6Q2cscZi2mg9/cNW5R8
	 kJSuMh/nWBBleHFzCOuygzxAcqmEj3ZuFJXTKgVlzQmVyvcuYy3wYXapuQdweanPAj
	 ZNLBnkoNBO/pdDzkEd8BJzCxl+yapBLwA4ZJeKR2+A6WGy2ZTdfCM5+TaFkxnW74AL
	 HopHlVMxXjNh8cSPf6v3VSsDM3uGmaCRCqhZ6oAEYw9FdtY2D2H2JfM8xTi6Eewl/f
	 /eg0P515N1DrD/8wBKo0LwxlmwU4xDfaXDqH/vNij68YWfsXyoRP/KGmxzY63hXNbg
	 wl3GQJvEEg3ww==
Date: Tue, 18 Feb 2025 16:50:03 -0800
Subject: [PATCH 2/3] logwrites: use BLKZEROOUT if it's available
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587004.4078081.9861006903580046263.stgit@frogsfrogsfrogs>
In-Reply-To: <173992586956.4078081.15131555531444924972.stgit@frogsfrogsfrogs>
References: <173992586956.4078081.15131555531444924972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use the BLKZEROOUT ioctl instead of writing zeroed buffers if the kernel
supports it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 src/log-writes/log-writes.h |    1 +
 src/log-writes/log-writes.c |   10 ++++++++++
 2 files changed, 11 insertions(+)


diff --git a/src/log-writes/log-writes.h b/src/log-writes/log-writes.h
index b9f571ac3b2384..f659931634e64a 100644
--- a/src/log-writes/log-writes.h
+++ b/src/log-writes/log-writes.h
@@ -63,6 +63,7 @@ struct log_write_entry {
 
 #define LOG_IGNORE_DISCARD (1 << 0)
 #define LOG_DISCARD_NOT_SUPP (1 << 1)
+#define LOG_ZEROOUT_NOT_SUPP (1 << 2)
 
 struct log {
 	int logfd;
diff --git a/src/log-writes/log-writes.c b/src/log-writes/log-writes.c
index aa53473974d9e8..8f94ae5629e085 100644
--- a/src/log-writes/log-writes.c
+++ b/src/log-writes/log-writes.c
@@ -42,6 +42,7 @@ static int discard_range(struct log *log, u64 start, u64 len)
 
 static int zero_range(struct log *log, u64 start, u64 len)
 {
+	u64 range[2] = { start, len };
 	u64 bufsize = len;
 	ssize_t ret;
 	char *buf = NULL;
@@ -54,6 +55,15 @@ static int zero_range(struct log *log, u64 start, u64 len)
 		return 0;
 	}
 
+	if (!(log->flags & LOG_ZEROOUT_NOT_SUPP)) {
+		if (ioctl(log->replayfd, BLKZEROOUT, &range) < 0) {
+			if (log_writes_verbose)
+				printf(
+ "replay device doesn't support zeroout, switching to writing zeros\n");
+			log->flags |= LOG_ZEROOUT_NOT_SUPP;
+		}
+	}
+
 	while (!buf) {
 		buf = malloc(bufsize);
 		if (!buf)

