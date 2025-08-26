Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735AA2C327E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222851; cv=none; b=SrBolSKSptQ0JjJvVEDYqEFt9AlTrh0zVkdrqxf/ruLhrHBtHAjWk2+jfhHI++KW1KUPva19uVPnUU1UT9xKc7epCeQQ46ars71sdSIWFSTCbZLZE3ucpTALk2c5N4gcBgHzanvmriWkbLTGBSnJxN50/9KYqPlr7lMJI3EGMRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222851; c=relaxed/simple;
	bh=vHDpIlmRrKEsMC6hQOsoWSBV+q9fFoSkGH387M5hfEY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XeaNHaUQIuu8oXp42rc0Obj2QkSD7yUYRjgiMIihMb8F5VrUYTKAo0KXCHlpQ5a+uqJKIsgxOHdeEoqStjfddvBgJkVEdJn5agfCrEj1oInNOayEmDoRcqMHjsEO9WuLmuyEJwFBAN1FXTGItOkSxSUGo9l5XoV2VTt1c4dJl3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=woRvo9Ht; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="woRvo9Ht"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e96d8722c6eso1480450276.3
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222848; x=1756827648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=zMreGU+s+wwVcoeAi06UGUjf1LeI/F4g5bJZVVKKmnA=;
        b=woRvo9Hta4jWW23pzuqj6hwVnLgsOyq1rHHaQkUZH08Ut5DbbE6Qn5x6iQxTH39QY/
         9YaEPW2OHGLJvmPIlMMcLvhXgBsa60tLgE1cCDd3qVV+5RGldlPow8bmFOv1rIZ5GLv0
         6455ghKwSoeCvFXOXMs1Yh3b0TRdu2BAkTDO8qWdoIYAgIyQIunRMR4rCQ4HHMvgO2Jf
         rssPou0viPGu85ntiECJyquRgrzc1J2J42QQYGEsX7UIwu7tauO2LbT3vcrxsLgsw7K7
         /JrZFzb4Di+EpeTqf22ygpXp1VQeNskoBhcAALyXbRY1/HCBipKVNthHg7oyqVf464X8
         10og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222848; x=1756827648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zMreGU+s+wwVcoeAi06UGUjf1LeI/F4g5bJZVVKKmnA=;
        b=Uig8rOaH+9GMYyflckWoQS2G22cfOtMswyjw3onGsxLwJhF9OdYU7jnHoDqy/GqO5u
         CDVbi/vTS9BEc5fhpNorxm3cQmsihn36Ec6ryq9s9K2Mo5MVeSp1zgJfI9AHDXbbQw9q
         0KTDXBJaI2Aiofvn7TFkHhwYKOM9ZpsYeXNFtfGX/t0lP81lxCr9GDr7iw+kiEujXuBR
         DX36FcVj0UuDZXpQXJF3tRflIyCGF3PJef4hZMDvNBhDLPYqdHqiQzcj2JU4KziX881K
         J6tvI8XVi0Mm0V1iD/pG5G+YGme2oxFMsBR98yucgZ/FHeFaug3Qu3uT8tgvPtYZhv8H
         04sg==
X-Forwarded-Encrypted: i=1; AJvYcCX8zk9VZZRACXCQRbWVKF/wN9OZx4cQIcEpq+waaB5lStB7N1JoeO/5kyY0NwKhtG42up1h2pbSYEg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzit5IQJrUnoD5yIMKEvbDHvYJiAIiX9mYDYHH8yVL4yPleyLEX
	baWFB4sOcq5yIV8R2evoca5osS+X/CCcx3TWG57vMLnblDVsV5WCBFzMeNvTDCS1DWM=
X-Gm-Gg: ASbGncvzjgyWKKnIU+/f98TN/FWayEEShDRGKhT6CTuQaD/2oBw/3imSGzZ9G1sJNAf
	9WJeSMGQd2GRPbw/NvnxdOj/owwYw+Sufg8OGpbRrYwj9IeAzYAx3eTRZlXyyLiKBB7XJ+FWtXg
	S4QCp2Eu+zNtBxsFJwkVPfwZ7iFF4WYtWBJPZ+TzwjuxXwuSxzTW/J6P+cn9qFuI5j2wIw2826q
	FSd79JECy5FMgjMLRBxPoJVpW4OaY34+/a9tHcVea1/sVdGr7njKGSVQgPWvQ+iO53zbMsyi6FD
	r0A8hkV5SXGd/zLBDdoLc+ROe8iY7HIxKBDNfdxAiDqEmMH1YW8C9hvFC8o/TtSSG7ainAe8hlT
	+lnTsieSHBgrkgmegyHYP7cSy2cIIgAcsiUpI/ALH377pfdIplHnjDHUMQoyqYDlla+TIxA==
