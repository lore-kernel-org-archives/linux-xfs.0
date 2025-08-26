Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1323728A6
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222923; cv=none; b=g+r8O/flZn8vf/IThhZpe0so+6bkEIb3ExGaQjA+BOrkljxS/6lf0Fg9f3EtTlSGofwefZZZ3W0Ry94RviGz4y3DIVF14v5n21RhN0jyw3J1rFAuK3m9HzyqV6UWaHUSdPt3iB4rHIA6W09ri2dqYvt7p3F2R7Lhb7IWopzj3uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222923; c=relaxed/simple;
	bh=MRbjz58EJk2DIV/CMfsuQeru3Gjlj5upRwbvX0t3mqA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pts9Pren+Rg8Jl3BLENI6jM4OE2/g5wsbnUc8gfoZZ44feCXuurmCJ0cgf5LDEDFFz8UT8dUM7jqu2nUzQ8I6CIKzGEJr6blAodNInffoT+dyOOv7Au/QFSAbdjnzObRvS5lNfUZb6yXm8+7m2dD671EpHzBq1Bl93NAs7bDbg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=BILrCV0W; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="BILrCV0W"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-71d608e34b4so45882137b3.3
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222921; x=1756827721; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h6Y2vCrhkZTJ22Wp+VyocA6nDD0iA/acEwKo6i4LTMQ=;
        b=BILrCV0WYnWT1+2jq6fXe3vKn1IHeBBILGrrJVAnTnpJcJYKAMzR3plnA76m6YeXxF
         a6pcAgQ3YvsnQlJBDZcbjUKnbWHJIRT+cixh8gcWP4ozxfkU3ayzIPS4WbvCgVM1V1J9
         JivlLLAyTLjmRyOshv7iUp7r/q08xiYFz/EZOzzeVwBZrD+XfNGu6Z8H70D2dCsk7QVB
         kMEYOeV4tsj1mLQdqgYFePAosHW+XMhrIGGEFCXaEAWEtoZarqJJMIzyqhK4SfnsdTzY
         duTPScZDefdP6Ngt2VeLd7tNlT3lkFmPY6rGXWhbi9BCBCri92kMMlbCwHc8levsNrco
         GlmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222921; x=1756827721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6Y2vCrhkZTJ22Wp+VyocA6nDD0iA/acEwKo6i4LTMQ=;
        b=ZFksJMX0wg/NJOZZDZoqlTtkQsXibf28oTuojd7P/4msB13sRX+hzHhmhIRXwKX4Au
         vYj/4EE40EUvbhtJ6rJRaXi3VdI6PNxSM+QJ12LmfxhZPeB1rUTE78cEC9KF3wiGUNAZ
         esc9V65pBoucxu/EfVTd5lfehMl05Z3xWnzBkDew92Qxs8M9b+LctGnyNOYcAAm8Sopn
         jyOUhEsc9+5uEGX8Zl2WQRAzy0//gFsJkxNuc6bMENGW+Y/yKvzxmUS1pWIkS2eqqQzB
         anMIkAV1pqooB0DB4IQxvkBHTt4fp6hU2Z8G5J7QiaiMWDaZ1Np1XXuKjOYaHMbzf+o8
         bRSg==
X-Forwarded-Encrypted: i=1; AJvYcCXOKavlA1fiP6WGKXjhUeDxMI9uygwWj6FaImOLDU+fmgTEUKhoK8SoYaHVpiLjw+ut4Bk7/S9eJVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwErZdhS2Lwwcw5Vv03XVHmitQT6axwGpNU6WtHvoPB/MtklDdu
	SF10dxM5EqS5cM1oVg7GQvgxihRuAbTemtodoPHk4IDylt6EPsDmB6Sg/x/X37b6RGFxWeK3imr
	WSBm9
X-Gm-Gg: ASbGncvapngFoeaWoSLedqouWnh1ctzJAd9wj+ywZLaCjh/jNUOZ+Ggyf3arG+oLvdT
	q0H1vVO0BPPb1pnMNpzyoZ6rHMQe7jdde48fHfJwKyIy0wywOrUwQkPPQ62DcGdKKPOr8gCi5ap
	TF4knyOLkLLwQTVsCjqJN1vHERGdem05dfPzj1np/wX3ho+I1EoP7Q/19z9k4IPwW4AIO+NdZLq
	vIq/i4XeD+FxQhCCvh/9+D4ogRLsPsQjmqRhN2rtwFtpyHZ16icziUT6ENS8BqAQkq4Hqw9iBun
	d9gaUeXPpPaV0ExNPJtGtVN1GWHow8/xhSKKMgI+qqYi1WeDLYMwJ93AMPxuY0Dvqy/Px9Twdut
	usdxXJVmURfS+I4W9TNzIcX9sNreRMYYWkKkvx+U5ANTIzVIEdMtDEAIJtMd40eIfWMf2GQ==
X-Google-Smtp-Source: AGHT+IEMOMVn8rVVn/LrSUqLRsgPs8HrTr922RJlf5aayGldBVTuMlA9OhISdmU7x/PsUdxbw40paw==
X-Received: by 2002:a05:690c:680c:b0:71d:5782:9d4c with SMTP id 00721157ae682-71fdc3e0679mr159524887b3.28.1756222920808;
        Tue, 26 Aug 2025 08:42:00 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5fbb1a885absm419060d50.4.2025.08.26.08.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:42:00 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 49/54] xfs: remove reference to I_FREEING|I_WILL_FREE
Date: Tue, 26 Aug 2025 11:39:49 -0400
Message-ID: <681053424e9eefe065dc689a325e94f79d0f918b.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs already is using igrab which will do the correct thing, simply
remove the reference to these flags.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/scrub/common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 2ef7742be7d3..b0bb40490493 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1086,8 +1086,7 @@ xchk_install_handle_inode(
 
 /*
  * Install an already-referenced inode for scrubbing.  Get our own reference to
- * the inode to make disposal simpler.  The inode must not be in I_FREEING or
- * I_WILL_FREE state!
+ * the inode to make disposal simpler.  The inode must be live.
  */
 int
 xchk_install_live_inode(
-- 
2.49.0

