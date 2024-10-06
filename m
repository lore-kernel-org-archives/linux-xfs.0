Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6571F94A
	for <linux-xfs@vger.kernel.org>; Sun,  6 Oct 2024 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728226379; cv=none; b=qHFqr9pP5h+YFOBe+VY9CaBakqkqEyZxP/VGlELXQSJ0t0G9Is2eG66TFunskcdYQmMj7NLZwKEvkByJc1CvdGH+ulqfY77OOGkIneV0CdRwclwXmwQwgVRyZ13O7syQD+v1Aq7+uoci/N7nJi8xFduN6KYZQ3UmgzzlPMey2mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728226379; c=relaxed/simple;
	bh=shgDBjQqYSVf0UslaCxth3Qda0hEBLGt1sWdyIHJPVA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qGVNGZw2pRb2HwbHkAjhkYGlg3SlgDPeHDg1LrNwEnAEEv92WGeZZi+DgtKicRqTF1Rrcx/wccIhlFSJxN51hHVDNYbL9NQ5FLR9JHMHO78S1Rf38OOojd/KAnJaJarEYceGCxtRfg0eenUAI/cLKb7I2/gWvic76Ju3Lm7e6wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=RxDzy/sd; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="RxDzy/sd"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2e07d85e956so2974817a91.3
        for <linux-xfs@vger.kernel.org>; Sun, 06 Oct 2024 07:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1728226377; x=1728831177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/jN5IJB1E2Lr0al72GEamd2RYur9sqqi/hVsmg8n8rw=;
        b=RxDzy/sddpK++kRlX7NALV7binrBIaAPHAjYb1RFTHcEyReTxzdPYeLEVKFdTpt32b
         A0vj0Qs1satPkjmFxWMZJxNmmrmisCuhLu2B2RHyAt56mkTDTOBXw69D8q1+jULwQToH
         xJn17BmCM0zyRWrdRDJjkXB5fE+Oen2MQDlULNFP4S1VdXtdWNUvSitS4lrB5DnVPf5n
         XlUps8LrX7Plkieoq7wiWJRk7Vipob8RmCBQyQF3qNm2iSbzG6QCzCp6xUTd64i6ub+k
         ptddsiyFX7jwkGJm5/f1Cidq+r/mX1dsiSRW1bAwYFm0qyt3RsKFrpVEzExCIo6GUJcp
         2DGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728226377; x=1728831177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/jN5IJB1E2Lr0al72GEamd2RYur9sqqi/hVsmg8n8rw=;
        b=oSQqQXh/U0HA35cV+2MQEzk7qvL2QZm0Re9V1bb30VlxvqyYWAxvmkSGWG8DmAHbtI
         9qNYMbV/EGVlI8ETwAliWL3CRFycn/seW+HQ1RedsL+LynuXKjNncTQPuJ6Bo7KCuzJZ
         KwE48zyimbCub8iqNM+vP6frF76HSIQA/OowQiaPCZRx6lVe3lvCBsW5GvLLI6c/lq4L
         t0XtQ2AzzIcaawalrCGaWp7UPIn1vtJDrpg9RhuTOT74sq+QpvVe8gOaOTIfl6qdGqtE
         KfQB3aZUP/mu/BKv8UxF30q5X4QddIiTs81kAYYiq8CmGMmdSdOWuwBlr5owLfeJ2oJa
         jTGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDrlBTf9gFOGxhVHZtWFOdHWjBKbhRvAPyT3kwMBfad6gjm5lEuplDgVCAaEPsMoZCrgiR9HAegEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyP2FYn2dfws5GvsA9e0kq7s8ZFc5lYrzld4V7NTld8+5EPQq+u
	rNn2Eq9nD6LjYXW0imEWEMxuwyRM+fOZqK0sCRvmEWrJw2SzUNJjatjkiQVuDtI=
X-Google-Smtp-Source: AGHT+IGuPc5eZvJWKPTOyXTikGuhJmkR+fXTXGygxbFH1nWXgpOcVKkQSkjknXHFwPK0qUQPDVGQDA==
X-Received: by 2002:a17:90a:4bc6:b0:2d3:ca3f:7f2a with SMTP id 98e67ed59e1d1-2e1e62674damr9537001a91.22.1728226377448;
        Sun, 06 Oct 2024 07:52:57 -0700 (PDT)
Received: from localhost.localdomain ([143.92.64.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1e8664bfasm5213680a91.44.2024.10.06.07.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2024 07:52:56 -0700 (PDT)
From: Tang Yizhou <yizhou.tang@shopee.com>
X-Google-Original-From: Tang Yizhou
To: jack@suse.cz,
	hch@infradead.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	chandan.babu@oracle.com
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Tang Yizhou <yizhou.tang@shopee.com>
Subject: [PATCH v2 0/3] Cleanup some writeback codes
Date: Sun,  6 Oct 2024 23:28:46 +0800
Message-Id: <20241006152849.247152-1-yizhou.tang@shopee.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tang Yizhou <yizhou.tang@shopee.com>

v2:
PATCH #1: Rename BANDWIDTH_INTERVAL to BW_DIRTYLIMIT_INTERVAL and update
some comments.

PATCH #2: Pick up Jan's Reviewed-by tag.

PATCH #3: xfs_max_map_length() was written following the logic of
writeback_chunk_size().


Tang Yizhou (3):
  mm/page-writeback.c: Rename BANDWIDTH_INTERVAL to
    BW_DIRTYLIMIT_INTERVAL
  mm/page-writeback.c: Fix comment of wb_domain_writeout_add()
  xfs: Let the max iomap length be consistent with the writeback code

 fs/fs-writeback.c         |  5 ----
 fs/xfs/xfs_iomap.c        | 52 ++++++++++++++++++++++++---------------
 include/linux/writeback.h |  5 ++++
 mm/page-writeback.c       | 18 +++++++-------
 4 files changed, 46 insertions(+), 34 deletions(-)

-- 
2.25.1

