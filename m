Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319C03C1083
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 09:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142370; cv=none; b=MhMFsel22rUAwe9oxsgFLj9CqmqsDfzUq1OBoh++wBuOFRpAWVVCGOo5E0eqIC3MgnOrxrNb0cFZeZRpU0E4UNad64AmfLxgWC2UNBv5SBtbPQez8+vOgwcXZVwD7k6WUGvj97425BAh5TiLACFfDOF2iNuZppuSIgAIe2rY8KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142370; c=relaxed/simple;
	bh=aTMUcqZURy19NxFvWbxUVqjPoyE/i6xWtuoBHgM6v5c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gFjyZ/shk7UC/YyCnT+wMVLvvDcCZ01g6B5Km/WpuIbvktD9JQJ90RV6sWh0Zten+mhnxb4zRoASF4yE7hle/EQo5wCJFpVbpb9Jf6xaLkfW+3RxbPGC11DgMuguGC+bSG6ECbNGEy4iGlXgOhj5a2ziUzFxubvzeqOIAwi+SFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FGFgvUJA; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FGFgvUJA"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-16079d54c17so568236c88.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 02:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792142368; x=1792747168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xKIcc9y2gPYr67ZGxXeokwj+kkWiL3V5XBf1VhWPUVU=;
        b=FGFgvUJAv8s2A6YxIjHQoZU7x5wvf7kQ4xu+ZoTgCQWRbGCz1Xg9tKW93AcvOzwgAi
         8LRnhT3op7JDqFFFmQhJ4CHy3tDzDHQq/eYpE7xf+7T08hE5qGPUvKu7A1V6tKUEqMrW
         5rRbMspLxGfMii0OaJvlAtjKTnkXnh1k4qhjo0IfhzSLw28jh7uuFmG3QCeAQQKn7k4H
         TwN4am2PyPHq0iS6sSwbdmsEjGQi+vItStQRrGaQDavCDjQJoP6a/OnKT0QxonRz6DUH
         0A8hXHgezZb7NvG+bSP8Sjp7wAwRdQIxI2lWdw9ngKCyw7QFCCx01xdja1WWBgMAFpkO
         3NcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792142368; x=1792747168;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xKIcc9y2gPYr67ZGxXeokwj+kkWiL3V5XBf1VhWPUVU=;
        b=U7sLk3vbuFuzFWvEnJajgDCSI+ueacaD/2WpGHMW3XcxayMHozZ3lQzEiUCcTTqk9G
         LlQokkllsW3+rvTpSxAMvTzT6CbE10rU2L1M/pPr6HO/3R6y+/kCeyz8K8NXllpIACGj
         EFwlJmldDjmFFUTzbvVBTxqlFyZyaZQFUOZbbDQxAADAc4OfxF8lwmtCKP6verrL4rdB
         BNObomyoHOy9dulVS5e8DRFMMQfcvcuN0Efh20G90jtAmCG3cFHQGaML6H8TGOgIPMFk
         yfjwtYj9gQzBo+UwVUgPekDAdtt5FaaCWULWKZSq9Mvy/NwQv6Nb/NTwM0KcZlB23mkL
         U0+g==
X-Forwarded-Encrypted: i=1; AKwUvBxLGYGOOV+B/VRmjy3ZqB2ClQo5ufkbErNfRH3kcNcb9icZU3eXit70mCjIowAG/cl6kYupJEpdXJE=@vger.kernel.org
X-Gm-Message-State: AFq9FYKDsMFH+inn4t6PD1sJLsYxRZOf+7ON57GfwmJcG1mB5Rfso1oY
	cGv/ieKkXTPMRrU3zg/rPwIzO/CEj+k3fawZvGYx7fYCzXYI71vhnEY=
X-Gm-Gg: AYBFou0iHbgXZIhD0Tsv4L3DY2Oh3uRMnv3QNHW6V9X78Li9uM28LCzK4+GRY8H2N00
	Ht6oFeClIXHtqsy32gFDw6UoZNdHgOGuSgkl8REL1IFAmIfK1x6zlkO8NWj8qeHHsMMF1UKn19j
	4sZvkC8FxPX+8W9qEY7Ab8LvtxIBPtVfA9/AjqcMoHtAD2BKqBP05QccSmSmx/iC95N0U2VPGG3
	kvJNvsMKi/4gtl4e0tdEi1Vewcdr5UtI8RAjKf7MSDZLFHjlN1xCsy38CWiqZUPF4igOuHwSQq9
	RjeGl1bwqI3TkVEXCyQpihZJrVRnny6amwtT5l9J2pRU9oa39ja0MhUN2J+wQ7pDn4rLtPKY6EK
	8JJRUeW8RJMNji7WN7pMiPel6fsgpOTpXsg0w0Gl8djpgps/RHphWWeda+vnvG2nN2AS6cxsqk0
	uhA+x7YNGrGEOoMAZlSg7PJwefbhHQRRgJfhRxS6XTqzcrFAf5iIU03ibY9OyUbTdz0Toqqn+Fn
	ANMbo7OBDN4UyK19NDYgbP/1Al+6KFK3g18Ycr41YHhfqOyS/Bt0PvOmCd55xc=
X-Received: by 2002:a05:701b:4544:10b0:144:c12b:dfc6 with SMTP id a92af1059eb24-16a60ce7b43mr28678298c88.44.1792142368095;
        Fri, 16 Oct 2026 02:19:28 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:e55a:7bfc:fc3a:e718:89f6])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36082a7b33bsm9840943eec.24.2026.10.16.02.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 02:19:27 -0700 (PDT)
From: Anuj Gupta <anuj1072538@gmail.com>
To: asml.silence@gmail.com,
	hch@lst.de,
	djwong@kernel.org,
	cem@kernel.org,
	brauner@kernel.org,
	axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com,
	anuj20.g@samsung.com,
	nj.shetty@samsung.com
Subject: [RFC 0/4] fs: support dma-buf backed direct I/O
Date: Fri, 16 Oct 2026 14:49:10 +0530
Message-ID: <20261016091919.971295-1-anuj1072538@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series lets an application register a dma-buf against a file,
so reads and writes go directly to the device as dma-buf backed
bios with no per-command DMA mapping.

This series builds on Pavel Begunkov's dma-buf block support v11,
https://lore.kernel.org/all/cover.1791975048.git.asml.silence@gmail.com/
which is queued in Jens Axboe's tree:
https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=for-7.4/io_uring-dmabuf

A separate kernel tree is present here:
https://github.com/anuj7781/linux-kernel/tree/anuj/fs-dmabuf-rfc-v11-desc-v2

Nitesh Shetty (4):
  block: factor out bdev_init_dma_buf_io_ctx()
  block: refuse a dma-buf bio for a disk the buffer was not registered
    on
  iomap: add dma-buf direct I/O guards and registration helper
  xfs: support dma-buf registered buffers for direct I/O

 block/bio.c                | 15 +++++++++++++++
 block/fops.c               | 19 +++++++++++++++----
 fs/iomap/direct-io.c       | 31 ++++++++++++++++++++++++++++++-
 fs/xfs/xfs_file.c          | 30 ++++++++++++++++++++++++++++++
 include/linux/blkdev.h     |  3 +++
 include/linux/dma-buf-io.h |  2 ++
 include/linux/iomap.h      |  3 +++
 7 files changed, 98 insertions(+), 5 deletions(-)

-- 
2.43.0

