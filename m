Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83184D9F78
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 17:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791220942; cv=none; b=m6yGJ7eD37ybs88yk6vnBUJ7RQdXty/wLiK8oW13hJ1DiMH9f6/C/w1/YbVcFjWcqst004JrKpXQHXRW08QSd1FtVOezHC2an7b0ijNk6cDNk8IbM2dk8+T1XF40FAJHWvE9KlsHuiMcGO012SmAqflTNpZNleMq4TIQSanEK1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791220942; c=relaxed/simple;
	bh=HPQFx2is0ieEJVe20uGM4PhbiKW1+p2gDf94Lw0VAsA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PNhzCHXfsmUtHYvvZTZ6Z2uYBOzOhu4j1epor/xboQc5nUh62mKIFNeBQSmAq3RUBMo+s6in7kbxItxpdyC8kUDP7XCmJFs9kbGsag5ejKqKYmRQV/WbYybTqgWK0dZbWE20qTiZ1rjvvwN7+X+ZuFHgYf3pjqyQRvWZwmAgRn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NjqGYALq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TATaom2Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NjqGYALq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TATaom2Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791220939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=G/Fp1l+4O2G/kdbq36fNWAo+kb/ppuNf3q/OqZtqd4s=;
	b=NjqGYALqyOcHGL0hd8Im+Fp6wGy5yhkLPR18htQgulFddp5Obm7KS2zgU5NiR4wDBQja0e
	zv8cy6GyZIKulVTpSPtNch/PHni3s3BJFH0K0Ju1iCKuuX0Ys/kG4/By1ZqHOCe57f8pY/
	vMLIKFHlvtkDBpxfbyonrPt4xs+S4iM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-2vRFh9ZAMaCFAJL0l_U2lQ-1; Mon, 05 Oct 2026 13:22:15 -0400
X-MC-Unique: 2vRFh9ZAMaCFAJL0l_U2lQ-1
X-Mimecast-MFC-AGG-ID: 2vRFh9ZAMaCFAJL0l_U2lQ_1791220935
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a027f2e364so15909635e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 05 Oct 2026 10:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791220934; x=1791825734; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G/Fp1l+4O2G/kdbq36fNWAo+kb/ppuNf3q/OqZtqd4s=;
        b=TATaom2Q/y8VuQC6aMzvpGuRmZS4gdl1yMy17N7pWgkdDg1Twdea0pER7H4vtZRX/m
         NVNKz/Cg7v6KjYyoMSlenD2iy6rVXbKnArKeeRsOZfkLfR2TNUZiwo9+rwujLMljMWZr
         ey3zI96AkO7OB8xCuPlSG3ZftMkSAYfXtALbN/Ro0Wr/HDisZMnWsKdcyxvjGcdkJzx9
         c9v2d8Kz7/cywB948tATBLUUflBTk3YzpjkO0bG0zcYPpvlc2/YwCClQe0+m3HXBTnho
         yXjtbTvKVhCMFjfM2kMtRzhdFLnsBalV748cXlkByvvuWaNRQVuiHWcyFJze9L7E6izK
         k8QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791220934; x=1791825734;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G/Fp1l+4O2G/kdbq36fNWAo+kb/ppuNf3q/OqZtqd4s=;
        b=aGzupeJ3Lg1d9yzh4GbHH27OCMeRzyiO0+XLbVRR+vNjuFV0OAWnGGABHebGNU/8bv
         6YxKQDrr81WrvrsIGLtgWcYBjvoIf43brHQgnBv4fe+gOV8LQNnRk0FIgoMYpYqQmbjo
         okBEA6Pm4nBvOFapRop8QpRs2HZYlOKy4PY9VAK7lRQtQZiVelZ4/MsAbe/N7zJVWfYN
         VLYAvYz5E3e8p6t7p0q/bGr/FpE+qlM16ZlOedZkV/6lioYnix/J759qHdRXLupD2KaJ
         9X+x0wSjROIiAn9S0Tu54iTh0XU/xrI7OCOpXPpFquVqI28FGXABDrPlZFq2dgYNRF1w
         4U/Q==
X-Gm-Message-State: AFuF++ny8Xdr/syNABxfTAjbNOlHK1E2d3CTOHSx9SH61FsGUjoqLx5J
	NmOkyXgB12NlIFat5t8hSKVd31RdptmnNBJ8JzmmdGUEykXLvHcwPuSN/0ldAojpJcmKNRK1Wt6
	z3wyC8vEOvRwIBAhdZlxdZeV3AEUdxaXom8t4y0XRlirqjIaPeu4DdKzkWtDi/ZbgNik2hn9m4y
	1+QsvuLKHqbTL7kSXtNTLP/CUdnR4KpItrFgp0CYupgXCP
