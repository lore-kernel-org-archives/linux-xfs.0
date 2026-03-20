Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3202DB7B7
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 03:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773976372; cv=none; b=lsWwjuRR6IPgWrthUc2TDDpeg/VhnDC6WwEJu87qh611zyu8LCwdwUw+wyICSBPlHzBdZ613FvysKWSz8U9u+37r7pywXKNIr/U00ndrRuT2cKyR8uByvpz9AFyZiJQnO4oXBs6bw30VDrAaeO/0Iln2c0mw4Mf3Jm7s1W3vSjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773976372; c=relaxed/simple;
	bh=NvV+h593Ou5IBnxtUlqtw1Pyy++rLNAuvH0B1AJ01CI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bzdLsGzvL2hvTKzOV4mXyzs5lnwF08LRZU3rRM85iNrLbBNH+VxdjoCcvG4qs1r79497wvXFpcAggI2JQ6oEa5brg1ODCNj+DuVUFzdE5F68h1IVHQ+zjtCESKJMckphRHVFWCiB+64r4b4ULCQtlSDqYUFjz9gVFLeSfloiFic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J72F7E6l; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J72F7E6l"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b04fc8851cso14977345ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 20:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773976370; x=1774581170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4I6B8Rx4hDXdmswJxNp2RjYpERKWQN7pv7OUIlU9OXM=;
        b=J72F7E6l2u5ftLiq8lu2Nf13vGpquLSXaBwhQ9O9g7NEDaBvAUGjKPFvLX7xvspe8g
         EaGry8PsI97ZptjuIgCIfVYScXFq/x+cg9vce/bRNhSNdcXdUKT+2j5X9KGasqT2F/oO
         uCV0n7V/E7zhLtT8RE3fmMnpBDv/lRUz+g+fmldFfylwWWs0TViCG3zPae6pviv5E0qF
         rTB57PYJ2B1H7qS8E5EydNSd67FeToeuJdbUZwT4nmxjbNohFsq5Tl4YmPZpyfAlwrVN
         x8fn7FOmgBbpotHgBVYqjbxJl3df2Ra7/qo9ekRsry8UUC2afcUYy8d8HV27BAhSWGVz
         tVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773976370; x=1774581170;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4I6B8Rx4hDXdmswJxNp2RjYpERKWQN7pv7OUIlU9OXM=;
        b=d1Ohp9lGErfMgPkeoQHd9PKr6GIiyxDfclYPSzZh7EA9SF/h6PuPJIeMRvvQgHHArF
         oEgQzltvQZ9r/LAJoZlL3yjT1P6p7ku7kNTdFdrwMfom9l0adxq79eOOABlhuYx8U92l
         N5njTjFCQr868ySJCMaRw9WUeGyICAeYGBEMTO046bDk7YxZ5OTYT93IBXaddAsM8TI4
         sc0zh8Ur7wb6uYa/ADc516J1N7WuBljNtH6puVIsOHc+dITnKEbu9vPRRkQLPOdvI/ie
         8O6Fl8x8YbPGkeHNyVQ7kxIMcFiQbagEHM2fUAFAIV5uraArLn4lPZRtoSocXEZKHK2Y
         ztyw==
X-Gm-Message-State: AOJu0YyepYym3y9XEqA4+MejBX/GkfH/vGyvrVlmF8yzjKduvmLRsMw3
	NwLOWlsQqnDiF+I6y0Vy5rteAaeyJVCoFeGlaKnR6M5zoD6iTDTNONwe
X-Gm-Gg: ATEYQzyllZLAoDRm3kgFiemPi7kXInhsHggRsgSelopytOGGkcjDYnbWcIWyDYcO2Ds
	GPLtKio+0dXoiNy282l08i1e3L4H19PLA2w+oBEyVpEasXM3r2XXFRTPZQu/0ESsGfoxj0iRteJ
	ghtUKUgJ3JHWXy8LZzmRt5x9ijkE60ao4GKsJRMHeKffT6HuhwJmf/13R62pGs2o5kcrgagJakd
	bHwCCuwnUecFrisL2x0bikubEbjaooFnqDxddd3QtXpklqvxXRs7UEn0daQ3YiR91hguq+qYtJh
	MQSJdKasmxP0737vVQIdZZBAi49AAEclVSsjBVCzWIWi4XMoVPui/gu4BykF9rJ5qj1CpY0Ah/q
	AULKNKw5fDMCDdpk8YKV1LPCuu/POQY4+WqSyGWiBkIXqxaa6PEmpHvZ+CSeqiGkzgFSopIHMUy
	JW1oKPNGD3YLZpytdmMg==
X-Received: by 2002:a17:903:32c6:b0:2ae:55eb:f82d with SMTP id d9443c01a7336-2b0826d751dmr12591125ad.1.1773976370299;
        Thu, 19 Mar 2026 20:12:50 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083656df5sm7259535ad.44.2026.03.19.20.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 20:12:49 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: annotate data race on li_lsn in CIL formatting vs AIL insertion
Date: Fri, 20 Mar 2026 10:55:07 +0800
Message-Id: <20260320025507.3331221-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_inode_item_format_core() reads lip->li_lsn without holding any lock
to embed the last on-disk LSN into the log dinode during CIL commit:

    xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);

Concurrently, xfs_trans_ail_update_bulk() writes lip->li_lsn under
ail_lock when inserting items into the AIL after log IO completion:

    lip->li_lsn = lsn;

The CIL context lock (xc_ctx_lock) and the AIL lock (ail_lock) are
independent and provide no mutual exclusion between these paths.

Under simple interleaving on 64-bit architectures this is benign since
li_lsn monotonically increases and both old/new values are valid
checkpoint LSNs.  However, on 32-bit architectures the 64-bit xfs_lsn_t
can be torn into two 32-bit loads, producing a bogus LSN that could
cause log recovery to make incorrect replay decisions.  XFS already
acknowledges this concern via the xfs_trans_ail_copy_lsn() helper which
takes ail_lock on 32-bit.

Annotate with READ_ONCE()/WRITE_ONCE() to prevent compiler-level
tearing on all architectures.

Fixes: 93f958f9c41f ("xfs: cull unnecessary icdinode fields")
Cc: stable@vger.kernel.org
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/xfs/xfs_inode_item.c | 2 +-
 fs/xfs/xfs_trans_ail.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 8913036b8024..ef0a0889c580 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -624,7 +624,7 @@ xfs_inode_item_format_core(
 	struct xfs_log_dinode	*dic;
 
 	dic = xlog_format_start(lfb, XLOG_REG_TYPE_ICORE);
-	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
+	xfs_inode_to_log_dinode(ip, dic, READ_ONCE(ip->i_itemp->ili_item.li_lsn));
 	xlog_format_commit(lfb, xfs_log_dinode_size(ip->i_mount));
 }
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 923729af4206..3a0e0c65ebc5 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -831,7 +831,7 @@ xfs_trans_ail_update_bulk(
 		} else {
 			trace_xfs_ail_insert(lip, 0, lsn);
 		}
-		lip->li_lsn = lsn;
+		WRITE_ONCE(lip->li_lsn, lsn);
 		list_add_tail(&lip->li_ail, &tmp);
 	}
 
-- 
2.34.1

