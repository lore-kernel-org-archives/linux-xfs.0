Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63B6318120
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 23:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028110; cv=none; b=NnBCzibU1/UF3lNvAOJmR1utPA/GDpSaTYg3H0fu1aRNxWWMTw+pQETW5ICFTBMJRYOZDSVVPMrDi/w4VQLRS7iT4dfVADxD6RsmQbfCalPqU1GFkcjCkAnTXSe2fUjXrWKkhdJkAOK2JOQ60skbISenU6E5Cw/ce68cJ6veLZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028110; c=relaxed/simple;
	bh=AU6gZMWoUejzxWtNerSxKMr0ZxfAoqmaTtwAxnvaFgQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dhrF5tlXA5vUBGZ7hXfTcQwqxtwXj3Jg/UiH3rkokko2rWexTdz5UPUY526Hipubhc9vZkYseL960Y8mxCEEPS4RYmxAkaiohsL6YLNnogzy2TdkD3PNpewG+amflbl7a+hjeOBfmyEUv92/tVy6L5NLulbSTPPor0ahb9+p5VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lq6ugxMm; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lq6ugxMm"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-bc59a785697so4218087a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 15:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028107; x=1764632907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KD9mOy62HqGMPaOYo+qJ4jLF6S4k7Y6n0q2fK45fvpw=;
        b=lq6ugxMmUsfcFcfrN2hI2q5uo3qKC0lcYsCcmMVQlglmNFMZsZRxQws1LIAEQ9d4uR
         Tcq2enPC5f2a7pXnih0YZW2TCZ70XI3wUfkMuTfGib69MOF1JzD6Fs6/LIU5vH/d4+Ch
         ag08aC00IeRf+xW32sBk5KEYF8m+h61nwsZ+/7bcxsYi+ssrYvgeM1IEqKzclY1OpKQ2
         6UiFw7foQTpFGzCqj5bJD24hwUyzhCoOZkRfXW/xL6M6YXRlHXdGNKSFJVoIflMnPM+Q
         8s+3cLIZa+ljYHSQ0HeJqVyMMK5yi1YdC9xLId/M2CrxGewIQJ2b+ufHsNxGMIDiP4wa
         0K4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028107; x=1764632907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KD9mOy62HqGMPaOYo+qJ4jLF6S4k7Y6n0q2fK45fvpw=;
        b=wzXt3Yj+Gze1MOOtmEznhnGD8fEsRMFqHwWMMvM7RZ3FCfsbgqzja68r2MMWx8hSVp
         2aI+0ktUpb2biNR9ZYsueELfixJQrcLCIXOa71FmG1dvZk0yHkGfAHTNnEDZ48vgy/R8
         FTwBivYzr3bkydRB46cac5uHAksIBO1USSc8qAU45+NNZFJXeWL05ssCBNI6n/Gx7V6d
         pokwS4TJBx1YGMyKlAfu/gSmdeAMVpVfkJuiCJB6kGYdVyW9xAY75zn/FGfNIiVFme2s
         CaEcdKNWkDIRVFGThMMhbN+PjeIHI/Ds/6kUO6qfmKmZibi+sOQM6+uFsdvu9+P4+5cc
         k6mg==
X-Forwarded-Encrypted: i=1; AJvYcCU6LljnuCpBc4tERXfjzArjGevM9jTnrG/i2L0a4Y1REUtI5FeurgeOMhiNiWYBtH4eXl+BhDvE9GM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVraVuwyUrJE0GaAX4tlIjcUFkjaetTxtajZDdr2O1SdoTBEVV
	mcEDL/lAEoJeizNeONN4z+K81keKfPnGZiOZrauQXxDMYKkkMLu2QUTr
