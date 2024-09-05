Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C769D1CFBC
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560514; cv=none; b=uTr5ePHpujla5hOESTJMYe77YW8v1p51rwjLaLzwlM9GVqTcsMar4gqBk9tK6bC6iRDmUu8HK5YBPP+nJXkXyEJW/bPkCzsBdifxSZ+8GxNszr0UHm87d9BJ1U0H1nH+2AyX5nY45MvdMVLKiSlXd2X3gLh9JBolYwZvQEOIvew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560514; c=relaxed/simple;
	bh=J55Rx5eZcjTP3QMIjrdMzC49R0JZviNJeAfoRyPwlRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=De5wx/TproMwTM3bJGeWp0wHmeF460kFFEUH+PrmORmS7wYW3fl4jvjy3r8R5394wyPuu6r4HWFxiwgWil7xvleKqNkqaJShJtOht9EQHm4CazUYrr2222Bkdynqz/PosdPbscY3FCAkNHWfnQxTh7N5lg48tgn6X7I+OQht7p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FGlwLz3G; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FGlwLz3G"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-205659dc63aso11985925ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560512; x=1726165312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SAEgxCEs2Cxm3YOJZ8VvrHVenV0GteqrvVz8xZIOIwk=;
        b=FGlwLz3GhgbLnGh+ULv3R3tu5XBZrD15GbcmlkwTt2cWTH3gf40kBthMZpCoOLVZQK
         KBFcJw7p73V1n1x4TNzxRfVDfAI2RuMDRPS5YKl/R7WWFyyHqwZqXVHV7vGcqkqy4Wfc
         P+1d7r6cw+SW5pUeEcJZ4N1CFnqsM0Ax97gmxF0yioBtx0KjVJiQbuMma9wvPN3jac5j
         RUdZKhBpz74eZq1VHdpPHfRM1OwDS5GK6wzwBVRB6nMkuE5wQQrZW3b+O2qUbzUpDr2+
         1e58ezN8jx7rSbSiF/E5poQpWFFwdmZAUspA0wHrJhPyFDULlVw5ZocKo9s//OKiSPKR
         ZWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560512; x=1726165312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SAEgxCEs2Cxm3YOJZ8VvrHVenV0GteqrvVz8xZIOIwk=;
        b=xF41iYAT1p99W28Z5O94oeQlcZnoljtAB6tjWMGUyTjqCy6Wy9e/3PlGQ+hQpV3/MR
         pVWUyQSmuU+Tv2ebHMa3+wxv5B5Hiye0AsnHjqNB6Vqph0bYj4ByOwyrFV894uX/EPC0
         apMQ19FugbEXHHjy2eyjX29iKGR40QAIiPPv+N4wz2ujkvJSA5eRXZE2loKlcNt4v93m
         LsLvvrozb+ldKO1JYzlOW3hZWLTq8wE8edLNyIl8DiP82pGlGgWFO7S2CK4W6SoYYqLv
         s+JPxb9mWXPXb4zueCykhaxmwZCK3WO1Sea6KjPrMbqIDNrGmU4gDYxmvx2DTp6TnrqO
         AgAg==
X-Gm-Message-State: AOJu0Yzx5Nh46rJJ0O5GZ6F8+OBMckflnmFzsXzoAuAeDJzza0+JyiyU
	LFs7W7nRKIpXZIuAAsDsbknA3P809ooVX/EReJpI5YETD8j43Ew+K1mguw==
X-Google-Smtp-Source: AGHT+IF8r45YAakZH7gvNa3yzhOecNmFzfFsXFDMbk3joXmxwd6Wybt1vHgAq9MEjE2CCyKakDXBfA==
X-Received: by 2002:a17:903:11cf:b0:202:3103:c250 with SMTP id d9443c01a7336-20547338beemr191124245ad.38.1725560511852;
        Thu, 05 Sep 2024 11:21:51 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:21:51 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 00/26] xfs backports to catch 6.1.y up to 6.6
Date: Thu,  5 Sep 2024 11:21:17 -0700
Message-ID: <20240905182144.2691920-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
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
2.46.0.598.g6f2099f65c-goog

