Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EE72D9ED9
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 02:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762481221; cv=none; b=N++IjeeFFzEayPmg2UMNMNjjwIxOlIyqPPL9cmillYRF/wVFtAz4rfq0/2KgZ8FoA4rT6xK8lKUkfq48Pc7o3aNVAg0Y7ePhIp2UMYlLBlGvQeCLgIGWFTWHMp7/8p7uQV41ywTmcQ9kSS5Wr8MXKex6jf/dzuNe4th06lTwCzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762481221; c=relaxed/simple;
	bh=5/T0SIm0UdNO/IdzRZZKEiu//zm3DFK1QFan+BlZfc8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lD+SxPMoMoY+Qpr2r3FKkzhy6jaFeyu99c/fqAMP67Hn/n3fqRwBLqtQxEjszud5G+1LIWko5626aC8r/h2vpC9Sm1I2Hl0Uf0Wa6047y/PHSD1yjEgQP2TIA4tx23NxjDF2hYUsYUwHRz0Cqz23boO0VzyhweYGu9jTMtgUHJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=OYp4ubuT; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="OYp4ubuT"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-29586626fbeso2422045ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 06 Nov 2025 18:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1762481219; x=1763086019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oWHtEzv8Rq5cRO8AqC7Ez/zeQln1yPOIQJdYebnSBzQ=;
        b=OYp4ubuT3gFc60iNpOyqfZR5wKv5fjTWfjquldjj3yOmqwOqHhb+gL5tBGy1h6g19a
         mE9JKBplmSkVKkEn3gsbnssVeL3P2OnVme1LfIGDUWl5uwketcnYSSPYd40ovl+AAtli
         qK20UzYrZWuzXHfZvM8pZD6J1OS8frr4sUeuoh+AKkoH53mA0fbtfwSUkKSjloevMJ8H
         BKbPC7Ggm5NBb6iCHtS/VLhpM2bxPrrfQKV92pW54zrGq7nwYO5NHJQ/ZCweBAVuV4JQ
         X8QjrT3Jou7mvj0bxG/giBOc833ri2zbOH18PTI/qb3Ld1KMUxR3ET8eZjBe147luRUB
         lIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762481219; x=1763086019;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWHtEzv8Rq5cRO8AqC7Ez/zeQln1yPOIQJdYebnSBzQ=;
        b=N/zjjY6kPTTr80GgkLZGy1P/TkModHFQBnONFDFBHs/y3XCV/fillP3BULKsepGtnX
         SVgrkkCqfG3jNVQlshkqDwdxb38HhiTUD+a+mGIRvb1jCfw129KPDCUF4wIY9MPg119F
         YM3gwuPAiC6mMowSxpd3ID04UXcNkL08ygkd2/uJdCcbpi89MWfPd9vxNO58W7HDkXku
         hH3ghRHrRoBcj8wJZ4d0Y2GduF56gpVrOhNUrqm3Sdd4srYC/Aw3WKgP804uDV2nsBlU
         L6sT2a644Hi74xhMOwLBErAsCnGSjliAk6MyxqibryO0VwLpWFVneZpSnVMffKg0kK+W
         /yiw==
X-Forwarded-Encrypted: i=1; AJvYcCUtlIpGClmHshQfSjePm0nbXO9LSZ5JHAnyUlZ0HXCQSrNPHy+kx953rgD37DryDrR4VJPEdZQXV6k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyalJYKSeI+67E7M/CgaQRyzyryq3D9O/qo70KmeOVqYJhLSLKF
	z2K8wOqYvwqKkJ8kfN7joz5C5OFFU3shD0wAgVP308tn0j4mupRN3s6SqulZrGg5BJs=
X-Gm-Gg: ASbGncvb/1w8r1Jdr1e4T3Q7VZ1wDiITORQV009KILD5w9Wfyspgxj4tpIhxyu+VGwY
	Y42oNcHFr1xLWhsy1t0jujYioUXM57r/xBVNAgXPDyShNGeIQ1cRprHTS7uydRJB5YHgVIuw9ov
	+IIZ1hCTxU4vjxnsFRmyWuLMUsCIFEg9Q+WM6+oFCdprND2/Buxe0ETU3K2qBby3vtXcM6Cve8i
	mO4jJK4tJiajw/E+9bjtAym0eiMmmOdBLi7fZ8fQ6z0RGmhbHVo3PKJYshCvWN/pkrTkhIACoEN
	l+vRl0Y2aEGgmphJpLMxQ5LMbtcOxXz0kmRaGUOvZHv9ayOg/r9zb4bI6rTQePVVoExOP9EQ+Uc
	oWQRxFS/T/ZlKL3rgovsHIPjICY5F+sYAZ6vet77u0GFBoJcSYCaI+1W02NKcEHbsK+7A46WDYO
	ZXHFcKSOcag2ARowT2
X-Google-Smtp-Source: AGHT+IEQ1r7AsblEW15F6NrWnCgQgZkngBPtkNTOIEI5NyInjWIPCo6YMVNtFNrYGdMqGrYdOjvVJw==
X-Received: by 2002:a17:903:1ca:b0:296:1beb:6776 with SMTP id d9443c01a7336-297c04aa6abmr21929025ad.58.1762481218563;
        Thu, 06 Nov 2025 18:06:58 -0800 (PST)
Received: from localhost.localdomain ([2408:8740:c4ff:1::4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096825esm43129885ad.3.2025.11.06.18.06.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Nov 2025 18:06:58 -0800 (PST)
From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	asml.silence@gmail.com,
	willy@infradead.org,
	djwong@kernel.org,
	hch@infradead.org,
	ritesh.list@gmail.com,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org,
	ming.lei@redhat.com,
	linux-nvme@lists.infradead.org
Cc: Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH v2 0/2] block: enable per-cpu bio cache by default
Date: Fri,  7 Nov 2025 10:05:55 +0800
Message-Id: <20251107020557.10097-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For now, per-cpu bio cache was only used in the io_uring + raw block
device, filesystem also can use this to improve performance.
After discussion in [1], we think it's better to enable per-cpu bio cache
by default.

v2:
enable per-cpu bio cache for passthru IO by default.

v1:
https://lore.kernel.org/linux-fsdevel/CAPFOzZs5mJ9Ts+TYkhioO8aAYfzevcgw7O3hjexFNb_tM+kEZA@mail.gmail.com/

[1] https://lore.kernel.org/linux-fsdevel/c4bc7c33-b1e1-47d1-9d22-b189c86c6c7d@gmail.com/



Fengnan Chang (2):
  block: use bio_alloc_bioset for passthru IO by default
  block: enable per-cpu bio cache by default

 block/bio.c               | 26 ++++++------
 block/blk-map.c           | 89 +++++++++++++++------------------------
 block/fops.c              |  4 --
 drivers/nvme/host/ioctl.c |  2 +-
 include/linux/fs.h        |  3 --
 io_uring/rw.c             |  1 -
 6 files changed, 48 insertions(+), 77 deletions(-)


base-commit: 4a0c9b3391999818e2c5b93719699b255be1f682
-- 
2.39.5 (Apple Git-154)

