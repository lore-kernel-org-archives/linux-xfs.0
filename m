Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD5D6BFA3
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 08:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714034159; cv=none; b=s6a40G4CaL79X3HjAhZO10Alkm7DjF4lPgod+ZNfbv3Z+PBy62/jXLMT3JfLqja/i4/s7ZSzNGAeq3C4kkyTWzDObENJdlFbIIB9ZxYhI7fPEw5+w2LNRtI4NF/UGJjgYusqgPX4kK2Ziu1cj+UA4g6EBW+wiacYvT0a3QWMl8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714034159; c=relaxed/simple;
	bh=dJiNbOsPjQ9mkJhn856P0t9z3IUC+nYPv0VCnpV+ntE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCzdEiKytHe93SrOYJi53czMRInrApvWSj73ayxNBFtp8PUhwSzq6WADmv1czBIxLYh+pm1YEZn4ETqqTliTi1aGRZn/aETnkDL9CNHqfThjgFfbsBhXh9Z7YbqOSFoSqG6lDSxBURYtkeFgKL9OLNs/PN//8AqbXWutEWi9e/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOq7ZgoK; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOq7ZgoK"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6f0aeee172dso530290b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 01:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714034156; x=1714638956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtVSwCni1N47YHZ3I0HkmSaKxaX7+FUtONwpYIT1e/Y=;
        b=QOq7ZgoKqzt8+ftouoXyZ74d54EA63BC0PGZeNtf4mQCVXEfG7zQeAgnnyMNQz94+G
         ct4IWTQzIt3Yb5Q7snNXzvUmytCSM4pBi1cDGAAQRdAmTx7Oxdr99WxLau+a1RnjH7h5
         8mn+y86E6ofFs+lXcDiqP+OVhGpcHEzDLz22QNkeH2/KppS28df8MTq08ikAAVDvsBST
         mk8ws1dq7UiGT/fz81NYLtopupCI575BUxbL+QmVdxucEmqQDjT9mJFVjKaLmCI7uTuT
         hZekhdGdG4VfVimi9Sp1V7dzgychl3ElNoB2ZN9WykGrCjsrfrq3FumebVS8RZcphIfI
         hhJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714034156; x=1714638956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QtVSwCni1N47YHZ3I0HkmSaKxaX7+FUtONwpYIT1e/Y=;
        b=hptK1EdytYNatmCXbHT+6SBrbiI0JQPKhzDuDGAX1lpX4IqVXpnDmuoyuSeGlunR8Q
         hAQ8ADr8SjqYyRKZOB04VM+Xb7pQTv0CABchJzQ5jUMY48oCKD4CAeUKE8DrUMyW/FDQ
         pfSmpyTc7oBOESJsjt1TeAZ+atJL3R5pNfb73LFN6RpZvvfupJInc708ofzcKDi1689D
         EnQLyRKHxOiUmOqcOrLDUtjHzsJPHxNqxn7u+KQKfLRIH3Pw/wNJOoZdu6uSSK+ffWKp
         yf9C3ecxndw1WIQOBeArzSMcpFiKyJQAcHc7KclkAFOwX+xQDkdjASDO8obnnXjnSa+0
         jfpA==
X-Gm-Message-State: AOJu0YzNa25ol+sZOT6IY3tWYHqZqGO/jKm/v7WhcqrWz5BfOxobNgI7
	3DcKpIKBSKtGokRc5Yj7gnboiSWaXJn1DuvHP9Pbym46j0ciuYqIVIQFkKLr
X-Google-Smtp-Source: AGHT+IF2+mNi/DK/cHVk5jtYcc4eqoYMVcAPPANMV2ApdLFRPpQebBfxFIbA0AgrnFYO27ukngzX3w==
X-Received: by 2002:a05:6a00:1399:b0:6e6:fb9a:fb45 with SMTP id t25-20020a056a00139900b006e6fb9afb45mr3364405pfg.1.1714034156536;
        Thu, 25 Apr 2024 01:35:56 -0700 (PDT)
Received: from dw-tp.in.ibm.com ([129.41.58.7])
        by smtp.gmail.com with ESMTPSA id b9-20020a056a00114900b006eaaaf5e0a8sm12629989pfm.71.2024.04.25.01.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 01:35:56 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCHv2 1/1] xfs: Add cond_resched in xfs_bunmapi_range loop
Date: Thu, 25 Apr 2024 14:05:38 +0530
Message-ID: <f7d3db235a2c7e16681a323a99bb0ce50a92296a.1714033516.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1714033516.git.ritesh.list@gmail.com>
References: <cover.1714033516.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An async dio write to a sparse file can generate a lot of extents
and when we unlink this file (using rm), the kernel can be busy in umapping
and freeing those extents as part of transaction processing.
Add cond_resched() in xfs_bunmapi_range() to avoid soft lockups
messages like these. Here is a call trace of such a soft lockup.

watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:0:82435]
CPU: 1 PID: 82435 Comm: kworker/1:0 Tainted: G S  L   6.9.0-rc5-0-default #1
Workqueue: xfs-inodegc/sda2 xfs_inodegc_worker
NIP [c000000000beea10] xfs_extent_busy_trim+0x100/0x290
LR [c000000000bee958] xfs_extent_busy_trim+0x48/0x290
Call Trace:
  xfs_alloc_get_rec+0x54/0x1b0 (unreliable)
  xfs_alloc_compute_aligned+0x5c/0x144
  xfs_alloc_ag_vextent_size+0x238/0x8d4
  xfs_alloc_fix_freelist+0x540/0x694
  xfs_free_extent_fix_freelist+0x84/0xe0
  __xfs_free_extent+0x74/0x1ec
  xfs_extent_free_finish_item+0xcc/0x214
  xfs_defer_finish_one+0x194/0x388
  xfs_defer_finish_noroll+0x1b4/0x5c8
  xfs_defer_finish+0x2c/0xc4
  xfs_bunmapi_range+0xa4/0x100
  xfs_itruncate_extents_flags+0x1b8/0x2f4
  xfs_inactive_truncate+0xe0/0x124
  xfs_inactive+0x30c/0x3e0
  xfs_inodegc_worker+0x140/0x234
  process_scheduled_works+0x240/0x57c
  worker_thread+0x198/0x468
  kthread+0x138/0x140
  start_kernel_thread+0x14/0x18

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 656c95a22f2e..44d5381bc66f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6354,6 +6354,7 @@ xfs_bunmapi_range(
 		error = xfs_defer_finish(tpp);
 		if (error)
 			goto out;
+		cond_resched();
 	}
 out:
 	return error;
--
2.44.0

