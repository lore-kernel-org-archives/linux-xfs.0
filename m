Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77831AC8BE;
	Tue, 24 Sep 2024 18:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203156; cv=none; b=GKBbP1DabHznyb232u/jWlWy5lbYPahctsJfNRqhcTQYbll8mqVVVwxlkryZzpH7rV9MUxdipgxtkDpGO6CsNgTk9LpLvsuFc6DIidBpx/ihdj07+i9kMzRMLEEKR7dgybdiaMmVbQ/gwp+tFdmADiFJ7DuWPQ8QmVRzK9pO1bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203156; c=relaxed/simple;
	bh=GSoJ+xfdvN9VGcn4z9mhLFvNIWYJJi4wuZTOf4puMQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T24pwlc1QnCUjamLdFjRd3fIYW6AZn6xTNl12q8xSEAR5FTMZIONP0eHHkLfIepo+i2SqCJAGmjYCk4teYpQysGX+FBG1onOgBSZ/dD7lFXU/oEufaSxnrrhTtPCSBIFReuBvfb6IIhifi6kdAO4QNlhoayDK4V0uwUFt2LuHqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRi+flTJ; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRi+flTJ"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-656d8b346d2so3680722a12.2;
        Tue, 24 Sep 2024 11:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203154; x=1727807954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QG5QFevg4WSS02ZDjik0CgJaj/D5fK0JboTy2CiftOk=;
        b=BRi+flTJX9f6lkBLEq/nrBGXCFHmVmhyf8mES9uIv0y+UjOnxqn6Fsr3Ofi9zDFA1M
         QWIH0S7plMyJ+ebvbjW5vM2y8CXQAa3PuAPgSbcCvpjCf3lw2u1XCdogbl0nRuXWfJEu
         Y8JQpkEhD4FMKex+jtOqdk0Lkxd539RmMfoeE6+Raory96dJAWHsJaHTHmRU4glW0kQs
         2LRRtz8+Rq9+PNxH0hjRz5OlJrPFKcsmrhCfANpZ98pNpGRuNz4Vj0/RlWPHdSOZtyhX
         HN7dmhzrtw5RSLGtwPjcWPUURrMFnTOSMvLsBP8qzZ0JDC22Kb3+UWR5njg5ruGKSi3c
         xbsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203154; x=1727807954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QG5QFevg4WSS02ZDjik0CgJaj/D5fK0JboTy2CiftOk=;
        b=j6Y/szgdGlDuEhymA5xGG2h+OMCga0LiTwPuTR39SqYLD7a8arhP4TeMi2gN8eHBxn
         km9O7W+G19+7mtqGNSIet1Et5un5Y0jWLIOX7OQr5c5gxBPDD2tUo4miuXW63n9DKgrM
         siKe+VUY9kf0QBYQjr09MRQONO2d7jKCBc2/ij93X+L+pCHm/WvvLCE1x/0XpMZ3dKFA
         hjWFnr4iL1YQ6W9VruMZ+h0frFs/g4Zk3M+LzwwyJALINFyuwH82MLvlAmOaNqn8czwP
         wM7JVrvckryM/2mtZ3JmBFoMe8eiCgPi6P/vuuKKyEqR9ZdYBORdTuFJAmKMS4webZK8
         mITA==
X-Gm-Message-State: AOJu0YyXBgreB//yh8ia1qs5BZ00HrQKT4kYTJG0lhcCamHUKcjGvwhV
	ljz0vu1QZpTGUfpf+jTx+3nY45y/Kt9hXdZbrl2CbsmNRwKqtTJCgGak0DaG
X-Google-Smtp-Source: AGHT+IFVfWnKbiC5eFPmsAKgaYQ+s01s8fdmjPgzkyb7ZS58wywTxosSDvJbUhFFj0IzySfBzHlKXQ==
X-Received: by 2002:a17:90b:4d90:b0:2c8:e888:26a2 with SMTP id 98e67ed59e1d1-2e06ae6200fmr114233a91.13.1727203153937;
        Tue, 24 Sep 2024 11:39:13 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:13 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 12/26] xfs: defered work could create precommits
Date: Tue, 24 Sep 2024 11:38:37 -0700
Message-ID: <20240924183851.1901667-13-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit cb042117488dbf0b3b38b05771639890fada9a52 ]

To fix a AGI-AGF-inode cluster buffer deadlock, we need to move
inode cluster buffer operations to the ->iop_precommit() method.
However, this means that deferred operations can require precommits
to be run on the final transaction that the deferred ops pass back
to xfs_trans_commit() context. This will be exposed by attribute
handling, in that the last changes to the inode in the attr set
state machine "disappear" because the precommit operation is not run.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_trans.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bd16fbff534..a772f60de4a2 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -970,6 +970,11 @@ __xfs_trans_commit(
 		error = xfs_defer_finish_noroll(&tp);
 		if (error)
 			goto out_unreserve;
+
+		/* Run precommits from final tx in defer chain. */
+		error = xfs_trans_run_precommits(tp);
+		if (error)
+			goto out_unreserve;
 	}
 
 	/*
-- 
2.46.0.792.g87dc391469-goog

