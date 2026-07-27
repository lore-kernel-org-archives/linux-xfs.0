Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C3E3FE64E
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 12:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156742; cv=none; b=GBfsjiP+xNN5iVIJV6NeLUxtygRBstYCvkuVQsUg5MjYieEIZTbgz8DJdEq4ZNyw687sOUl7W0BWKR/uVTJ9aMrgKDNgMdqdtZe8Uc32oDS/7hWQChOsoclpO/OT7oDZU1ssLk7nMPrqvaYBM754c6hLgESgwEA36LBHLlFNU/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156742; c=relaxed/simple;
	bh=Mk+aSmRtnc7VXZ1Sj0oftf32acPUng9c8JpD9JPtNbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MejfRgwes4zhiE3LqLDN8izNXCCqQGZyk8vCjl9Ud9ibSzjWxBPSMYxfUQg/LF3pBNGVyxj5+RS/Z6NbhTjjGX/IlvM/aZAn4IB8s3YX5OBijm7AMAvmERJSCmfuhCs3X8LFm9m/MoUrDP6gDSxcjnmmpFVdaHrkuH2dsDSaAEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CqUrykoT; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CqUrykoT"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2caf228a910so19794645ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 05:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785156740; x=1785761540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5rmvb0S4tEI37DfKVdNdDGK3575sQGIUhWUSJ2ESEpw=;
        b=CqUrykoT3wtf6vyKTG7VZyEo8sE4Y1phu6bO5ERarMvYoQK8rMUQMjcVlRDYH2i7Wh
         8mZsBtE1QfYSrfFf4V3z5YsW5KIJ+fSeeZ6O7FgpNF+CCKkLZItmRfLBFw9sA8bE10GH
         mjZeHx23lmAZ4T9gZ7SHXxQGHmifyX2qifgg+TyMDm8U7gvf92X+PWoLc4bhTY3RXAnI
         qhcRd2jjyZb3jaebyb/y0iDa5NGJPBayEz0sAvFWWs21kjX4aZtanBHy5dVNJwAeKAfp
         Svbj9PrBVzxNe1n5k2Ub7dkVsy+5WVF8ub7zQBeMcPuRh3b3w5To8zvrfUh+MhkO6GNd
         K85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785156740; x=1785761540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5rmvb0S4tEI37DfKVdNdDGK3575sQGIUhWUSJ2ESEpw=;
        b=qpEkk2N7zUCW+Xmyh3pP/kJwzCTQ1WGQ2l2xeTQH6ewgVjg5o6zc/lCI1A6iksmhRp
         Yyz0Zct8+WpjdjGj//67Nk1bx5TxXJxTZ7y6FJgyvYnTjspaXxEGXU70lQSq1IeE4u2p
         0o7l5b4/JrJ4GiuJyL4tekcO4KozdUaxQZEdCrXcoS4nGCKoosyD5i5xmu62086nCbmp
         D9zwGTHf7eGlvxYGcIAltaUMN3sv0nrzHYBEhRQaDS/CyzSAp3vmbp/A04M1kUAOigpA
         Wm6TBdCQx4i2nJEoh+6Cen1N9OnNwPG9lmfaIUiVnIUhUsU7wRGbyfIutiE4y5NLzXPG
         MIyw==
X-Forwarded-Encrypted: i=1; AHgh+RqidBXdfbOZNgGaFpFJTQvyGIVQGYGNJxxANj8EbLVNHta32NrygqANSP2UEMRAK/mmQRHZsF2xtL0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyN7fnJEFIvB9KfmyS8MsuWX7GgK8vWwuv7n9CnXc0ZR8GR5vGS
	4K9F61O1ZS9I/TwUf6fyzI03oj/iQ03cCVBGvjM7soPV5loSOzzqDVcAZc/mIDV5TZdsBZaE
