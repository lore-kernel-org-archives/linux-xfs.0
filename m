Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A79C1607B1;
	Wed,  1 May 2024 18:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588903; cv=none; b=CB18O+jajIgOqQfpx5F/EC2SXJdJurd86UBnyzCjam/YEhlKSe5KKT8L1sQ3rXif0DPLHCu3Tr9x6YmHrWkDTudyTQpMCrqYx6SEjMjz3E1FT5tWFexTFYl+e7SbWFM0SgCrziUVbyVZ7NSfk1qTRY7NRaeIY9rm2SBeHbuvan4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588903; c=relaxed/simple;
	bh=Kmw9l0cqK5ama/v4PT2AxmTFQ3JaZ0bVy9giSUZXT2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsFBTP1Z+nZqdipdL157fl8MCX8ceRJyCa9R1zepj8aKyxQOtLLUZvpU0RexreJ90TCj54xPVlmh0H3bfBg4KQSGZAeLYoj5+ny85CANH83TNPTFkvYC28YpTy3AuI7nhmsL2xZ5RYRc/ejBxnYFKEZnWDe8BCf5UAm2MhoR79E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b8X9kQ7O; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b8X9kQ7O"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6f103b541aeso5999985b3a.3;
        Wed, 01 May 2024 11:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588901; x=1715193701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KkP9WS3QOeqmVJntIQIzZGDd5VGTrS79uRMxT5ZcRoA=;
        b=b8X9kQ7Ox/xIeEjhhwZm+zkgbfmoaquvAaajgnNu2QQsfBNVo+avMD+LtUnJlit/X8
         BKhmFkGXnkP6cB5v2tN/I6oh5Jm9+oRHrvAaXwjVC16pE8XFw10dQc/uruvfZlljaMkg
         qEYGPsdRu8v9Gg8oyxA1aK+d+Hop3wJT2jgnGcogdhUcX0+LrCHS5aPRgm4URodaaKOW
         3f2ZHrlZJIbAx9JSwh5uL3Q6J3FxfEP8EXyt9zUtsZpEFvAXZaN/HApBvHaW357p1hQ1
         pfng27Ynjn8hb9QCDEqfrNUUxhPU/Bv63z7nqf7yIyHKnOwCvDlULO5WYrkvZtWwneOu
         /JHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588901; x=1715193701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KkP9WS3QOeqmVJntIQIzZGDd5VGTrS79uRMxT5ZcRoA=;
        b=bBrLYH9tNveT4J1l6VfUnckNwf80NsgHPdRfnayVDwJqv/G7uJAWboFHcgwPGoAS+k
         oi5i0KId6mxaqL+tSjwbmYi/p4OpWNgqyIjx1R/nEzYe5w5jPW5BwfKlD+k22A/u0Avu
         3aoAgUbWEbA6lnuZvvc8ptdeEkkzCo0JHI90RwbrF5kZF1q4LmcoZ0g2O9Lu//b/tX9d
         JVM1hfYDQoR3QI5Vqr1A8RZBl2v6Z9eKES5J9ifsz/2rrVnQ+SvkdPy9EG3N4nKas6cV
         eOuMnA9epOkAdWZtHWrlP5LwqUy3xryyI0Pitty3HleIR+E+xZKfTk+2G4BdmrFCrtlk
         stvA==
X-Gm-Message-State: AOJu0YzFALJEmL37/VxWjAP4V66GIVsQQhjuKg7AOVDtnyhGWErkHlTi
	IeUefW1qgh1jV6+Ur7n95aGFNZfFxsbHMTSUzyTctXH6wWYeTuaqcNtqL96G
X-Google-Smtp-Source: AGHT+IFawa5nAKISB501JbRuTbYWcz1eunO3jWMbtVKXVL431XQ3dKcaEhCWCzOriOCpxTTSf+2HJw==
X-Received: by 2002:a05:6a20:3244:b0:1ae:381d:4200 with SMTP id hm4-20020a056a20324400b001ae381d4200mr3171079pzc.35.1714588901492;
        Wed, 01 May 2024 11:41:41 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:41 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Hironori Shiina <shiina.hironori@gmail.com>,
	Hironori Shiina <shiina.hironori@fujitsu.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 23/24] xfs: get root inode correctly at bulkstat
Date: Wed,  1 May 2024 11:41:11 -0700
Message-ID: <20240501184112.3799035-23-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.45.0.rc1.225.g2a3ae87e7f-goog

