Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8932F36C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 00:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708992703; cv=none; b=FzBjW0KCQ99OSlXrd4P+2Iyvba8Wysak/q0IYSIpaAJTdNKyqfj8TeZZtGl3bEMKnv7wUbT/xCXm09BfzUNz+jXKZlqaPgSr4rPm9j0jj7pkpU0TJdUf3KdkCJiFX3lZ0WRgbk+/gCQnM5acnve9epa+3b8+iWPveyQOiMJEcIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708992703; c=relaxed/simple;
	bh=EgR6dqOTCwg4DOFLpm/xmzPppBOf0VkmnyX8bTmt6jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7KizOjrsSFzB5pkmZ43KjcfUsVgvPIRgH5Y4wV+pQC+Ze/0tiqiEjGOB4jqTQD8W0XhLork6p9msr7KWT/6GgGgSUnL5I5ndV9BbIXlFL93sJZFgjC1FME6uClntVVhleZRhjYg/KAmBkdeZC1xqbS4fewG7+QgPsG3Xct9+Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=g7tje9on; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="g7tje9on"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-21fa6e04835so1450561fac.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 16:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708992700; x=1709597500; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+daDMUEe/KGwIE7InYc8qLVYWLJEkumvevybGWZvAWk=;
        b=g7tje9onA/NKxzdJckQsdNYakXqw8SfB31v8ayC2NrWC+BDiLD/NePZWAfTf5Mxsoa
         hJdv9QzwfKNfnKhRueDVZhRQ1YN2Ck+7eawhX4jDwc8EoBkapyllRLYbbQ62tApR5nxv
         Ot8jHCh9qNCRRHrRss+p7JIUi9lPNWRkqeSgaz9k2tR1TprBfkViNLAWh9f34WV5Uo/Z
         XBRVYQ5p3u+tKwo8iH7LoLIC6LM1Am47CIrezlEu0A2dbrj/rivUQ8XGQ/+cgBz1Xr48
         0m+pQM4RvT8ikxUBiRXuQqJsCc25hctzP3H4OeOHxBmyWwkhKXhDTJrxJZFUQut1/t9s
         msEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708992700; x=1709597500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+daDMUEe/KGwIE7InYc8qLVYWLJEkumvevybGWZvAWk=;
        b=vG8uOxu+FZmnOShY1NAKCVVCFVjmsTremcTiMmTwD3hoErHYpyHOrzm6nIk4+auySl
         3NGShAKC2KZw9VkRCrxg9ogDCChiMd+US8sLaJB9XovYnDa3myQbmiZKGakvmajUmrMh
         1BuLLvqEot9zcJk8XY22y83DT72kEzRfeuqMMGLc5JfJRb9k9lmWP+hZGhbP74xQR1Oh
         s9ueF0oUn+BFTv6e7B20ojVLQdYm/XQSOTw3uP/iiEq3xB2l24jeRf2B+J8vMGOuVVK1
         VMxGlXaJvXe+adCgdu4InzG3y3yI4qxH5a8qc4SKxRoIyIWmqKYcLLs4rIyOYsg/kS1c
         O68Q==
X-Gm-Message-State: AOJu0YzGk8eWZ+G5kGHznNXcJv1KmaigNmxUFM12a+XkPs52USMgEs3F
	pIir7GtECG1eBuXHLR4LaVnTyNHPDXRXDfcOiPQV6+Vp/TLXf/kkZqznInv3gkEpYi7Z3YCneeG
	N
X-Google-Smtp-Source: AGHT+IGeIKtMPOnJHo1n+4XH33cOWfrYt+6WH/4qWb1TIHXCJ6DRgsJ/N0bHQYmXJJLXB3BMO3qAUQ==
X-Received: by 2002:a05:6870:ecaa:b0:21e:9a89:62c7 with SMTP id eo42-20020a056870ecaa00b0021e9a8962c7mr8222306oab.39.1708992700643;
        Mon, 26 Feb 2024 16:11:40 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id k25-20020a635619000000b005bdbe9a597fsm4491720pgb.57.2024.02.26.16.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 16:11:40 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rel4L-00ByRP-1g;
	Tue, 27 Feb 2024 11:11:37 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rel4L-000000030un-0AKW;
	Tue, 27 Feb 2024 11:11:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org
Subject: [PATCH 1/2] xfs: xfs_btree_bload_prep_block() should use __GFP_NOFAIL
Date: Tue, 27 Feb 2024 11:05:31 +1100
Message-ID: <20240227001135.718165-2-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240227001135.718165-1-david@fromorbit.com>
References: <20240227001135.718165-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

This was missed in the conversion from KM* flags.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 10634530f7ba ("xfs: convert kmem_zalloc() to kzalloc()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree_staging.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index f0c69f9bb169..e6ec01f25d90 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -406,7 +406,7 @@ xfs_btree_bload_prep_block(
 
 		/* Allocate a new incore btree root block. */
 		new_size = bbl->iroot_size(cur, level, nr_this_block, priv);
-		ifp->if_broot = kzalloc(new_size, GFP_KERNEL);
+		ifp->if_broot = kzalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */
-- 
2.43.0

