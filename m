Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4F21A275
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864647; cv=none; b=anE1u0eBS7fFfn255VNUGMTFUOmDo5hzAvZsZx4hZ501Rx4S9m2BdkS2l+2A/efeo7kNS+o1xk4j46cQPnkp/OZb0O4kU6on9ri8RavzNH0gFv1lTFZaeaSP3lZO+bJ+BHQzhh+FBGWa3g1ZO3eqKJOWk6VsAWblgFjoFfU78UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864647; c=relaxed/simple;
	bh=wZJShG1258d75ZNnBq3KB1Y4038h6PIjQCDHOhPR1/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ORaVLoRV0+dFmCENaNhtnISUCKqrjxkKb6fJYePym6wo05+g3u1tD2IHeWDrydijbBfzkxgTtUSfU7OmZbGKTtlu0oollgYGmend7yrYC1pqPTnuhE1sA3af7EBX+MgXqnlbA5BospKAlg302FNsoz0kwEti2rx3XuYj5+3MZi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcrGPN/z; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcrGPN/z"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6a183eb9689so50965eaf.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864644; x=1783469444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=00v5X3baWfSngkK0txDtqxtj/nkRDu2X3zVjI+7oWpM=;
        b=bcrGPN/zG0Q2lsag7ZZAOVTQSEZ+DKMdY5pVjYodtx5OZ59b/GDfwd+AB4jBfMj+jh
         TXVSB+2GXBErPrRO6d/TtOjBE3YA3mxJsBZSyM1J/JcLgN2SD+J5o8Cg4T3V7ihPUztT
         PBAYHRz38HmWrQZl7C1QEsJ0FFqts2u2KIKI2Q/jWo0Mne8rAn8yYrReUxUojEdwkltl
         RD6r8z446Jj2CpvsUb1kS42ihAhW0TnRlrzJNyoXYGHX1Z7695wMC9alt/c5AAUNNHMD
         ysxX248L7tFP/RUjR9GCBS+Y0oj5GJTAKrNem4hORpjMZw3yXf4ZraMt4QMbL9+K+sd2
         et0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864644; x=1783469444;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=00v5X3baWfSngkK0txDtqxtj/nkRDu2X3zVjI+7oWpM=;
        b=QA0loNUpefe/u4kwR4sKcYxOYblQZDDRL2WpWNAvl1RVO3Ed2bgYKFqmGDTuS2YVj9
         EZXseYmIDObdZxO4JOHm18hpBbi4i+Cl0KbwwXKvUAZm3XwM4L6VS/WPUnVOicvGpod4
         tZ3ujkKvP+WomxWlh8tqW+hM94EEOKwfU0vVgbs+cdxHISoWw1xpXzT5DXYpdGW6jxHJ
         bHZa7MFLFAh9jzQsvAcWR0lDkDbjdhDT4Zki7YuCmytALa1mPzbV8A2Z7DnqSGBupUqd
         OWW7IsDqGZ3lQWI1ZGpzW5lpxvwqXEbY5AuupavjhaygIIYzae82OYEJdygaavdOr4mn
         gnIw==
X-Forwarded-Encrypted: i=1; AFNElJ97RwbKBbmG/lBbBGN2/sX+af/JQKN+IKCUrscpj6q85B4/YSv/PQ7IEXgPPcLeqkONoiNZ9avoa+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqePNN9x9Qato3RLjqaYFBKpGqUBY+onv6c05uAuEBM44JzNMj
	drdscpOhQpYb/+fUFmPozPrneOBwDoYWKVUayUi6hqgXC21NXYWluWRLnRmX4A==
X-Gm-Gg: AfdE7cmO6gWeMkFyoLeuMWOC8mOd1QLbNO2/7+dMlmJ0+N8DHbUweZR78BWUgQe9yuW
	l6nXG2f+y0haBaEJQpY9gPd4fAO4Ht9AY+P6esCrHe+4Adr35N/iuN0NKDVRxUKyCqsNrcWD88N
	Sok3JtmssKxGY4XcumGkwBS6wI++zlCU00C95NiLwJsHX14Dhu00hRxhY+oPu5XKwBhCO6cGtdL
	p4NaWCfJWwLqYX8BcTDkB0xNEcSLN2kRYk272zKKUr4vAmr8N2ykawxT/UPCBFM6GsGWqOOdRuZ
	c+dZH78Q7srsvwvb55G0+x7w/UMzkfQpkHhQgPFkwZRjyUA4IQ/rj7dam9OyDf+LkW9T0wqnjAt
	M1Ezq4C5QttuY5pVjm63AacLZVIJAlLx1xxNm49v03roYo31eHo/g0VkmpsgN9UmLsJTb7rTSro
	BDF0J6sw0UGRMcWy94ewqdJ+rsazZNPcS4ldQw3ZWs2MUoUrQQrd5wjg6JetfqjvjK
X-Received: by 2002:a05:6820:2089:b0:6a1:7953:38fd with SMTP id 006d021491bc7-6a18926014bmr4246123eaf.59.1782864644561;
        Tue, 30 Jun 2026 17:10:44 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a18917194csm2904868eaf.2.2026.06.30.17.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:10:43 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2 00/18] iomap: convert to in-iter iomap_next() model 
Date: Tue, 30 Jun 2026 17:09:15 -0700
Message-ID: <20260701000949.1666714-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series implements a suggestion by Christoph for finishing the conversion
of iomap to an iterator model. This revives Matthew's previous RFC [1], which
had the same intention.

