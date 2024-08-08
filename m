Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C4A158875
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 19:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723145302; cv=none; b=Sh5pGrLWxrXaPkv5qUuTXXoTwk18gng1RcTFaR0zBjPq8r8zgRp/19C84L/6eEvGHiZLjQkv0z4XJXsttgNHGWlRRnnWtjSwOOL94S1awhnA90FNPvFWOT3dV/sKOvRR533U1pr3AVbSVkxYDsX17U0DENXqLhJz81NWDaEGIjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723145302; c=relaxed/simple;
	bh=2T/bTyebmmWzgd79hiDdf0J2vl5OhNotJm/x2K/voWI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSLXvGCSFRaoZmROs76iWP3HiaOE1Ouazrir0t6GLuJRXALYYK04j1yxtjAK+I6QY1zxk/u/b8GRSW6Xyivl32z+OYhzVrKHXlRhBmIwgrh9fBTsAjWd3lBTP+ZT/P4oc0i36QhyPXsCURhr0gDsYOc5EQsDrbIsoMMODqtkW8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=3LpYCTl+; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="3LpYCTl+"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7a1d7a544e7so83797185a.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2024 12:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723145299; x=1723750099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rE3z53SxlgArsKnVp16449O9VmLlGGSseshi4KP5xk8=;
        b=3LpYCTl+TTMHPOVTFUjxbAP5FdreSyhgMqNnVG8AMrrjShiMrZMhLtgidkLT/MJPDI
         WiATpKWSxlMkGnVpxIWnB4E/kOAzfn8XJY2Sid4QEFbARfIW8/znKlX90QQtEudEr7VC
         WHUwWDfSyathT4saIRCmEnaugWGKfY9PnN1M+WxnVPvFGrv2YdoakfB2RgvWbqEVC2Mi
         jJIYqt/17FcXGuQRxAmD/5iNfixztyyZ8b1dKqn+oeaOE2/MCEtp1G5JIbAcrSOYvATO
         4gadLdC8utv4Jl3KgNDdoT0eRdZWf2iST2QeGK/URMvSXAdRnZIN6nRR+4fLV0dz7B5x
         G5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723145299; x=1723750099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rE3z53SxlgArsKnVp16449O9VmLlGGSseshi4KP5xk8=;
        b=JPrXYiORDIlUD8lr33y8W/CIG9mgydDBd1NOZ+DknAhWzOLseHtr9cemhdEMx+cQuH
         51VvvnGbxN4VonhWQBsO9Y8rtrg0D1gXQq1+nXlF/uvnHacQr9WkFDM/IsCaMO77egxi
         0a+kHcVEN28Ow0YRlET1z32nMD+UtxBbJ8fTRSL1zQ/nJT/X2b26BnnqQkj0i0LvphK6
         cZN8M3zcfOqYaebA+i59dBZgvC4UgbUdgZ7+dz4QxD+Dqyo5BZvptAXzYN43ZfJO/feP
         NQ75Hr9MdR7SEjNCYyBZtgBpowMCdyaJpaFUaZk8CsfyAb/hmf4X9f0VNshFl4nbjs9S
         sweg==
X-Forwarded-Encrypted: i=1; AJvYcCVoN6PVtGXnrBoxbFR24LqIlOn9XO9udRXqB0tUPzS+cjgtFmLQUx7VTteYe86ZgbUlOs1Uhh6CesDaut/VTglFDbLN7b6qill7
X-Gm-Message-State: AOJu0YxH4P5tOhF6/DRzmU9GMzcZDfKw8UWNvMdo156iWUgedoMpWsmz
	YyRMOiaeHi26r4mwIl2mrm2g2T/iJ3VdbtCRebAV8tRUMIcWJheAb4OE2O8Os8A=
X-Google-Smtp-Source: AGHT+IHIPxOimm17lsK2mRhrmoBs8JQ3/lrD4oPi09uZKL/T2UFWVQatxODNJLMYL/PxGf3Q64nPmg==
X-Received: by 2002:a05:620a:2596:b0:7a3:49dc:e4c8 with SMTP id af79cd13be357-7a38183e77dmr296678685a.31.1723145299430;
        Thu, 08 Aug 2024 12:28:19 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c86ff90fsm15610521cf.5.2024.08.08.12.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 12:28:19 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 01/16] fanotify: don't skip extra event info if no info_mode is set
Date: Thu,  8 Aug 2024 15:27:03 -0400
Message-ID: <6a659625a0d08fae894cc47352453a6be2579788.1723144881.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723144881.git.josef@toxicpanda.com>
References: <cover.1723144881.git.josef@toxicpanda.com>
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

