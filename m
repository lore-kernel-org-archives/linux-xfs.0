Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1431E2304
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731684691; cv=none; b=jIE5bw0lgpEutIZA2r4i4X+pUiWts2Bq2DJuDCrlJiSg8v7hNcA+H0t5+hSSu7ZcMm3jkTnfnOyquSEtOUH2QdRnrN13MnL+fC4cNNIMmu0OcP1jHMXSBPEaYfbba7m3kwXef9x8cOWsEzvz+EQ8JNBu5a8OqnXRGJhneHJCHBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731684691; c=relaxed/simple;
	bh=lJOFXxVHcZLI+SjVd+0f1jV7QzcPV4Ai9MyZQsFymWc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMzGb+y43jGFv9ftNz179CuFeeCgq49zZEPmR2LydNTAy7X9ucYnIf6KPyoue9vmUU1OJ6gU5mAiFSdO+kXGj6uWt7M63MisWIxrDeUvZip3y3yB1AJRj33H4Np+CP8j7WEwiJ/CnRveUTN0VG3S2m4eJN2Fn1ipMh2czIC9ARo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=WgCxMT83; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="WgCxMT83"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e38193093a7so1569125276.0
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 07:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731684688; x=1732289488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5jVczlJ/TW6EECuU4gj9yYFP++VZ/oJUqPiY9P+PdPU=;
        b=WgCxMT83OJndjUPd1bpnut4k1njFzRSZT+45Xv3MOuEfIXNhQ8xGLPxT0GqdDQHzNP
         3FAWKaE95mHY8cUM+/Z5QrkWB0K2NYjSpt+ynKmwctxgJinxlfalSnXxa8fOhVKxfb/r
         tf9/isOH+Yy4aOI396zxw1OlUitAZJj1uMr/FmQMmtcFWRgeXhdZF1/+5AnF88+K0ilc
         MC9tIpVfjIx/NdV9UCRqJaDktOuFLyAn5ypGjSbY6Kzd8xez0CWvSR9ZXhOdtDojIykm
         hIY+HUEro6Ry3Z00n1ne4KcwAg4GG0CxfnafkIR/PjPfO5G+FTo/yMRJ4Yjgj1LodC5Q
         NxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731684688; x=1732289488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5jVczlJ/TW6EECuU4gj9yYFP++VZ/oJUqPiY9P+PdPU=;
        b=gfJNfygSSPupptOdNTcIXO1S1UUfZ6+FcgLVtmsOioaNMons/9Ls53IRlw9b/yRSsi
         liLQwhu1jmE+P+/jnjGebdOiBJciPtUA/lwvGuPVI+GG4iTuQ5BPEwx8RclTgaeBsBoM
         /vg+pwMFZVmTKozKWVkVHSAHglglSy/B0iGDVO8fzL2AIPMSIvMJZfFu1m4sM+QL67dq
         NIspXcknLPhCQFbGhuJDgxYUZmAccoZwANwhT3IqA3mgFmqULzQb37PPNPlkFxd/gtfx
         Uk4z4mAxHRyHW2ARN3vck4c/Rg9oMet66cw84b7l3YNS0S0Cv7PEcgMwGLjCVAzCAZmW
         7Bmw==
X-Forwarded-Encrypted: i=1; AJvYcCV4PUGzmeJdOsSwYVXqaIeaDoAasVecfjRt+ODet7kiFmysFsjzfrD2QjNcGk0pkTURSCXN+iycKRs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqeDQJZBbaULnB/Nj8pFOtwaFwDTfD2pVOc1QojInflxldJ483
	yd4ZTxhmFyGDeg0TEyIgOo9Ossc2wRaDayJabFgehS91LUSPW9OCSueWG2xT/mE=
X-Google-Smtp-Source: AGHT+IEWEdrPnRli1gv+jVnLYsORdUcuZyTi/FsZKRBYcdcM64Io8ydfsi1gmscyy1vF3dAQcsDh6w==
X-Received: by 2002:a05:690c:4c02:b0:6ea:2ac4:9df6 with SMTP id 00721157ae682-6ee55bbade0mr37073597b3.3.1731684688405;
        Fri, 15 Nov 2024 07:31:28 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6ee4449516asm7602087b3.124.2024.11.15.07.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 07:31:27 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH v8 04/19] fanotify: don't skip extra event info if no info_mode is set
Date: Fri, 15 Nov 2024 10:30:17 -0500
Message-ID: <afcbc4e4139dee076ef1757918b037d3b48c3edb.1731684329.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731684329.git.josef@toxicpanda.com>
References: <cover.1731684329.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

Previously we would only include optional information if you requested
it via an FAN_ flag at fanotify_init time (FAN_REPORT_FID for example).
However this isn't necessary as the event length is encoded in the
metadata, and if the user doesn't want to consume the information they
don't have to.  With the PRE_ACCESS events we will always generate range
information, so drop this check in order to allow this extra
information to be exported without needing to have another flag.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/notify/fanotify/fanotify_user.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 919ff59cb802..8fca5ec442e4 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -158,9 +158,6 @@ static size_t fanotify_event_len(unsigned int info_mode,
 	int fh_len;
 	int dot_len = 0;
 
-	if (!info_mode)
-		return event_len;
-
 	if (fanotify_is_error_event(event->mask))
 		event_len += FANOTIFY_ERROR_INFO_LEN;
 
@@ -754,12 +751,10 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	buf += FAN_EVENT_METADATA_LEN;
 	count -= FAN_EVENT_METADATA_LEN;
 
-	if (info_mode) {
-		ret = copy_info_records_to_user(event, info, info_mode, pidfd,
-						buf, count);
-		if (ret < 0)
-			goto out_close_fd;
-	}
+	ret = copy_info_records_to_user(event, info, info_mode, pidfd,
+					buf, count);
+	if (ret < 0)
+		goto out_close_fd;
 
 	if (f)
 		fd_install(fd, f);
-- 
2.43.0