This series has no functional changes intended. Patch 1 introduces the new
->iomap_next() interface, and the rest is a mechanical conversion to the new
api. The patches are broken down as:

1) Patch 1: adds ->iomap_next() and an iomap_process() inline helper that
filesystems can use by passing in their direct begin/end helper functions

2) Patches 2 to 15: converts each filesystem to ->iomap_next()

3) Patch 16: Removes the legacy ->iomap_begin()/->iomap_end() path

4) Patch 17: Passes iomap_next_fn directly instead of struct iomap_ops

5) Patch 18: Updates the iomap documentation to match.

If needed, performance-critical callers can later inline the iteration into
the caller and avoid the indirect iomap_next_fn call on hot paths.

This series is submitted against Christian's vfs iomap tree, and is based
on top of the current head of his tree (commit f2727952b21d1).

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20200728173216.7184-1-willy@infradead.org/T/#u

Changelog
---------
v1: https://lore.kernel.org/linux-fsdevel/20260625024723.1611000-1-joannelkoong@gmail.com/
v1 -> v2:
* Implement conversion for all callers

Joanne Koong (18):
  iomap: add ->iomap_next() and iomap_process() helper
  xfs: convert iomap ops to ->iomap_next()
  btrfs: convert iomap ops to ->iomap_next()
  ntfs3: convert iomap ops to ->iomap_next()
  ntfs: convert iomap ops to ->iomap_next()
  ext4: convert iomap ops to ->iomap_next()
  erofs: convert iomap ops to ->iomap_next()
  zonefs: convert iomap ops to ->iomap_next()
  ext2: convert iomap ops to ->iomap_next()
  block: convert iomap ops to ->iomap_next()
  f2fs: convert iomap ops to ->iomap_next()
  gfs2: convert iomap ops to ->iomap_next()
  hpfs: convert iomap ops to ->iomap_next()
  fuse: convert iomap ops to ->iomap_next()
  exfat: convert iomap ops to ->iomap_next()
  iomap: remove ->iomap_begin()/->iomap_end() legacy path
  iomap: pass iomap_next_fn directly instead of struct iomap_ops
  Documentation: iomap: update docs to reflect iomap_next model

 Documentation/filesystems/iomap/design.rst    | 115 ++++++++++-----
 .../filesystems/iomap/operations.rst          |  60 ++++----
 Documentation/filesystems/iomap/porting.rst   |  22 ++-
 block/fops.c                                  |  14 +-
 fs/btrfs/direct-io.c                          |  14 +-
 fs/dax.c                                      |  47 ++++---
 fs/erofs/data.c                               |  30 ++--
 fs/erofs/internal.h                           |   3 +-
 fs/erofs/zmap.c                               |   9 +-
 fs/exfat/file.c                               |  18 +--
 fs/exfat/inode.c                              |   6 +-
 fs/exfat/iomap.c                              |  20 +--
 fs/exfat/iomap.h                              |   6 +-
 fs/ext2/ext2.h                                |   3 +-
 fs/ext2/file.c                                |   4 +-
 fs/ext2/inode.c                               |  12 +-
 fs/ext4/ext4.h                                |   6 +-
 fs/ext4/extents.c                             |  12 +-
 fs/ext4/file.c                                |  14 +-
 fs/ext4/inode.c                               |  23 +--
 fs/f2fs/data.c                                |   9 +-
 fs/f2fs/f2fs.h                                |   3 +-
 fs/f2fs/file.c                                |   4 +-
 fs/fuse/dax.c                                 |  16 ++-
 fs/fuse/file.c                                |  14 +-
 fs/fuse/virtio_fs.c                           |   2 +-
 fs/gfs2/aops.c                                |   6 +-
 fs/gfs2/bmap.c                                |  12 +-
 fs/gfs2/bmap.h                                |   3 +-
 fs/gfs2/file.c                                |   6 +-
 fs/gfs2/inode.c                               |   6 +-
 fs/hpfs/file.c                                |  10 +-
 fs/internal.h                                 |   1 -
 fs/iomap/buffered-io.c                        |  38 ++---
 fs/iomap/direct-io.c                          |   8 +-
 fs/iomap/fiemap.c                             |   8 +-
 fs/iomap/iter.c                               |  88 +++++++-----
 fs/iomap/seek.c                               |   8 +-
 fs/iomap/swapfile.c                           |   4 +-
 fs/ntfs/aops.c                                |   6 +-
 fs/ntfs/file.c                                |  24 ++--
 fs/ntfs/inode.c                               |   2 +-
 fs/ntfs/iomap.c                               |  58 +++++---
 fs/ntfs/iomap.h                               |  15 +-
 fs/ntfs3/file.c                               |  16 +--
 fs/ntfs3/inode.c                              |  16 ++-
 fs/ntfs3/ntfs_fs.h                            |   3 +-
 fs/remap_range.c                              |   6 +-
 fs/xfs/xfs_aops.c                             |   8 +-
 fs/xfs/xfs_file.c                             |  44 +++---
 fs/xfs/xfs_iomap.c                            | 105 ++++++++++----
 fs/xfs/xfs_iomap.h                            |  24 ++--
 fs/xfs/xfs_iops.c                             |   4 +-
 fs/xfs/xfs_reflink.c                          |   6 +-
 fs/zonefs/file.c                              |  32 +++--
 include/linux/dax.h                           |  18 ++-
 include/linux/fs.h                            |   7 +-
 include/linux/iomap.h                         | 131 ++++++++++++------
 58 files changed, 730 insertions(+), 479 deletions(-)

-- 
2.52.0

