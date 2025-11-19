Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E392E5B36
	for <linux-xfs@vger.kernel.org>; Wed, 19 Nov 2025 15:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763566802; cv=none; b=SrsWbGMZ21qmGYM5bN17Jc06N4rK5Blip5CaKdR8UIO9Zhmq9w7AfxMnie+bvTXoe7iBnULcIXyewQtA2Ww2NAa3ZZuihxfvf0meCv20kr3PSYfpS3iqJu4CTSMQe9p4Q5MbUeXZsKplwXqJ4lYdy2wb6wSO0elYeOa/uc+BEL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763566802; c=relaxed/simple;
	bh=+yDP7vHuHZabaqvWKih93fJjCuuATDc1fsyBE+gWZu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMwiofFwdRvcftPO8t0rZz5ydMkYtj0EZQUAIqi/zvx5XpHoOGpR0wmIBwXQe4rzJEL5HeN0DmoeYPVLpoE+yr/R1+qrGIOZS3FRyYFyDwKuThW26dKjvexuxBKo82AnnSa5oj1eqXobDoWQsPDOytuKfE8Ps7YG2VgnCX1qgw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gWakmFvY; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gWakmFvY"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4eda6a8cc12so64746441cf.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Nov 2025 07:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763566800; x=1764171600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dkO6OIHDEaOQOyMckBl5bOgZ0VGVIhNhceKFziBTYy4=;
        b=gWakmFvYA5UBOvGdDKLGgWJ4reVskOYoXUs4t3MbLtrAp5gRew77S0rZNhoD6MH/rZ
         wB/vlBxOP3JT6bLFfkeYzbGT3dkME6B4Jz6/lMezhLlxtAm9y/e0VlPz6fFI1fPVfYl+
         3KZ059WlcfHZ4KwHYVw79qTEJAS6rdypORllChyEcdEL3oth4Kmmja5++lyIElbE/wpF
         cgpz0PE5/IQQkdKMtov/JpqdcWC/p/eLdQdnwHOulgJD36NvQvVIEO5iTYX6YDCgRAbt
         lJb4D4tcorb0U8+NoDoG5J37nB6ne1fo8pmn3UMHCLR1C3M5+HntHBznd6N2SuzCqFgd
         BqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763566800; x=1764171600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dkO6OIHDEaOQOyMckBl5bOgZ0VGVIhNhceKFziBTYy4=;
        b=TOAMErYUut9RPpLTysquGxwaTsiGd5dvm5Efl3qObAz/HvSgsZUTyS9SvXfheUr+vx
         APZHI9MYobIKsAr00xZ+DjwcKJG6NiSg5k69DdupcUtYRvStsZdcOdmC+B8tvJgnLM/U
         soLwtGAGjy0Qndg5hLvdzedC/0j3drgm2iUCIVTYhxF6pMOckbvaVBcup286K8Hl4kYD
         3k+S+3wnvuswu2GWwnCN/mGqLaq0Il2WrtJjNTPKnwpOYwAW1nl7zQlyd6nL6fHQ6vpB
         MsYJebADadr1w9nORKBGv8zgh6sTvhXt6gvGjmyD9Fo2ujpQ8iQp/KjnLQJek8rXKxrc
         NCNw==
X-Forwarded-Encrypted: i=1; AJvYcCWe8BWrSlW3gMGeZvtb3rCKSz4gvxgTlLWeKIXMSP2e7hW9x/EyS+5RYgG1LUiCDVhg/Mu4QLOjvkw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj1cLW/xOtDgaBc/6tKHAnZx5fJowkba38ch9wUM0SJZ15Dnz1
	8BCRMxTJkvQm4rWvYOeMEde5GiGCwASVKTybY46Q/EH0i2iV6AdH7hBy
X-Gm-Gg: ASbGncvZZEC9SUiMwL0L5wRCG6+RVdd6+OA8Gkj8PiBVYoHgi7HJCOGuIefx4HwIHem
	ijMfmUokiQUuXP77QdlC/+BtWirb317HaAyna5QxZcZeAXU9Pa0guw/pZpjFSom/bvFGFvRV872
	fuoVWuTLizoLcnwD8kPKLPpTaxoP5EDuZAUJcHHdZ+Yw8SEn/X9QqWnHvcRvFpSejsgHFeqa4nB
	CCrqZFkiJYxrjLjzgB/mvIM1z6xzIbo8EF3kPnkY/ozX5BJJDVr/Bq2Mwp5f6dNX3UKhrnc7i/E
	T/MGz3Z9GafPu4mHMGKlCbo7jfe3+pHpScgJ3ehBkwIjcYv+OU+CPmQzNflAeJpZQY1UINvBt9o
	2smsCrATDSTfNZDXxmrFcZc9dQAds2HqI6l8vz3VqPqe5x72a+T8NJyNDBhR9+EEpTeB82b56az
	fq7tZ0AMkirqDTLZQEdCK5bgxOssTL9oA=
