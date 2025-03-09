Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C8040849;
	Sun,  9 Mar 2025 12:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741524099; cv=none; b=lM/icdBKbBxkhQBZ5AfGznTmvq2tQ/HXQQ7AYQRzix7dKeD0ffGw6lJDG++avVXCubxSJy8An5/YhSzsJf7UJHCb4hGMLx02YkBTruzVHODG8TsfAkXpiC25lhHUKZsy5SN/Mm0Xp0a0A/96o9m3tHOfXChJiSfFW0Ey0LGE3zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741524099; c=relaxed/simple;
	bh=NIt+fjpsQJoN/ng/Mqi+At1plZSlaOyMv2eBpoBoMUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFvRe5Pdd+vr/LqgSQNoHo9dUs1rmFeqaUArMzplqBkwpAjPF1y1aY/QYr9CetS5gA4T+2mVcmqVSB+QjH+P1GpE4xsxIxKUnXp9ujUGiKQbBpzOAD6SSlmF48zrU6px4HB27w++3AZfMgfWQOpZDFyVrzTr1S5jPDMXXSMrKTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iliK6akz; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iliK6akz"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ff6ae7667dso6471272a91.0;
        Sun, 09 Mar 2025 05:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741524097; x=1742128897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3heT3TehvrAt/IC6wSWllFV3+o7dpz5h1Lr7V7n2HJU=;
        b=iliK6akzzwA7gDruZdnjjTZu+7Ew4699//H5Wc5Z75xIknnhNRu1u3LJ/oBLJ3omTW
         HltdMu7XCRapALkpReNQmzrCapGgM/BfdedzAsatEzfiPerCkYNnm6ZXs3+CLa+vWT6N
         kjZs+4izfcOGefh9UZKaqRRG4GCpzSrMCsUovfNw8/G9YTN4TFJaDvrpfg1L1kC8wz4G
         7bGRVT6RX1/X/mkDXwZUa7J31MRFpblcEoS4CqsO2kHjAwWZtKiw4yQEPFtuOWYjdag3
         JZkaYM79vPSktXq8QYON+Kl0YeBgODxA1IPBpIoTXIGM2FN6f85Ftye3UUXASCPV2kKM
         JpYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741524097; x=1742128897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3heT3TehvrAt/IC6wSWllFV3+o7dpz5h1Lr7V7n2HJU=;
        b=XViiEBcJEbydTpD7ILGap/vi4+ECSH889Qe+uSwOQqhxhurg1X3dZrN44JleKXledK
         xdkcP62Sl/qNDaqjilxpM/R+7dLEhQ2Ku9EyHqywixwaFh8lKX0Yc59hYhAvMe6e3x/v
         q06d7BSBcV1Uj2qHZkIIdRfdEK5HsRR+ak+S4HfZIOKCAad+sCIEzc+DSzv5+bkaiZj4
         CSOWCMHPXQylqiW1iKvp0kG8GIEOxisY8m0XRQl0/Y41GdQuLe1QeB8a6FWa7GlUoI4M
         4/xYdQsqRRUFK6sONrREkUkKCOSovn6wOTRemJQ/ZEGUOLNe7cqsKFC9f9S6v2aYu9Lv
         SQvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFNaOUPn8sgxA2YRSSGFKE4ps0VtxZamsksQFu640UpDY48Jf77DNxssbHVDbIPi0ByBsbQGBud5pO3Y8=@vger.kernel.org, AJvYcCV612B1Tsf56uVPXwKGzF1uSEgEgKDlFXzQkF6+NBpBM4lipF3ev1v2MTH8VoCwgzcT3YUxI10jt4JV@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/zJPgZPzimue4nEtRc59NSWyvFrltZSJJqeM/zy4VVieu5ASM
	v2Vr4XeVxKXBpbMbuuBJ3Du+jNprpUBi1UvUmC94jxVPaJxzQsUJ
X-Gm-Gg: ASbGncuKuzUKWWXKQa2FM7PPgwQ2xpeRqLdlaIbkMx/hqoxu66TZZBrNkvaIRtmcN6r
	7W01xTbkXP75hTAk/8RJVZZe6Zt1PMZYie6eqksmFJtV4QUxfGv5d4FnoISuncttatoNiJ+feZo
	ZwsYljSLuvoQCVUDUQMuixugqzrQNauuifQS9LBdrqMaMrhCMCIkwCQSJOgwN15v8LVQJgf/G2F
	GL2uP52Dk9tJCaSLJe2+6IGMezbEYAMonGJ5RX61CMY3lTHyQ+RY3qT+FBIfG7q51rm2WqB/peU
	DtOU8K024QPYNlmW6HkGACURkTKK1eQ3YIIskHZ/kdicTLcjwaMlP3r1oyYH
X-Google-Smtp-Source: AGHT+IFu2X8y0Xhh768uWe61TmX6SKsfM5J5IifCobUJX7M1EYUMJX9eUXflb5qFK1PMqHHrmjgsig==
X-Received: by 2002:a17:90b:350d:b0:2fa:137f:5c61 with SMTP id 98e67ed59e1d1-2ff7ce7ab5emr20089393a91.12.1741524097203;
        Sun, 09 Mar 2025 05:41:37 -0700 (PDT)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff728a901bsm6056388a91.49.2025.03.09.05.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 05:41:36 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: david@fromorbit.com
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	cem@kernel.org,
	dchinner@redhat.com,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't allow log recover IO to be throttled
Date: Sun,  9 Mar 2025 20:41:33 +0800
Message-ID: <20250309124133.1453369-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <Z8YU-BYfB2SCwtW6@dread.disaster.area>
References: <Z8YU-BYfB2SCwtW6@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 4 Mar 2025 07:45:44 +1100, Dave Chinner wrote:
> On Mon, Mar 03, 2025 at 07:23:01PM +0800, Jinliang Zheng wrote:
> > When recovering a large filesystem, avoid log recover IO being
> > throttled by rq_qos_throttle().
> 
> Why?
> 
> The only writes to the journal during recovery are to clear stale
> blocks - it's only a very small part of the IO that journal recovery
> typically does. What problem happens when these writes are
> throttled?

Sorry for the late reply, I was struggling with my work. :-(

Recently, we encountered the problem of xfs log IO being throttled in
the Linux distribution version maintained by ourselves. To be more
precise, it was indirectly throttled by the IO issued by the LVM layer.
For details, see [1] please.

After this problem was solved, we naturally checked other related log
IO paths, hoping that they would not be throttled by wbt_wait(), that
is, we hoped that they would be marked with REQ_SYNC | REQ_IDLE.

For log recover IO, in the LVM scenario, we are not sure whether it
will be affected by IO on other LVs on the same PV. In addition, we
did not find any obvious side effects of this patch. An ounce of
prevention is worth a pound of cure, and we think it is more
appropriate to add REQ_IDLE here.

Of course, if there is really a reason not to consider being throttled,
please forgive me for disturbing you.

[1] https://lore.kernel.org/linux-xfs/20250220112014.3209940-1-alexjlzheng@tencent.com/

Thank you very much. :)
Jinliang Zheng

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