X-Google-Smtp-Source: AGHT+IGsVYuqRBvkdR7S92vGQPz2qGvqEOwVMV0wcO4JgtzB3RgwhEaAV+Oq4KYFgPRLTlJZcz4v2A==
X-Received: by 2002:a05:6902:188e:b0:e95:3ada:4d2 with SMTP id 3f1490d57ef6-e953ada05acmr11464034276.47.1756222845145;
        Tue, 26 Aug 2025 08:40:45 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e96ea63fab0sm169411276.8.2025.08.26.08.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:40:44 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 00/54] fs: rework inode reference counting
Date: Tue, 26 Aug 2025 11:39:00 -0400
Message-ID: <cover.1756222464.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1: https://lore.kernel.org/linux-fsdevel/cover.1755806649.git.josef@toxicpanda.com/

v1->v2:
- Fixed all the things that Christian pointed out.
- Re-ordered some of the patches to the front in case Christian wants to take
  those first.
- Added a new patch for reading the current i_count and propagated that
  everywhere.
- Fixed the cifs build breakage.
- Removed I_REFERENCED since it's no longer needed.
- Remove I_LRU_ISOLATING since it's no longer needed.
- Reworked the drop_nlink/clear_nlink part to simply remove the inode from the
  LRU in the unlink path, and made this its own patch to make the behavior
  change clear.
- NOTE: I'm re-running fstests on this now, there was a slight issue with
  removing the drop_nlink/clear_nlink patch and so I had to add the unlink/rmdir
  patch to resolve it. I assume everything will be fine but just an FYI.
- NOTE #2: I reordered stuff, and I did a rebase and rebuild at every step, but
  I noticed this morning I still missed an odd rebase artifact, so by all means
  validate I didn't make any silly mistakes on the in-between patches.

--- Original email ---

Hello,

This series is the first part of a larger body of work geared towards solving a
variety of scalability issues in the VFS.

We have historically had a variety of foot-guns related to inode freeing.  We
have I_WILL_FREE and I_FREEING flags that indicated when the inode was in the
different stages of being reclaimed.  This lead to confusion, and bugs in cases
where one was checked but the other wasn't.  Additionally, it's frankly
confusing to have both of these flags and to deal with them in practice.

However, this exists because we have an odd behavior with inodes, we allow them
to have a 0 reference count and still be usable. This again is a pretty unfun
footgun, because generally speaking we want reference counts to be meaningful.

The problem with the way we reference inodes is the final iput(). The majority
of file systems do their final truncate of a unlinked inode in their
->evict_inode() callback, which happens when the inode is actually being
evicted. This can be a long process for large inodes, and thus isn't safe to
happen in a variety of contexts. Btrfs, for example, has an entire delayed iput
infrastructure to make sure that we do not do the final iput() in a dangerous
context. We cannot expand the use of this reference count to all the places the
inode is used, because there are cases where we would need to iput() in an IRQ
context  (end folio writeback) or other unsafe context, which is not allowed.

To that end, resolve this by introducing a new i_obj_count reference count. This
will be used to control when we can actually free the inode. We then can use
this reference count in all the places where we may reference the inode. This
removes another huge footgun, having ways to access the inode itself without
having an actual reference to it. The writeback code is one of the main places
where we see this. Inodes end up on all sorts of lists here without a proper
reference count. This allows us to protect the inode from being freed by giving
this an other code mechanisms to protect their access to the inode.

With this we can separate the concept of the inode being usable, and the inode
being freed.  The next part of the patch series is to stop allowing for inodes
to have an i_count of 0 and still be viable.  This comes with some warts. The
biggest wart is now if we choose to cache inodes in the LRU list we have to
remove the inode from the LRU list if we access it once it's on the LRU list.
This will result in more contention on the lru list lock, but in practice we
rarely have inodes that do not have a dentry, and if we do that inode is not
long for this world.

With not allowing inodes to hit a refcount of 0, we can take advantage of that
common pattern of using refcount_inc_not_zero() in all of the lockless places
where we do inode lookup in cache.  From there we can change all the users who
check I_WILL_FREE or I_FREEING to simply check the i_count. If it is 0 then they
aren't allowed to do their work, othrwise they can proceed as normal.

With all of that in place we can finally remove these two flags.

This is a large series, but it is mostly mechanical. I've kept the patches very
small, to make it easy to review and logic about each change. I have run this
through fstests for btrfs and ext4, xfs is currently going. I wanted to get this
out for review to make sure this big design changes are reasonable to everybody.

The series is based on vfs/vfs.all branch, which is based on 6.9-rc1. Thanks,

Josef

