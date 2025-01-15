Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BFA2147EE;
	Wed, 15 Jan 2025 12:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736944533; cv=none; b=oGp+NdnTCSpyTlT1BtW+0Tx0iIHSQRI/WToBKBHuTgy1QFed9ckGohlowAWmJU+KSUDm6VbQFlhf9k3st0WpRrlSUvMYbDnlGYQYhvmvCpXMsLGrTxVK1l6tik/V8btlvK3KBs4AQn/yhDwHgs3BtnLj3UfzUzGIpswQ91bko8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736944533; c=relaxed/simple;
	bh=U/FA17bRARhz/OH9vDb0zhfRRZAWzAU9QR5iGTQ83s0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TB4aFKATv1V3agPrtKkNUwI9m6h/Zl5LgyoGvSQeVsbkaJAv1CGwrCiF0NZOvw0MXjZvQO+2SNjoB2bj9hoK38UvOMymr8Pv1n/2AePpufnC6APcHBVrkhrAZZd408z1R37FC2L/nq4+DLxMvaEAIXR1w2jZs3v5tsZLVvZ3twA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hV45VsIq; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hV45VsIq"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2167141dfa1so14320405ad.1;
        Wed, 15 Jan 2025 04:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736944531; x=1737549331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+80OGSZHS3zxkO7V3dRKVOrQn9UKerL0YbqvYsgrGwU=;
        b=hV45VsIqpSkM7Olvv1aAvhaAYJa/oqtCbUCau9pX4j6fcDgkKUfYtnpZnqqWWTDDGS
         TV4SSBe2Yk/7QpctM8UthTRk6YyFt9KRPi+o8Pn7PjjMDZ8S5W2FzB30s78eZ8mjWUBA
         zcAsLM6j1RKbtihdHNz/jLPcXubKyqqEVj3jHRTlulQHZ6iuUIOUr+TsV3Y7hTXu4JcO
         UlLt0K5nfL4EnFcw5zY5VXez8Rkdgkv6fsiXhqtHmMAxXvXxYtW4c2qp9Ap1Q+NetEY0
         ehjlMxI8GzDevxTIhLZt+gD9LZYAtTPTtvZ9JS75aYChF+M0Pw9ekhrXaetPUt8ShZU4
         iYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736944531; x=1737549331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+80OGSZHS3zxkO7V3dRKVOrQn9UKerL0YbqvYsgrGwU=;
        b=PY42REHVsXaEAn6BoNOuqJczZOE4Ma5JuqCmx6x2YcZ4+zRYxdcu/h8kyUmUjzfn3B
         ilPzBGPr0jvEdB5vYoy0n3m4qV0Hhe3yL9brJpNqleKPfzPAbUpwbLeSnVxEsJM3JceU
         zpjF9J4uGj2jAu+DXZSaWsJTg5B8XlSbRADPL+liZ3dPihLfTgauaZURsl7/+EWp4FPx
         6KK2UIHNsN5DmNqPNMgWZUp2DPKbZgjKjWIMKQ2JQ354ddT9R9yZJIUwpwmE3z2AenOw
         n9Uj+2RPud6WFTmp+up4MeUxxU9kt/RwLTKPz7G43PHj06hbQGd3wjAYOdRJsmo2crP+
         d/Vg==
X-Forwarded-Encrypted: i=1; AJvYcCVUPr5uuIXmvZk4Ok2oytyZxfZDkPEcpuzRvidGRf/iEcKijsmpAlX1v3zpdodcuWddmwGFtiR0uka831I=@vger.kernel.org, AJvYcCXjpTdHgzTVSh235Rsj003UnKJAFEdoaEnEUXoJ2Yk0XEuOLLnSO5PvVdDagYQ1PcvnQ4j11vK+cPnH@vger.kernel.org
X-Gm-Message-State: AOJu0YwmZycJmh7np5NzaEEVsI3CLQokwJhgyq4eZhws3zC+NOCic+oB
	k4+Jo55yA6GOwCztmUWMx25TUQPLCIjxNeJkvAjpUK4d/HE1iAtJmsHoOg==
X-Gm-Gg: ASbGncuHzD9fryu1DlVvgbsyEAz1C8mel5RmZ2GWcJbSOQ1a5NcnvtlMubx+SqeK07T
	kzuwaQSncPCz93/KUDl+tBP/4/PyFd8oXaH/34BZdU4M6YGr8tQce+5eS92EJFEvDS33lSkXt+U
	wyRYjmduT4WprX6RTpIMGFtVCm6P0LxQwJOi7489FL6slNpEBCDabrvNEujHdj2MVOmNoFAARyG
	kYTdlqtdIN5Twa8cigDUJLgH0EI5+mudggfOK7mDrEniq2QesqzP6I2+MKOGWeMbEnMe9pC
X-Google-Smtp-Source: AGHT+IEdLEE5WtDNvO/oUxBx+i9u2XulGHJbtCJ6ezAWU48d+dRnuhJ3L/RrVSRHssCvC1tcaQFuDA==
X-Received: by 2002:a17:903:41ca:b0:215:44fe:163d with SMTP id d9443c01a7336-21bf0cf5267mr40109545ad.17.1736944530969;
        Wed, 15 Jan 2025 04:35:30 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f253e02sm82305535ad.225.2025.01.15.04.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 04:35:30 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: dchinner@redhat.com,
	djwong@kernel.org
Cc: cem@kernel.org,
	chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Dave Chinner <david@fromorbit.com>
Subject: [RESEND PATCH v3] xfs: fix the entry condition of exact EOF block allocation optimization
Date: Wed, 15 Jan 2025 20:35:25 +0800
Message-ID: <20250115123525.134269-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we call create(), lseek() and write() sequentially, offset != 0
cannot be used as a judgment condition for whether the file already
has extents.

Furthermore, when xfs_bmap_adjacent() has not given a better blkno,
it is not necessary to use exact EOF block allocation.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
Changelog:
- V3: use ap->eof to mark whether to use the EXACT allocation algorithm
- V2: https://lore.kernel.org/linux-xfs/Z1I74KeyZRv2pBBT@dread.disaster.area/
- V1: https://lore.kernel.org/linux-xfs/ZyFJm7xg7Msd6eVr@dread.disaster.area/T/#t
---
 fs/xfs/libxfs/xfs_bmap.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5255f93bae31..2b95279303d3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3566,12 +3566,12 @@ xfs_bmap_btalloc_at_eof(
 	int			error;
 
 	/*
-	 * If there are already extents in the file, try an exact EOF block
-	 * allocation to extend the file as a contiguous extent. If that fails,
-	 * or it's the first allocation in a file, just try for a stripe aligned
-	 * allocation.
+	 * If there are already extents in the file, and xfs_bmap_adjacent() has
+	 * given a better blkno, try an exact EOF block allocation to extend the
+	 * file as a contiguous extent. If that fails, or it's the first
+	 * allocation in a file, just try for a stripe aligned allocation.
 	 */
-	if (ap->offset) {
+	if (ap->eof) {
 		xfs_extlen_t	nextminlen = 0;
 
 		/*
@@ -3739,7 +3739,8 @@ xfs_bmap_btalloc_best_length(
 	int			error;
 
 	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
-	xfs_bmap_adjacent(ap);
+	if (!xfs_bmap_adjacent(ap))
+		ap->eof = false;
 
 	/*
 	 * Search for an allocation group with a single extent large enough for
-- 
2.41.1

