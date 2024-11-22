Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55A460890;
	Fri, 22 Nov 2024 16:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294291; cv=none; b=TClNqRmRrj4x/NnHug/kDBIwwG90nMFMIbinDAA1YAOoK9FYc5mcNc1qRsb1DloV3KvPlStnhNDSaD44hSeQcG5C2PjFxmVj9Saqr5r0N0wEkASiLiy65uLHO4VQP0SSlVT6EGMaufnzgtH4/Nl2mrV1JFTENXsSY86MQVXHZkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294291; c=relaxed/simple;
	bh=1b3WRsNnivAxyi55OjZu3eEOrtb0Id4ruAwv8YsLp24=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FfmB99pV0iL3zN669isremIfIm47F7DUqt2bBUUGmjMWDFGjNKxspfwQLEo6Qp6kDKXuLvEbtQuAQ4gVGGcxMZ/Bv5WsKPUKFtA1IWEbz9pY84Sxm7Egb+sO5VRY2N+5vFNWtVRxIeEmSpagHLlgQc11qvI+BL5RNNjv0kSaFlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dy0sxI3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dy0sxI3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569D7C4CECE;
	Fri, 22 Nov 2024 16:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294290;
	bh=1b3WRsNnivAxyi55OjZu3eEOrtb0Id4ruAwv8YsLp24=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dy0sxI3Qz5QQjTmpOXDFSA2z6rdSma6VGEQ/gAEdxTWDZy+3HRX0sjgwDlna9W7W2
	 mgrKYvDMrvhzgGuBmObjOdDYypCcGHNMEaPayTKytzk5BN/7m8vi7KHDfRSzDfuuq7
	 O75KtkImEQlYW8ZTHhs4/bYtBBeoNdl6yLnWMdFlTMajMQSUKx9bbULN8P9QvXnwbw
	 5Yf1ERt7A/a4Ce3wl2J87Zp24dsId7ffRD+uGXfII20RpPOCJNTrQPHRtp704LC1b/
	 U0Sg84wfoVb/M/b1XHz5oa6YcrnRqhfdWSEhpsdB5xVOswuHtQWjMA6NBDWjioM1mE
	 27gmG8rtgal4A==
Date: Fri, 22 Nov 2024 08:51:29 -0800
Subject: [PATCH 04/17] logwrites: use BLKZEROOUT if it's available
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420076.358248.10925789878371514364.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
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
 src/log-writes/log-writes.c |   10 ++++++++++
 src/log-writes/log-writes.h |    1 +
 2 files changed, 11 insertions(+)


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

