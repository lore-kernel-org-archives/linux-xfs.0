Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD913BBC1
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168574; cv=none; b=nFhkj4qsQfhPHO2RgJL6fZiZA271q82ndX7jan/Qe62d1d6aMTTlJlX+CrRhYnXfPbta7p2o8i68O7zidQ9VB90otB/Gk83kbo6I2LYkY4Xz17dy2wNidxkCcFmJj7r5pl7fg4PSlyURSR5GADjxJ6vVLluAvz/qqTmcN+Y65Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168574; c=relaxed/simple;
	bh=SH1qnePCFrRl3fAgZRNYZa8yrIJShfVzGEm4Ck1rCxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EygeFxAz4RYbmLAy89pjVJoXnNd07PdBoxwZHbQj+ApfiLgPw99E5vFsJ151L4/VldNjfHxJ6fDbu+z18mr47VB7XRnsYKF1ziKkmktMjE4VQdYB0MVUE11HBrksWAWCm/TwMbSgV0f5/Vu1P3VqRW1ln8Vs5ccZO8IgpfS7Z3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=APhydaYr; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="APhydaYr"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e36b7e7dd2so23341115ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168573; x=1714773373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uBlBlpf98C5X0voCh7UOBX1uYrcKQ0GqpvlCauYQYPM=;
        b=APhydaYr7c7c2tesbjgbXDFOnLnuRE3QofVWWFxrZIIxxoF1Cf1Jm2Z55vOAtPYiff
         slDRgnhQbGM/rNaaDoINwUpe0eRt5Axe5b6XkKObJQbrsZe3QA1vJp1g3WRZsGoWusZ+
         ANeF5t2RWdzdnZdCIRI2WIWDFgxyu8G8e8fQ6RRQLvXG4ztkh7yHbXyqHlQc48/AKfeb
         z8rH3CLoMHGIaOZYKGJNTekIg3GpddQ7Dzd8reCXkU+LvLpCaex9Ua5umBWjNJrHdOjX
         4HsLCEysxto6JQb1Ln3l+UFQewrXeRUZ4lLtJ1pjc6OhT6ZaKXvFIPJ4zs4y3BI/QW4B
         acNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168573; x=1714773373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uBlBlpf98C5X0voCh7UOBX1uYrcKQ0GqpvlCauYQYPM=;
        b=FvbzwnXEZQs76TKtiqWCCyX8TBIk6r8/f1jcw3n/XjCySRnOMvCIRWVZP3nPutZvqd
         bi9p+1ZmsHxhgWhlYEOAd2Mq5y2pYzUs/UhCTSbVCFszn2DrIhEDtaEOpou2JNrFD58z
         nEGYXGWxq36kvLLch9f9RxKlaFUjgoP/Y8yemLkGuK4FIatAQMdEl1ZBpEWlhJby4igI
         eH5d6do94s7mLVyWEu7Gxwqkdgl8L/Xb9VkxEJNOjyw2dIDvFKJySgyOYJq0fio8uqHu
         xg+oLKiQsUmFVIM2qo/8ha0p3dAPQKuYUxAEd3eB3QR0aD2/7XK5bcSNY6jH/4/pZ1zX
         ZUkg==
X-Gm-Message-State: AOJu0YwrgRish0h3745jdcLT9yTUJDqgHnb75LwXuiMuEgbGq8JZ7ipA
	406nFz9HXTg6ZeiHNo6W0UtePlgdCzK9S1dm+/mbsNDknekC81DedBLaOO4I
X-Google-Smtp-Source: AGHT+IGm11uv+Py5P8rTiQvG3CGLJIpJNUT4LDpu3bT+Vj/nxiGRvsVFHH3op4mPzWfeuNHaOxGTzw==
X-Received: by 2002:a17:903:2409:b0:1e9:a0ce:f618 with SMTP id e9-20020a170903240900b001e9a0cef618mr1266366plo.69.1714168572907;
        Fri, 26 Apr 2024 14:56:12 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:56:12 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	Hironori Shiina <shiina.hironori@gmail.com>,
	Hironori Shiina <shiina.hironori@fujitsu.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 23/24] xfs: get root inode correctly at bulkstat
Date: Fri, 26 Apr 2024 14:55:10 -0700
Message-ID: <20240426215512.2673806-24-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hironori Shiina <shiina.hironori@gmail.com>

[ Upstream commit 817644fa4525258992f17fecf4f1d6cdd2e1b731 ]

The root inode number should be set to `breq->startino` for getting stat
information of the root when XFS_BULK_IREQ_SPECIAL_ROOT is used.
Otherwise, the inode search is started from 1
(XFS_BULK_IREQ_SPECIAL_ROOT) and the inode with the lowest number in a
filesystem is returned.

Fixes: bf3cb3944792 ("xfs: allow single bulkstat of special inodes")
Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1f783e979629..85fbb3b71d1c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -754,7 +754,7 @@ xfs_bulkstat_fmt(
 static int
 xfs_bulk_ireq_setup(
 	struct xfs_mount	*mp,
-	struct xfs_bulk_ireq	*hdr,
+	const struct xfs_bulk_ireq *hdr,
 	struct xfs_ibulk	*breq,
 	void __user		*ubuffer)
 {
@@ -780,7 +780,7 @@ xfs_bulk_ireq_setup(
 
 		switch (hdr->ino) {
 		case XFS_BULK_IREQ_SPECIAL_ROOT:
-			hdr->ino = mp->m_sb.sb_rootino;
+			breq->startino = mp->m_sb.sb_rootino;
 			break;
 		default:
 			return -EINVAL;
-- 
2.44.0.769.g3c40516874-goog

