Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F7A24A079
	for <linux-xfs@vger.kernel.org>; Mon,  4 Aug 2025 12:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309318; cv=none; b=UELeA0ng2GYSaSNJvrAxBBHQP1H2qOB73g5Ain0bKB3pRYZpJP+//t3I8ROwOTJK4Jg8r820vz6jqjO88Oxi8LFzfXezHDfbI/uAnrqmQW2YlhOL1tr+uht8iQsZlvM5Fs8dBKCx1OZ4WmvrYZDRe04sVW/GJsGguxFvdMDuW78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309318; c=relaxed/simple;
	bh=f4MUMSMnDZ0MhhdMfvKigrDjH/4DiQbPnUpoO+skDmg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ckSeLuIpwBm5+9KMIe0HdU88k5Vz9e0tj9WZEF8FCXbvdOWZkmIHasg+O9nvc6w5ajL5ptGtMrhITsIbseT6oNIRZbhwpQJCguljbrViiEUToLZTmwngcJhvnQLm6jv5ACH4O09IFhEq7FTJTeMvuLwuEt3Ll1eNzrCq2MB/3Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tz8zieit; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tz8zieit"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754309315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6M5pWcUF2bRfxmOemdeCZ/exnbEQ7UIPJUP2/lYn0q0=;
	b=Tz8zieitVcnd0l4Mpt4pVW2k5O7+djssRJTlyU//q8FAgEAuUKuPBs3rYEG7StuQThfOIH
	/7nNIxrFg79oRUVBadzzUqycRgUWMwi/BgYWBis5eG7iufLeQvZwO/JmGwqAtZSl9h7QHu
	iVFld1h5udnguAuU4gnEeuZVt3KdnbE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-spJMSO3HP8-fwj5xO5Xnug-1; Mon, 04 Aug 2025 08:08:33 -0400
X-MC-Unique: spJMSO3HP8-fwj5xO5Xnug-1
X-Mimecast-MFC-AGG-ID: spJMSO3HP8-fwj5xO5Xnug_1754309313
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459d3abb2b5so4817545e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Aug 2025 05:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754309312; x=1754914112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6M5pWcUF2bRfxmOemdeCZ/exnbEQ7UIPJUP2/lYn0q0=;
        b=DiMlUrAQ5jPNe3jtD79RTELSruUldOnPmsq7o5ojAfaL71mhjfGD0DCjSDFzE5V1VB
         K+DVgiezT7TpDYTACtY6Xl8MsDR2Fyhlvmqvqpntl1yi8vJgzKIAuNtP8yVixKihVRVA
         r9r6UiL0boeITuSmlWDW3JA7a3lZNRBQTshR7Cc3qUtTQgn5ZLeJDIMxpEFsgzt7Tjn/
         b6f/gOVdOBTOU2HIHNFuO8Sos3kXtU7q3rwmXZFdyNKHRSEr2ry3x8TFXADoDH9lxrdx
         s+fna94hnz3lpH9iZc5Akt9YonUaj/+nsL5MOV4aPLLrqyOHVmuuUMtZHbeIX/q6JgnU
         +VlA==
X-Forwarded-Encrypted: i=1; AJvYcCUL+99CQOC3AbHvacrZmFeBHaVQKyhGVA00qoC5Pb4R2tLrjTurRebg3qP+Q2n2T2H4Ri8DwFlKvsA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyfq09apVj99QXED+016BB51EOpHQSejH690qJ0lXi37RVQw1rN
	/n9lsXFAJJEPiSp99A7JbUlM/OHQQl11g9HdXOEIgqtVq0As8qsD07UB7V9Xg78ZSEtJG8/6Vpr
	b0t7iQ9vwLla8RGno84EjbqFKSFHPM2Utzi4rqKMtYUQ/ePpbREPru8PApJQ3
X-Gm-Gg: ASbGncs3WFiAsBPXdmeP+A5JJBROZuwKCV+Prp6dx36qOS5n9V/KgDWVomLKEF226bV
	fhn65kvSMnVxGZT9afwqiFql5rMG2UGemaQTF5B7ctmMlRnCnKdxcKgcnWsWX3usWJWu1OlPvhn
	cOLjdUao3OGzPJgmpVL0yT1mGy3rTAnZ6b1PH4FYaZIQjgFIxHbSn7+SF8rKvee4gR7WDg2xc/7
	zepd0wZN3mnwtixZR3SQg1BHH9G5zegvYYYAUXKQnsbE/SCWTreBpPOFm7o181P3vm+OCETzYBL
	vp1Rr61xqzcsget9dr8Ydahi5JSLikmjUK8n447QzqLRsQ==
X-Received: by 2002:a05:600c:1c24:b0:456:285b:db24 with SMTP id 5b1f17b1804b1-458b6b435ffmr56688415e9.28.1754309312602;
        Mon, 04 Aug 2025 05:08:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPSows/4EcFOx/3X+rMupvUzGOJBk52wOr7+g4s/ypynDBfyNbe+3PGGoejfauIAMERG+3BA==
X-Received: by 2002:a05:600c:1c24:b0:456:285b:db24 with SMTP id 5b1f17b1804b1-458b6b435ffmr56688205e9.28.1754309312183;
        Mon, 04 Aug 2025 05:08:32 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589ee4f239sm163962675e9.21.2025.08.04.05.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 05:08:31 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 04 Aug 2025 14:08:16 +0200
Subject: [PATCH v2 3/3] xfs: allow setting file attributes on special files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250804-xfs-xattrat-v2-3-71b4ead9a83e@kernel.org>
References: <20250804-xfs-xattrat-v2-0-71b4ead9a83e@kernel.org>
In-Reply-To: <20250804-xfs-xattrat-v2-0-71b4ead9a83e@kernel.org>
To: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1473; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=xt/e5+x4LHcLIg5bls6AjmN3zt89FyCtm//YOZvcXiM=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMiYs2nu0Syh94RNPfdXkz+f2XtoZOzM3lfH+mxnHT
 8byPtW4ZK7VUcrCIMbFICumyLJOWmtqUpFU/hGDGnmYOaxMIEMYuDgFYCLrYhkZvhdNPcd7RP70
 19nr3KdtzdWyv31qhu7rqpfxO47/afE+WMjI0MNa8c1an8NM+vKl5+8SrI+W7apYuoWTe8ef203
 T+sJX8wAArNlMfA==
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

XFS does't have file attributes manipulation ioctls for special
files. Changing or reading file attributes is rejected for them in
xfs_fileattr_*et().

In XFS, this is necessary to work for project quota directories.
When project is set up, xfs_quota opens and calls FS_IOC_SETFSXATTR on
every inode in the directory. However, special files are skipped due to
open() returning a special inode for them. So, they don't even get to
this check.

The recently added file_getattr/file_setattr will call xfs_fileattr_*et,
on special files. This patch allows reading/changing file attributes on
special files.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fe1f74a3b6a3..f3c89172cc27 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -512,9 +512,6 @@ xfs_fileattr_get(
 {
 	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
 
-	if (d_is_special(dentry))
-		return -ENOTTY;
-
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	xfs_fill_fsxattr(ip, XFS_DATA_FORK, fa);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
@@ -736,9 +733,6 @@ xfs_fileattr_set(
 
 	trace_xfs_ioctl_setattr(ip);
 
-	if (d_is_special(dentry))
-		return -ENOTTY;
-
 	if (!fa->fsx_valid) {
 		if (fa->flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL |
 				  FS_NOATIME_FL | FS_NODUMP_FL |

-- 
2.50.0

