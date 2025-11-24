Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1608E272E42
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 23:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028104; cv=none; b=OzgfLf+IlF4qwuDqZM9SUsgKaaCTiJgvx1IPF2WIZLTM03dbu8awL7htDvkF7mRX7U2KgrbMakIt76ARKP4so2XxZSUCp3lWUeWv0AaZkiKHksRRXVaLO35S6qLyTqZ1xxlLCmnNNLWNOkh/4IciCilKmkFUvkbBFMz30t0zwb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028104; c=relaxed/simple;
	bh=0HZiUPVVqiDv8ZEl67pEJba49nGpbGLpzJLHrHVWkJs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qXRMQHLs4WcfbIoXfprqFz01WcT9CQc+CBInUd3MUXey5v5IRk8pn2AQ/bguCI9A4fQM8niaQ/Wl10tdM8eVKzHhS3hD5exSMQ59Dky4kqEk9SP15ojP2yDyqxwHSSgo3x9G5ZUV1KQ4x/0d4KvKsWDWe+p45KF97SAbZwD0klo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bPL86y/i; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPL86y/i"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b852bb31d9so5645399b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 15:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028101; x=1764632901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L8zwVcuAssRnEQZ8e7ewIMIsPfvOXMAA4RWGmHyZ+Rs=;
        b=bPL86y/iBZjOidhBAl6VEV+QifNIHQrW4C3Ep/nwnKCbwUYO59IpTBFsDTtTEXt8yx
         FJpoB8nln2MJ0VffyNsLuxsbAfCrlFlqVQdFMMBONxF0RNtxGWy73OnTLTVzfvdxyT/l
         1a5MQ5SILc0M6AkSTMRTtkdDAAw9Lhar88tFes+HRhPfsfPrH0YQpWIRbMdqpN8JxpT5
         pn89jOdNkpwNkPjwlZ7wuYN9CfRt97F+rlWz4bReRFYlh2UbtSsd3m2VD8CYzxEdUPwJ
         1hrdyU71mzSM4j22YMWsrdkPTHruHM0KynglrtZuDsfqrhVEhrIXc/umLfuVoTM6pkLZ
         4c1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028101; x=1764632901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L8zwVcuAssRnEQZ8e7ewIMIsPfvOXMAA4RWGmHyZ+Rs=;
        b=vvhGfRHNhD4LOk4YukzW85BJbJCm1YieE5bXUHhICTaQT0ydV7/DNK9uaz/m6y3ZXD
         hPKcJGXwJwjgoNKEYvyrPVitr5r75sTudv4X3LZVEryyLgd3Qz1QbC/33q8V36xRa1BZ
         WWrklfpQNmvouMdAIqdoOf0eMtOFvlf12DHmrVuLLu3JTUz8HoprNYn6Fk+lbIIdQJK5
         A6XqkumsqHA14b4k4EnNt9z2es2XmWupFhFBC8udM1X0aXa19da/Xd7i5aWXZ9N3w68M
         0IVD09OGY692E7ZDK5O7GyLILVPog9jWnFB/J6ZZsO64avK3yrUy3qt8atn7FJ/COZ94
         Oiqw==
X-Forwarded-Encrypted: i=1; AJvYcCUGkJkcrRXn3p72PvgwFZb77c4De4KnNdKLuI4Lx3+KiwP9qo/+rJki/Xdu0ezuMQPrHBpq3O4AsiA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrJpz3faMlfbasledBvC1cG442S6x3tuJM0Uk3GNCPboFCiNAA
	fROqwyJZ7Z+8NN5QfM7gBFoF2hIsTZReuR+U40ZIDaQ/nY5zRaGtzClX
