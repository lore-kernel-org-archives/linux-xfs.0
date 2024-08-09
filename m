Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C7015A853
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229097; cv=none; b=TQTl8VS4qEuBCsyC0sipjy8CT7KUtLW4mypY1NXHGQxO5gC0p//2zNfkriBeAvyWjfc1HOcd4i9H+0Ef1jFupH9AKk1Lhbyb4agDL19e5k1h4MEDv5jDKqxTRVwjmqZzEdu2Nk8s9Wy96xpEhhxfcVv+L4F+M0/JZTwsL3erLhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229097; c=relaxed/simple;
	bh=2T/bTyebmmWzgd79hiDdf0J2vl5OhNotJm/x2K/voWI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEboWCLyBe8Oy8Pk8xGiHwLk+nNsuh1uMYn4AXSH8Z2fKetm4GcHQ/Qtu+1mkZOT5oGRt82zbHG0heJqZA3iJ4yIOu7bqYciaGGfW+gS+JEKIhJV0LUoJoN+iko9dUovU/n+PM5dq3ieh8A8FisT/4sgUzmxISb933+R2j3YdZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=aK/KphFn; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="aK/KphFn"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7a1d067d5bbso161932785a.3
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229095; x=1723833895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rE3z53SxlgArsKnVp16449O9VmLlGGSseshi4KP5xk8=;
        b=aK/KphFnztu0k+zKP8edP0bMnNQdw8XwKsOGrSCximDQNbqvL4BBB9sN07E9hXt7i1
         whbj8jtVeOTk9WFyMeyh7NSaVQ88s8xeiIF4ZJXQT3SbInQuNGVPXnvl5RMYo+g1vbRs
         1C0LrT+RJGXEmqjvzcgU1zMWpT348pckPA4bupKyDHEU1eisoI7cyT4oCdQ6OCVSsMEp
         DG+lF8oGLlrFxg8hS9I05Mv01Yij8MS/izcJ/HnnbFShCu2Ap8Ip0qggP0u2j8pxe8G7
         MZLk0KLCXAWeWtkMkktrTAUfFOvw+4c8Rb1HHTyy0JiT2Fw2HIXfvIlYb/xfJQwV5vFo
         61zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229095; x=1723833895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rE3z53SxlgArsKnVp16449O9VmLlGGSseshi4KP5xk8=;
        b=MywF7R9zaT8nL55vl9w6ZB+IE2zqHLx09yuMcozh1yAMzbAVoYiwCzHS2R1ccAulG+
         BT9LJkP3cQQ5+IYeKKWs2OTDntme50rLp564HjDEug4PLqf9XL1TtMTeZh7AnCFBcMye
         hM/8yh1bBrURVua+ZRrXpPuDKPkPvinKtpc0O+zqi2YBnsqYLZibVl3EnXmkEr2aRl1L
         5yqJrV0yZQ++mO1Q7Bx02XBz0Q34ijP+rWy4VptKknI++6VgCT8r0g00H3tVrCkyWrO+
         QMBDo4oGsleETRNA4CC77xiOM6kc/+xeGqIAbS4r3AVd+afy0hbkQsVQfGSL+5L18ObF
         VqkA==
X-Forwarded-Encrypted: i=1; AJvYcCWEt6sYjiBx2TyXgbMlJ81KmUP4BQMf8so3t+th1VQ7NV9JTFL9xGwlu2DDCbxrsmUI7uXqYxNMf7OaDBYCcHHjhEx1yRZE7xgk
X-Gm-Message-State: AOJu0YzNxC7VmhjXm61T5l4g+5k+56b/bBfz1Yd0f7EfUWJA917tC1ee
	VU0P9fUoT5LGePZWvLufmDKrESIDAH0oU3xY43FUt5u6885UJkuH67uRiydAi00=
X-Google-Smtp-Source: AGHT+IE+4cAeGI2IrLHm9+QXQfJeM6o9eDiy6XNCvfHvWZenBULR3s4f7ggKi9MJTEoPvfkVGp5AYg==
X-Received: by 2002:a05:620a:2589:b0:79d:6039:783c with SMTP id af79cd13be357-7a4c17f0865mr249153685a.41.1723229094969;
        Fri, 09 Aug 2024 11:44:54 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7d820dbsm4254485a.66.2024.08.09.11.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:44:53 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 01/16] fanotify: don't skip extra event info if no info_mode is set
Date: Fri,  9 Aug 2024 14:44:09 -0400
Message-ID: <6a659625a0d08fae894cc47352453a6be2579788.1723228772.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723228772.git.josef@toxicpanda.com>
References: <cover.1723228772.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New pre-content events will be path events but they will also carry
additional range information. Remove the optimization to skip checking
whether info structures need to be generated for path events. This
results in no change in generated info structures for existing events.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/notify/fanotify/fanotify_user.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 9ec313e9f6e1..2e2fba8a9d20 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -160,9 +160,6 @@ static size_t fanotify_event_len(unsigned int info_mode,
 	int fh_len;
 	int dot_len = 0;
 
-	if (!info_mode)
-		return event_len;
-
 	if (fanotify_is_error_event(event->mask))
 		event_len += FANOTIFY_ERROR_INFO_LEN;
 
@@ -740,12 +737,10 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	if (fanotify_is_perm_event(event->mask))
 		FANOTIFY_PERM(event)->fd = fd;
 
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

