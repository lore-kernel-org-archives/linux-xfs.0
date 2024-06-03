Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2903207
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 04:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717388082; cv=none; b=fQmGdGZSuP2i9+aCbJlFefGEwcprk3zOQ2EOsdQ5dKFtkVUsQmBas9aLrjm5AigAkAxqNWHpA9hY8GkSx2uj3RkjSl1MHoSm1bxEdNW8dl8h0VZTqGCc0PTEZnlz8jL/VUY6q/wft6Ilgj3Q/YDzebsEdu5iXgsPpIPNfnfJnlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717388082; c=relaxed/simple;
	bh=iBG3J93LSr8ldFaD9jUhpeGTNlOjTeEc+4DnjPOCnTI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r2Y/rxJNAPfDeJ2rNWDAk7G+CW0ShZjkJKNbwhwVWGwnLungSC0LWOBvj1DEn05nJpRCNe+OlhHbrxwpB55wYdN1Hh99sd0dK7B9ruYeE0cEzgDjSY4sPOKEXVMU5UQfkktk+trjZWoFVYWJ3YC0aBYC2fRsTqPstfdqHccKJ0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i9GIOMMm; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i9GIOMMm"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70260814b2dso748487b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 02 Jun 2024 21:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717388080; x=1717992880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KZh+wFqw5Y9cxS9lWkEqLNC1NzUlg+xmzN63BHBhHww=;
        b=i9GIOMMmTf45fRINJ1m7W621cbVN+XH4U4ThNjwRzdGhg5OU1dTbC3DiPSrXn2KvqH
         T+zNyPw3qjQGtidf5rdcTkrQnYZ978ECXuT1T/R4nytoTO8QYiz12iD9Mfo8nwS5aqyq
         33FVz96hUjtbNt+6dr7aIMf5dn9hB1LC715eucuxVimyFOv3o3L3qn/zTxyo/6/vIOv1
         PoK550+inOvgVhjxHyFgsa2MHjd/kMUOiMobY/h01Wjz1rVrLFutInYG+WbIOsbK5cKn
         kGtIvTz2NrOjtHxnupHWqGemLIeg5DCSddI7zhqz1ucb7HZwVzmZCjFtTi91pgIPDMJ0
         P/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717388080; x=1717992880;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KZh+wFqw5Y9cxS9lWkEqLNC1NzUlg+xmzN63BHBhHww=;
        b=b7dx9W/PUX4zJFw/UPcSmT/Ijv5lDKmrdYQZNdTu0RdoIsZAEEeJ9CAOhAvgfLiacz
         vbG4At/6wSyMyKnj8r5EI8eo7DyCkrGjc60wsApojFfq5HgFYc+ScTrhV5eUIPMo+MaM
         HWs2Wqt6pDYgKjG9o85rblN1qd/xPiqJ5RSpNbSyEJ31pi7UJYQ4eHwinK+TcSrPFXBo
         qK49rjMlJtfCZG3eZCAWG46GHMDEpfUfminxUm5RvzewsExx00Hhek0iMfGLroffBLcn
         09b0uQfhYXLlfT80XBTbL/oUoX0dusaAWD0LHmVSPDaAGFwNd5T3Ivl6SljyEuZ3vnNh
         dhtg==
X-Gm-Message-State: AOJu0YwUGwbV/T0fbj8YKmRRok6OqdBqqGvQC2ay+Vp/DHyF2ktjJsXI
	hhA39l3qPTzr/HP8ySR66ZBW+CE/71J5XYnDmoeF21c4NSjdNwcAGE7f45eN64I=
X-Google-Smtp-Source: AGHT+IHwSLy7LtBidCYVfed+Bsxm//YkSiM/YNL1O3W6eQ5VkMxZqcjFgp5EBWHH5X452I75YcRK0Q==
X-Received: by 2002:a05:6a21:3296:b0:1b1:f732:779b with SMTP id adf61e73a8af0-1b26f0ec8b2mr12295199637.3.1717388079789;
        Sun, 02 Jun 2024 21:14:39 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702423c7bf0sm4619620b3a.42.2024.06.02.21.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 21:14:39 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: chandan.babu@oracle.com,
	djwong@kernel.org,
	lei lu <llfamsec@gmail.com>
Subject: [PATCH] xfs: add bounds checking to xlog_recover_process_ophdr
Date: Mon,  3 Jun 2024 12:14:10 +0800
Message-Id: <20240603041410.79381-1-llfamsec@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure xlog_op_header don't stray beyond valid memory region.
Check if there is enough space for the fixed members of each
xlog_op_header before visiting.

Signed-off-by: lei lu <llfamsec@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1251c81e55f9..660e79a07ce6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2361,6 +2361,11 @@ xlog_recover_process_ophdr(
 	unsigned int		len;
 	int			error;
 
+	if (dp > end) {
+		xfs_warn(log->l_mp, "%s: op header overrun", __func__);
+		return -EFSCORRUPTED;
+	}
+
 	/* Do we understand who wrote this op? */
 	if (ohead->oh_clientid != XFS_TRANSACTION &&
 	    ohead->oh_clientid != XFS_LOG) {
@@ -2456,7 +2461,6 @@ xlog_recover_process_data(
 
 		ohead = (struct xlog_op_header *)dp;
 		dp += sizeof(*ohead);
-		ASSERT(dp <= end);
 
 		/* errors will abort recovery */
 		error = xlog_recover_process_ophdr(log, rhash, rhead, ohead,
-- 
2.34.1