X-Gm-Gg: ASbGnctvchT40+turyKWg+ZfUxsn4wCVOhl+AzomGLXldbEZwcMEZrItf3t1VSeRZ6h
	sR18J0qJP65NQvGpSFAun4Iv0IJZ/rqqrjDDf8yrhbibSp2HfkokkFrl43saxDdLsmN1C69JOGK
	ECaGTTSXFleVxWaJDFmFqT7LpyhrDUpucLapCcO3hA4l2fe66fFM9OA30Kgjobo5qx2lyRgc7vQ
	svKHaA6GBVR9J6KSgh+pfmA6tpuKaziHQtQ0tnfKotLEIljRbFShOb4+8Gv6xcIlj37bvg/Y9YP
	rdzMzLcZOuE3qzVC+r28T1XeDRgnLbTtLMQLG9RF0uOX3YNDZzzCQdeOfK5t6xysSZ1K2Q0w9Y5
	F+nGx/LKrJEQqGEKtXe3O9P0oDpmuT6dPInYSLM9TFa2LUOf7J1fGCE3PKgIjGRoMalrBr/W5YI
	0KC07ObliWjF85I2pIcsxIrJnPEUqHZQSaerll2ZVn8+0nQ3c=
X-Google-Smtp-Source: AGHT+IGqGWPp3dbaz9P/oMvxkH8tM768OBnx1ym9H6OndIwxHy5XjYnjyPQDBtMIVrKtoM7S3ehYMw==
X-Received: by 2002:a05:693c:810c:b0:2a4:3593:9697 with SMTP id 5a478bee46e88-2a719279965mr8848102eec.20.1764028106837;
        Mon, 24 Nov 2025 15:48:26 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a6fc5b122dsm56253333eec.5.2025.11.24.15.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:26 -0800 (PST)
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
Subject: [PATCH V3 4/6] nvmet: ignore discard return value
Date: Mon, 24 Nov 2025 15:48:04 -0800
Message-Id: <20251124234806.75216-5-ckulkarnilinux@gmail.com>
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

__blkdev_issue_discard() always returns 0, making the error checking
in nvmet_bdev_discard_range() dead code.

Kill the function nvmet_bdev_discard_range() and call
__blkdev_issue_discard() directly from nvmet_bdev_execute_discard(),
since no error handling is needed anymore for __blkdev_issue_discard()
call.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 drivers/nvme/target/io-cmd-bdev.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 8d246b8ca604..ca7731048940 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -362,29 +362,14 @@ u16 nvmet_bdev_flush(struct nvmet_req *req)
 	return 0;
 }
 
-static u16 nvmet_bdev_discard_range(struct nvmet_req *req,
-		struct nvme_dsm_range *range, struct bio **bio)
-{
-	struct nvmet_ns *ns = req->ns;
-	int ret;
-
-	ret = __blkdev_issue_discard(ns->bdev,
-			nvmet_lba_to_sect(ns, range->slba),
-			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
-			GFP_KERNEL, bio);
-	if (ret && ret != -EOPNOTSUPP) {
-		req->error_slba = le64_to_cpu(range->slba);
-		return errno_to_nvme_status(req, ret);
-	}
-	return NVME_SC_SUCCESS;
-}
-
 static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 {
+	struct nvmet_ns *ns = req->ns;
 	struct nvme_dsm_range range;
 	struct bio *bio = NULL;
+	sector_t nr_sects;
 	int i;
-	u16 status;
+	u16 status = NVME_SC_SUCCESS;
 
 	for (i = 0; i <= le32_to_cpu(req->cmd->dsm.nr); i++) {
 		status = nvmet_copy_from_sgl(req, i * sizeof(range), &range,
@@ -392,9 +377,10 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 		if (status)
 			break;
 
-		status = nvmet_bdev_discard_range(req, &range, &bio);
-		if (status)
-			break;
+		nr_sects = le32_to_cpu(range.nlb) << (ns->blksize_shift - 9);
+		__blkdev_issue_discard(ns->bdev,
+				nvmet_lba_to_sect(ns, range.slba), nr_sects,
+				GFP_KERNEL, &bio);
 	}
 
 	if (bio) {
-- 
2.40.0

