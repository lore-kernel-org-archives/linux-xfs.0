Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976B62B9AF
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168534; cv=none; b=qI/7jBxsU2aznvHLELpZaUydYMToUgfVXz0loTvkeHtN36v/12kwiEeauWFkaCvBXgp9uoLDEl2Bwfi1ELsc6Ubm+hGuXEJXc7bondZLtDpZfwYjGXKQ83j4l4HI8UBRQwEhT70kXTQjG/B5STLgayHy9fCCMu9zjPRpO4ndE3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168534; c=relaxed/simple;
	bh=ByTKF1VzTvv5a0CLQurna7KzVG7mWrycdZxRk8eqgm0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KwOeThrum14UKHsszummyTbTjFEsvXsmmix4HcR6nY292+G5QzqbMZbj2Ip7euXr9D3HI+63B/j5J2KifMksGvsyKVqxMsbReTMe/KVf/35G3gDnNIvgo3B6Zs+IRiVuMV/pYZKXwpT3kZSQJx3PReUMlV4amHO5PVXDY2Kbg8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WOWDJu+h; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WOWDJu+h"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e834159f40so21419725ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168532; x=1714773332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g5JkCn2JNjSEuLyxpWsrFQ+7LJqSJuXTjikZchfkgiY=;
        b=WOWDJu+hm3zFjGYA2wXVnGtiAEDYrJ2QhMdrXGxVO08JDvEN/3spM2Uxx0a83DbNtB
         O/5wXKFtS5CUukAvZK8CPj11TXCRgC2LBvNmvw42LrtDd4fJHg1MjXAnZ5+dYz5oLvUH
         73z+IodMcQfASdswn28zrqlUpiYrjzUR4OMFJ+MZqChX0cFmg8LJkT2RA+DeyHQuin3c
         qoNyZH8wSYbbyoyRGrxqCO2jROL9zM3QC6cVnzqP6uUVeYGqSMIdEh5ZKGGawGy8QuI0
         tBIkbMCsGP8BM3Zsa31eDjBhOdoDYWZ/mG5DBjpqVBm2AKp81vqY8+jv0ZLpNggrv52F
         95QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168532; x=1714773332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g5JkCn2JNjSEuLyxpWsrFQ+7LJqSJuXTjikZchfkgiY=;
        b=qj/RnDtjcr+pKsT4jNBc0EuGdItFJ7Z+8CSHg0q3Ad8+ceLt6Bq9s/Bfn5B9ZdLMvz
         9QYvPOihftSJhRViFFvIoepk3GBPkJfb9g0IXOuCVNLLyVmn+i3FOQuhlySL69w3ZUuo
         lGpL8hmWYdBBDhShf0SnjZYOoo9O7CRIOm2eizkdkKdsifX2h3+miTTx7mdi4WxxDsQE
         iRCTAf1ZcnJZcs2Okv/Lw90isxZTsCkcDw/R0rRjcWvsOy3g4TQJb4wOAanMcx3Mb+RS
         iX98gkRXY6kOgXuuSIyx1430YU/HpwE/yE6TP3AsoKvVPjHTIGs6JeocHR39/N44kxMq
         mV7A==
X-Gm-Message-State: AOJu0Yx43v8AxS3BEHE1MMMQcEaxKXZ068Ymae1ozUcNxB2082tpIgx3
	4YJp2EoEhgPoYmV6R+a22GatfXC5VzxzLCiO8wn+jid7OAWA1GVAxfJGz/7P
X-Google-Smtp-Source: AGHT+IEGTLWdppq8aZmmR9W1zYT+nh6QBHZP6aS6t5+qSZ9ufp4OzsF8O+JwOCirHRPNe2Z3vIIcBQ==
X-Received: by 2002:a17:902:da88:b0:1e5:556:60e2 with SMTP id j8-20020a170902da8800b001e5055660e2mr4497674plx.5.1714168532573;
        Fri, 26 Apr 2024 14:55:32 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:55:32 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 00/24] more backport proposals for linux-6.1.y
Date: Fri, 26 Apr 2024 14:54:47 -0700
Message-ID: <20240426215512.2673806-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi again,

These have been tested on 10 configs x 30 runs of the auto group. No
regressions were seen.

- Leah

Darrick J. Wong (8):
  xfs: fix incorrect error-out in xfs_remove
  xfs: invalidate block device page cache during unmount
  xfs: attach dquots to inode before reading data/cow fork mappings
  xfs: hoist refcount record merge predicates
  xfs: estimate post-merge refcounts correctly
  xfs: invalidate xfs_bufs when allocating cow extents
  xfs: allow inode inactivation during a ro mount log recovery
  xfs: fix log recovery when unknown rocompat bits are set

Dave Chinner (10):
  xfs: write page faults in iomap are not buffered writes
  xfs: punching delalloc extents on write failure is racy
  xfs: use byte ranges for write cleanup ranges
  xfs,iomap: move delalloc punching to iomap
  iomap: buffered write failure should not truncate the page cache
  xfs: xfs_bmap_punch_delalloc_range() should take a byte range
  iomap: write iomap validity checks
  xfs: use iomap_valid method to detect stale cached iomaps
  xfs: drop write error injection is unfixable, remove it
  xfs: fix off-by-one-block in xfs_discard_folio()

Eric Sandeen (1):
  xfs: short circuit xfs_growfs_data_private() if delta is zero

Guo Xuenan (2):
  xfs: wait iclog complete before tearing down AIL
  xfs: fix super block buf log item UAF during force shutdown

Hironori Shiina (1):
  xfs: get root inode correctly at bulkstat

Long Li (2):
  xfs: fix sb write verify for lazysbcount
  xfs: fix incorrect i_nlink caused by inode racing

 fs/iomap/buffered-io.c       | 254 ++++++++++++++++++++++++++++++++++-
 fs/iomap/iter.c              |  19 ++-
 fs/xfs/libxfs/xfs_bmap.c     |   8 +-
 fs/xfs/libxfs/xfs_errortag.h |  12 +-
 fs/xfs/libxfs/xfs_refcount.c | 146 +++++++++++++++++---
 fs/xfs/libxfs/xfs_sb.c       |   7 +-
 fs/xfs/xfs_aops.c            |  37 ++---
 fs/xfs/xfs_bmap_util.c       |  10 +-
 fs/xfs/xfs_bmap_util.h       |   2 +-
 fs/xfs/xfs_buf.c             |   1 +
 fs/xfs/xfs_buf_item.c        |   2 +
 fs/xfs/xfs_error.c           |  27 +++-
 fs/xfs/xfs_file.c            |   2 +-
 fs/xfs/xfs_fsops.c           |   4 +
 fs/xfs/xfs_icache.c          |   6 +
 fs/xfs/xfs_inode.c           |  16 ++-
 fs/xfs/xfs_ioctl.c           |   4 +-
 fs/xfs/xfs_iomap.c           | 177 ++++++++++++++----------
 fs/xfs/xfs_iomap.h           |   6 +-
 fs/xfs/xfs_log.c             |  53 ++++----
 fs/xfs/xfs_mount.c           |  15 +++
 fs/xfs/xfs_pnfs.c            |   6 +-
 include/linux/iomap.h        |  47 +++++--
 23 files changed, 683 insertions(+), 178 deletions(-)

-- 
2.44.0.769.g3c40516874-goog

