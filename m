Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED41436683B
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 15:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770046843; cv=none; b=h2FsIa1GBYD54S2RkYpdSTSFuH5ryS5RHlrFyuoz9Felx95mIUzIZY6n5thIR6Ydixziy5BSC9bGY1a2PmDkfPyPTQ9zdIIC+Knsdd92oW6IhOyYjORpAzLLN+GCX5FP3MrTgGCFXiPFCYv1Gv2ZlyJxLR7qN5waQYWgecmrBRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770046843; c=relaxed/simple;
	bh=RP6S1ivaYAK6Fs5+VhDcT3M8k5FicM0n51mqRABDv7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nVmHs0O3RS9KLxy+7UDKNk1BQbqkOeia5amC6cZABMbEXsrb8530xgGW+0BdjNNPn/voY0CUzXd2uB4ZA/6u1y7UwVFxtDVmwgoz0e31fDCHzqPHOYVzRY+WS1aCA5yLuCUdSpU/w96cQ8F2X0dGr6hNJhJHtAlnEX9CmK3TteE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kAQzHm5p; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kAQzHm5p"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82311f4070cso2948821b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 Feb 2026 07:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770046841; x=1770651641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n05z2JgZ055VI92yGkVjhSrgVttdCiXX4GMR4DMFah4=;
        b=kAQzHm5pTWygrkNcCvwyQzPkeb3zpZ1/rPtCqNQ/srl24eOOYRxh3hFsf2L1I23R5z
         Ib0UCnjBi1f2Ddp64smUrCpzhSHN73Q3nHbpcJo8RP9m70biXvQuxFIltD3kLsZdAJWa
         kvISTxR9gTS6PaGBpztbHS5WBOj4BeLX3h8kW7c/q/EJ/PgAwLwxmv+lzESVFqOHU1xe
         gQqWcUV1QaunUWmCIFcR7hSbSf2TAA6YVP4ATqrk7eqVyU3TeToApfDtI2bzlO2OarxS
         YcXn5y+XpnwPOHa/zQHe5ZxcCFqNWbWsldbU0l1xfiptEo6Vhkwl8cc1svydgnH6tR41
         4U5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770046841; x=1770651641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n05z2JgZ055VI92yGkVjhSrgVttdCiXX4GMR4DMFah4=;
        b=MUTd/JwDpzC6cXwjbIPWGm0lik0/1Fs+kVMvj/0ZSn+KhoxqtCoBOPBz1QCblFjCBm
         nOi4EtPeysCLjYPDyrINAJ6VlfehbMQHH1YxUWgeWLkLij8hMTiEU5pC30+E7lVi2qHb
         4ZBZ4ioWxwJHJKtOf+H+mb4BheLU3vczmeQtJvSUGvBPcYB+1AUPtHC1zCWVldI4Y37z
         Pm7ie2FxmQdhaC9EooVHbqvoi3K5kkomigsg+wDHpwibRxLV1JhOX/YEBgTxAWWZSX9I
         UejzPH8BiZZwf8fHMD5r8dcagOzb8WowDajQFDI1xuTUndux5WhdZBeU0P5rRvXInbLe
         TDfA==
X-Forwarded-Encrypted: i=1; AJvYcCXXPO9VNRaPF1DrIu2JlDQzmuxAt+mgt8LAqDWjDTjkkGnJvSJjflTT2WBpgIjWnkvPU2V0WsnXfqo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjgxJglLTkiYOdWeneEUKSHi+oylST6ROVj4Tgfcx5o3YOs1fq
	hIV69T/emw76wh5D4g4xWlEtsgpqoF4wRQiFnAp5WXhZwbvSxGak9cDh
X-Gm-Gg: AZuq6aIp19HFaPlBWrZG6sAm/xLkV9avA9MrgEMReBuYA65QJCyMg7JUb0BjghCcimr
	24v+w3TM6jgyVOQl5sxCHvjOZUkoQoA9ZeS8bPuBHSJ2lgI7NA4cq9Bm2+vOahzQK1SsO0DsPZk
	eNcTdukTcheP7yNWZBM8ZPW0/OmkAn3JNG1WpSTLXG0s+xdd5f37fLoFpSFULni0Jhr3LFrj0Hv
	CxHNVQcPVPQVAYbsmpgy3MHZtkCzrcm0tYZ0vsQvX1VLR20l6vEy/GF4NQT+GBKHfWVVu/oRywI
	G/9Xp5cw7BOxXjVRBdMvu77ExhZA2TBBhFCZG3D9aI9sSbQQ+XDKp9L1K4hyNQ3JpzIcRjZTBLM
	IsKVLoZQ5gLeh0EDfg1Fselqp9z4/hJqBQPy00VfkLOSFBRm/8cRNJk0PZK3pL8sCorKzvB/XVG
	l47vWRh55XRdeDSVXTARhwL/Uh6Y1tmGRjx5HcZ6Bh/+tj/5nQ1LHNc7tgmws3czgLbc2flGgWT
	M6flFsZLQGvSxTjf4v3hE8ppWjK45kEZ9ubp91up8FTSw==
X-Received: by 2002:a05:6a00:218d:b0:81f:804f:af26 with SMTP id d2e1a72fcca58-823920f2aaemr18442535b3a.19.1770046841306;
        Mon, 02 Feb 2026 07:40:41 -0800 (PST)
Received: from lorddaniel-VivoBook-ASUSLaptop-K3502ZA-S3502ZA.www.tendawifi.com ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b2305fsm19783019b3a.10.2026.02.02.07.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 07:40:40 -0800 (PST)
From: Piyush Patle <piyushpatle228@gmail.com>
To: brauner@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+bd5ca596a01d01bfa083@syzkaller.appspotmail.com
Subject: [PATCH] iomap: handle iterator position advancing beyond current mapping
Date: Mon,  2 Feb 2026 21:10:30 +0530
Message-Id: <20260202154030.644730-1-piyushpatle228@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260202130044.567989-1-piyushpatle228@gmail.com>
References: <20260202130044.567989-1-piyushpatle228@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reports a WARN_ON in iomap_iter_done() when iter->pos advances
past the end of the current iomap during buffered writes.

This happens when a write completes and updates iter->pos beyond the
mapped extent before a new iomap is obtained, violating the invariant
that iter->pos must lie within the active iomap range.

Detect this condition early and mark the mapping stale so the iterator
restarts with a fresh iomap covering the current position.

Fixes: a66191c590b3b58eaff05d2277971f854772bd5b ("iomap: tighten iterator state validation")
Tested-by: Piyush Patle <piyushpatle288@gmail.com>
Signed-off-by: Piyush Patle <piyushpatle228@gmail.com>
Reported-by: syzbot+bd5ca596a01d01bfa083@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=bd5ca596a01d01bfa083
---
 fs/iomap/iter.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c04796f6e57f..466a12b0c094 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -111,6 +111,13 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 			       &iter->iomap, &iter->srcmap);
 	if (ret < 0)
 		return ret;
+	if (iter->iomap.length &&
+	    iter->iomap.offset + iter->iomap.length <= iter->pos) {
+		iter->iomap.flags |= IOMAP_F_STALE;
+		iomap_iter_reset_iomap(iter);
+		return 1;
+	}
+
 	iomap_iter_done(iter);
 	return 1;
 }
-- 
2.34.1