X-Gm-Gg: AR+sD13z10sprEbAq7NtFumti9JRCiNQpHNWpmpxqi5fvAiEck+Eflc0As0kBjnDAVi
	ZYt2HJHolT19xK+RZb0R2bE01KKyRU9WtcWOnX5ThYlQYkcqFC6vT2ZEP0vH9I5Mfn8vlHBGn32
	FSLwCLTrzh6KV9oHfqzwEDoka/r2scmGOydteVxGTQNcAXl1JoMqzOqaVrWlZAE8Prr27ypQ3wE
	gdWy9emjN0WBYzparPeSYJoGX3xP1+UsnDXui/Yyx9fXeCeA2ZrUCIJG4WGUEzuiy+pQ9BSJfny
	NAPUHVimVWVGZaQnwkOWDA9cxT9pXwvX2idb8Gu1/se+1Jd9y8B3mF6dlsDVt93BDd6bg8pXtmL
	06f8vuGwYNHfyS+3YhHrfEX/iXkT2cm5lLfrdoTcnMKsVPk4Q30jxjQx/Pk9dVMRw/oHwSEV+ln
	gb2q+xDrZZZojcuHoZ2rYYjWMtPadjIdi6YwxtwowuAZZp
X-Received: by 2002:a17:902:ecd0:b0:2ce:e75f:b713 with SMTP id d9443c01a7336-2cfde85f81bmr79315895ad.23.1785156739927;
        Mon, 27 Jul 2026 05:52:19 -0700 (PDT)
Received: from JIAPENGLIN-MC0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde81dcc1sm35033385ad.84.2026.07.27.05.52.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Jul 2026 05:52:19 -0700 (PDT)
From: Lin Jiapeng <ljp1205831794@gmail.com>
X-Google-Original-From: Lin Jiapeng <jiapenglin@tencent.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: stable@vger.kernel.org,
	jiapenglin@tencent.com
Subject: [PATCH] xfs: fix exchange-range reflink flag clearing issue with  INO1_WRITTEN
Date: Mon, 27 Jul 2026 20:52:03 +0800
Message-ID: <20260727125210.28329-1-jiapenglin@tencent.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When exchanging two full-file ranges, xmi_can_exchange_reflink_flags()
can move the reflink inode flag from the file that currently has it to
the other file, as long as exactly one side is marked.  This assumes
that the file contents, and therefore all shared extents, are exchanged.

That assumption is not true when XFS_EXCHMAPS_INO1_WRITTEN is set.
xfs_exchmaps_can_skip_mapping() can skip hole and unwritten mappings
from file1, so an exchange can complete without moving every mapping
that the earlier flag-swap decision accounted for.  In that case the
post-operation cleanup can clear the reflink flag from an inode that
still owns shared written extents.  Later writes then take the
non-reflink write path and may update blocks that should still have
been protected by CoW, which shows up as data corruption between
reflink-related files.

Fix this by disabling the reflink flag exchange whenever
XFS_EXCHMAPS_INO1_WRITTEN is requested.  The contents exchange can still
proceed; the conservative outcome is that both inodes keep the reflink
flag.  The regular reflink flag cleanup path can drop the extra flag
later once the inode no longer has shared extents.

Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
---
 fs/xfs/libxfs/xfs_exchmaps.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index dcd0bd0b13b4..3efed37cb98a 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -959,6 +959,16 @@ xmi_can_exchange_reflink_flags(
 {
 	struct xfs_mount		*mp = req->ip1->i_mount;
 
+	/*
+	 * The INO1_WRITTEN optimization can skip exchanging hole and
+	 * unwritten mappings, which means we cannot guarantee that all
+	 * shared extents actually moved to the other file.  Clearing the
+	 * reflink flag of an inode that still holds shared extents breaks
+	 * the CoW write path, so refuse to exchange the flags in that case.
+	 */
+	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
+		return false;
+
 	if (hweight32(reflink_state) != 1)
 		return false;
 	if (req->startoff1 != 0 || req->startoff2 != 0)
-- 
2.50.1 (Apple Git-155)

