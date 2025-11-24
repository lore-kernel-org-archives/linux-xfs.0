Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C09335079
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 23:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028111; cv=none; b=uJNeWooeLLsxjrDMO46YuSG0MV+HVFmrqQLM1j7EkU4tvROQ/62XvazR95dfA7hww31jZs+F7msOk881F5w9Op+RUyakwckjF3RAKKWK4DxfoAlCbBQ8I9HvtafIiiegOgeJ0YiQERjk2UhvXvBZd578uBP8rMRZNVfTZG/lL48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028111; c=relaxed/simple;
	bh=Am7Xg6QJV818HftQaQoJheIX+hzBGkDxL1hHod2VREY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eH65WDOhWDUGJIzJSyq1t3NPY6mfPD8oYdZyhgYdSZpDq0SPAQT3rlqKXnFHP4srKPcedMshCL6KmjPyKMuITtJhu/lsRU5ua8in0a0CELo4oyYjYf9XRArwMZorAwrYj/6sZ32dvOsRAq3vLmMnBiNarb6AB9PQY4d+wDnfJJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j1p+HPxt; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j1p+HPxt"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-297ef378069so44422455ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 15:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028108; x=1764632908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14mujLSQeTKxSJUy/um1pAgQzTbPorW1qBu/kH6klR8=;
        b=j1p+HPxtmEJXq1utE07WkQkG5flpsDtFoeQM2jUrBDC6qKWM1nLMeIlhSLC9+NpIYi
         n4/q62g+t8PqkUImUcZdYWQ9E+IqnqzXK8BOc4daG66olSGcgd8vESZhU183lgbFGWLw
         bJzyz8FQm1wBtTjkNmWGsBwkrAjSUYPQOuyRvgnuslbcOXS8E7wf8QMGnFn9hXpPg2Uf
         B7kaMI0ZMw6Nc8ClKDSeJUBWafnApBQlQ8Lb1HDdWYiWqtk5yUaH3XIBnavJX/JbYKOZ
         yIoeSjOpsBKfdDTkwXA5EHzUnajxEViGSyFL297Yd+gPgWO5Zs6qAg3Wa4VWJ2hkvR42
         32SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028108; x=1764632908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=14mujLSQeTKxSJUy/um1pAgQzTbPorW1qBu/kH6klR8=;
        b=rs1NKSbPXJ2fEZo1tjcSs+Ylh14BK/71pdEKqRO+G+0YnvAUmu9SfyQ58Jj75RqHOr
         rIjaZKrvOSjDpNbocNUW1FJxfPVj3Rmv6U1x6dPNLvcGH6YXHucRt2hezC1HB544r8Vt
         pVykw3luxaTpvSYyt1GoQg2plcoiI/x8vMsrYnkZ3suLBZNUomkgEtjj/MJbWlSonxdw
         vYeF5hwkXlY/15oytGiWSuicmwYxWfo2vlrY9U9eHOP0BeMqB2dds9PCdqvRSoPnkqWU
         ea8S4X6REhrIK81XkdXbyCZMGo8Q5eoE142Wbwe+5jivEz87+vB6eGfFv4GRcs/+30SW
         tFVA==
X-Forwarded-Encrypted: i=1; AJvYcCVb5o199rVDqye6fjBpYq/N7L+GRvSJsKVOUTEW2R3MCJY3VXpxXSy2S/K1zQwTdPiytfXWU53z37w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdWpgNAehq3/vhhRgqsQk2Wgr2kjgOIHYc75LCRorCGs8rqdli
	zS1NqWFyo9LViOgOMFuhErz9gacA4AK8LV2/rF5i/ux8MUFdyJqesYjZ
X-Gm-Gg: ASbGncsVQ84BAo6ETTIIVqKA1+vXBVjCd/u3e+8e2Hcen2wV0B0ti1VJU0d/FUPbxeR
	vYxB6RRS2bGCLfo2rP5+w/IQFGJqW80STqslevrlpZEdJ4JrL/M5200KMmAfe610BYKFGsVLe3L
	YD0fBjnYk4cJ2Fp4EVojpTGtQPqj9pjJquki85NQIvggtbdVeGBSLJpKEk9S1BxN+LYYnLsP8hD
	qFSSyzu/PSJ4/l77eMNVprAulT85TVI5qOnXsOgLzZ2MARW8OD3WcAEtPxrLCI5gVIWg7KuWzyQ
	fCHLmwn7xHq7PGTFjzswIXWltQNdKaLKlWBOpUpuQ9yhonPfC0U5j3UtCCAxtT41zoPAxnwpo7e
	ZaFmBfmHBd0iEcEsEQGLQqZ6dRZC7j30Tc7LGF4LkCxYfGNDhUrY9+5MU45FTQh/AUrc1CoQkBu
	9CJRrC+M9PUmZnGeZc8lQcD65kHuoCD4ukU4NKT8I00uQ5v3I=
X-Google-Smtp-Source: AGHT+IFryzmc/XiOW9LSO9isjtYB1LRYx6LJmKSX/rJnv82E/9f71NMvnHJMZsWalBLPhm0XU6n7Vg==
X-Received: by 2002:a05:7022:ec88:b0:119:e55a:9bf5 with SMTP id a92af1059eb24-11cb3ef2594mr558577c88.17.1764028108043;
        Mon, 24 Nov 2025 15:48:28 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93de6d5csm50934844c88.4.2025.11.24.15.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:27 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH V3 5/6] f2fs: ignore discard return value
Date: Mon, 24 Nov 2025 15:48:05 -0800
Message-Id: <20251124234806.75216-6-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making the error assignment
in __submit_discard_cmd() dead code.

Initialize err to 0 and remove the error assignment from the
__blkdev_issue_discard() call to err. Move fault injection code into
already present if branch where err is set to -EIO.

This preserves the fault injection behavior while removing dead error
handling.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 fs/f2fs/segment.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b45eace879d7..22b736ec9c51 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1343,15 +1343,9 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 
 		dc->di.len += len;
 
+		err = 0;
 		if (time_to_inject(sbi, FAULT_DISCARD)) {
 			err = -EIO;
-		} else {
-			err = __blkdev_issue_discard(bdev,
-					SECTOR_FROM_BLOCK(start),
-					SECTOR_FROM_BLOCK(len),
-					GFP_NOFS, &bio);
-		}
-		if (err) {
 			spin_lock_irqsave(&dc->lock, flags);
 			if (dc->state == D_PARTIAL)
 				dc->state = D_SUBMIT;
@@ -1360,6 +1354,8 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 			break;
 		}
 
+		__blkdev_issue_discard(bdev, SECTOR_FROM_BLOCK(start),
+				SECTOR_FROM_BLOCK(len), GFP_NOFS, &bio);
 		f2fs_bug_on(sbi, !bio);
 
 		/*
-- 
2.40.0