X-Google-Smtp-Source: AGHT+IH4MOUKy5wRlExiOws0XrrPOkWoG7npYHydd6YPsYrrwJLdVB9xwxhCMW3280EGtqPgG2xmMg==
X-Received: by 2002:ac8:5d4d:0:b0:4ed:6e70:1ac4 with SMTP id d75a77b69052e-4edf212f37fmr270692441cf.42.1763566799989;
        Wed, 19 Nov 2025 07:39:59 -0800 (PST)
Received: from rpthibeault-XPS-13-9305.. ([23.233.177.113])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-882862ce5e6sm137057526d6.10.2025.11.19.07.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:39:59 -0800 (PST)
From: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
To: cem@kernel.org
Cc: chandanbabu@kernel.org,
	djwong@kernel.org,
	bfoster@redhat.com,
	david@fromorbit.com,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Subject: [PATCH v4] xfs: validate log record version against superblock log version
Date: Wed, 19 Nov 2025 10:37:22 -0500
Message-ID: <20251119153721.2765700-2-rpthibeault@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aRzU0yjBfQ3CjWpp@dread.disaster.area>
References: <aRzU0yjBfQ3CjWpp@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot creates a fuzzed record where xfs_has_logv2() but the
xlog_rec_header h_version != XLOG_VERSION_2. This causes a
KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
xlog_recover_process() -> xlog_cksum().

Fix by adding a check to xlog_valid_rec_header() to abort journal
recovery if the xlog_rec_header h_version does not match the super
block log version.

A file system with a version 2 log will only ever set
XLOG_VERSION_2 in its headers (and v1 will only ever set V_1), so if
there is any mismatch, either the journal or the superblock has been
corrupted and therefore we abort processing with a -EFSCORRUPTED error
immediately.

Also, refactor the structure of the validity checks for better
readability. At the default error level (LOW), XFS_IS_CORRUPT() emits
the condition that failed, the file and line number it is
located at, then dumps the stack. This gives us everything we need
to know about the failure if we do a single validity check per
XFS_IS_CORRUPT().

Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
Tested-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Fixes: 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
---
changelog
v1 -> v2: 
- reject the mount for h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
v2 -> v3: 
- abort journal recovery if the xlog_rec_header h_version does not 
match the super block log version
v3 -> v4: 
- refactor for readability

 fs/xfs/xfs_log_recover.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e6ed9e09c027..f5f28755b2ff 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2950,31 +2950,40 @@ xlog_valid_rec_header(
 	xfs_daddr_t		blkno,
 	int			bufsize)
 {
+	struct xfs_mount	*mp = log->l_mp;
+	u32			h_version = be32_to_cpu(rhead->h_version);
 	int			hlen;
 
-	if (XFS_IS_CORRUPT(log->l_mp,
+	if (XFS_IS_CORRUPT(mp,
 			   rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM)))
 		return -EFSCORRUPTED;
-	if (XFS_IS_CORRUPT(log->l_mp,
-			   (!rhead->h_version ||
-			   (be32_to_cpu(rhead->h_version) &
-			    (~XLOG_VERSION_OKBITS))))) {
-		xfs_warn(log->l_mp, "%s: unrecognised log version (%d).",
-			__func__, be32_to_cpu(rhead->h_version));
+
+	if (XFS_IS_CORRUPT(mp, !h_version))
 		return -EFSCORRUPTED;
-	}
+	if (XFS_IS_CORRUPT(mp, (h_version & ~XLOG_VERSION_OKBITS)))
+		return -EFSCORRUPTED;
+
+	/*
+	 * the log version is known, but must match the superblock log
+	 * version feature bits for the header to be considered valid
+	 */
+	if (xfs_has_logv2(mp)) {
+		if (XFS_IS_CORRUPT(mp, !(h_version & XLOG_VERSION_2)))
+			return -EFSCORRUPTED;
+	} else if (XFS_IS_CORRUPT(mp, !(h_version & XLOG_VERSION_1)))
+			return -EFSCORRUPTED;
 
 	/*
 	 * LR body must have data (or it wouldn't have been written)
 	 * and h_len must not be greater than LR buffer size.
 	 */
 	hlen = be32_to_cpu(rhead->h_len);
-	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > bufsize))
+	if (XFS_IS_CORRUPT(mp, hlen <= 0 || hlen > bufsize))
 		return -EFSCORRUPTED;
 
-	if (XFS_IS_CORRUPT(log->l_mp,
-			   blkno > log->l_logBBsize || blkno > INT_MAX))
+	if (XFS_IS_CORRUPT(mp, blkno > log->l_logBBsize || blkno > INT_MAX))
 		return -EFSCORRUPTED;
+
 	return 0;
 }
 
-- 
2.43.0

