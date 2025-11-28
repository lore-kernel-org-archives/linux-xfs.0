Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639802E540C
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318760; cv=none; b=e2IC+3WVmKxkvCUJBDGLAwb/2mVdkQ1nWwfqzd9m4dTEqCw/yFk4T6m/nUCz/lHh8AXmWe9XSVqZPxmYkEn6nQ9/STIg3I0fXf2qC+I5kW2fVlYECwYIFDNj9i3A2l2sjQBa6r34siHRAAs82XqGvqE5455lqhDvLU58BYgN4Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318760; c=relaxed/simple;
	bh=nXmk28ARgCcn+VciidQA11ELnwMOW79oTG8rwah+rkY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NtFjSKBH3Hh7n5D25VT5sJxm/fmN8BNHRgFl9xRR0JdXJtFG76hztCLS7QnlRPrn6as4VBV9rmFNMoZGHtvx8u2kJByU74T7NujciZ/ReYZIIWj/aHe8FZJc1mb7scBvVype3qHF7NawBEYVNaNJZUyoxU4PFUvkxtROir5mkvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WbSTKMTh; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WbSTKMTh"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7aad4823079so1395411b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318758; x=1764923558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NqrU9sAvwHlZJQNnImTr6s/wIfO8kcl//WUqMA/q7Cw=;
        b=WbSTKMThxlm/4xPvDvVSdATelz6yqeTOs+IvgJZWQDyb709cyNDzAvJaCuE/WHUfr8
         f1EXuQjx9KklKfe6IGC9GxwbPNiUhFRhtPViJU5n1/wswvK2qvWEKT15ugysJsOxNyOV
         0uqD9V9m04Yc9KgtA+FDS8Mvu/cCw1m4aFP6z6xpnXqkwCvAyLykLEave5F5K6paV0r5
         RH2U9jLSGQzsV3JqjgNJOo8b3jqGoP/3QTiNs6/CVY5odXzqsztNSE+auBZPLLZQWGtm
         b3SYZJ7/TkhkqFqTAMHpaoTfjrZBGaxDBSXuJVI40X+Q/WhUsDScuEMwNUyzoUgxeTWP
         AhLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318758; x=1764923558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NqrU9sAvwHlZJQNnImTr6s/wIfO8kcl//WUqMA/q7Cw=;
        b=ZXB6pS64r1I460BBW1dnxY22XOLQWktUJ8fWXcZJuuZshVRmPlGP4NeTykd7cMnr/h
         euHijnBNMDGf+IyemIgHbb07M7iEXQxLnc0HlBW5un7aPj9VMAm77mQ6AjKVkGETXs7B
         ClBcHE1UIkk8ipjfU+7TSJvEEW3g1kYSWEXpqJY8dyBNM1eTnELBLOc/b/dGeO3NW4C/
         WT6iTTgJWCC+RsCKOv0Yzr2XU4XuNAa8LfUnHJbBw+55MLupHqxIR4h1LRSOU36dEEK9
         ZBQa9FQ/IwwTUVedvMc1RqpUywY1XV2PtXIjuTM5FBK9hHVduZlz7ybMp6hzs1XIioYt
         dkyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUF8bRULjThq8iR1AyerwNshFTlmJMaRRJYaNBSa6DWcdf0M/Frst6OEQoi0XSScUX3tRQ66NvXNEE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWLRSKPeHDmO4WKTApzyjA7JojrS/KP17iw424M+QgpC58t7wN
	PgajqZ080w+8/bDbL5snXe50Ha4tjTeP79KVfaINvFwwZXTrG5gbv6mH
X-Gm-Gg: ASbGncs7P0/8beLnUxYZAO9nKFeI/9+2JPmwFBC8UzuD1YDNy5GwddPFVGphl1IxKXf
	TW33FHKiCgfa6hEiJ2r/VFq3jryUj6DX3Etk3UTEJgyHo4ON+0f088adJYeihXGOg+wQEQYUbzN
	DyrbX0rTEgHsIwzHt7fj0h0gWAfzFvGfQ3T9QZ/v+Sk6Ij4GewMGtzhD32nYj8WNHLNbDWQxbkK
	8rcC8Mozg0otKFaj7FkKGqvsRJCg6oJ6iXeFWmgSgJMdFoidil6BEbEciD+riScxpQ3HBCdT16g
	MqRVJSZz2A+1gaVNLJaaz+Lp5Yma77NmJ1iJoi3Us8kxMA6wYIF7S7iGP0foN4cGfBDzcAC2ben
	Iidi37YUB0mr3SsIgxlHBoaqnaTDW4X0IwaZj5qCAsd+3GY3126UyIICA9gBsirVbg6YID6aDaH
	R84qiEUTTJ9Z/hzqBFTQx2Ac6mrQ==
X-Google-Smtp-Source: AGHT+IHdakmTE4ccsFNQ1yLU+VXJurH34ar1nC0le8zm5bpThSihG4vDxPqEawqzf6sYQkBphfQIBA==
X-Received: by 2002:a05:7022:ebc2:b0:11a:e610:ee32 with SMTP id a92af1059eb24-11c9d85f282mr16086363c88.25.1764318757636;
        Fri, 28 Nov 2025 00:32:37 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:37 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	gruenba@redhat.com,
	ming.lei@redhat.com,
	siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v2 00/12] Fix bio chain related issues
Date: Fri, 28 Nov 2025 16:32:07 +0800
Message-Id: <20251128083219.2332407-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Hi all,

While investigating another problem [mentioned in v1], we identified
some buggy code in the bio chain handling logic. This series addresses
those issues and performs related code cleanup.

Patches 1-4 fix incorrect usage of bio_chain_endio().
Patches 5-12 clean up repetitive code patterns in bio chain handling.

v2:
- Added fix for bcache.
- Added BUG_ON() in bio_chain_endio().
- Enhanced commit messages for each patch

v1:
https://lore.kernel.org/all/20251121081748.1443507-1-zhangshida@kylinos.cn/


Shida Zhang (12):
  block: fix incorrect logic in bio_chain_endio
  block: prevent race condition on bi_status in __bio_chain_endio
  md: bcache: fix improper use of bi_end_io
  block: prohibit calls to bio_chain_endio
  block: export bio_chain_and_submit
  gfs2: Replace the repetitive bio chaining code patterns
  xfs: Replace the repetitive bio chaining code patterns
  block: Replace the repetitive bio chaining code patterns
  fs/ntfs3: Replace the repetitive bio chaining code patterns
  zram: Replace the repetitive bio chaining code patterns
  nvdimm: Replace the repetitive bio chaining code patterns
  nvmet: use bio_chain_and_submit to simplify bio chaining

 block/bio.c                       | 15 ++++++++++++---
 drivers/block/zram/zram_drv.c     |  3 +--
 drivers/md/bcache/request.c       |  6 +++---
 drivers/nvdimm/nd_virtio.c        |  3 +--
 drivers/nvme/target/io-cmd-bdev.c |  3 +--
 fs/gfs2/lops.c                    |  3 +--
 fs/ntfs3/fsntfs.c                 | 12 ++----------
 fs/squashfs/block.c               |  3 +--
 fs/xfs/xfs_bio_io.c               |  3 +--
 fs/xfs/xfs_buf.c                  |  3 +--
 fs/xfs/xfs_log.c                  |  3 +--
 11 files changed, 25 insertions(+), 32 deletions(-)

-- 
2.34.1

