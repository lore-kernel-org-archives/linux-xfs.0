Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1C63DDAEA
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 07:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785223172; cv=none; b=foJfvd3ZLNM7djK4mdrkyvbeH/OLz1WYDnzCtojLhTSHyGPdiCeThgEccXk4tnEAlnVp0stwO+RbwYrADL/AWZLuKXxFGC1h5BrpDC8xVmUmCdacrD6nF+HLy0cCcwxwUYOXxDwINWRbLQwaLmVyA1YVvuuI7UmstKmYayoNAJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785223172; c=relaxed/simple;
	bh=B/tEtOff3mXWMkusIR5hXxc+CXzdsKI4VFS8H6AoxSY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hAcBBf1vcsYep+r5jXQdak0OoDlfNLAYBX49yMaN2AmELegH9OBszf4M8SfENPe1ysGqKiuYM78Ul/tuWBdEThyw/3HCgb86GbPWtfmvyNgRaPil0Pk/mEpVXMzOEg/WFWsSVTRh2zGGackygJZhXNAKHTV835uGKfS2iLz3CR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FlcszQsF; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FlcszQsF"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d01663d816so2811735ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 00:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785223170; x=1785827970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xh/gHs1jAvs3mRq2XK2BfruBHbrtemacxFBys8zAlQw=;
        b=FlcszQsFeUQ1i+5Pti4pW9cfdRLNqtR2WpFO6b8wxjbnAhcdz3K9Mrvu6+Dzla9i3m
         wMoNUh1au3hmln8Xlj9+X4stbFtRDF551C0iBvTEx9sRBJh7nOmBTWahd39/4dkkB0z+
         K8dOPDnXzqFw+w8NX1BJW3nPte1WpFlfyaRc5K+W/nFQ5ES07LvOXxs3vzgH/sayiP+K
         UhwpZlF5Cj8bh4gizFeU3w4kd+bDlyfkmu8XC+E8sn9NcGue1LWBWYicWBffikoPjBc3
         YJHDprZC0tcu7Va6x7Zzlx2YMTs43hcxUI6Vv9OgLsDu80z23aWjCdqBq1TX6NtyEXaP
         oU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785223170; x=1785827970;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xh/gHs1jAvs3mRq2XK2BfruBHbrtemacxFBys8zAlQw=;
        b=C/g5M+HiugbYbtHBgQ9OKM+9gSILao8uqyM+gnWCLPJpxxBbgsiCzs8MQAV5PULbXd
         0Pl4rDFopSxe3VAOC5O6kzhqrnwqYnBTiiQGKHC/Hl2Hxd1P4b+tDnIqmoHBKaQEJ/hz
         38GacnmRDDiwhHgccAZOj2BIQQUrTjXmtwHbSHvW7F33TkcdH/wubDm59xwGTpw9lMmH
         PkSRzdabZxHOAQSTe9o0yeoMstRUUcyOlJ30R4ZGpXY0BRIx8AgiCiGAONnNkpF6bJBU
         sxMtHDUmGM2DdTpbMN+e/UqMc4scnkhBda5EMC59ZcIxdPWrfTtOhg5f5lHHUadBLoIN
         O96g==
X-Forwarded-Encrypted: i=1; AHgh+RpC67zOeCSzoJcqPtjP+9/kZNLAJIhRyQJJC2hZEmXH23r3/eWwj8bxSXsvRNLgFeso9Po6nSzK9xE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyW2CYSXSqWMrEXW3KucJFpO85rPDz5th09brZjxImvYmyTfsD
	Fufsmdei47ttmiawNddNeyYGXmgWnZJ9Bo4cJcihfD3KXb7HzqET139T
X-Gm-Gg: AR+sD10AgTalG5AC9mbJBVqzwlNejXMtlbQfw1sOfY5qcRvcYm1hSjaoL3un6vwSU0n
	WXnyyTEgzN5N+iNA6MIZ0zZfUMIJKozKZ0DwPUF7r60lDY6lfyOnSRsIS+7+DxmEAMzSALav+zu
	W5ezIQ2Z3NCI3z5jiyDvymYhpYkA8HVXuqrKKz5OFCcjd5c4/iZFUWzCX+TyBuu3pVYBpLiuz57
	OeNd9XYTXw5t8JG90WEyE/KIwD83FZlrhD/av9QQE44Vfcnq05T+HKlNKYJRW0OlSndsHrY2nCb
	TMBQD6jjj3RtlGhsqd71/6ooVWYwF2Z0tCMmDw995QGEZI/pLRmwvhznO1W00EGByXL3eqRABPx
	4RhbrG4pz+iEQVg04n0tgtxa28RFwUn186O/mKyt8IEGDqris5JQkIr3mrr7UogDU3HOHBjFDho
	enLbmRHHehEIs1T8vuiuCNl8ksqCQkVtvyCzWQ/xYWjZH0mtJjQSZdFGftv6I/LqEWLpeZ3xoV1
	7odDphTed8MBnwIMsmBb56CO46uQu0=
X-Received: by 2002:a17:902:f709:b0:2b2:67ca:5ff9 with SMTP id d9443c01a7336-2d015902adfmr16876015ad.0.1785223169512;
        Tue, 28 Jul 2026 00:19:29 -0700 (PDT)
Received: from JIAPENGLIN-MC0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde81d849sm46665115ad.81.2026.07.28.00.19.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jul 2026 00:19:27 -0700 (PDT)
From: Lin Jiapeng <ljp1205831794@gmail.com>
X-Google-Original-From: Lin Jiapeng <jiapenglin@tencent.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: stable@vger.kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	jiapenglin@tencent.com
Subject: [PATCH v3] xfs: fix exchange-range reflink flag clearing issue with  INO1_WRITTEN
Date: Tue, 28 Jul 2026 15:19:10 +0800
Message-ID: <20260728071921.81156-1-jiapenglin@tencent.com>
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
Cc: <stable@vger.kernel.org> # v6.10
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

