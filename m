Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8692E419;
	Tue, 24 Sep 2024 18:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203140; cv=none; b=L01kL71rI32ep5i0pIlriLvLsPFvr0jwWS11D6DKUKz97nFGWwKg5xIL2VwOJbsHy4RUP+zqWHpK5Agiz29VjjQvtVYnvFzO8hRizEIMi5vdkrfITlMNZwmHCN85KZB4nGDem46MkOS0DRQVYcLo131m52UZvOVTRQZSaF4iRZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203140; c=relaxed/simple;
	bh=x4TVpbg5stKTq34VK50t+YsOs37tam9qBb52KOMB0ik=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LcUQNBtUxdXvfsUYgJLB2m2InpiMVbLIA6728AVkQ3OpnlBdIS2FPRwJQE1guUeftMGMI8HEqsmwnsl9h+Ye/1FqnPRxH0vSnhRNvo4XnvfMEVuIsxmpwLkVrS20qpw2TKUVgP/7JIkc5MIQ6FaAIxMF5bI9T84NuuZJ8IIwN14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OTe+H8xf; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OTe+H8xf"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2d8881850d9so4780949a91.3;
        Tue, 24 Sep 2024 11:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203138; x=1727807938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T1DmOd0SHbIv2CnlsV5YM2ubopx1fW60N5aWJQ955I8=;
        b=OTe+H8xfRmer9rNK5qHVuYjePqeePn5owubFAl5AEtNMXCFYfZmThlS57VJ68iX972
         Z4MY20XwNOi+L6vOEvOc3vFjfGexPZ78gNAQlODFuvCZQdfaJltNtatC9ZKfji/2LxCz
         QLwzmsG6Vblkz2po69Qq18Uqe9xQAyWbiCipXPwT7hde7Z8oTxBv5AeOxlISOEW5lwVZ
         XO5gQZdbXo2LAuY7KJbgqINmYoXMS8prNU31iOaEVHPP9pcfjpvsBVjMXVgXTSpVFQwt
         +b/bXMBYrjKpWS0jFTLKm0fa0YGyvZY8f4epxrGBqTT2/ZrP1XEcMyHJAPkvFanqakFp
         74jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203138; x=1727807938;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T1DmOd0SHbIv2CnlsV5YM2ubopx1fW60N5aWJQ955I8=;
        b=MesSw1/WqQ5v8JPnNOoCf2jdIYw5ADq8SSYFMHt+2B8dhVApvBHiU6RN1LTctRfzrw
         bANmUJP6kU9Aihrb6mhS9mb5OdU9am+/GokZGo1C9gaUqMkS2FJfXcc+1pmwTe44HR/Q
         H5B1T2+T2pGVgWmgfXgK+nZEdNO1yIonAwvOL6jfTqI/7meFxe7q/ixTvWl7so+SAkcA
         SDOXhAgT8GIq6sQnJVEVUGieiYL+3VBH7V7+3zz+IoPHd9RhU8g6tfvgSW3KkHAHO6gS
         Q/InzQqUCbZOGA1OWN7yt94/aparqTE1MrNIfXwyOyvqmjnGQrd+vBqu1D0tGMNVrhfy
         GWiA==
X-Gm-Message-State: AOJu0YyWTvuU+iRtz/MwOgE+eG8Dw/sW9DXFZ0hnB09BF3MJlh9oKEZp
	xuqjlJ5B9NyRDONtzdhLlJ91CXAMBey7EJ+4rd45Wf66PyedTuN1irfvVw==
X-Google-Smtp-Source: AGHT+IH/mRTR2gWLSC2aHjTcG5XHKNnekvoQKfZ/BqEfwa7PaXowKnu3rVAgd1ZQSuFKYKw1WsaO5A==
X-Received: by 2002:a17:90b:350a:b0:2dd:4f6b:638d with SMTP id 98e67ed59e1d1-2e06ae7763fmr98864a91.17.1727203137649;
        Tue, 24 Sep 2024 11:38:57 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:38:57 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 00/26] xfs backports to catch 6.1.y up to 6.6
Date: Tue, 24 Sep 2024 11:38:25 -0700
Message-ID: <20240924183851.1901667-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello again,

Here is the next set of XFS backports, this set is for 6.1.y and I will
be following up with a set for 5.15.y later. There were some good
suggestions made at LSF to survey test coverage to cut back on
testing but I've been a bit swamped and a backport set was overdue.
So for this set, I have run the auto group 3 x 8 configs with no
regressions seen. Let me know if you spot any issues.

