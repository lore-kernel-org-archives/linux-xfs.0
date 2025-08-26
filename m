Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AE9371E97
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222918; cv=none; b=tm2Z6Wt9H0bS7d9m/+Zzsd9SogavJC5aBnMA6cYzmegNPPUWoW/Qv7dwi5SsMpk6NvIH8q3mafLHyI5nLgHhuj2bPvKaCmnZ+18/jG8Zk4MgVJmTOv2I/0XuQs4dCzmYmSOBH4XQmEPBBpTSX/5IAhHTba+ZGbeStryDX1hURJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222918; c=relaxed/simple;
	bh=tkUhaR2Wdt5kCnisT2HbbJH/eYzoHj1oGz3hiKRRSd0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsU52gK+Oi9nQM0UUEpG+py2Lckw0X0YZPiXi4PvY5BAYJ2xl6/FLZiayQ9a7eI17pspkRjAINQ6WcZcIT4WTLFddGhITdcpmhHhi7hgP4MZDxVQp/ziSBQtPdLvf3+K3/nn17BWfw+tC6bBrPGhC/TqJmlt+nXszdkbjzHgMLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=c5I2z7r9; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="c5I2z7r9"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d60501806so45868257b3.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222916; x=1756827716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=afAll3Ztw+chy5iK2sURo8W26thUm5pr0Qhfoj2rvnQ=;
        b=c5I2z7r9VVzoxl68ES1Z25gV+d6w6eJYv/6Bxlte/oj+84QvjtChOCwiegislYCmfg
         XFUBdiMCkmH3DimoO3xk+iXCCb/LektHh3tcGXDDRWBIL90wQjdtXCZ5uE/cs0KWovWF
         /eNoBYpC+RCgDGJS7HqroABXV8u6Hj3uQtFDPUdszi8bmi0c+UWIY918xSW1pjOTwKw4
         KJrsLIgxJ+FOcFyyrHaGWcFeEd8/FQ+AHBsDoI/zuInW9+lwZGnESZc9wMLr0NzhrIQC
         33lUYMb++s0q1v8cBpgCZ0fMEfZaZsQt+Wf2K5ERzoSXXY1peHTavVx/0Jr57qARt/X2
         C+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222916; x=1756827716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=afAll3Ztw+chy5iK2sURo8W26thUm5pr0Qhfoj2rvnQ=;
        b=rHiXQJydqrba60WinZAh1tf/XyTYzpAk7a836P+vV1Jh6dkDdi0jzKUWwbvodcAafJ
         slrzHoW0C/m6wNSX7QDKrKJctVyp001uYgxnjvapjuCllI77kejUdZ3jEAOm5txZALy/
         XDCHlpeQpQH/gn79gaMbMTJyLdkXzi8q6ST0RK9Y2C/58Bd2QopzHcYhESfB/6/ZCPIM
         zmFSmXDXnzaCJGbxXA8r8NcnEPagOEJeYCNUps3w5U9MeDiJT5mmM2XOE4Xe5UwYpjg3
         DLdt2lqOLUUqcqvfy3GNDP6jimY7+56L6qJxYjrsZxhCCa8uEkWM/CymiTlVs8X9cEGv
         52+g==
X-Forwarded-Encrypted: i=1; AJvYcCWNeAGU8nzfXnSvh08qXoBJ2Uen1FQu4ONN8P5BkBWxkfgiye4LQ2FyHZN5TUawxWDslYsGGm107Wk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEBz1syRDvEwreFO2Nrz0zlta3jImTGStXUR7+5+5k/YfbE6xL
	esOoINrupywWctWfBtlk5wqe29kzhZOh0dJo0VPJ7PNkKMElM300CPhW2nwMCWDvJa0=
X-Gm-Gg: ASbGnctw8cgB4d3rnKeOU1RbWvgkseVaBc1f+qBHDO2uIE0J5D45s1XhjZ0zuNNCg+Z
	fv31yHUXFZ6m5MHypAHoOPDevuaLQ9g6eGDYlMNaZxG2x2MXJQ7jTtjlwl8veExeynYGNlWsvYB
	DE8kCkEwdVNCFwPm4xIEdcfPh8LGhfb1otboabzs3fFt86tPg3qQERSavdeQO0IvN3ruCU/2g9r
	EisviuA4633nQKhPkSscztQzc4mfEtDE5wHJWx/pshAAAYYKRIS3MIqy3xyhWDSN3K191ygXxtz
	X8A2gxSc4aqICxC9lr87AEItThEQSFpTsAFZJEleNlRRZ3IOwPo/xeUUNK0h4Ij87yfcy4l/JHN
	6viDK72/69cjIczKwGlkEGei2cGIOiavWLYo+eK5iRtPsBs1VCwTOpy6O/fQ=
X-Google-Smtp-Source: AGHT+IGcJ0F+Yu8LKKYT4wPl7uuybVV1LKhPL6NkeZN/ZOA11iSP+ko8POCF1twTXQouIMsAmh++wg==
X-Received: by 2002:a05:690c:3348:b0:721:3bd0:d5ba with SMTP id 00721157ae682-7213bd0d69dmr13183867b3.41.1756222916060;
        Tue, 26 Aug 2025 08:41:56 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff18e31acsm24874707b3.67.2025.08.26.08.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:55 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 46/54] ext4: remove reference to I_FREEING in orphan.c
Date: Tue, 26 Aug 2025 11:39:46 -0400
Message-ID: <5e023690acf2ba9a94f12a5d703bb6c66ec99723.1756222465.git.josef@toxicpanda.com>
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

We can use the i_count refcount to see if this inode is being freed.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/ext4/orphan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 524d4658fa40..9ef693b9ad06 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -107,7 +107,8 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	if (!sbi->s_journal || is_bad_inode(inode))
 		return 0;
 
-	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
+	WARN_ON_ONCE(!(inode->i_state & I_NEW) &&
+		     icount_read(inode) > 0 &&
 		     !inode_is_locked(inode));
 	/*
 	 * Inode orphaned in orphan file or in orphan list?
@@ -236,7 +237,8 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	if (!sbi->s_journal && !(sbi->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
-	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
+	WARN_ON_ONCE(!(inode->i_state & I_NEW) &&
+		     icount_read(inode) > 0 &&
 		     !inode_is_locked(inode));
 	if (ext4_test_inode_state(inode, EXT4_STATE_ORPHAN_FILE))
 		return ext4_orphan_file_del(handle, inode);
-- 
2.49.0

