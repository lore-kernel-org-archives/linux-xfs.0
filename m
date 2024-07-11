Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AF7383
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 00:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720658202; cv=none; b=o3jQbzoQwP5iYieEzjru8BmP4j42PsaU4/ewYnRzZ1OO8+/j0CVyw/gvgNVEsAwaW8W/Y0KZ1EoATU3vsSSRB1AP0dNK+nHg91W0aqDun/sVRkKY84McnC7Gm/TMeqB9PyoMjyQ0D6S4FglGLUzfWQOLlRYVLRr7tIHD6km0QbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720658202; c=relaxed/simple;
	bh=BxPVC4GWdqlaCIrLs3an2sjbWsgrnqd73oZyDTc+eBk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Rjju9o2denDnhQMsKQUkBMrPTHDEaoAKb5Sevt4zt7LinhYdOriYP3+487Rf+8bsS9Kd8rhr/Yp61twtOYCFYETVjxF4Nnvg6RrpoL3YHlMLQhjE0lMtw2faHnDpAP7T8Wlwtf+3KbJQmt/GxwtUz9Hc88lA3whvVwG0T1rhsco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=1XNkq1fX; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="1XNkq1fX"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70b0d0a7a56so331925b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2024 17:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720658200; x=1721263000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=6pYBGdgFUjwtzYTaVzpxf1IZQZYisL1jzh2HvZoLkQY=;
        b=1XNkq1fXBn03Br5nDtaIVLVNEH3YniE60i2VpDGecTF1JXUdryz3j898qi3+xLD5T3
         9u+2CKfnn1cBLnMxHguPAdict5j6xVDYYkfWabTlk4MJlrY68FSwpXomR57u/X6dgFJ0
         4TvmPAt4rntdRhij2BpASE546jL8QzaGqtpc8KpZA5zatlELrDP3kAsQwz7aKNqd6doP
         hEFRe8AMRFI9GHYDlZ+lwZJx3kUUEJ0KvI14SUJ0r00IvkBdJjr8+X1yX4d9XGBO7r9V
         cmYaG4bCukteYIM3MYXgS6+Z+kI14kt0CUH5mdHsSzx/r7JcegMQRNM5xZOzYfwsW9UH
         6Y0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720658200; x=1721263000;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6pYBGdgFUjwtzYTaVzpxf1IZQZYisL1jzh2HvZoLkQY=;
        b=JfCUI1MQTBHbIRAcKEql4gslctvJSUq9LMCKuxJWpIqJle/1p2Gi96YTTnVVDeH+Ne
         /VTredZ1a2fecDv9xqSuoqX7sEFLEF/Q3lEEEmWKqKjuBrv34NIMfSezhvLtO4fIzm4j
         8uLVyyICwOJ7f/P5NI616GX0XpBx938GBWAwp01FgXbdjqZH+NQBhULLeR5WV5Vusz4u
         w8xSxJWhOs/6GlvA1o3CcUfVIvp6L3rReFZRJppfrLhjNkO3TJ2C9f9tywsNuOwbojHS
         WlJptkt2hRfBRrXgF4NWnoijT6PdJlNzFOegOKHj6ZfITORFasBSL/LoQYcguZxAmhAo
         ew3Q==
X-Gm-Message-State: AOJu0YziGvdX34N55RxsOsCV/iMUD7y88f6aFMpvkhFuW43uPnDYZVcI
	KpqGbqvqQFkWVaA5ljc04XY/t38qiioYtLHM3WBecXNox1qMJn+0vda1KM3DgNW75qB5UaqZgFK
	P
X-Google-Smtp-Source: AGHT+IHmynDvRqemw9sCQxEQvQsXBqrmDcTqjdkucYALBaLxkPtyKVIznzt5dyYzBxrNR0Tx27HPAA==
X-Received: by 2002:a05:6a00:ccd:b0:706:8a67:c3a0 with SMTP id d2e1a72fcca58-70b434f64b1mr7672037b3a.5.1720658200326;
        Wed, 10 Jul 2024 17:36:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b439b70d2sm4405432b3a.190.2024.07.10.17.36.39
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 17:36:40 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1sRhnZ-00BSEt-2R
	for linux-xfs@vger.kernel.org;
	Thu, 11 Jul 2024 10:36:37 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1sRhnZ-0000000CVBc-122C
	for linux-xfs@vger.kernel.org;
	Thu, 11 Jul 2024 10:36:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: update XFS_IOC_DIOINFO memory alignment value
Date: Thu, 11 Jul 2024 10:36:37 +1000
Message-ID: <20240711003637.2979807-1-david@fromorbit.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

As of v6.0, the DIO memory buffer alignment is no longer aligned to
the logical sector size of the underlying block device. There is now
a specific DMA alignment parameter that memory buffers should be
aligned to. statx(STATX_DIOALIGN) gets this right, but
XFS_IOC_DIOINFO does not - it still uses the older fixed alignment
defined by the block device logical sector size.

This was found because the s390 DASD driver increased DMA alignment
to PAGE_SIZE in commit bc792884b76f ("s390/dasd: Establish DMA
alignment") and DIO aligned to logical sector sizes have started
failing on kernels with that commit. Fixing the "userspace fails
because device alignment constraints increased" issue is not XFS's
problem, but we really should be reporting the correct device memory
alignment in XFS_IOC_DIOINFO.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f0117188f302..71eba4849e03 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1368,7 +1368,8 @@ xfs_file_ioctl(
 		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
 		struct dioattr		da;
 
-		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
+		da.d_mem = bdev_dma_alignment(target->bt_bdev);
+		da.d_miniosz = target->bt_logical_sectorsize;
 		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
 
 		if (copy_to_user(arg, &da, sizeof(da)))
-- 
2.45.1