This set has already been ack'd on the XFS list.

Thanks,
Leah

https://lkml.iu.edu/hypermail/linux/kernel/2212.0/04860.html
52f31ed22821
[1/1] xfs: dquot shrinker doesn't check for XFS_DQFLAG_FREEING

https://lore.kernel.org/linux-xfs/ef8a958d-741f-5bfd-7b2f-db65bf6dc3ac@huawei.com/
4da112513c01
[1/1] xfs: Fix deadlock on xfs_inodegc_worker

https://www.spinics.net/lists/linux-xfs/msg68547.html
601a27ea09a3
[1/1] xfs: fix extent busy updating

https://www.spinics.net/lists/linux-xfs/msg67254.html
c85007e2e394
[1/1] xfs: don't use BMBT btree split workers for IO completion

fixes from start of the series
https://lore.kernel.org/linux-xfs/20230209221825.3722244-1-david@fromorbit.com/
[00/42] xfs: per-ag centric allocation alogrithms

1dd0510f6d4b
[01/42] xfs: fix low space alloc deadlock

f08f984c63e9
[02/42] xfs: prefer free inodes at ENOSPC over chunk allocation

d5753847b216
[03/42] xfs: block reservation too large for minleft allocation

https://lore.kernel.org/linux-xfs/Y+Z7TZ9o+KgXLcV8@magnolia/
60b730a40c43
[1/1] xfs: fix uninitialized variable access

https://lore.kernel.org/linux-xfs/20230228051250.1238353-1-david@fromorbit.com/
0c7273e494dd
[1/1] xfs: quotacheck failure can race with background inode inactivation

https://lore.kernel.org/linux-xfs/20230412024907.GP360889@frogsfrogsfrogs/
8ee81ed581ff
[1/1] xfs: fix BUG_ON in xfs_getbmap()

https://www.spinics.net/lists/linux-xfs/msg71062.html
[0/4] xfs: bug fixes for 6.4-rc1

[1/4] xfs: don't unconditionally null args->pag in xfs_bmap_btalloc_at_eof
    skip, fix for a commit from 6.3

8e698ee72c4e
[2/4] xfs: set bnobt/cntbt numrecs correctly when formatting new AGs

[3/4] xfs: flush dirty data and drain directios before scrubbing cow fork
    skip, scrub

[4/4] xfs: don't allocate into the data fork for an unshare request
    skip, more of an optimization than a fix

1bba82fe1afa
[5/4] xfs: fix negative array access in xfs_getbmap
  (fix of 8ee81ed)

https://lore.kernel.org/linux-xfs/20230517000449.3997582-1-david@fromorbit.com/
[0/4] xfs: bug fixes for 6.4-rcX

89a4bf0dc385
[1/4] xfs: buffer pins need to hold a buffer reference

[2/4] xfs: restore allocation trylock iteration
  skip, for issue introduced in 6.3

cb042117488d
[3/4] xfs: defered work could create precommits
  (dependency for patch 4)

82842fee6e59
[4/4] xfs: fix AGF vs inode cluster buffer deadlock

https://lore.kernel.org/linux-xfs/20240612225148.3989713-1-david@fromorbit.com/
348a1983cf4c
(fix for 82842fee6e5)
[1/1] xfs: fix unlink vs cluster buffer instantiation race

https://lore.kernel.org/linux-xfs/20230530001928.2967218-1-david@fromorbit.com/
d4d12c02b
[1/1] xfs: collect errors from inodegc for unlinked inode recovery

https://lore.kernel.org/linux-xfs/20230524121041.GA4128075@ceph-admin/
c3b880acadc9
[1/1] xfs: fix ag count overflow during growfs

4b827b3f305d
[1/1] xfs: remove WARN when dquot cache insertion fails
  requested on list to reduce bot noise

https://www.spinics.net/lists/linux-xfs/msg73214.html
5cf32f63b0f4
[1/2] xfs: fix the calculation for "end" and "length"

[2/2] introduces new feature, skipping

https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com/
3c90c01e4934
[1/1] xfs: correct calculation for agend and blockcount
  (fixes 5cf32)

https://lore.kernel.org/all/20230901160020.GT28186@frogsfrogsfrogs/
68b957f64fca
[1/1] xfs: load uncached unlinked inodes into memory on demand

https://www.spinics.net/lists/linux-xfs/msg74960.html
[0/3] xfs: reload entire iunlink lists

f12b96683d69
[1/3] xfs: use i_prev_unlinked to distinguish inodes that are not on the unlinked list