X-Gm-Gg: AYBFou36R71kbVprp2cjCgjio8qnN0PW74hesRWOgmi3taDCWCt6sRrvAioEAYVS5hq
	3Zuf8LYbicrcLo4fyvAZqIPk9zMYP6LHUhJpEfzaLE6a0lccLI4W7ktQmjZjHqBf36DDKKFl7tf
	iA8TLuuCyTNBAPHa/jUSFQK21hCmzFaa29dt1eLHhmUpSU8McJPMkzLYmvvyMCYU6HRWaura7Zp
	yH/0QElFJjfY5TiJ+jY6Oxgp6/H3H4KtdLc0KBzTd7CoCd+oTQkoiz70AH+g6aRSnfi+2XtG8wd
	LIOWNQ+QSt1kfUORlPKmlx8+93ZQUj49akxIZZM6f6cwgqdYO5Fi0ShoZ81OtbJ+o04xMjotkXK
	YLz0yQZ8f5Jq3z0OjL15UBCdIB/M6pfBzkA==
X-Received: by 2002:a05:600c:4fc1:b0:49f:f099:6fb1 with SMTP id 5b1f17b1804b1-4a02756f148mr192739875e9.15.1791220934563;
        Mon, 05 Oct 2026 10:22:14 -0700 (PDT)
X-Received: by 2002:a05:600c:4fc1:b0:49f:f099:6fb1 with SMTP id 5b1f17b1804b1-4a02756f148mr192739335e9.15.1791220933961;
        Mon, 05 Oct 2026 10:22:13 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a178c33091sm5790085e9.4.2026.10.05.10.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 10:22:13 -0700 (PDT)
Date: Mon, 5 Oct 2026 19:22:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: 1149571@bugs.debian.org, aalbersh@kernel.org, biebl@debian.org, 
	djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, sandeen@redhat.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to caca7f14b449
Message-ID: <asPcwLl90eFEnfB6@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

caca7f14b449c94583a263e5d4e51354e86529f8

New commits:

Christoph Hellwig (10):
      [8a4a368b497d] libxfs: refactor the reinit case in libxfs_buftarg_init
      [08c91516ffa7] libxfs: split error injection option parsing out of libxfs_buftarg_init
      [8f9506e2dafc] libxfs: remove buftarg member aliases
      [35e136a42548] libxfs: unify buftarg handling with the kernel
      [55ec0ef299d5] libxfs: make the size check in rtmount_init internal RT device aware
      [c189d771732e] libxfs: don't clear ->dev in libxfs_device_close
      [45c2b2ae6968] libxfs: fix buftarg initialization for the RT device
      [d69aadab419e] libxfs: rename bt_bdev*
      [5f82a09e37bc] libfrog: improve ramdisk handling in platform_flush_device
      [e58810a53900] xfs_db: remove a double-whitespace in rdump_regfile_data

Darrick J. Wong (2):
      [d28edf8b3722] xfs_healer: correct xfd_ API usage
      [fde1eeed253a] xfs_healer: fail earlier on non-xfs filesystems

Eric Sandeen (3):
      [196c46c1bd31] libxfs: change cache_node_allocate function signature
      [92d45f837671] libxfs: Return -ENOMEM on actual cache node allocation failures
      [caca7f14b449] libxfs: do not allow cache growth to overflow

Code Diffstat:

 copy/xfs_copy.c          |   2 +-
 db/io.c                  |   4 +-
 db/metadump.c            |   7 +--
 db/rdump.c               |   2 +-
 healer/xfs_healer.c      |  14 ++++-
 libfrog/linux.c          |  13 ++--
 libfrog/platform.h       |   2 +-
 libxfs/buf_mem.c         |   4 +-
 libxfs/cache.c           |  54 ++++++++++++----
 libxfs/init.c            | 161 +++++++++++++++++++++++++----------------------
 libxfs/libxfs_io.h       |   4 +-
 libxfs/rdwr.c            |  50 ++++++++-------
 libxfs/stubs/xfs_mount.h |   3 -
 libxfs/trans.c           |   4 +-
 libxfs/util.c            |   2 +-
 mkfs/xfs_mkfs.c          |  10 ++-
 repair/attr_repair.c     |  11 ++--
 repair/da_util.c         |   2 +-
 repair/dino_chunks.c     |   8 +--
 repair/dinode.c          |   8 +--
 repair/phase3.c          |   2 +-
 repair/phase5.c          |   6 +-
 repair/prefetch.c        |   6 +-
 repair/quotacheck.c      |   2 +-
 repair/rt.c              |   2 +-
 repair/scan.c            |  16 ++---
 repair/zoned.c           |   2 +-
 27 files changed, 228 insertions(+), 173 deletions(-)

-- 
- Andrey