Josef Bacik (54):
  fs: make the i_state flags an enum
  fs: add an icount_read helper
  fs: rework iput logic
  fs: add an i_obj_count refcount to the inode
  fs: hold an i_obj_count reference in wait_sb_inodes
  fs: hold an i_obj_count reference for the i_wb_list
  fs: hold an i_obj_count reference for the i_io_list
  fs: hold an i_obj_count reference in writeback_sb_inodes
  fs: hold an i_obj_count reference while on the hashtable
  fs: hold an i_obj_count reference while on the LRU list
  fs: hold an i_obj_count reference while on the sb inode list
  fs: stop accessing ->i_count directly in f2fs and gfs2
  fs: hold an i_obj_count when we have an i_count reference
  fs: add an I_LRU flag to the inode
  fs: maintain a list of pinned inodes
  fs: delete the inode from the LRU list on lookup
  fs: remove the inode from the LRU list on unlink/rmdir
  fs: change evict_inodes to use iput instead of evict directly
  fs: hold a full ref while the inode is on a LRU
  fs: disallow 0 reference count inodes
  fs: make evict_inodes add to the dispose list under the i_lock
  fs: convert i_count to refcount_t
  fs: use refcount_inc_not_zero in igrab
  fs: use inode_tryget in find_inode*
  fs: update find_inode_*rcu to check the i_count count
  fs: use igrab in insert_inode_locked
  fs: remove I_WILL_FREE|I_FREEING check from __inode_add_lru
  fs: remove I_WILL_FREE|I_FREEING check in inode_pin_lru_isolating
  fs: use inode_tryget in evict_inodes
  fs: change evict_dentries_for_decrypted_inodes to use refcount
  block: use igrab in sync_bdevs
  bcachefs: use the refcount instead of I_WILL_FREE|I_FREEING
  btrfs: don't check I_WILL_FREE|I_FREEING
  fs: use igrab in drop_pagecache_sb
  fs: stop checking I_FREEING in d_find_alias_rcu
  ext4: stop checking I_WILL_FREE|IFREEING in ext4_check_map_extents_env
  fs: remove I_WILL_FREE|I_FREEING from fs-writeback.c
  gfs2: remove I_WILL_FREE|I_FREEING usage
  fs: remove I_WILL_FREE|I_FREEING check from dquot.c
  notify: remove I_WILL_FREE|I_FREEING checks in fsnotify_unmount_inodes
  xfs: remove I_FREEING check
  landlock: remove I_FREEING|I_WILL_FREE check
  fs: change inode_is_dirtytime_only to use refcount
  btrfs: remove references to I_FREEING
  ext4: remove reference to I_FREEING in inode.c
  ext4: remove reference to I_FREEING in orphan.c
  pnfs: use i_count refcount to determine if the inode is going away
  fs: remove some spurious I_FREEING references in inode.c
  xfs: remove reference to I_FREEING|I_WILL_FREE
  ocfs2: do not set I_WILL_FREE
  fs: remove I_FREEING|I_WILL_FREE
  fs: remove I_REFERENCED
  fs: remove I_LRU_ISOLATING flag
  fs: add documentation explaining the reference count rules for inodes

 Documentation/filesystems/vfs.rst        |  86 +++++
 arch/powerpc/platforms/cell/spufs/file.c |   2 +-
 block/bdev.c                             |   8 +-
 fs/bcachefs/fs.c                         |   3 +-
 fs/btrfs/inode.c                         |  11 +-
 fs/ceph/mds_client.c                     |   2 +-
 fs/crypto/keyring.c                      |   7 +-
 fs/dcache.c                              |   4 +-
 fs/drop_caches.c                         |  11 +-
 fs/ext4/ialloc.c                         |   4 +-
 fs/ext4/inode.c                          |   8 +-
 fs/ext4/orphan.c                         |   6 +-
 fs/f2fs/super.c                          |   4 +-
 fs/fs-writeback.c                        | 105 ++++--
 fs/gfs2/ops_fstype.c                     |  17 +-
 fs/hpfs/inode.c                          |   2 +-
 fs/inode.c                               | 422 ++++++++++++++---------
 fs/internal.h                            |   1 +
 fs/namei.c                               |  30 +-
 fs/nfs/inode.c                           |   4 +-
 fs/nfs/pnfs.c                            |   2 +-
 fs/notify/fsnotify.c                     |  26 +-
 fs/ocfs2/inode.c                         |   4 -
 fs/quota/dquot.c                         |   6 +-
 fs/smb/client/inode.c                    |   2 +-
 fs/super.c                               |   3 +
 fs/ubifs/super.c                         |   2 +-
 fs/xfs/scrub/common.c                    |   3 +-
 fs/xfs/xfs_bmap_util.c                   |   2 +-
 fs/xfs/xfs_inode.c                       |   2 +-
 fs/xfs/xfs_trace.h                       |   2 +-
 include/linux/fs.h                       | 285 ++++++++-------
 include/trace/events/filelock.h          |   2 +-
 include/trace/events/writeback.h         |   6 +-
 security/landlock/fs.c                   |  22 +-
 35 files changed, 684 insertions(+), 422 deletions(-)

-- 
2.49.0