83771c50e42b
[2/3] xfs: reload entire unlinked bucket lists
  (dependency of 49813a21ed)

49813a21ed57
[3/3] xfs: make inode unlinked bucket recovery work with quotacheck
  (dependency for 537c013)

https://lore.kernel.org/all/169565629026.1982077.12646061547002741492.stgit@frogsfrogsfrogs/
537c013b140d
[1/1] xfs: fix reloading entire unlinked bucket lists
  (fix of 68b957f64fca)


Darrick J. Wong (8):
  xfs: fix uninitialized variable access
  xfs: load uncached unlinked inodes into memory on demand
  xfs: fix negative array access in xfs_getbmap
  xfs: use i_prev_unlinked to distinguish inodes that are not on the
    unlinked list
  xfs: reload entire unlinked bucket lists
  xfs: make inode unlinked bucket recovery work with quotacheck
  xfs: fix reloading entire unlinked bucket lists
  xfs: set bnobt/cntbt numrecs correctly when formatting new AGs

Dave Chinner (12):
  xfs: dquot shrinker doesn't check for XFS_DQFLAG_FREEING
  xfs: don't use BMBT btree split workers for IO completion
  xfs: fix low space alloc deadlock
  xfs: prefer free inodes at ENOSPC over chunk allocation
  xfs: block reservation too large for minleft allocation
  xfs: quotacheck failure can race with background inode inactivation
  xfs: buffer pins need to hold a buffer reference
  xfs: defered work could create precommits
  xfs: fix AGF vs inode cluster buffer deadlock
  xfs: collect errors from inodegc for unlinked inode recovery
  xfs: remove WARN when dquot cache insertion fails
  xfs: fix unlink vs cluster buffer instantiation race

Long Li (1):
  xfs: fix ag count overflow during growfs

Shiyang Ruan (2):
  xfs: fix the calculation for "end" and "length"
  xfs: correct calculation for agend and blockcount

Wengang Wang (1):
  xfs: fix extent busy updating

Wu Guanghao (1):
  xfs: Fix deadlock on xfs_inodegc_worker

Ye Bin (1):
  xfs: fix BUG_ON in xfs_getbmap()

 fs/xfs/libxfs/xfs_ag.c          |  19 ++-
 fs/xfs/libxfs/xfs_alloc.c       |  69 +++++++--
 fs/xfs/libxfs/xfs_bmap.c        |  16 +-
 fs/xfs/libxfs/xfs_bmap.h        |   2 +
 fs/xfs/libxfs/xfs_bmap_btree.c  |  19 ++-
 fs/xfs/libxfs/xfs_btree.c       |  18 ++-
 fs/xfs/libxfs/xfs_fs.h          |   2 +
 fs/xfs/libxfs/xfs_ialloc.c      |  17 +++
 fs/xfs/libxfs/xfs_log_format.h  |   9 +-
 fs/xfs/libxfs/xfs_trans_inode.c | 113 +-------------
 fs/xfs/xfs_attr_inactive.c      |   1 -
 fs/xfs/xfs_bmap_util.c          |  18 +--
 fs/xfs/xfs_buf_item.c           |  88 ++++++++---
 fs/xfs/xfs_dquot.c              |   1 -
 fs/xfs/xfs_export.c             |  14 ++
 fs/xfs/xfs_extent_busy.c        |   1 +
 fs/xfs/xfs_fsmap.c              |   1 +
 fs/xfs/xfs_fsops.c              |  13 +-
 fs/xfs/xfs_icache.c             |  58 +++++--
 fs/xfs/xfs_icache.h             |   4 +-
 fs/xfs/xfs_inode.c              | 260 ++++++++++++++++++++++++++++----
 fs/xfs/xfs_inode.h              |  36 ++++-
 fs/xfs/xfs_inode_item.c         | 149 ++++++++++++++++++
 fs/xfs/xfs_inode_item.h         |   1 +
 fs/xfs/xfs_itable.c             |  11 ++
 fs/xfs/xfs_log_recover.c        |  19 ++-
 fs/xfs/xfs_mount.h              |  11 +-
 fs/xfs/xfs_notify_failure.c     |  15 +-
 fs/xfs/xfs_qm.c                 |  72 ++++++---
 fs/xfs/xfs_super.c              |   1 +
 fs/xfs/xfs_trace.h              |  46 ++++++
 fs/xfs/xfs_trans.c              |   9 +-
 32 files changed, 841 insertions(+), 272 deletions(-)

-- 
2.46.0.792.g87dc391469-goog