X-Gm-Gg: ASbGncsJ02G10sY5o283eTG/oYcsOkJme3iO9fExJqadfCgHioVOUlXSkNYTVR+zukf
	iiKdPb9CMcHDPMDZohSGVtFXkST0PUxMUdMWzfjmnTgvcA2cE0kVu7tz/f04h8UuIIqFJeKas+L
	IGt6/UHidUZGtoDCmy9prSadYiDe5MZ7y3leTyEWl8AoeYmN80LOAjhMw3Nos6vhTHJG9uoLVTi
	62SxFDTKq26yivVJpFITWlLXzrlBHLkJduje93kFBpcCcf+NPmKCsU/7D4TrernGXS6+doSHb3D
	3wsmrexRQeF7gdJvUdpxTW5UFRYvBbz8Mn0wkxuipDo8mRBgBMzONeXgMkq9+8aA0NojybXGpXv
	48MXSUQO13KeKXSynqSm2Q/e7Wg9W5nRRF90SDbtyAANUvWdszv1NXz+vw3JKnoPRjEljxtRyd4
	oiXyRqOBGoQnrLASnRN1so29gZbxX4Bl85b2WSROG8wrku8U8=
X-Google-Smtp-Source: AGHT+IEWVgvs7HfQh1Jftv0/sg1EMetPp1p1pbe1p7lp0IBRgw/xws/S7S4QHSHoK5/x2kKFyy9WJQ==
X-Received: by 2002:a05:7022:1093:b0:11a:2ec0:dd02 with SMTP id a92af1059eb24-11c9d85fed4mr7996088c88.33.1764028101157;
        Mon, 24 Nov 2025 15:48:21 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93db556csm74670928c88.1.2025.11.24.15.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:20 -0800 (PST)
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
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: [PATCH V3 0/6] block: ignore __blkdev_issue_discard() ret value
Date: Mon, 24 Nov 2025 15:48:00 -0800
Message-Id: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

__blkdev_issue_discard() only returns value 0, that makes post call
error checking code dead. This patch series revmoes this dead code at
all the call sites and adjust the callers.

Please note that it doesn't change the return type of the function from
int to void in this series, it will be done once this series gets merged
smoothly.

For f2fs and xfs I've ran following test which includes discard
they produce same PASS and FAIL output with and without this patch
series.

  for-next (lblk-fnext)    discard-ret (lblk-discard)
  ---------------------    --------------------------
  FAIL f2fs/008            FAIL f2fs/008
  FAIL f2fs/014            FAIL f2fs/014
  FAIL f2fs/015            FAIL f2fs/015
  PASS f2fs/017            PASS f2fs/017
  PASS xfs/016             PASS xfs/016
  PASS xfs/288             PASS xfs/288
  PASS xfs/432             PASS xfs/432
  PASS xfs/449             PASS xfs/449
  PASS xfs/513             PASS xfs/513
  PASS generic/033         PASS generic/033
  PASS generic/038         PASS generic/038
  PASS generic/098         PASS generic/098
  PASS generic/224         PASS generic/224
  PASS generic/251         PASS generic/251
  PASS generic/260         PASS generic/260
  PASS generic/288         PASS generic/288
  PASS generic/351         PASS generic/351
  PASS generic/455         PASS generic/455
  PASS generic/457         PASS generic/457
  PASS generic/470         PASS generic/470
  PASS generic/482         PASS generic/482
  PASS generic/500         PASS generic/500
  PASS generic/537         PASS generic/537
  PASS generic/608         PASS generic/608
  PASS generic/619         PASS generic/619
  PASS generic/746         PASS generic/746
  PASS generic/757         PASS generic/757
 
For NVMeOF taret I've testing blktest with nvme_trtype=nvme_loop
and all the testcases are passing.

 -ck

Changes from V2:-

1. Add Reviewed-by: tags.
2. Split patch 2 into two separate patches dm and md.
3. Condense __blkdev_issue_discard() parameters for in nvmet patch.
4. Condense __blkdev_issue_discard() parameters for in f2fs patch.

Chaitanya Kulkarni (6):
  block: ignore discard return value
  md: ignore discard return value
  dm: ignore discard return value
  nvmet: ignore discard return value
  f2fs: ignore discard return value
  xfs: ignore discard return value

 block/blk-lib.c                   |  6 +++---
 drivers/md/dm-thin.c              | 12 +++++-------
 drivers/md/md.c                   |  4 ++--
 drivers/nvme/target/io-cmd-bdev.c | 28 +++++++---------------------
 fs/f2fs/segment.c                 | 10 +++-------
 fs/xfs/xfs_discard.c              | 27 +++++----------------------
 fs/xfs/xfs_discard.h              |  2 +-
 7 files changed, 26 insertions(+), 63 deletions(-)

-- 
2.40.0

