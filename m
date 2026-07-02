Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2731030E82D
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009212; cv=none; b=cIG1KCm+SEzIqBr/qH5zRSiRWfqcsEx350kkHr4aNUMnRfp4XiG2a+wg0kXFWfb3CFtZts8TOoFnkaz44FiBiVd5WuXNugo3D2IhdUoy+Zyw+kbVbB9prfHSvfXlQNcNUsehA3pBaKQdpRCA9HY6ZxnP/Xi5cEVQsBDJeRnCGpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009212; c=relaxed/simple;
	bh=YkifzzUJ1OIGyF5Al1H+xUDqEKvcCO2rPaAV9TEQLbM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LMbpOp9aTZYSi+7qHTG4Neeu9z4PcFu3fvdt+bIW2DX5Pq0g8qNm/TuW8UP9aAGcI+fehS60NDCtB8tLrHstJuZF/rIByq5PZfy4RaeHYDSWhmm86wFjzR30s70RkMR90QrsLWiCECTm4LogK4OS0wgZGAIe7pESWs/3Mc1YXCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SgIrMMaC; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SgIrMMaC"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c8b49639fbaso1328249a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 09:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783009210; x=1783614010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qOcR1Cxg64MPN7ZuuLfwJvMkCMR8JIOnc95xJL05BmE=;
        b=SgIrMMaCUPx/DNI68mzLnLz4OrMRMheXH7QB5P+V+LOExKOPox+MvuGcrtJlu86t47
         D8PC+OUioJyCSX2HZDfAI9DXtoux94g2b3rnSOp5XPyqXH7ert6jzyEKYD+bXfYskXcZ
         1Oplnv87peDMc4FVODr9KsAa46dqDogSFk6l3nhobw7gMaAg3XCOVgdTxFWSzeQ2PTeR
         57rlMdDRx7wqrhaGlTsmqqwVdfL3Np4hrEE1MXuNvXdCSjbRycQH6Q8cAmq88imVPi2q
         o8NX5m1XwsJCr82XNqKjXo0jY+VWWdHfqa/IcwDnuYw3BsBmrMluQjofwyNUNOsUWdyW
         ljPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783009210; x=1783614010;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOcR1Cxg64MPN7ZuuLfwJvMkCMR8JIOnc95xJL05BmE=;
        b=HK2HNoR2k0Ir6aFBf32dN+c8eRWc+BTRXAxCj+DRSbXP4nFB5ZQl+8mCkQ156g6pIu
         R+XY4UA3K0GIjwdbEmrGmSqobXV8fssPaMILQJm5KC2P4J6M8v1e3hzQEY0lnKZC/Uh6
         qthUSVK0sqy+Uum/USqVP/hqvDnwbCq/VbizMEn7oat0CfZrFvoYaAtw3wBXNVMw+Mow
         kKTE1WHYO18aM9EVUo6GDA3Aiq6Q2o/5sSRK9yjIKSk+iw3VFTdj3qnDWL45F3nsgggu
         jemS3G//ZPpZ9O7/1vDk2NxO8shyAv3A81HhyVRNrhUEkXI+rSd58chS7A22DgPuEUvw
         +1bw==
X-Gm-Message-State: AOJu0Yzi0qZLJIrPXJ+IH36rFyNCpe4340Oo0RzPyO17bbuvIrCIHKyN
	6Z25aeunodPSICjap/HFwvqjGZfP5usNu3QGuXBGXjMtAeTUdfYeZ/5gUM0GRl7U
X-Gm-Gg: AfdE7clL+aauTNG2h2SH4STp2NiRWzRMwJphMYdeRhgAO0maXFhrRvM8lp5TDZb3eNX
	zeplEJ4ps9BfK7WRcQtfYU2CBQg8jJq+Xp7aPYEw0+xlQIZfFA4CqGZ+Rx7Nfym8CdZYSXzGKNF
	cBdRsAOurL2sRnMcZGt6WfFJHpHq0iGDOQFTnbAatOMUrpl08boV75ePkc946eHJWFW0s++R96/
	C/hmAuY35X2RvwY0Xs0AI4tWM1uivO/bKOYE25yKCvNKuZ0he3DgtmNCN8XobFts3kzRYZ8GWKf
	DQxTXcL/1yEKlxc2TqaYU6qIIbNcCxEzuTRk5142Y9pmeXnKxHMhLp2cMDruwlzLvDIohsDgtkd
	vezvINgSBnT29l2frZjASThl3DOc1GsWfuF8wlzt1xhijPiKJ+F0/8SPaucDrSuD4IiPrpVJpVL
	kJPBK/Yk9EWBHguWNNzkLzEi4olBrFkI19HDWGshML+zLShbSfjT7d4/Ftrw==
X-Received: by 2002:a05:6a21:a346:b0:3bf:b08a:cded with SMTP id adf61e73a8af0-3bfed473edbmr7689956637.37.1783009210299;
        Thu, 02 Jul 2026 09:20:10 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c85b345sm16493826c88.10.2026.07.02.09.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 09:20:09 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH v3 0/3] xfs: fix NULL deref in log recovery reorder
Date: Thu,  2 Jul 2026 09:19:57 -0700
Message-ID: <20260702162000.3548359-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A crafted on-disk log can commit a transaction whose only item is a bare
transaction header (ri_cnt == 0, ri_buf == NULL).
xlog_recover_reorder_trans() then runs ITEM_TYPE() on it and dereferences
the NULL ri_buf, faulting the kernel at mount time.

v3:
 - patches 1 and 2: picked up the Reviewed-by tags, plus the
   s/encountered/encounter/ fix in patch 2 that Darrick noted
 - patch 3: reworked the changelog per Darrick and Christoph. The empty
   item comes from the len == sizeof(xfs_trans_header) path; the check can
   only run at commit time because a split header may still get regions
   from later ops; and the runtime commit path never emits this, so it is
   only reachable on a crafted log.  It came from an AI-assisted code
   audit of the parser.  Added Cc: stable # v4.3.

Tested on xfs-7.2-fixes with KASAN: the unpatched kernel oopses in
xlog_recover_reorder_trans; the patched kernel fails the mount with
-EFSCORRUPTED and no splat.

Weiming Shi (3):
  xfs: drop ASSERT(0) on unrecognized log item type
  xfs: splice unsorted log items back to the transaction after the loop
  xfs: fail recovery on a committed log item with no regions

 fs/xfs/xfs_log_recover.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

-- 
2.43.0

